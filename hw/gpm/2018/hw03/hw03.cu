/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 3 - Spring 2018
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2018/hw03.pdf

 /// Documentation
//
//   c++:  http://en.cppreference.com
//   CUDA: http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html
//   CUDA debugger: https://docs.nvidia.com/cuda/cuda-gdb/index.html

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

// Maximum size of matrix.
#define N 64

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

struct App
{
  // Number of input and output vectors, that is, the size of the
  // input and output arrays.
  //
  int num_vecs;

  Elt_Type matrix[N][N];

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

  // GPU pointers to the input and output arrays, cast to float4s.
  //
  float4 *d_in_f4, *d_out_f4;
  //
  // The compiler can emit more efficient load and store instructions
  // to float4 elements than to four consecutive floats.
  //
  // Note: These "_f4" pointers only work when Elt_Type is a float.

  // Size of matrix to use.
  int n;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);

template <int eN> __device__ void
mxv_sh_ochunk()
{
  /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
  //  Instead, modify mxv_sh_ochunk_sol_mn.

  // Matrix size is eN by eN.
  // Since size in this case is a compile-time constant code will
  // be of higher quality.

  // First things, first. Make sure that the problem size
  // matches the specialization.

  const int tid = blockIdx.x * blockDim.x + threadIdx.x;
  assert( tid != 0 || eN == d_app.n );

  const int CS = 8;  // Chunk Size: Number of input vector components to read.
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

  // Maximum number of output vector components written per thread,
  // based on vector size, eN.
  const int NL = eN / CS;

  /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
  //  Instead, modify mxv_sh_ochunk_sol_mn.

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      // Initialize output vector components to zero.
      Elt_Type vout[NL];
      for ( auto& v: vout ) v = 0;

#pragma unroll
      for ( int c=0; c<eN; c += CS )
        {
          // This thread along with CS-1 of its neighbors load CS
          // components of an input vector.
          //
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * eN + c + thd_c_offset ];

          // Copy input vector components from shared to local address space.
          //
          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          // Using the CS input vector components, compute part
          // of our NL output vector components.
          for ( int rr=0; rr<NL; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }

#pragma unroll
      // Write output vector components to global memory.
      for ( int rr=0; rr<NL; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          d_app.d_out[ ( hb + thd_v_offset ) * eN + r ] = vout[rr];
        }
    }
}

// Instantiate versions for 16 by 16 and 32 by 32 matrices.
extern "C" __global__ void mxv_sh_ochunk_64(){ mxv_sh_ochunk<64>(); }
extern "C" __global__ void mxv_sh_ochunk_32(){ mxv_sh_ochunk<32>(); }
extern "C" __global__ void mxv_sh_ochunk_16(){ mxv_sh_ochunk<16>(); }


extern "C" __global__ void
mxv_sh_ochunk_mn()
{
  /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
  //  Instead, modify mxv_sh_ochunk_sol_mn.

  // Matrix size is in d_app structure. d_app.n by d_app.n.

  const int CS = 8;  // Chunk Size: Number of input vector components to read.
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x / CS;
  const int stop = d_app.num_vecs;
  const int inc = num_threads / CS;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_r_offset = thd_c_offset;
  const int thd_v_offset = threadIdx.x / CS;

  const int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE];

  const int n = d_app.n;

  // Maximum number of output vector components written per thread,
  // based on maximum vector size, N.
  const int NL = N / CS;
  // Number of output vector components written per thread based on
  // vector size, n.
  const int nl =  n / CS;

  /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
  //  Instead, modify mxv_sh_ochunk_sol_mn.

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      // Initialize output vector components to zero. Note that the
      // code initializes for the maximum number of components
      // assigned to this thread, NL, not the actual number, nl or
      // nl-1.
      Elt_Type vout[NL];
      for ( auto& v: vout ) v = 0;

      for ( int c=0; c<n; c += CS )
        {
          // This thread along with CS-1 of its neighbors load CS
          // components of an input vector.
          //
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * n + c + thd_c_offset ];

          // Copy input vector components from shared to local address space.
          //
          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          // Using the CS input vector components, compute part
          // of our nl output vector components.
          for ( int rr=0; rr<nl; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }

      /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
      //  Instead, modify mxv_sh_ochunk_sol_mn.

      // Write output vector components to global memory.
      for ( int rr=0; rr<nl; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          d_app.d_out[ ( hb + thd_v_offset ) * n + r ] = vout[rr];
        }
    }
  /// DO NOT MODIFY THIS ROUTINE. USE IT FOR COMPARISON.
  //  Instead, modify mxv_sh_ochunk_sol_mn.
}


extern "C" __global__ void
mxv_sh_ochunk_sol_mn()
{
  /// PUT SOLUTION IN ↓↓ THIS ROUTINE ↓↓.

  // Matrix size is in d_app structure. d_app.n by d_app.n.

  const int CS = 8;  // Chunk Size: Number of input vector components to read.
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x / CS;
  const int stop = d_app.num_vecs;
  const int inc = num_threads / CS;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_r_offset = thd_c_offset;
  const int thd_v_offset = threadIdx.x / CS;

  const int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE];

  const int n = d_app.n;

  // Maximum number of output vector components written per thread,
  // based on maximum vector size, N.
  const int NL = N / CS;
  // Number of output vector components written per thread based on
  // vector size, n.
  const int nl =  n / CS;

  /// PUT SOLUTION IN ↕↕ THIS ROUTINE ↕↕.

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      // Initialize output vector components to zero. Note that the
      // code initializes for the maximum number of components
      // assigned to this thread, NL, not the actual number, nl or
      // nl-1.
      Elt_Type vout[NL];
      for ( auto& v: vout ) v = 0;

      for ( int c=0; c<n; c += CS )
        {
          // This thread along with CS-1 of its neighbors load CS
          // components of an input vector.
          //
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * n + c + thd_c_offset ];

          // Copy input vector components from shared to local address space.
          //
          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          // Using the CS input vector components, compute part
          // of our nl output vector components.
          for ( int rr=0; rr<nl; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }

      // Write output vector components to global memory.
      for ( int rr=0; rr<nl; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          d_app.d_out[ ( hb + thd_v_offset ) * n + r ] = vout[rr];
        }
    }

  /// PUT SOLUTION IN ↑↑ THIS ROUTINE ↑↑.
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
#if 0
  info.GET_INFO(mxv_sh_ochunk_sol_mn);
#else
  info.GET_INFO(mxv_sh_ochunk_16);
  info.GET_INFO(mxv_sh_ochunk_32);
  info.GET_INFO(mxv_sh_ochunk_64);
  info.GET_INFO(mxv_sh_ochunk_sol_mn);
  info.GET_INFO(mxv_sh_ochunk_mn);
#endif

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
  // When debug true: matrix is identity and for each vector v_i=i
  // (component i is set to value i).
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
  if ( opt_p )
    {
      NPerf_metric_collect("gld_efficiency");
      NPerf_metric_collect("l2_read_throughput");
      NPerf_metric_collect("l2_write_throughput");
      NPerf_metric_collect("flop_sp_efficiency");
      NPerf_metric_collect("shared_efficiency");
    }
  //
  // Note: The more metrics that are collected, the more times a kernel
  // will need to be run.

  if ( false ) NPerf_metrics_off();

  const size_t in_size_elts = size_t(app.num_vecs) * N;
  const size_t in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const size_t out_size_elts = size_t(app.num_vecs) * N;
  const size_t out_size_bytes = out_size_elts * sizeof( app.h_out[0] );

  const int overrun_size_elts = thd_per_block_goal * N * 32;
  const int overrun_size_bytes = overrun_size_elts * sizeof( app.h_out[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new Elt_Type[ in_size_elts ];
  app.h_out = new Elt_Type[ out_size_elts ];
  app.h_out_check = NULL;

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  app.d_in_f4 = (float4*) app.d_in;
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );
  app.d_out_f4 = (float4*) app.d_out;

  printf
    ("Max matrix: %d x %d.  Num vectors (S): %d.   Grid size: %d blocks.\n",
         N, N, app.num_vecs, num_blocks);
  printf("Elements per thread: %.1f (4 wp) - %.1f (32 wp)\n",
         double(app.num_vecs) / ( num_blocks * 4 * 32 ),
         double(app.num_vecs) / ( num_blocks * 32 * 32 ));

  // Initialize input array.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    for ( int c=0; c<N; c++ )
      app.h_in[ i * N + c ] = debug ? Elt_Type(c) : drand48();

  // Initialize matrix.
  //
  for ( int r=0; r<N; r++ )
    for ( int c=0; c<N; c++ )
      app.matrix[r][c] = debug ? r == c : drand48();

  struct Shape {
    Shape(int np):n(np),h_out_check(app.num_vecs*np){};
    Shape():n(0){};
    int n;
    vector<Elt_Type> h_out_check;
  };

  vector<int> sizes = { 64, 32, 16 };
  map<int,Shape> shapes;
  for ( auto n: sizes ) shapes.emplace(n,n);

  // Compute correct answers.
  //
  for ( auto& sh: shapes )
    {
      Shape& s = sh.second;
      assert( s.n <= N );
      for ( int i=0; i<app.num_vecs; i++ )
        for ( int r=0; r<s.n; r++ )
          {
            s.h_out_check[ i * s.n + r ] = 0;
            for ( int c=0; c<s.n; c++ )
              s.h_out_check[ i * s.n + r ] +=
                app.h_in[ i * s.n + c ] * app.matrix[r][c];
          }
    }

  app.h_out_check = shapes[N].h_out_check.data();

  struct KShape {
    KShape(int knop, Shape *sp, Kernel_Info *kip):kno(knop),s(sp),ki(kip){};
    const int kno;
    Shape* const s;
    Kernel_Info* const ki;
  };
  vector<KShape> kshapes;

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      Kernel_Info* const ki = &info.ki[kernel];
      string kn = ki->name;
      // Eagerly awaiting c++20 ends_with. RHEL should have it by 2035.
      string suffix = kn.substr(kn.size()-3,3);
      if ( suffix == "_mn" )
        for ( auto& sh: shapes ) kshapes.emplace_back(kernel,&sh.second,ki);
      else if ( suffix == "_64" )
        kshapes.emplace_back(kernel,&shapes[64],ki);
      else if ( suffix == "_32" )
        kshapes.emplace_back(kernel,&shapes[32],ki);
      else if ( suffix == "_16" )
        kshapes.emplace_back(kernel,&shapes[16],ki);
    }

  double elapsed_time_s = 86400; // Reassigned to minimum run time.
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

    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d threads. \n",
           num_blocks, thd_per_block_goal);

    for ( KShape ks: kshapes )
      {
        const int kernel = ks.kno;
        Kernel_Info* const ki = ks.ki;
        cudaFuncAttributes& cfa = ki->cfa;
        const int wp_limit = cfa.maxThreadsPerBlock >> 5;

        const int thd_limit = wp_limit << 5;
        const int thd_per_block_no_vary = min(thd_per_block_goal,thd_limit);

        const int wp_start = 4;
        const int wp_stop = vary_warps ? wp_limit : wp_start;
        const int wp_inc = 4;

        app.n = ks.s ? ks.s->n : N;
        assert( app.n > 0 );

        const int64_t num_ops =   // Multiply-adds.
          int64_t(app.n) * app.n * app.num_vecs;

        // Amount of data in and out of GPU chip.
        const int64_t amt_data_bytes =
          sizeof(app.h_in[0]) * app.num_vecs * ( app.n + app.n );

        // Copy App structure to GPU.
        //
        CE( cudaMemcpyToSymbol
            ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

        pString msize = pStringF("(%d,%d)",app.n,app.n);

        pTable table;
        table.stream = stdout;

        for ( int wp_cnt = 0, wp_iter = wp_start;
              wp_cnt < wp_stop && ( wp_cnt = min(wp_iter,wp_stop) );
              wp_iter += wp_inc )
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

                if ( wp_cnt == wp_start )
                  printf("Kernel %s%s:\n", info.ki[kernel].name, msize.s);

                table.row_start();
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("t/µs","%6.0f", this_elapsed_time_s * 1e6);
                table.entry
                  ("I/op","%4.1f",
                   NPerf_metric_value_get("inst_executed") * 32.0 / num_ops );
                if ( opt_p )
                  {
                    table.entry
                      ("Ld eff","%5.1f%%",
                       NPerf_metric_value_get("gld_efficiency"));
                    table.entry
                      ("SM eff","%5.1f%%",
                       NPerf_metric_value_get("shared_efficiency"));
                    table.entry
                      ("L2rθ","%5.1f",
                       NPerf_metric_value_get("l2_read_throughput") * 1e-9 );
                    table.entry
                      ("L2wθ","%5.1f",
                       NPerf_metric_value_get("l2_write_throughput") * 1e-9 );
                    table.entry
                      ("FP%","%5.1f%%",
                       NPerf_metric_value_get("flop_sp_efficiency"));
                  }

                const bool plot_bandwidth = false;

                table.entry("GB/s","%4.0f", thpt_data_gbps);
                table.entry("FP θ","%4.0f", thpt_compute_gflops);

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);

                string util_hdr =
                  plot_bandwidth ? "Bandwidth Util" : "FP Utilization";
                const double frac = plot_bandwidth ? comm_frac : comp_frac;
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                table.entry
                  (util_hdr,fmt,
                   string( size_t(max(0.0,frac*max_st_len)), '*' ),
                   pTable::pT_Left);

              } else {

              printf
                ("%-20s %2d wp  %7.0f µs  %8.3f GF  %8.3f GB/s  "
                 "%5.2f I/F\n",
                 info.ki[kernel].name,
                 (thd_per_block + 31 ) >> 5,
                 this_elapsed_time_s * 1e6,
                 thpt_compute_gflops, thpt_data_gbps,
                 NPerf_metric_value_get("inst_executed") * 32 / num_ops
                 );
            }

            table.row_end();

            elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( app.h_out, app.d_out, out_size_bytes,
                  cudaMemcpyDeviceToHost) );
            int err_count = 0;
            Elt_Type* const h_out_check =
              ks.s ? ks.s->h_out_check.data() : app.h_out_check;
            for ( int i=0; i<app.num_vecs; i++ )
              for ( int r=0; r<app.n; r++ )
                {
                  const int idx = i * app.n + r;

                  if ( fabs( h_out_check[idx] - app.h_out[idx] ) > 1e-5 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf
                          ("Error at vec %d elt %d: %.7f != %.7f (correct)\n",
                               i, r, app.h_out[idx], h_out_check[idx] );
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }
}
