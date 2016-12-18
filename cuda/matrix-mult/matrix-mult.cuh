#ifndef MATRIX_MULT_CUH
#define MATRIX_MULT_CUH

#include <gp/cuda-gpuinfo.h>

__host__ void kernels_get_attr(GPU_Info& gpu_info);
__host__ void mmult_launch
(dim3 dg, dim3 db, int version, void *a_dev, void *b_dev, int array_size);

#endif
