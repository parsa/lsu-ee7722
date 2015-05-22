/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 1

 /// See stream-2.cc for instructions.

#include "stream-2.cuh"


// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1, v2;
__constant__ int array_size;
__constant__ Vector2* a;
__constant__ float* b;


// Declare Kernels
//
__global__ void dots_loopless();
__global__ void dots_stride_large();
__global__ void dots_stride_small();


__host__ cudaError_t
kernels_get_attr
(struct cudaFuncAttributes *attr, char **names, int max_count)
{
  // Return information about kernels.
  //
  // Information includes number of registers used.

  struct cudaFuncAttributes *attr_stop = attr + max_count;
  cudaError_t er = cudaSuccess; // Tentative.
#define GETATTR(func)                                                         \
  er = cudaFuncGetAttributes(attr,func); *names = #func; attr++; names++;     \
  if ( er || attr == attr_stop ) { *names = NULL; return er; }
  GETATTR(dots_loopless);
  GETATTR(dots_stride_large);
  GETATTR(dots_stride_small);
  *names = NULL;
  return er;
#undef GETATTR
}


 /// Homework 1: The routine below will have to be modfied for several problems.
 // 
__host__ void
dots_launch(dim3 dg, dim3 db)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  //  dots_loopless<<<dg,db>>>();
  dots_stride_large<<<dg,db>>>();
}

// This routine executes on the GPU.
//
__global__ void
dots_loopless()
{
  // Run the kernel for one iteration.  This only works
  // if the total number of threads is equal to the array size.

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


// This routine also executes on the GPU.
//
__global__ void
dots_stride_large()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx_start = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;
  int stride = thread_count;

  for ( int idx = idx_start; idx < array_size; idx += stride )
    b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}


 /// Homework 1: Modfiy this routine for one of the problems.
//
__global__ void
dots_stride_small()
{
  // Modify this routine so that a block accesses a contiguous
  // block of data.
  //
  int idx_start = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;
  int stride = thread_count;

  for ( int idx = idx_start; idx < array_size; idx += stride )
    b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}
