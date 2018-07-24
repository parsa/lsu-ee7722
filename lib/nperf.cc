#include <stdio.h>
#include <stdarg.h>
#include <math.h>
#include <string>
#include <map>
#include <list>
#include <vector>
#include <set>
#include <algorithm>
#include <string.h>
#include <assert.h>
#include "nperf.h"

#include <cuda.h>
#include <cupti.h>

#ifdef HAVE_BFD
#include <bfd.h>
static char* demangle(const char *m)
{
  char* const d = bfd_demangle(NULL,m,0);
  return d ? d : strdup(m);
}
#else
static char* demangle(const char *m) { return strdup(m); }
#endif

using namespace std;

#define CHECK_CUPTI_ERROR(err) \
        REPORT_CUPTI_ERROR(err)

#define REPORT_CUPTI_ERROR(err)                                               \
  if ( err != CUPTI_SUCCESS )                                                 \
    {                                                                         \
      const char *errstr;                                                     \
      cuptiGetResultString(err, &errstr);                                     \
      fprintf(stderr,"%s:%d: Error %s for CUPTI API call\n",                  \
              __FILE__,__LINE__,errstr);                                      \
      exit(1);                                                                \
    }

// Wrapper for CUPTI API calls.
//
#define CU( rval )                                                            \
  { const CUptiResult err = rval;                                             \
    REPORT_CUPTI_ERROR(err); }


// Error-check Wrapper for CUDA driver API calls.
//
#define CE(rv)                                                                \
 {                                                                            \
   const CUresult result = rv;                                                \
   const char* err_str = NULL;                                                \
   cuGetErrorString(result,&err_str);                                         \
   if ( result != CUDA_SUCCESS )                                              \
     {                                                                        \
      fprintf(stderr,"%s:%d: Error %s for driver API call\n",                 \
              __FILE__,__LINE__,err_str);                                     \
      exit(1);                                                                \
     }                                                                        \
 }

typedef CUpti_ActivityKernel2 Version_ActivityKernel;

class RT_Info;

static void
rt_info_handle_kernel(RT_Info *rt_info, Version_ActivityKernel *record);
static void rt_info_handle(RT_Info *rt_info, CUpti_Activity *record);

class RTI_Kernel_Info;

typedef list<RTI_Kernel_Info*> RTI_List;
const CUdevice device_null = -1;

class NPerf_Metric_Value {
public:
  NPerf_Metric_Value():status(NPerf_Status_Status_Unset),d(0){};
  NPerf_Metric_Value(NPerf_Status s):status(s),d(-int(s)){};
  NPerf_Status status;
  CUpti_MetricValueKind kind;
  CUpti_MetricValue metric_value;
  double d;
  int warps_per_block;
  int blocks, block_size;
  double value_per_warp_get()
  { return status == NPerf_Status_OK
      ? d / ( warps_per_block * blocks ) : 0; }
  double value_per_thread_get()
  { return status == NPerf_Status_OK
      ? d / ( block_size * blocks ) : 0; }
};

template<typename T> T
cupti_metric_get_attr(CUpti_MetricID metric_id, CUpti_MetricAttribute attr)
{
  T val;
  size_t val_sz = sizeof(T);
  CU( cuptiMetricGetAttribute( metric_id, attr, &val_sz, &val) );
  assert( val_sz == sizeof(T) ); // Won't catch most mistakes!
  return val;
}

#define DEFINE_METRIC_GET_ATTR(T,abbrev)                                      \
T cupti_metric_get_attr_##abbrev                                              \
(CUpti_MetricID metric_id, CUpti_MetricAttribute attr)                        \
{ return cupti_metric_get_attr<T>(metric_id,attr); }

DEFINE_METRIC_GET_ATTR(int64_t,i);
DEFINE_METRIC_GET_ATTR(double,d);
DEFINE_METRIC_GET_ATTR(CUpti_MetricValueKind,k);

class Met_Event_Info {
public:
  Met_Event_Info():value(0){};
  uint64_t value;
};

class Metric_Info {
public:
  string name;
  CUpti_MetricID met_id;
  CUpti_MetricValueKind kind;
};


class Metrics {
public:
  Metrics():eg_sets(NULL),eg_curr(NULL){};
  ~Metrics();
  map<string,Metric_Info> metric_info;
  CUpti_EventGroupSets *eg_sets;
  CUpti_EventGroupSet *eg_curr;
};

class Metrics_Data {
public:
  Metrics_Data(){ reset(); };
  void reset()
  {
    set_next = 0;
    set_rounds = 0;
    num_launches = 0;
    elapsed_time_ns = 0;
    values_rounds = 0;
    event_info.clear();
    event_info_live.clear();
  };

  void data_append(Metrics_Data *md)
    {
      assert( event_info.size() == md->event_info.size() );
      assert( values.size() == md->values.size() );
#define ADD_TO(m) m += md->m;
      ADD_TO(set_rounds);
      ADD_TO(num_launches);
      ADD_TO(elapsed_time_ns);
#undef ADD_TO
      for ( auto& elt : md->event_info )
        event_info[elt.first].value += elt.second.value;
    }
  int set_next;
  int set_rounds;
  int num_launches;
  int64_t elapsed_time_ns; // Total over all launches.

  // Each event group collected exactly set_rounds times.
  map<CUpti_EventID,Met_Event_Info> event_info;
  // set_next sets collected set_rounds+1 times, the others set_rounds times.
  map<CUpti_EventID,Met_Event_Info> event_info_live;

  // Linearized events and values. Populated on demand.
  int values_rounds; // Value of set_rounds the last time values updated.
  vector<CUpti_EventID> event_ids;
  vector<uint64_t> values;
};

//
// Per-Kernel Information
//
class RTI_Kernel_Info
{
public:
  RTI_Kernel_Info()
  {
    rti = NULL;
    func_name = NULL;
    inited = false;
    have_cupti_kernel_data = false;
    func_name_demangled = NULL;
    call_count = 0;
    elapsed_time_ns = 0;
    call_count_lite = 0;
    elapsed_time_lite_ns = 0;
    api_config_inited = false;
    api_config_change_warning_issued = false;
    api_block.x = 0;
    display = false;
    et_print_mult_txt = "ms";
  }
  RTI_Kernel_Info(RTI_Kernel_Info *ki)
    {
      *this = *ki;
    }

  ~RTI_Kernel_Info()
  {
    if ( func_name_demangled ) free( func_name_demangled );
  }

  void time_normalize()
  {
    if ( call_count_lite > 1 )
      {
        elapsed_time_lite_ns /= call_count_lite;
        call_count_lite = 1;
      }
    if ( call_count > 1 )
      {
        elapsed_time_ns /= call_count;
        call_count = 1;
      }
  }

  RT_Info *rti;
  const char *func_name;
  bool inited;
  bool have_cupti_kernel_data;
  char *func_name_demangled;
  Version_ActivityKernel cupti_kernel;

  bool display;  // Print information about this kernel.

  // Data collected using API hooks.
  bool api_config_inited, api_config_change_warning_issued;
  dim3 api_grid, api_block;

  // Data collected using Activity API.
  int call_count; // Number of kernel launches.
  int64_t elapsed_time_ns;
  int call_count_lite;          // Data collected when no events traced.
  int64_t elapsed_time_lite_ns;

  // Data collected from replay callbacks.
  int replay_num_launches;

  CUfunction cu_function;

public:

  void data_reset(RT_Info *rti);
  void data_append(RTI_Kernel_Info *k);

  // Members initialized at end of run when preparing report, applies
  // to any launch of the kernel.
  //
  int api_thread_count;         // Threads per launch.
  int api_block_size;           // Threads per block.
  int api_block_count;
  int api_warps_per_block;      // Rounded up.
  int api_blocks_per_mp;    // Rounded up, to reflect sampled mp.
  int warps_per_sm_per_launch;
  double api_blocks_per_mp_avg;    // Average.
  const char *et_print_mult_txt;

  Metrics_Data md;
};

typedef map<string,RTI_Kernel_Info*> RTI_Hash;
typedef map<CUfunction,RTI_Kernel_Info> CUF_Hash;

//
// Per Process Information
//
class RT_Info {
public:
  RT_Info(){
    cupti_inited = false;
    cupti_on = false;
    stop_tracing = false;
    event_tracing_user_on = true;
    context = NULL;
    dev = device_null;
    call_trace_count = 0;
    call_trace_end = 0;
    call_trace_pause_level = 0;
    fake_fh_next = NULL;
    event_callbacks_inited = false;
    event_tracing_active = false;
    device_data_collected = false;
    kernel_last = NULL;
    metrics_inited = false;
  };
  ~RT_Info(){
    for ( auto ki: kernel_info_store ) free(ki);
  }
  static int need_run_get_call_count;
  bool cupti_inited;      // True if CUPTI successfully initialized.
  bool cupti_on; // True if user wants CUPTI instrumentation. 
  bool event_callbacks_inited;
  bool stop_tracing;      // True if tracing was started unnecessarily.
  int call_trace_start, call_trace_count, call_trace_end;
  int call_trace_pause_level;
  CUpti_SubscriberHandle subscriber;
  CUfunction fake_fh_next;
  map<string,CUfunction> fake_fh_map;

  // Used to turn tracing on and off during a run.
  bool event_tracing_user_on;
  bool tracing_get() { return event_tracing_user_on; }
  bool tracing_set(bool setting){
    const bool rv = event_tracing_user_on;
    event_tracing_user_on = setting;
    return rv;
  }
  bool tracing_on(){ return tracing_set(true); }
  bool tracing_off(){ return tracing_set(false); }

  // Per-kernel information indexed by function handle, CUfunction.
  CUF_Hash kernel_info_fh;
  RTI_Hash kernel_info_name;
  map<uint32_t,CUfunction> corr_to_h;

  // The most recent kernel for which event has been collected.
  RTI_Kernel_Info *kernel_last;

  vector<RTI_Kernel_Info*> kernel_info_store;

  RTI_Kernel_Info *kernel_get(NPerf_Kernel_Data kd)
  {
    if ( kd.id == -1 ) return NULL;
    assert( kd.id < int(kernel_info_store.size()) );
    return kernel_info_store[kd.id];
  }
  RTI_Kernel_Info *kernel_get(const char *kernel_name)
  {
    if ( !kernel_name ) return kernel_last;
    return kernel_info_name[string(kernel_name)];
  }

  const char* kernel_last_name_get()
    {
      if ( !kernel_last ) return NULL;
      return kernel_last->func_name_demangled;
    }

  NPerf_Kernel_Data nperf_kernel_data_dup();
  void nperf_kernel_data_append(NPerf_Kernel_Data& kd);

  CUdevice dev;                 // Device on which info being collected.
  CUcontext context;            // Make sure that only one context used.

  // GPU Characteristics
  bool device_data_collected;
  int numMultiprocessors;
  double clock_freq_hz;
  static const int gpu_name_size = 80;
  char gpu_name[gpu_name_size+1];
  int wp_lg;
  int wp_sz;
  int wp_mask;

  void device_data_collect()
  {
    if ( device_data_collected ) return;
    if ( dev == device_null ) return;
    device_data_collected = true;
    CE( cuDeviceGetName(gpu_name,gpu_name_size,dev) );

    int clock_freq_khz = 0;
    CE( cuDeviceGetAttribute
        (&clock_freq_khz, CU_DEVICE_ATTRIBUTE_CLOCK_RATE, dev) );
    clock_freq_hz = clock_freq_khz * 1000.0;

    CE( cuDeviceGetAttribute(&wp_sz, CU_DEVICE_ATTRIBUTE_WARP_SIZE, dev) );

    wp_lg = 5; // Checked by the assertion below.
    wp_mask = wp_sz - 1;
    assert( 1 << wp_lg == wp_sz );

    CE( cuDeviceGetAttribute
        (&numMultiprocessors, CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT,
         dev) );

  }

  bool event_tracing_active; // If true event monitoring on. Detects nesting.
  uint64_t event_tracing_start_timestamp; // In ns

  void context_set(CUcontext ctx)
  {
    if ( context ) return;
    assert( !context );
    context = ctx;
  }

  void on_api_enter(CUpti_CallbackData *cbdata);
  void on_api_exit(CUpti_CallbackData *cbdata);

  void data_reset()
  {
    kernel_last = NULL;
    need_run_get_call_count = 0;
    CUF_Hash& kafh = kernel_info_fh;
    for ( CUF_Hash::iterator it = kafh.begin(); it != kafh.end(); it++ )
      {
        RTI_Kernel_Info* const rti = &it->second;
        rti->data_reset(this);
      }
  }

  CUfunction fake_fh_get(string name)
  {
    const unsigned int before = fake_fh_map.size();
    CUfunction& fh = fake_fh_map[name];
    if ( before != fake_fh_map.size() )
      {
        fake_fh_next = CUfunction((char*)(fake_fh_next) + 16 );
        fh = fake_fh_next;
      }
    return fh;
  }

  int atend();

private:
  Metrics metrics;
  void metrics_init();
  bool metrics_inited;
public:
  bool metric_add(string metric_name);
  template<typename T> double kernel_et_get(T k);
  int kernel_nlaunches_get(const char *kernel_name);
  bool need_run_get(const char *kernel_name);
  NPerf_Metric_Value
  metric_value_get(const char *metric_name, RTI_Kernel_Info *ki);
  NPerf_Metric_Value
  metric_value_get(const char *metric_name, NPerf_Kernel_Data kd);
  NPerf_Metric_Value
  metric_value_get(const char *metric_name, const char *kernel_name);
  NPerf_Metric_Value
  metric_value_get(const string metric_name, const string kernel_name)
  { return metric_value_get(metric_name.c_str(), kernel_name.c_str()); }

  NPerf_Status metric_data_status(const char *kernel_name = NULL);
  int metrics_min_launches_get()
  {
    metrics_init();
    if ( !metrics.eg_sets ) return 1;
    return metrics.eg_sets->numSets + 1;
  }
};

int RT_Info::need_run_get_call_count = 0;


void
RTI_Kernel_Info::data_reset(RT_Info *rti)
{
  if ( !api_config_inited ) return;
  api_config_inited = false;
  call_count = 0;
  elapsed_time_ns = 0;
  call_count_lite = 0;
  elapsed_time_lite_ns = 0;
  md.reset();
}

void
RTI_Kernel_Info::data_append(RTI_Kernel_Info *ki)
{
  assert( ki && ki->cu_function == cu_function );
  assert( call_count_lite == 1 );
  if ( ki->call_count_lite )
    elapsed_time_lite_ns += ki->elapsed_time_lite_ns / ki->call_count_lite;
  if ( ki->call_count )
    elapsed_time_ns += ki->elapsed_time_ns / ki->call_count;
  md.data_append(&ki->md);
}


// Kludge, until I figure out persistent storage.
RT_Info *rt_info = NULL;


//
// Code below based on NVIDIA CUPTI sample prog  activity.cpp
// The code is not based on any understanding of the relationship
// between buffer size and number of buffers on tracing overhead.
//
#define BUF_SIZE (32 * 1024)
#define ALIGN_SIZE (8)
#define ALIGN_BUFFER(buffer, align)                                            \
  (((uintptr_t) (buffer) & ((align)-1)) ? ((buffer) + (align) - ((uintptr_t) (buffer) & ((align)-1))) : (buffer))


void
cb_buffer_requested(uint8_t **buffer, size_t *size, size_t *maxNumRecords)
{
  uint8_t *bfr = (uint8_t *) malloc(BUF_SIZE + ALIGN_SIZE);
  if ( !bfr )
    fprintf(stderr, "NVIDIAPerf: Out of memory.\n");

  *size = BUF_SIZE;
  *buffer = ALIGN_BUFFER(bfr, ALIGN_SIZE);
  *maxNumRecords = 0;
}

void
cb_buffer_completed
(CUcontext ctx, uint32_t streamId,
 uint8_t *buffer, size_t size, size_t validSize)
{
  if (validSize > 0)
    {
      do {
        CUpti_Activity *record = NULL;
        CUptiResult status =
          cuptiActivityGetNextRecord(buffer, validSize, &record);
        if ( status == CUPTI_SUCCESS ) { rt_info_handle(rt_info, record); }
        else if (status == CUPTI_ERROR_MAX_LIMIT_REACHED) { break; }
        else { CU(status); }
      } while (1);

      // report any records dropped from the queue
      size_t dropped;
      CU(cuptiActivityGetNumDroppedRecords(ctx, streamId, &dropped));
      if ( dropped )
        fprintf(stderr,
                "Dropped %u activity records\n", (unsigned int)dropped);
    }

  free(buffer);
}


#define DECL_PARAMS(t,v) t *v = (t*) cbd->functionParams;

static void CUPTIAPI
traceCallback(void *userdata, CUpti_CallbackDomain domain,
              CUpti_CallbackId cbid, const void *cbdata)
{
  RT_Info* const rt_info = (RT_Info*) userdata;

  if ( domain == CUPTI_CB_DOMAIN_RESOURCE )
    {
      CUpti_ResourceData* const resourceData = (CUpti_ResourceData*) cbdata;
      if ( cbid == CUPTI_CBID_RESOURCE_CONTEXT_CREATED )
        rt_info->context_set(resourceData->context);
    }
  else if ( domain == CUPTI_CB_DOMAIN_DRIVER_API
              || domain == CUPTI_CB_DOMAIN_RUNTIME_API )
    {
      CUpti_CallbackData* const cbd = (CUpti_CallbackData*) cbdata;

      if ( cbd->callbackSite == CUPTI_API_EXIT )
        {
          if ( cbid == CUPTI_DRIVER_TRACE_CBID_cuModuleGetFunction )
            {
              DECL_PARAMS(cuModuleGetFunction_params,params);
              RTI_Kernel_Info& ki = rt_info->kernel_info_fh[*params->hfunc];
              ki.rti = rt_info;
              ki.func_name = strdup(params->name);
              ki.func_name_demangled = demangle(ki.func_name);
              ki.cu_function = *params->hfunc;
              rt_info->kernel_info_name[string(ki.func_name_demangled)] = &ki;
            }
        }

      const bool __attribute__ ((unused)) launch_runtime =
        ( domain == CUPTI_CB_DOMAIN_RUNTIME_API &&
          cbid == CUPTI_RUNTIME_TRACE_CBID_cudaLaunch_v3020 );

      const bool launch_driver =
        ( domain == CUPTI_CB_DOMAIN_DRIVER_API &&
          cbid == CUPTI_DRIVER_TRACE_CBID_cuLaunchKernel );

      if ( launch_driver )
        {
          if ( cbd->callbackSite == CUPTI_API_ENTER )
            rt_info->on_api_enter(cbd);
          else if ( cbd->callbackSite == CUPTI_API_EXIT )
            rt_info->on_api_exit(cbd);
        }

      if ( cbd->callbackSite == CUPTI_API_EXIT ) return;
      if ( rt_info->call_trace_count >= rt_info->call_trace_end ) return;
      if ( rt_info->call_trace_pause_level ) return;
      if ( rt_info->call_trace_count++ < rt_info->call_trace_start )
        return;
#define DP(tp) tp* const p = (tp*) cbd->functionParams
      switch ( cbid ) {
      case CUPTI_DRIVER_TRACE_CBID_cuMemcpyHtoD_v2:
        {
          DP(cuMemcpyHtoD_v2_params);
          printf("Memcopy %#llx[%lu]\n",p->dstDevice,p->ByteCount);
        }
        break;
      case CUPTI_DRIVER_TRACE_CBID_cuMemcpy3D_v2:
        {
          CUDA_MEMCPY3D* const pcopy = *(CUDA_MEMCPY3D**)cbd->functionParams;
          const char* const mt[] = {"???","Hst","Dev","Ary","Uni"};
          printf("Memcpy 3D %s -> %s %p "
                 "(%zd,%zd,%zd)->(%zd,%zd,%zd) %zdx%zdx%zd\n",
                 mt[pcopy->srcMemoryType],
                 mt[pcopy->dstMemoryType],
                 pcopy->dstMemoryType == 1 ? (void*)pcopy->dstHost :
                 pcopy->dstMemoryType == 2 ? (void*)pcopy->dstDevice : NULL,
                 pcopy->srcXInBytes, pcopy->srcY, pcopy->srcZ,
                 pcopy->dstXInBytes, pcopy->dstY, pcopy->dstZ,
                 pcopy->WidthInBytes, pcopy->Height, pcopy->Depth
                 );
          break;
        }

      }
#undef DP
      printf("Call of %s, cbid %d, serial %d\n",
             cbd->functionName, cbid, rt_info->call_trace_count);
    }
}

int
rt_info_trace_for(int num)
{
  if ( !rt_info ) return 0;
  rt_info->call_trace_start = rt_info->call_trace_count;
  rt_info->call_trace_end = rt_info->call_trace_start + num;
  return 1;
}

int
rt_info_trace_pause()
{
  if ( !rt_info ) return 0;
  return rt_info->call_trace_pause_level++;
}
int
rt_info_trace_resume()
{
  if ( !rt_info ) return 0;
  return --rt_info->call_trace_pause_level == 0;
}

static void
rt_info_handle(RT_Info *rt_info, CUpti_Activity *record)
{
  if ( rt_info->stop_tracing ) return;

  switch ( record->kind ) {
  case CUPTI_ACTIVITY_KIND_KERNEL:
    rt_info_handle_kernel(rt_info,(Version_ActivityKernel*)record);
    break;
  default:
    break;
  }
}

static void
rt_info_handle_kernel(RT_Info *rt_info, Version_ActivityKernel *kernel)
{
  string func_name(kernel->name);
  const uint32_t corr_id = kernel->correlationId;
  map<uint32_t,CUfunction>::iterator hi = rt_info->corr_to_h.find(corr_id);
  CUfunction fh = hi != rt_info->corr_to_h.end() ? hi->second :
    rt_info->fake_fh_get(kernel->name);

  RTI_Kernel_Info& ki = rt_info->kernel_info_fh[fh];
  const bool first_time = !ki.have_cupti_kernel_data;

  if ( !first_time ) return;

  // Initialize kernel information.
  //
  ki.inited = true;
  if ( !ki.func_name )
    {
      ki.rti = rt_info;
      ki.func_name = func_name.c_str();
      ki.func_name_demangled = demangle(ki.func_name);
    }

  // To Do: See if launch configuration varies for a kernel.
  ki.cupti_kernel = *kernel;
  ki.have_cupti_kernel_data = true;

}

const bool replay_use = true;

void
replay_callback(const char *kname, int num_replays, void *data)
{
  RTI_Kernel_Info* const ki = (RTI_Kernel_Info*) data;
  // Yes, I know it's global but I'd prefer that it not always be.
  ki->replay_num_launches++;
}

void
RT_Info::on_api_enter(CUpti_CallbackData *cbdata)
{
  context = cbdata->context;

  if ( dev == device_null ) CE( cuCtxGetDevice(&dev) );
  metrics_init();
  device_data_collect();
  if ( !event_tracing_user_on ) return;

  cuLaunchKernel_params* const params =
    (cuLaunchKernel_params*)cbdata->functionParams;
  CUfunction hfunc = params->f;
  RTI_Kernel_Info& ki = kernel_info_fh[hfunc];

  //  This is why kernel event tracing should not be used on production runs.
  CE( cuCtxSynchronize() );
  assert( !event_tracing_active );

  event_tracing_active = true;

  Metrics_Data &md = ki.md;

  const bool rt_info_metrics =
    metrics.eg_sets && ki.call_count_lite >= md.set_rounds;

  ki.replay_num_launches = 0;

  if ( rt_info_metrics )
    {
      if ( replay_use )
        {
          CU( cuptiEnableKernelReplayMode(context) );
          CU( cuptiKernelReplaySubscribeUpdate(replay_callback,&ki) );
        }
      else
        CU( cuptiSetEventCollectionMode
            (context, CUPTI_EVENT_COLLECTION_MODE_KERNEL) );

      assert( !metrics.eg_curr );

      const int eg_start = replay_use ? 0 : md.set_next;
      const int eg_stop = replay_use ? metrics.eg_sets->numSets : eg_start + 1;

      metrics.eg_curr = &metrics.eg_sets->sets[eg_start];

      for ( int egi = eg_start; egi < eg_stop; egi++ )
        {
          CUpti_EventGroupSet* const egs = &metrics.eg_sets->sets[egi];

          for ( uint i=0; i<egs->numEventGroups; i++ )
            {
              int all = 1;
              CU( cuptiEventGroupSetAttribute
                  ( egs->eventGroups[i],
                    CUPTI_EVENT_GROUP_ATTR_PROFILE_ALL_DOMAIN_INSTANCES,
                    sizeof(all), &all));
              CU( cuptiEventGroupEnable(egs->eventGroups[i]) );
            }
        }
    }

  CU( cuptiDeviceGetTimestamp(context, &event_tracing_start_timestamp) );
}

void
RT_Info::on_api_exit(CUpti_CallbackData *cbdata)
{
  cuLaunchKernel_params* const params =
    (cuLaunchKernel_params*)cbdata->functionParams;
  CUfunction hfunc = params->f;
  const uint32_t correlation_id = cbdata->correlationId;
  const CUcontext context = cbdata->context;
  corr_to_h[correlation_id] = hfunc;

  if ( !event_tracing_user_on ) return;

  CE( cuCtxSynchronize() ); ///  SHOULD THIS BE AVOIDED??
  assert( event_tracing_active );
  event_tracing_active = false;
  uint64_t event_tracing_stop_timestamp;
  CU( cuptiDeviceGetTimestamp(context, &event_tracing_stop_timestamp) );
  const int64_t elapsed_raw =
    event_tracing_stop_timestamp - event_tracing_start_timestamp;

  RTI_Kernel_Info& ki = rt_info->kernel_info_fh[hfunc];

  const int64_t elapsed = elapsed_raw / max(1,ki.replay_num_launches);

  ki.elapsed_time_ns += elapsed;
  ki.call_count++;

  kernel_last = &ki;

  if ( !metrics.eg_curr )
    {
      ki.elapsed_time_lite_ns += elapsed;
      ki.call_count_lite++;
    }

  dim3 grid = dim3(params->gridDimX, params->gridDimY, params->gridDimZ);
  dim3 block = dim3(params->blockDimX, params->blockDimY, params->blockDimZ);
  if ( ki.api_config_inited )
    {
      if ( !ki.api_config_change_warning_issued &&
           ( ki.api_grid.x != grid.x || ki.api_grid.y != grid.y
             || ki.api_grid.z != grid.z
             || ki.api_block.x != block.x || ki.api_block.y != block.y
             || ki.api_block.z != block.z ) )
        {
          ki.api_config_change_warning_issued = true;
          fprintf(stderr,
                  "Kernel at %p launched with multiple configurations\n",
                  hfunc);
        }
    }
  else
    {
      ki.api_config_inited = true;
      ki.api_grid = grid;  ki.api_block = block;
      ki.api_block_count = ki.api_grid.x * ki.api_grid.y * ki.api_grid.z;
      ki.api_block_size = ki.api_block.x * ki.api_block.y * ki.api_block.z;
      ki.api_thread_count = ki.api_block_count * ki.api_block_size;
      ki.api_warps_per_block = ( ( ki.api_block_size + wp_mask ) >> wp_lg );
      ki.api_blocks_per_mp_avg =
        double(ki.api_block_count) / numMultiprocessors;
      ki.api_blocks_per_mp = 0.999 + ki.api_blocks_per_mp_avg;
      ki.warps_per_sm_per_launch =
        ki.api_warps_per_block * ki.api_blocks_per_mp;
    }

  if ( !metrics.eg_curr ) return;

  Metrics_Data &md = ki.md;

  const int eg_start = replay_use ? 0 : md.set_next;
  const int eg_stop = replay_use ? metrics.eg_sets->numSets : eg_start + 1;
  metrics.eg_curr = NULL;

  for ( int egi = eg_start; egi < eg_stop; egi++ )
    {
      CUpti_EventGroupSet* const egs = &metrics.eg_sets->sets[egi];

      for ( uint i=0; i<egs->numEventGroups; i++ )
        {
          CUpti_EventGroup eg = egs->eventGroups[i];
#define SZ(v) size_t v##_sz=sizeof(v);
          auto ga = [&](CUpti_EventGroupAttribute attr)
            {
              int val;
              size_t val_sz = sizeof(val);
              CU( cuptiEventGroupGetAttribute ( eg, attr, &val_sz, &val ) );
              assert( val_sz == sizeof(val) );
              return val;
            };

          const int group_domain = ga(CUPTI_EVENT_GROUP_ATTR_EVENT_DOMAIN_ID);
          int num_total_instances; SZ(num_total_instances);
          CU( cuptiDeviceGetEventDomainAttribute
              ( dev, group_domain,
                CUPTI_EVENT_DOMAIN_ATTR_TOTAL_INSTANCE_COUNT,
                &num_total_instances_sz, &num_total_instances ) );
          const int num_instances = ga(CUPTI_EVENT_GROUP_ATTR_INSTANCE_COUNT);
          const int num_events = ga(CUPTI_EVENT_GROUP_ATTR_NUM_EVENTS);
          CUpti_EventID event_ids[num_events];
          SZ(event_ids);
          CU( cuptiEventGroupGetAttribute
              ( eg,
                CUPTI_EVENT_GROUP_ATTR_EVENTS,
                &event_ids_sz, &event_ids[0] ) );
          for ( int j=0; j<num_events; j++ )
            {
              uint64_t vals[num_instances];
              SZ(vals);
              CU( cuptiEventGroupReadEvent
                  ( eg, CUPTI_EVENT_READ_FLAG_NONE,
                    event_ids[j], &vals_sz, &vals[0] ) );
              uint64_t val_sum = 0;
              for ( auto v : vals ) val_sum += v;
              const uint64_t val_norm =
                val_sum / num_instances * num_total_instances;
              md.event_info_live[event_ids[j]].value = val_norm;
            }
#undef SZ
          CU( cuptiEventGroupDisable( eg ) );
        }
    }

  if ( replay_use )
    CU( cuptiDisableKernelReplayMode(context) );

  if ( replay_use || ++md.set_next == int(metrics.eg_sets->numSets) )
    {
      for ( auto elt : md.event_info_live )
        md.event_info[elt.first].value += elt.second.value;
      md.set_next = 0;
      md.set_rounds++;
    }

  md.num_launches++;
  md.elapsed_time_ns += elapsed;
}


void
NPerf_init_(bool turn_on)
{
  assert( !rt_info || rt_info->cupti_on == turn_on ); // Pending testing.
  if ( rt_info ) return;

  rt_info = new RT_Info;
  rt_info->call_trace_start = 0;
  rt_info->call_trace_end = rt_info->call_trace_start + 1;

  rt_info->cupti_on = turn_on;

  if ( !rt_info->cupti_on ) return;

  // The code below must execute as early as possible, including
  // before any--ANY--CUDA API routines are called.

  CU(cuptiActivityEnable(CUPTI_ACTIVITY_KIND_DEVICE));
  CU(cuptiActivityEnable(CUPTI_ACTIVITY_KIND_KERNEL));
  CU(cuptiActivityRegisterCallbacks(cb_buffer_requested,cb_buffer_completed));

  CUptiResult cuptierr = cuptiSubscribe
    (&rt_info->subscriber,(CUpti_CallbackFunc)traceCallback, (void*)rt_info);

  if ( cuptierr != CUPTI_SUCCESS )
    {
      CHECK_CUPTI_ERROR(cuptierr);
      return;
    }

  CU(cuptiEnableDomain(1, rt_info->subscriber, CUPTI_CB_DOMAIN_DRIVER_API));
  CU(cuptiEnableDomain(1, rt_info->subscriber, CUPTI_CB_DOMAIN_RUNTIME_API));
  CU(cuptiEnableDomain(1, rt_info->subscriber, CUPTI_CB_DOMAIN_RESOURCE));
  CU(cuptiEnableDomain(1, rt_info->subscriber, CUPTI_CB_DOMAIN_SYNCHRONIZE));

  rt_info->cupti_inited = true;
}

void
RT_Info::metrics_init()
{
  if ( metrics_inited ) return;
  if ( dev == device_null ) CE( cuCtxGetDevice(&dev) );
  metrics_inited = true;
#if 0

  metric_add("eligible_warps_per_cycle");
  metric_add("gld_efficiency");
  metric_add("gld_throughput");
  metric_add("shared_efficiency");
  metric_add("shared_replay_overhead");
  metric_add("sm_efficiency");
  metric_add("inst_executed");
  metric_add("inst_issued");
  metric_add("flop_count_dp");
  metric_add("ipc");
  metric_add("issued_ipc");
  metric_add("issue_slots");
  metric_add("issue_slot_utilization");
  metric_add("l2_l1_read_hit_rate");
  metric_add("l2_l1_read_throughput");
  metric_add("l2_read_throughput");
  metric_add("l2_utilization");
  metric_add("nc_cache_global_hit_rate");
  metric_add("sysmem_utilization");
  metric_add("dram_read_throughput");
  metric_add("dram_write_throughput");
  metric_add("dram_utilization");
#endif

  vector<CUpti_MetricID> metric_ids;
  for ( auto &mi: metrics.metric_info ) metric_ids.push_back(mi.second.met_id);

  if ( metrics.eg_sets )
    CU( cuptiEventGroupSetsDestroy( metrics.eg_sets ) );

  if ( !metric_ids.size() )
    {
      metrics.eg_sets = NULL;
      return;
    }

  CU( cuptiMetricCreateEventGroupSets
      ( context, sizeof(metric_ids[0])*metric_ids.size(), metric_ids.data(),
        &metrics.eg_sets) );
}

bool
RT_Info::metric_add(string name)
{
  if ( !rt_info ) return false;
  if ( !rt_info->cupti_on ) return false;
  if ( dev == device_null ) CE( cuCtxGetDevice(&dev) );
  CUpti_MetricID met_id;
  CUptiResult rv = cuptiMetricGetIdFromName(dev,name.c_str(),&met_id);
  if ( rv == CUPTI_ERROR_INVALID_METRIC_NAME ) return false;
  CU( rv );
  Metric_Info &mi = metrics.metric_info[name];
  mi.name = name;
  mi.met_id = met_id;
  mi.kind = cupti_metric_get_attr_k(mi.met_id,CUPTI_METRIC_ATTR_VALUE_KIND);

  metrics_inited = false;
  return true;
}

bool
NPerf_metric_collect(const char *name)
{ return rt_info->metric_add(name); }

NPerf_Status
RT_Info::metric_data_status(const char *kernel_name)
{
  if ( !rt_info ) return NPerf_Status_Off;
  RTI_Kernel_Info* const ki = kernel_get(kernel_name);
  if ( !ki ) return NPerf_Status_Kernel_Not_Found;
  if ( ki->md.set_rounds ) return NPerf_Status_OK;
  return NPerf_Status_Insufficient_Launches;
}

NPerf_Status
NPerf_metric_data_status(const char* kernel_name)
{ return rt_info->metric_data_status(kernel_name); }


NPerf_Kernel_Data NPerf_kernel_data_dup()
{ return rt_info->nperf_kernel_data_dup(); }
void NPerf_kernel_data_append(NPerf_Kernel_Data& kd)
{ rt_info->nperf_kernel_data_append(kd); }

NPerf_Kernel_Data
RT_Info::nperf_kernel_data_dup()
{
  if ( ! NPerf_metrics_collection_get() ) return NPerf_Kernel_Data();
  assert( kernel_last );
  RTI_Kernel_Info* const kcpy = new RTI_Kernel_Info(kernel_last);
  kcpy->time_normalize();
  const int idx = kernel_info_store.size();
  kernel_info_store.push_back(kcpy);
  return NPerf_Kernel_Data(idx);
}

void
RT_Info::nperf_kernel_data_append(NPerf_Kernel_Data& kd)
{
  if ( ! NPerf_metrics_collection_get() ) return;
  assert( kernel_last );
  if ( kd.id < 0 ) { kd = nperf_kernel_data_dup(); return; }
  kernel_info_store[kd.id]->data_append(kernel_last);
}

const char*
NPerf_kernel_last_name_get()
{ return rt_info->kernel_last_name_get(); }

bool
NPerf_need_run_get(const char* kernel_name)
{ return rt_info->need_run_get(kernel_name); }

bool
RT_Info::need_run_get(const char* kernel_name)
{
  if ( ! need_run_get_call_count++ ) return true;
  if ( !rt_info ) return false;
  if ( !rt_info->cupti_on ) return false;
  if ( !event_tracing_user_on ) return false;

  RTI_Kernel_Info* const ki = kernel_get(kernel_name);
  if ( !ki ) return true;
  if ( ki->call_count_lite == 0 ) return true;
  if ( !metrics.eg_sets ) return false;
  if ( ki->md.set_rounds == 0 ) return true;
  return false;
}

int
NPerf_kernel_nlaunches_get(const char *kernel_name)
{ return rt_info->kernel_nlaunches_get(kernel_name); }

int
RT_Info::kernel_nlaunches_get(const char *kernel_name)
{
  if ( !rt_info ) return 1;
  RTI_Kernel_Info* const ki = kernel_get(kernel_name);
  if ( !ki ) return 1;
  return ki->call_count;
}


double
NPerf_kernel_et_get(const char* kernel_name)
{ return rt_info->kernel_et_get(kernel_name); }
double
NPerf_kernel_et_get(NPerf_Kernel_Data kernel_name)
{ return rt_info->kernel_et_get(kernel_name); }

template<typename T>
double
RT_Info::kernel_et_get(T kernel_name)
{
  if ( !rt_info ) return -1;
  RTI_Kernel_Info* const ki = kernel_get(kernel_name);
  if ( !ki ) return -1;
  if ( ki->call_count_lite == 0 ) return -1;
  return 1e-9 * ki->elapsed_time_lite_ns / ki->call_count_lite;
}


NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, const char* kernel_name)
{
  if ( !rt_info || !rt_info->cupti_on )
    return NPerf_Metric_Value(NPerf_Status_Off);
  return metric_value_get(metric_name, kernel_get(kernel_name));
}

NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, NPerf_Kernel_Data kd)
{
  if ( !rt_info || !rt_info->cupti_on )
    return NPerf_Metric_Value(NPerf_Status_Off);
  return metric_value_get(metric_name, kernel_get(kd));
}

NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, RTI_Kernel_Info *ki)
{
  if ( !ki ) return NPerf_Metric_Value(NPerf_Status_Kernel_Not_Found);
  auto mii = metrics.metric_info.find(metric_name);
  if ( mii == metrics.metric_info.end() )
    return NPerf_Metric_Value(NPerf_Status_Metric_Not_Found);
  Metric_Info& mi = metrics.metric_info[metric_name];
  Metrics_Data& md = ki->md;

  if ( md.set_rounds == 0 )
    return NPerf_Metric_Value(NPerf_Status_Insufficient_Launches);
  if ( md.values_rounds != md.set_rounds )
    {
      md.event_ids.clear();
      md.values.clear();
      for ( auto elt : md.event_info )
        {
          md.event_ids.push_back(elt.first);
          md.values.push_back(elt.second.value/md.set_rounds);
        }
      md.values_rounds = md.set_rounds;
    }
  const int num_events = md.event_ids.size();

  NPerf_Metric_Value npv(NPerf_Status_OK);
  npv.kind = mi.kind;
  npv.blocks = ki->api_block_count;
  npv.block_size = ki->api_block_size;
  npv.warps_per_block = ki->api_warps_per_block;
  assert( npv.blocks );
  assert( npv.warps_per_block );

  const int64_t et_ns =
    ki->elapsed_time_lite_ns / max(1,ki->call_count_lite);
  
  CUptiResult rv = cuptiMetricGetValue
    (dev, mi.met_id,
     sizeof(md.event_ids[0])*num_events, md.event_ids.data(),
     sizeof(md.values[0])*num_events, md.values.data(),
     et_ns, &npv.metric_value);

  if ( rv == CUPTI_ERROR_INVALID_METRIC_VALUE )
    return NPerf_Metric_Value(NPerf_Status_Bad_Data);
  if ( rv != CUPTI_SUCCESS )
    return NPerf_Metric_Value(NPerf_Status_Error_Other);

  switch ( mi.kind ) {
  case CUPTI_METRIC_VALUE_KIND_DOUBLE:
  case CUPTI_METRIC_VALUE_KIND_PERCENT:            // 0.0 - 100.0
    npv.d = npv.metric_value.metricValueDouble;            break;
  case CUPTI_METRIC_VALUE_KIND_UINT64:
    npv.d = npv.metric_value.metricValueUint64;            break;
  case CUPTI_METRIC_VALUE_KIND_INT64:
  case CUPTI_METRIC_VALUE_KIND_THROUGHPUT:        // Bytes per second
    npv.d = npv.metric_value.metricValueInt64;             break;
  case CUPTI_METRIC_VALUE_KIND_UTILIZATION_LEVEL: // 0-10
    npv.d = npv.metric_value.metricValueUtilizationLevel;  break;
  default: assert(false);
  };

  return npv;
}

double
NPerf_metric_value_get
(const char* metric_name, const char *kernel_name)
{
  return rt_info->metric_value_get(metric_name,kernel_name).d;
}

double
NPerf_metric_value_get
(const char* metric_name, NPerf_Kernel_Data kd)
{
  return rt_info->metric_value_get(metric_name,kd).d;
}

double
NPerf_metric_value_per_warp_get
(const char* metric_name, const char *kernel_name)
{
  return
    rt_info->metric_value_get(metric_name,kernel_name).value_per_warp_get();
}

double
NPerf_metric_value_per_thread_get
(const char* metric_name, const char *kernel_name)
{
  return
    rt_info->metric_value_get(metric_name,kernel_name).value_per_thread_get();
}

Metrics::~Metrics()
{
  if ( !eg_sets ) return;
  CU( cuptiEventGroupSetsDestroy( eg_sets ) );
  eg_sets = NULL;
}





int
NPerf_min_launches_get()
{
  if ( !rt_info ) return 0;
  return rt_info->metrics_min_launches_get();
}


bool
NPerf_metrics_collection_get()
{
  if ( !rt_info || !rt_info->cupti_on ) return false;
  return rt_info->tracing_get();
}
bool
NPerf_metrics_collection_set(bool setting)
{
  if ( !rt_info ) NPerf_init();
  return rt_info->tracing_set(setting);
}

bool
NPerf_metrics_on()
{
  if ( !rt_info ) NPerf_init();
  return rt_info->tracing_set(true);
}

bool
NPerf_metrics_off()
{
  if ( !rt_info ) NPerf_init();
  return rt_info->tracing_off();
}

void
NPerf_data_reset()
{
  if ( !rt_info )
    {
      fprintf
      (stderr,
       R"--(Attempt to use an NPerf function without first calling NPerf_init.
  Call NPerf_init(false); when NPerf not wanted.
)--");
      assert( false );
    }
  rt_info->data_reset();
}



// For sort of kernels.
//
static bool comp_rti(RTI_Kernel_Info *a, RTI_Kernel_Info *b)
{
  return strcmp(a->func_name_demangled,b->func_name_demangled) < 0;
}
static bool comp_time(RTI_Kernel_Info *a, RTI_Kernel_Info *b)
{
  return a->elapsed_time_ns > b->elapsed_time_ns;
}

void
NPerf_atend()
{
  if ( !rt_info ) return;
  rt_info->atend();
}


int
RT_Info::atend()
{

  if ( !rt_info->cupti_inited ) return 0;
  if ( rt_info->stop_tracing ) return 0;

  if ( dev == device_null ) CE( cuCtxGetDevice(&dev) );

  // Note: Should probably call these on all devices that were used.
  //
  CE( cuCtxSynchronize() );
  cudaDeviceReset();

  device_data_collect();

  CU(cuptiEnableDomain(0, subscriber, CUPTI_CB_DOMAIN_DRIVER_API));
  CU(cuptiEnableDomain(0, subscriber, CUPTI_CB_DOMAIN_RUNTIME_API));
  CU(cuptiEnableDomain(0, subscriber, CUPTI_CB_DOMAIN_RESOURCE));
  CU(cuptiEnableDomain(0, subscriber, CUPTI_CB_DOMAIN_SYNCHRONIZE));
  CU(cuptiUnsubscribe(subscriber));

  // Sort kernel information by kernel name.
  //
  CUF_Hash& kafh = rt_info->kernel_info_fh;
  RTI_List sorted_time;
  int64_t total_time_ns = 0;
  for ( CUF_Hash::iterator it = kafh.begin(); it != kafh.end(); it++ )
    {
      RTI_Kernel_Info* const rti = &it->second;
      if ( !rti->call_count ) continue;
      total_time_ns += rti->elapsed_time_ns;
      sorted_time.push_back(&it->second);
    }
  sorted_time.sort( comp_time );
  const int64_t elapsed_time_threshold =
    total_time_ns * 1;

  RTI_List sorted;
  int64_t total_time_show_ns = 0;
  int display_count = 0;
  const int kernels_display_soft_limit = 4;
  for ( RTI_List::iterator it = sorted_time.begin();
        it != sorted_time.end(); it++ )
    {
      RTI_Kernel_Info* const rti = *it;
      const bool display =
        display_count < kernels_display_soft_limit
        || rti->elapsed_time_ns >= elapsed_time_threshold;
      rti->display = display;
      sorted.push_back(rti);
      if ( display )
        {
          display_count++;
          total_time_show_ns += rti->elapsed_time_ns;
        }
    }
  sorted.sort( comp_rti );

  const char* const div = "========================================";
  printf("%s%s\n",div,div);
  printf("Run-Time GPU Resource and Performance Data\n\n");

  uint32_t cupti_version;  CU( cuptiGetVersion(&cupti_version) );
  printf("CUPTI API build %d, run %d.\n",
         CUPTI_API_VERSION, cupti_version);

  printf("Number of launches needed: %d metric.\n",
         metrics.eg_sets->numSets );

#define printf if ( ki->display ) printf

  // Print info on each kernel.
  //
  for ( RTI_List::iterator it = sorted.begin(); it != sorted.end(); it++ )
    {
      RTI_Kernel_Info* const ki = *it;

      printf("\nFor Kernel \"%s\"  (addr %p)\n",
             ki->func_name_demangled,
             ki->cu_function);

      const int api_block_size = ki->api_block_size;
      const int api_block_count = ki->api_block_count;
      const double api_blocks_per_mp = ki->api_blocks_per_mp_avg;

      if ( ki->api_block.x )
        {
          const char* const mult_abbr[] = { "ns", "µs", "ms", "s" };
          const int mult_limit = sizeof(mult_abbr)/sizeof(mult_abbr[0]);
          const int dig_grps =
            min( mult_limit,
                 max(0, int(log10(ki->elapsed_time_ns))/3-1));
          ki->et_print_mult_txt = mult_abbr[dig_grps];
          const double et_print_mult_from_ns = pow(10,-dig_grps*3);

          printf(" Data From API Hooks\n");
          printf("   Launches %5d,                   "
                 "Total Execution Time %8.1f %2s\n",
                 ki->call_count,
                 ki->elapsed_time_ns * et_print_mult_from_ns,
                 ki->et_print_mult_txt);
          printf("   Block size [%3d, %3d, %2d] = %5d threads = %2d warps.\n"
                 "   Grid size  [%3d, %3d, %2d] = %5d blocks,  %.1f per MP.\n",
                 ki->api_block.x, ki->api_block.y, ki->api_block.z,
                 api_block_size, api_block_size + 31 >> wp_lg,
                 ki->api_grid.x, ki->api_grid.y, ki->api_grid.z,
                 api_block_count, api_blocks_per_mp);
        }

      if ( ki->md.set_rounds > 0 )
        {
          Metrics_Data& md = ki->md;
          const double et_ns =
            ki->elapsed_time_lite_ns / max(1,ki->call_count_lite);
          const double cycles = 1e-9 * et_ns * clock_freq_hz;
          printf
            ("\nMetrics stuff collected over %d rounds. Each launch "
             "%.0f cyc or %.6f ms\n",
             md.set_rounds, cycles, et_ns * 1e-6);

          for ( auto &elt: metrics.metric_info )
            {
              Metric_Info& mi = elt.second;

              //  CUPTI_METRIC_ATTR_NAME
              //  CUPTI_METRIC_ATTR_SHORT_DESCRIPTION
              //  CUPTI_METRIC_ATTR_LONG_DESCRIPTION

              //  * The metric value is a 64-bit double.
              // CUPTI_METRIC_VALUE_KIND_DOUBLE            = 0,
              //  * The metric value is a 64-bit unsigned integer.
              // CUPTI_METRIC_VALUE_KIND_UINT64            = 1,
              //  * The metric value is a percentage represented by a 64-bit
              //  * double. For example, 57.5% is represented by the value 57.5.
              // CUPTI_METRIC_VALUE_KIND_PERCENT           = 2,
              //  * The metric value is a throughput represented by a 64-bit
              // CUPTI_METRIC_VALUE_KIND_THROUGHPUT        = 3,
              //  * The metric value is a 64-bit signed integer.
              // CUPTI_METRIC_VALUE_KIND_INT64             = 4,
              //  * The metric value is a utilization level, as represented by
              //  * CUpti_MetricValueUtilizationLevel.
              // CUPTI_METRIC_VALUE_KIND_UTILIZATION_LEVEL = 5

              NPerf_Metric_Value npv = metric_value_get(mi.name,ki->func_name);
              printf("%-25s  ",mi.name.c_str());

              switch ( npv.kind ) {
              case CUPTI_METRIC_VALUE_KIND_DOUBLE:
                printf("%12.8f\n",npv.metric_value.metricValueDouble);
                break;
              case CUPTI_METRIC_VALUE_KIND_UINT64:
                printf("%12lu or %7.1f per wp or %7.1f per thd\n",
                       npv.metric_value.metricValueUint64,
                       npv.value_per_warp_get(),
                       npv.value_per_thread_get() );
                break;
              case CUPTI_METRIC_VALUE_KIND_INT64:
                printf("%ld\n",npv.metric_value.metricValueInt64);
                break;
              case CUPTI_METRIC_VALUE_KIND_THROUGHPUT:
                printf
                  ("%10.6f GB/s\n", npv.metric_value.metricValueInt64 * 1e-9);
                break;
              case CUPTI_METRIC_VALUE_KIND_PERCENT:
                printf("%10.6f%%\n",npv.metric_value.metricValuePercent);
                break;
              case CUPTI_METRIC_VALUE_KIND_UTILIZATION_LEVEL:
                printf
                  ("%3d (0-10)\n",npv.metric_value.metricValueUtilizationLevel);
                break;
              default:
                assert(false);
              }
            }
        }

    }
#undef printf

  return 0;
}

