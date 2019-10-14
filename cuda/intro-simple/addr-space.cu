/// LSU EE 7722 GPU Microarchitecture
//
 /// Simple, Self-Contained, One-File CUDA Example

 /// How to Compile from the Command Line
//
//   nvcc -o addr-space addr-space.cu -O3 -Xcompiler -Wall

 /// Documentation
//
//   CUDA: http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html
//   C++:  http://en.cppreference.com/w/

#include <stdio.h>
#include <cuda_runtime.h>
#include <vector>
using namespace std;

#if 0
/// Address Spaces

 // - Global
 // - Constant
 // - Shared
 // - Local


/// Global Address Space

 /// Size:  32- or 64-bit address space.  Matches size used by host OS, usually 64 bits.

 /// Scope:
 //
 //   Single space shared by all threads.
 //   Readable and writeable by all threads and host.
 //   Difficult to use for sharing of data.

 /// Latency, Bandwidth
 //
 //  Cases
 //    - Off-Chip Access. (Most common.)
 //    - L2 Cache Hit.  (Fairly common. Possible through Volta [CC 7.x])
 //    - L1 Cache Hit.  (Depends on CC.  Possible in CC 2.x, 7.0)
 //    - Texture Cache Hit. (Depends on CC.)

 //  Off-Chip Access
 //    - Latency hundreds of cycles. Course default: 400 cycles.
 //    - Limited by off-chip bandwidth. 400 GB/s for high-end devices. (2018)
 //    

 /// Declaration
 //
 //  In global scope:
 //
 //  :Syntax:  __device__ TYPE VARNAME;
 //  :Sample:  __device__ double mydata[1000];
 //
 //  Note: Sample above shows *static* allocation of global space.
 //        In most cases dynamic allocation is used.


 /// Dynamic Allocation on Host
 //
 //  :Syntax: cudaMalloc( PTR, AMT_CHARS );
 //  Allocates AMT_CHARS bytes of storage in global space,
 //  and puts address of that storage in PTR.
 //


 /// Transfer Between CPU and GPU (Either Direction)
 //
 //  :Syntax: cudaMemcpy( DST_PTR, SRC_PTR, SZ_CHARS, cudaMemcpyHostToDevice );
 //  Copies SZ_CHARS bytes 
 //  from the CPU (host) starting at address SRC_PTR
 //  to the GPU (device) starting at address DST_PTR, where
 //  SRC_PTR is an address in the CPU address space and
 //  DST_PTR is an address in the GPU global address space.
 //
 //  :Syntax: cudaMemcpy( DST_PTR, SRC_PTR, SZ_CHARS, cudaMemcpyDeviceToHost );
 //  Copies SZ_CHARS bytes 
 //  from the GPU (device) starting at address SRC_PTR
 //  to the CPU (host) starting at address DST_PTR, where
 //  SRC_PTR is an address in the GPU global address space and
 //  DST_PTR is an address in the CPU address space.

 /// Short Example

const int size = 1024 * 32;
__device__ float a[size];
__device__ float b[size];

__global__ void thread_main(float *x)
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

  a[idx] = idx + blockIdx.x;
  b[idx] = float(blockIdx.x) / (idx+1);
  x[idx] = a[idx] + b[idx];
}

__host__ int main(int argc, char** argv)
{
  void *x_dev;
  cudaMalloc( &x_dev, size * sizeof(x_dev[0]) );

  thread_main<<<32,1024>>>(x_dev);

  // Copy data from GPU to CPU.
  //
  float x[size];
  cudaMemcpy( x, x_dev, size * sizeof(x[0]), cudaMemcpyDeviceToHost );
}


/// Constant Address Space

 /// Size 64 kiB ( 16-bit address space )

 /// Scope
 //
 //   Single space shared by all threads.
 //   Readable by all threads.
 //   Cannot be written by threads.
 //   Writeable from CPU.

 /// Declaration
 //
 //  In global scope:
 //
 //  :Syntax:  __constant__ TYPE VARNAME;
 //  :Sample:  __constant__ int my_int_var;

 /// Transfer Between CPU and GPU
 //
 // :Syntax: cudaMemcpyToSymbol(DST_SYM, SRC_PTR, SZ_CHARS, OFF, cudaMemcpyHostToDevice );
 // Copy SZ_CHARS from CPU starting at address SRC_PTR + OFF
 // to GPU symbol DST_SYM, which can be in constant address space.


 /// Short Example

__constant__ int d_size;
__constant__ float *d_x;

__device__ float a[size];
__device__ float b[size];

__global__ void thread_main()
{
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

  if ( idx >= d_size ) return;

  a[idx] = idx + blockIdx.x;
  b[idx] = float(blockIdx.x) / (idx+1);
  d_x[idx] = a[idx] + b[idx];
}


__host__ int main(int argc, char** argv)
{
  int size = 1024 * 32;
  void *x_dev;
  cudaMalloc( &x_dev, size * sizeof(x_dev[0]) );

  cudaMemcpyToSymbol
    ( d_size, &size, sizeof(size), 0, cudaMemcpyHostToDevice )
  cudaMemcpyToSymbol
    ( d_x, &x_dev, sizeof(x_dev), 0, cudaMemcpyHostToDevice )

  thread_main<<<32,1024>>>();

  // Copy data from GPU to CPU.
  //
  float x[size];
  cudaMemcpy( x, x_dev, size * sizeof(x[0]), cudaMemcpyDeviceToHost );
}


/// Shared Address Space

 /// Size 48 kiB  (Before CC 7.0)   

 /// Scope
 //
 //   Each block has its own shared address space.
 //   Shared address space shared by all threads within a block.
 //   Readable and writeable by threads.


 /// Declaration
 //
 //  In global or procedure scope
 //
 //  :Syntax:  __shared__ TYPE VARNAME;
 //  :Sample:  __shared__ int my_int_var;

 /// Transfer Between CPU and GPU
 //
 //  Not easily accomplished.


/// Local Address Space

 /// Size 512 kiB per thread.

 /// Scope
 //
 //  Each thread has its own local address space.

 /// Declaration
 //
 //  In procedure scope declared without a qualifier:
 //
 //  :Syntax:  TYPE VARNAME;
 //  :Sample:  float my_array[20];

 /// Implementation  <- IMPORTANT
 //
 //  Registers, If Possible
 //  Some L1 cache, depending on CC.
 //  L2, device memory.
 //




#endif


__device__ int size_d;
__constant__ int size_c;
__shared__ int size_s;


 /// Declaration of Kernel (Entry point for code running on GPU.)
//
// Note: the attribute __global__ indicates that the procedure is
// started by a kernel launch. A GPU-only procedure would use the
// attribute __device__ and a CPU-only procedure would use the
// attribute __host__.
//
__global__ void
thread_main(float *x, float *a, float *b)
{
  // Variables threadIdx, blockIdx, and blockDim are pre-set.
  //

  int size = size_c;

  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

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
