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

#include <nvperf_host.h>
#include <nvperf_cuda_host.h>
#include <cupti_target.h>
#include <cupti_profiler_target.h>
#include <cupti_callbacks.h>
#include <nvperf_host.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <stdlib.h>

#include <Metric.h>
#include <Eval.h>
#include <List.h>
#include <Parser.h>
#include <Utils.h>

#include <iostream>

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

#define CP(apiFuncCall)                                                       \
do {                                                                          \
    NVPA_Status _status = apiFuncCall;                                        \
    if (_status != NVPA_STATUS_SUCCESS) {                                     \
        fprintf(stderr, "%s:%d: error: function %s failed with error %s.\n",  \
                __FILE__, __LINE__, #apiFuncCall,                             \
                NV::Metric::Utils::GetNVPWResultString(_status) );            \
        exit(-1);                                                             \
    }                                                                         \
} while (0)

#define CR(apiFuncCall)                                          \
do {                                                                           \
    cudaError_t _status = apiFuncCall;                                         \
    if (_status != cudaSuccess) {                                              \
        fprintf(stderr, "%s:%d: error: function %s failed with error %s.\n",   \
                __FILE__, __LINE__, #apiFuncCall, cudaGetErrorString(_status));\
        exit(-1);                                                              \
    }                                                                          \
} while (0)

#define DEF_PROF_STRUCT(n)                                                    \
struct p##n : public n                                                        \
{                                                                             \
  p##n():n{n##_STRUCT_SIZE}{};                                                \
  p##n(CUptiResult (*f)(n*)):n{n##_STRUCT_SIZE}{CU(f(this));};                    \
};

#define DEF_NVPW_STRUCT(n)                                                    \
struct p##n : public n                                                        \
{                                                                             \
  p##n():n{n##_STRUCT_SIZE}{};                                                \
  p##n(NVPA_Status (*f)(n*)):n{n##_STRUCT_SIZE}{CP(f(this));};                \
};

DEF_PROF_STRUCT(CUpti_Profiler_BeginPass_Params);
DEF_PROF_STRUCT(CUpti_Profiler_BeginSession_Params);
DEF_PROF_STRUCT(CUpti_Profiler_CounterDataImageOptions);
DEF_PROF_STRUCT(CUpti_Profiler_CounterDataImage_CalculateScratchBufferSize_Params);
DEF_PROF_STRUCT(CUpti_Profiler_CounterDataImage_CalculateSize_Params);
DEF_PROF_STRUCT(CUpti_Profiler_CounterDataImage_InitializeScratchBuffer_Params);
DEF_PROF_STRUCT(CUpti_Profiler_CounterDataImage_Initialize_Params);
DEF_PROF_STRUCT(CUpti_Profiler_DeInitialize_Params);
DEF_PROF_STRUCT(CUpti_Profiler_DisableProfiling_Params);
DEF_PROF_STRUCT(CUpti_Profiler_EnableProfiling_Params);
DEF_PROF_STRUCT(CUpti_Profiler_EndPass_Params);
DEF_PROF_STRUCT(CUpti_Profiler_EndSession_Params);
DEF_PROF_STRUCT(CUpti_Profiler_FlushCounterData_Params);
DEF_PROF_STRUCT(CUpti_Profiler_SetConfig_Params);
DEF_PROF_STRUCT(CUpti_Profiler_UnsetConfig_Params);

DEF_PROF_STRUCT(CUpti_Profiler_Initialize_Params);
DEF_PROF_STRUCT(CUpti_Device_GetChipName_Params);

DEF_NVPW_STRUCT(NVPW_InitializeHost_Params);
DEF_NVPW_STRUCT(NVPW_CUDA_MetricsContext_Create_Params);
DEF_NVPW_STRUCT(NVPW_MetricsContext_Destroy_Params);
DEF_NVPW_STRUCT(NVPW_MetricsContext_GetMetricProperties_Begin_Params);
DEF_NVPW_STRUCT(NVPW_MetricsContext_GetMetricProperties_End_Params);


class CP_Info {
  // Note: CP is for CUpti Profiling API.
public:
  CP_Info();

  bool state_pending_init_metrics;
  bool state_pending_init_session;

  bool state_inited_metrics;
  bool state_inited_session;

  int numRanges;
  string chipName;
  bool allPassesSubmitted;

  CUpti_ProfilerRange profilerRange;
  CUpti_ProfilerReplayMode profilerReplayMode;

  map<string,string> metric_alias;
  string metric_name_translate (string user_metric_name);

  vector<string> metric_names_user;
  vector<string> metric_names_nvpw;
  map<string,string> metric_user_to_nvpw;
  map<string,double> metric_values;
  bool state_metrics_retrieved;

  vector<uint8_t> img_cnt_data_pfx;
  vector<uint8_t> img_config;
  vector<uint8_t> img_cnt_data;
  vector<uint8_t> img_cnt_data_scr_buf;

  bool metrics_setup();
  bool session_start();
  void at_launch_before();
  void at_launch_after();
  void metrics_retrieve();
  void profiling_exit();
};

CP_Info::CP_Info()
{
  numRanges = 1;
  profilerRange = CUPTI_AutoRange;
  profilerReplayMode = CUPTI_KernelReplay;
  allPassesSubmitted = true;

  state_pending_init_metrics = true;
  state_pending_init_session = true;

  state_metrics_retrieved = false;
  state_inited_metrics = false;
  state_inited_session = false;

  // Source:
  //  https://docs.nvidia.com/cupti/Cupti/r_main.html#metrics_map_table_70
  metric_alias["achieved_occupancy"] = "sm__warps_active.avg.pct_of_peak_sustained_active";
  metric_alias["double_precision_fu_utilization"] = "smsp__inst_executed_pipe_fp64.avg.pct_of_peak_sustained_active";
  metric_alias["dram_read_bytes"] = "dram__bytes_read.sum";
  metric_alias["dram_read_throughput"] = "dram__bytes_read.sum.per_second";
  metric_alias["dram_read_transactions"] = "dram__sectors_read.sum";
  metric_alias["dram_utilization"] = "dram__throughput.avg.pct_of_peak_sustained_elapsed";
  metric_alias["dram_write_bytes"] = "dram__bytes_write.sum";
  metric_alias["dram_write_throughput"] = "dram__bytes_write.sum.per_second";
  metric_alias["dram_write_transactions"] = "dram__sectors_write.sum";
  metric_alias["eligible_warps_per_cycle"] = "smsp__warps_eligible.sum.per_cycle_active";
  metric_alias["flop_count_dp_add"] = "smsp__sass_thread_inst_executed_op_dadd_pred_on.sum";
  metric_alias["flop_count_dp_fma"] = "smsp__sass_thread_inst_executed_op_dfma_pred_on.sum";
  metric_alias["flop_count_dp_mul"] = "smsp__sass_thread_inst_executed_op_dmul_pred_on.sum";
  metric_alias["flop_count_hp_add"] = "smsp__sass_thread_inst_executed_op_hadd_pred_on.sum";
  metric_alias["flop_count_hp_fma"] = "smsp__sass_thread_inst_executed_op_hfma_pred_on.sum";
  metric_alias["flop_count_hp_mul"] = "smsp__sass_thread_inst_executed_op_hmul_pred_on.sum";
  metric_alias["flop_count_sp_add"] = "smsp__sass_thread_inst_executed_op_fadd_pred_on.sum";
  metric_alias["flop_count_sp_fma"] = "smsp__sass_thread_inst_executed_op_ffma_pred_on.sum";
  metric_alias["flop_count_sp_mul"] = "smsp__sass_thread_inst_executed_op_fmul_pred_on.sum";
  metric_alias["flop_dp_efficiency"] = "smsp__sass_thread_inst_executed_ops_dadd_dmul_dfma_pred_on.avg.pct_of_peak_sustained_elapsed";
  metric_alias["flop_hp_efficiency"] = "smsp__sass_thread_inst_executed_ops_hadd_hmul_hfma_pred_on.avg.pct_of_peak_sustained_elapsed";
  metric_alias["flop_sp_efficiency"] = "smsp__sass_thread_inst_executed_ops_fadd_fmul_ffma_pred_on.avg.pct_of_peak_sustained_elapsed";
  metric_alias["gld_efficiency"] = "smsp__sass_average_data_bytes_per_sector_mem_global_op_ld.pct";
  metric_alias["gld_throughput"] = "l1tex__t_bytes_pipe_lsu_mem_global_op_ld.sum.per_second";
  metric_alias["gld_transactions"] = "l1tex__t_sectors_pipe_lsu_mem_global_op_ld.sum";
  metric_alias["gld_transactions_per_request"] = "l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_ld.ratio";
  metric_alias["global_atomic_requests"] = "l1tex__t_requests_pipe_lsu_mem_global_op_atom.sum";
  metric_alias["global_load_requests"] = "l1tex__t_requests_pipe_lsu_mem_global_op_ld.sum";
  metric_alias["global_reduction_requests"] = "l1tex__t_requests_pipe_lsu_mem_global_op_red.sum";
  metric_alias["global_store_requests"] = "l1tex__t_requests_pipe_lsu_mem_global_op_st.sum";
  metric_alias["gst_efficiency"] = "smsp__sass_average_data_bytes_per_sector_mem_global_op_st.pct";
  metric_alias["gst_throughput"] = "l1tex__t_bytes_pipe_lsu_mem_global_op_st.sum.per_second";
  metric_alias["gst_transactions"] = "l1tex__t_bytes_pipe_lsu_mem_global_op_st.sum";
  metric_alias["gst_transactions_per_request"] = "l1tex__average_t_sectors_per_request_pipe_lsu_mem_global_op_st.ratio";
  metric_alias["half_precision_fu_utilization"] = "smsp__inst_executed_pipe_fp16.avg.pct_of_peak_sustained_active";
  metric_alias["inst_bit_convert"] = "smsp__sass_thread_inst_executed_op_conversion_pred_on.sum";
  metric_alias["inst_compute_ld_st"] = "smsp__sass_thread_inst_executed_op_memory_pred_on.sum";
  metric_alias["inst_control"] = "smsp__sass_thread_inst_executed_op_control_pred_on.sum";
  metric_alias["inst_executed"] = "smsp__inst_executed.sum";
  metric_alias["inst_executed_global_atomics"] = "smsp__sass_inst_executed_op_global_atom.sum";
  metric_alias["inst_executed_global_loads"] = "smsp__inst_executed_op_global_ld.sum";
  metric_alias["inst_executed_global_reductions"] = "smsp__inst_executed_op_global_red.sum";
  metric_alias["inst_executed_global_stores"] = "smsp__inst_executed_op_global_st.sum";
  metric_alias["inst_executed_local_loads"] = "smsp__inst_executed_op_local_ld.sum";
  metric_alias["inst_executed_local_stores"] = "smsp__inst_executed_op_local_st.sum";
  metric_alias["inst_executed_shared_loads"] = "smsp__inst_executed_op_shared_ld.sum";
  metric_alias["inst_executed_shared_stores"] = "smsp__inst_executed_op_shared_st.sum";
  metric_alias["inst_executed_surface_atomics"] = "smsp__inst_executed_op_surface_atom.sum";
  metric_alias["inst_executed_surface_reductions"] = "smsp__inst_executed_op_surface_red.sum";
  metric_alias["inst_executed_surface_stores"] = "smsp__inst_executed_op_surface_st.sum";
  metric_alias["inst_executed_tex_ops"] = "smsp__inst_executed_op_texture.sum";
  metric_alias["inst_fp_16"] = "smsp__sass_thread_inst_executed_op_fp16_pred_on.sum";
  metric_alias["inst_fp_32"] = "smsp__sass_thread_inst_executed_op_fp32_pred_on.sum";
  metric_alias["inst_fp_64"] = "smsp__sass_thread_inst_executed_op_fp64_pred_on.sum";
  metric_alias["inst_integer"] = "smsp__sass_thread_inst_executed_op_integer_pred_on.sum";
  metric_alias["inst_inter_thread_communication"] = "smsp__sass_thread_inst_executed_op_inter_thread_communication_pred_on.sum";
  metric_alias["inst_issued"] = "smsp__inst_issued.sum";
  metric_alias["inst_misc"] = "smsp__sass_thread_inst_executed_op_misc_pred_on.sum";
  metric_alias["inst_per_warp"] = "smsp__average_inst_executed_per_warp.ratio";
  metric_alias["ipc"] = "smsp__inst_executed.avg.per_cycle_active";
  metric_alias["issue_slot_utilization"] = "smsp__issue_active.avg.pct_of_peak_sustained_active";
  metric_alias["issue_slots"] = "smsp__inst_issued.sum";
  metric_alias["issued_ipc"] = "smsp__inst_issued.avg.per_cycle_active";
  metric_alias["l1_sm_lg_utilization"] = "l1tex__lsu_writeback_active.avg.pct_of_peak_sustained_active";
  metric_alias["l2_atomic_throughput"] = "lts__t_sectors_srcunit_l1_op_atom.sum.per_second";
  metric_alias["l2_atomic_transactions"] = "lts__t_sectors_srcunit_l1_op_atom.sum";
  metric_alias["l2_global_atomic_store_bytes"] = "lts__t_bytes_equiv_l1sectormiss_pipe_lsu_mem_global_op_atom.sum";
  metric_alias["l2_global_load_bytes"] = "lts__t_bytes_equiv_l1sectormiss_pipe_lsu_mem_global_op_ld.sum";
  metric_alias["l2_local_load_bytes"] = "lts__t_bytes_equiv_l1sectormiss_pipe_lsu_mem_local_op_ld.sum";
  metric_alias["l2_read_throughput"] = "lts__t_sectors_op_read.sum.per_second";
  metric_alias["l2_read_transactions"] = "lts__t_sectors_op_read.sum";
  metric_alias["l2_surface_load_bytes"] = "lts__t_bytes_equiv_l1sectormiss_pipe_tex_mem_surface_op_ld.sum";
  metric_alias["l2_surface_store_bytes"] = "lts__t_bytes_equiv_l1sectormiss_pipe_tex_mem_surface_op_st.sum";
  metric_alias["l2_tex_hit_rate"] = "lts__t_sector_hit_rate.pct";
  metric_alias["l2_tex_read_hit_rate"] = "lts__t_sector_op_read_hit_rate.pct";
  metric_alias["l2_tex_read_throughput"] = "lts__t_sectors_srcunit_tex_op_read.sum.per_second";
  metric_alias["l2_tex_read_transactions"] = "lts__t_sectors_srcunit_tex_op_read.sum";
  metric_alias["l2_tex_write_hit_rate"] = "lts__t_sector_op_write_hit_rate.pct";
  metric_alias["l2_tex_write_throughput"] = "lts__t_sectors_srcunit_tex_op_read.sum.per_second";
  metric_alias["l2_tex_write_transactions"] = "lts__t_sectors_srcunit_tex_op_read.sum";
  metric_alias["l2_utilization"] = "lts__t_sectors.avg.pct_of_peak_sustained_elapsed";
  metric_alias["l2_write_throughput"] = "lts__t_sectors_op_write.sum.per_second";
  metric_alias["l2_write_transactions"] = "lts__t_sectors_op_write.sum";
  metric_alias["ldst_fu_utilization"] = "smsp__inst_executed_pipe_lsu.avg.pct_of_peak_sustained_active";
  metric_alias["local_load_requests"] = "l1tex__t_requests_pipe_lsu_mem_local_op_ld.sum";
  metric_alias["local_load_throughput"] = "l1tex__t_bytes_pipe_lsu_mem_local_op_ld.sum.per_second";
  metric_alias["local_load_transactions"] = "l1tex__t_sectors_pipe_lsu_mem_local_op_ld.sum";
  metric_alias["local_load_transactions_per_request"] = "l1tex__average_t_sectors_per_request_pipe_lsu_mem_local_op_ld.ratio";
  metric_alias["local_store_requests"] = "l1tex__t_requests_pipe_lsu_mem_local_op_st.sum";
  metric_alias["local_store_throughput"] = "l1tex__t_sectors_pipe_lsu_mem_local_op_st.sum.per_second";
  metric_alias["local_store_transactions"] = "l1tex__t_sectors_pipe_lsu_mem_local_op_st.sum";
  metric_alias["local_store_transactions_per_request"] = "l1tex__average_t_sectors_per_request_pipe_lsu_mem_local_op_st.ratio";


  metric_alias["pcie_total_data_received"] = "pcie__read_bytes.sum";
  metric_alias["pcie_total_data_transmitted"] = "pcie__write_bytes.sum";
  metric_alias["shared_efficiency"] = "smsp__sass_average_data_bytes_per_wavefront_mem_shared.pct";
  metric_alias["shared_load_throughput"] = "l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum.per_second";
  metric_alias["shared_load_transactions"] = "l1tex__data_pipe_lsu_wavefronts_mem_shared_op_ld.sum";
  metric_alias["shared_store_throughput"] = "l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum.per_second";
  metric_alias["shared_store_transactions"] = "l1tex__data_pipe_lsu_wavefronts_mem_shared_op_st.sum";
  metric_alias["shared_utilization"] = "l1tex__data_pipe_lsu_wavefronts_mem_shared.avg.pct_of_peak_sustained_elapsed";
  metric_alias["single_precision_fu_utilization"] = "smsp__pipe_fma_cycles_active.avg.pct_of_peak_sustained_active";
  metric_alias["sm_efficiency"] = "smsp__cycles_active.avg.pct_of_peak_sustained_elapsed";
  metric_alias["sm_tex_utilization"] = "l1tex__texin_sm2tex_req_cycles_active.avg.pct_of_peak_sustained_elapsed";
  metric_alias["special_fu_utilization"] = "smsp__inst_executed_pipe_xu.avg.pct_of_peak_sustained_active";
  metric_alias["stall_constant_memory_dependency"] = "smsp__warp_issue_stalled_imc_miss_per_warp_active.pct";
  metric_alias["stall_inst_fetch"] = "smsp__warp_issue_stalled_no_instruction_per_warp_active.pct";
  metric_alias["stall_memory_dependency"] = "smsp__warp_issue_stalled_long_scoreboard_per_warp_active.pct";
  metric_alias["stall_not_selected"] = "smsp__warp_issue_stalled_not_selected_per_warp_active.pct";
  metric_alias["stall_sleeping"] = "smsp__warp_issue_stalled_sleeping_per_warp_active.pct";
  metric_alias["stall_texture"] = "smsp__warp_issue_stalled_tex_throttle_per_warp_active.pct";
  metric_alias["surface_atomic_requests"] = "l1tex__t_requests_pipe_tex_mem_surface_op_atom.sum";
  metric_alias["surface_load_requests"] = "l1tex__t_requests_pipe_tex_mem_surface_op_ld.sum";
  metric_alias["surface_reduction_requests"] = "l1tex__t_requests_pipe_tex_mem_surface_op_red.sum";
  metric_alias["surface_store_requests"] = "l1tex__t_requests_pipe_tex_mem_surface_op_st.sum";
  metric_alias["sysmem_read_throughput"] = "lts__t_sectors_aperture_sysmem_op_read.sum.per_second";
  metric_alias["sysmem_read_transactions"] = "lts__t_sectors_aperture_sysmem_op_read.sum";
  metric_alias["sysmem_write_throughput"] = "lts__t_sectors_aperture_sysmem_op_write.sum.per_second";
  metric_alias["sysmem_write_transactions"] = "lts__t_sectors_aperture_sysmem_op_write.sum";
  metric_alias["tensor_precision_fu_utilization"] = "sm__pipe_tensor_cycles_active.avg.pct_of_peak_sustained_active";
  metric_alias["tex_cache_hit_rate"] = "l1tex__t_sector_hit_rate.pct";
  metric_alias["tex_fu_utilization"] = "smsp__inst_executed_pipe_tex.avg.pct_of_peak_sustained_active";
  metric_alias["tex_sm_tex_utilization"] = "l1tex__f_tex2sm_cycles_active.avg.pct_of_peak_sustained_elapsed";
  metric_alias["tex_sm_utilization"] = "sm__mio2rf_writeback_active.avg.pct_of_peak_sustained_elapsed";
  metric_alias["texture_load_requests"] = "l1tex__t_requests_pipe_tex_mem_texture.sum";
  metric_alias["warp_execution_efficiency"] = "smsp__thread_inst_executed_per_inst_executed.ratio";
  metric_alias["warp_nonpred_execution_efficiency"] = "smsp__thread_inst_executed_per_inst_executed.pct";

}

bool
CP_Info::metrics_setup()
{
  if ( !state_pending_init_metrics ) return state_inited_metrics;
  state_pending_init_metrics = false;

  pNVPW_InitializeHost_Params{NVPW_InitializeHost};

  if ( metric_names_user.empty() ) return state_inited_metrics;

  // Try to filter the metrics.
  pNVPW_CUDA_MetricsContext_Create_Params mctx_create_pars;
  mctx_create_pars.pChipName = chipName.c_str();
  CP( NVPW_CUDA_MetricsContext_Create(&mctx_create_pars) );
  const auto mctx = mctx_create_pars.pMetricsContext;

  for ( auto& name_user: metric_names_user )
    {
      string name =
        metric_alias.count(name_user) ? metric_alias[name_user] : name_user;

      string name_clean;
      bool isolated, keepInstances;
      NV::Metric::Parser::ParseMetricNameString
        (name, &name_clean, &isolated, &keepInstances);

      pNVPW_MetricsContext_GetMetricProperties_Begin_Params gmet_prop_beg_pars;
      gmet_prop_beg_pars.pMetricsContext = mctx;
      gmet_prop_beg_pars.pMetricName = name_clean.c_str();
      bool okay =
        NVPW_MetricsContext_GetMetricProperties_Begin( &gmet_prop_beg_pars )
        == NVPA_STATUS_SUCCESS;
      if ( !okay )
        printf("Metric %s (%s) okay %d\n",
               name.c_str(), name_clean.c_str(), okay);

      if ( !okay ) continue;
      if ( false )
        printf(" %s\n",gmet_prop_beg_pars.pDescription);
      metric_names_nvpw.push_back(name);
      metric_user_to_nvpw[name_user] = name;

      pNVPW_MetricsContext_GetMetricProperties_End_Params gmet_prop_end_pars;
      gmet_prop_end_pars.pMetricsContext = mctx;
      CP( NVPW_MetricsContext_GetMetricProperties_End(&gmet_prop_end_pars) );
    }

  pNVPW_MetricsContext_Destroy_Params mctx_destroy_pars;
  mctx_destroy_pars.pMetricsContext = mctx;
  NVPW_MetricsContext_Destroy(&mctx_destroy_pars);

  if ( metric_names_nvpw.empty() ) return state_inited_metrics;

  string nperf_metric = "gpu__cycles_elapsed.sum";
  metric_names_nvpw.push_back(nperf_metric);
  metric_user_to_nvpw[nperf_metric] = nperf_metric;

  if ( !NV::Metric::Config::GetConfigImage
       ( chipName, metric_names_nvpw, img_config ) )
    {
      std::cout << "Failed to create configImage" << std::endl;
      exit(-1);
    }
  if ( !NV::Metric::Config::GetCounterDataPrefixImage
       ( chipName, metric_names_nvpw, img_cnt_data_pfx ) )
    {
      std::cout << "Failed to create img_cnt_data_pfx" << std::endl;
      exit(-1);
    }
  return state_inited_metrics = true;
}

bool
CP_Info::session_start()
{
  if ( !state_inited_metrics ) return false;
  if ( !state_pending_init_session ) return state_inited_session;
  if ( state_inited_session )
    {
      pCUpti_Profiler_UnsetConfig_Params{cuptiProfilerUnsetConfig};
      pCUpti_Profiler_EndSession_Params{cuptiProfilerEndSession};
    }

  state_metrics_retrieved = false;
  state_pending_init_session = false;

  // createCounterDataImage

  pCUpti_Profiler_CounterDataImageOptions cdi_opts;
  cdi_opts.pCounterDataPrefix = &img_cnt_data_pfx[0];
  cdi_opts.counterDataPrefixSize = img_cnt_data_pfx.size();
  cdi_opts.maxNumRanges = numRanges;
  cdi_opts.maxNumRangeTreeNodes = numRanges;
  cdi_opts.maxRangeNameLength = 64;

  pCUpti_Profiler_CounterDataImage_CalculateSize_Params cs_pars;
  cs_pars.pOptions = &cdi_opts;
  cs_pars.sizeofCounterDataImageOptions =
    CUpti_Profiler_CounterDataImageOptions_STRUCT_SIZE;
  CU( cuptiProfilerCounterDataImageCalculateSize( &cs_pars ) );

  const size_t cdi_elts = cs_pars.counterDataImageSize;
  img_cnt_data.resize( cdi_elts );

  pCUpti_Profiler_CounterDataImage_Initialize_Params cdii_pars;
  cdii_pars.sizeofCounterDataImageOptions =
    CUpti_Profiler_CounterDataImageOptions_STRUCT_SIZE;
  cdii_pars.pOptions = &cdi_opts;
  cdii_pars.counterDataImageSize = cdi_elts;
  cdii_pars.pCounterDataImage = &img_cnt_data[0];
  CU( cuptiProfilerCounterDataImageInitialize( &cdii_pars ) );

  pCUpti_Profiler_CounterDataImage_CalculateScratchBufferSize_Params sbs_pars;
  sbs_pars.counterDataImageSize = cdi_elts;
  sbs_pars.pCounterDataImage = &img_cnt_data[0];
  CU( cuptiProfilerCounterDataImageCalculateScratchBufferSize(&sbs_pars) );
  img_cnt_data_scr_buf.resize( sbs_pars.counterDataScratchBufferSize );

  pCUpti_Profiler_CounterDataImage_InitializeScratchBuffer_Params isb_pars;
  isb_pars.counterDataImageSize = cdi_elts;
  isb_pars.pCounterDataImage = &img_cnt_data[0];
  isb_pars.counterDataScratchBufferSize = img_cnt_data_scr_buf.size();
  isb_pars.pCounterDataScratchBuffer = &img_cnt_data_scr_buf[0];
  CU( cuptiProfilerCounterDataImageInitializeScratchBuffer(&isb_pars) );

  // beginSession(ProfilingData_t* pProfilingData)

  pCUpti_Profiler_BeginSession_Params bs_pars;
  bs_pars.ctx = nullptr;
  bs_pars.counterDataImageSize = img_cnt_data.size();
  bs_pars.pCounterDataImage = &img_cnt_data[0];
  bs_pars.counterDataScratchBufferSize = img_cnt_data_scr_buf.size();
  bs_pars.pCounterDataScratchBuffer = &img_cnt_data_scr_buf[0];
  bs_pars.range = profilerRange;
  bs_pars.replayMode = profilerReplayMode;
  bs_pars.maxRangesPerPass = numRanges;
  bs_pars.maxLaunchesPerPass = numRanges;

  const auto rv = cuptiProfilerBeginSession(&bs_pars);
  if ( rv == CUPTI_ERROR_INSUFFICIENT_PRIVILEGES )
    {
      printf
        ( "NPerf error: Insufficient privileges for event register use.\n"
          "  Hassle your system administrator.\n");
      return state_inited_session;
    }

  CU( rv );

  // setConfig(ProfilingData_t* pProfilingData)

  pCUpti_Profiler_SetConfig_Params setConfigParams;
  setConfigParams.pConfig = &img_config[0];
  setConfigParams.configSize = img_config.size();
  setConfigParams.passIndex = 0;
  CU( cuptiProfilerSetConfig(&setConfigParams) );
  return state_inited_session = true;
}

void
CP_Info::at_launch_before()
{
  assert( !state_pending_init_session );
  if ( !state_inited_session ) return;
  if ( profilerReplayMode == CUPTI_UserReplay )
    pCUpti_Profiler_BeginPass_Params{cuptiProfilerBeginPass};
  pCUpti_Profiler_EnableProfiling_Params{cuptiProfilerEnableProfiling};
}

void
CP_Info::at_launch_after()
{
  if ( !state_inited_session ) return;
  pCUpti_Profiler_DisableProfiling_Params{cuptiProfilerDisableProfiling};

  if ( profilerReplayMode == CUPTI_UserReplay )
    {
      pCUpti_Profiler_EndPass_Params endPassParams(cuptiProfilerEndPass);
      allPassesSubmitted = endPassParams.allPassesSubmitted == 1;
    }
  else if ( profilerReplayMode == CUPTI_KernelReplay )
    {
      allPassesSubmitted = true;
      if ( numRanges == 1 ) state_pending_init_session = true;
    }

  if ( allPassesSubmitted )
    pCUpti_Profiler_FlushCounterData_Params{cuptiProfilerFlushCounterData};
}

void
CP_Info::metrics_retrieve()
{
  if ( state_metrics_retrieved ) return;
  vector<NV::Metric::Eval::MetricNameValue> mvmap; // Not actually a map.
  NV::Metric::Eval::GetMetricGpuValue
    (chipName, img_cnt_data, metric_names_nvpw, mvmap);

  metric_values.clear();

  for ( auto& e: mvmap )
    {
      assert( e.numRanges == 1 );
      for ( auto& [name,val]: e.rangeNameMetricValueMap )
        metric_values[e.metricName] = val;
    }
  state_metrics_retrieved = true;
}

void
CP_Info::profiling_exit()
{
  pCUpti_Profiler_UnsetConfig_Params{cuptiProfilerUnsetConfig};
  pCUpti_Profiler_EndSession_Params{cuptiProfilerEndSession};
  pCUpti_Profiler_DeInitialize_Params{cuptiProfilerDeInitialize};
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
    cupti_on_requested = false;
    cupti_on_pending = false;
    cupti_on_failed = false;
    cupti_on = false;
    use_profiling_api = false;
    stop_tracing = false;
    event_tracing_user_on = true;
    context = NULL;
    dev = device_null;
    dev_idx = -1;
    call_trace_count = 0;
    call_trace_end = 0;
    call_trace_pause_level = 0;
    fake_fh_next = NULL;
    event_callbacks_inited = false;
    event_tracing_active = false;

    metrics_non_empty = false;

    device_data_collected = false;
    kernel_last = NULL;
    metrics_inited = false;
  };
  ~RT_Info(){
    for ( auto ki: kernel_info_store ) free(ki);
  }
  static int need_run_get_call_count;
  bool cupti_on_requested; // True if user wants CUPTI instrumentation. 
  bool cupti_on_pending;   // True if cupti is to be initialized.
  bool cupti_on; // True if CUPTI successfully initialized.
  bool cupti_on_failed;  // True if initialization tried and failed.
  bool metrics_non_empty; // True if at least one metric (prof or event) set up.
  bool use_profiling_api;
  bool event_callbacks_inited;
  bool stop_tracing;      // True if tracing was started unnecessarily.
  int call_trace_start, call_trace_count, call_trace_end;
  int call_trace_pause_level;
  CUpti_SubscriberHandle subscriber;
  CUfunction fake_fh_next;
  map<string,CUfunction> fake_fh_map;

  bool nperf_init_finish();
  bool cupti_assure_on()
  {
    if ( cupti_on_pending ) nperf_init_finish();
    return cupti_on;
  }
  bool cupti_check_on()
  {
    return cupti_on;
  }

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
  int dev_idx;
  CUcontext context;            // Make sure that only one context used.

  // GPU Characteristics
  bool device_data_collected;
  int numMultiprocessors;
  double clock_freq_hz;
  static const int gpu_name_size = 80;
  char gpu_name[gpu_name_size+1];
  int cc_major, cc_minor;
  int wp_lg;
  int wp_sz;
  int wp_mask;

  CP_Info cp_info;

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

  void context_set(CUcontext ctx = nullptr)
  {
    if ( context ) return;

    if ( !ctx )
      {
        CE( cuCtxGetCurrent(&ctx) );
        assert( ctx );
      }

    context = ctx;

    if ( dev == device_null ) CE( cuCtxGetDevice(&dev) );
    int n_dev;
    CE( cuDeviceGetCount(&n_dev) );
    for ( int i=0; i<n_dev; i++ )
      {
        CUdevice devi;
        CE( cuDeviceGet(&devi,i) );
        if ( devi != dev ) continue;
        dev_idx = i;
        break;
      }

    assert( dev_idx >= 0 );

    pCUpti_Device_GetChipName_Params getChipNameParams;
    getChipNameParams.deviceIndex = dev_idx;
    CU( cuptiDeviceGetChipName(&getChipNameParams) );
    cp_info.chipName = getChipNameParams.pChipName;
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
  context_set( cbdata->context );
  device_data_collect();

  metrics_init();

  if ( !event_tracing_user_on ) return;
  if ( !metrics_non_empty ) return;

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

  if ( use_profiling_api && metrics_non_empty )
    {
      cp_info.at_launch_before();
    }

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
  const CUcontext ctx = cbdata->context;
  assert( context == ctx );
  corr_to_h[correlation_id] = hfunc;

  if ( !event_tracing_user_on ) return;
  if ( !metrics_non_empty ) return;

  CE( cuCtxSynchronize() ); ///  SHOULD THIS BE AVOIDED??
  assert( event_tracing_active );
  event_tracing_active = false;
  uint64_t event_tracing_stop_timestamp;
  CU( cuptiDeviceGetTimestamp(context, &event_tracing_stop_timestamp) );
  const int64_t elapsed_raw =
    event_tracing_stop_timestamp - event_tracing_start_timestamp;

  if ( use_profiling_api && metrics_non_empty )
    cp_info.at_launch_after();

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
  assert( !use_profiling_api );

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

  rt_info->cupti_on_requested = turn_on; // Keeps this value until exit.
  rt_info->cupti_on_pending = turn_on;   // Set to false when init attempted.

  if ( !rt_info->cupti_on_pending ) return;

  // The code below must execute as early as possible, including
  // before any--ANY--CUDA API routines are called.

  CU(cuptiActivityEnable(CUPTI_ACTIVITY_KIND_DEVICE));
  CU(cuptiActivityEnable(CUPTI_ACTIVITY_KIND_KERNEL));

  // Cannot complete initialization until a device is chosen.
}

bool
RT_Info::nperf_init_finish()
{
  const CUptiResult err_reg_callbacks =
    cuptiActivityRegisterCallbacks(cb_buffer_requested,cb_buffer_completed);

  if ( err_reg_callbacks != CUPTI_SUCCESS )
    {
      cupti_on_failed = true;
      cupti_on_pending = false;
      cupti_on = false;
      const char *err_str;
      cuptiGetResultString(err_reg_callbacks, &err_str);
      printf
        ("Could not set up GPU event-register statistics: %s\n", err_str);

      cp_info.state_pending_init_metrics = false;
      cp_info.state_pending_init_session = false;
      assert( !cp_info.state_inited_metrics );
      assert( !cp_info.state_inited_session );

      return false;
    }

  CUptiResult cuptierr = cuptiSubscribe
    (&subscriber,(CUpti_CallbackFunc)traceCallback, (void*)rt_info);

  if ( cuptierr != CUPTI_SUCCESS )
    {
      // Actually, I don't expect this code to execute.
      CHECK_CUPTI_ERROR(cuptierr);
      return false;
    }

  CU(cuptiEnableDomain(1, subscriber, CUPTI_CB_DOMAIN_DRIVER_API));
  CU(cuptiEnableDomain(1, subscriber, CUPTI_CB_DOMAIN_RUNTIME_API));
  CU(cuptiEnableDomain(1, subscriber, CUPTI_CB_DOMAIN_RESOURCE));
  CU(cuptiEnableDomain(1, subscriber, CUPTI_CB_DOMAIN_SYNCHRONIZE));

  context_set();

  assert( dev != device_null );

  // Determine whether to use the profile or the event API.
  CE( cuDeviceGetAttribute
      (&cc_major,CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MAJOR,dev) );
  CE( cuDeviceGetAttribute
      (&cc_minor,CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MINOR,dev) );
  use_profiling_api = cc_major >= 7;

  if ( use_profiling_api )
    pCUpti_Profiler_Initialize_Params{cuptiProfilerInitialize};

  cupti_on_pending = false;
  cupti_on = true;
  return true;
}

void
RT_Info::metrics_init()
{
  assert( device_data_collected );
  cupti_check_on();
  if ( use_profiling_api )
    {
      cp_info.metrics_setup();
      metrics_non_empty = !cp_info.metric_names_nvpw.empty();
      cp_info.session_start();
      return;
    }

  if ( metrics_inited ) return;

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

  metrics_non_empty = !metric_ids.empty();

  if ( !metrics_non_empty )
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
  if ( !cupti_on_requested ) return false;
  if ( !cupti_assure_on() ) return false;

  if ( use_profiling_api )
    {
      cp_info.metric_names_user.push_back(name);
      return true;
    }

  if ( dev == device_null )
    {
      CUresult rv = cuCtxGetDevice(&dev);
      if ( rv == CUDA_ERROR_NOT_INITIALIZED )
        {
          fprintf(stderr,
                  "metric_add for %s called too early,"
                  " it must be called after CUDA initialized.\n",
                  name.c_str());
          exit(1);
        }
    }

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
  if ( !cupti_assure_on() ) return false;
  if ( !metrics_non_empty ) return false;
  if ( use_profiling_api && !cp_info.state_inited_session ) return false;

  RTI_Kernel_Info* const ki = kernel_get(kernel_name);
  if ( !ki && need_run_get_call_count > 0 )
    {
      fprintf(stderr, "NPerf: Problem hooking CUDA calls. Turning off.\n");
      cupti_on_failed = true;
      cupti_on = false;
      return false;
    }
  if ( !ki ) return need_run_get_call_count < 2;
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

  if ( use_profiling_api )
    if ( NPerf_Metric_Value npv =
         metric_value_get("gpu__cycles_elapsed.sum",ki);
         npv.status == NPerf_Status_OK && clock_freq_hz )
      return npv.d / clock_freq_hz;

  if ( ki->call_count_lite == 0 ) return -1;
  return 1e-9 * ki->elapsed_time_lite_ns / ki->call_count_lite;
}


NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, const char* kernel_name)
{
  if ( !cupti_check_on() ) return NPerf_Metric_Value(NPerf_Status_Off);
  return metric_value_get(metric_name, kernel_get(kernel_name));
}

NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, NPerf_Kernel_Data kd)
{
  if ( !cupti_check_on() ) return NPerf_Metric_Value(NPerf_Status_Off);
  return metric_value_get(metric_name, kernel_get(kd));
}

NPerf_Metric_Value
RT_Info::metric_value_get(const char *metric_name, RTI_Kernel_Info *ki)
{
  if ( !ki ) return NPerf_Metric_Value(NPerf_Status_Kernel_Not_Found);

  NPerf_Metric_Value npv(NPerf_Status_OK);
  npv.blocks = ki->api_block_count;
  npv.block_size = ki->api_block_size;
  npv.warps_per_block = ki->api_warps_per_block;

  if ( use_profiling_api )
    {
      if ( !metrics_non_empty ) return NPerf_Metric_Value(NPerf_Status_Off);
      if ( !cp_info.state_inited_session )
        return NPerf_Metric_Value(NPerf_Status_Off);
      string mname_user = metric_name;
      auto mii = cp_info.metric_user_to_nvpw.find(mname_user);
      if ( mii == cp_info.metric_user_to_nvpw.end() )
        return NPerf_Metric_Value(NPerf_Status_Metric_Not_Found);
      string mname = mii->second;
      cp_info.metrics_retrieve();
      if ( !cp_info.metric_values.count(mname) )
        return NPerf_Metric_Value(NPerf_Status_Error_Other);

      // Battle Short
      const double adj =
        mname_user == "l2_read_throughput"
        || mname_user == "l2_write_throughput" ? 32.0 : 1.0;

      npv.kind = CUPTI_METRIC_VALUE_KIND_DOUBLE;
      npv.d = cp_info.metric_values[mname] * adj;
      npv.metric_value.metricValueDouble = npv.d;
      return npv;
    }

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

  npv.kind = mi.kind;

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
  if ( !rt_info || !rt_info->cupti_assure_on() ) return false;
  if ( rt_info->use_profiling_api && !rt_info->cp_info.state_inited_session )
    return false;
  return rt_info->metrics_non_empty;
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

  if ( !cupti_on ) return 0;
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

