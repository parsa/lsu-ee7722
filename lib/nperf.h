// -*- c++ -*-

#ifndef RT_INFO_H
#define RT_INFO_H

typedef enum
  { NPerf_Status_OK,
    NPerf_Status_Status_Unset,
    NPerf_Status_Off,
    NPerf_Status_Kernel_Not_Found,
    NPerf_Status_Metric_Not_Found,
    NPerf_Status_Bad_Data,
    NPerf_Status_Insufficient_Launches,
    NPerf_Status_Error_Other,
    NPerf_Status_ENUME_SIZE }
  NPerf_Status;

void NPerf_init_(bool turn_on = true);

#if 0

inline void
NPerf_init(bool turn_on = true)
{
#ifdef __CUDACC_DEBUG__
  NPerf_init_(false);
#else
  NPerf_init_(turn_on);
#endif
}

#else

inline void
NPerf_init(bool turn_on = true)
{
#ifndef __CUDACC__
  // Make sure that debug macros defined for non-nvcc compilations.
  const std::string check_corr = "-D__CUDA_DEBUG_EXE__";
#ifndef CDEBUG_FLAGS
  const std::string check = "cdebug not defined";
#else
  const std::string check = CDEBUG_FLAGS;
#endif
  if ( turn_on && check != check_corr )
    fprintf
      (stderr,"\n** WARNING: Compiled without CDEBUG_FLAGS set.  This may cause errors when running under cuda-gdb.");
#endif

#if defined __CUDACC_DEBUG__ || defined __CUDA_DEBUG_EXE__
  NPerf_init_(false);
#else
  NPerf_init_(turn_on);
#endif
}

#endif


class NPerf_Kernel_Data {
public:
  NPerf_Kernel_Data():id(-1){};
  NPerf_Kernel_Data(int idp):id(idp){};
  bool operator == (const NPerf_Kernel_Data& k) { return id == k.id; }
  int id;
};

void NPerf_atend();

int NPerf_min_launches_get(); 
void NPerf_data_reset();

bool NPerf_metrics_collection_get();
bool NPerf_metrics_collection_set(bool setting);
bool NPerf_metrics_on();
bool NPerf_metrics_off();

NPerf_Kernel_Data NPerf_kernel_data_dup();
void NPerf_kernel_data_append(NPerf_Kernel_Data& kd);

bool NPerf_metric_collect(const char *name);
NPerf_Status NPerf_metric_data_status(const char* kernel_name = NULL);
bool NPerf_need_run_get(const char* kernel_name = NULL);
const char* NPerf_kernel_last_name_get();
double NPerf_kernel_et_get(const char *kernel_name = NULL);
double NPerf_kernel_et_get(NPerf_Kernel_Data kd);
int NPerf_kernel_nlaunches_get(const char *kernel_name = NULL);
double NPerf_metric_value_get
(const char* metric_name, const char *kernel_name = NULL);
double NPerf_metric_value_get(const char* metric_name, NPerf_Kernel_Data kd);
double NPerf_metric_value_per_warp_get
(const char* metric_name, const char *kernel_name = NULL);
double NPerf_metric_value_per_thread_get
(const char* metric_name, const char *kernel_name = NULL);

#endif
