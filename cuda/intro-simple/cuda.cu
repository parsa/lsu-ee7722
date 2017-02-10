/// LSU EE 7722 GPU Microarchitecture
//
 /// Simple CUDA Example, without LSU ECE helper classes.

// How to Compile From Emacs
//
//  Within Emacs, as set up for class, compile by pressing [F9].
//
// How to Compile from the Command Line
//
//   Simplest
//     nvcc cuda.cu
//
//   Reasonable
//     nvcc -o cuda cuda.cu  -O3 -g -Xcompiler -Wall

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>

 /// Declaration of Kernel (Entry point for code running on GPU.)
//
__global__ void thread_main();
//
// Note: the attribute __global__ indicates that the procedure is
// started by a kernel launch. A GPU-only procedure would use the
// attribute __device__ and a CPU-only procedure would use the
// attribute __host__.


// This routine executes on the GPU.
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

  // Perform Computation
  //
  x[idx] = a[idx] + b[idx];
}


 /// CUDA API Error-Checking Wrapper
///
#define CE(call) {                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess ) {                                                 \
     printf("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));  exit(1);}}


__host__ int
main(int argc, char** argv)
{
  srand48(1);                   // Seed random number generator.

  // Declare host arrays for inputs and output.
  //
  vector<float> a(SIZE);
  vector<float> b(SIZE);
  vector<float> x(SIZE);

  // Allocate storage for GPU copy of data.
  //
  // The returned addresses are in GPU global space. They are not
  // valid addresses on the CPU.
  //
  void *a_dev, b_dev, x_dev;
  CE(cudaMalloc(&a_dev, host_array_size * sizeof(a[0]) ));
  CE(cudaMalloc(&b_dev, host_array_size * sizeof(b[0]) ));
  CE(cudaMalloc(&x_dev, host_array_size * sizeof(x[0]) ));

  // Initialize input array.
  //
  float xi = drand48(), yi = drand48();
  for ( int i=0; i<host_array_size; i++ )
    {
      a[i] = xi; b[i] = yi;
      xi += 0.1; yi += 0.1;
    }

  // Move input arrays to GPU.
  //
  CE(cudaMemcpy(a_dev, a.data(), host_array_size * sizeof(a[0]),
                cudaMemcpyHostToDevice));
  CE(cudaMemcpy(b_dev, b.data(), host_array_size * sizeof(b[0]),
                cudaMemcpyHostToDevice));

  // Specify Launch Configuration
  //
  dim3 db, dg;
  db.x = 64;          // Number of threads per block in x dimension.
  db.y = db.z = 1;    // Number of threads per block in y and z dimensions.

  // Choose grid size so that there is at least one thread per array
  // element.
  //
  dg.x = (SIZE + db.x - 1 ) / db.x;
  dg.y = dg.z = 1;

  // Launch Kernel
  //
  dots<<<dg,db>>>(SIZE, x.data(), a.data(), b.data());

  // Copy data from GPU to CPU.
  //
  CE(cudaMemcpy(x.data(), x_dev, host_array_size * sizeof(x[0]),
                cudaMemcpyDeviceToHost));

  printf("Finished with %d elements, element %d is %.5f\n",
         host_array_size, argc, x[argc]);
}

