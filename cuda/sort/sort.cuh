#ifndef SORT_CUH
#define SORT_CUH

#undef DEBUG_SORT

struct pCUDA_Func_Attributes {
  const char *name;
  cudaError_t err;
  cudaFuncAttributes attr;
};

__host__ int kernels_get_attr(pCUDA_Func_Attributes **attr);
__host__ void sort_launch
(dim3 dg, dim3 db, int version, int array_size, int array_size_lg);

#endif
