/// LSU EE 7722 GPU Microarchitecture
//
 /// Simple, Self-Contained, One-File CUDA Example

 /// How to Compile from the Command Line
//
//   nvcc -o cuda cuda.cu -O3 -Xcompiler -Wall

 /// Documentation
//
//   CUDA: http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html
//   C++:  http://en.cppreference.com/w/

#include <stdio.h>
#include <cuda_runtime.h>
#include <vector>
using namespace std;


 /// Declaration of Kernel (Entry point for code running on GPU.)
//
// Note: the attribute __global__ indicates that the procedure is
// started by a kernel launch. A GPU-only procedure would use the
// attribute __device__ and a CPU-only procedure would use the
// attribute __host__.
//
__global__ void
thread_main(int size, float *x, float *a, float *b)
{
  // Variables threadIdx, blockIdx, and blockDim are pre-set.
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
  if ( idx >= size ) return;

  a[idx] = idx + blockIdx.x;
  b[idx] = float(blockIdx.x) / (idx+1);

  // Perform Computation
  //
  x[idx] = a[idx] + b[idx];
}


__host__ int
main(int argc, char** argv)
{
  const int SIZE = 100000000;

  // Declare host arrays for inputs and output.
  //
  vector<float> a(SIZE);
  vector<float> b(SIZE);
  vector<float> x(SIZE);

  // Compute size of each array.
  //
  const int array_size_chars = a.size() * sizeof(a[0]);

  // Allocate storage for GPU copy of data.
  //
  // The address of the allocated storage is returned in the first
  // argument, a_dev, etc. The addresses are in GPU global space and
  // so they are not necessarily valid on the CPU.
  //
  void *a_dev, *b_dev, *x_dev;
  cudaMalloc( &a_dev, array_size_chars );
  cudaMalloc( &b_dev, array_size_chars );
  cudaMalloc( &x_dev, array_size_chars );

  // Specify Launch Configuration
  //
  const int db = 64;        // Number of threads per block.

  // Choose grid size so that there is at least one thread per array
  // element.
  //
  const int dg = (SIZE + db - 1 ) / db;

  // Launch Kernel
  //
  thread_main<<<dg,db>>>(SIZE, x.data(), a.data(), b.data());

  // Copy data from GPU to CPU.
  //
  cudaMemcpy( x.data(), x_dev, array_size_chars, cudaMemcpyDeviceToHost );

  printf("Finished with %d elements, element %d is %.5f\n",
         SIZE, argc, x[argc]);

  cudaFree( a_dev );
  cudaFree( b_dev );
  cudaFree( x_dev );
}
