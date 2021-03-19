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
#include <misc.h>

#define N 16
#define M 16

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

typedef uint32_t Op_Type;

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
  Elt_Type *h_in, *h_out, *h_out_check, *h_out_check_n;
  Op_Type norm_threshold;
  Op_Type *h_op;
  //
  // Note: h_in points to an array holding num_vecs N-element vectors,
  //       and so the total size of h_in is num_vects * N elements.

  // GPU pointers to the input and output arrays.
  //
  Elt_Type *d_in, *d_out;
  Op_Type *d_op;

};


// Declare application data structure.
//
// .. in host address space ..
App app;
//
// .. and in device constant address space.
__constant__ App d_app;


// Pointer to kernel main (global) functions.
typedef void (*KPtr)(Elt_Type *dout, const Elt_Type *din);

const int chunk_size = 8;

extern "C" __global__ void
mxv_ld_all()
{
  // Group (chunk) size: The number of threads that cooperate to read
  // and write vectors.
  //
  const int CS = chunk_size;
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_v_offset = threadIdx.x;
  const int thd_g_offset = threadIdx.x & ~ ( CS - 1 );

  const int MAX_BLOCK_SIZE = 1024;
  assert( threadIdx.x || blockDim.x <= MAX_BLOCK_SIZE );
  __shared__ Elt_Type vxfer[CS][MAX_BLOCK_SIZE+1];

  for ( int hb = bl_start; hb<stop; hb += num_threads )
    {
      const int h = hb + thd_v_offset;
      const bool have_work = d_app.d_op[h] <= d_app.norm_threshold;

      Elt_Type vout[M]{};

      for ( int c=0; c<N; c += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[g][threadIdx.x] =
              d_app.d_in[( hb+thd_g_offset + g )*N + c + thd_c_offset ];

          if ( !have_work ) continue;

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_c_offset ][ thd_g_offset + cc ];

          for ( int r=0; r<M; r++ )
            for ( int cc=0; cc<CS; cc++ )
              vout[r] += d_app.matrix[r][c+cc] * vin[cc];
        }

#pragma unroll
      for ( int rr=0; rr<M; rr += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[thd_c_offset][thd_g_offset+g] = vout[rr+g];
          for ( int g=0; g<CS; g++ )
              d_app.d_out[ ( hb + thd_g_offset + g ) * M + rr + thd_c_offset ]
                = vxfer[g][threadIdx.x];
        }
    }
}

extern "C" __global__ void
mxv_ld_chunk()
{
  // Group (chunk) size: The number of threads that cooperate to read
  // and write vectors.
  //
  const int CS = chunk_size;
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;

  const int wp_lg = 5;
  const int wp_sz = 1 << wp_lg;
  const int lane = threadIdx.x % wp_sz;
  const int thd_c_offset = threadIdx.x % CS;
  const int thd_v_offset = threadIdx.x;
  const int thd_g_offset = threadIdx.x & ~ ( CS - 1 );
  const int thd_wp_c0 = lane & ~ ( CS - 1 );

  const int MAX_BLOCK_SIZE = 1024;
  assert( threadIdx.x || blockDim.x <= MAX_BLOCK_SIZE );
  __shared__ Elt_Type vxfer[CS][MAX_BLOCK_SIZE+1];

  for ( int hb = bl_start; hb<stop; hb += num_threads )
    {
      const int h = hb + thd_v_offset;
      const bool have_work = d_app.d_op[h] <= d_app.norm_threshold;
      const uint32_t have_work_wp_v = __ballot_sync(~0,have_work);
      if ( !have_work_wp_v ) continue;
      const uint32_t chunk_wk_v = have_work_wp_v >> thd_wp_c0;

      Elt_Type vout[M]{};

      for ( int c=0; c<N; c += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[g][threadIdx.x] =
              chunk_wk_v  &  1 << g
              ? d_app.d_in[( hb+thd_g_offset + g )*N + c + thd_c_offset ]
              : 0;

          if ( !have_work ) continue;

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_c_offset ][ thd_g_offset + cc ];

          for ( int r=0; r<M; r++ )
            for ( int cc=0; cc<CS; cc++ )
              vout[r] += d_app.matrix[r][c+cc] * vin[cc];
        }

#pragma unroll
      for ( int rr=0; rr<M; rr += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[thd_c_offset][thd_g_offset+g] = vout[rr+g];
          for ( int g=0; g<CS; g++ )
            if ( chunk_wk_v  &  1 << g )
              d_app.d_out[ ( hb + thd_g_offset + g ) * M + rr + thd_c_offset ]
                = vxfer[g][threadIdx.x];
        }
    }
}

typedef int worka_t;

// Declare a type for the compression function. This is needed for the
// templates.
typedef int (*Compress_Func)(bool have_work, worka_t* const &work_assignments);

__device__ int
compress_atomic(bool have_work, worka_t* const &worka)
{
  __shared__ int amt_work_block; // Number of threads with work.
  __syncthreads();
  if ( threadIdx.x == 0 ) amt_work_block = 0;
  __syncthreads();
  if ( have_work ) worka[atomicAdd(&amt_work_block,1)] = threadIdx.x;
  __syncthreads();
  return amt_work_block;
}

__device__ int
compress_prefix_shared(bool have_work, worka_t* const &worka)
{
  const int MAX_BLOCK_SIZE = 1024;
  worka_t* const prefix_array = worka;
  worka_t my_val = have_work;
  for ( int dist = 1; dist < MAX_BLOCK_SIZE; dist <<= 1 )
    {
      __syncthreads();
      prefix_array[threadIdx.x] = my_val;
      __syncthreads();
      if ( dist <= threadIdx.x ) my_val += prefix_array[threadIdx.x-dist];
      if ( dist >= blockDim.x ) break;
    }
  __shared__ int amt_work_block;
  if ( threadIdx.x == blockDim.x - 1 ) amt_work_block = my_val;
  __syncthreads();
  if ( have_work ) worka[my_val-1] = threadIdx.x;
  __syncthreads();
  return amt_work_block;
}

__device__ int
compress_prefix_ballot(bool have_work, worka_t* const &worka)
{
  const int wp_lg = 5;
  const int wp_sz = 1 << wp_lg;
  const int lane_last = wp_sz - 1;  // The highest lane number.
  const int lane = threadIdx.x & ( wp_sz - 1 );
  const uint32_t msk = ~0;  // A thread mask.

  __shared__ int amt_work_block;
  if ( threadIdx.x == 0 ) amt_work_block = 0;

  // Bit vector indicating which threads in this warp have work.
  const uint32_t have_work_wp_v = __ballot_sync(msk,have_work);

  // Shift off bits corresponding to higher-numbered lanes.
  const uint32_t have_work_pf_v = have_work_wp_v << ( lane_last - lane );

  // Use population count function to compute the number of threads
  // that have work in this warp at this and lower-numbered lanes.
  // Note: pf is an abbreviation for prefix sum.
  //
  const uint32_t my_pf = __popc(have_work_pf_v);
  //
  // Note: __popc compiles to a single machine instruction in Kepler to
  // Pascal GPUs (and hopefully future models too).

  int pfx_wp = 0;
  __syncthreads();
  if ( lane == lane_last ) pfx_wp = atomicAdd( &amt_work_block, my_pf );
  pfx_wp = __shfl_sync(msk,pfx_wp,lane_last);

  const int pfx_me = pfx_wp + my_pf;
  if ( have_work ) worka[pfx_me-1] = threadIdx.x;
  __syncthreads();
  return amt_work_block;
}

template <Compress_Func compress> __device__ void
mxv_compress()
{
  // Group (chunk) size: The number of threads that cooperate to read
  // and write vectors.
  //
  const int CS = chunk_size;
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_g_offset = threadIdx.x & ~ ( CS - 1 );

  const int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[CS][MAX_BLOCK_SIZE+1];

  __shared__ int worka[MAX_BLOCK_SIZE]; // Work assignment.
  worka[threadIdx.x] = threadIdx.x;

  for ( int hb = bl_start; hb<stop; hb += num_threads )
    {
      const bool work = d_app.d_op[hb + threadIdx.x] <= d_app.norm_threshold;

      const int work_pos = compress(work,worka);

      // If true, no vector assigned to this thread.
      const bool skip = threadIdx.x >= work_pos;

      // If true, this thread is in a group in which at least one thread
      // has a vector and at least one thread does not have a vector.
      //
      const bool tail_chunk =
        thd_g_offset < work_pos && thd_g_offset + CS >= work_pos;

      if ( skip && !tail_chunk ) continue;

      const int work_v_offset = worka[threadIdx.x];
      //
      // This thread, threadIdx.x, will operate on the same element
      // as thread work_v_offset would have.

      Elt_Type vout[M]{};

      for ( int c=0; c<N; c += CS )
        {
          Elt_Type vx[CS];
          for ( int g=0; g<CS; g++ )
            vx[g] = d_app.d_in[ ( hb + worka[thd_g_offset + g] ) * N
                          + c + thd_c_offset ];

          for ( int g=0; g<CS; g++ ) vxfer[g][threadIdx.x] = vx[g];

          if ( skip ) continue;

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_c_offset ][ thd_g_offset + cc ];

          for ( int r=0; r<M; r++ )
            for ( int cc=0; cc<CS; cc++ )
              vout[r] += d_app.matrix[r][c+cc] * vin[cc];
        }

      if ( skip && tail_chunk ) continue;

      if ( tail_chunk )
#pragma unroll
        for ( int r=0; r<M; r++ )
          d_app.d_out[ ( hb + work_v_offset ) * M + r ] = vout[r];
      else
#pragma unroll
        for ( int rr=0; rr<M; rr += CS )
          {
            for ( int g=0; g<CS; g++ )
              vxfer[thd_c_offset][thd_g_offset+g] = vout[rr+g];
            for ( int g=0; g<CS; g++ )
              d_app.d_out
                [ ( hb + worka[thd_g_offset + g] ) * M + rr + thd_c_offset ]
                = vxfer[g][threadIdx.x];
          }
    }
}

__global__ void
mxv_compress_wps()
{
  const int wp_lg = 5;
  const int wp_sz = 1 << wp_lg;
  const int wp_mk = wp_sz - 1;
  const int lane_last = wp_sz - 1;
  const int lane = threadIdx.x & wp_mk;
  const uint32_t msk = ~0;

  // Group (chunk) size: The number of threads that cooperate to read
  // and write vectors.
  //
  const int CS = chunk_size;
  const int num_threads = blockDim.x * gridDim.x;

  // First element used by this block.
  const int bl_start = blockIdx.x * blockDim.x;
  const int stop = d_app.num_vecs;

  const int thd_c_offset = threadIdx.x % CS;
  const int thd_g_offset = threadIdx.x & ~ ( CS - 1 );
  const int thd_wp_c0 = lane & ~ ( CS - 1 );

  constexpr int MAX_BLOCK_SIZE = 1024;
  __shared__ Elt_Type vxfer[CS][MAX_BLOCK_SIZE+1];

  __shared__ int workb[2 * MAX_BLOCK_SIZE];
  int *wwork = &workb[ 2 * ( threadIdx.x & ~wp_mk ) ];

  wwork[lane] = wwork[wp_sz + lane] = -1;

  int amt_wk_buf = 0;

  for ( int hb = bl_start; hb < stop || amt_wk_buf > 0; hb += num_threads )
    {
      const bool last_iter = hb + num_threads >= stop;
      const int h = hb + threadIdx.x;
      const bool work = hb < stop && d_app.d_op[h] <= d_app.norm_threshold;

      // Bit vector indicating which threads in this warp have work.
      const uint32_t have_work_wp_v = __ballot_sync(msk,work);

      // If there's nothing new and it's not the last iteration, continue.
      if ( !have_work_wp_v && !last_iter ) continue;

      // Shift off bits corresponding to higher-numbered lanes.
      const int amt_wk_here = __popc(have_work_wp_v);
      const uint32_t have_work_pf_v = have_work_wp_v << ( lane_last - lane );
      const uint32_t my_pf = __popc(have_work_pf_v);

      if ( work ) wwork[ amt_wk_buf + my_pf - 1] = h;
      amt_wk_buf += amt_wk_here;
      if ( amt_wk_buf < wp_sz && !last_iter ) continue;

      if ( lane >= amt_wk_buf )
        {
          if ( thd_wp_c0 >= amt_wk_buf ) break;
          wwork[lane] = wwork[thd_wp_c0];
        }

      Elt_Type vout[M]{};

#pragma unroll
      for ( int c=0; c<N; c += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[g][threadIdx.x] =
              d_app.d_in[ ( wwork[thd_wp_c0 + g] ) * N + c + thd_c_offset ];

          Elt_Type vin[CS];
          for ( int cc=0; cc<CS; cc++ )
            vin[cc] = vxfer[ thd_c_offset ][ thd_g_offset + cc ];

          for ( int r=0; r<M; r++ )
            for ( int cc=0; cc<CS; cc++ )
              vout[r] += d_app.matrix[r][c+cc] * vin[cc];
        }

#pragma unroll
      for ( int rr=0; rr<M; rr += CS )
        {
          for ( int g=0; g<CS; g++ )
            vxfer[thd_c_offset][thd_g_offset+g] = vout[rr+g];
          for ( int g=0; g<CS; g++ )
            d_app.d_out[ ( wwork[thd_wp_c0 + g] ) * M + rr + thd_c_offset ]
              = vxfer[g][threadIdx.x];
        }

      wwork[lane] = wwork[lane+wp_sz];
      amt_wk_buf -= wp_sz;

    }
}


extern "C" __global__ void mxv_atomic() { mxv_compress<compress_atomic>(); }
extern "C" __global__ void mxv_pfx_shared()
{ mxv_compress<compress_prefix_shared>(); }
extern "C" __global__ void mxv_pfx_ballot()
{ mxv_compress<compress_prefix_ballot>(); }

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

  info.GET_INFO(mxv_ld_all);
  info.GET_INFO(mxv_ld_chunk);
#if 1
  info.GET_INFO(mxv_atomic);
  info.GET_INFO(mxv_pfx_shared);
  info.GET_INFO(mxv_pfx_ballot);
  info.GET_INFO(mxv_compress_wps);
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
  const int wp_lg = 5;
  const int wp_sz = 1 << wp_lg;

  // Examine argument 1, number of blocks per MP.
  //
  // 0: Largest number that will fit.
  // n: Number of blocks per MP.

  const int arg1_int = argc < 2 ? 1 : atoi(argv[1]);
  const bool choose_blocks_per_mp = arg1_int == 0;
  const int blocks_per_mp = abs(arg1_int);

  // Examine argument 2, number of warps per block.
  //
  // 0: If arg1 is != 0, maximize number of warps per block.
  //    If arg1 is == 0, maximize number of warps per MP.
  // n: Exact size.

  const bool opt_p = argc >= 3 && argv[2][0] == 'p';
  const int arg2_int = argc < 3 ? 0 : atoi(argv[2]+opt_p);
  const int thd_per_block_goal = arg2_int ? arg2_int << wp_lg: 1024;
  const bool choose_wps_per_block = arg2_int == 0;

  // Examine argument 3, size of array in elts per MP. Fractional values okay.
  //
  app.num_vecs = argc < 4 ? num_mp << 20 : int( atof(argv[3]) * (num_mp<<20) );

  if ( thd_per_block_goal <= 0 || app.num_vecs <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS | 0 ] [[p][ 0 | WP_PER_BLOCK]] "
             "[NUM_M_ELTs_PER_SM]\n",
             argv[0]);
      exit(1);
    }

  const bool vary_work = true;

  // Collect performance data using a wrapper to NVIDIA CUPTI event
  // counter API.
  //
  NPerf_metric_collect("inst_executed");
  if ( opt_p )
    {
      NPerf_metric_collect("gld_efficiency");
      NPerf_metric_collect("gst_efficiency");
      NPerf_metric_collect("shared_efficiency");
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
  const size_t op_size_bytes = app.num_vecs * sizeof( app.h_op[0] );
  const size_t out_size_elts = size_t(app.num_vecs) * M;
  const size_t out_size_bytes = out_size_elts * sizeof( app.h_out[0] );

  const int overrun_size_elts = thd_per_block_goal * max(N,M);
  const int overrun_size_bytes = overrun_size_elts * sizeof( app.h_out[0] );

  // Allocate storage for CPU copy of data.
  //
  app.h_in = new Elt_Type[ in_size_elts ];
  app.h_op = new Op_Type[ in_size_elts ];
  app.h_out = new Elt_Type[ out_size_elts ];
  app.h_out_check = new Elt_Type[ out_size_elts ];
  app.h_out_check_n = new Elt_Type[ out_size_elts ];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_in,  in_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_op,  op_size_bytes + overrun_size_bytes ) );
  CE( cudaMalloc( &app.d_out, out_size_bytes + overrun_size_bytes ) );

  printf("Matrix size: %d x %d.  Vectors: %d.\n",
         N, M, app.num_vecs );

  // Initialize input array.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    for ( int c=0; c<N; c++ )
      app.h_in[ i * N + c ] = debug ? Elt_Type(c) : drand48();

  const Op_Type norm_threshold_max = ( 1 << 20 );

  for ( int i=0; i<app.num_vecs; i++ )
    app.h_op[i] = random() % norm_threshold_max;

  // Initialize transformation matrix.
  //
  for ( int r=0; r<M; r++ )
    for ( int c=0; c<N; c++ )
      app.matrix[r][c] = debug ? r == c : drand48();

  // Compute correct answer.
  //
  for ( int i=0; i<app.num_vecs; i++ )
    {
      vector<Elt_Type> vo(M);
      for ( int r=0; r<M; r++ )
        for ( int c=0; c<N; c++ )
          vo[ r ] += app.h_in[ i * N + c ] * app.matrix[r][c];
      Elt_Type *cptr = &app.h_out_check[ i * M ];
      for ( auto e: vo ) *cptr++ = e;
      {
        Elt_Type sos = 0;
        for ( auto e: vo ) sos += e*e;
        Elt_Type nf = sos ? powf(sos,-0.5) : 1;
        for ( auto& e: vo ) e *= nf;
      }
      Elt_Type *cptrn = &app.h_out_check_n[ i * M ];
      for ( auto e: vo ) *cptrn++ = e;
    }

  const int64_t num_ops_max_mxv = ( int64_t(M) * N + N + M ) * app.num_vecs;
  const int64_t num_ops_max_iter = 7 * app.num_vecs;

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
    CE( cudaMemcpy
        ( app.d_op, app.h_op, op_size_bytes, cudaMemcpyHostToDevice ) );

    // Copy App structure to GPU.
    //
    CE( cudaMemcpyToSymbol
        ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

    double tscale = 0;

    for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
      {
        cudaFuncAttributes& cfa = info.ki[kernel].cfa;
        const int wp_limit = cfa.maxThreadsPerBlock >> wp_lg;
        const int thd_limit = wp_limit << wp_lg;
        // gl: Goal and limit.
        const int thd_per_block_gl = min(thd_per_block_goal,thd_limit);

        int block_sz = 0;
        int bl_p_mp = 0;

        if ( choose_wps_per_block && choose_blocks_per_mp )
          {
            int num_wp_per_mp = 0;
            int num_wp = 0;
            for ( int nwpi = 1; nwpi <= wp_limit; nwpi++ )
              if ( set_max
                   ( num_wp_per_mp,
                     nwpi * info.get_max_active_blocks_per_mp(kernel,nwpi<<5) )
                   )
                num_wp = nwpi;
            bl_p_mp = num_wp_per_mp / num_wp;
            block_sz = num_wp * wp_sz;
          }
        else if ( !choose_wps_per_block && choose_blocks_per_mp )
          {
            block_sz = thd_per_block_gl;
            bl_p_mp = info.get_max_active_blocks_per_mp(kernel,block_sz);
          }
        else if ( choose_wps_per_block && !choose_blocks_per_mp )
          {
            for ( int nwpi = wp_limit; nwpi >= 1; nwpi-- )
              {
                const int bl_sz = nwpi << wp_lg;
                if ( !set_max
                     ( bl_p_mp,
                       info.get_max_active_blocks_per_mp(kernel,bl_sz) ) )
                  continue;
                block_sz = bl_sz;
                set_min( bl_p_mp, blocks_per_mp );
                if ( bl_p_mp >= blocks_per_mp ) break;
              }
          }
        else if ( !choose_wps_per_block && !choose_blocks_per_mp )
          {
            block_sz = thd_per_block_gl;
            bl_p_mp = blocks_per_mp;
          }
        else { assert( false ); }

        const int n_blocks = bl_p_mp * num_mp;

        assert( block_sz && n_blocks );

        pTable table(stdout);

        const double wp_1_2 = 1.0 - pow(0.5,1.0/wp_sz);
        const double wp_1_8 = 1.0 - pow(0.875,1.0/wp_sz);

        for ( double work_frac: { 1.0, .75, .5, .25, wp_1_2, wp_1_8, 0.0 } )
          {
            Op_Type norm_threshold = work_frac * norm_threshold_max;

            app.norm_threshold = norm_threshold;

            // Copy App structure to GPU.
            //
            CE( cudaMemcpyToSymbol
                ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

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
              KPtr(info.ki[kernel].func_ptr)<<<n_blocks,block_sz>>>
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

            const int64_t num_ops =
              work_frac * num_ops_max_mxv + num_ops_max_iter;

            const int64_t amt_data_bytes =
              op_size_bytes + work_frac * ( in_size_bytes + out_size_bytes );

            const double thpt_compute_gflops =
              work_frac * num_ops / this_elapsed_time_s * 1e-9;
            const double thpt_data_gbps =
              amt_data_bytes / this_elapsed_time_s * 1e-9;

            if ( vary_work )
              {
                const double comp_frac =
                  1e9 * thpt_compute_gflops
                  / ( sizeof(Elt_Type) == 4 ? info.chip_sp_flops :
                      sizeof(Elt_Type) == 8 ? info.chip_dp_flops : 1 );
                const double comm_frac =
                  min(2.0,1e9 * thpt_data_gbps / info.chip_bw_Bps);

                // Number of warps, rounded up.
                //
                const int num_wps = ( block_sz + 31 ) >> wp_lg;

                // The maximum number of active blocks per MP for this
                // kernel when launched with a block size of thd_per_block.
                //
                const int max_bl_per_mp =
                  info.get_max_active_blocks_per_mp(kernel,block_sz);

                // The number of active blocks is the minimum of what
                // can fit and how many are available.
                //
                const int bl_per_mp =
                  min( max_bl_per_mp, ( n_blocks + num_mp - 1 )/ num_mp );

                // Based on the number of blocks, compute the number of warps.
                //
                const int act_wps = num_wps * bl_per_mp;

                if ( table.num_lines < 1 )
                  printf("Kernel %s:\n", info.ki[kernel].name);

                table.row_start();
                table.entry("wp",num_wps);
                table.entry("ac",act_wps);
                table.entry("work","%5.3f", work_frac);
                table.entry("t/µs","%5.0f", this_elapsed_time_s * 1e6);
                table.entry
                  ("I/op","%4.1f",
                   NPerf_metric_value_get("inst_executed")
                   * 32.0 / max(int64_t(1),num_ops) );
                if ( opt_p )
                  {
                    table.entry
                      ("SM eff","%5.1f%%",
                       NPerf_metric_value_get("shared_efficiency"));
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
                if ( !plot_bandwidth )
                  table.entry("FP θ","%4.0f", thpt_compute_gflops);
                table.entry("GB/s","%4.0f", thpt_data_gbps);

                if ( tscale == 0 ) tscale = this_elapsed_time_s * 2;

                const int max_st_len =
                  max(5, output_width - 1 - table.row_len_get() );
                pStringF fmt("%%-%ds",max_st_len);

                const bool ref_time = false;

                string util_hdr =
                  ref_time ? "Reference Time" :
                  plot_bandwidth ? "Data BW Util" : "FP Utilization";
                const double frac =
                  ref_time ? this_elapsed_time_s / tscale :
                  plot_bandwidth ? comm_frac : comp_frac;
                util_hdr += string(max_st_len - util_hdr.length(),'-');
                table.entry
                  (util_hdr,fmt,
                   string( size_t(max(0.0,frac*max_st_len)), '*' ),
                   pTable::pT_Left);
                table.row_end();

              } else {

              printf
                ("%-15s %2d wp  %7.0f µs  %8.3f GF  %8.3f GB/s  "
                 "%5.2f I/F  %5.1f%%\n",
                 info.ki[kernel].name,
                 (block_sz + wp_sz - 1 ) >> wp_lg,
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
              {
                const bool norm = app.h_op[i] > norm_threshold;
                for ( int r=0; r<M; r++ )
                  {
                    const int idx = i * M + r;
                    Elt_Type cval = norm ? 0 : app.h_out_check[idx];

                    if ( fabs( cval - app.h_out[idx] ) > 1e-5 )
                      {
                        err_count++;
                        if ( err_count < 5 )
                          printf
                            ("Error at vec %d elt %d: %.7f != %.7f (correct)\n",
                             i, r, app.h_out[idx], cval );
                      }
                  }
              }
            if ( err_count )
              printf("Total errors %d\n", err_count);
          }
      }
  }
}
