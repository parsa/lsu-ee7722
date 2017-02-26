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
#include <vector>
#include <algorithm>
#include <cuda_runtime.h>
#include "util.h"
using namespace std;

// Make it easy to switch between different types for array elements.
// Note: Using a float can cause rounding errors in reduce_iter_atomic_grid.
//
typedef int Elt_Type;


struct App
{
  int array_size;
  Elt_Type *v_in;
  Elt_Type *d_v_in;

  Elt_Type *thd_sum;
  Elt_Type *d_thd_sum;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

#define BLOCK_SIZE_MAX 1024


__device__ Elt_Type
reduce_thread()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  // Unroll degree.
  const int deg = 8;

  // Compute element number to start at.
  //
  const int wp_lg = 5;
  const int wp_msk = ( 1 << wp_lg ) - 1;
  const int lane = tid & wp_msk;

  const int start = ( tid - lane ) * deg + lane;
  const int stop = d_app.array_size;
  const int inc = num_threads * deg;

  Elt_Type thd_sum = 0;

  for ( int h=start; h<stop; h += inc )
    for ( int i=0; i<deg; i++ )
      thd_sum += d_app.d_v_in[h+(i<<wp_lg)];

  return thd_sum;
}

extern "C" __global__ void
reduce_iter_atomic_grid()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  // Unroll degree.
  const int deg = 8;

  // Compute element number to start at.
  //
  const int wp_lg = 5;
  const int wp_msk = ( 1 << wp_lg ) - 1;
  const int lane = tid & wp_msk;

  const int start = ( tid - lane ) * deg + lane;
  const int stop = d_app.array_size;
  const int inc = num_threads * deg;

  for ( int h=start; h<stop; h += inc )
    for ( int i=0; i<deg; i++ )
      atomicAdd( &d_app.d_thd_sum[blockIdx.x], d_app.d_v_in[h+(i<<wp_lg)] );
}


extern "C" __global__ void
reduce_per_thd()
{
  // No reduction performed by GPU.
  //
  // Each thread computes its own sum and writes it to global memory.
  // CPU computes sum of BG elements.
  //
  // Where: B is threads per block (blockDim.x)
  //        G is number of blocks (gridDim.x)
  //        Total number of threads is BG.

  const Elt_Type thd_sum = reduce_thread();
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  d_app.d_thd_sum[tid] = thd_sum;
}

extern "C" __global__ void
reduce_per_blk_1thd()
{
  // Linear reduction by one thread per block.
  //
  // Each thread computes its own sum and writes it to shared memory.
  // One thread per block computes a block-wide sum and write it to global mem.
  //
  // G CPU threads each compute sum of B elements.
  // CPU computes sum of G elements.

  const Elt_Type thd_sum = reduce_thread();
  __shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];

  shared_sum[threadIdx.x] = thd_sum;  // Make sum available to thread 0.
  __syncthreads();

  if ( threadIdx.x != 0 ) return;

  Elt_Type our_sum = thd_sum;

  for ( int i=1; i<blockDim.x; i++ )
    our_sum += shared_sum[i];

  d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_thd_atomic_blk()
{
  // Use an atomic add operating on a shared variable.

  const Elt_Type thd_sum = reduce_thread();
  __shared__ Elt_Type our_sum;

  if ( threadIdx.x == 0 ) our_sum = 0;

  __syncthreads();

  atomicAdd( &our_sum, thd_sum );

  __syncthreads();

  if ( threadIdx.x == 0 ) d_app.d_thd_sum[blockIdx.x] = our_sum;
}

extern "C" __global__ void
reduce_thd_atomic_grd()
{
  // Use an atomic add operating on a global variable.

  const Elt_Type thd_sum = reduce_thread();

  atomicAdd( &d_app.d_thd_sum[0], thd_sum );

}

extern "C" __global__ void
reduce_thd_tree_blk()
{
  // Use a reduction tree.
  //
  // By using a complete tree reduction we perform the minimum
  // number of adds. That's the good news. The bad news is that
  // we need to synchronize each iteration.
  //

  const Elt_Type thd_sum = reduce_thread();
  __shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];

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
reduce_wp_lin_tree_blk()
{
  // A mixture of a linear sum and a tree reduction, chosen so
  // that only a single warp of threads participates.  Since only
  // a single warp is executing, no synchronizations are necessary
  // other than the one after the thread's initial sum is written.

  const Elt_Type thd_sum = reduce_thread();

  volatile __shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];

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
reduce_thd_tree_wp_tree_blk()
{
  const Elt_Type thd_sum = reduce_thread();

  volatile __shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];

  shared_sum[threadIdx.x] = thd_sum;

  Elt_Type our_sum = thd_sum;

  const int warp_lg = 5;
  const int warp_size = 1 << warp_lg;
  const int half_warp_size = warp_size >> 1;
  const int lane = threadIdx.x & ( warp_size - 1 );

  // Each warp computes a sum of its elements using a reduction tree.
  //
  for ( int dist = half_warp_size;  dist;  dist >>= 1 )
    if ( lane < dist )
      {
        our_sum += shared_sum[ threadIdx.x + dist ];
        shared_sum[ threadIdx.x ] = our_sum;
      }

#if 1

  const int warp_num = threadIdx.x >> warp_lg;
  volatile __shared__ Elt_Type wshared_sum[32];

  // Note: Only needed if blockDim.x < 1024.
  if ( warp_num == 0 ) wshared_sum[ threadIdx.x ] = 0;
  __syncthreads();

  // Store per-warp sum in shared memory.
  //
  if ( !lane ) wshared_sum[ warp_num ] = our_sum;

  __syncthreads();

  Elt_Type our_osum = 0;

  if ( threadIdx.x < half_warp_size )
    {
      // Use a reduction tree for the per-warp sums.

      our_osum = wshared_sum[ threadIdx.x ];

      for ( int dist = half_warp_size;  dist;  dist >>= 1 )
        if ( lane < dist )
          {
            our_osum += wshared_sum[ threadIdx.x + dist ];
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
  const Elt_Type thd_sum = reduce_thread();
  __shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];

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

  gpu_info_print();

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(reduce_per_thd);
  info.GET_INFO(reduce_per_blk_1thd);
  info.GET_INFO(reduce_iter_atomic_grid);
  info.GET_INFO(reduce_thd_atomic_blk);
  info.GET_INFO(reduce_thd_atomic_grd);
  info.GET_INFO(reduce_thd_tree_blk);
  info.GET_INFO(reduce_wp_lin_tree_blk);
  info.GET_INFO(reduce_thd_tree_wp_tree_blk);
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
  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();
  const int num_mp = info.cuda_prop.multiProcessorCount;

  // Examine argument 1, block count, default is number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
     arg1_int == 0 ? num_mp :
     arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block = argc < 3 ? 1024 : atoi(argv[2]);
  const int num_threads = num_blocks * thd_per_block;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 24 : int( atof(argv[3]) * (1<<24) );

  const int sum_array_size = num_threads;

  if ( num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int max_unroll_deg = 32;
  const int overrun_elts = 32 * max_unroll_deg;
  const int array_size_elts = app.array_size + overrun_elts;
  const int array_size_bytes = array_size_elts * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Elt_Type[array_size_elts];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  array_size_bytes ) );

  //  Allocate storage on CPU and GPU for the sums. The number of elements
  //  used for the sum can vary.
  //
  app.thd_sum = new Elt_Type[sum_array_size];
  CE( cudaMalloc( &app.d_thd_sum, sum_array_size * sizeof(app.d_thd_sum[0]) ) );

  // Initialize input array. Set overrun area to zero.
  //
  //  for ( int i=0; i<app.array_size; i++ ) app.v_in[i] = 2 * drand48();
  for ( int i=0; i<app.array_size; i++ ) app.v_in[i] = 1;
  for ( int i=app.array_size+1; i<array_size_elts; i++ ) app.v_in[i] = 0;

  // Compute correct answer.
  double cpu_grand_sum = 0;

  for ( int h=0; h<app.array_size; h++ ) cpu_grand_sum += app.v_in[h];

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
    printf("Launching with %d blocks of %d threads for %d elts ...\n",
           num_blocks, thd_per_block, app.array_size);

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        const int sum_array_used = kernel == 0 ? num_threads : num_blocks;
        const int samples = 20;
        const int hsamp = samples/2;
        vector<double> elapsed_times;

        for ( int s=0; s<samples; s++ )
          {
            CE(cudaMemset(app.d_thd_sum,0,sizeof(Elt_Type)*sum_array_used));

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
            elapsed_times.push_back( this_elapsed_time_s );
          }

        sort(elapsed_times.begin(),elapsed_times.end());
        const double elapsed_time_s = elapsed_times[hsamp];
        const double err_s = elapsed_times[hsamp+1]-elapsed_time_s;
        const double err = err_s/elapsed_time_s;

        printf("%-27s   %8.0f µs min, err %5.1f µs %3.1f%%.\n",
               info.ki[kernel].name,
               elapsed_time_s * 1e6, err_s * 1e6, 100 * err);

        //  Copy back per-thread sums.
        //
        CE( cudaMemcpy
            ( app.thd_sum, app.d_thd_sum,
              sizeof(Elt_Type) * sum_array_used, cudaMemcpyDeviceToHost) );

        // Find the sum of each thread or block's sum.
        //
        double grand_sum = 0;
        for ( int i=0; i<sum_array_used; i++ )
          grand_sum += app.thd_sum[i];

        double diff = fabs(grand_sum-cpu_grand_sum) / app.array_size;
        const bool correct = diff <= 1e-5;
        if ( !correct )
          printf
            ("Kernel above sum is %s,  %.1f %s %.1f (correct)\n",
             correct ? "correct" : "**wrong**",
             grand_sum,
             grand_sum == cpu_grand_sum ? "==" : diff < 1e-5 ? "~" : "!=",
             cpu_grand_sum);
      }
  }
}
