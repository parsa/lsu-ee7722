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

inline double
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
  static const int max_kernels = 10;
  Kernel_Info ki[max_kernels];
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  int num_kernels;
};
#define GET_INFO(proc) get_info((Func)proc,#proc)

inline void
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

    const int cc_per_mp =
      cuda_prop.major == 1 ? 8 :
      cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 32 : 48 ) :
      cuda_prop.major == 3 ? 192 : 
      cuda_prop.major == 5 ? 128 : 0;

    const int dp_per_mp =
      cuda_prop.major == 1 ? 1 :
      cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 16 : 4 ) :
      cuda_prop.major == 3 ? ( cuda_prop.minor < 3 ? 8 : 64 ) :
      cuda_prop.major == 5 ? 1 : 0;

    const double mem_l2_gbs =
      2 * cuda_prop.memoryClockRate * 1000.0
      * ( cuda_prop.memoryBusWidth >> 3 )
      * 1e-9;

    printf
      ("GPU %d: L2: %d kiB   MEM<->L2: %.1f GB/s\n",
       dev,
       cuda_prop.l2CacheSize,
       mem_l2_gbs);

    const double sp_gflops = 
      cc_per_mp * cuda_prop.multiProcessorCount * cuda_prop.clockRate/1e6;

    const double dp_gflops = 
      dp_per_mp * cuda_prop.multiProcessorCount * cuda_prop.clockRate/1e6;

    printf
      ("GPU %d: CC: %d.%d  MP: %2d  CC/MP: %3d  DP/MP: %2d  TH/BL: %4d\n",
       dev, cuda_prop.major, cuda_prop.minor,
       cuda_prop.multiProcessorCount,
       cc_per_mp, dp_per_mp,
       cuda_prop.maxThreadsPerBlock);

    printf
      ("GPU %d: SHARED: %5d B  CONST: %5d B  # REGS: %5d\n",
       dev,
       int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
       cuda_prop.regsPerBlock
       );

    printf
      ("GPU %d: PEAK: %.0f SP GFLOPS  %.0f DP GFLOPS"
       "  COMP/COMM:  %.1f SP  %.1f DP\n",
       dev, 
       sp_gflops, dp_gflops,
       4 * sp_gflops / mem_l2_gbs,
       8 * dp_gflops / mem_l2_gbs);
  }

}


#endif
