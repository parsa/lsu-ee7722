/// LSU EE 7722 GPU Microarchitecture
//
 /// Spring 2019
 /// Homework 2
 //
 //  Assignment: https://www.ece.lsu.edu/koppel/gp/2019/hw02.pdf
 //
 //  Modify this file only.


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
#include <assert.h>
#include <nperf.h>
#include "util.h"
#include <ptable.h>

#define N 24
#define M 24


// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;


// Vector of Four Elt_Types. Used instead of a float4.
//
struct __builtin_align__(4*sizeof(Elt_Type)) __align__(4*sizeof(Elt_Type))
  Elt_Type4
{
  // Elements can be accessed using homogeneous vector component names.
  Elt_Type x, y, z, w;

  // Elements can also be accessed as a 4-element array.
  __host__ __device__ Elt_Type& operator [] (int i)
  { return i==0?x:i==1?y:i==2?z:w; }
};

struct App
{
  // Number of input and output vectors, that is, the size of the
  // input and output arrays.
  //
  int num_vecs;

  Elt_Type matrix[M][N];

  // Host pointers to the input and output arrays, and to a CPU-computed
  // output array used for checking results.
  //
  Elt_Type *h_in, *h_out, *h_out_check;
  //
  // Note: h_in points to an array holding num_vecs N-element vectors,
  //       and so the total size of h_in is num_vects * N elements.

  // GPU pointers to the input and output arrays.
  //
  Elt_Type *d_in, *d_out;

  // GPU pointers to the input and output arrays, cast to Elt_Type4's.
  //
  Elt_Type4 *d_in_f4, *d_out_f4;
  //
  // The compiler can emit more efficient load and store instructions
  // to Elt_Type4 elements than to four consecutive floats.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);


extern "C" __global__ void
mxv_g_only(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  // Relay on the compiler to use the read-only cache for din.
  //
  // Note that dout and d_app.d_out hold the same address, as do din
  // and d_app.d_in.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    for ( int r=0; r<M; r++ )
      {
        Elt_Type elt = 0;
        for ( int c=0; c<N; c++ ) elt += d_app.matrix[r][c] * din[ h * N + c ];
        dout[ h * M + r ] = elt;
      }
}

extern "C" __global__ void
mxv_vec_ld()
{
  // Read and write vector components as Elt_Type4.
  // This should use more, but not all, of a 32-B request for float elements.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;
  const int nq = N/4;  // One quarter of N.

  for ( int h=tid; h<d_app.num_vecs; h += num_threads )
    {
      // Read elements as Elt_Type4.
      Elt_Type4 vin[nq];
      for ( int i=0; i<nq; i++ ) vin[i] = d_app.d_in_f4[ h * ( N >> 2 ) + i ];

      Elt_Type vout[M];

      // Note: Unrolling this loop avoids local memory access.
#     pragma unroll
      for ( int r=0; r<M; r++ )
        {
          vout[r] = 0;
          for ( int c=0; c<N; c += 4 )
            for ( int i=0; i<4; i++ )
              vout[r] += d_app.matrix[r][c+i] * vin[c/4][i];
        }
      for ( int r=0; r<M; r+=4 )
        d_app.d_out_f4[ ( h * M + r ) >> 2 ] =
          Elt_Type4( { vout[r], vout[r+1], vout[r+2], vout[r+3] } );
    }
}



extern "C" __global__ void
mxv_o_per_thd()
{
  // Assign one vector to M threads, each thread computes one element.
  //
  // This arrangement avoids the need for any local memory buffering
  // and results in efficient global memory writes. Global memory
  // reads are still inefficient.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid / M;  // First vector number computed by this thread.
  const int r = tid % M;      // Vector element computed by this thread.

  const int stop = d_app.num_vecs;
  const int inc = num_threads / M;

  for ( int h=start; h<stop; h += inc )
    {
      // Operate on vector number h, compute output vector element r.

      Elt_Type vout = 0;
      for ( int c=0; c<N; c++ )
        vout += d_app.matrix[r][c] * d_app.d_in[ h * N + c ];

      d_app.d_out[ h * M + r ] = vout;
    }
}

extern "C" __global__ void
mxv_o_per_thd_sol()
{
  // Assign one vector to M threads, each thread computes one element.
  //
  // This arrangement avoids the need for any local memory buffering and
  // results in efficient global memory writes. 

  /// Homework 2:
  //  Modify so that input vectors read as Elt_Type4's.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid / M;  // First vector number computed by this thread.
  const int r = tid % M;      // Vector element computed by this thread.

  const int stop = d_app.num_vecs;
  const int inc = num_threads / M;

  for ( int h=start; h<stop; h += inc )
    {
      // Operate on vector number h, compute output vector element r.

      Elt_Type vout = 0;
      for ( int c=0; c<N; c++ )
        vout += d_app.matrix[r][c] * d_app.d_in[ h * N + c ];

      d_app.d_out[ h * M + r ] = vout;
    }
}


const int mxv_sh_ochunk_CS = 8;

extern "C" __global__ void
mxv_sh_ochunk()
{
  const int CS = mxv_sh_ochunk_CS;

  // Have CS threads perform one multiplication.
  // Each thread writes M/CS elements. 

  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x / CS;
  const int stop = d_app.num_vecs;
  const int inc = num_threads / CS;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_r_offset = threadIdx.x % CS;
  const int thd_v_offset = threadIdx.x / CS;

  const int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE];

  const int ML = ( M + CS - 1 ) / CS;

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      Elt_Type vout[ML];
      for ( int rl=0; rl<ML; rl++ ) vout[rl] = 0;

#pragma unroll
      for ( int c=0; c<N; c += CS )
        {
          Elt_Type vin[CS];

          // Read in one vector component, and put it in shared memory.
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * N + c + thd_c_offset ];

          // Read CS components, one we loaded, the others by our neighbors.
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          for ( int rr=0; rr<ML; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }
#pragma unroll
      for ( int rr=0; rr<ML; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          d_app.d_out[ ( hb + thd_v_offset ) * M + r ] = vout[rr];
        }

    }
}

extern "C" __global__ void
mxv_sh_ochunk_sol()
{
  const int CS = mxv_sh_ochunk_CS;

  // Have CS threads perform one multiplication.
  // Each thread writes M/CS elements. 

  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x / CS;
  const int stop = d_app.num_vecs;
  const int inc = num_threads / CS;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_r_offset = threadIdx.x % CS;
  const int thd_v_offset = threadIdx.x / CS;

  const int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE];

  const int ML = ( M + CS - 1 ) / CS;

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      Elt_Type vout[ML];
      for ( int rl=0; rl<ML; rl++ ) vout[rl] = 0;

#pragma unroll
      for ( int c=0; c<N; c += CS )
        {
          Elt_Type vin[CS];

          // Read in one vector component, and put it in shared memory.
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * N + c + thd_c_offset ];

          // Read CS components, one we loaded, the others by our neighbors.
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          for ( int rr=0; rr<ML; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }
#pragma unroll
      for ( int rr=0; rr<ML; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          d_app.d_out[ ( hb + thd_v_offset ) * M + r ] = vout[rr];
        }
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
  dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(mxv_g_only);
  info.GET_INFO(mxv_vec_ld);

  info.GET_INFO(mxv_o_per_thd);
  info.GET_INFO(mxv_o_per_thd_sol);

  info.GET_INFO(mxv_sh_ochunk);
  info.GET_INFO(mxv_sh_ochunk_sol);

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
  const bool debug = false;

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

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.num_vecs = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( num_threads <= 0 || app.num_vecs <= 0 )
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
    }
  //
  // Note: The more metrics that are collected, the more times a kernel
  // will need to be run.

  // Don't collect performance data if we are varying warps. Why?
  // Because it takes too long.
  if ( false )
    NPerf_metrics_off();

  const size_t in_size_elts = size_t(app.num_vecs) * N;
  const size_t in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const size_t out_size_elts = size_t(app.num_vecs) * M;
  const size_t out_size_bytes = out_size_elts * sizeof( app.h_out[0] );

  const int overrun_size_elts = thd_per_block_goal * max(N,M);
  const int overrun_size_bytes = overrun_size_elts * sizeof( app.h_out[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new Elt_Type[ in_size_elts ];
  app.h_out = new Elt_Type[ out_size_elts ];
  app.h_out_check = new Elt_Type[ out_size_elts ];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  app.d_in_f4 = (Elt_Type4*) app.d_in;
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );
  app.d_out_f4 = (Elt_Type4*) app.d_out;

  printf("Matrix size: %d x %d.  Vectors: %d.   %d blocks of %d thds.\n",
         N, M, app.num_vecs, num_blocks, thd_per_block_goal);

  // Initialize input array.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    for ( int c=0; c<N; c++ )
      app.h_in[ i * N + c ] = debug ? Elt_Type(c) : drand48();

  // Initialize transformation matrix.
  //
  for ( int r=0; r<M; r++ )
    for ( int c=0; c<N; c++ )
      app.matrix[r][c] = debug ? r == c : drand48();

  // Compute correct answer.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    for ( int r=0; r<M; r++ )
      {
        app.h_out_check[ i * M + r ] = 0;
        for ( int c=0; c<N; c++ )
          app.h_out_check[ i * M + r ] +=
            app.h_in[ i * N + c ] * app.matrix[r][c];
      }

  const int64_t num_ops_fp = int64_t(M) * N * app.num_vecs;  // Multiply-adds.
  const int64_t insns_addr = 4, insns_loop = 3;
  const int64_t insns_ld_st = N + M;
  const int64_t num_ops = num_ops_fp + insns_ld_st + insns_addr + insns_loop;

  // Amount of data in and out of GPU chip.
  const int64_t amt_data_bytes = in_size_bytes + out_size_bytes;

  double elapsed_time_s = 86400; // Reassigned to minimum run time.
  const int output_width = stdout_width_get();
#if 0
  // Analysis of mxv_o_lbuf:
  const double lat_mem_cyc = 345;
  const double lat_iter_cyc = lat_mem_cyc + M * N + M;
  const double lat_iter_s = lat_iter_cyc / ( info.cuda_prop.clockRate * 1e3 );
  const double data_iter_B = sizeof(Elt_Type) * ( M + N );
  const double p = info.chip_bw_Bps * lat_iter_s / data_iter_B;
  const int sm_thpt_ls = 64;
  const double ni_fp = N * M;
  const double ni_mem = N + M;
  const double t_issue_1 = ni_fp / (num_mp*info.cc_per_mp)
    + ni_mem / ( num_mp * sm_thpt_ls );
  const double q = lat_iter_cyc / t_issue_1;
  printf("Analysis for mxv_o_lbuf: L = %.1f ns, "
         "p = %.1f wp/sm,  q= %.1f wp/sm\n",
         lat_iter_s * 1e9, p/32/num_mp, q/32/num_mp );
#endif
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
    printf("Launching with %d blocks of up to %d threads. \n",
           num_blocks, thd_per_block_goal);

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        cudaFuncAttributes& cfa = info.ki[kernel].cfa;
        const auto func_ptr = info.ki[kernel].func_ptr;
        const int wp_limit = cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary = min(thd_per_block_goal,thd_limit);

        const int wp_start = 1;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 4;

        const int thd_per_vec =
          func_ptr == mxv_o_per_thd || func_ptr == mxv_o_per_thd_sol ? M :
          func_ptr == mxv_sh_ochunk || func_ptr == mxv_sh_ochunk_sol
          ? mxv_sh_ochunk_CS : 1;

        pTable table(stdout);

        for ( int wp_cnt = wp_start; wp_cnt <= wp_stop;
              wp_cnt += ( wp_cnt < 4 ? 1 : wp_inc ) )
          {
            const int thd_per_block =
              vary_warps ? wp_cnt << 5 : thd_per_block_no_vary;

            // Zero the output array.
            //
            CE(cudaMemset(app.d_out,0,out_size_bytes));

            // Measure execution time starting "now", which is after data
            // set to GPU.
            //
            CE(cudaEventRecord(gpu_start_ce,0));

            // Launch Kernel
            //
            for ( NPerf_data_reset(); NPerf_need_run_get(); )
              KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>
                (app.d_out,app.d_in);

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
                  / ( sizeof(Elt_Type) == 4 ? info.chip_sp_flops :
                      sizeof(Elt_Type) == 8 ? info.chip_dp_flops : 1 );
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
                const int act_thds_gpu =
                  min( num_mp * act_wps * 32, num_blocks * thd_per_block );

                const double iter_per_thd =
                  thd_per_vec * app.num_vecs / act_thds_gpu;

                if ( wp_cnt == wp_start )
                  printf("Kernel %s:\n", info.ki[kernel].name);

                pTable_Row row(table);
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry("Lw/µs","%6.1f",
                            this_elapsed_time_s*1e6 / iter_per_thd );
                table.entry
                  ("I/op","%4.1f",
                   NPerf_metric_value_get("inst_executed") * 32.0 / num_ops );
                if ( opt_p )
                  {
                    table.header_span_start("R-Eff-%");
                    table.entry
                      ("Ld","%3.0f",
                       NPerf_metric_value_get("gld_efficiency"));
                    table.entry
                      ("St","%3.0f",
                       NPerf_metric_value_get("gst_efficiency"));
                    table.header_span_end();
                    table.header_span_start("L2-Cache");
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
                ( app.h_out, app.d_out, out_size_bytes, cudaMemcpyDeviceToHost) );
            int err_count = 0;
            for ( int i=0; i<app.num_vecs; i++ )
              for ( int r=0; r<M; r++ )
                {
                  const int idx = i * M + r;

                  if ( fabs( app.h_out_check[idx] - app.h_out[idx] ) > 1e-5 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf("Error at vec %d elt %d: %.7f != %.7f (correct)\n",
                               i, r, app.h_out[idx], app.h_out_check[idx] );
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }

}
