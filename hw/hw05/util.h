#ifndef UTIL_H
#define UTIL_H

#include <assert.h>


template<typename T> __attribute__((target(mic)))
inline T min(T a, T b) { return b < a ? b : a; }
template<typename T> __attribute__((target(mic)))
inline T max(T a, T b) { return b > a ? b : a; }

// Test for pthread return values.
#define CP(f) { const int rv=f; assert( rv == 0 ); }


__attribute__((target(mic)))
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

typedef void* (*Func)(void*);

// Info about a specific kernel.
//
struct Kernel_Info {
  Func func_ptr;
  //  void (*func_ptr)();           // Pointer to kernel function.
  const char *name;             // ASCII version of kernel name.
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
    num_kernels++;
  }

  double chip_bw_Bps, chip_sp_flops;
  int cc_per_mp;
  static const int max_kernels = 4;
  Kernel_Info ki[max_kernels];
  int num_kernels;
};
#define GET_INFO(proc) get_info((Func)proc,#proc)

#endif
