#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>
#include <initializer_list>
#include <vector>
#include <algorithm>
using namespace std;

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}


extern "C" void
dots
(int size, double* __restrict__ ax, double* __restrict__ ay,
 double v0, double v1, double v2, double* __restrict__ b, int nthreads)
{
  b = (double*) __builtin_assume_aligned(b,32);
  ax = (double*) __builtin_assume_aligned(ax,32);
  ay = (double*) __builtin_assume_aligned(ay,32);

#pragma omp parallel for num_threads(nthreads)
  for ( int i=0; i<size; i++ )
    {
      b[i] = v0 + v1 * ax[i] + v2 * ay[i];
    }
}

extern "C" void
dots_plain
(int size, double* ax, double* ay,
 double v0, double v1, double v2, double* b, int nthreads)
{

#pragma omp parallel for num_threads(nthreads)
  for ( int i=0; i<size; i++ )
    {
      b[i] = v0 + v1 * ax[i] + v2 * ay[i];
    }
}

int
main(int argc, char **argv)
{
  srand48(1);
  const int size_lg = argc > 1 ? atoi(argv[1]) : 10;
  const int size = 1 << size_lg;

  double* const ax = new double[size];
  double* const ay = new double[size];
  double* const b = new double[size];
  double xi = drand48();
  double yi = drand48();
  for ( int i=0; i<size; i++ )
    {
      ax[i] = xi; ay[i] = yi;
      xi += 0.1; yi += 0.1;
    }
  const double v0 = drand48();
  const double v1 = drand48();
  const double v2 = drand48();
  double bogus_sum = 0;

  for ( int version = 0; version < 2; version++ )
    {
      printf("-- Version %d\n",version);
      //  for ( int nt = 1; nt < 8; nt++ )
      for ( int nt: { 1, 1, 1, 2, 3, 4, 8, 10, 16, 32, 64 } )
        {
          vector <double> times;
          for ( int r = 0; r < 3; r++ )
            {
              const double time_start = time_fp();

              switch ( version ) {
              case 0: dots_plain(size,ax,ay,v0,v1,v2,b,nt); break;
              case 1: dots(size,ax,ay,v0,v1,v2,b,nt); break;
              }
              bogus_sum += b[argc];
              const double elapsed_time_s = time_fp() - time_start;
              times.push_back(elapsed_time_s);
            }
          sort(times.begin(),times.end());

          const double elapsed_time_s = times[times.size()/2];

          printf("Thds %2d   Time %.3f ms\n", nt, elapsed_time_s * 1000);


        }
    }

  printf("Finished with %d elements, element %d is %.5f\n",
         size, argc, bogus_sum);


}
