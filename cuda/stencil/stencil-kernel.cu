#include "stencil.cuh"
#include <gp/cuda-util-kernel.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1;
__constant__ int array_size;
__constant__ float* a;
__constant__ float* b;
extern __shared__ float s[]; // Shared memory for buffering a elements.

__global__ void stencil();
__global__ void stencil_iter();
__global__ void stencil_shared();

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attr, char **names)
{
  // Return attributes of kernels, such as number of registers
  // used.

  cudaError_t er;

  CU_SYM(a); CU_SYM(b);
  CU_SYM(array_size);
  CU_SYM(v0); CU_SYM(v1);

#define GETATTR(func)                                                         \
  er = cudaFuncGetAttributes(attr,func); *names = #func; attr++; names++;     \
  if ( er ) return er;
  GETATTR(stencil);
  GETATTR(stencil_iter);
  GETATTR(stencil_shared);
  *names = NULL;
  return er;
#undef GETATTR
}

__host__ void
stencil_launch(dim3 dg, dim3 db, bool shared_kernel)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  // stencil<<<dg,db>>>();

  int shared_amt = (db.x + 2) * sizeof(float);

  if ( shared_kernel )
    stencil_shared<<<dg,db,shared_amt>>>();
  else
    stencil_iter<<<dg,db>>>();
}

__global__ void
stencil()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

  if ( idx >= array_size ) return;

  b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] );
}

__global__ void
stencil_iter()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;

  for ( int idx = tid;  idx < array_size;  idx += thread_count )
    {
      b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] );
    }
}

__global__ void
stencil_shared()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;

  int bl_idx = blockDim.x - 1;
  int sidx = threadIdx.x + 1;

  __shared__ float s[1024];

  for ( int idx = tid;  idx < array_size;  idx += thread_count )
    {
      // Load shared memory with a values.
      //
      float a_0 = a[idx];
      s[sidx] = a_0;

      // Two lucky threads per block get to preload a second element.
      //
      if ( threadIdx.x == 0 )
        s[0] = a[idx-1];
      if ( threadIdx.x == bl_idx )
        s[blockDim.x+1] = a[idx+1];

      // Wait for everyone to finish.
      //
      //  __syncthreads();

      // Note that values read from a register or shared memory.
      //
      b[idx] = v0 * a_0 + v1 * ( s[sidx-1] + s[sidx+1] );
    }
}

