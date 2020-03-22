/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2020
 /// Homework 1 -- SOLUTION
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2020/hw01.pdf
 //
 //  Modify this file only.

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
#include <ptable.h>

constexpr int Dj = 32;

struct App
{
  int array_size;

  float *h_in;         // Host address space, data in.
  float *h_w;          // Host address space, weight array.
  float *h_out;        // Host address space, data out.
  float *h_out_check;  // Compute correct answer on CPU, to check GPU.

  float *d_in;         // Device address space, data in.
  float *d_w;          // Device address space, weight array.
  float *d_out;        // Device address space, data out.

  float w[Dj];         // Same address space as App object.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App dapp;


///
/// GPU Code (Kernels)
///

__global__ void
conv_simple()
{
  // Each thread operates on its own contiguous section of the array.

  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  const int elt_per_thread = ( dapp.array_size + n_threads - 1 ) / n_threads;
  const int start = elt_per_thread * tid;  // Bad: Non-consecutive access.
  const int stop = min( start + elt_per_thread, dapp.array_size );

  for ( int h=start; h<stop; h++ )
    {
      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += dapp.d_in[h+j] * dapp.d_w[j];
      dapp.d_out[h] = s;
    }
}

__global__ void
conv_efficient()
{
  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int h=tid; h<dapp.array_size; h += n_threads )
    {
      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += dapp.d_in[h+j] * dapp.d_w[j];
      dapp.d_out[h] = s;
    }
}

__global__ void
conv_wbuf()
{
  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;


  // Copy dapp.d_w into an array (shared or local address space)
  // and use that array inside the loop.
  //
  // DO NOT use dapp.w[j] in this routine.

  /// SOLUTION -- Problem 1
  //
  //  Declare a local array and fill it with the weights (dapp.d_w).
  //
  float w[Dj];
  for ( int j=0; j<Dj; j++ ) w[j] = dapp.d_w[j];

  for ( int h=tid; h<dapp.array_size; h += n_threads )
    {
      float s = 0;
      // SOLUTION - Use w instead of dapp.d_w.
      for ( int j=0; j<Dj; j++ ) s += dapp.d_in[h+j] * w[j];
      dapp.d_out[h] = s;
    }

}

__global__ void
conv_inbuf_wp_a()
{
  constexpr int wp_lg = 5;
  constexpr int wp_sz = 1 << wp_lg;
  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_wps = n_threads >> wp_lg;
  assert( n_wps << wp_lg == n_threads );

  const int [[gnu::unused]] wp_idx = tid >> wp_lg;
  const int [[gnu::unused]] wp_ldx = threadIdx.x >> wp_lg;
  const int [[gnu::unused]] lane = threadIdx.x % wp_sz;

  /// SOLUTION -- Problem 2 -- Using a barrier (syncwarp).

  // First, find number of array elements per warp, rounding up.
  //
  const int elt_per_wp_raw = ( dapp.array_size + n_wps - 1 ) / n_wps;

  // Next, round up to a multiple of warp size. This will avoid overlap.
  //
  const int elt_per_wp = ( elt_per_wp_raw + wp_sz - 1 ) & ~( wp_sz - 1 );
  //
  // Note: wp_sz - 1 is 31 or 0x1f.
  // The ~ is bitwise NOT, so  ~0x1f  is  0xffffffe0.
  // The & is bitwise AND, so   x & ~0x1f  
  //   sets the least significant 5 bits of x to zero,
  //   making it a multiple of 32.

  // Find the starting and ending element for this warp.
  //
  const int wp_start = elt_per_wp * wp_idx;
  const int wp_end = min( wp_start + elt_per_wp, dapp.array_size );

  // This solution won't work if Dj > wp_sz.
  assert( wp_sz >= Dj );

  // Declare an array to hold input elements.
  // Each warp uses 64 elements of this array.
  //
  __shared__ float in_buffer[2048];

  // Declare a pointer to this warp's part of the shared array.
  //
  float* const wp_buf = &in_buffer[ wp_ldx * 2 * wp_sz ];

  // Load the first set of values.
  //
  wp_buf[ wp_sz + lane ] = dapp.d_in[ wp_start + lane ];

  for ( int hw=wp_start; hw<wp_end; hw += wp_sz )
    {
      const int h = hw + lane;

      // Move data loaded in the previous iteration ..
      //
      wp_buf[ lane ] = wp_buf[ wp_sz + lane ];
      //
      // .. and load the next set of values.
      //
      wp_buf[ wp_sz + lane ] = dapp.d_in[ wp_sz + h ];

      // Make sure that the assignment to wp_buf above is done before
      // the code below.
      //
      __syncwarp();
      //
      // The __syncwarp call is being used to tell the compiler to not
      // move the  "wp_buf[ wp_sz + lane ] = dapp.d_in[ wp_sz + h ];"
      // line past the __syncwarp.

      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += wp_buf[ lane + j ] * dapp.w[j];
      dapp.d_out[h] = s;
    }
}

__global__ void
conv_inbuf_wp_b()
{
  constexpr int wp_lg = 5;
  constexpr int wp_sz = 1 << wp_lg;
  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_wps = n_threads >> wp_lg;
  assert( n_wps << wp_lg == n_threads );

  const int [[gnu::unused]] wp_idx = tid >> wp_lg;
  const int [[gnu::unused]] wp_ldx = threadIdx.x >> wp_lg;
  const int [[gnu::unused]] lane = threadIdx.x % wp_sz;

  /// SOLUTION -- Problem 2 -- Using a volatile declaration.

  // First, find number of array elements per warp, rounding up.
  //
  const int elt_per_wp_raw = ( dapp.array_size + n_wps - 1 ) / n_wps;

  // Next, round up to a multiple of warp size. This will avoid overlap.
  //
  const int elt_per_wp = ( elt_per_wp_raw + wp_sz - 1 ) & ~( wp_sz - 1 );
  //
  // Note: wp_sz - 1 is 31 or 0x1f.
  // The ~ is bitwise NOT, so  ~0x1f  is  0xffffffe0.
  // The & is bitwise AND, so   x & ~0x1f  
  //   sets the least significant 5 bits of x to zero,
  //   making it a multiple of 32.

  // Find the starting and ending element for this warp.
  //
  const int wp_start = elt_per_wp * wp_idx;
  const int wp_end = min( wp_start + elt_per_wp, dapp.array_size );

  // This solution won't work if Dj > wp_sz.
  assert( wp_sz >= Dj );

  // Declare an array to hold input elements.
  // Each warp uses 64 elements of this array.
  //
  __shared__ volatile float in_buffer[2048];
  //
  // Note: the volatile attribute tells the compiler that values in
  // the array (in this case) can be changed by other threads (or in
  // other cases, by hardware). This forces the compiler to load a
  // value each time it is needed, and to store values in to the
  // variable at the place in the code an assignment like
  // in_buffer[x]=y appears.
  //
  // For example, suppose in_buffer[x] appears in two places in the
  // code and x is the same in both places. Without the volatile
  // qualifier the compile would load in_buffer[x] into a register,
  // and use that register at each place in the code in_buffer[x]
  // appears. But, if in_buffer is declared with the volatile
  // qualifier the compiler will load in_buffer[x] from shared memory
  // twice, one each place it appears in the code.

  // Declare a pointer to this warp's part of the shared array.
  //
  volatile float* const wp_buf = &in_buffer[ wp_ldx * 2 * wp_sz ];

  // Load the first set of values.
  //
  wp_buf[ wp_sz + lane ] = dapp.d_in[ wp_start + lane ];

  for ( int hw=wp_start; hw<wp_end; hw += wp_sz )
    {
      const int h = hw + lane;

      // Move data loaded in the previous iteration ..
      //
      wp_buf[ lane ] = wp_buf[ wp_sz + lane ];
      //
      // .. and load the next set of values.
      //
      wp_buf[ wp_sz + lane ] = dapp.d_in[ wp_sz + h ];

      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += wp_buf[ lane + j ] * dapp.w[j];
      dapp.d_out[h] = s;
    }
}

__global__ void
conv_inbuf_class()
{
  constexpr int wp_lg = 5;
  constexpr int wp_sz = 1 << wp_lg;
  const int n_threads = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_wps = n_threads >> wp_lg;
  assert( n_wps << wp_lg == n_threads );

  const int [[gnu::unused]] wp_idx = tid >> wp_lg;
  const int [[gnu::unused]] wp_ldx = threadIdx.x >> wp_lg;
  const int [[gnu::unused]] lane = threadIdx.x % wp_sz;

  /// SOLUTION -- Written during class on 13 March.

  // First, find number of array elements per warp, rounding up.
  //
  const int elt_per_wp_raw = ( dapp.array_size + n_wps - 1 ) / n_wps;

  // Next, round up to a multiple of warp size. This will avoid overlap.
  //
  const int elt_per_wp = ( elt_per_wp_raw + wp_sz - 1 ) & ~( wp_sz - 1 );

  // Find the starting and ending element for this warp.
  //
  const int wp_start = elt_per_wp * wp_idx;
  const int wp_end = min( wp_start + elt_per_wp, dapp.array_size );

  const int mask = 63;
  __shared__ float in_buffer[2048];

  float* const wp_buf = &in_buffer[ wp_ldx * 2 * wp_sz ];

  int idx1 = 0;

  wp_buf[ idx1 + lane ] = dapp.d_in[ wp_start + lane ];

  for ( int h_wp=wp_start; h_wp<wp_end; h_wp += wp_sz )
    {
      const int h = h_wp + lane;
      wp_buf[ ( idx1 + wp_sz + lane ) & mask ] = dapp.d_in[ wp_sz + h ];

      __syncwarp();

      float s = 0;
      for ( int j=0; j<Dj; j++ )
        s += wp_buf[ ( idx1 + lane + j ) & mask ] * dapp.w[j];
      dapp.d_out[h] = s;

      idx1 += wp_sz;
    }
}

__global__ void
conv_inbuf_block()
{
  /// Alternative Approach -- Divide array between blocks.

  const int tx = threadIdx.x;  // Space-saving abbreviation.
  const int elt_per_block = ( dapp.array_size + gridDim.x - 1 ) / gridDim.x;
  const int bl_start = elt_per_block * blockIdx.x;
  const int bl_end = min( bl_start + elt_per_block, dapp.array_size );

  __shared__ float in_buffer[2048];
  in_buffer[tx+blockDim.x] = dapp.d_in[bl_start+tx];

  for ( int hb=bl_start; hb<bl_end; hb += blockDim.x )
    {
      const int h = hb + tx;
      __syncthreads();
      in_buffer[tx] = in_buffer[tx+blockDim.x];
      in_buffer[tx+blockDim.x] = dapp.d_in[h+blockDim.x];
      __syncthreads();

      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += in_buffer[tx+j] * dapp.w[j];
      dapp.d_out[h] = s;
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

  const bool show_all = false;
  if ( show_all )
    {
      info.GET_INFO(conv_simple);
      info.GET_INFO(conv_efficient);
    }
  info.GET_INFO(conv_wbuf);
  info.GET_INFO(conv_inbuf_wp_a);
  info.GET_INFO(conv_inbuf_wp_b);
  info.GET_INFO(conv_inbuf_block);
  info.GET_INFO(conv_inbuf_class);

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
  const int n_threads = num_blocks * thd_per_block_goal;

  // If true, run kernels at multiple block sizes.
  //
  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 16 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( n_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int in_size_elts = app.array_size + Dj;
  const int in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const int w_size_bytes = Dj * sizeof( app.h_w[0] );
  const int out_size_bytes = app.array_size * sizeof( app.h_out[0] );
  const int overrun_size_bytes = num_blocks * 1024 * sizeof( app.h_in[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new float[in_size_elts];
  app.h_w = new float[Dj];
  app.h_out = new float[app.array_size];
  app.h_out_check = new float[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_w,  w_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Array size: %d elements, num weights %d\n", app.array_size,Dj);

  // Initialize input arrays.
  //
#pragma omp parallel for
  for ( int i=0; i<in_size_elts; i++ ) app.h_in[i] = drand48();
  for ( int i=0; i<Dj; i++ ) app.w[i] = app.h_w[i] = drand48();

  // Compute correct answer.
  //
#pragma omp parallel for
  for ( int i=0; i<app.array_size; i++ )
    {
      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += app.h_in[i+j] * app.h_w[j];
      app.h_out_check[i] = s;
    }

  /// Compute Expected Computation and Communication
  //
  // Number of multiply/add operations. Ignore everything else.
  //
  const int64_t num_ops = Dj * app.array_size;  // Multiply-adds.
  //
  // Amount of data in and out of GPU chip --- if code well-written.
  //
  const int amt_data_bytes = in_size_bytes + w_size_bytes + out_size_bytes;

  // The width, in characters, of the output to which we are printing.
  //
  const int output_width = stdout_width_get();

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
    CE( cudaMemcpy
        ( app.d_w, app.h_w, w_size_bytes, cudaMemcpyHostToDevice ) );

    // Copy App structure to GPU.
    //
    CE( cudaMemcpyToSymbol
        ( dapp, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

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

        pTable table(stdout);

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            if ( vary_warps && wp_cnt > 4 && wp_cnt & 0x3 ) continue;

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
                const double comp_frac =
                  4e9 * thpt_compute_gflops / info.chip_sp_flops;
                const double bw_frac =
                  1e9 * thpt_data_gbps / info.chip_bw_Bps;

                const bool graph_bw = true;
                const double frac = graph_bw ? bw_frac : comp_frac;

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

                pTable_Row row(table);
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry("FP θ","%4.0f", thpt_compute_gflops);
                table.entry("GB/s","%4.0f", thpt_data_gbps);

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);
                string util_hdr =
                  graph_bw ? "Data BW Util" : "FP Utilization";
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                table.entry
                  (util_hdr,fmt,
                   string( size_t(max(0.0,frac*max_st_len)), '*' ),
                   pTable::pT_Left);

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
