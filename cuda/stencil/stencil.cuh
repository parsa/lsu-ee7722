#ifndef STENCIL_CUH
#define STENCIL_CUH

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attrs, char **names);

__host__ void stencil_launch(dim3 dg, dim3 db, bool shared_kernel);

#endif
