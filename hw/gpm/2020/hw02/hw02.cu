/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2020
 /// Homework 2
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2020/hw02.pdf
 //
 //  Note: The solution to Homework 2 is "paper" only. This file
 //  will not be collected.

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

constexpr int Dj = 512; // Maximum

struct App
{
  int array_size;

  float *h_in;         // Host address space, data in.
  float *h_w;          // Host address space, weight array.
  float *h_out;        // Host address space, data out.

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

template <int n_wps, int Dj>
__global__ void
conv_wbuf()
{
  constexpr int wp_sz = 32;
  constexpr int block_dim = n_wps * wp_sz;
  const int n_threads = block_dim * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * block_dim;
  assert( block_dim == blockDim.x );

  for ( int h=tid; h<dapp.array_size; h += n_threads )
    {
      float s = 0;
      for ( int j=0; j<Dj; j++ ) s += dapp.d_in[h+j] * dapp.w[j];
      dapp.d_out[h] = s;
    }
}

template <int n_wps, int Dj>
__global__ void
conv_inbuf_block()
{
  constexpr int wp_sz = 32;
  constexpr int block_dim = n_wps * wp_sz;
  assert( block_dim == blockDim.x );
  assert( Dj <= block_dim );

  const int tx = threadIdx.x;  // Space-saving abbreviation.
  const int elt_per_block = ( dapp.array_size + gridDim.x - 1 ) / gridDim.x;
  const int bl_start = elt_per_block * blockIdx.x;
  const int bl_end = min( bl_start + elt_per_block, int(dapp.array_size) );

  __shared__ float in_buffer[block_dim*2];
  in_buffer[tx+block_dim] = dapp.d_in[bl_start+tx];

  for ( int hb=bl_start; hb<bl_end; hb += block_dim )
    {
      const int h = hb + tx;
      __syncthreads();
      in_buffer[tx] = in_buffer[tx+block_dim];
      in_buffer[tx+block_dim] = dapp.d_in[h+block_dim];
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

  constexpr int wp_sz = 32;

  struct App_Kernel_Info {
    App_Kernel_Info(Kernel_Info& k,const char *name, int n_wpsp, int djp):
      k_ptr(k.func_ptr),name_base(name),n_wps(n_wpsp),dj(djp){};
    GPU_Info_Func k_ptr;
    const char *name_base;
    int n_wps, dj;
  };

  map<string,vector<App_Kernel_Info>> kernels;
  map<int,int> w_sizesm;
  map<int,int> n_wpsm;

  #define EXAMINE_KERNEL(k,b,n) \
   kernels[#k].emplace_back(info.GET_INFO((k<b,n>)),#k,b,n); \
   w_sizesm[n]++;  n_wpsm[n]++;

  #define SPECIALIZE_KERNEL_2(b,n) \
    EXAMINE_KERNEL(conv_wbuf,b,n); \
    EXAMINE_KERNEL(conv_inbuf_block,b,n);

  #define SPECIALIZE_KERNEL(n) \
    SPECIALIZE_KERNEL_2(8,n) \
    SPECIALIZE_KERNEL_2(16,n) \
    SPECIALIZE_KERNEL_2(32,n)

  SPECIALIZE_KERNEL(4);
  SPECIALIZE_KERNEL(8);
  SPECIALIZE_KERNEL(16);
  SPECIALIZE_KERNEL(18);
  SPECIALIZE_KERNEL(24);
  SPECIALIZE_KERNEL(32);
  SPECIALIZE_KERNEL(64);
  SPECIALIZE_KERNEL(128);
  SPECIALIZE_KERNEL(256);
  SPECIALIZE_KERNEL(512);

  #undef SPECIALIZE_KERNEL


  vector<int> w_sizes;
  for ( auto& e: w_sizesm ) w_sizes.push_back(e.first);

  const bool want_kernel_info = false;
  if ( want_kernel_info )
    {
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
    }


  // Get number of multiprocessors. (A.k.a. streaming multiprocessors or SMs)
  //
  const int num_mp = info.cuda_prop.multiProcessorCount;

  // Examine argument 1, block count, default is number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
     arg1_int == 0 ? num_mp :
     arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of warps per block.
  //
  const int wp_per_block_arg = argc < 3 ? 32 : atoi(argv[2]);
  const int wp_per_block_goal =
   wp_per_block_arg == 0 ? 32 : wp_per_block_arg;
  const int n_threads = num_blocks * wp_per_block_goal * wp_sz;

  // If true, run kernels at multiple block sizes.
  //
  const bool vary_warps = wp_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 16 << 20 : int( atof(argv[3]) * (1<<20) );
  const int64_t array_size_64 = app.array_size; // Need 64 bits in places.

  if ( n_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  // The following are maximum values. The value for a particular run
  // depends on the number of weights, dj, rather than the maximum, Dj.
  //
  const size_t in_size_elts = array_size_64 + Dj;
  const size_t in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const size_t w_size_bytes = Dj * sizeof( app.h_w[0] );
  const size_t out_size_bytes = array_size_64 * sizeof( app.h_out[0] );
  const size_t overrun_size_bytes = num_blocks * 1024 * sizeof( app.h_in[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new float[in_size_elts];
  app.h_w = new float[Dj];
  app.h_out = new float[array_size_64];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_w,  w_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Array size: %zd elements, num weights %d\n", array_size_64, Dj);

  // Initialize input arrays.
  //
#pragma omp parallel for
  for ( size_t i=0; i<in_size_elts; i++ ) app.h_in[i] = drand48();
  for ( int i=0; i<Dj; i++ ) app.w[i] = app.h_w[i] = drand48();

  map<int,vector<float>> h_outs_check;
  for ( int dj: w_sizes ) h_outs_check[dj].resize(in_size_elts);

  // Compute correct answer.
  //
#pragma omp parallel for
  for ( int i=0; i<app.array_size; i++ )
    {
      float s = 0;
      int j = 0;
      for ( int dj: w_sizes )
        {
          for ( ; j<dj; j++ ) s += app.h_in[i+j] * app.h_w[j];
          h_outs_check[dj][i] = s;
        }
    }

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
    printf("Launching with %d blocks of up to %d warps. \n",
           num_blocks, wp_per_block_goal);

    for ( auto& elt: kernels )
      {
        auto& klist = elt.second;
        const char* kname = klist[0].name_base;

        printf("Kernel %s:\n", kname);
        pTable table(stdout);

        for ( auto& aki: klist )
          {
            Kernel_Info* const ki = &info.get_info(aki.k_ptr);
            const int wp_per_block = aki.n_wps;
            const int dj = aki.dj;

            if ( !vary_warps && wp_per_block != wp_per_block_goal ) continue;

            /// Compute Expected Computation and Communication
            //
            // Number of multiply/add operations. Ignore everything else.
            //
            const int64_t num_ops_fp = dj * array_size_64;  // Multiply-adds.
            const int64_t num_ops_ls = 0; // Load and store instructions.

            //
            // Amount of data in and out of GPU chip --- if perfectly-written.
            //
            const int64_t amt_data_elts = 2 * array_size_64 + dj;
            const int64_t amt_data_bytes = sizeof(app.h_in[0]) * amt_data_elts;

            {
              const int thd_per_block = wp_per_block * wp_sz;

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
              KPtr(ki->func_ptr) <<< num_blocks, thd_per_block >>>();

              // Stop measuring execution time now, which is before is data
              // returned from GPU.
              //
              CE(cudaEventRecord(gpu_stop_ce,0));
              CE(cudaEventSynchronize(gpu_stop_ce));
              float cuda_time_ms = -1.1;
              CE( cudaEventElapsedTime
                  (&cuda_time_ms,gpu_start_ce,gpu_stop_ce) );

              const double this_elapsed_time_s = cuda_time_ms * 0.001;

              const double thpt_compute_gflops =
                num_ops_fp / this_elapsed_time_s * 1e-9;
              const double thpt_data_gbps =
                amt_data_bytes / this_elapsed_time_s * 1e-9;

              // Number of load/store operations per second.
              const double chip_ls_ops = info.chip_sp_flops / 4;

              const double t_bound_fp = num_ops_fp / info.chip_sp_flops;
              const double t_bound_ls = num_ops_ls / chip_ls_ops;
              const double t_bound_insn = t_bound_fp + t_bound_ls;

              {
                const double comp_frac = t_bound_insn / this_elapsed_time_s;
                  //  1e9 * thpt_compute_gflops / info.chip_sp_flops;
                const double bw_frac =
                  1e9 * thpt_data_gbps / info.chip_bw_Bps;

                // Number of warps, rounded up.
                //
                const int num_wps = ( thd_per_block + 31 ) >> 5;

                // The maximum number of active blocks per MP for this
                // kernel when launched with a block size of thd_per_block.
                //
                const int max_bl_per_mp =
                  ki->get_max_active_blocks_per_mp(thd_per_block);

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

                // Based on the number of blocks, compute number of warps.
                //
                const int act_wps = num_wps * bl_per_mp;

                pTable_Row row(table);
                table.entry("dj","%3d",dj);
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry("FP θ","%4.0f", thpt_compute_gflops);
                table.entry("GB/s","%4.0f", thpt_data_gbps);

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);
                string util_hdr =
                  "--- Utilization: ++Compute++   **Data**  ";
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                const bool bw_more = bw_frac > comp_frac;
                const char* sym = bw_more ? "+*" : "*+";
                const double frac_min =  bw_more ? comp_frac : bw_frac;
                const double frac_max = !bw_more ? comp_frac : bw_frac;
                const size_t len_min = frac_min * max_st_len + 0.5;
                const size_t len_max = frac_max * max_st_len + 0.5;
                string bar = string( len_min, sym[0] ) +
                  string( len_max - len_min, sym[1] );

                table.entry(util_hdr,fmt, bar, pTable::pT_Left);
              }

              // Copy output array from GPU to CPU.
              //
              CE( cudaMemcpy
                  ( app.h_out, app.d_out, out_size_bytes, cudaMemcpyDefault) );
              int err_count = 0;
              for ( int i=0; i<app.array_size; i++ )
                {
                  if ( fabs( h_outs_check[dj][i] - app.h_out[i] ) > 1e-4 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf("Error at vec %d: %.7f != %.7f (correct)\n",
                               i, app.h_out[i], h_outs_check[dj][i] );
                    }
                }
              if ( err_count )
                printf("Total errors %d\n", err_count);
            }
          }
      }

  }

}
