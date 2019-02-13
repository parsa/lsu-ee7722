#ifndef MICROBENCHMARKS_UTIL_H
#define MICROBENCHMARKS_UTIL_H

#include <gp/cuda-gpuinfo.h>

#ifdef __NVCC__
#if __CUDACC_VER_MAJOR__ < 9
#define __shfl_xor_sync(mask,ref,bits) __shfl_xor(ref,((mask)*0)+bits)
#endif
#endif

template<typename T> inline T min(T a, T b) { return b < a ? b : a; }

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}

#endif
