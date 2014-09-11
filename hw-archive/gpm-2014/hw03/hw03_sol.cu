/// LSU EE 7722 (Spring 2014), GPU Microarchitecture
//

 /// Homework 3 (Spring 2014)  SOLUTION
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
  int4 *d_idx_array4;   /// SOLUTION Problem 2
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
  /// PROBLEM 2 SOLUTION
  //  Use type punning so that idx_array accessed using vector loads.

  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  for ( int piece = tid; piece < dapp.num_pieces; piece += thread_count )
    {
      const int idx_piece4_start = piece * clength / 4;
      float sum = 0;
      for ( int i=0; i<clength/4; i++ )
        {
          int4 indices = dapp.d_idx_array4[idx_piece4_start+i];
          sum += dapp.d_data_array[indices.x];
          sum += dapp.d_data_array[indices.y];
          sum += dapp.d_data_array[indices.z];
          sum += dapp.d_data_array[indices.w];
        }

      dapp.d_sum_array[piece] = sum;
    }
}

extern "C" __global__ void
sums_2()
{
  /// PROBLEM 3 SOLUTION
  //  Reduce noncontiguous access to dapp.d_data_array using shared memory.

  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  const int dcache_elts = ( 1 << 15 ) >> 2;
  const int nrounds = ( dapp.data_array_elts + dcache_elts -1 ) / dcache_elts;

  for ( int round = 0; round < nrounds; round++ )
    {
      __shared__ float dcache[dcache_elts];
      const int chunk_start = round * dcache_elts;
      if ( round != 0 ) __syncthreads();
      for ( int sdidx = threadIdx.x; sdidx < dcache_elts; sdidx += blockDim.x )
        dcache[sdidx] = dapp.d_data_array[chunk_start + sdidx];
      __syncthreads();

      for ( int piece = tid; piece < dapp.num_pieces; piece += thread_count )
        {
          const int idx_piece_start = piece * clength;
          float sum = 0;
          for ( int i=0; i<clength; i++ )
            {
              const int didx = dapp.d_idx_array[idx_piece_start+i];
              const unsigned int sidx = didx - chunk_start;
              if ( sidx < dcache_elts ) sum += dcache[sidx];
            }
          if ( round == 0 )
            dapp.d_sum_array[piece] = sum;
          else
            dapp.d_sum_array[piece] += sum;
        }
    }
}

extern "C" __global__ void
sums_3()
{
  const int thread_count = blockDim.x * gridDim.x;
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  const int dcache_elts = ( 1 << 15 ) >> 2;
  const int nrounds = ( dapp.data_array_elts + dcache_elts -1 ) / dcache_elts;
  __shared__ float dcache[dcache_elts];

  const int ppi = 4;
  const int work_per_iter = thread_count * ppi;
  const int max_iters = ( dapp.num_pieces + work_per_iter - 1 ) / work_per_iter;

  const int lidx_size = ppi * clength;

  for ( int p = 0;  p < max_iters;  p++ )
    {
      const int piece_start = tid * ppi + p * work_per_iter;
      const int idx_piece_start = piece_start * clength;

      int4 l4[ lidx_size / 4 ];
      float sums[ ppi ];
      for ( int i=0; i<lidx_size; i += 4 )
        l4[ i/4 ] = *(int4*)&dapp.d_idx_array[idx_piece_start+i];
      int *lidx = (int*)l4;

      for ( int i=0; i<ppi; i++ ) sums[i] = 0;

      for ( int round = 0; round <nrounds; round++ )
        {
          const int chunk_start = round * dcache_elts;
          __syncthreads();
          for ( int sdidx = threadIdx.x; sdidx < dcache_elts;
                sdidx += blockDim.x )
            dcache[sdidx] = dapp.d_data_array[chunk_start + sdidx];
          __syncthreads();

          for ( int j=0; j<ppi; j++ )
            {
              float sum = 0;
              for ( int i=0; i<clength; i++ )
                {
                  const int didx = lidx[ j*clength + i ];
                  const unsigned int sidx = didx - chunk_start;
                  if ( sidx < dcache_elts ) sum += dcache[sidx];
                }
              sums[j] += sum;
            }
        }
      for ( int j=0; j<ppi; j++ )
        {
          const int piece = piece_start + j;
          if ( piece < dapp.num_pieces ) dapp.d_sum_array[piece] = sums[j];
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

  info.GET_INFO(sums_0);
  info.GET_INFO(sums_1);
  info.GET_INFO(sums_2);
  info.GET_INFO(sums_3);

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

  /// SOLUTION  -  Problem 2
  app.d_idx_array4 = (int4*)app.d_idx_array;

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

  /// SOLUTION Problem 1

  const int idx_array_elts = app.idx_array_elts;

  // Amount of data transferred if all elts in a request are used.
  // For sum_0 and sum_1 only some elts are used, so this ideal
  // amount is not the answer to Problem 1.
  //
  const double __attribute__((unused)) data_size_ideal =
    idx_array_bytes + idx_array_elts * sizeof(app.data_array[0])
    + sum_array_bytes;

  const bool have_l1_cache = info.cuda_prop.major == 2;
  const int l1_cache_size = 3 << 14;

  // Compute the probability that an access to a data array element
  // hits the cache (after the cache has warmed up). This is easy to
  // compute because elements are accessed randomly.
  //
  const double warm_hit_ratio = 
    min( 1.0, double(l1_cache_size) / data_array_bytes );

  const int req_size = 32;
  const int line_size = 128;

  // Compute the amount of data accessed assuming that idx_array_elts
  // is large and that data_array_elts is much larger than 32 (the
  // warp size). Each index array element is read once (this is
  // certainly true for sums_1 and is true for sums_0 if the cache
  // cooperates). Each sum_array element is written once. The data
  // array is accessed idx_array_elts times. Using the cache hit ratio
  // and the line size one can find the amount of data transferred. If
  // there is no L1 cache then assume that every accesses brings in a
  // 32-byte request.
  //
  const double data_size_sums_0 =
    have_l1_cache 
    ? ( idx_array_bytes 
        + idx_array_elts * line_size * ( 1 - warm_hit_ratio )
        + sum_array_bytes
        )
    : ( idx_array_bytes + idx_array_elts * req_size + sum_array_bytes );

  // Amount of data when data_array cached.
  //
  const int elt_per_round = ( 1 << 15 ) / sizeof(app.data_array[0]);
  const int rounds = ( app.data_array_elts + elt_per_round -1 ) / elt_per_round;
  const double data_size_sums_2 =
    rounds * idx_array_bytes + data_array_bytes + sum_array_bytes;

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

          const double data_size = 
            kernel < 2 ? data_size_sums_0 : data_size_sums_2;

          const double frac = data_size / elapsed_time_s / info.chip_bw_Bps;
          const int s_idx = max(0.0,full_width * ( 1 - frac ));

          printf(" %2d  %9.3f  %6.2f %5.1f%%  %s\n",
                 warp_cnt, 1e6 * elapsed_time_s,
                 1e-9 * data_size / elapsed_time_s,
                 100 * frac, &stars[kernel][s_idx] );
        }
    }
}
