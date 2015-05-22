#ifndef UTIL_H
#define UTIL_H

template<typename T> inline T min(T a, T b) { return b < a ? b : a; }

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

//
// Collect GPU and Kernel Info
//

typedef void (*Func)();

// Info about a specific kernel.
//
struct Kernel_Info {
  void (*func_ptr)();           // Pointer to kernel function.
  const char *name;             // ASCII version of kernel name.
  cudaFuncAttributes cfa;       // Kernel attributes reported by CUDA.
};

// Info about GPU and each kernel.
//
class GPU_Info {
public:
  GPU_Info() { num_kernels = 0; }
  void get_info( Func k_ptr, const char *k_name)
  {
    ki[num_kernels].name = k_name;
    ki[num_kernels].func_ptr = k_ptr;
    CE( cudaFuncGetAttributes(&ki[num_kernels].cfa,k_ptr) );
    num_kernels++;
  }
  void get_gpu_info(int dev)
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      cc_per_mp =
        cuda_prop.major == 1 ? 8 :
        cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 32 : 48 ) :
        cuda_prop.major == 3 ? 192 : 0;

      chip_bw_Bps =
        2 * cuda_prop.memoryClockRate * 1000.0
        * ( cuda_prop.memoryBusWidth >> 3 );
      chip_sp_flops =
        1000.0 * cc_per_mp * cuda_prop.clockRate
        * cuda_prop.multiProcessorCount;
    }

  double chip_bw_Bps, chip_sp_flops;
  int cc_per_mp;
  static const int max_kernels = 4;
  Kernel_Info ki[max_kernels];
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  int num_kernels;
};
#define GET_INFO(proc) get_info((Func)proc,#proc)

#endif
