/// LSU EE 7722 GPU Microarchitecture
//

#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>
#include <new>
#include <cuda_runtime.h>
#include "util.h"

#define N 4

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

struct __align__(16) Vertex
{
  Elt_Type __align__(16) a[N];
};

struct __align__(16) V4 {
  Elt_Type x, y, z, w;
};

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  int array_size;  // Number of vertices.
  Vertex *v_in, *v_out;
  Vertex *d_v_in, *d_v_out;
  V4 * d_v4_in;

  Elt_Type *thd_sum;
  Elt_Type *d_thd_sum;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

#define BLOCK_SIZE_MAX 1024
__shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];
__shared__ Elt_Type wshared_sum[32];

extern "C" __global__ void reduce_method_0();
extern "C" __global__ void reduce_method_1();
extern "C" __global__ void reduce_method_2();
extern "C" __global__ void reduce_method_3();
extern "C" __global__ void reduce_method_4();

__device__ Elt_Type d_sum_sum_of_sq;

__device__ Elt_Type
cuda_vtx_xform()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  // Compute element number to start at.
  //
  const int start = tid;
  const int stop = d_app.array_size;
  const int inc = d_app.num_threads;

  Elt_Type sum_sum_of_sq = 0;

  for ( int h=start; h<stop; h += inc )
    {
      V4 p2 = d_app.d_v4_in[h];
      Vertex p;
      p.a[0] = p2.x; p.a[1] = p2.y; p.a[2] = p2.z; p.a[3] = p2.w;
      Vertex q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p.a[j];
        }
      d_app.d_v_out[h] = q;

      //  Compute the magnitude squared of q and update "sum" variable.
      //
      Elt_Type sum_of_sq = 0;
      for ( int i=0; i<N; i++ ) sum_of_sq += q.a[i] * q.a[i];

      sum_sum_of_sq += sum_of_sq;
    }

  return sum_sum_of_sq;
}


extern "C" __global__ void
reduce_method_0()
{
  // No reduction performed by GPU.
  //
  // Each thread computes its own sum and writes it to global memory.
  // CPU computes sum of BG elements.
  //
  // Where: B is threads per block (blockDim.x)
  //        G is number of blocks (gridDim.x)
  //        Total number of threads is BG.

  const Elt_Type thd_sum = cuda_vtx_xform();
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  d_app.d_thd_sum[tid] = thd_sum;
}

extern "C" __global__ void
reduce_method_1()
{
  // Linear reduction by one thread per block.
  //
  // Each thread computes its own sum and writes it to shared memory.
  // One thread per block computes a block-wide sum and write it to global mem.
  //
  // G CPU threads each compute sum of B elements.
  // CPU computes sum of G elements.

  const Elt_Type thd_sum = cuda_vtx_xform();

  shared_sum[threadIdx.x] = thd_sum;  // Make sum available to thread 0.
  __syncthreads();

  if ( threadIdx.x != 0 ) return;

  Elt_Type our_sum = thd_sum;

  for ( int i=1; i<blockDim.x; i++ )
    our_sum += shared_sum[i];

  d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_atomic_sum_block()
{
  // Use an atomic add operating on a shared variable.

  const Elt_Type thd_sum = cuda_vtx_xform();
  __shared__ Elt_Type our_sum;

  if ( threadIdx.x == 0 ) our_sum = 0;

  __syncthreads();

  atomicAdd( &our_sum, thd_sum );

  __syncthreads();

  if ( threadIdx.x == 0 ) d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_atomic_sum_grid()
{
  // Use an atomic add operating on a global variable.

  const Elt_Type thd_sum = cuda_vtx_xform();

  atomicAdd( &d_app.d_thd_sum[0], thd_sum );

}

extern "C" __global__ void
reduce_method_2()
{
  // Use a reduction tree.
  //
  // By using a complete tree reduction we perform the minimum
  // number of adds. That's the good news. The bad news is that
  // we need to synchronize each iteration.
  //

  const Elt_Type thd_sum = cuda_vtx_xform();

  shared_sum[threadIdx.x] = thd_sum;  // Make sum available to other threads.
  Elt_Type our_sum = thd_sum;

  for ( int dist = blockDim.x >> 1;  dist;  dist >>= 1 )
    {
      __syncthreads();  // Wait for other threads to finish.
      if ( threadIdx.x < dist )
        {
          our_sum += shared_sum[ threadIdx.x + dist ];
          shared_sum[ threadIdx.x ] = our_sum;
        }
    }

  if ( threadIdx.x ) return;

  d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_method_3()
{
  // A mixture of a linear sum and a tree reduction, chosen so
  // that only a single warp of threads participates.  Since only
  // a single warp is executing, no synchronizations are necessary
  // other than the one after the thread's initial sum is written.

  const Elt_Type thd_sum = cuda_vtx_xform();

  shared_sum[threadIdx.x] = thd_sum;  // Make sum available to other threads.
  Elt_Type our_sum = thd_sum;

  __syncthreads();

  // In the code below, only the first 32 threads do something useful.

  const int warp_size = 32;
  const int half_warp_size = warp_size >> 1;

  // Perform a linear sum.
  //
  // The first 32 threads each compute their own sum.
  //
  if ( threadIdx.x < warp_size )
    for ( int i = threadIdx.x + warp_size;  i < blockDim.x;  i += warp_size )
      our_sum += shared_sum[i];

  shared_sum[threadIdx.x] = our_sum;

  // Perform a tree reduction.
  //
  // The first 32 threads perform a tree reduction of the linear sums
  // found in the previous step.
  //
  if ( threadIdx.x < half_warp_size )
    for ( int dist = half_warp_size;  dist;  dist >>= 1 )
      if ( threadIdx.x < dist )
        {
          our_sum += shared_sum[ threadIdx.x + dist ];
          shared_sum[ threadIdx.x ] = our_sum;
        }

  if ( threadIdx.x ) return;

  d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_method_4()
{
  const Elt_Type thd_sum = cuda_vtx_xform();

  shared_sum[threadIdx.x] = thd_sum;

  Elt_Type our_sum = thd_sum;

  const int warp_lg = 5;
  const int warp_size = 1 << warp_lg;
  const int half_warp_size = warp_size >> 1;
  const int lane = threadIdx.x & ( warp_size - 1 );

  for ( int dist = half_warp_size;  dist;  dist >>= 1 )
    if ( lane < dist )
      {
        our_sum += shared_sum[ threadIdx.x + dist ];
        shared_sum[ threadIdx.x ] = our_sum;
      }

#if 1

  const int warp_num = threadIdx.x >> warp_lg;

  if ( !lane )
    wshared_sum[ warp_num ] = our_sum;

  __syncthreads();

  Elt_Type our_osum = 0;

  if ( threadIdx.x < half_warp_size )
    {
      our_osum = wshared_sum[ threadIdx.x ];

      for ( int dist = half_warp_size;  dist;  dist >>= 1 )
        if ( lane < dist )
          {
            our_osum += wshared_sum[ threadIdx.x + dist ];
            if ( dist > 1 )
              wshared_sum[ threadIdx.x ] = our_osum;
          }

    }

#else

  __syncthreads();

  const int our_elt = threadIdx.x << warp_lg;
  const int block_size = blockDim.x;
  Elt_Type our_osum = threadIdx.x < warp_size ? shared_sum[ our_elt ] : 0;

  for ( int dist = block_size >> 1;  dist >= warp_size;  dist >>= 1 )
      if ( our_elt < dist )
        {
          our_osum += shared_sum[ our_elt + dist ];
          shared_sum[ our_elt ] = our_osum;
        }

#endif

  if ( threadIdx.x ) return;

  d_app.d_thd_sum[blockIdx.x] = our_osum;
}

extern "C" __global__ void
reduce_method_5()
{
  const Elt_Type thd_sum = cuda_vtx_xform();

  shared_sum[threadIdx.x] = thd_sum;  // Make sum available to other threads.
  Elt_Type our_sum = thd_sum;

  __syncthreads();

  // In the code below, only the first 32 threads do something useful.

  const int warp_size = 32;
  const int half_warp_size = warp_size >> 1;

  // Perform a linear sum.
  //
  // The first 32 threads each compute their own sum.
  //
  if ( threadIdx.x < warp_size )
    for ( int i = threadIdx.x + warp_size;  i < blockDim.x;  i += warp_size )
      our_sum += shared_sum[i];

  __all ( our_sum > 1.23 );

  // Perform a tree reduction.
  //
  // The first 32 threads perform a tree reduction of the linear sums
  // found in the previous step.
  //
  if ( threadIdx.x < half_warp_size )
    for ( int dist = half_warp_size;  dist;  dist >>= 1 )
      if ( threadIdx.x < dist )
        {
          our_sum += shared_sum[ threadIdx.x + dist ];
          shared_sum[ threadIdx.x ] = our_sum;
        }

  if ( threadIdx.x ) return;

  d_app.d_thd_sum[blockIdx.x] = our_sum;
}


GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  print_gpu_info();

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(reduce_method_0);
  info.GET_INFO(reduce_method_1);
  info.GET_INFO(reduce_atomic_sum_block);
  info.GET_INFO(reduce_atomic_sum_grid);
  info.GET_INFO(reduce_method_2);
  info.GET_INFO(reduce_method_3);
  info.GET_INFO(reduce_method_4);
  //  info.GET_INFO(reduce_method_5);

  // Print information about kernel.
  //
  printf("\nCUDA Kernel Resource Usage:\n");

  for ( int i=0; i<info.num_kernels; i++ )
    {
      printf("For %s:\n", info.ki[i].name);
      printf("  %6zd shared, %zd const, %zd loc, %d regs; "
             "%d max threads per block.\n",
             info.ki[i].cfa.sharedSizeBytes,
             info.ki[i].cfa.constSizeBytes,
             info.ki[i].cfa.localSizeBytes,
             info.ki[i].cfa.numRegs,
             info.ki[i].cfa.maxThreadsPerBlock);
    }
  return info;
}


int
main(int argc, char **argv)
{
  // Examine argument 1, block count.
  //
  const int arg1_int = argc < 2 ? 3 * 16 : atoi(argv[1]);
  const int num_blocks = abs(arg1_int);

  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block = argc < 3 ? 1024 : atoi(argv[2]);
  app.num_threads = num_blocks * thd_per_block;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  const int sum_array_size = app.num_threads;

  if ( app.num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.v_out = new Vertex[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  app.array_size * sizeof(Vertex) ) );
  CE( cudaMalloc( &app.d_v_out, app.array_size * sizeof(Vertex) ) );
  app.d_v4_in = (V4*) app.d_v_in;

  //  Allocate storage on CPU and GPU for the minimum magnitude (sq) and
  //  its index.
  //
  app.thd_sum = new Elt_Type[sum_array_size];
  CE( cudaMalloc( &app.d_thd_sum, sum_array_size * sizeof(Elt_Type) ) );

  // Initialize device memory to zeros. Helps catch bugs.
  //
  CE( cudaMemset( app.d_thd_sum, 0, sum_array_size*sizeof(Elt_Type) ) );

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<N; j++ ) app.v_in[i].a[j] = drand48();

  // Initialize transformation matrix.
  //
  for ( int i=0; i<N; i++ )
    for ( int j=0; j<N; j++ )
      app.matrix[i][j] = drand48();

  // Compute correct answer.
  double cpu_grand_sum = 0;

  for ( int h=0; h<app.array_size; h++ )
    {
      Vertex p = app.v_in[h];
      Vertex q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      Elt_Type sos = 0; for(int i=0; i<N; i++ ) sos+= q.a[i]*q.a[i];
      cpu_grand_sum += sos;
    }

    {
      // Prepare events used for timing.
      //
      cudaEvent_t gpu_start_ce, gpu_stop_ce;
      CE(cudaEventCreate(&gpu_start_ce));
      CE(cudaEventCreate(&gpu_stop_ce));

      // Copy input array from CPU to GPU.
      //
      CE( cudaMemcpy
          ( app.d_v_in, app.v_in, array_size_bytes, cudaMemcpyHostToDevice ) );

      // Copy App structure to GPU.
      //
      CE( cudaMemcpyToSymbol
          ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

      // Launch kernel multiple times and keep track of the best time.
      printf("Launching with %d blocks of %d threads ...\n",
             num_blocks, thd_per_block);

      for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
        {
          const int samples = 10;
          double elapsed_time_s = 86400; // Reassigned to minimum run time.
          double elapsed_time_sum = 0;

          for ( int s=0; s<samples; s++ )
            {

              CE(cudaMemset(app.d_thd_sum,0,sizeof(Elt_Type)*sum_array_size));

              // Measure execution time starting "now", which is after data
              // set to GPU.
              //
              CE(cudaEventRecord(gpu_start_ce,0));

              // Launch Kernel
              //
              info.ki[kernel].func_ptr<<<num_blocks,thd_per_block>>>();

              // Stop measuring execution time now, which is before is data
              // returned from GPU.
              //
              CE(cudaEventRecord(gpu_stop_ce,0));
              CE(cudaEventSynchronize(gpu_stop_ce));
              float cuda_time_ms = -1.1;
              CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

              const double this_elapsed_time_s = cuda_time_ms * 0.001;
              if ( s ) elapsed_time_sum += this_elapsed_time_s;
              elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);
            }

          printf("%-26s   %11.3f µs min, %11.3f µs avg.\n",
                 info.ki[kernel].name,
                 elapsed_time_s * 1e6,
                 elapsed_time_sum * 1e6 / (samples-1));

          //  Copy back per-thread sums.
          //
          CE( cudaMemcpy
              ( app.thd_sum, app.d_thd_sum,
                sizeof(Elt_Type) * sum_array_size, cudaMemcpyDeviceToHost) );

          const int sum_array_used = kernel == 0 ? app.num_threads : num_blocks;

          // Find the sum of each thread or block's sum.
          //
          Elt_Type grand_sum = 0;
          for ( int i=0; i<sum_array_used; i++ )
            grand_sum += app.thd_sum[i];

          Elt_Type diff = fabs(grand_sum-cpu_grand_sum) / app.array_size;
          const bool correct = diff < 1e-5;
          if ( !correct )
          printf
            ("Sum is %s,  %.1f %s %.1f (correct)\n",
             correct ? "correct" : "**wrong**",
             grand_sum,
             grand_sum == cpu_grand_sum ? "==" : diff < 1e-5 ? "~" : "!=",
             cpu_grand_sum
             );
        }
    }

  // Copy output array from GPU to CPU.
  //
  CE( cudaMemcpy
      ( app.v_out, app.d_v_out, array_size_bytes, cudaMemcpyDeviceToHost) );
  
}
