/// LSU EE 7722 (Spring 2015), GPU Microarchitecture
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
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

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
#if 1
  const int start = tid;
  const int stop = d_app.array_size;
  const int inc = d_app.num_threads;
#else
  const int start = tid * elt_per_thread;
  const int stop = start + elt_per_thread;
  const int inc = 1;
#endif

  for ( int h=start; h<stop; h += inc )
    {
#if 1
      Vertex p = d_app.d_v_in[h];
#else
      V4 p2 = d_app.d_v4_in[h];
      Vertex p; 
      p.a[0] = p2.x; p.a[1] = p2.y; p.a[2] = p2.z; p.a[3] = p2.w;
#endif
      Vertex q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p.a[j];
        }
      d_app.d_v_out[h] = q;
    }
}

void
print_gpu_and_kernel_info()
{
  gpu_info_print();

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
  const int arg1_int = argc < 2 ? 1 : atoi(argv[1]);
  const bool use_pthreads = arg1_int < 0;
  const int num_blocks = abs(arg1_int);

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block = argc < 3 ? 1024 : atoi(argv[2]);
  app.num_threads = use_pthreads ? -arg1_int : num_blocks * thd_per_block;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 22 : int( atof(argv[3]) * (1<<20) );

  if ( app.num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ -NUM_PTHREADS | NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] "
             "[DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  if ( !use_pthreads && argc == 1 )
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

  printf
    ("\nPreparing for %d %s threads operating on %d vectors of %d elements.\n",
         app.num_threads,
         use_pthreads ? "CPU" : "GPU",
         app.array_size, N);

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
        pthread_create(&ptid[i], &attr, pt_thread_start, (void*)ptrdiff_t(i));

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

      // Copy output array from GPU to CPU.
      //
      CE( cudaMemcpy
          ( app.v_out, app.d_v_out, array_size_bytes, cudaMemcpyDeviceToHost) );

    }

  const double data_size = app.array_size * sizeof(Vertex) * 2;
  const double fp_op_count = app.array_size * ( 2 * N * N - N  );

  printf("Elapsed time for %d threads and %d elements is %.3f µs\n",
         app.num_threads, app.array_size, 1e6 * elapsed_time_s);
  printf("Rate %.3f GFLOPS,  %.3f GB/s\n",
         1e-9 * fp_op_count / elapsed_time_s,
         1e-9 * data_size / elapsed_time_s);
}
