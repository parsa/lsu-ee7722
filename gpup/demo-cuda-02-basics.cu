/// LSU EE 4702-1 (Fall 2015), GPU Programming
//

 /// Simple CUDA Example, without LSU ECE helper classes.

/// References
//
//

#if 0
/// Background

//  The following background describes the view of NVIDIA GPUs
//  provided by the CUDA system.  "View" means how the hardware
//  appears to the application programmer.  For CUDA, this should
//  be very close to the actual hardware.

 /// Compute Capability (CC)
//
//   An NVIDIA numbering system that identifies the approximate
//   capabilities of the hardware.
//
//   Compute Capabilities
//
//   -- CC 1.0, 1.1, 1.2, 1.3
//      Tesla. (Not to be confused with the Tesla board.)
//      Now considered obsolete.
//
//   -- CC 2.0, 2.1
//      Fermi
//
//   -- CC 3.0, 3.5
//      Kepler
//      Product cycle ending. (17 November 2014,  9:24:12 CST)
//      Currently the highest performance for scientific computation.
//
//   -- CC 5.2
//      Maxwell
//      Product cycle beginning. (17 November 2014,  9:24:16 CST)
//      Currently the highest performance for single-precision computation.


 /// Hardware Organization
//
//   Streaming Multiprocessor (SM, SMX)
//
//   Functional Unit
//     A piece of hardware that can perform a particular set of operations.
//     Examples:
//
//        CUDA Core:  Can perform most single-precision non-divide FP.


 /// Thread Organization
//
//
//   Thread
//     Has one PC.
//      Sort of a brain, or maybe just a body that can be in one place
//      at one time.
//
//   Warp
//     A collection of 32 threads.
//     One day the size of warp may change but it's been 32 through CC 5.2.
//     Threads in a warp travel together.
//
//   Block
//     A collection of threads, number determined by user.
//     All threads in a block execute on the same multiprocessor.
//     Threads within a block share shared memory.
//
//   Grid
//     A collection of blocks.

 /// Kernel Launch
//
//   :Def: Kernel Launch
//         The initiation of execution of CUDA code.
//         Done by a CUDA API call.
//         Specify:
//           The name of the CUDA C procedure to start. (E.g., my_kernel();)
//           The grid size. (The number of blocks.)
//           The block size.
//
 ///  Launch Configuration Criteria
//
//    Number of blocks is a multiple of number of SMs.
//    Number of threads per block is a multiple of 32.


 /// 

#endif

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
  float4 *d_v_in;
  float *d_m_out;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;


///
/// GPU Code (Kernels)
///


__global__ void
cuda_thread_start_simple()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  const int elt_per_thread = d_app.array_size / d_app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      float4 p = d_app.d_v_in[h];

      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;

      d_app.d_m_out[h] = sqrtf( sos );
    }
}

__global__ void
cuda_thread_start_efficient()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  for ( int h=tid; h<d_app.array_size; h += d_app.num_threads )
    {
      float4 p = d_app.d_v_in[h];

      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;

      d_app.d_m_out[h] = sqrtf( sos );
    }
}


///
/// Collect Information About GPU and Code
///

// Info about a specific kernel.
//
struct Kernel_Info {
  void (*func_ptr)();           // Pointer to kernel function.
  const char *name;             // ASCII version of kernel name.
  cudaFuncAttributes cfa;       // Kernel attributes reported by CUDA.
};

// Info about GPU and each kernel.
//
struct GPU_Info {
  double bw_Bps;
  static const int num_kernels_max = 4;
  int num_kernels;
  Kernel_Info ki[num_kernels_max];
};

GPU_Info gpu_info;

void
cuda_init()
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

      const double chip_bw_Bps = gpu_info.bw_Bps =
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
         cuda_prop.l2CacheSize >> 10,
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

  gpu_info.num_kernels = 0;

#define GET_INFO(proc_name) {                                                 \
  const int idx = gpu_info.num_kernels++;                                     \
  if ( idx < gpu_info.num_kernels_max ) {                                     \
    gpu_info.ki[idx].name = #proc_name;                                       \
    gpu_info.ki[idx].func_ptr = (void(*)())proc_name;                         \
    CE(cudaFuncGetAttributes(&gpu_info.ki[idx].cfa,proc_name));               \
  }}

  GET_INFO(cuda_thread_start_simple);
  GET_INFO(cuda_thread_start_efficient);

#undef GET_INFO

  // Print information about time_step routine.
  //
  printf("\nCUDA Routine Resource Usage:\n");

  for ( int i=0; i<gpu_info.num_kernels; i++ )
    {
      printf("For %s:\n", gpu_info.ki[i].name);
      printf("  %6zd shared, %zd const, %zd loc, %d regs; "
             "%d max threads per block.\n",
             gpu_info.ki[i].cfa.sharedSizeBytes,
             gpu_info.ki[i].cfa.constSizeBytes,
             gpu_info.ki[i].cfa.localSizeBytes,
             gpu_info.ki[i].cfa.numRegs,
             gpu_info.ki[i].cfa.maxThreadsPerBlock);
    }

  printf("\n");
}

///
/// Main Routine
///

int
main(int argc, char **argv)
{
  const int nt_raw = argc < 2 ? 1 : atoi(argv[1]);
  app.num_threads = abs(nt_raw);

  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );
  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);
  const int out_array_size_bytes = app.array_size * sizeof(app.m_out[0]);

  const bool simple = argc < 4 ? 1 : atof(argv[3]);

  if ( argc < 2 ) cuda_init();

  const int threads_per_block = 256;
  const int blocks_per_grid =
    ( app.num_threads + threads_per_block-1 ) / threads_per_block;

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vertex[app.array_size];
  app.m_out = new float[app.array_size];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  array_size_bytes     ) );
  CE( cudaMalloc( &app.d_m_out, out_array_size_bytes ) );

  printf("Launching %d blocks * %d threads for %d elts using %s kernel.\n",
         blocks_per_grid, threads_per_block, app.array_size,
         simple ? "simple" : "efficient" );

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



  /// Launch Kernel
  //
  if ( simple )

    cuda_thread_start_simple<<< blocks_per_grid, threads_per_block >>>();

  else

    cuda_thread_start_efficient<<< blocks_per_grid, threads_per_block >>>();

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
