#ifndef UTIL_H
#define UTIL_H

#include <gp/cuda-gpuinfo.h>

template<typename T> inline T min(T a, T b) { return b < a ? b : a; }

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}

#endif
