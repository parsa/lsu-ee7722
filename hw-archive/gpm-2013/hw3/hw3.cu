/// LSU EE 7700-2 (Spring 2013), GPU Microarchitecture
//

 /// Homework 3
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gp/2013/hw03.pdf
 //
 /// Your Name:

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

#define N 4

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

// Make it easy to switch between float and double for vertex and matrix
// elements.
//
typedef float Elt_Type;

struct __align__(16) Vertex
{
  Elt_Type a[N];
};

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  int array_size;  // Number of vertices.
  bool find_minimum_magnitude; // For problem 2.
  Vertex *v_in, *v_out;
  Vertex *d_v_in, *d_v_out;
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

  // Number of elements that each thread should work on.  We are ignoring
  // rounding errors.
  //
  const int elt_per_thread = d_app.array_size / d_app.num_threads;

  /// WARNING:
  //
  // The order in which the threads examine elements here is poorly
  // chosen and will unnecessarily make inefficient use of the memory
  // system.

  // Compute element number to start at.
  //
  const int start = elt_per_thread * tid;

  // Compute element number to stop at.
  //
  const int stop = start + elt_per_thread;

  // WARNING: This code accesses elements in an inefficient order.
  for ( int h=start; h<stop; h++ )
    {
      Vertex p = d_app.d_v_in[h];
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
print_gpu_info()
{
  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  if ( device_count == 0 )
    {
      fprintf(stderr,"No GPU found, exiting.\n");
      exit(1);
    }

  int dev = 0;
  CE(cudaGetDevice(&dev));
  printf("Using GPU %d\n",dev);

  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).

  /// Print information about the available GPUs.
  //
  {
    CE(cudaGetDeviceProperties(&cuda_prop,dev));
    printf
      ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
       dev, cuda_prop.name, cuda_prop.clockRate/1e6,
       int(cuda_prop.totalGlobalMem >> 20));

    printf
      ("GPU %d: CC: %d.%d  MP: %2d  TH/WP: %3d  TH/BL: %4d\n",
       dev, cuda_prop.major, cuda_prop.minor,
       cuda_prop.multiProcessorCount,
       cuda_prop.warpSize,
       cuda_prop.maxThreadsPerBlock
       );

    printf
      ("GPU %d: SHARED: %5d  CONST: %5d  # REGS: %5d\n",
       dev,
       int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
       cuda_prop.regsPerBlock
       );
  }

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
  // Examine argument 1, block size, if negative, find minimum magnitude.
  //
  const int arg1_int = argc < 2 ? 1 : atoi(argv[1]);
  const bool find_mag = arg1_int < 0;
  const int num_blocks = abs(arg1_int);

  const bool use_pthreads = false;

  // For Problem 2.
  app.find_minimum_magnitude = find_mag;

  // Examine argument 2, number of threads per block.
  //
  const int thd_per_block = argc < 3 ? 1 : atoi(argv[2]);
  app.num_threads = use_pthreads ? -arg1_int : num_blocks * thd_per_block;

  // Examine argument 3, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  if ( app.num_threads <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_PTHREADS | - NUM_CUDA_BLOCKS ] [THD_PER_BLOCK] [DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  if ( !use_pthreads )
    print_gpu_info();

  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.v_out = new Vertex[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  app.array_size * sizeof(Vertex) ) );
  CE( cudaMalloc( &app.d_v_out, app.array_size * sizeof(Vertex) ) );

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

  double elapsed_time_s;
  int minimum_mag_index = 0;     // For Problem 2.
  Elt_Type minimum_mag_val = 0;  // For Problem 2.

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

      // Measure execution time starting "now", which is after data
      // set to GPU.
      //
      CE(cudaEventRecord(gpu_start_ce,0));

      printf("Launching with %d blocks of %d threads.\n",
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
      elapsed_time_s = cuda_time_ms * 0.001;

      // Copy output array from GPU to CPU.
      //
      CE( cudaMemcpy
          ( app.v_out, app.d_v_out, array_size_bytes, cudaMemcpyDeviceToHost) );

      // PROBLEM 2
      //
      // Insert code for reading magnitude information and having
      // CPU finish up finding the minimum.

      minimum_mag_index = -1;  // PROBLEM 2 - change this line.
      minimum_mag_val = 0.0;   // PROBLEM 2 - change this line too.
    }

  const double data_size = app.array_size * sizeof(Vertex) * 2;
  const double fp_op_count = app.array_size * ( 2 * N * N - N  );

  printf("Elapsed time for %d threads and %d elements is %.3f µs\n",
         app.num_threads, app.array_size, 1e6 * elapsed_time_s);
  printf("Rate %.3f GFLOPS,  %.3f GB/s\n",
         1e-9 * fp_op_count / elapsed_time_s,
         1e-9 * data_size / elapsed_time_s);

  if ( app.find_minimum_magnitude )
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
