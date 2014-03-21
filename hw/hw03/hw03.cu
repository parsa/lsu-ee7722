/// LSU EE 7722 (Spring 2014), GPU Microarchitecture
//

 /// Homework 3 (Spring 2014)
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gp/2014/hw03.pdf
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


struct App_Common
{
  int length;
  int num_pieces;
  int idx_array_elts;
  int data_array_elts;
  int *idx_array;
  float *data_array;
  float *sum_array;
  float *sum_array_check;

  int *d_idx_array;
  float *d_data_array;
  float *d_sum_array;
};


// In host address space.
App_Common app;

// In device constant address space.
__constant__ App_Common dapp;


const int clength = 8;

extern "C" __global__ void
sums_0()
{
  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int piece = tid; piece < dapp.num_pieces; piece += thread_count )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += dapp.d_data_array[dapp.d_idx_array[idx_piece_start+i]];

      dapp.d_sum_array[piece] = sum;
    }
}

extern "C" __global__ void
sums_1()
{
  // PROBLEM 2 SOLUTION HERE.
  // Reduce noncontiguous access to dapp.d_idx_array.

  return;

  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int piece = tid; piece < dapp.num_pieces; piece += thread_count )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += dapp.d_data_array[dapp.d_idx_array[idx_piece_start+i]];

      dapp.d_sum_array[piece] = sum;
    }
}

extern "C" __global__ void
sums_2()
{
  // PROBLEM 3 SOLUTION HERE.
  // Reduce noncontiguous access to dapp.d_data_array using shared memory.

  return;


  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int piece = tid; piece < dapp.num_pieces; piece += thread_count )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += dapp.d_data_array[dapp.d_idx_array[idx_piece_start+i]];

      dapp.d_sum_array[piece] = sum;
    }
}

GPU_Info
print_gpu_info()
{
  GPU_Info info;

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  CE( cudaGetDeviceCount(&device_count) ); // Get number of GPUs.
  if ( device_count == 0 )
    {
      fprintf(stderr,"No GPU found, exiting.\n");
      exit(1);
    }

  /// Print information about the available GPUs.
  //
  for ( int dev=0; dev<device_count; dev++ )
    {
      info.get_gpu_info(dev);  // Look in file util.h.
      cudaDeviceProp& cuda_prop = info.cuda_prop;

      printf
        ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
         dev, cuda_prop.name, cuda_prop.clockRate/1e6,
         int(cuda_prop.totalGlobalMem >> 20));

      printf
        ("GPU %d: CC: %d.%d  MP: %2d  CC/MP: %3d  TH/BL: %4d\n",
         dev, cuda_prop.major, cuda_prop.minor,
         cuda_prop.multiProcessorCount,
         info.cc_per_mp,
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
         info.chip_bw_Bps * 1e-9,
         info.chip_sp_flops * 1e-9,
         4 * info.chip_sp_flops / info.chip_bw_Bps);
    }

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(sums_0);
  info.GET_INFO(sums_1);
  info.GET_INFO(sums_2);

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
  // Get info about GPU and each kernel.
  //
  GPU_Info info = print_gpu_info();

  // Examine argument 1, grid size.
  //
  const int arg1_int =
    argc < 2 ? info.cuda_prop.multiProcessorCount : atoi(argv[1]);
  const int num_blocks = abs(arg1_int);

  // Examine argument 2, number of pieces. Fractional values okay.
  //
  app.num_pieces = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );

  if ( num_blocks <= 0 || app.num_pieces <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [NUMBER OF PIECES]\n",
             argv[0]);
      exit(1);
    }

  app.length = clength;
  app.idx_array_elts = app.num_pieces * app.length;
  app.data_array_elts = 1 << 14;

  const int idx_array_bytes = app.idx_array_elts * sizeof(app.idx_array[0]);
  const int data_array_bytes = app.data_array_elts * sizeof(app.data_array[0]);
  const int sum_array_bytes = app.num_pieces * sizeof(app.sum_array[0]);

  // Allocate storage for CPU copy of data.
  //
  app.idx_array = new int[idx_array_bytes];
  app.data_array = new float[data_array_bytes];
  app.sum_array = new float[sum_array_bytes];
  app.sum_array_check = new float[sum_array_bytes];

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_idx_array, idx_array_bytes ) );
  CE( cudaMalloc( &app.d_data_array, data_array_bytes ) );
  CE( cudaMalloc( &app.d_sum_array, sum_array_bytes ) );

  printf("\nData array size %d elements, index array size %d elements.\n",
         app.data_array_elts, app.idx_array_elts);

  // Initialize input array.
  //
  for ( int i=0; i<app.data_array_elts; i++ )
    {
      app.data_array[i] = drand48();
    }

  for ( int i=0; i<app.idx_array_elts; i++ )
    {
      app.idx_array[i] = random() % app.data_array_elts;
    }

  // Compute correct answer (for checking).
  //
  for ( int p=0; p<app.num_pieces; p++ )
    {
      float sum = 0;
      int idx_base = p * app.length;
      for ( int i=0; i<app.length; i++ )
        sum += app.data_array[app.idx_array[idx_base+i]];
      app.sum_array_check[p] = sum;
    }

  // Prepare events used for timing.
  //
  cudaEvent_t gpu_start_ce, gpu_stop_ce;
  CE(cudaEventCreate(&gpu_start_ce));
  CE(cudaEventCreate(&gpu_stop_ce));

  // Copy input array from CPU to GPU.
  //
  CE( cudaMemcpy( app.d_idx_array, app.idx_array, idx_array_bytes,
                  cudaMemcpyHostToDevice ) );
  CE( cudaMemcpy( app.d_data_array, app.data_array, data_array_bytes,
                  cudaMemcpyHostToDevice ) );

  const double data_size =
    idx_array_bytes * data_array_bytes + sum_array_bytes;

  // Stuff needed to print bar graph.
  //
  const int full_width = 49;  // Width of longest bar.
  char **stars = (char**) alloca( info.num_kernels * sizeof(void*) );
  for ( int j=0; j< info.num_kernels; j++ )
    {
      stars[j] = (char*) alloca(full_width+1);
      for ( int i=0; i<full_width; i++ ) stars[j][i] = '0' + j;
      stars[j][full_width] = 0;
    }

  for ( int kernel = 0; kernel < info.num_kernels; kernel++ )
    {
      cudaFuncAttributes& cfa = info.ki[kernel].cfa;

      if ( kernel > 0 && cfa.numRegs < 3 )
        {
          printf("Not running kernel %s because code probably not present.\n",
                info.ki[kernel].name);
          continue;
        }

      // Maximum number of warps per block that this GPU can handle
      // for this kernel.
      //
      const int wp_limit = cfa.maxThreadsPerBlock >> 5;

      printf("\nRunning kernel %s which uses %d regs on %d blocks.\n",
             info.ki[kernel].name, cfa.numRegs, num_blocks);

      printf(" %3s %9s  %6s  %5s\n", "Num", "Time", "Data", "" );
      printf(" %3s %9s  %6s  %5s\n", "Wps", "µs", " GB/s", "Pct" );

      for ( int warp_cnt = 2; warp_cnt <= wp_limit; warp_cnt += 2 )
        {
          const int thd_per_block = warp_cnt << 5;

          // Copy App structure to GPU.
          //
          CE( cudaMemcpyToSymbol
              ( dapp, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

          // Zero result array (to catch errors when kernel skips elements).
          //
          CE( cudaMemset( app.d_sum_array, 0, sum_array_bytes ) );

          // Measure execution time starting "now", which is after data
          // set to GPU.
          //
          CE(cudaEventRecord(gpu_start_ce,0));

          // Launch Kernel
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
              (app.sum_array, app.d_sum_array, sum_array_bytes,
               cudaMemcpyDeviceToHost) );

          int err = 0;
          for ( int e=0; e<app.num_pieces; e++ )
            {
              const float diff =
                fabs( app.sum_array[e] - app.sum_array_check[e] );
              if ( diff > 0.00001 )
                {
                  err++;
                  if ( err < 2 )
                    printf
                      ("Error at array idx %d: %f != %f (correct)\n",
                       e, app.sum_array[e], app.sum_array_check[e]);
                }
            }

          const double frac = data_size / elapsed_time_s / info.chip_bw_Bps;
          const int s_idx = max(0.0,full_width * ( 1 - frac ));

          printf(" %2d  %9.3f  %6.2f %5.1f%%  %s\n",
                 warp_cnt, 1e6 * elapsed_time_s,
                 1e-9 * data_size / elapsed_time_s,
                 100 * frac, &stars[kernel][s_idx] );
        }
    }
}
