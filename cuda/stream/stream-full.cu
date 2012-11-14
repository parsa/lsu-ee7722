
// Simple CUDA Example, without LSU ECE helper classes.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>


// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1, v2;
__constant__ int array_size;
__constant__ float *ax, *ay;
__constant__ float* b;

__global__ void dots();

 /// CUDA API Error-Checking Wrapper
///
#define CE(call)                                                              \
 {                                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess )                                                   \
     {                                                                        \
       printf("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));               \
       exit(1);                                                               \
     }                                                                        \
 }


__host__ int
main(int argc, char** argv)
{
  srand48(1);                   // Seed random number generator.
  const int size_lg = argc > 1 ? atoi(argv[1]) : 10;
  const int host_array_size = 1 << size_lg;

  // Allocate storage for CPU copy of data.
  //
  float *host_ax = (float*) malloc( host_array_size * sizeof(host_ax[0]) );
  float *host_ay = (float*) malloc( host_array_size * sizeof(host_ay[0]) );
  float *host_b = (float*) malloc( host_array_size * sizeof(host_b[0]) );

  // Allocate storage for GPU copy of data.
  //
  void *ax_dev, *ay_dev, *b_dev;
  CE(cudaMalloc(&ax_dev, host_array_size * sizeof(host_ax[0]) ));
  CE(cudaMalloc(&ay_dev, host_array_size * sizeof(host_ay[0]) ));
  CE(cudaMalloc(&b_dev, host_array_size * sizeof(host_b[0]) ));

  // Write GPU Scalar Variables
  //
  CE(cudaMemcpyToSymbol
     (ax, &ax_dev, sizeof(ax_dev), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     (ay, &ay_dev, sizeof(ay_dev), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     (b, &b_dev, sizeof(b_dev), 0, cudaMemcpyHostToDevice));

  // Initialize input array.
  //
  float xi = drand48(), yi = drand48();
  for ( int i=0; i<host_array_size; i++ )
    {
      host_ax[i] = xi; host_ay[i] = yi;
      xi += 0.1; yi += 0.1;
    }

  // Move input arrays to GPU.
  //
  CE(cudaMemcpy(ax_dev, host_ax, host_array_size * sizeof(host_ax[0]),
                cudaMemcpyHostToDevice));
  CE(cudaMemcpy(ay_dev, host_ay, host_array_size * sizeof(host_ay[0]),
                cudaMemcpyHostToDevice));

  // Initialize some more variables ...
  //
  const float host_v0 = drand48(), host_v1 = drand48(), host_v2 = drand48();

  // ... and send their values to GPU.
  //
  CE(cudaMemcpyToSymbol
     (v0, &host_v0, sizeof(host_v0), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     (v1, &host_v1, sizeof(host_v1), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     (v2, &host_v2, sizeof(host_v2), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     (array_size, &host_array_size, sizeof(host_array_size), 0,
      cudaMemcpyHostToDevice));

  // Specify Launch Configuration
  //
  dim3 db, dg;
  db.x = 64;          // Number of threads per block.
  db.y = db.z = 1;

  dg.x =              // Number of blocks.
    int(ceil(double(host_array_size) / db.x));
  dg.y = dg.z = 1;

  // Launch Kernel
  //
  dots<<<dg,db>>>();

  // Copy data from GPU to CPU.
  //
  CE(cudaMemcpy(host_b, b_dev, host_array_size * sizeof(host_b[0]),
                cudaMemcpyDeviceToHost));

  printf("Finished with %d elements, element %d is %.5f\n",
         host_array_size, argc, host_b[argc]);
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
  b[idx] = v0 + v1 * ax[idx] + v2 * ay[idx];
}



__global__ void
dots2()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = 
    threadIdx.x
    + threadIdx.y * blockDim.x
    + threadIdx.z * blockDim.x * blockDim.y
    + blockIdx.x * blockDim.x * blockDim.y * blockDim.z
    + blockIdx.y * blockDim.x * blockDim.y * blockDim.z * gridDim.x
    + blockIdx.z * blockDim.x * blockDim.y * blockDim.z * gridDim.x * gridDim.y;

  // Array size might not be a multiple of block size.
  //
  if ( idx >= array_size ) return;

  // Note: this will be improved.
  //
  b[idx] = v0 + v1 * ax[idx] + v2 * ay[idx];
}
