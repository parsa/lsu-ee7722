/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 1 SOLUTION - Spring 2016
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2016/hw01.pdf

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>
#include <new>
#include <cuda_runtime.h>
#include <assert.h>
#include "util.h"


// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

struct App
{
  int array_size;

  // Host pointers to the input and output arrays, and to CPU-computed
  // output arrays used for checking results.
  //
  Elt_Type *h_in, *h_out, *h_out_check;
  Elt_Type *h_out_sc_check;

  /// Problem 3 -- This might come in handy.
  int mask;

  // GPU pointers to the input and output arrays.
  //
  Elt_Type *d_in, *d_out;

};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

extern "C" __global__ void
lane_aligned()
{
  /// Problem 1 -- Put solution in this routine.

  /// SOLUTION Problem 1
  //
  //  Round the block size down to the largest multiple of 32, and
  //  use that "useful" block size instead of the real one.

  // SOLUTION: Round block dim to largest multiple of 32 <= blockDim.x
  //
  const int useful_block_dim = blockDim.x & ~ 0x1f;

  // SOLUTION: Use useful_block_dim to compute number of threads
  //
  const int useful_num_threads = useful_block_dim * gridDim.x;

  // SOLUTION: Just return if we are beyond the useful part.
  //
  if ( threadIdx.x >= useful_block_dim ) return;

  const int tid = threadIdx.x + blockIdx.x * useful_block_dim;
  const int lane = threadIdx.x & 0x1f;

  const int start = tid;
  const int stop = d_app.array_size;

  // Encode lane number so that it can be written to output array
  // elements. The CPU code will use this to check whether any
  // partial warps executed. Please don't change the line below,
  // that would be lying to the CPU code.
  //
  const Elt_Type lane_label = 1e-5 * lane;

  for ( int i = start; i < stop; i += useful_num_threads )
    d_app.d_out[i] = d_app.d_in[i] + lane_label;

}



 /// SOLUTION -- Problem 3
//
//   Increase number of iterations from 2 to 16 so that computation
//   time is a significant portion of execution time.

// Number of iterations used in scheduler_bm.
//
const int iters = 16;
//
// It is important that this value is a compile-time constant.


extern "C" __global__ void
scheduler_bm()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;
  const int stop = d_app.array_size;
  const int inc = num_threads;

  for ( int i = start; i < stop; i += inc )
    {
      Elt_Type accum = d_app.d_in[i];

      // SOLUTION -- Problem 3
      //
      // Use mask to suppress execution of certain threads.
      //
      if ( ( tid & d_app.mask ) == 0 )
        for ( int j=0; j<iters; j++ ) accum = __sinf(accum);

      d_app.d_out[i] = accum;
    }
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

  info.GET_INFO(lane_aligned);
  info.GET_INFO(scheduler_bm);

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

  // Examine argument 1, block count. Default is number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
     arg1_int == 0 ? num_mp :
     arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block_arg = argc < 3 ? 1024 : atoi(argv[2]);
  const int thd_per_block_goal =
   thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS | -BLOCKS_PER_MP ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  /// SOLUTION -- Problem 3. Get mask value from the command line.
  //
  app.mask = argc < 5 ? 0 : strtol(argv[4],NULL,0);

  const int in_size_bytes = app.array_size * sizeof( app.h_in[0] );
  const int out_size_bytes = app.array_size * sizeof( app.h_out[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new Elt_Type[ app.array_size ];
  app.h_out = new Elt_Type[ app.array_size ];
  app.h_out_check = new Elt_Type[ app.array_size ];
  app.h_out_sc_check = new Elt_Type[ app.array_size ];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes ) );

  // Initialize input array and arrays holding correct answers.
  //
  for ( int i=0; i<app.array_size; i++ )
    {
      app.h_in[i] = i + 0.01 * ( i & 0x1f );
      app.h_out[i] = 0;
      app.h_out_check[i] = app.h_in[i] + 0.00001 * ( i & 0x1f );
      Elt_Type accum = app.h_in[i];
      for ( int j=0; j<iters; j++ ) accum = sin(accum);

      // The NVIDIA hardware sin is not accurate for larger values,
      // so use a -2 to indicate that GPU output should not be checked
      // at this element.
      //
      app.h_out_sc_check[i] = i < 100000 ? accum : -2;
    }

  // Amount of data in and out of GPU chip.
  const int amt_data_bytes = in_size_bytes + out_size_bytes;

  double elapsed_time_s = 86400; // Reassigned to minimum run time.

  {
    // Prepare events used for timing.
    //
    cudaEvent_t gpu_start_ce, gpu_stop_ce;
    CE(cudaEventCreate(&gpu_start_ce));
    CE(cudaEventCreate(&gpu_stop_ce));

    // Copy input array from CPU to GPU.
    //
    CE( cudaMemcpy
        ( app.d_in, app.h_in, in_size_bytes, cudaMemcpyHostToDevice ) );

    // Copy App structure to GPU.
    //
    CE( cudaMemcpyToSymbol
        ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

    // Launch kernel multiple times and keep track of the best time.
    printf("\nLaunching with %d blocks of up to %d threads for %d elts "
           "and mask %#x.\n",
           num_blocks, thd_per_block_goal, app.array_size, app.mask);

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        cudaFuncAttributes& cfa = info.ki[kernel].cfa;
        const int wp_limit = cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary = min(thd_per_block_goal,thd_limit);

        const int wp_start = 4;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 4;

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            // Zero the output array.
            //
            CE( cudaMemset(app.d_out,0,out_size_bytes) );

            // Measure execution time starting "now", which is after data
            // set to GPU.
            //
            CE(cudaEventRecord(gpu_start_ce,0));

            // Launch Kernel
            //
            info.ki[kernel].func_ptr <<< num_blocks, thd_per_block >>>();
            //
            // Confused?
            //
            //  info.ki[kernel].func_ptr holds a pointer to the kernel
            //    routine.

            // Stop measuring execution time now, which is before is data
            // returned from GPU.
            //
            CE(cudaEventRecord(gpu_stop_ce,0));
            CE(cudaEventSynchronize(gpu_stop_ce));
            float cuda_time_ms = -1.1;
            CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

            const double this_elapsed_time_s = cuda_time_ms * 0.001;

            const double thpt_data_gbps =
              amt_data_bytes / this_elapsed_time_s * 1e-9;

            if ( vary_warps )
              {
                const char* const stars = "********************************************************************************";
                const int stars_len = 80;
                const double bw_frac =
                  1e9 * thpt_data_gbps / info.chip_bw_Bps;
                const int max_st_len = 52;  // Maximum stars length.

                // Number of warps, rounded up.
                //
                const int wps = ( thd_per_block + 31 ) >> 5;

                /// Problem 2 Solution Goes Around Here

                // The maximum number of active blocks per MP for this
                // kernel when launched with a block size of thd_per_block.
                //
                const int max_bl_per_mp =
                  info.get_max_active_blocks_per_mp(kernel,thd_per_block);

                /// Problem 2: Assign appropriate value.

                /// SOLUTION - Problem 2
                //

                // Compute number of blocks available per MP based only on
                // the number of blocks.  This may be larger than the
                // number of blocks that can run.
                //
                const int bl_per_mp_available =
                  0.999 + double(num_blocks) / num_mp;

                // The number of active blocks is the minimum of what
                // can fit and how many are available.
                //
                const int bl_per_mp =
                  min( bl_per_mp_available, max_bl_per_mp );

                // Based on the number of blocks, compute the num ber of warps.
                //
                const int act_wps = wps * bl_per_mp;

                if ( wp_cnt == wp_start )
                  printf("Kernel %s:\n", info.ki[kernel].name);

                printf("%2d wp  %2d acwp  %6.0f µs  %5.0f GB/s %s\n",
                       (thd_per_block + 31 ) >> 5,
                       act_wps,
                       this_elapsed_time_s * 1e6,
                       thpt_data_gbps,
                       &stars[stars_len-int(bw_frac*max_st_len)]
                       );

              } else {

              printf("K %-15s %2d wp  %11.3f µs  %8.3f GB/s\n",
                     info.ki[kernel].name,
                     (thd_per_block + 31 ) >> 5,
                     this_elapsed_time_s * 1e6,
                     thpt_data_gbps);

            }

            elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( app.h_out, app.d_out, out_size_bytes,
                  cudaMemcpyDeviceToHost) );
            int err_count = 0;
            Elt_Type* const out_check =
              kernel == 0 ? app.h_out_check : app.h_out_sc_check;
            const double tolerance = kernel == 0 ? 1e-5 : 1e-2;
            for ( int i=0; i<app.array_size; i++ )
              {
                if ( out_check[i] == -2 ) continue; // Don't check.

                /// SOLUTION -- Problem 3
                //
                // Skip correctness check if sine execution was
                // suppressed by the mask.
                // 
                if ( kernel == 1 && i & app.mask ) continue;

                if ( fabs( out_check[i] - app.h_out[i] ) > tolerance )
                  {
                    err_count++;
                    if ( err_count < 5 )
                      printf("Error at elt %#x: %.7f != %.7f (correct)\n",
                             i, app.h_out[i], out_check[i] );
                  }
              }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }

}
