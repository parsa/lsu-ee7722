/// LSU EE 4702-1 (Fall 2015), GPU Programming
//

 /// Shared memory CUDA Example, without LSU ECE helper classes.

/// References
//
//

#if 0
/// Background

 /// Shared Memory
 //
 //  An address space that's shared amongst threads in a block.
 //    Members of a block can load values that other block members wrote.
 //
 //  The maximum amount of shared memory is 48 kiB per block in Kepler
 //  and Maxwell devices.
 //
 //  A variable is assigned to shared memory if it is declared using
 //  the __shared__ qualifier.
 //
 //  :Example: Declaration examples.

__shared__ int amount;
__shared__ float4 forces[12];

 /// Shared Memory Uses
 //
 //  Communication between threads.
 //  Caching of global memory. 
 //    (Copying to a place where it can be accessed quickly.)

 /// Other Stuff
 //
 //  Need to coordinate readers and writers.


 __syncthreads();

 atomicAdd(POINTER, AMT);

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

struct Vector
{
  float a[4];
};

struct App
{
  int num_threads;
  int array_size;
  Vector *v_in;
  float *m_out;
  Vector *d_v_in;
  float *d_m_out;
  float *block_mag_sum;
  float *d_block_mag_sum;
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;

///
/// GPU Code (Kernel)
///


__global__ void
cuda_thread_start()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  // Shared array, one element for each member of block (up to max bl size).
  __shared__ float our_mag_sums[1024];

  float my_mag_sum = 0;

  for ( int h=tid; h<d_app.array_size; h += d_app.num_threads )
    {
      Vector p = d_app.d_v_in[h];
      float sos = 0;

      for ( int i=0; i<4; i++ ) sos += p.a[i] * p.a[i];

      const float mag = sqrtf( sos );

      // Write magnitude to global memory.
      d_app.d_m_out[h] = mag;

      // Compute this thread's magnitude sum.
      my_mag_sum += mag;
    }

  // Save this thread's magnitude sum in shared memory.
  //
  our_mag_sums[threadIdx.x] = my_mag_sum;

  // Wait for all threads to do this.
  //
  __syncthreads();

  // All but the first warp are finished.
  //
  if ( threadIdx.x >= 32 ) return;

  // Threads in first warp (first 32) each compute sum for their lane.
  //
  float lane_mag_sum = 0;
  for ( int i=threadIdx.x; i<blockDim.x; i+=32 )
    lane_mag_sum += our_mag_sums[i];

  // Save the sum for this lane in shared memory.
  //
  our_mag_sums[threadIdx.x] = lane_mag_sum;

  // Have just thread 0 finish up.
  //
  if ( threadIdx.x != 0 ) return;

  // Compute the sum of the last 32 elements.
  //
  float block_mag_sum = 0;
  for ( int i=0; i<32; i++ ) block_mag_sum += our_mag_sums[i];

  // Save this sum to global memory.  CPU will sum of blocks.
  //
  d_app.d_block_mag_sum[blockIdx.x] = block_mag_sum;
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
  }}

  GET_INFO(cuda_thread_start);

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
  const int threads_per_block = argc < 2 ? 1 : atoi(argv[1]);
  const int blocks_per_grid = argc < 3 ? 1 : atoi(argv[2]);
  app.num_threads = threads_per_block * blocks_per_grid;

  app.array_size = argc < 4 ? 1 << 20 : int( atof(argv[3]) * (1<<20) );

  const int array_size_bytes = app.array_size * sizeof(app.v_in[0]);
  const int out_array_size_bytes = app.array_size * sizeof(app.m_out[0]);
  const int block_mag_sum_bytes =
    blocks_per_grid * sizeof(app.block_mag_sum[0]);

  if ( argc < 2 ) cuda_init();

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vector[app.array_size];
  app.m_out = new float[app.array_size];
  app.block_mag_sum = new float[blocks_per_grid];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_v_in,  array_size_bytes     ) );
  CE( cudaMalloc( &app.d_m_out, out_array_size_bytes ) );
  CE( cudaMalloc( &app.d_block_mag_sum, block_mag_sum_bytes ) );

  printf("Preparing for %d threads %d elements using %d blocks of size %d.\n",
         app.num_threads, app.array_size,
         blocks_per_grid, threads_per_block);

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
  cuda_thread_start<<<blocks_per_grid,threads_per_block>>>();

  // Copy output arrays from GPU to CPU.
  //
  CE( cudaMemcpy
      ( app.m_out, app.d_m_out, out_array_size_bytes, cudaMemcpyDeviceToHost) );
  CE( cudaMemcpy
      ( app.block_mag_sum, app.d_block_mag_sum, block_mag_sum_bytes,
        cudaMemcpyDeviceToHost) );

  float mag_sum = 0;
  for ( int i=0; i<blocks_per_grid; i++ )
    mag_sum += app.block_mag_sum[i];

  const double data_size = app.array_size * ( sizeof(Vector) + sizeof(float) );
  const double fp_op_count = app.array_size * 5;
  const double elapsed_time = time_fp() - time_start;

  float mag_sum_check = 0;
  for ( int i=0; i<app.array_size; i++ )
    mag_sum_check += app.m_out[i];

  const float mag_avg_check = mag_sum_check / app.array_size;
  const float mag_avg = mag_sum / app.array_size;

  if ( fabs(mag_avg_check-mag_avg) > 0.00001 )
    printf("** Averages don't check %.7f != %.7f (cpu)\n",
           mag_avg, mag_avg_check);

  printf("Elapsed time for %d threads and %d elements is %.3f µs\n",
         app.num_threads, app.array_size, 1e6 * elapsed_time);

  printf("Rate %.3f GFLOPS,  %.3f GB/s\n",
         1e-9 * fp_op_count / elapsed_time,
         1e-9 * data_size / elapsed_time);

}
