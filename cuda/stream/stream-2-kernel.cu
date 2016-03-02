#include "stream-2.cuh"
#include <gp/cuda-util-kernel.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1, v2;
__constant__ int array_size;
__constant__ Vector2* a;
__constant__ float* b;

extern "C" __global__ void dots();
extern "C" __global__ void dots_iterate1();
extern "C" __global__ void dots_iterate2();
extern "C" __global__ void dots_iterate3();

// This routine executes on the CPU.
//
__host__ void
dots_launch(dim3 dg, dim3 db)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  dots<<<dg,db>>>();
}

// This routine executes on the GPU.
//
extern "C" __global__ void
dots()
{
  // Variable threadIdx, blockIdx, and blockDim pre-set.
  //

  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  //        Idx within    Idx of       Block size.
  //        a block.      block.
  //        Can be 0      Can be
  //        to block      from 0
  //        size -1       to # of
  //                      blocks.

  // Array size might not be a multiple of block size.
  //
  if ( idx >= array_size ) return;

  b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}

// This routine executes on the CPU.
//
__host__ void
dots_iterate_launch(dim3 dg, dim3 db, int kernel)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  switch ( kernel ) {
  case 0: dots_iterate1<<<dg,db>>>(); break;
  case 1: dots_iterate2<<<dg,db>>>(); break;
  case 2: dots_iterate3<<<dg,db>>>(); break;
  }
}

// This routine also executes on the GPU.
//
extern "C" __global__ void
dots_iterate1()
{
  // This is the preferred way of iterating over array elements
  // because consecutive threads access consecutive elements.

  int thread_count = blockDim.x * gridDim.x;
  int idx_start = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int idx = idx_start; idx < array_size; idx += thread_count )
    b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}

extern "C" __global__ void
dots_iterate2()
{
  // This method is less efficient.

  int thread_count = blockDim.x * gridDim.x;
  int elt_per_thread = array_size / thread_count;
  int idx_start = ( threadIdx.x + blockIdx.x * blockDim.x ) * elt_per_thread;
  int idx_stop = idx_start + elt_per_thread;

  for ( int idx = idx_start; idx < idx_stop; idx++ )
    b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;

}


// This routine also executes on the GPU.
//
extern "C" __global__ void
dots_iterate3()
{
#define chunk 32
#define degree 4

  const int thread_count = blockDim.x * gridDim.x;
  int idx_start = threadIdx.x + degree * blockIdx.x * blockDim.x;

  for ( int idx = idx_start; idx < array_size; idx += degree * thread_count )
    {
      for ( int i=0; i<degree; i++ )
        b[idx+i*chunk] = v0 + v1 * a[idx+i*chunk].x + v2 * a[idx+i*chunk].y;
    }
}


//
// Code for collecting information about kernels (routines above).
//

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attr, char **names, int max_count)
{
  struct cudaFuncAttributes *attr_stop = attr + max_count;
  cudaError_t er = cudaSuccess; // Tentative.

  CU_SYM(a); CU_SYM(b);
  CU_SYM(array_size);
  CU_SYM(v0); CU_SYM(v1); CU_SYM(v2);

#define GETATTR(func)                                                         \
  er = cudaFuncGetAttributes(attr,func); *names = #func; attr++; names++;     \
  if ( er || attr == attr_stop ) { *names = NULL; return er; }
  GETATTR(dots);
  GETATTR(dots_iterate1);
  GETATTR(dots_iterate2);
  GETATTR(dots_iterate3);
  *names = NULL;
  return er;
#undef GETATTR
}

