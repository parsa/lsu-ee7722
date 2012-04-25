#ifndef MATRIX_MULT_CUH
#define MATRIX_MULT_CUH

struct pCUDA_Func_Attributes {
  const char *name;
  cudaError_t err;
  cudaFuncAttributes attr;
};

__host__ int kernels_get_attr(pCUDA_Func_Attributes **attr);
__host__ void mmult_launch
(dim3 dg, dim3 db, int version, void *a_dev, void *b_dev, int array_size);

#endif
