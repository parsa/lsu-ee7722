#ifndef SORT_CUH
#define SORT_CUH

#undef DEBUG_SORT

#include <gp/cuda-gpuinfo.h>

typedef unsigned Sort_Elt;
const int elt_per_thread = 4;

inline __device__ __host__
int div_ceil(int a, int b){ return ( a + b - 1 ) / b; }

__host__ void kernels_get_attr(GPU_Info *gpu_info);

__host__ void
sort_launch_pass_1
(int dg, int db, int radix_lg, int digit_pos, bool first_iter);
__host__ void
sort_launch_pass_2
(int dg, int db, int radix_lg, int digit_pos, bool last_iter);

struct Radix_Sort_GPU_Constants
{
  int array_size;               // Number of elements in array.
  int array_size_lg;            // ceil( log_2 ( array_size ) )

  int sort_radix_lg;
  int sort_radix;
};


#endif
