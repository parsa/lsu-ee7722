/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 1 -- SOLUTION

 /// Search for SOLUTION to see parts that were changed.

 /// See stream-2.cc for instructions.

#include "solution.cuh"


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
dots_launch(dim3 dg, dim3 db, char version, int array_size)
{
  /// SOLUTION -- Problems 3 and 4
  //
  //  This routine modified so that it can call either dots_loopless,
  //  dots_stride_large, and dots_stride_small.  The routine that's
  //  called depends on the new argument version.

#if ALTERNATE_SOL
  /// SOLUTION -- Problem 3
  //
  //  This could be a solution to Problem 3, but this code doesn't use
  //  it. Instead, version is set to 'n' by the caller of dots_launch.
  
  int thread_count = dg.x * db.x;
  if ( thread_count >= array_size ) version = 'n';
#endif

  switch ( version ) {
  case 'n': dots_loopless<<<dg,db>>>(); break;
  case 'l': dots_stride_large<<<dg,db>>>(); break;
  case 's': dots_stride_small<<<dg,db>>>(); break;
  }
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
  /// SOLUTION -- Problem 4
  //
  //  First, determine how many array elements each block should
  //  access:
  //
  int elt_per_block = ceilf( float(array_size) / gridDim.x );

  //  Determine the first and last+1 element to be accessed by this
  //  block (blockIdx.x).
  //
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_block_stop = min(array_size, idx_block_start + elt_per_block);

  //  Determine the first element to be accessed by this thread.
  //
  int idx_start = idx_block_start + threadIdx.x;
  //
  //  Note that because idx_start includes a "+ threadIdx.x" term
  //  consecutive threads will access consecutive array elements, which is
  //  necessary to construct fully occupied memory transactions.

  //  Determine how far ahead to skip each iteration.
  //
  int stride = blockDim.x;
  //
  // Note that the largest value of threadIdx.x is blockDim.x-1.

  for ( int idx = idx_start; idx < idx_block_stop; idx += stride )
    b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}
