#ifndef SORT_CUH
#define SORT_CUH

#undef DEBUG_SORT

#include <gp/cuda-gpuinfo.h>

typedef unsigned Sort_Elt;
const int elt_per_thread = 8;

inline __device__ __host__
int div_ceil(int a, int b){ return ( a + b - 1 ) / b; }

__host__ void kernels_get_attr(GPU_Info *gpu_info);

__host__ Kernel_Info*
sort_launch_pass_1
(GPU_Info *gpu_info, int dg, int db,
 int radix_lg, int digit_pos, bool first_iter);
__host__ Kernel_Info*
sort_launch_pass_2
(GPU_Info *gpu_info, int dg, int db, 
 int radix_lg, int digit_pos, bool last_iter);

struct Radix_Sort_GPU_Constants
{
  int array_size;               // Number of elements in array.
  int array_size_lg;            // ceil( log_2 ( array_size ) )

  int elt_per_tile;
  int num_tiles;
  int thisto_array_size_elts;
  int bhisto_array_size_elts;

  int radix_lg;
  int radix;
};


#endif
