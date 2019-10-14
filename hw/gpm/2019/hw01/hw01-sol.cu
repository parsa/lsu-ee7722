/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2019
 /// Homework 1 -- SOLUTION
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2019/hw01.pdf
 //
 //  Modify this file only.


#include <string.h>
#include <stdio.h>
#include <cuda_runtime.h>
#include <assert.h>
#include <nperf.h>
#include "util.h"
#include <ptable.h>

const int slen = 24;
struct __align__(32) Some_Struct
{
  float f0, f1;
  char str[slen];
};


struct App
{
  int n_elts;
  Some_Struct *ss_in_d, *ss_in_h, *ss_out_d, *ss_out_h, *ss_check_h;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

typedef void (*KPtr)(const Some_Struct *dout, const Some_Struct *din);

extern "C" __global__ void
ss_l1ro
(Some_Struct* __restrict__ ss_out, const Some_Struct* __restrict__ ss_in)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  for ( int h=tid; h<d_app.n_elts; h += num_threads )
    {
      Some_Struct elt = ss_in[h];
      Some_Struct elt_out;
      bool ord = elt.f0 <= elt.f1;
      elt_out.f0 = ord ? elt.f0 : elt.f1;
      elt_out.f1 = ord ? elt.f1 : elt.f0;
      int delta = elt.f0 == elt.f1 ? 0 : ord ? -1 : 1;
      for ( int i=0; i<slen; i++ ) elt_out.str[i] = elt.str[i] + delta;
      ss_out[h] = elt_out;
    }
}

extern "C" __global__ void
ss_g_only(Some_Struct* ss_out, const Some_Struct* ss_in)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  for ( int h=tid; h<d_app.n_elts; h += num_threads )
    {
      Some_Struct elt = ss_in[h];
      Some_Struct elt_out;
      bool ord = elt.f0 <= elt.f1;
      elt_out.f0 = ord ? elt.f0 : elt.f1;
      elt_out.f1 = ord ? elt.f1 : elt.f0;
      int delta = elt.f0 == elt.f1 ? 0 : ord ? -1 : 1;
      for ( int i=0; i<slen; i++ ) elt_out.str[i] = elt.str[i] + delta;
      ss_out[h] = elt_out;
    }
}

typedef int4 my_type;
// typedef Some_Struct my_type;

extern "C" __global__ void
ss_sh(Some_Struct* ss_out, const Some_Struct* ss_in)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int ss_size_words = sizeof(Some_Struct) / sizeof(my_type);

  __shared__ Some_Struct ss_blk[1024];

  // Cast pointers to Some_Struct to pointers to integers so that
  // Some_Struct data can be moved around as a simple array of integers.
  //
  my_type* const ss_blk_wds = (my_type*) &ss_blk[0];
  my_type* const ss_in_wds = (my_type*) &ss_in[0];
  my_type* const ss_out_wds = (my_type*) &ss_out[0];

  /// SOLUTION

  // Prepare some common warp-related constants values.
  //
  const int wp_lg = 5;
  const int wp_sz = 1 << wp_lg;
  assert( wp_sz == warpSize );
  const int wp_mk = wp_sz - 1;  // Warp mask.
  const int lane = tid & wp_mk;
  const int wp_num = threadIdx.x >> wp_lg;

  for ( int h=tid; h<d_app.n_elts; h += num_threads )
    {
      // Compute element number accessed by first thread in this warp.
      const int h_wp = h - lane;
      // Compute word number accessed by first thread in this warp.
      const int h_wds = h_wp * ss_size_words + lane;

      // Load elements (structures) operated on by this warp.
      for ( int i=0; i<ss_size_words; i++ )
        ss_blk_wds[     wp_num * wp_sz * ss_size_words + lane + i * wp_sz    ]
          = ss_in_wds[h_wds + i * wp_sz];

      Some_Struct  elt = ss_blk[  threadIdx.x   ];
      Some_Struct& elt_out = ss_blk[threadIdx.x];

      bool ord = elt.f0 <= elt.f1;
      elt_out.f0 = ord ? elt.f0 : elt.f1;
      elt_out.f1 = ord ? elt.f1 : elt.f0;
      int delta = elt.f0 == elt.f1 ? 0 : ord ? -1 : 1;
      for ( int i=0; i<slen; i++ ) elt_out.str[i] += delta;

      // Store elements (structures) operated on by this warp.
      for ( int i=0; i<ss_size_words; i++ )
        ss_out_wds[h_wds + i * wp_sz]
          = ss_blk_wds[ wp_num * wp_sz * ss_size_words + lane + i * wp_sz];
    }
}



GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  gpu_info_print();

  // Determine which GPU to use. (For starters, if there's more than
  // one, choose the one connected to the display.)
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(ss_g_only);
  info.GET_INFO(ss_l1ro);
  info.GET_INFO(ss_sh);

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
  // Must be called before any CUDA API calls.
  NPerf_init();

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
  const bool opt_p = argc >= 3 && string(argv[2]) == "p";
  const int thd_per_block_arg = argc < 3 ? 1024 : opt_p ? 0 : atoi(argv[2]);
  const int thd_per_block_goal =
   thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array. Fractional values okay.
  //
  app.n_elts = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( num_threads <= 0 || app.n_elts <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK|p] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  // Collect performance data using a wrapper to NVIDIA CUPTI event
  // counter API.
  //
  NPerf_metric_collect("inst_executed");
  NPerf_metric_collect("gld_efficiency");
  if ( opt_p )
    {
      NPerf_metric_collect("gst_efficiency");
      NPerf_metric_collect("l2_read_throughput");
      NPerf_metric_collect("l2_write_throughput");
      NPerf_metric_collect("dram_read_throughput");
      NPerf_metric_collect("dram_write_throughput");
      NPerf_metric_collect("shared_load_transactions_per_request");
    }
  //
  // Note: The more metrics that are collected, the more times a kernel
  // will need to be run.

  // Don't collect performance data if we are varying warps. Why?
  // Because it takes too long.
  if ( false )
    NPerf_metrics_off();

  const size_t in_size_elts = app.n_elts;
  const size_t in_size_bytes = in_size_elts * sizeof( app.ss_in_h[0] );
  const size_t out_size_elts = app.n_elts;
  const size_t out_size_bytes = out_size_elts * sizeof( app.ss_out_h[0] );

  const int overrun_size_elts = thd_per_block_goal * 32;
  const int overrun_size_bytes = overrun_size_elts * sizeof( app.ss_out_h[0] );

  // Allocate storage for CPU copy of data.
  //
  vector<Some_Struct> ss_in_v(in_size_elts);
  vector<Some_Struct> ss_out_v(in_size_elts);
  vector<Some_Struct> ss_check_v(in_size_elts);
  app.ss_in_h = ss_in_v.data();
  app.ss_out_h = ss_out_v.data();
  app.ss_check_h = ss_check_v.data();

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.ss_in_d,   in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.ss_out_d,  in_size_bytes + overrun_size_bytes ) );

  printf("Array size: %d.  Grid: %d blocks of %d thds.\n",
         app.n_elts, num_blocks, thd_per_block_goal);
  printf("Structure Size: %zd B,  slen = %d\n",
         sizeof(Some_Struct), slen);

  // Initialize input array.
  //
  for ( int i=0; i<app.n_elts; i++ )
    {
      Some_Struct& elt = ss_in_v[i];
      elt.f0 = drand48();
      elt.f1 = drand48();
      for ( int j=0; j<slen; j++ ) elt.str[j] = random();
      Some_Struct& elt_out = ss_check_v[i];
      bool ord = elt.f0 <= elt.f1;
      elt_out.f0 = ord ? elt.f0 : elt.f1;
      elt_out.f1 = ord ? elt.f1 : elt.f0;
      int delta = elt.f0 == elt.f1 ? 0 : ord ? -1 : 1;
      for ( int i=0; i<slen; i++ ) elt_out.str[i] = elt.str[i] + delta;
    }

  const int64_t num_ops = app.n_elts * ( 3 + slen );

  // Amount of data in and out of GPU chip.
  const int64_t amt_data_bytes = in_size_bytes + out_size_bytes;

  double elapsed_time_s = 86400; // Reassigned to minimum run time.
  const int output_width = stdout_width_get();
  int n_errors_all = 0;

  {
    // Prepare events used for timing.
    //
    cudaEvent_t gpu_start_ce, gpu_stop_ce;
    CE(cudaEventCreate(&gpu_start_ce));
    CE(cudaEventCreate(&gpu_stop_ce));

    // Copy input array from CPU to GPU.
    //
    CE( cudaMemcpy
        ( app.ss_in_d, app.ss_in_h, in_size_bytes, cudaMemcpyHostToDevice ) );

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

        pTable table;

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop; wp_cnt += wp_inc )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            // Zero the output array.
            //
            CE(cudaMemset(app.ss_out_d,0,out_size_bytes));

            // Measure execution time starting "now", which is after data
            // set to GPU.
            //
            CE(cudaEventRecord(gpu_start_ce,0));

            // Launch Kernel
            //
            for ( NPerf_data_reset(); NPerf_need_run_get(); )
              KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>
                (app.ss_out_d,app.ss_in_d);

            // Stop measuring execution time now, which is before is data
            // returned from GPU.
            //
            CE(cudaEventRecord(gpu_stop_ce,0));
            CE(cudaEventSynchronize(gpu_stop_ce));
            float cuda_time_ms = -1.1;
            CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

            const double this_elapsed_time_s =
              NPerf_metrics_collection_get()
              ? NPerf_kernel_et_get() : cuda_time_ms * 0.001;

            const double thpt_compute_gflops =
              num_ops / this_elapsed_time_s * 1e-9;
            const double thpt_data_gbps =
              amt_data_bytes / this_elapsed_time_s * 1e-9;

            if ( vary_warps )
              {
                const double comp_frac =
                  1e9 * thpt_compute_gflops
                  / ( sizeof(Some_Struct::f0) == 4 ? info.chip_sp_flops :
                      sizeof(Some_Struct::f0) == 8 ? info.chip_dp_flops : 1 );
                const double comm_frac =
                  min(2.0,1e9 * thpt_data_gbps / info.chip_bw_Bps);

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

                table.row_start();
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%4.0f", this_elapsed_time_s * 1e6);
                table.entry
                  ("I/op","%4.1f",
                   NPerf_metric_value_get("inst_executed") * 32.0 / num_ops );
                if ( opt_p )
                  {
                    table.header_span_start("Req U %");
                    table.entry
                      ("Ld","%3.0f",
                       NPerf_metric_value_get("gld_efficiency"));
                    table.entry
                      ("St","%3.0f",
                       NPerf_metric_value_get("gst_efficiency"));
                    table.header_span_end();
                    table.entry
                      ("Shx","%4.1f",
                       NPerf_metric_value_get
                       ("shared_load_transactions_per_request"));
                    table.header_span_start("L2 Cache");
                    table.entry
                      ("Rd θ","%5.1f",
                       NPerf_metric_value_get("l2_read_throughput") * 1e-9 );
                    table.entry
                      ("Wr θ","%5.1f",
                       NPerf_metric_value_get("l2_write_throughput") * 1e-9 );
                    table.header_span_end();
                    table.header_span_start("DRAM");
                    table.entry
                      ("Rd θ","%5.1f",
                       NPerf_metric_value_get("dram_read_throughput") * 1e-9 );
                    table.entry
                      ("Wr θ","%5.1f",
                       NPerf_metric_value_get("dram_write_throughput") * 1e-9 );
                    table.header_span_end();
                  }

                const bool plot_bandwidth = true;

                if ( ! plot_bandwidth )
                  table.entry("FP θ","%4.0f", thpt_compute_gflops);
                table.entry("GB/s","%4.0f", thpt_data_gbps);

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);

                string util_hdr =
                  plot_bandwidth ? "Data BW Util" : "FP Utilization";
                const double frac = plot_bandwidth ? comm_frac : comp_frac;
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                table.entry
                  (util_hdr,fmt,
                   string( size_t(max(0.0,frac*max_st_len)), '*' ),
                   pTable::pT_Left);

              } else {

              printf
                ("%-15s %2d wp  %7.0f µs  %8.3f GF  %8.3f GB/s  "
                 "%5.2f I/F  %5.1f%%\n",
                 info.ki[kernel].name,
                 (thd_per_block + 31 ) >> 5,
                 this_elapsed_time_s * 1e6,
                 thpt_compute_gflops, thpt_data_gbps,
                 NPerf_metric_value_get("inst_executed") * 32 / num_ops,
                 NPerf_metric_value_get("gld_efficiency")
                 );
            }

            elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( app.ss_out_h, app.ss_out_d,
                  out_size_bytes, cudaMemcpyDeviceToHost) );
            int err_count = 0;
            for ( int i=0; i<app.n_elts; i++ )
                {
                  Some_Struct eo = app.ss_out_h[i];
                  Some_Struct ec = app.ss_check_h[i];
                  int nd = 0;
                  for ( int j=0; j<slen; j++ ) nd += eo.str[j] != ec.str[j];
                  if ( eo.f0 != ec.f0 || eo.f1 != ec.f1 || nd )
                    {
                      err_count++;
                      n_errors_all++;
                      if ( err_count < 5 )
                        printf("Error at elt %d: "
                               "(%.2f,%.2f) != (%.2f,%.2f) (correct) %d nd\n",
                               i, eo.f0,eo.f1, ec.f0,ec.f1,nd);
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
        printf("%s",table.body_get());
      }
  }
  printf("Run completed, total errors: %d\n",n_errors_all);
}
