/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 2 - Spring 2016 -- SOLUTION
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2016/hw02.pdf
//  Solution writeup: http://www.ece.lsu.edu/koppel/gp/2016/hw02_sol.pdf
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
#include <assert.h>
#include <string>
#include "util.h"

#define N 16
#define M 16

 /// SOLUTION -- Problem 3
//
//   Increase interleave factor from 4 to 16 to improve performance.
//
#define IF 16


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

  /// SOLUTION -- Problem 3
  //
  //  Declare types for interleaved input and output. Note that there
  //  is no device interleaved output, the kernel always writes d_out,
  //  and host code copies that to either h_out_interleaved when
  //  necessary.
  //
  Elt_Type *h_in_interleaved;
  Elt_Type *d_in_interleaved;
  Elt_Type *h_out_interleaved;

  //
  // Note: h_in points to an array holding num_vecs N-element vectors,
  //       and so the total size of h_in is num_vects * N elements.

  // GPU pointers to the input and output arrays.
  //
  Elt_Type *d_in, *d_out;

};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

 /// SOLUTION - Problem 1
//
//   Declare a global (device)-space variable for the matrix.
//
__device__ App d_app_g;

typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);


extern "C" __global__ void
mxv_g_only(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  /// Homework 2: Don't modify this routine.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )

    // Operate on vector number h.

    for ( int r=0; r<M; r++ )
      {
        Elt_Type elt = 0;
        for ( int c=0; c<N; c++ ) elt += d_app.matrix[r][c] * din[ h * N + c ];
        dout[ h * M + r ] = elt;
      }
}

extern "C" __global__ void
mxv_g_only_g(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  /// Problem 1 Solution here, and other places.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )

    // Operate on vector number h.

    for ( int r=0; r<M; r++ )
      {
        Elt_Type elt = 0;

        /// SOLUTION -- Problem 1
        //
        //  Read the matrix that was placed in the global address space.
        //
        for ( int c=0; c<N; c++ )
          elt += d_app_g.matrix[r][c] * din[ h * N + c ];
        dout[ h * M + r ] = elt;
      }
}

extern "C" __global__ void
mxv_g_only_s(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  /// Problem 2 Solution here, and other places.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  /// SOLUTION -- Problem 2
  //
  //  Copy matrix to shared memory.
  //
  __shared__ Elt_Type matrix[M][N];
  Elt_Type* const m0 = &matrix[0][0];
  Elt_Type* const m0_c = &d_app.matrix[0][0];
  const int elts = M * N;
  for ( int idx = threadIdx.x; idx < elts; idx += blockDim.x )
    m0[idx] = m0_c[idx];
  __syncthreads();

  for ( int h=start; h<stop; h += inc )

    // Operate on vector number h.

    for ( int r=0; r<M; r++ )
      {
        Elt_Type elt = 0;

        /// SOLUTION -- Problem 2
        //
        // Use shared matrix instead of constant-space matrix.

        for ( int c=0; c<N; c++ ) elt += matrix[r][c] * din[ h * N + c ];
        dout[ h * M + r ] = elt;
      }
}


extern "C" __global__ void
mxv_g_only_interleave
(Elt_Type* __restrict__ dout, const Elt_Type* __restrict__ din)
{
  /// Problem 3 Solution here, and other places.

  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int start = tid;        // First vector number computed by this thread.
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    {

      /// SOLUTION -- Problem 3
      //
      //  Split index for vector h into two indices h = h0 + hh. Index
      //  h0 is the index of the first vector of the IF group we need,
      //  and hh is where within the IF group our vector is. For
      //  example, suppose IF = 4 and h = 17. Vectors 16, 17, 18, and
      //  19, form a group with h0 = 16, and we need the second vector
      //  so hh = 1.
      //
      const int64_t h0 = ( h / IF ) * IF;
      const int hh = h - h0;
      //
      // The type for h0 is set to 64 bits so that the compiler can
      // emit load instructions with constant offsets. Consider "h0*M
      // + r * IF + hh". If the compiler evaluates that using 32-bit
      // arithmetic then there might be 32-bit overflow, which
      // according to the C language must be discarded. Since the
      // compiler doesn't know whether there would be overflow (there
      // won't unless the array has more than 2^31 elements) it must
      // recompute the expression for each r iteration. By setting h0
      // to a 64-bit type there can't be overflow so the compiler can
      // put "h0*M" in a register and use "r*IF+hh" as a constant
      // offset (after adjusting for data type size).

      for ( int r=0; r<M; r++ )
        {
          Elt_Type elt = 0;

          /// SOLUTION -- Problem 3
          //
          //  Use group plus offset indexing for both din and dout.
          //
          for ( int c=0; c<N; c++ )
            elt += d_app.matrix[r][c] * din[ h0 * N + c * IF + hh ];
          dout[ h0 * M + r * IF + hh ] = elt;
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
  info.GET_INFO(mxv_g_only_g);
  info.GET_INFO(mxv_g_only_s);
  info.GET_INFO(mxv_g_only_interleave);

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

  /// SOLUTION -- Problem 3
  //
  //  Allocate host and device storage for interleaved arrays.
  //
  app.h_in_interleaved = new Elt_Type[ in_size_elts ];
  app.h_out_interleaved = new Elt_Type[ out_size_elts ];
  CE( cudaMalloc( &app.d_in_interleaved, in_size_bytes + overrun_size_bytes ) );


  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Matrix size: %d x %d.  Vectors: %d.   %d blocks of %d thds.\n",
         N, M, app.num_vecs, num_blocks, thd_per_block_goal);

  // Initialize input array.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    for ( int c=0; c<N; c++ )
      app.h_in[ i * N + c ] = debug ? Elt_Type(c) : drand48();

  /// SOLUTION -- Problem 3
  //
  //  Copy data from the "flat" array to the interleaved array.
  //
  for ( int i0=0; i0<app.num_vecs; i0 += IF )
    for ( int c=0; c<N; c++ )
      for ( int ii = 0;  ii < IF;  ii ++ )
        {
          // The i0 loop iterates over groups of vectors containing
          // IF vectors each.  The ii loop iterates over vectors within
          // a group. Below, compute the vector index used by din.
          //
          const int i = i0 + ii;

          // Compute the index of component c for the regular array.
          //
          const int idx = i * N + c;

          // Compute the index for component c in the interleaved
          // array.
          //
          const int inter_idx = i0 * N + ii + c * IF;

          app.h_in_interleaved[inter_idx] = app.h_in[ idx ];
        }

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


    /// SOLUTION -- Problem 3
    //
    //  Copy interleaved data to GPU.
    //
    CE( cudaMemcpy
        ( app.d_in_interleaved, app.h_in_interleaved,
          in_size_bytes, cudaMemcpyHostToDevice ) );

    // Copy App structure to GPU.
    //
    CE( cudaMemcpyToSymbol
        ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

    /// SOLUTION -- Problem 1
    CE( cudaMemcpyToSymbol
        ( d_app_g, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

    // Launch kernel multiple times and keep track of the best time.
    printf("Launching with %d blocks of up to %d threads. \n",
           num_blocks, thd_per_block_goal);

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        cudaFuncAttributes& cfa = info.ki[kernel].cfa;
        const int wp_limit = cfa.maxThreadsPerBlock >> 5;

        /// SOLUTION -- Problem 3
        //
        const bool uses_interleaved_data =
          std::string(info.ki[kernel].name) == "mxv_g_only_interleave";

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

            /// SOLUTION -- Problem 3
            //
            //  Use pointer to appropriate type.
            //
            Elt_Type* const d_in =
              uses_interleaved_data ? app.d_in_interleaved : app.d_in;

            // Launch Kernel
            //
            KPtr(info.ki[kernel].func_ptr)<<<num_blocks,thd_per_block>>>
              (app.d_out,d_in);

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
                const int max_st_len = 50;

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

            /// SOLUTION -- Problem 3
            //
            //  If interleaved data is being used, copy GPU data
            //  into app.h_out_interleaved and then restore it
            //  back to its original order.
            //
            Elt_Type* const h_out =
              uses_interleaved_data ? app.h_out_interleaved : app.h_out;

            // Copy output array from GPU to CPU.
            //
            CE( cudaMemcpy
                ( h_out, app.d_out, out_size_bytes, cudaMemcpyDeviceToHost) );

            /// SOLUTION -- Problem 3
            //
            //  Uninterleave data.
            //
            if ( uses_interleaved_data )
              for ( int i0=0; i0<app.num_vecs; i0 += IF )
                for ( int r=0; r<M; r++ )
                  for ( int ii = 0;  ii < IF;  ii ++ )
                    {
                      const int reg_idx = ( i0 + ii ) * M + r;
                      const int inter_idx = i0 * M + ii + r * IF;
                      app.h_out[reg_idx] = h_out[inter_idx];
                    }

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
