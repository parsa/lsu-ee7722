/// LSU EE 4702-1 (Fall 2016), GPU Programming
//

 /// Simple CUDA Example, without LSU ECE helper classes.

/// References
//
//

#if 0
/// Background

//  The following background describes the view of NVIDIA GPUs
//  provided by the CUDA system.  "View" means how the hardware
//  appears to the application programmer.  For CUDA, this should
//  be very close to the actual hardware.

 /// Compute Capability (CC)
//
//   An NVIDIA numbering system that identifies the approximate
//   capabilities of the hardware.
//
//   Compute Capabilities
//
//   -- CC 1.0, 1.1, 1.2, 1.3
//      Tesla. (Not to be confused with the Tesla board.)
//      Now considered obsolete.
//
//   -- CC 2.0, 2.1
//      Fermi
//
//   -- CC 3.0, 3.5
//      Kepler
//      Product cycle ending.
//      Currently the highest performance for scientific computation.
//
//   -- CC 5.2
//      Maxwell
//      Product cycle ending.
//
//   -- CC 6.X
//      Pascal
//      Product cycle starting.
//      Currently the highest performance for single-precision computation.



 /// Hardware Organization
//
//   Streaming Multiprocessor (SM, SMX)
//
//   Functional Unit
//     A piece of hardware that can perform a particular set of operations.
//     Examples:
//
//        CUDA Core:  Can perform most single-precision non-divide FP.


 /// CUDA Thread Organization
//
//   :Def: Kernel
//
//   :Def: Thread
//     Has one PC.
//      Sort of a brain, or maybe just a body that can be in one place
//      at one time.
//
//   :Def: Block
//     A grouping of threads.
//
//     The number of threads in a block is called the block size.


//     All threads in a block execute on the same multiprocessor.
//     Threads within a block share shared memory.
//
//   :Def: Grid
//     A collection of blocks.
//
//   Warp
//     A collection of 32 threads.
//     One day the size of warp may change but it's been 32 through CC 5.2.
//     Threads in a warp travel together.
//


 /// Kernel Launch
//
//   :Def: Kernel Launch
//         The initiation of execution of CUDA code.
//         Done by a CUDA API call.
//         Specify:
//           The name of the CUDA C procedure to start. (E.g., my_kernel();)
//           The grid size. (The number of blocks.)
//           The block size.
//
 ///  Launch Configuration Criteria
//
//    Number of blocks is a multiple of number of SMs.
//    Number of threads per block is a multiple of 32.


 /// 

#endif

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
#include "../cuda/intro-vtx-transform/util.h"

struct Vertex
{
  float a[4];
};

struct App
{
  int num_threads;
  int array_size;
  Vertex *v_in;
  float *m_out;
  float *m_out_check;

  float4 *d_v_in;
  float *d_m_out;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;


///
/// GPU Code (Kernels)
///


__global__ void
cuda_thread_start_simple()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  const int elt_per_thread =
    ( d_app.array_size + d_app.num_threads - 1 ) / d_app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      float4 p = d_app.d_v_in[h];

      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;

      d_app.d_m_out[h] = sos;
    }
}

__global__ void
cuda_thread_start_efficient()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  for ( int h=tid; h<d_app.array_size; h += d_app.num_threads )
    {
      float4 p = d_app.d_v_in[h];

      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;

      d_app.d_m_out[h] = sos;
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

  info.GET_INFO(cuda_thread_start_simple);
  info.GET_INFO(cuda_thread_start_efficient);

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


///
/// Main Routine
///


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
  const int thd_per_block_arg = argc < 3 ? 1024 : atoi(argv[2]);
  const int thd_per_block_goal =
   thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = app.num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int in_size_bytes = app.array_size * sizeof( app.v_in[0] );
  const int out_size_bytes = app.array_size * sizeof( app.m_out[0] );
  const int overrun_size_bytes = 1024 * sizeof( app.v_in[0] );

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.m_out = new float[app.array_size];
  app.m_out_check = new float[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_m_out, out_size_bytes + overrun_size_bytes ) );

  printf("Array size: %d  4-component vectors.\n", app.array_size);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<4; j++ ) app.v_in[i].a[j] = drand48();

  // Compute correct answer.
  //
  for ( int i=0; i<app.array_size; i++ )
    {
      app.m_out_check[i] = 0;
      for ( int j=0; j<4; j++ )
        app.m_out_check[i] += app.v_in[i].a[j] * app.v_in[i].a[j];
    }

  const int64_t num_ops = 4 * app.array_size;  // Multiply-adds.

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
        ( app.d_v_in, app.v_in, in_size_bytes, cudaMemcpyHostToDevice ) );

    // Copy App structure to GPU.
    //
    CE( cudaMemcpyToSymbol
        ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d threads. \n",
           num_blocks, thd_per_block_goal);

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
            CE(cudaMemset(app.d_m_out,0,out_size_bytes));

            // Measure execution time starting "now", which is after data
            // set to GPU.
            //
            CE(cudaEventRecord(gpu_start_ce,0));

            typedef void (*KPtr)();
            // Launch Kernel
            //
            KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>
              ();

            // Stop measuring execution time now, which is before is data
            // returned from GPU.
            //
            CE(cudaEventRecord(gpu_stop_ce,0));
            CE(cudaEventSynchronize(gpu_stop_ce));
            float cuda_time_ms = -1.1;
            CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

            const double this_elapsed_time_s = cuda_time_ms * 0.001;

            const double thpt_compute_gflops =
              num_ops / this_elapsed_time_s * 1e-9;
            const double thpt_data_gbps =
              amt_data_bytes / this_elapsed_time_s * 1e-9;

            if ( vary_warps )
              {
                const char* const stars = "********************************************************************************";
                const int stars_len = 80;
                const double comp_frac = 
                  4e9 * thpt_compute_gflops / info.chip_sp_flops;
                const int max_st_len = 52;

                // Number of warps, rounded up.
                //
                const int num_wps = ( thd_per_block + 31 ) >> 5;

                // The maximum number of active blocks per MP for this
                // kernel when launched with a block size of thd_per_block.
                //
                const int max_bl_per_mp =
                  info.get_max_active_blocks_per_mp(kernel,thd_per_block);

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
                const int act_wps = num_wps * bl_per_mp;

                if ( wp_cnt == wp_start )
                  printf("Kernel %s:\n", info.ki[kernel].name);

                printf("%2d %2d wp  %6.0f µs  %4.0f GF  %4.0f GB/s %s\n",
                       num_wps, act_wps,
                       this_elapsed_time_s * 1e6,
                       thpt_compute_gflops, thpt_data_gbps,
                       &stars[stars_len-int(comp_frac*max_st_len)]);

              } else {

              printf("K %-15s %2d wp  %11.3f µs  %8.3f GFLOPS  %8.3f GB/s\n",
                     info.ki[kernel].name,
                     (thd_per_block + 31 ) >> 5,
                     this_elapsed_time_s * 1e6,
                     thpt_compute_gflops, thpt_data_gbps);

            }

            elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( app.m_out, app.d_m_out, out_size_bytes, cudaMemcpyDeviceToHost) );
            continue; // Battle Short.
            int err_count = 0;
            for ( int i=0; i<app.array_size; i++ )
              {
                if ( fabs( app.m_out_check[i] - app.m_out[i] ) > 1e-5 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf("Error at vec %d: %.7f != %.7f (correct)\n",
                               i, app.m_out[i], app.m_out_check[i] );
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }

}
