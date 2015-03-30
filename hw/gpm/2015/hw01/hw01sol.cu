/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 1 - Spring 2015
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2015/hw01.pdf

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

#define N 16
#define M 16


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

    // Operate on vector number h.
#pragma unroll
    for ( int r=0; r<M; r++ )
      {
        Elt_Type elt = 0;
        for ( int c=0; c<N; c++ ) elt += d_app.matrix[r][c] * din[ h * N + c ];
        dout[ h * M + r ] = elt;
      }
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
mxv_o_lbuf()
{
  // Local memory for output vector.
  //
  // Use local memory to buffer entire output vector.  Right after each
  // input vector element is read use it to partially compute each
  // of the M output vector elements.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    {
      // Operate on vector number h.

      Elt_Type vout[M];
      for ( int r=0; r<M; r++ ) vout[r] = 0;

      for ( int c=0; c<N; c++ )
        {
          const Elt_Type vin = d_app.d_in[ h * N + c ];
          for ( int r=0; r<M; r++ ) vout[r] += d_app.matrix[r][c] * vin;
        }
      for ( int r=0; r<M; r++ ) d_app.d_out[ h * M + r ] = vout[ r ];
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

      for ( int c=0; c<N; c++ )
        vout += d_app.matrix[r][c] * d_app.d_in[ h * N + c ];

      d_app.d_out[ h * M + r ] = vout;
    }
}


extern "C" __global__ void
mxv_sh()
{
  // Local memory for output vector, use shared memory to redistribute
  // input- and output-vector elements so that global memory reads and
  // writes are fully utilized.

  // Chunk Size: Number of vector elements to redistribute at a time.
  const int CS = 8;

  const int num_threads = blockDim.x * gridDim.x;

  // The vector number operated on by threadIdx.x 0 in the first iteration.
  //
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  // Used to compute the vector element number to read or write from
  // global memory.
  //
  const int thd_x_offset = threadIdx.x % CS;

  // Used to compute the vector number to read or write from global memory.
  //
  const int thd_x_idx_st = threadIdx.x / CS;

  const int64_t BLOCK_SIZE = blockDim.x;
  const int64_t MAX_BLOCK_SIZE = 1024;

  // Shared memory used to redistribute vector elements.
  //
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE][CS + 1];

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      // Compute matrix-vector product for vector number  hb + threadIdx.x.

      Elt_Type vout[M];
      for ( int r=0; r<M; r++ ) vout[r] = 0;

      for ( int c=0; c<N; c += CS )
        {
          // Read and redistribute input vector elements c, c+1,
          // ... c+CS-1, then use those to compute part of the
          // matrix-vector product.

          // Read input vector elements sequentially and place them in
          // shared memory.
          //
          // The entire g loop reads CS elements of each thread's
          // input vector. Each iteration of the g loop reads CS
          // elements from BLOCK_SIZE / CS vectors.
          //
          __syncthreads();
          for ( int g=0; g<CS; g++ )
            {
              const int idx = g * BLOCK_SIZE / CS + thd_x_idx_st;
              vxfer[idx][thd_x_offset] =
                d_app.d_in[ hb * N + idx * N + c + thd_x_offset ];
            }

          // Copy the portion of the input vector just read to local
          // memory (the vin array). We expect that the compiler will
          // use registers for all values of vin.
          //
          __syncthreads();
          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ ) vin[cc] = vxfer[threadIdx.x][cc];

          // Perform the matrix-vector multiplication for the parts of
          // the input vector just read.
          //
          for ( int r=0; r<M; r++ )
            for ( int cc=0; cc<CS; cc++ )
              if ( c+cc < N ) vout[r] += d_app.matrix[r][c+cc] * vin[cc];
        }

      // Use shared memory to redistribute the output vector elements to
      // threads so that the write to global memory will be efficient.
      //
      for ( int r=0; r<M; r += CS )
        {
          __syncthreads();
          for ( int rr=0; rr<CS; rr++ ) vxfer[threadIdx.x][rr] = vout[r+rr];

          __syncthreads();
          for ( int g=0; g<CS; g++ )
            {
              const int idx = g * BLOCK_SIZE / CS + thd_x_idx_st;

              // The if statement is needed of M is not a multiple of CS.
              if ( thd_x_offset + r < M )
                d_app.d_out[ hb * M + idx * M + r + thd_x_offset ] =
                  vxfer[idx][thd_x_offset];
            }
        }
    }
}



extern "C" __global__ void
mxv_sh_ochunk()
{
  // Compute element number to start at.
  //

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

#pragma unroll
      for ( int c=0; c<N; c += CS )
        {
          vxfer[threadIdx.x] =
            d_app.d_in[ ( hb + thd_v_offset ) * N + c + thd_c_offset ];

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_v_offset * CS + cc ];

          for ( int rr=0; rr<ML; rr++ )
            {
              const int r = rr * CS + thd_r_offset;
              for ( int cc=0; cc<CS; cc++ )
                if ( c+cc < N )
                  vout[rr] += d_app.matrix[r][c+cc] * vin[cc];
            }
        }
      for ( int rr=0; rr<ML; rr++ )
        {
          const int r = rr * CS + thd_r_offset;
          if ( r < M )
            d_app.d_out[ hb * M + ( threadIdx.x / CS ) * M + r ] = vout[rr];
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
  info.GET_INFO(mxv_o_lbuf);
  info.GET_INFO(mxv_o_per_thd);

  info.GET_INFO(mxv_sh);
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
