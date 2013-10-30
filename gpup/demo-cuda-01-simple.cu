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

 /// CUDA API Error-Checking Wrapper
///
#define CE(call)                                                              \
 {                                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess )                                                   \
     {                                                                        \
       printf("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));               \
       exit(1);                                                               \
     }                                                                        \
 }

double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}

struct Vertex
{
  float a[4];
};

struct App
{
  int num_threads;
  int array_size;
  Vertex *v_in;
  float *m_out;
  Vertex *d_v_in;
  float *d_m_out;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

__global__ void
cuda_thread_start()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  const int elt_per_thread = d_app.array_size / d_app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      Vertex p = d_app.d_v_in[h];
      float sos = 0;

      for ( int i=0; i<4; i++ ) sos += p.a[i] * p.a[i];

      d_app.d_m_out[h] = sqrtf( sos );
    }
}

int
main(int argc, char **argv)
{
  const int nt_raw = argc < 2 ? 1 : atoi(argv[1]);
  app.num_threads = abs(nt_raw);

  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );
  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);
  const int out_array_size_bytes = app.array_size * sizeof(app.m_out[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.m_out = new float[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  array_size_bytes     ) );
  CE( cudaMalloc( &app.d_m_out, out_array_size_bytes ) );

  printf("Preparing for %d threads %d elements.\n",
         app.num_threads, app.array_size);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<4; j++ ) app.v_in[i].a[j] = drand48();

  const double time_start = time_fp();

  // Copy input array from CPU to GPU.
  //
  CE( cudaMemcpy
      ( app.d_v_in, app.v_in, array_size_bytes, cudaMemcpyHostToDevice ) );

  // Copy App structure to GPU.
  //
  CE( cudaMemcpyToSymbol
      ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

  const int threads_per_block = 256;
  const int blocks_per_grid =
    ( app.num_threads + threads_per_block-1 ) / threads_per_block;

  cuda_thread_start<<<blocks_per_grid,threads_per_block>>>();

  // Copy output array from GPU to CPU.
  //
  CE( cudaMemcpy
      ( app.m_out, app.d_m_out, out_array_size_bytes, cudaMemcpyDeviceToHost) );

  const double data_size = app.array_size * ( sizeof(Vertex) + sizeof(float) );
  const double fp_op_count = app.array_size * 5;
  const double elapsed_time = time_fp() - time_start;

  printf("Elapsed time for %d threads and %d elements is %.3f µs\n",
         app.num_threads, app.array_size, 1e6 * elapsed_time);
  printf("Rate %.3f GFLOPS,  %.3f GB/s\n",
         1e-9 * fp_op_count / elapsed_time,
         1e-9 * data_size / elapsed_time);
}