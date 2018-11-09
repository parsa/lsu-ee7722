/// LSU EE 4702-1 (Fall 2018), GPU Programming
//

 /// Simple CUDA Example, without LSU ECE helper classes.

/// References
//
//  :ccpg19: CUDA C Programming Guide Version 10
//           https://docs.nvidia.com/cuda/cuda-c-programming-guide


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
//   -- CC 3.0, 3.1, 3.5, 3.7
//      Kepler
//      Outdated.
//
//   -- CC 5.2
//      Maxwell
//      Outdated.
//
//   -- CC 6.0, 6.1, 6.2
//      Pascal
//      Product cycle ending.
//      If cost is no object, good double-precision and half-precision perf.
//      Some support for machine learning: 16-bit floats.
//
//   -- CC 7.0
//      Volta
//      Not used much for graphics.
//      If cost is no object, good double-precision and half-precision perf.
//      Machine learning support.
//
//   -- CC 7.5
//      Turing
//      Ray tracing support.
//      Machine learning support.


 /// CUDA Thread Organization
//
//   :Def: Kernel
//     A procedure that executes on the GPU.
//     "I launched a kernel to multiply two 1000 by 1000 matrices."
//
//   :Def: Thread
//     Similar to the definition of a thread on a CPU.
//     A path of execution through the kernel.
//     Each Thread:
//       Has its own id.
//       The id consists of a thread index, in variable threadIdx, ..
//       .. and a block index, in variable blockIdx.
//     "My kernel consists of 16384 threads."
//
//   :Def: Block
//     A grouping of threads.
//
//     The number of threads in a block is called the block size ..
//     .. its value is in variable blockDim.
//     "My kernel has a block size of 1024 threads."

//
//   :Def: Grid
//     A collection of blocks.
//     The grid size is specified in the kernel launch.
//     "My kernel consists of 16 blocks of 1024 threads each."
//
//   :Def: Warp
//     A group of threads that (usually) execute together.
//     For all NV GPUs so far warp size is 32 threads
//     One day the size of warp may change but it's been 32 through CC 7.5.
//     "I chose my block size to be a multiple of the warp size."
//


 /// Hardware Organization
//
//   :Def: Streaming Multiprocessor (SM, SMX, MP)
//     The hardware to execute a block of threads.
//     In class called a multiprocessor (the word streaming omitted) for short.
//     Roughly akin to a core in a CPU.
//     High-performance GPUs might have about 50 SMs.
//
//     Each block is assigned to a particular SM.
//     All threads in a block execute on the same multiprocessor.
//     Threads within a block share shared memory.
//
//      "Uh-oh, my new GPU has 50 SMs. I hope my code can launch enough
//       blocks to keep them all busy."
//         
//
//   :Def: Functional Unit
//     A piece of hardware that can perform a particular set of operations.
//     Typical, GPU and Non-GPU Examples:
//        Integer ALU: Can perform such as add, sub, AND, OR, etc.
//        Integer multiply.
//        FP add, mul, madd.
//        FP div, sqrt, trig.
//     NVIDIA GPU Units:
//        CUDA Core:  Can perform most single-precision non-divide FP.
//        Special Func Unit: division, reciprocal square root, approx trig.
//        Load / Store: Read and write from memory.


 /// Kernel Launch
//
//   :Def: Kernel Launch
//     The initiation of execution of CUDA code.
//     Done by a CUDA API call.
//     Specify:
//        The name of the CUDA C procedure to start. (E.g., my_kernel();)
//        The grid size. (The number of blocks.)
//        The block size.
//
//   :Def: Launch Configuration
//     The block size and grid sized used for a kernel launch.
//     Choosing the correct launch configuration is very important.
//         
//
 ///  Launch Configuration Criteria
//
//    - Number of blocks is a multiple of number of SMs.
//    - Number of threads per block is a multiple of warp size (32).


 /// Global Memory Access
//
//   :Sample:  mval = a[tid];
//
//   Important rule:
//
//     Consecutive threads should access consecutive data items.
//       As in:  mval = a[ tid ];         // Good. ☺
//       NOT:    mval = a[ tid * 1000 ];  // BAD.  ☹
//
//     Size of contiguous chunks (accessed by consecutive threads)     
//     should be a multiple of 32 bytes.
//
 /// Possible Locations of Global Data
//
//   - Off-Chip Global Memory
//     Requires about 400 cycles to obtain data.
//     Subject to off-chip BW limit. 
//       BW limit in Telsa K20c:  208 GB/s
//       BW limit in GTX 780:     288 GB/s
//
//   - Level 2 Cache  (Not caché, please).
//     Size varies, about 1 MiB.
//     Requires about 200 cycles to obtain data.
//     Much higher BW limit.
//
//   Note: L2 only has a small latency benefit.
//         Larger benefit is higher bandwidth.
//
 /// Memory Requests
//
//   How Things Work (CC 3.x to 6.x)
//
//     - Threads in a warp execute a load instruction. E.g., mval = a[tid];
//
//     - Hardware coalesces these loads based on address into
//        contiguous *requests* of size 32, 64, or 128 B.
//
//     - Requests are sent to L2 cache, and if necessary, off-chip storage.
//
//     - Dependent instructions can execute when requests return.
//
//   Implications
//
//     Bandwidth consumed determined by request size ..
//     .. not by how much data actually needed.
//
//     Possible slow down with a larger number of requests ..
//     .. so 10 128-B requests better than 40 32-B request ..
//     .. even though they are the same size.


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
#include <gp/cuda-gpuinfo.h>


struct App
{
  int num_threads;
  int array_size;

  float4 *h_in;         // Host address space, data in.
  float *h_out;         // Host address space, data out.
  float *h_out_check;   // Compute correct answer on CPU, to check GPU.

  float4 *d_in;         // Device address space, data in.
  float *d_out;         // Device address space, data out.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;


///
/// GPU Code (Kernels)
///


__global__ void
kmain_simple()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  const int elt_per_thread =
    ( d_app.array_size + d_app.num_threads - 1 ) / d_app.num_threads;
  const int start = elt_per_thread * tid;  // Bad: Non-consecutive access.
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      float4 p = d_app.d_in[h];  // Bad: Non-consecutive access.
      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
      d_app.d_out[h] = sos;
    }
}

__global__ void
kmain_efficient()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  if ( tid >= d_app.num_threads ) return;

  for ( int h=tid; h<d_app.array_size; h += d_app.num_threads )
    {
      float4 p = d_app.d_in[h];  // Good: Consecutive access.
      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
      d_app.d_out[h] = sos;
    }
}


__global__ void
kmain_tuned()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  if ( tid >= d_app.num_threads ) return;

  const int strip_len = 4;
  // Data "strip" is 32 threads wide and strip_len threads long.

  const int wp_sz = 32;         // Warp size.
  const int wp = tid / wp_sz;   // This thd's warp number within kernel. (0-)
  const int ln = tid % wp_sz;   // This thd's lane number within warp.  (0-31)
  const int start = wp * wp_sz * strip_len + ln;

  for ( int h=start; h<d_app.array_size; h += strip_len * d_app.num_threads )
    {
      float soses[strip_len];
      for ( int i=0; i<strip_len; i++ )
        {
          float4 p = d_app.d_in[ h + i * wp_sz ];
          soses[i] = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
        }
      for ( size_t i=0; i<strip_len; i++ )
        d_app.d_out[ h + i * wp_sz ] = soses[i];
    }
}



GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  gpu_info_print();

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(kmain_simple);
  info.GET_INFO(kmain_efficient);
  info.GET_INFO(kmain_tuned);

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

  // Get number of multiprocessors. (A.k.a. streaming multiprocessors or SMs)
  //
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
  const int num_threads = num_blocks * thd_per_block_goal;

  // If true, run kernels at multiple block sizes.
  //
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

  const int in_size_bytes = app.array_size * sizeof( app.h_in[0] );
  const int out_size_bytes = app.array_size * sizeof( app.h_out[0] );
  const int overrun_size_bytes = num_blocks * 1024 * sizeof( app.h_in[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new float4[app.array_size];
  app.h_out = new float[app.array_size];
  app.h_out_check = new float[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Array size: %d  4-component vectors.\n", app.array_size);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<4; j++ ) ((float*)&app.h_in[i])[j] = drand48();

  // Compute correct answer.
  //
  for ( int i=0; i<app.array_size; i++ )
    {
      float4 p = app.h_in[i];
      app.h_out_check[i] = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
    }

  /// Compute Expected Computation and Communication
  //
  // Number of multiply/add operations. Ignore everything else.
  //
  const int64_t num_ops = 4 * app.array_size;  // Multiply-adds.
  //
  // Amount of data in and out of GPU chip.
  //
  const int amt_data_bytes = in_size_bytes + out_size_bytes;

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

    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d threads. \n",
           num_blocks, thd_per_block_goal);

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        cudaFuncAttributes& cfa = info.ki[kernel].cfa;
        const int wp_limit = cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary = min(thd_per_block_goal,thd_limit);

        const int wp_start = 1;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 1;

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            if ( vary_warps && wp_cnt > 4 && wp_cnt & 0x3 ) continue;

            app.num_threads = thd_per_block * num_blocks;

            // Copy App structure to GPU.
            //
            CE( cudaMemcpyToSymbol
                ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

            // Zero the output array.
            //
            CE(cudaMemset(app.d_out,0,out_size_bytes));

            // Measure execution time starting "now", which is after data
            // set to GPU.
            //
            CE(cudaEventRecord(gpu_start_ce,0));

            typedef void (*KPtr)();

            /// Launch Kernel
            //
            KPtr(info.ki[kernel].func_ptr) <<< num_blocks, thd_per_block >>>();

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
                const double bw_frac =
                  1e9 * thpt_data_gbps / info.chip_bw_Bps;

                const bool graph_bw = true;
                const double frac = graph_bw ? bw_frac : comp_frac;

                const int max_st_len = 43;

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

                printf("%2d %2d wp %6.0f µs %3.0f GF  %3.0f GB/s %s\n",
                       num_wps, act_wps,
                       this_elapsed_time_s * 1e6,
                       thpt_compute_gflops, thpt_data_gbps,
                       &stars[stars_len-int(frac*max_st_len)]);

              } else {

              printf("K %-15s %2d wp  %11.3f µs  %8.3f GFLOPS  %8.3f GB/s\n",
                     info.ki[kernel].name,
                     (thd_per_block + 31 ) >> 5,
                     this_elapsed_time_s * 1e6,
                     thpt_compute_gflops, thpt_data_gbps);

            }

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( app.h_out, app.d_out, out_size_bytes, cudaMemcpyDefault) );
            int err_count = 0;
            for ( int i=0; i<app.array_size; i++ )
              {
                if ( fabs( app.h_out_check[i] - app.h_out[i] ) > 1e-5 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf("Error at vec %d: %.7f != %.7f (correct)\n",
                               i, app.h_out[i], app.h_out_check[i] );
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }

}
