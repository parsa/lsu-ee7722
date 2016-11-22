/// LSU EE 4702-1 (Fall 2016), GPU Programming
//

 /// Shared memory CUDA Example, without LSU ECE helper classes.

/// References
//
//

#if 0
/// Background

 /// Shared Address Space and Shared Memory
 //
 //  References
 //    General description: CUDA C Programming Guide Section 3.23 (v8)
 //    Amount of SM: CUDA C Programming Guide Section Table 12 (Appendix G)
 //
 //
 //  :Def: Shared Address Space
 //  An address space provided by CUDA (through CC 5.x) in which:
 //
 //   - Each block has its own address space.
 //
 //   - Address space is shared by all threads in a block.
 //
 //   - Locations can be read and written.
 //
 //   - Size of space is 48 kiB in CC 2.X to CC 5.x (so far).
 //
 //   - Shared address space uses shared memory.
 //
 //
 //  :Def: Shared Memory
 //  Hardware used to implement the shared address space.
 //
 //   - Shared memory is part of SM, so no communication limits.
 //
 //   - Amount of shared memory per SM (NOT per block) varies:
 //      48 kiB  CC 2.0 - CC 3.5
 //     112 kiB  CC 3.7
 //      64 kiB  CC 5.0, 5.3, 6.0, 6.2
 //      96 kiB  CC 5.2, 6.1
 //
 //   - Low latency (fast). As low as 12 cycles.
 //
 //   - High throughput.
 //
 //   - Banked organization.  Throughput depends on access patterns.
 //
 //
 /// Declaration and Use of Shared Memory
 //
 //   - Declare variables using __shared__ qualifier.
 //
 //   - Declaration can be at procedure or global scope.
 //
 //   - Any type can be shared, including arrays.
 //
 //   - Pointers to shared variables can be taken.
 //
 //  :Example: Declaration examples.

__shared__ int amount;
__shared__ float4 forces[12];


 /// Shared Memory Uses
 //
 //  Communication between threads.
 //    For example, to compute a block-wide sum.
 //
 //  Caching of global memory. 
 //    (Copying to a place where it can be accessed quickly.)


  /// Atomic Operations
  //
  //  :Def: Atomic Operation
  //        An operation that appears to be either ..
  //        .. completely finished or ..
  //        .. not yet started.
  //        An atomic operation NEVER appears to be partially done.

  //  :Example:
  //
  //  A the following "+=" operation is NOT atomic.
  //
  __shared__ int sum;

  if ( threadIdx.x == 0 )  sum = 0;
  if ( threadIdx.x == 40 ) sum += 40;
  if ( threadIdx.x == 70 ) sum += 70;
  //
  //  An we need an atomic operation to perform the additions above.

  /// CUDA C Atomic Operations
  //
  //  Reference: CUDA C Programming Guide B.12
  //
  /// oldval = atomicAdd( valAddress, amount )
  //  Atomically add amount to *valAddress, return old value.


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
#include <gp/cuda-gpuinfo.h>

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}


#if 0

__global__ void
cuda_thread_super_simple(int *output_data, int *input_data)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int my_element = input_data[tid];

  /// Reasonable use of shared memory.
  //
  //  Make thread 12's element available to all threads in the block.

  __shared__ int a;

  if ( threadIdx.x == 12 ) a = my_element;

  __syncthreads();

  output_data[tid] = my_element + a;


  /// Bad use of shared memory.
  //
  //  Everyone writes trouble.

  __shared__ int trouble;

  trouble = my_element;

  __syncthreads();

  // All threads read the same value, whoever got there last.

  output_data[tid] = my_element + trouble;


  /// Reasonable use of shared memory.
  //
  //  Share your array element with our neighbor.

  __shared__ int our_data[1024];

  our_data[threadIdx.x] = my_element;

  __syncthreads();

  output_data[tid] = my_element + our_data[threadIdx ^ 1];


}
#endif


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

void
cuda_init()
{
  GPU_Info gpu_info;

  gpu_info_print();

  // Choose GPU 0 because we don't have time to provide a way to let
  // the user choose.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  gpu_info.get_gpu_info(dev);

  gpu_info.GET_INFO(cuda_thread_start);

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
