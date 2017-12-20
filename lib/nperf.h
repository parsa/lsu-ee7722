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

void NPerf_init(bool turn_on = true);
void NPerf_atend();

int NPerf_min_launches_get(); 
void NPerf_data_reset();

bool NPerf_metrics_collection_get();
bool NPerf_metrics_collection_set(bool setting);
bool NPerf_metrics_on();
bool NPerf_metrics_off();

bool NPerf_metric_collect(const char *name);
NPerf_Status NPerf_metric_data_status(const char* kernel_name = NULL);
bool NPerf_need_run_get(const char* kernel_name = NULL);
const char* NPerf_kernel_last_name_get();
double NPerf_kernel_et_get(const char *kernel_name = NULL);
int NPerf_kernel_nlaunches_get(const char *kernel_name = NULL);
double NPerf_metric_value_get
(const char* metric_name, const char *kernel_name = NULL);
double NPerf_metric_value_per_warp_get
(const char* metric_name, const char *kernel_name = NULL);
double NPerf_metric_value_per_thread_get
(const char* metric_name, const char *kernel_name = NULL);

#endif
