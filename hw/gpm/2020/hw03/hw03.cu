/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2020
 /// Homework 3
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2020/hw03.pdf
 //

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
#include <nperf.h>

inline __device__ int
fl1(u_int32_t n) { return 8 * sizeof(n) - __clz(n);}

template<class T> __device__
T floor2(T x) { return x <= 0 ? 0 : T(1) << fl1(x) - 1; }
template<class T> __device__
T ceil2(T x) { return x <= 0 ? 0 : T(1) << fl1(x-1); }


constexpr int wc_max = 16;
constexpr int wr_max = 16;
constexpr int w_elts_max = wc_max * wr_max;

struct App
{
  int in_nr, in_nc;   // Input:  Number rows, number columns.
  int out_nr, out_nc; // Output: Number rows, number columns.
  int w_nr, w_nc;     // Weights:Number rows, number columns.

  float *h_in;         // Host address space, data in.
  float *h_w;          // Host address space, weight array.
  float *h_out;        // Host address space, data out.

  float *d_in;         // Device address space, data in.
  float *d_w;          // Device address space, weight array.
  float *d_out;        // Device address space, data out.

  float w[w_elts_max]; // Constant address space, weights.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App dapp;


///
/// GPU Code (Kernels)
///

template <int w_nr, int w_nc>
__global__ void
conv_wbuf()
{
  const int block_dim = blockDim.x;
  const int n_threads = block_dim * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * block_dim;
  const int n_elt = dapp.out_nr * dapp.out_nc;

  assert( w_nr == dapp.w_nr );
  assert( w_nc == dapp.w_nc );

  for ( int h=tid; h<n_elt; h += n_threads )
    {
      const int ro = h / dapp.out_nc;
      const int co = h % dapp.out_nc;

      float s = 0;

#pragma unroll
      for ( int rw=0; rw<w_nr; rw++ )
        for ( int cw=0; cw<w_nc; cw++ )
          {
            const int ri = ro + rw;
            const int ci = co + cw;
            const int iidx = ri * dapp.in_nc + ci;
            const int widx = rw * w_nc + cw;
            s += dapp.d_in[iidx] * dapp.w[widx];
          }
      dapp.d_out[h] = s;
    }
}

template <int w_nr, int w_nc>
__global__ void
conv_prob1()
{
  const int block_dim = blockDim.x;
  const int n_threads = block_dim * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * block_dim;
  const int n_elt = dapp.out_nr * dapp.out_nc;

  assert( w_nr == dapp.w_nr );
  assert( w_nc == dapp.w_nc );

  for ( int h=tid; h<n_elt; h += n_threads )
    {
      const int ro = h / dapp.out_nc;
      const int co = h % dapp.out_nc;

      float s = 0;

#pragma unroll
      for ( int rw=0; rw<w_nr; rw++ )
        for ( int cw=0; cw<w_nc; cw++ )
          {
            const int ri = ro + rw;
            const int ci = co + cw;
            const int iidx = ri * dapp.in_nc + ci;
            const int widx = rw * w_nc + cw;
            s += dapp.d_in[iidx] * dapp.w[widx];
          }
      dapp.d_out[h] = s;
    }
}

template <int w_nr, int w_nc>
__global__ void
conv_prob2()
{
  const int block_dim = blockDim.x;
  const int n_threads = block_dim * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * block_dim;
  const int n_elt = dapp.out_nr * dapp.out_nc;

  assert( w_nr == dapp.w_nr );
  assert( w_nc == dapp.w_nc );

  for ( int h=tid; h<n_elt; h += n_threads )
    {
      const int ro = h / dapp.out_nc;
      const int co = h % dapp.out_nc;

      float s = 0;

#pragma unroll
      for ( int rw=0; rw<w_nr; rw++ )
        for ( int cw=0; cw<w_nc; cw++ )
          {
            const int ri = ro + rw;
            const int ci = co + cw;
            const int iidx = ri * dapp.in_nc + ci;
            const int widx = rw * w_nc + cw;
            s += dapp.d_in[iidx] * dapp.w[widx];
          }
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
  NPerf_init();

  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  NPerf_metric_collect("inst_executed");
  NPerf_metric_collect("l2_global_load_bytes");
  NPerf_metric_collect("l2_write_transactions");
  NPerf_metric_collect("dram_read_bytes");
  NPerf_metric_collect("dram_write_bytes");

  constexpr int wp_sz = 32;

  struct App_Kernel_Info {
    App_Kernel_Info(Kernel_Info& k,const char *name, int w_nrp, int w_ncp):
      k_ptr(k.func_ptr),name_base(name),rc{w_nrp,w_ncp}{}
    GPU_Info_Func k_ptr;
    const char *name_base;
    pair<int,int> rc;
  };

  map<string,vector<int>> kernel_map;
  map<pair<int,int>,int> rc_uses;
  vector<pair<int,int>> rc_list;
  vector<App_Kernel_Info> kernels;

  #define EXAMINE_KERNEL(k,r,c) \
    { const int idx = kernels.size(); \
      kernels.emplace_back(info.GET_INFO((k<r,c>)),#k,r,c);   \
      kernel_map[#k].push_back(idx); \
      if ( !rc_uses[make_pair(r,c)]++ ) rc_list.emplace_back(r,c); }

  #define SPECIALIZE_KERNEL(r,c) \
    EXAMINE_KERNEL(conv_wbuf,r,c); \
    EXAMINE_KERNEL(conv_prob1,r,c); \
    EXAMINE_KERNEL(conv_prob2,r,c);

  SPECIALIZE_KERNEL(8,8);
  SPECIALIZE_KERNEL(16,16);

  #undef SPECIALIZE_KERNEL

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

  // Examine argument 3, number of array columns per MP.
  //
  const double col_per_mp = argc < 4 ? 128.0 : atof(argv[3]);

  // Want array size to be larger than L2 cache.
  //
  const size_t target_array_sz_bytes = 1 << 25;
  const size_t target_array_sz_elts =
    target_array_sz_bytes / sizeof(app.h_in[0]);

  app.out_nc = num_mp * col_per_mp;
  app.out_nr = max( 32ul, target_array_sz_elts / app.out_nc );

  // Maximum values.
  app.w_nr = wr_max;
  app.w_nc = wc_max;
  app.in_nr = app.out_nr + app.w_nr;
  app.in_nc = app.out_nc + app.w_nc;

  if ( n_threads <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[COL PER MP]\n",
             argv[0]);
      exit(1);
    }

  const size_t in_msize_elts = app.in_nr * app.in_nc;
  const size_t in_msize_bytes = in_msize_elts * sizeof( app.h_in[0] );
  const size_t w_msize_elts = app.w_nr * app.w_nc;
  const size_t w_msize_bytes = w_msize_elts * sizeof( app.h_w[0] );
  const size_t out_size_elts = app.out_nr * app.out_nc;
  const size_t out_size_bytes = out_size_elts * sizeof( app.h_out[0] );
  const size_t overrun_size_bytes = num_blocks * 1024 * sizeof( app.h_in[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new float[in_msize_elts];
  app.h_w = new float[w_msize_elts];
  app.h_out = new float[out_size_elts];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_msize_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_w,  w_msize_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Out array size: %d * %d elements, num weights max %d * %d\n",
         app.out_nr, app.out_nc, app.w_nr, app.w_nc );

  // Initialize input arrays.
  //
#pragma omp parallel for
  for ( size_t i=0; i<in_msize_elts; i++ ) app.h_in[i] = drand48();
  for ( size_t i=0; i<w_msize_elts; i++ ) app.w[i] = app.h_w[i] = drand48();

  map<pair<int,int>,vector<float>> h_outs_check;
  for ( auto rc: rc_list ) h_outs_check[rc].resize(out_size_elts);

  // Compute correct answer.
  //
#pragma omp parallel for
  for ( int ro=0; ro<app.out_nr; ro++ )
    for ( int co=0; co<app.out_nc; co++ )
      {
        const int oidx = ro * app.out_nc + co;
        for ( auto rc: rc_list )
          {
            const int w_nr = rc.first, w_nc = rc.second;
            const int in_nc = app.out_nc + w_nc;
            float s = 0;
            for ( int rw=0; rw<w_nr; rw++ )
              for ( int cw=0; cw<w_nc; cw++ )
                {
                  const int widx = rw * w_nc + cw;
                  const int iidx = (ro+rw) * in_nc + (co+cw);
                  s += app.h_in[iidx] * app.h_w[widx];
                }
            h_outs_check[rc][oidx] = s;
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
        ( app.d_in, app.h_in, in_msize_bytes, cudaMemcpyHostToDevice ) );
    CE( cudaMemcpy
        ( app.d_w, app.h_w, w_msize_bytes, cudaMemcpyHostToDevice ) );


    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d warps. \n",
           num_blocks, wp_per_block_goal);

    for ( auto& aki: kernels )
      {
        const char* kname = aki.name_base;

        printf("Kernel %s:\n", kname);
        pTable table(stdout);

        Kernel_Info* const ki = &info.get_info(aki.k_ptr);
        auto rc = aki.rc;
        const int wr = rc.first, wc = rc.second;

        app.w_nr = wr;
        app.w_nc = wc;
        app.in_nr = app.out_nr + wr;
        app.in_nc = app.out_nc + wc;

        const size_t w_size_elts = wr * wc;
        const size_t in_size_elts = ( app.out_nc + wc ) * ( app.out_nr + wr );

        // Copy App structure to GPU.
        //
        CE( cudaMemcpyToSymbol
            ( dapp, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

        const int wp_limit = ki->cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary =
          min(wp_per_block_goal*wp_sz,thd_limit);

        const int wp_start = 1;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 1;

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            if ( vary_warps && wp_cnt > 4 && wp_cnt & 0x3 ) continue;


            /// Compute Expected Computation and Communication
            //
            // Number of multiply/add operations. Ignore everything else.
            //
            const int64_t num_ops_fp = out_size_elts * w_size_elts;
            const int64_t num_ops_ls = 0; // Load and store instructions.

            //
            // Amount of data in and out of GPU chip --- if perfect.
            //
            const int64_t amt_data_elts =
              in_size_elts + out_size_elts + w_size_elts;
            const int64_t amt_data_bytes =
              sizeof(app.h_in[0]) * amt_data_elts;

            {
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
              for ( NPerf_data_reset(); NPerf_need_run_get(); )
                KPtr(ki->func_ptr) <<< num_blocks, thd_per_block >>>();

              // Stop measuring execution time now, which is before is data
              // returned from GPU.
              //
              CE(cudaEventRecord(gpu_stop_ce,0));
              CE(cudaEventSynchronize(gpu_stop_ce));
              float cuda_time_ms = -1.1;
              CE( cudaEventElapsedTime
                  (&cuda_time_ms,gpu_start_ce,gpu_stop_ce) );

              const double this_elapsed_time_s =
                NPerf_metrics_collection_get()
                ? NPerf_kernel_et_get() : cuda_time_ms * 0.001;

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
                const double fp_frac = t_bound_fp / this_elapsed_time_s;

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
                table.entry("r","%2d",wr);
                table.entry("c","%2d",wc);
                table.entry("wp",num_wps);
                if ( num_blocks > num_mp )
                  table.entry("ac",act_wps);

                if ( NPerf_metrics_collection_get() )
                  {
                    const double transaction_sz_bytes = 32;
                    double dram_rd_bytes =
                      NPerf_metric_value_get("dram_read_bytes");
                    double dram_wr_bytes =
                      NPerf_metric_value_get("dram_write_bytes");

                    double l2_rd_bytes =
                      NPerf_metric_value_get("l2_global_load_bytes");
                    double l2_wr_bytes =
                      NPerf_metric_value_get("l2_write_transactions")
                      * transaction_sz_bytes;

                    table.entry
                      ("I/op","%4.1f",
                       NPerf_metric_value_get("inst_executed")
                       * 32.0 / num_ops_fp );
                    table.header_span_start("Data Amt");
                    table.entry
                      ("DRAM","%4.1f",
                       ( dram_rd_bytes + dram_wr_bytes ) / amt_data_bytes);
                    table.entry
                      ("L2","%5.1f",
                       ( l2_rd_bytes + l2_wr_bytes ) / amt_data_bytes);
                    table.header_span_end();
                  }

                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry("FP θ","%4.0f", thpt_compute_gflops);
                if ( false )
                  table.entry("GB/s","%4.0f", thpt_data_gbps);

                const size_t max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%zds",max_st_len);


                string util_hdr =
                  "=== Util: FP++  Insn-- Data**  ";
                if ( max_st_len > util_hdr.length() )
                  util_hdr += string(max_st_len - util_hdr.length(),'=');

                typedef struct { double f; char c; } Elt;
                vector<Elt> segments =
                  { { fp_frac, '+' }, { comp_frac, '-' }, { bw_frac, '*' } };

                sort( segments.begin(), segments.end(),
                      [](Elt& a, Elt& b){ return a.f < b.f; } );

                string bar;
                for ( Elt& e: segments )
                  if ( size_t p = e.f * max_st_len + 0.5; p > bar.length() )
                    bar += string( p - bar.length(), e.c );

                if ( bar.length() > max_st_len )
                  {
                    bar.resize(max_st_len);
                    bar[max_st_len-1] = '>';
                  }

                table.entry(util_hdr,fmt, bar, pTable::pT_Left);
              }

              // Copy output array from GPU to CPU.
              //
              CE( cudaMemcpy
                  ( app.h_out, app.d_out, out_size_bytes, cudaMemcpyDefault) );
              int err_count = 0;
              for ( size_t i=0; i<out_size_elts; i++ )
                {
                  if ( fabs( h_outs_check[rc][i] - app.h_out[i] ) > 1e-4 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf
                          ("Error at rc %zd %zd: %.7f != %.7f (correct)\n",
                           i / app.out_nc, i % app.out_nc,
                           app.h_out[i], h_outs_check[rc][i] );
                    }
                }
              if ( err_count )
                printf("Total errors %d\n", err_count);
            }
          }
      }

  }

}
