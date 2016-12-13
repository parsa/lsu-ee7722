/// LSU EE 4702-1 (Fall 2016), GPU Programming
//

 /// Code used in Final Exam problems 3 and 4.
 //
 //  See  http://www.ece.lsu.edu/koppel/gpup/2016/fe.pdf
 //
 //  Based on demo-cuda-02-basics.cu
 //
 //  Not runnable.

/// References
//
//  :ccpg8: CUDA C Programming Guide Version 8
//          https://docs.nvidia.com/cuda/cuda-c-programming-guide

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


struct App
{
  int num_threads;
  int array_size;

  float4 *h_in;         // Host address space, data in.
  float *h_out;         // Host address space, data out.
  float *h_out_check;   // Compute correct answer on CPU, to check GPU.

  float4 *d_in;         // Device address space, data in.
  float *d_out;         // Device address space, data out.
};

// In host address space.
App app;

// In device constant address space.
__constant__ App d_app;


///
/// GPU Code (Kernels)
///


__global__ void
kmain_simple()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;

  if ( tid >= d_app.num_threads ) return;

  const int elt_per_thread =
    ( d_app.array_size + d_app.num_threads - 1 ) / d_app.num_threads;
  const int start = elt_per_thread * tid;  // Bad: Non-consecutive access.
  const int stop = start + elt_per_thread;

  for ( int h=start; h<stop; h++ )
    {
      float4 p = d_app.d_in[h];  // Bad: Non-consecutive access.
      float sos = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
      d_app.d_out[h] = sos;
    }
}

float dot(float4 p, float4 q) { return p.x*q.x+p.y*q.y+p.z*q.z+p.w*q.w;}
float dot(float3 p, float3 q) { return p.x*q.x+p.y*q.y+p.z*q.z;}
float dot(float2 p, float2 q) { return p.x*q.x+p.y*q.y;}

__global__ void
kmain_efficient()
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_threads = blockDim.x * gridDim.x;

  for ( int h=tid; h<d_app.array_size; h += n_threads )
    {
      float4 p = d_app.d_in[h];
      d_app.d_out[h] = dot(p,p);
    }
}

__global__ void
prob_x(float2 *d_in, float *d_out)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_threads = blockDim.x * gridDim.x;

  for ( int h=tid; h<d_app.array_size-1; h += n_threads )
    {
      float2 p = d_in[h];
      float2 q = d_in[h+1];
      float dp = dot(p,q);
      d_out[h] = dp;
    }
}

__global__ void
prob_x2_sol(float2 *d_in, float *d_out)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_threads = blockDim.x * gridDim.x;

  __shared__ float3 sm[1024];

  for ( int h=tid; h<d_app.array_size; h += n_threads )
    {
      float2 p = d_in[h];
      __syncthreads();
      sm[threadIdx.x] = p;
      __syncthreads();
      float2 q = sm[threadIdx.x+1];
      float dp = dot(p,q);
      d_out[h] = dp;
    }
}

__global__ void
prob_x2(float2 *d_in, float *d_out)
{
  const int tid = threadIdx.x + blockIdx.x * blockDim.x;
  const int n_threads = blockDim.x * gridDim.x;

  __shared__ float3 sm[1024];

  for ( int h=tid; h<d_app.array_size; h += n_threads )
    {
      float2 p = d_in[h];


      float2 q = d_in[h+1];

      float dp = dot(p,q);
      d_out[h] = dp;
    }
}

__global__ void
prob_x3(float3 *d_in, float *d_out)
{
  const int tid = threadIdx.x + blockIdx.x * ( blockDim.x - 1 );
  const int n_threads = blockDim.x * gridDim.x;
  const bool last_thd = threadIdx.x == blockDim.x - 1;

  __shared__ float3 sm[1024];

  for ( int h=tid; h<d_app.array_size-1; h += n_threads )
    {
      float3 p = d_in[h];
      __syncthreads();
      sm[threadIdx.x] = p;
      __syncthreads();
      if ( last_thd ) continue;
      float3 q = sm[threadIdx.x+1];
      float dp = dot(p,q);
      d_out[h] = dp;
    }
}


GPU_Info
print_gpu_and_kernel_info()
{
  GPU_Info info;

  gpu_info_print();

  // Choose GPU 0 because it's usually the better choice.
  //
  int dev = 0;
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);
  info.get_gpu_info(dev);

  info.GET_INFO(kmain_simple);
  info.GET_INFO(kmain_efficient);
  info.GET_INFO(kmain_tuned);

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


