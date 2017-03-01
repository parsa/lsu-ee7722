/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 1 - Spring 2017
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2017/hw02.pdf

 /// Documentation
//
//   c++:  http://en.cppreference.com
//   CUDA: http://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html


#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <new>
#include <string>
#include <assert.h>
#include <time.h>
#include <ctype.h>
#include <unistd.h>
#include <stdlib.h>

#include <cuda_runtime.h>
#include <gp/cuda-gpuinfo.h>

using namespace std;

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}

// Matrix dimension. (Matrix size will be N by N.)
//
const int N = 16;

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

const char* elt_type_str(float f){ return "float"; }
const char* elt_type_str(double f){ return "double"; }
const char* elt_type_str(int f){ return "int"; }

struct App
{
  // Number of input and output matrices.
  //
  int n_mats;

  // Host pointers to the input and output arrays, and to a CPU-computed
  // output array used for checking results.
  //
  Elt_Type *h_in, *h_out, *h_out_check;
  //
  // Note: h_in points to an array holding n_mats N by N-element matrices
  //       and so the total size of h_in is n_mats * N * N elements.

  // GPU pointers to the input and output arrays.
  //
  Elt_Type *d_in, *d_out;
};


// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);


extern "C" __global__ void
mxm_g_only(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;
  const int stop = d_app.n_mats;
  const int inc = num_threads;

  auto idx = [](int i,int r,int c) { return i * N*N + r * N + c; };

  for ( int h=start; h<stop; h += inc )
    {
      for ( int r=0; r<N; r++ )
        {
          for ( int c=0; c<N; c++ )
            {
              Elt_Type elt_rc = 0;
              for ( int k=0; k<N; k++ )
                elt_rc += din[ idx( h, r, k ) ] * din[ idx( h, k, c ) ];
              dout[ idx( h, r, c ) ] = elt_rc;
            }
        }
    }
}


template<int thds_per_mat>
__global__ void
mxm_g_split(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  /// HOMEWORK 2 Problem 2 solution in this routine.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  auto idx = [](int i,int r,int c) { return i * N*N + r * N + c; };

  const int start = tid;
  const int stop = d_app.n_mats;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    {
      for ( int r=0; r<N; r++ )
        {
          for ( int c=0; c<N; c++ )
            {
              Elt_Type elt_rc = 0;
              for ( int k=0; k<N; k++ )
                elt_rc += din[ idx( h, r, k ) ] * din[ idx( h, k, c ) ];
              dout[ idx( h, r, c ) ] = elt_rc;
            }
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
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(mxm_g_only);

  /// Homework 2: Add mxm_g_split specializations as needed.
  //
  info.GET_INFO(mxm_g_split<1>);
  info.GET_INFO(mxm_g_split<8>);

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

  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_and_kernel_info();

  const int num_mp = info.cuda_prop.multiProcessorCount;

  const int nsq = N * N;

  // Examine argument 1, block count, default is number of MPs.
  // Negative value is a multiple of the number of MPs.
  //
  const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
  const int num_blocks =
    arg1_int == 0 ? num_mp :
    arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

  // Examine argument 2, number of threads per block.
  // Zero means vary the number of threads in multiples of 32.
  //
  const int thd_per_block_arg = argc < 3 ? 0 : atoi(argv[2]);
  const int thd_per_block_goal =
    thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  const int in_size_bytes_targ =
    argc < 4 ? 1 << 24 : int( atof(argv[3]) * (1<<20) );
  app.n_mats = in_size_bytes_targ / ( nsq * sizeof(app.h_in[0]) );

  if ( num_threads <= 0 || app.n_mats <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const size_t in_size_elts = size_t(app.n_mats) * nsq;
  const size_t in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const size_t out_size_elts = size_t(app.n_mats) * nsq;
  const size_t out_size_bytes = out_size_elts * sizeof( app.h_out[0] );

  const int overrun_size_elts = thd_per_block_goal * nsq;
  const int overrun_size_bytes = overrun_size_elts * sizeof( app.h_out[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new Elt_Type[ in_size_elts ];
  app.h_out = new Elt_Type[ out_size_elts ];
  app.h_out_check = new Elt_Type[ out_size_elts ];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf
    ("Input is %d  %d x %d matrices of %s, total size %zd bytes (%.1f MiB).\n",
     app.n_mats, N, N,
     elt_type_str(Elt_Type(1)), in_size_bytes,
     double(in_size_bytes)/(size_t(1)<<20));

#define IDX(i,r,c) ((i) * nsq + (r) * N + (c))

  // Initialize input array.
  //
  for ( int i=0; i<app.n_mats; i++ )
    for ( int r=0; r<N; r++ )
      for ( int c=0; c<N; c++ )
        app.h_in[ IDX(i,r,c) ] = debug ? Elt_Type(c) : drand48();

  // Compute correct answer.
  //
  for ( int i=0; i<app.n_mats; i++ )
    for ( int r=0; r<N; r++ )
      for ( int c=0; c<N; c++ )
        {
          app.h_out_check[IDX(i,r,c)] = 0;
          for ( int k=0; k<N; k++ )
            app.h_out_check[IDX(i,r,c)] +=
              app.h_in[IDX(i,r,k)] * app.h_in[IDX(i,k,c)];
        }

  const int64_t num_ops = int64_t(N) * nsq * app.n_mats;  // Multiply-adds.

  // Amount of data in and out of GPU chip.
  const int64_t amt_data_bytes = in_size_bytes + out_size_bytes;


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

  auto check = [&]()
    {
      int err_count = 0;
      for ( int i=0; i<app.n_mats; i++ )
        for ( int r=0; r<N; r++ )
          for ( int c=0; c<N; c++ )
            {
              const int idx = IDX(i,r,c);

              if ( fabs( app.h_out_check[idx] - app.h_out[idx] ) > 1e-5 )
                {
                  err_count++;
                  if ( err_count < 5 )
                    printf
                      ("Error at mat %d elt %d,%d: "
                       "%.7f != %.7f (correct)\n",
                       i, r, c, app.h_out[idx], app.h_out_check[idx] );
                }
            }
      if ( err_count )
        printf("Total errors %d\n", err_count);
    };

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      Kernel_Info& k = info.ki[kernel];

      cudaFuncAttributes& cfa = k.cfa;
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

          double this_elapsed_time_s = 0;

          // Zero the output array.
          //
          CE(cudaMemset(app.d_out,0,out_size_bytes));

          // Measure execution time starting "now", which is after data
          // set to GPU.
          //
          CE(cudaEventRecord(gpu_start_ce,0));

          // Launch Kernel
          //
          KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>
            (app.d_out,app.d_in);

          // Stop measuring execution time now, which is before is data
          // returned from GPU.
          //
          CE(cudaEventRecord(gpu_stop_ce,0));
          CE(cudaEventSynchronize(gpu_stop_ce));
          float cuda_time_ms = -1.1;
          CE(cudaEventElapsedTime
             (&cuda_time_ms,gpu_start_ce,gpu_stop_ce));
          this_elapsed_time_s = cuda_time_ms * 0.001;

          // Should count fmadd as 1.
          const double thpt_compute_gflops =
            num_ops / this_elapsed_time_s * 1e-9;
          const double thpt_data_gbps =
            amt_data_bytes / this_elapsed_time_s * 1e-9;

          if ( vary_warps )
            {
              const int rate =
                sizeof(Elt_Type) == sizeof(float)
                ? info.chip_sp_flops : info.chip_dp_flops;
              const double comp_frac __attribute__((unused))
                = 1e9 * thpt_compute_gflops / rate;
              const double comm_frac =
                1e9 * thpt_data_gbps / info.chip_bw_Bps;
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
                     string(int(comm_frac*max_st_len),'=').c_str());

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
              ( app.h_out, app.d_out, out_size_bytes,
                cudaMemcpyDeviceToHost) );

          check();

        }
    }
}
