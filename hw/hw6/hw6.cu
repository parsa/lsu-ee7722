/// LSU EE 7700-2 (Spring 2013), GPU Microarchitecture
//

 /// Homework 6
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gp/2013/hw06.pdf
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

// Size of vectors.
#define N 2

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

struct __align__(4 * N) Vertex
{
  Elt_Type a[N];
};

#if N == 4
__device__ Vertex make_vertex(float4 f4)
{
  Vertex p;
  p.a[0]=f4.x; p.a[1]=f4.y; p.a[2]=f4.z; p.a[3]=f4.w;
  return p;
}
#endif

__device__ Vertex make_vertex(float2 f)
{
  Vertex p;
  p.a[0]=f.x; p.a[1]=f.y;
  return p;
}

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  int array_size;  // Number of vertices.
  Vertex *v_in, *v_out, *v_out_cpu;
#if N == 4
  float4 *d_v_in_f4;
#endif
#if N == 2
  float2 *d_v_in_f4;
#endif
  // Note: Undeclared variable error if N not 2 or 4.
  Vertex *d_v_in;
  Vertex *d_v_out;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;


//
// Perform vertex transformation assuming lots of threads per block.
//
extern "C" __global__ void
kernel_many_threads()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int num_threads = d_app.num_threads;
  const int array_size = d_app.array_size;

  // Prepare a vertex holding the constant zero.
  Vertex zero; for ( int i=0; i<N; i++ ) zero.a[i] = 0;

  for ( int h=tid;  h<array_size;  h += num_threads )
    {
      // Load a vertex from global memory. Loaded as a float2 so that
      // the compiler uses a vector load, operated on as a Vertex for
      // coding convenience.
      //
      Vertex p = make_vertex(d_app.d_v_in_f4[h]);

      Vertex q = zero;

      // Perform the transformation.
      //
      for ( int i=0; i<N; i++ )
        for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p.a[j];

      // And write the result.
      //
      d_app.d_v_out[h] = q;
    }
}


//
// Perform vertex transformation assuming fewer threads.
//
// Degree is number of times that loop unrolled.
//
template<int DEGREE>
__device__ void
kernel_few_threads_d()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  const int num_threads = d_app.num_threads;
  const int array_size = d_app.array_size;
  Vertex zero; for ( int i=0; i<N; i++ ) zero.a[i] = 0;

  const int safe_limit = array_size - DEGREE * num_threads;
  int h = tid;

  // Make sure compiler doesn't try to unroll it further.
# pragma unroll 1

  // Main loop, each iteration operates on DEGREE vertices.
  //
  for ( ; h<safe_limit;  h += DEGREE * num_threads )
    {
      // Load the vertices.
      //
      Vertex p[DEGREE];
      for ( int i=0; i<DEGREE; i++ )
        p[i] = make_vertex(d_app.d_v_in_f4[h + i * num_threads]);

      // Transform and store them.
      //
      for ( int l=0; l<DEGREE; l++ )
        {
          Vertex q = zero;
          for ( int i=0; i<N; i++ )
            for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p[l].a[j];
          d_app.d_v_out[h+l*num_threads] = q;
        }
    }

  // Perform the last few iterations.
  //
  for ( ; h < array_size; h += num_threads )
    {
      Vertex p = make_vertex(d_app.d_v_in_f4[h]);
      Vertex q = zero;
      for ( int i=0; i<N; i++ )
        for ( int j=0; j<N; j++ ) q.a[i] += d_app.matrix[i][j] * p.a[j];
      d_app.d_v_out[h] = q;
    }
}

// Declare Kernels with varying unroll degrees.
//
extern "C" __global__ void kernel_few_threads_d2()
{ kernel_few_threads_d<2>(); }
extern "C" __global__ void kernel_few_threads_d4()
{ kernel_few_threads_d<4>(); }
extern "C" __global__ void kernel_few_threads_d8()
{ kernel_few_threads_d<8>(); }


//
// Collect GPU and Kernel Info
//

// Info about a specific kernel.
//
struct Kernel_Info {
  void (*func_ptr)();           // Pointer to kernel function.
  char *name;                   // ASCII version of kernel name.
  cudaFuncAttributes cfa;       // Kernel attributes reported by CUDA.
};

// Info about GPU and each kernel.
//
struct GPU_Info {
  double bw_Bps;
  static const int num_kernels = 4;
  Kernel_Info ki[num_kernels];
};

GPU_Info
print_gpu_info()
{
  GPU_Info info;

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  if ( device_count == 0 )
    {
      fprintf(stderr,"No GPU found, exiting.\n");
      exit(1);
    }

  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).

  /// Print information about the available GPUs.
  //
  for ( int dev=0; dev<device_count; dev++ )
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      printf
        ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
         dev, cuda_prop.name, cuda_prop.clockRate/1e6,
         int(cuda_prop.totalGlobalMem >> 20));

      const int cc_per_mp =
        cuda_prop.major == 1 ? 8 :
        cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 32 : 48 ) :
        cuda_prop.major == 3 ? 192 : 0;

      const double chip_bw_Bps = info.bw_Bps =
        2 * cuda_prop.memoryClockRate * 1000.0
        * ( cuda_prop.memoryBusWidth >> 3 );
      const double chip_sp_flops =
        1000.0 * cc_per_mp * cuda_prop.clockRate
        * cuda_prop.multiProcessorCount;

      printf
        ("GPU %d: CC: %d.%d  MP: %2d  CC/MP: %3d  TH/BL: %4d\n",
         dev, cuda_prop.major, cuda_prop.minor,
         cuda_prop.multiProcessorCount,
         cc_per_mp,
         cuda_prop.maxThreadsPerBlock);

      printf
        ("GPU %d: SHARED: %5d B  CONST: %5d B  # REGS: %5d\n",
         dev,
         int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
         cuda_prop.regsPerBlock);

      printf
        ("GPU %d: L2: %d kiB   MEM to L2: %.1f GB/s  SP %.1f GFLOPS  "
         "OP/ELT %.2f\n",
         dev,
         cuda_prop.l2CacheSize,
         chip_bw_Bps * 1e-9,
         chip_sp_flops * 1e-9,
         4 * chip_sp_flops / chip_bw_Bps);

    }

  // Choose GPU 0 because we don't have time to provide a way to let
  // the user choose.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);

#define GET_INFO(idx,proc_name)                                               \
  info.ki[idx].name = #proc_name;                                             \
  info.ki[idx].func_ptr = proc_name;                                          \
  CE( cudaFuncGetAttributes(&info.ki[idx].cfa,proc_name) );

  GET_INFO(0,kernel_many_threads);
  GET_INFO(1,kernel_few_threads_d2);
  GET_INFO(2,kernel_few_threads_d4);
  GET_INFO(3,kernel_few_threads_d8);

#undef GET_INFO

  // Print information about time_step routine.
  //
  printf("\nCUDA Routine Resource Usage:\n");

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
  // Examine argument 1, grid size.
  //
  const int arg1_int = argc < 2 ? 4 : atoi(argv[1]);
  const int num_blocks = abs(arg1_int);

   // Examine argument 2, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );

  if ( num_blocks <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_info();

  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.v_out = new Vertex[app.array_size];
  app.v_out_cpu = new Vertex[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  app.array_size * sizeof(Vertex) ) );
  CE( cudaMalloc( &app.d_v_out, app.array_size * sizeof(Vertex) ) );

  // Cast input data pointer to a type that the CUDA compiler handles better.
  //
  app.d_v_in_f4 = (typeof app.d_v_in_f4) app.d_v_in;

  printf
    ("\nPreparing for %d blocks operating on %d vectors of %d elements.\n",
     num_blocks, app.array_size, N);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    for ( int j=0; j<N; j++ ) app.v_in[i].a[j] = drand48();

  // Initialize transformation matrix.
  //
  for ( int i=0; i<N; i++ )
    for ( int j=0; j<N; j++ )
      app.matrix[i][j] = drand48();

  // Compute correct answer (for checking).
  //
  for ( int e=0; e<app.array_size; e++ )
    for ( int i=0; i<N; i++ )
      {
        app.v_out_cpu[e].a[i] = 0;
        for ( int j=0; j<N; j++ )
          app.v_out_cpu[e].a[i] += app.v_in[e].a[j] * app.matrix[i][j];
      }

  // Prepare events used for timing.
  //
  cudaEvent_t gpu_start_ce, gpu_stop_ce;
  CE(cudaEventCreate(&gpu_start_ce));
  CE(cudaEventCreate(&gpu_stop_ce));

  // Copy input array from CPU to GPU.
  //
  CE( cudaMemcpy
      ( app.d_v_in, app.v_in, array_size_bytes, cudaMemcpyHostToDevice ) );

  const double data_size = app.array_size * sizeof(Vertex) * 2;

  // Stuff needed to print bar graph.
  //
  const int full_width = 49;  // Width of longest bar.
  char * const stars = (char*) alloca(full_width+1);
  for ( int i=0; i<full_width; i++ ) stars[i] = '*';
  stars[full_width] = 0;

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      cudaFuncAttributes& cfa = info.ki[kernel].cfa;

      // Maximum number of warps per block that this GPU can handle
      // for this kernel.
      //
      const int wp_limit = cfa.maxThreadsPerBlock >> 5;

      printf("Running kernel %s which uses %d regs.\n",
             info.ki[kernel].name, cfa.numRegs);

      printf(" %3s %9s  %6s  %5s\n", "Num", "Time", "Data", "" );
      printf(" %3s %9s  %6s  %5s\n", "Wps", "µs", " GB/s", "Pct" );

      for ( int warp_cnt = 1; warp_cnt <= wp_limit; warp_cnt++ )
        {
          const int thd_per_block = warp_cnt << 5;
          app.num_threads = num_blocks * thd_per_block;

          // Copy App structure to GPU.
          //
          CE( cudaMemcpyToSymbol
              ( d_app, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

          // Zero result array (to catch errors when kernel skips elements).
          //
          CE( cudaMemset( app.d_v_out, 0, array_size_bytes ) );

          // Measure execution time starting "now", which is after data
          // set to GPU.
          //
          CE(cudaEventRecord(gpu_start_ce,0));

          // Tell CUDA to start our threads on the GPU.
          //
          info.ki[kernel].func_ptr<<<num_blocks,thd_per_block>>>();

          // Stop measuring execution time now, which is before is data
          // returned from GPU.
          //
          CE(cudaEventRecord(gpu_stop_ce,0));
          CE(cudaEventSynchronize(gpu_stop_ce));
          float cuda_time_ms = -1.1;
          CE(cudaEventElapsedTime(&cuda_time_ms,gpu_start_ce,gpu_stop_ce));
          const double elapsed_time_s = cuda_time_ms * 0.001;

          // Copy output array from GPU to CPU.
          //
          CE( cudaMemcpy
              ( app.v_out, app.d_v_out, array_size_bytes,
                cudaMemcpyDeviceToHost) );

          int err = 0;
          for ( int e=0; e<app.array_size; e++ )
            for ( int i=0; i<N; i++ )
              {
                const double diff =
                  fabs( app.v_out[e].a[i] - app.v_out_cpu[e].a[i] );
                if ( diff > 0.00001 )
                  {
                    err++;
                    if ( err < 2 )
                      printf
                        ("Error at array idx %d, "
                         "vector elt %d: %f != %f (correct)\n",
                         e, i, app.v_out[e].a[i], app.v_out_cpu[e].a[i]);
                  }
              }

          const double frac = data_size / elapsed_time_s / info.bw_Bps;
          const int s_idx = full_width * ( 1 - frac );

          printf(" %2d  %9.3f  %6.2f %5.1f%%  %s\n",
                 warp_cnt, 1e6 * elapsed_time_s,
                 1e-9 * data_size / elapsed_time_s,
                 100 * frac, &stars[s_idx] );

        }
    }
}
