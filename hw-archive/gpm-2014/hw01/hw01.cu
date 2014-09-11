/// LSU EE 7722 (Spring 2014), GPU Microarchitecture
//

 /// Homework 1 and 2  (Spring 2014)
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gp/2014/hw01.pdf
 //                and http://www.ece.lsu.edu/koppel/gp/2014/hw02.pdf
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


// The unroll degree is used by kernels dots_iterate1 and dots_iterate2.
//
const int unroll_degree = 8;

struct App_Common
{
  float2 *a;
  float *b;
  float *b_check;

  float2 *d_a;
  float *d_b;

  float v0, v1, v2;
  int array_size;
  int num_threads;
};


// In host address space.
App_Common app;

// In device constant address space.
__constant__ App_Common dapp;



extern "C" __global__ void
dots_iterate0()
{
  const int thread_count = blockDim.x * gridDim.x;
  const int idx_start = threadIdx.x + blockIdx.x * blockDim.x;

  // For convenience, assign to local variables.
  float2* const a = dapp.d_a;
  float* const b = dapp.d_b;

  for ( int idx = idx_start; idx < dapp.array_size; idx += thread_count )
    b[idx] = dapp.v0 + dapp.v1 * a[idx].x + dapp.v2 * a[idx].y;

}


extern "C" __global__ void
dots_iterate1()
{
  const int thread_count = blockDim.x * gridDim.x;
  const int idx_start = threadIdx.x + blockIdx.x * blockDim.x;

  // For convenience, assign to local variables.
  float2* const a = dapp.d_a;
  float* const b = dapp.d_b;

  for ( int idx = idx_start; idx < dapp.array_size;
        idx += unroll_degree * thread_count )
    {
      float keep[unroll_degree];
      for ( int i=0; i<unroll_degree; i++ )
        {
          const int idx2 = idx + i * thread_count;
          if ( idx2 < dapp.array_size )
            keep[i] = dapp.v0 + dapp.v1 * a[idx2].x + dapp.v2 * a[idx2].y;
        }
      for ( int i=0; i<unroll_degree; i++ )
        {
          const int idx2 = idx + i * thread_count;
          if ( idx2 < dapp.array_size )
            b[idx2] = keep[i];
        }
    }
}

extern "C" __global__ void
dots_iterate2()
{
  /// Modify this routine for Homework 2.
  //
  //  Start your solution by removing the return statement below.

  return;

  const int thread_count = blockDim.x * gridDim.x;
  const int idx_start = threadIdx.x + blockIdx.x * blockDim.x;

  // For convenience, assign to local variables.
  float2* const a = dapp.d_a;
  float* const b = dapp.d_b;

  for ( int idx = idx_start; idx < dapp.array_size;
        idx += unroll_degree * thread_count )
    {
      float keep[unroll_degree];
      for ( int i=0; i<unroll_degree; i++ )
        {
          const int idx2 = idx + i * thread_count;
          if ( idx2 < dapp.array_size )
            keep[i] = dapp.v0 + dapp.v1 * a[idx2].x + dapp.v2 * a[idx2].y;
        }
      for ( int i=0; i<unroll_degree; i++ )
        {
          const int idx2 = idx + i * thread_count;
          if ( idx2 < dapp.array_size )
            b[idx2] = keep[i];
        }
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

  info.GET_INFO(dots_iterate0);
  info.GET_INFO(dots_iterate1);
  info.GET_INFO(dots_iterate2);

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

   // Examine argument 2, size of array in MiB. Fractional values okay.
  //
  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );

  if ( num_blocks <= 0 || app.array_size <= 0 )
    {
      printf("Usage: %s [ NUM_CUDA_BLOCKS ] [DATA_SIZE_MiB]\n",
             argv[0]);
      exit(1);
    }

  const int a_size_bytes = app.array_size * sizeof(app.a[0]);
  const int b_size_bytes = app.array_size * sizeof(app.b[0]);

  // Allocate storage for CPU copy of data.
  //
  app.a = new float2[app.array_size];
  app.b = new float[app.array_size];
  app.b_check = new float[app.array_size];
  const int overrun_size = 256;

  // Allocate storage for GPU copy of data.
  //
  CE( cudaMalloc( &app.d_a, (app.array_size+overrun_size)*sizeof(app.a[0]) ) );
  CE( cudaMalloc( &app.d_b, (app.array_size+overrun_size)*sizeof(app.b[0]) ) );

  printf
    ("\nPreparing for %d blocks operating on %d elements. Unroll degree: %d.\n",
     num_blocks, app.array_size, unroll_degree);

  // Initialize input array.
  //
  for ( int i=0; i<app.array_size; i++ )
    {
      app.a[i].x = drand48();
      app.a[i].y = drand48();
    }

  // Initialize Coefficients
  //
  app.v0 = drand48();
  app.v1 = drand48();
  app.v2 = drand48();

  // Compute correct answer (for checking).
  //
  for ( int e=0; e<app.array_size; e++ )
    app.b_check[e] = app.v0 + app.v1 * app.a[e].x + app.v2 * app.a[e].y;

  // Prepare events used for timing.
  //
  cudaEvent_t gpu_start_ce, gpu_stop_ce;
  CE(cudaEventCreate(&gpu_start_ce));
  CE(cudaEventCreate(&gpu_stop_ce));

  // Copy input array from CPU to GPU.
  //
  CE( cudaMemcpy( app.d_a, app.a, a_size_bytes, cudaMemcpyHostToDevice ) );

  const double data_size =
    app.array_size * ( sizeof(app.a[0]) + sizeof(app.b[0]) );

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

      if ( kernel == 2 && cfa.numRegs < 3 )
        {
          printf("Not running kernel %s because code probably not present.\n",
                info.ki[kernel].name);
          continue;
        }

      // Maximum number of warps per block that this GPU can handle
      // for this kernel.
      //
      const int wp_limit = cfa.maxThreadsPerBlock >> 5;

      printf("\nRunning kernel %s which uses %d regs on %d blocks.",
             info.ki[kernel].name, cfa.numRegs, num_blocks);
      if ( kernel )
        printf("  Unroll degree %d\n", unroll_degree);
      else
        printf("\n");

      printf(" %3s %9s  %6s  %5s\n", "Num", "Time", "Data", "" );
      printf(" %3s %9s  %6s  %5s\n", "Wps", "µs", " GB/s", "Pct" );

      for ( int warp_cnt = 1; warp_cnt <= wp_limit; warp_cnt++ )
        {
          const int thd_per_block = warp_cnt << 5;
          app.num_threads = num_blocks * thd_per_block;

          // Copy App structure to GPU.
          //
          CE( cudaMemcpyToSymbol
              ( dapp, &app, sizeof(app), 0, cudaMemcpyHostToDevice ) );

          // Zero result array (to catch errors when kernel skips elements).
          //
          CE( cudaMemset( app.d_b, 0, b_size_bytes ) );

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
              (app.b, app.d_b, b_size_bytes, cudaMemcpyDeviceToHost) );

          int err = 0;
          for ( int e=0; e<app.array_size; e++ )
            {
              const float diff = fabs( app.b[e] - app.b_check[e] );
              if ( diff > 0.00001 )
                {
                  err++;
                  if ( err < 2 )
                    printf
                      ("Error at array idx %d: %f != %f (correct)\n",
                       e, app.b[e], app.b_check[e]);
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
