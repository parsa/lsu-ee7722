#ifndef SORT_CUH
#define SORT_CUH

#undef DEBUG_SORT

#include <gp/cuda-gpuinfo.h>

struct pCUDA_Func_Attributes {
  const char *name;
  cudaError_t err;
  cudaFuncAttributes attr;
};

__host__ void kernels_get_attr(GPU_Info *gpu_info);
__host__ int sort_launch
(dim3 dg, dim3 db, int version,
 int array_size, int array_size_lg, int elt_per_thread_lg = 2);

#endif
