/// LSU EE 7722 GPU Microarchitecture
//

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

#define N 16
#define M 16

#if ( N + M ) * 1024 * 2 < 32769
#define SMALL
#endif

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
  // Local address space for input vector.
  //
  // Use local address space to buffer entire input vector, and write
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

      Elt_Type vout[M]{};

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
  constexpr int64_t MAX_BLOCK_SIZE = 1024;

  // Shared memory used to redistribute vector elements.
  //
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE][CS + 1];

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      // Compute matrix-vector product for vector number  hb + threadIdx.x.

      Elt_Type vout[M]{};

      for ( int c=0; c<N; c += CS )
        {
          // Read and redistribute input vector elements c, c+1,
          // ... c+CS-1, then use those to compute part of the
          // matrix-vector product.

          __syncthreads();

          for ( int v = thd_x_idx_st;  v < BLOCK_SIZE;  v += BLOCK_SIZE/CS )
            vxfer[ v ][ thd_x_offset ] =
              d_app.d_in[ hb * N + v * N + c + thd_x_offset ];

          // Copy the portion of the input vector just read to local
          // memory (the vin array). We hope that the compiler will
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
              const int v = g * BLOCK_SIZE / CS + thd_x_idx_st;

              // The if statement is needed if M is not a multiple of CS.
              if ( thd_x_offset + r < M )
                d_app.d_out[ hb * M + v * M + r + thd_x_offset ] =
                  vxfer[ v ][ thd_x_offset ];
            }
        }
    }
}

constexpr int mxv_sh_ochunk_CS = 8;

extern "C" __global__ void
mxv_sh_ochunk()
{
  // Chunk Size: Number of input vector elts to read.
  constexpr int CS = mxv_sh_ochunk_CS;

  const int num_threads = blockDim.x * gridDim.x;

  // First vector used by this block.
  const int bl_start = blockIdx.x * blockDim.x / CS;
  const int stop = d_app.num_vecs;
  const int inc = num_threads / CS;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_r_offset = threadIdx.x % CS;
  const int thd_v_offset = threadIdx.x / CS;

  constexpr int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[MAX_BLOCK_SIZE];

  constexpr int ML = ( M + CS - 1 ) / CS;

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      Elt_Type vout[ML]{};

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
#pragma unroll
      for ( int rr=0; rr<ML; rr++ )
        if ( const int r = rr * CS + thd_r_offset;   r < M   )
          d_app.d_out[ ( hb + thd_v_offset ) * M + r ] = vout[rr];

    }
}

extern "C" __global__ void
mxv_vec_ld()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  // Compute vector number to start at.
  //
  const int start = tid;
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  for ( int h=start; h<stop; h += inc )
    {
      Elt_Type vin[N];
      float4* const vin4 = (float4*) &vin[0];

      for ( int c4=0; c4<N/4; c4++ )
        vin4[c4] = d_app.d_in_f4[ h * ( N >> 2 ) + c4 ];

      Elt_Type vout[M]{};
      float4* const vout4 = (float4*) &vout[0];

      for ( int r=0; r<M; r++ )
        for ( int c=0; c<N; c++ )
          vout[r] += d_app.matrix[r][c] * vin[c];

      for ( int r4=0; r4<M/4; r4++ )
        d_app.d_out_f4[ h * ( M >> 2 ) + r4 ] = vout4[r4];
    }
}


template<bool use_shared = true>
__device__ void
mxv_vls()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = blockDim.x * gridDim.x;

  const int offset = threadIdx.x & 1;

  // Compute element number to start at.
  //
  const int start = tid;
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  __shared__ float4 v0[1024];

  for ( int h=start; h<stop; h += inc )
    {
      const int h0 = h - offset;

      __syncthreads();

      Elt_Type vin[N];
      float4* const vin4 = (float4*) &vin[0];

      for ( int cc=0; cc<N; cc += 8 )
        {
          const int c = cc + 4 * offset;

          float4 v0_o = d_app.d_in_f4[ ( h0 * N + c ) >> 2 ];
          float4 v1_o = d_app.d_in_f4[ ( ( h0 + 1 ) * N + c ) >> 2 ];
          float4 fswap = offset ? v0_o : v1_o;

          if ( use_shared )
            {
              v0[threadIdx.x] = fswap;
              fswap = v0[threadIdx.x ^ 1];
            }
          else
            {
              fswap.x = __shfl_xor_sync(~0,fswap.x,1);
              fswap.y = __shfl_xor_sync(~0,fswap.y,1);
              fswap.z = __shfl_xor_sync(~0,fswap.z,1);
              fswap.w = __shfl_xor_sync(~0,fswap.w,1);
            }

          vin4[cc/4] = offset ? fswap : v0_o;
          if ( cc + 4 < N ) vin4[cc/4+1] = offset ? v1_o  : fswap;

        }

      Elt_Type vbuf[8];
      float4* const vbuf4 = (float4*) &vbuf[0];
      const int M8 = ( M + 7 ) & ~7;
#pragma unroll
      for ( int64_t r=0; r<M8; r++ )
        {
          const int bpos = r % 8;
          Elt_Type elt = 0;
          for ( int c=0; c<N; c++ ) elt += d_app.matrix[r][c] * vin[c];
          vbuf[bpos] = elt;
          if ( bpos == 7 )
            {
              float4 fswap = offset ? vbuf4[0] : vbuf4[1];
              if ( use_shared )
                {
                  v0[threadIdx.x] = fswap;
                  fswap = v0[threadIdx.x ^ 1];
                }
              else
                {
                  fswap.x = __shfl_xor_sync(~0,fswap.x,1);
                  fswap.y = __shfl_xor_sync(~0,fswap.y,1);
                  fswap.z = __shfl_xor_sync(~0,fswap.z,1);
                  fswap.w = __shfl_xor_sync(~0,fswap.w,1);
                }

              float4 v0_o = offset ? fswap   : vbuf4[0];
              float4 v1_o = offset ? vbuf4[1] : fswap;

              if ( const int rr = r - 7 + offset * 4;  rr < M  )
                {
                  d_app.d_out_f4[ ( h0 * M + rr ) >> 2 ] = v0_o;
                  d_app.d_out_f4[ ( (h0+1) * M + rr ) >> 2 ] = v1_o;
                }
            }
        }
    }
}

extern "C" __global__ void mxv_vls_shared() {mxv_vls<true>();}
extern "C" __global__ void mxv_vls_shuffle() {mxv_vls<false>();}


#ifdef SMALL

extern "C" __global__ void
mxv_sh_easy()
{
  // Compute element number to start at.
  //
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;
  const int inc = num_threads;

  const int64_t BLOCK_SIZE = 1024;
#if N > M
  const int sm_stride = N;
#else
  const int sm_stride = M;
#endif
  __shared__ Elt_Type vins[BLOCK_SIZE][sm_stride];

  const int offset = threadIdx.x % N;
  const int idx_start = threadIdx.x / N;

  for ( int hb = bl_start; hb<stop; hb += inc )
    {
      for ( int g=0; g<N; g++ )
        vins[ idx_start + g * blockDim.x/N ][ offset ] =
          d_app.d_in[ hb * N + g * blockDim.x + threadIdx.x ];

      __syncthreads();
      Elt_Type vin[N];
      for ( int c=0; c<N; c++ ) vin[c] = vins[ threadIdx.x ][ c ];

      Elt_Type vout[M]{};
      for ( int r=0; r<M; r++ )
        for ( int c=0; c<N; c++ )
          vout[r] += d_app.matrix[r][c] * vin[c];

      __syncthreads();

      for ( int r=0; r<M; r++ ) vins[ threadIdx.x ][ r ] = vout[ r ];

      __syncthreads();

      for ( int r=0; r<M; r++ )
        d_app.d_out[ hb * M + r * blockDim.x + threadIdx.x ] =
          vins[ threadIdx.x / M + r * blockDim.x/M ] [ threadIdx.x % M ];

      __syncthreads();
    }
}
#endif



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

  info.GET_INFO(mxv_g_only);
  info.GET_INFO(mxv_i_lbuf);
  info.GET_INFO(mxv_o_lbuf);
  info.GET_INFO(mxv_o_per_thd);

#if N / 4 == (N+3)/4
  info.GET_INFO(mxv_vec_ld);
#endif
#if N / 4 == (N+3)/4 && M / 4 == (M+3)/4
  info.GET_INFO(mxv_vls_shared);
  info.GET_INFO(mxv_vls_shuffle);
#endif
  info.GET_INFO(mxv_sh);
  info.GET_INFO(mxv_sh_ochunk);

#ifdef SMALL
  info.GET_INFO(mxv_sh_easy);
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
          func_ptr == mxv_o_per_thd ? M :
          func_ptr == mxv_sh_ochunk ? mxv_sh_ochunk_CS : 1;

        pTable table;

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

                table.row_start();
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
                ( app.h_out, app.d_out, out_size_bytes,
                  cudaMemcpyDeviceToHost ) );
            int err_count = 0;
            for ( int i=0; i<app.num_vecs; i++ )
              for ( int r=0; r<M; r++ )
                {
                  const int idx = i * M + r;

                  if ( fabs( app.h_out_check[idx] - app.h_out[idx] ) > 1e-5 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf
                          ( "Error at vec %d elt %d: %.7f != %.7f (correct)\n",
                            i, r, app.h_out[idx], app.h_out_check[idx] );
                    }
                }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
        printf("%s",table.body_get());
      }
  }

}
