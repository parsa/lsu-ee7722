/// LSU EE 7722 (Spring 2015), GPU Microarchitecture
//
// Simple CUDA Example, without LSU ECE helper classes.

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
#include "util.h"

#define N 4

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

struct __align__(16) Vertex
{
  Elt_Type __align__(16) a[N];
};

struct __align__(16) V4 {
  Elt_Type x, y, z, w;
};

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  int array_size;  // Number of vertices.
  Vertex *v_in, *v_out;
  Vertex *d_v_in, *d_v_out;
  V4 * d_v4_in;

  int reduction_method;

  Elt_Type *thd_sum;
  Elt_Type *thd_min_mag_sq;
  int *thd_min_mag_sq_idx;
  Elt_Type *d_thd_sum;
  Elt_Type *d_thd_min_mag_sq;
  int *d_thd_min_mag_sq_idx;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

const int warp_size = 32;

#define BLOCK_SIZE_MAX 1024
__shared__ Elt_Type shared_sum[BLOCK_SIZE_MAX];
__shared__ int shared_mag_sq_idx[BLOCK_SIZE_MAX];
__shared__ Elt_Type wshared_mag_sq[warp_size];
__shared__ int wshared_mag_sq_idx[warp_size];

__device__ void find_min_method_1(float mag_sq, int idx);
__device__ void find_min_method_2(float mag_sq, int idx);
__device__ void find_min_method_3(float mag_sq, int idx);
__device__ void find_min_method_4(float mag_sq, int idx);


// The entry point for the GPU code.
//
__global__ void
cuda_thread_start()
{
  // Compute an id number that will be in the range from 0 to num_threads-1.
  //
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  // Compute element number to start at.
  //
  const int start = tid;
  const int stop = d_app.array_size;
  const int inc = d_app.num_threads;

  int min_mag_idx = -1;
  Elt_Type min_sum_of_sq = 0;

  for ( int h=start; h<stop; h += inc )
    {
      V4 p2 = d_app.d_v4_in[h];
      Vertex p; 
      p.a[0] = p2.x; p.a[1] = p2.y; p.a[2] = p2.z; p.a[3] = p2.w;
      Vertex q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p.a[j];
        }
      d_app.d_v_out[h] = q;

      //  Compute the magnitude squared of q and update "min" variables
      //  it it's the smallest yet.
      //
      Elt_Type sum_of_sq = 0;
      for ( int i=0; i<N; i++ ) sum_of_sq += q.a[i] * q.a[i];
      if ( h == start || sum_of_sq < min_sum_of_sq )
        {
          min_sum_of_sq = sum_of_sq;
          min_mag_idx = h;
        }
    }

  switch ( d_app.reduction_method ) {
  case 0: 
    d_app.d_thd_min_mag_sq[tid] = min_sum_of_sq;
    d_app.d_thd_min_mag_sq_idx[tid] = min_mag_idx;
    break;
  case 1: find_min_method_1(min_sum_of_sq,min_mag_idx); break;
  case 2: find_min_method_2(min_sum_of_sq,min_mag_idx); break;
  case 3: find_min_method_3(min_sum_of_sq,min_mag_idx); break;
  case 4: find_min_method_4(min_sum_of_sq,min_mag_idx); break;

  default:  d_app.d_thd_min_mag_sq[threadIdx.x] = 0; break;
  }

}

__device__ void
find_min_method_1(float thd_min_mag_sq, int thd_min_mag_sq_idx)
{
  shared_mag_sq[threadIdx.x] = thd_min_mag_sq;
  shared_mag_sq_idx[threadIdx.x] = thd_min_mag_sq_idx;
  __syncthreads();

  if ( threadIdx.x != 0 ) return;

  Elt_Type our_min = thd_min_mag_sq;
  int our_idx = thd_min_mag_sq_idx;

  for ( int i=1; i<blockDim.x; i++ )
    if ( shared_mag_sq[i] < our_min )
      {
        our_min = shared_mag_sq[i];
        our_idx = shared_mag_sq_idx[i];
      }

  d_app.d_thd_min_mag_sq[blockIdx.x] = our_min;
  d_app.d_thd_min_mag_sq_idx[blockIdx.x] = our_idx;
}

__device__ void
find_min_method_2(float thd_min_mag_sq, int thd_min_mag_sq_idx)
{
  shared_mag_sq[threadIdx.x] = thd_min_mag_sq;
  shared_mag_sq_idx[threadIdx.x] = thd_min_mag_sq_idx;

  Elt_Type our_min = thd_min_mag_sq;
  int our_idx = thd_min_mag_sq_idx;

  // Note: Block size must be a power of 2.

  for ( int dist = blockDim.x >> 1;  dist;  dist >>= 1 )
    {
      __syncthreads();
      if ( threadIdx.x < dist
           && shared_mag_sq[ threadIdx.x + dist ] < our_min )
        {
          our_min = shared_mag_sq[ threadIdx.x ] =
            shared_mag_sq[ threadIdx.x + dist ];
          our_idx = shared_mag_sq_idx[ threadIdx.x ] =
            shared_mag_sq_idx[ threadIdx.x + dist ];
        }
    }

  if ( threadIdx.x ) return;

  d_app.d_thd_min_mag_sq[blockIdx.x] = our_min;
  d_app.d_thd_min_mag_sq_idx[blockIdx.x] = our_idx;
}

__device__ void
find_min_method_3(float thd_min_mag_sq, int thd_min_mag_sq_idx)
{
  shared_mag_sq[threadIdx.x] = thd_min_mag_sq;
  shared_mag_sq_idx[threadIdx.x] = thd_min_mag_sq_idx;
  __syncthreads();

  Elt_Type our_min = thd_min_mag_sq;
  int our_idx = thd_min_mag_sq_idx;

  const int warp_size = 32;
  const int half_warp_size = warp_size >> 1;

  if ( threadIdx.x < warp_size )
    for ( int i = threadIdx.x + warp_size;  i < blockDim.x;  i += warp_size )
      if ( shared_mag_sq[ i ] < our_min )
        {
          our_min = shared_mag_sq[ i ];
          our_idx = shared_mag_sq_idx[ i ];
        }

  shared_mag_sq[threadIdx.x] = our_min;
  shared_mag_sq_idx[threadIdx.x] = our_idx;

  if ( threadIdx.x < half_warp_size )
    for ( int dist = half_warp_size;  dist;  dist >>= 1 )
      if ( threadIdx.x < dist
           && shared_mag_sq[ threadIdx.x + dist ] < our_min )
        {
          our_min = shared_mag_sq[ threadIdx.x ] =
            shared_mag_sq[ threadIdx.x + dist ];
          our_idx = shared_mag_sq_idx[ threadIdx.x ] =
            shared_mag_sq_idx[ threadIdx.x + dist ];
        }

  if ( threadIdx.x ) return;

  d_app.d_thd_min_mag_sq[blockIdx.x] = our_min;
  d_app.d_thd_min_mag_sq_idx[blockIdx.x] = our_idx;
}

__device__ void
find_min_method_4(float thd_min_mag_sq, int thd_min_mag_sq_idx)
{
  shared_mag_sq[threadIdx.x] = thd_min_mag_sq;
  shared_mag_sq_idx[threadIdx.x] = thd_min_mag_sq_idx;

  Elt_Type our_min = thd_min_mag_sq;
  int our_idx = thd_min_mag_sq_idx;

  const int warp_lg = 5;
  const int warp_size = 1 << warp_lg;
  const int half_warp_size = warp_size >> 1;
  const int lane = threadIdx.x & ( warp_size - 1 );

  for ( int dist = half_warp_size;  dist;  dist >>= 1 )
    if ( lane < dist && shared_mag_sq[ threadIdx.x + dist ] < our_min )
      {
        our_min = shared_mag_sq[ threadIdx.x ] =
          shared_mag_sq[ threadIdx.x + dist ];
        our_idx = shared_mag_sq_idx[ threadIdx.x ] =
          shared_mag_sq_idx[ threadIdx.x + dist ];
      }


#if 1

  const int warp_num = threadIdx.x >> warp_lg;

  if ( !lane )
    {
      wshared_mag_sq[ warp_num ] = our_min;
      wshared_mag_sq_idx[ warp_num ] = our_idx;
    }

  __syncthreads();

  if ( threadIdx.x < half_warp_size )
  for ( int dist = half_warp_size;  dist;  dist >>= 1 )
    if ( lane < dist && wshared_mag_sq[ threadIdx.x + dist ] < our_min )
      {
        our_min = wshared_mag_sq[ threadIdx.x ] =
          wshared_mag_sq[ threadIdx.x + dist ];
        our_idx = wshared_mag_sq_idx[ threadIdx.x ] =
          wshared_mag_sq_idx[ threadIdx.x + dist ];
      }

#else

  __syncthreads();

  const int our_elt = threadIdx.x << warp_lg;
  const int block_size = blockDim.x;

  if ( threadIdx.x < warp_size )
  for ( int dist = block_size >> 1;  dist >= warp_size;  dist >>= 1 )
      if ( our_elt < dist
           && shared_mag_sq[ our_elt + dist ] < our_min )
        {
          our_min = shared_mag_sq[ our_elt ] = shared_mag_sq[ our_elt + dist ];
          our_idx = shared_mag_sq_idx[ our_elt ]
            = shared_mag_sq_idx[ our_elt + dist ];
        }

#endif

  if ( threadIdx.x ) return;

  d_app.d_thd_min_mag_sq[blockIdx.x] = our_min;
  d_app.d_thd_min_mag_sq_idx[blockIdx.x] = our_idx;
}

void
print_gpu_and_kernel_info()
{
  print_gpu_info();

  cudaFuncAttributes cfa_prob1; // Properties of code to run on device.
  CE( cudaFuncGetAttributes(&cfa_prob1,cuda_thread_start) );

  // Print information about time_step routine.
  //
  printf("\nCUDA Routine Resource Usage:\n");
  printf(" Our CUDA Thread: %6zd shared, %zd const, %zd loc, %d regs; "
         "%d max threads per block.\n",
         cfa_prob1.sharedSizeBytes,
         cfa_prob1.constSizeBytes,
         cfa_prob1.localSizeBytes,
         cfa_prob1.numRegs,
         cfa_prob1.maxThreadsPerBlock);
}

void*
pt_thread_start(void *arg)
{
  const int tid = (ptrdiff_t) arg;
  printf("Hello from %d\n",tid);
  const int elt_per_thread = app.array_size / app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      Vertex p = app.v_in[h];
      Vertex q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }

  return NULL;
}

int
main(int argc, char **argv)
{
  // Examine argument 1, block count, if negative, use pthreads.
  //
  const int arg1_int = argc < 2 ? 32 : atoi(argv[1]);
  const bool use_pthreads = arg1_int < 0;
  const int num_blocks = abs(arg1_int);

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block = argc < 3 ? 256 : atoi(argv[2]);
  app.num_threads = use_pthreads ? -arg1_int : num_blocks * thd_per_block;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  app.reduction_method = argc < 5 ? 0 : atoi(argv[4]);
  const int mag_array_size =
    app.reduction_method ? num_blocks : app.num_threads;

  if ( app.num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ -NUM_PTHREADS | NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  if ( !use_pthreads )
    print_gpu_and_kernel_info();

  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.v_out = new Vertex[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  app.array_size * sizeof(Vertex) ) );
  CE( cudaMalloc( &app.d_v_out, app.array_size * sizeof(Vertex) ) );
  app.d_v4_in = (V4*) app.d_v_in;

  //  Allocate storage on CPU and GPU for the minimum magnitude (sq) and
  //  its index.
  //
  app.thd_min_mag_sq_idx = new int[mag_array_size];
  app.thd_min_mag_sq = new Elt_Type[mag_array_size];
  CE( cudaMalloc( &app.d_thd_min_mag_sq_idx, mag_array_size * sizeof(int) ) );
  CE( cudaMalloc( &app.d_thd_min_mag_sq, mag_array_size * sizeof(Elt_Type) ) );

  // Initialize device memory to zeros. Helps catch bugs.
  //
  CE( cudaMemset( app.d_thd_min_mag_sq_idx, 0, mag_array_size*sizeof(int) ) );
  CE( cudaMemset( app.d_thd_min_mag_sq, 0, mag_array_size*sizeof(Elt_Type) ) );

  printf
    ("\nPreparing for %d %s threads for %d vectors.  "
     "Reduction method %d.\n",
         app.num_threads,
         use_pthreads ? "CPU" : "GPU",
         app.array_size, app.reduction_method);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<N; j++ ) app.v_in[i].a[j] = drand48();

  // Initialize transformation matrix.
  //
  for ( int i=0; i<N; i++ )
    for ( int j=0; j<N; j++ )
      app.matrix[i][j] = drand48();

  double elapsed_time_s = 86400; // Reassigned to minimum run time.
  int minimum_mag_index = 0;
  Elt_Type minimum_mag_val = 0;

  if ( use_pthreads )
    {
      const double time_start = time_fp();

      // Allocate a structure to hold pthread thread ids.
      //
      pthread_t* const ptid = new pthread_t[app.num_threads];

      // Set up a pthread attribute, used for specifying options.
      //
      pthread_attr_t attr;
      pthread_attr_init(&attr);
      pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);

      // Launch the threads.
      //
      for ( int i=0; i<app.num_threads; i++ )
        pthread_create(&ptid[i], &attr, pt_thread_start, (void*)i);

      // Wait for each thread to finish.
      //
      for ( int i=0; i<app.num_threads; i++ )
        pthread_join( ptid[i], NULL );

      elapsed_time_s = time_fp() - time_start;
    }
  else
    {
      // Prepare events used for timing.
      //
      cudaEvent_t gpu_start_ce, gpu_stop_ce;
      CE(cudaEventCreate(&gpu_start_ce));
      CE(cudaEventCreate(&gpu_stop_ce));

      // Copy input array from CPU to GPU.
      //
      CE( cudaMemcpy
          ( app.d_v_in, app.v_in, array_size_bytes, cudaMemcpyHostToDevice ) );

      // Copy App structure to GPU.
      //
      CE( cudaMemcpyToSymbol
          ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

      // Launch kernel multiple times and keep track of the best time.

      const int num_reps = 5;
      for ( int r=0; r<num_reps; r++ )
        {
          // Measure execution time starting "now", which is after data
          // set to GPU.
          //
          CE(cudaEventRecord(gpu_start_ce,0));

          printf("Launching with %d blocks of %d threads ... ",
                 num_blocks, thd_per_block);

          // Tell CUDA to start our threads on the GPU.
          //
          cuda_thread_start<<<num_blocks,thd_per_block>>>();

          // Stop measuring execution time now, which is before is data
          // returned from GPU.
          //
          CE(cudaEventRecord(gpu_stop_ce,0));
          CE(cudaEventSynchronize(gpu_stop_ce));
          float cuda_time_ms = -1.1;
          CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));

          const double this_elapsed_time_s = cuda_time_ms * 0.001;
          printf(" %11.3f µs\n", this_elapsed_time_s * 1e6 );

          elapsed_time_s = min(this_elapsed_time_s,elapsed_time_s);
        }
    }

  // Copy output array from GPU to CPU.
  //
  CE( cudaMemcpy
      ( app.v_out, app.d_v_out, array_size_bytes, cudaMemcpyDeviceToHost) );

  //  Copy back per-thread minimum magnitudes (squared) and their indices.
  //
  CE( cudaMemcpy
      ( app.thd_min_mag_sq, app.d_thd_min_mag_sq,
        sizeof(Elt_Type) * mag_array_size, cudaMemcpyDeviceToHost) );
  CE( cudaMemcpy
      ( app.thd_min_mag_sq_idx, app.d_thd_min_mag_sq_idx,
        sizeof(int) * mag_array_size, cudaMemcpyDeviceToHost) );

  // Find the minimum magnitude squared and its index.
  //
  Elt_Type min_sos = app.thd_min_mag_sq[0];
  minimum_mag_index = app.thd_min_mag_sq_idx[0];
  for ( int i=1; i<mag_array_size; i++ )
    if ( app.thd_min_mag_sq[i] < min_sos )
      {
        min_sos = app.thd_min_mag_sq[i];
        minimum_mag_index = app.thd_min_mag_sq_idx[i];
      }

  // Take the square root to get the magnitude.
  //
  minimum_mag_val = sqrt(min_sos);

  const double data_size = app.array_size * sizeof(Vertex) * 2;
  const double fp_op_count = app.array_size * ( 2 * N * N - N  );

  printf("Elapsed time for %d threads and %d elements is %.3f µs\n",
         app.num_threads, app.array_size, 1e6 * elapsed_time_s);
  printf("Rate %.3f GFLOPS,  %.3f GB/s\n",
         1e-9 * fp_op_count / elapsed_time_s,
         1e-9 * data_size / elapsed_time_s);

  {
    // Compute correct answer.
    Elt_Type min_val = 0;
    int min_idx = -1;

    for ( int h=0; h<app.array_size; h++ )
      {
        Vertex p = app.v_in[h];
        Vertex q;
        for ( int i=0; i<N; i++ )
          {
            q.a[i] = 0;
            for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
          }
        Elt_Type sos = 0; for(int i=0; i<N; i++ ) sos+= q.a[i]*q.a[i];
        Elt_Type mag = sqrt(sos);
        if ( min_idx < 0 || mag < min_val ) { min_val = mag; min_idx = h; }
      }
    Elt_Type diff = fabs(min_val-minimum_mag_val);
    printf
      ("\nMinimum mag is %s,  %d %s %d (correct)  %.4f %s %.4f (correct)\n",
       diff < 1e-5 ? "correct" : "**wrong**",
       minimum_mag_index,
       min_idx == minimum_mag_index ? "==" : "!=",
       min_idx,
       minimum_mag_val,
       min_val == minimum_mag_val ? "==" : diff < 1e-5 ? "~" : "!=",
       min_val
       );

  }

}
