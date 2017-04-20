/// LSU EE 4702-X / EE 7722   -*- c++ -*-
//
 /// Code for printing info about GPU and collecting info about CUDA kernels.

#ifndef CUDA_GPUINFO_H
#define CUDA_GPUINFO_H

#include <stdio.h>
#include <cuda.h>
#include <cuda_runtime.h>
#include <string.h>
#include <nvml.h>
#include <map>
#include <vector>


 /// CUDA Runtime API Error-Checking Wrapper
///
#ifndef CE
#define CE(call)                                                              \
 {                                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess )                                                   \
     {                                                                        \
       printf("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));               \
       exit(1);                                                               \
     }                                                                        \
 }
#endif

 /// CUDA Device API Error Checking Wrapper
#define CD(rv)                                                                \
 {                                                                            \
   const CUresult result = rv;                                                \
   const char* err_str = NULL;                                                \
   cuGetErrorString(result,&err_str);                                         \
   if ( result != CUDA_SUCCESS )                                              \
     {                                                                        \
       fprintf                                                                \
         (stderr,                                                             \
          "Error %d for CUDA Driver API call: %s\n",                          \
          result, err_str ?: "Could not find error description." );           \
       exit(1);                                                               \
     }}

 /// CUDA Device management API Error Checking Wrapper
#define CM(rv)                                                                \
 ({                                                                           \
   const nvmlReturn_t result = rv;                                            \
   const char* const err_str = nvmlErrorString(result);                       \
   if ( result != NVML_SUCCESS && result != NVML_ERROR_NOT_SUPPORTED )        \
     {                                                                        \
       fprintf                                                                \
         (stderr,                                                             \
          "Error %d for CUDA Management API call: %s\n",                      \
          result, err_str ?: "Could not find error description." );           \
       exit(1);                                                               \
     } result; } )

struct GPU_Choose_Info {
  CUdevice cuda_device;
  int cuda_device_index;
  int cc_major, cc_minor;
  int cuda_version;
  bool display_absent;
};

inline GPU_Choose_Info
gpu_choose(bool verbose)
{
  // Note: Avoid using cuda RT API since that is sensitive to
  // build-time / run-time version number mismatches.

  CM( nvmlInit() );
  CD( cuInit(0) );

  typedef std::pair<int,int> Bus_Dev;
  std::map< Bus_Dev, nvmlDevice_t > pci_to_mlhandle;

  uint n_device_count = 0;
  CM( nvmlDeviceGetCount(&n_device_count) );

  for ( uint dev = 0; dev < n_device_count; dev++ )
    {
      nvmlDevice_t handle;
      CM( nvmlDeviceGetHandleByIndex(dev,&handle) );
      nvmlPciInfo_t pci;
      CM( nvmlDeviceGetPciInfo(handle,&pci) );
      pci_to_mlhandle[Bus_Dev(pci.bus,pci.device)] = handle;
    }

  int device_count;
  CD( cuDeviceGetCount(&device_count) );

  GPU_Choose_Info info_best;
  info_best.cuda_device_index = -1;

  for ( int dev = 0; dev < device_count; dev ++ )
    {
      GPU_Choose_Info info;  info.cuda_device_index = dev;
      int pci_bus_id = -1;
      CD( cuDeviceGetAttribute
          (&pci_bus_id,CU_DEVICE_ATTRIBUTE_PCI_BUS_ID,dev) );
      int pci_dev_id = -1;
      CD( cuDeviceGetAttribute
          (&pci_dev_id,CU_DEVICE_ATTRIBUTE_PCI_DEVICE_ID,dev) );
      CD( cuDeviceGetAttribute
          (&info.cc_major,CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MAJOR,dev) );
      CD( cuDeviceGetAttribute
          (&info.cc_minor,CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MINOR,dev) );

      nvmlDevice_t handle = pci_to_mlhandle[Bus_Dev(pci_bus_id,pci_dev_id)];
      char nvml_gpu_name[NVML_DEVICE_NAME_BUFFER_SIZE];
      CM( nvmlDeviceGetName(handle,nvml_gpu_name, sizeof(nvml_gpu_name)-1) );

      CD( cuDeviceGet(&info.cuda_device,dev) );

      nvmlPciInfo_t pci;
      CM( nvmlDeviceGetPciInfo(handle,&pci) );

      char gpu_name[100];
      CD( cuDeviceGetName(gpu_name,sizeof(gpu_name),info.cuda_device) );

      nvmlEnableState_t display_mode;
      const nvmlReturn_t dm_rv =
        CM( nvmlDeviceGetDisplayMode(handle,&display_mode) );

      nvmlEnableState_t is_active;
      const nvmlReturn_t ia_rv =
        CM( nvmlDeviceGetDisplayActive(handle,&is_active) );

      info.display_absent =
        ia_rv == NVML_SUCCESS && is_active == NVML_FEATURE_DISABLED;

      info.cuda_version = CUDA_VERSION;

      if ( info_best.cuda_device_index < 0
           || !info_best.display_absent
           || info_best.cc_major < info.cc_major
           || info_best.cc_major == info.cc_major
           && info_best.cc_minor < info.cc_minor )
        {
          info_best = info;
          if ( verbose ) printf("Best updated to:\n");
        }

      if ( !verbose ) continue;

      printf ("CUDA name: %s  bus %x  dev %x  CC %d.%d\n",
              gpu_name,pci_bus_id,pci_dev_id, info.cc_major, info.cc_minor);
      printf ("NVML name: %s  busID %s  Domain %x  Active %s  Mode %s\n",
              nvml_gpu_name, pci.busId, pci.domain,
              ia_rv == NVML_ERROR_NOT_SUPPORTED ? "ns " :
              is_active == NVML_FEATURE_DISABLED ? "dis" :
              is_active == NVML_FEATURE_ENABLED ? "ena" : "???",
              dm_rv == NVML_ERROR_NOT_SUPPORTED ? "ns " :
              display_mode == NVML_FEATURE_DISABLED ? "dis" :
              display_mode == NVML_FEATURE_ENABLED ? "ena" : "???");
    }

  CM( nvmlShutdown() );

  return info_best;
}

inline int gpu_choose_index(){ return gpu_choose(false).cuda_device_index; }

//
// Collect GPU and Kernel Info
//

typedef void (*GPU_Info_Func)();

// Info about a specific kernel.
//
struct Kernel_Info {
  GPU_Info_Func func_ptr;       // Pointer to kernel function.
  const char *name;             // ASCII version of kernel name.
  cudaFuncAttributes cfa;       // Kernel attributes reported by CUDA.
  bool (*block_size_okay_user_func)(int block_size);
  bool block_size_okay(int block_size)
    {
      if ( cfa.maxThreadsPerBlock < block_size ) return false;
      if ( block_size_okay_user_func )
        return block_size_okay_user_func(block_size);
      return true;
    }
};

// Info about GPU and each kernel.
//
class GPU_Info {
public:
  GPU_Info() { num_kernels = 0; }
  GPU_Info(int dev) { num_kernels = 0; get_gpu_info(dev); }
  Kernel_Info& get_info(GPU_Info_Func k_ptr, const char *k_name)
  {
    ki.push_back(Kernel_Info());
    ki[num_kernels].name = k_name;
    ki[num_kernels].func_ptr = k_ptr;
    ki[num_kernels].block_size_okay_user_func = NULL;
    CE( cudaFuncGetAttributes(&ki[num_kernels].cfa,(void*)k_ptr) );
    return ki[num_kernels++];
  }
  void get_gpu_info(int dev)
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      cc_per_mp =
        cuda_prop.major == 1 ? 8 :
        cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 32 : 48 ) :
        cuda_prop.major == 3 ? 192 :
        cuda_prop.major == 5 ? 128 :
        cuda_prop.major == 6 ? ( cuda_prop.minor == 0 ? 64 : 128 ) : 0;

      const bool is_geforce = strncmp("GeForce",cuda_prop.name,7) == 0;

      dp_per_mp =
        cuda_prop.major == 1 ? 1 :
        cuda_prop.major == 2 ? ( cuda_prop.minor == 0 ? 16 : 4 ) :
        cuda_prop.major == 3 ? ( cuda_prop.minor < 3 || is_geforce ? 8 : 64 ) :
        cuda_prop.major == 5 ? 4 :
        cuda_prop.major == 6 ? ( cuda_prop.minor == 0 ? 32 : 4 ) : 0;

      chip_bw_Bps =
        2 * cuda_prop.memoryClockRate * 1000.0
        * ( cuda_prop.memoryBusWidth >> 3 );
      chip_sp_flops =
        1000.0 * cc_per_mp * cuda_prop.clockRate
        * cuda_prop.multiProcessorCount;
      chip_dp_flops =
        1000.0 * dp_per_mp * cuda_prop.clockRate
        * cuda_prop.multiProcessorCount;
    }

  int get_max_active_blocks_per_mp
  (int knum, int block_size, int dynamic_shared_memory_bytes = 0)
    {
      int num_blocks = -1;
      CE( cudaOccupancyMaxActiveBlocksPerMultiprocessor
          (&num_blocks, (void*)ki[knum].func_ptr, block_size,
           dynamic_shared_memory_bytes) );
      return num_blocks;
    }

  double chip_bw_Bps;
  double chip_sp_flops; // MADD counted as 1 FLOP.
  double chip_dp_flops; // MADD counted as 1 FLOP.
  int cc_per_mp, dp_per_mp;
  std::vector<Kernel_Info> ki;
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  int num_kernels;
};
#define GET_INFO(proc) get_info((GPU_Info_Func)proc,#proc)

inline void
gpu_info_print()
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


  /// Print information about the available GPUs.
  //
  for ( int dev = 0; dev < device_count; dev++ )
  {
    GPU_Info gpu_info(dev);
    cudaDeviceProp& cuda_prop = gpu_info.cuda_prop;

    printf
      ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
       dev, cuda_prop.name, cuda_prop.clockRate/1e6,
       int(cuda_prop.totalGlobalMem >> 20));

    const int cc_per_mp = gpu_info.cc_per_mp;
    const int dp_per_mp = gpu_info.dp_per_mp;
    const double mem_l2_gbs = gpu_info.chip_bw_Bps * 1e-9;

    printf
      ("GPU %d: L2: %d kiB   MEM<->L2: %.1f GB/s\n",
       dev,
       cuda_prop.l2CacheSize >> 10,
       mem_l2_gbs);

    const double sp_gflops =
      cc_per_mp * cuda_prop.multiProcessorCount * (cuda_prop.clockRate/1e6);

    const double dp_gflops =
      dp_per_mp * cuda_prop.multiProcessorCount * (cuda_prop.clockRate/1e6);

    printf
      ("GPU %d: CC: %d.%d  MP: %2d  CC/MP: %3d  DP/MP: %2d  TH/BL: %4d\n",
       dev, cuda_prop.major, cuda_prop.minor,
       cuda_prop.multiProcessorCount,
       cc_per_mp, dp_per_mp,
       cuda_prop.maxThreadsPerBlock);

    printf
      ("GPU %d: SHARED: %5d B/BL  %5d B/MP  CONST: %5d B  # REGS: %5d\n",
       dev,
       int(cuda_prop.sharedMemPerBlock),
       int(cuda_prop.sharedMemPerMultiprocessor),
       int(cuda_prop.totalConstMem),
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
