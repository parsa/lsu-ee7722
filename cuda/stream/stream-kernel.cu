#include "stream.cuh"


// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1, v2;
__constant__ int array_size;
__constant__ Vector2* a;
__constant__ float* b;

__global__ void dots();

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
__global__ void
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

  // Note: this will be improved.
  //
  b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
}
