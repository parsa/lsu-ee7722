#ifndef SOL_CUH
#define SOL_CUH

struct pCUDA_Func_Attributes {
  const char *name;
  char abbrev; // Used to index switch statements.
  cudaError_t err;
  cudaFuncAttributes attr;
};

__host__ int kernels_get_attr(pCUDA_Func_Attributes **attr);

__host__ void stencil_launch(dim3 dg, dim3 db, int shared_bytes, char version);

#endif
