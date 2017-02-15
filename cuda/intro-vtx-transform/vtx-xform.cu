/// LSU EE 7722 (Spring 2017), GPU Microarchitecture
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
#include <vector>
using namespace std;

#include <cuda_runtime.h>

#include "util.h"

typedef float Elt_Type;

#define N 4

struct __builtin_align__(N*sizeof(Elt_Type)) __align__(N*sizeof(Elt_Type))
Vector
{
  Elt_Type a[N];
};

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  size_t array_size;
  Vector *v_in, *v_out;
  Vector *d_v_in, *d_v_out;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

void
omp_start()
{
#pragma omp parallel for num_threads(app.num_threads)
  for ( unsigned int h=0; h<app.array_size; h++ )
    {
      Vector p = app.v_in[h];
      Vector q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }
}

void*
pt_thread_start(void *arg)
{
  const int tid = (ptrdiff_t) arg;
  //  printf("Hello from %d\n",tid);
  const int elt_per_thread = app.array_size / app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      Vector p = app.v_in[h];
      Vector q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }

  return NULL;
}

__global__ void
cuda_thread_start()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  for ( int h=tid; h<d_app.array_size; h += d_app.num_threads )
    {
      Vector p = d_app.d_v_in[h];
      Vector q;
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

  // Determine which GPU to use. (For starters, if there's more than
  // one, choose the one connected to the display.)
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);

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

int
main(int argc, char **argv)
{
  const int nt_raw = argc < 2 ? 1 : atoi(argv[1]);
  app.num_threads = abs(nt_raw);

  print_gpu_and_kernel_info();

  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );
  const size_t array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vector[app.array_size];
  app.v_out = new Vector[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( & app.d_v_in,  app.array_size * sizeof(Vector) ) );
  CE( cudaMalloc( & app.d_v_out, app.array_size * sizeof(Vector) ) );

  printf("Using  %zd elements.\n", app.array_size);

  // Initialize input array.
  //
  for ( size_t i=0; i<app.array_size; i++ )
    for ( int j=0; j<N; j++ ) app.v_in[i].a[j] = drand48();

  // Initialize transformation matrix.
  //
  for ( int i=0; i<N; i++ )
    for ( int j=0; j<N; j++ )
      app.matrix[i][j] = drand48();

  printf("For %zd elements...\n", app.array_size);

  const char* const names[] = { "OMP", "PTH", "CUDA" };

  vector<pthread_t> ptid;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setscope(&attr, PTHREAD_SCOPE_SYSTEM);

  // Copy input array from CPU to GPU.
  //
  CE( cudaMemcpy
      ( app.d_v_in, app.v_in, array_size_bytes, cudaMemcpyHostToDevice ) );

  for ( int i=0; i<3; i++ )
    {
      printf("Running %s...\n", names[i]);
      for ( int ntl = 0; ntl < 7; ntl++ )
        {
          const double time_start = time_fp();

          app.num_threads = i < 2 ? 1 << ntl : 32 << ntl;
          switch ( i ) {

          case 0:
            omp_start();
            break;

          case 1: // pthreads
            {
              ptid.resize(app.num_threads);
              for ( ptrdiff_t i=0; i<app.num_threads; i++ )
                {
                  pthread_create(&ptid[i], &attr, pt_thread_start, (void*)i);
                }

              for ( int i=0; i<app.num_threads; i++ )
                {
                  pthread_join( ptid[i], NULL );
                }
            }
            break;
          case 2: // CUDA
            {
              // Copy App structure to GPU.
              //
              CE( cudaMemcpyToSymbol
                  ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

              const int threads_per_block = min(app.num_threads,32);
              const int blocks_per_grid =
                ( app.num_threads + threads_per_block-1 ) / threads_per_block;

              /// Kernel Launch
              cuda_thread_start <<< blocks_per_grid, threads_per_block >>>();

              CE( cudaStreamSynchronize( 0 ) );

            }
            break;
          }

          const double data_size = app.array_size * sizeof(Vector) * 2;
          const double fp_op_count = app.array_size * ( 16 + 12 );
          const double elapsed_time = time_fp() - time_start;

          // Copy output array from GPU to CPU.
          //
          CE( cudaMemcpy
              ( app.v_out, app.d_v_out, array_size_bytes,
                cudaMemcpyDeviceToHost) );

          printf(" %4d thds  %10.3f µs  Rate %7.3f GFLOPS,  %7.3f GB/s\n",
                 app.num_threads,
                 1e6 * elapsed_time,
                 1e-9 * fp_op_count / elapsed_time,
                 1e-9 * data_size / elapsed_time);

        }
    }


}
