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
(dim3 dg, dim3 db, int array_size, int array_size_lg);

struct Radix_Sort_GPU_Constants
{
  int array_size;               // Number of elements in array.
  int array_size_lg;            // ceil( log_2 ( array_size ) )

  int sort_bin_lg;
  int sort_bin_size;
  int sort_bin_mask;
  int sort_bin_count;
  int sort_all_bin_count;
  int sort_all_bin_lg;
};


#endif
