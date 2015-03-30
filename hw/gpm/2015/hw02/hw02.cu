/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 2 - Spring 2015
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2015/hw02.pdf

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
#include "util.h"

#define N 8
#define M 8


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

  // GPU pointers to the input and output arrays, cast to float4s.
  //
  float4 *d_in_f4, *d_out_f4;
  //
  // The compiler can emit more efficient load and store instructions
  // to float4 elements than to four consecutive floats.
  //
  // Note: These "_f4" pointers only work when Elt_Type is a float.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);


extern "C" __global__ void
mxv_g_only(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  // No local memory.
  //
  // In the inner loop use global memory accesses to access the input
  // vector elements. Hope that the compiler recognizes the repeated
  // accesses and so keeps each input vector element in a register
  // rather than reading global memory M times per input element.
  //
  // The compiler will avoid the repeated reads if it is convinced
  // that the input and output arrays don't overlap.  For the NVIDIA
  // compiler (CUDA 7.0) that seems to require declaring the array
  // pointers with the __restrict__ attributes as kernel arguments.
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
tryout(Elt_Type *dout, const Elt_Type *din)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  for ( int h = tid; h<d_app.num_vecs; h += num_threads )
    dout[h] = din[h] + din[h+0x20] + 1234;
}

extern "C" __global__ void
mxv_i_lbuf()
{
  // Local memory for input vector.
  //
  // Use local memory to buffer entire input vector, and write
  // each output vector element as soon as its computed.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    {
      Elt_Type vin[N];
      for ( int c=0; c<N; c++ ) vin[c] = d_app.d_in[ h * N + c ];

      for ( int r=0; r<M; r++ )
        {
          Elt_Type elt = 0;
          for ( int c=0; c<N; c++ ) elt += d_app.matrix[r][c] * vin[c];
          d_app.d_out[ h * M + r ] = elt;
        }
    }
}

extern "C" __global__ void
mxv_o_per_thd()
{
  // Assign one vector to M threads, each thread computes one element.
  //
  // This arrangement avoids the need for any local memory buffering,
  // results in efficient global memory writes. Global memory reads
  // are still inefficient.

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

      for ( int c=0; c<N; c+=4 )
        {
          // float4 v4 = d_app.d_in_f4[ ( h * N + c ) / 4 ];  // Plan A
          float4 v4 = d_app.d_in_f4[ ( h * N ) / 4 + c / 4 ]; // Plan B
          vout +=
            d_app.matrix[r][c] * v4.x
            + d_app.matrix[r][c+1] * v4.y
            + d_app.matrix[r][c+2] * v4.z
            + d_app.matrix[r][c+3] * v4.w;
        }

      d_app.d_out[ h * M + r ] = vout;
    }
}


extern "C" __global__ void
mxv_sh_ochunk()
{
  const int CS = 8;  // Chunk Size: Number of input vector elts to read.
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

      for ( int c=0; c<N; c += CS )
        {
          vxfer[threadIdx.x] =
            c + CS < N || c + thd_c_offset < N
            ? d_app.d_in[ ( hb + thd_v_offset ) * N + c + thd_c_offset ]
            : 0;

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          for ( int rr=0; rr<ML; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }

      for ( int rr=0; rr<ML; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          if ( r < M )
            d_app.d_out[ ( hb + thd_v_offset ) * M + r ] = vout[rr];
        }

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

  info.GET_INFO(mxv_g_only);
  info.GET_INFO(mxv_i_lbuf);
  info.GET_INFO(mxv_o_per_thd);

  info.GET_INFO(mxv_sh_ochunk);

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

  // Examine argument 1, block count, default is number of MPs.
  //
  const int arg1_int =
    argc < 2 ? info.cuda_prop.multiProcessorCount : atoi(argv[1]);
  const int num_blocks =
           arg1_int == 0 ? info.cuda_prop.multiProcessorCount : abs(arg1_int);

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block_arg = argc < 3 ? 1024 : atoi(argv[2]);
  const int thd_per_block_goal =
   thd_per_block_arg == 0 ? 1024 : thd_per_block_arg;
  const int num_threads = num_blocks * thd_per_block_goal;

  const bool vary_warps = thd_per_block_arg == 0;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.num_vecs = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( num_threads <= 0 || app.num_vecs <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int in_size_elts = app.num_vecs * N;
  const int in_size_bytes = in_size_elts * sizeof( app.h_in[0] );
  const int out_size_elts = app.num_vecs * M;
  const int out_size_bytes = out_size_elts * sizeof( app.h_out[0] );

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
  app.d_in_f4 = (float4*) app.d_in;
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );
  app.d_out_f4 = (float4*) app.d_out;

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

  const int64_t num_ops = int64_t(M) * N * app.num_vecs;  // Multiply-adds.

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

                if ( wp_cnt == wp_start )
                  printf("Kernel %s:\n", info.ki[kernel].name);

                printf("%2d wp  %6.0f µs  %5.0f GF  %5.0f GB/s %s\n",
                       (thd_per_block + 31 ) >> 5,
                       this_elapsed_time_s * 1e6,
                       thpt_compute_gflops, thpt_data_gbps,
                       &stars[stars_len-int(comp_frac*max_st_len)]
                       );

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
