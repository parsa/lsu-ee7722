/// LSU EE 7722 (Spring 2014), GPU Microarchitecture
//

 /// Homework 5 (Spring 2014) 
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gp/2014/hw05.pdf
 //

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>
#include <new>
#include <math.h>
#include <omp.h>
#include "util.h"

#include <offload.h>


struct App_Common
{
  int num_threads;
  int num_pieces;
  int idx_array_elts;
  int data_array_elts;
  int *idx_array;
  float *data_array;
  float *sum_array;
  float *sum_array_check;
};

struct Thread_Data {
  App_Common *app;
  int tid; // Our tid.
};


__attribute__((target(mic))) const int clength = 16;

#pragma offload_attribute(push, target(mic))

// Types for pointers to 512-bit aligned data.
//
typedef int* __attribute((align_value(512))) ptri512;
typedef float* __attribute((align_value(512))) ptrf512;

extern "C" void*
sums_0(Thread_Data *td)
{
  const int tid = td->tid;
  App_Common* const dapp = td->app;
  const int num_pieces = dapp->num_pieces;
  const int num_threads = dapp->num_threads;
  int* const idx_array = dapp->idx_array;
  float* const data_array = dapp->data_array;
  float* const sum_array = dapp->sum_array;

  for ( int piece = tid; piece < num_pieces; piece += num_threads )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += data_array[ dapp->idx_array[idx_piece_start+i] ];

      sum_array[piece] = sum;
    }
  return NULL;
}

extern "C" void*
sums_1(Thread_Data *td)
{
  const int tid = td->tid;
  App_Common* const dapp = td->app;
  const int num_pieces = dapp->num_pieces;
  const int num_threads = dapp->num_threads;
  int* const idx_array = dapp->idx_array;
  float* const data_array = dapp->data_array;
  float* const sum_array = dapp->sum_array;

  for ( int piece = tid; piece < num_pieces; piece += num_threads )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += data_array[ idx_array[idx_piece_start+i] ];

      sum_array[piece] = sum;
    }
  return NULL;
}

extern "C" void*
sums_2(Thread_Data *td)
{
  const int tid = td->tid;
  App_Common* const dapp = td->app;
  const int num_pieces = dapp->num_pieces;
  const int num_threads = dapp->num_threads;
  int* idx_array = dapp->idx_array;
  float* const data_array = dapp->data_array;
  float* const sum_array = dapp->sum_array;

  for ( int piece = tid; piece < num_pieces; piece += num_threads )
    {
      const int idx_piece_start = piece * clength;
      float sum = 0;
      for ( int i=0; i<clength; i++ )
        sum += data_array[ idx_array[idx_piece_start+i] ];

      sum_array[piece] = sum;
    }
  return NULL;
}

#pragma offload_attribute(pop)


int
main(int argc, char **argv)
{
  // Get info about MIC and each kernel.
  //
  GPU_Info info;

  const int num_devices = _Offload_number_of_devices();
  printf("Number of Phis available: %d\n",num_devices);

  const int num_cores_cpu = sysconf( _SC_NPROCESSORS_ONLN );

  int num_ctx_phi = -1;
#pragma offload target(mic)
  num_ctx_phi = sysconf( _SC_NPROCESSORS_ONLN );

  const int num_cores_phi = num_ctx_phi >> 2;
  const int num_free_cores = num_cores_phi - 1;

  printf("Num cores (cpu,phi) (%d,%d)\n", num_cores_cpu, num_cores_phi);

  info.GET_INFO(sums_0);
  info.GET_INFO(sums_1);
  info.GET_INFO(sums_2);

  App_Common app;
  __attribute__((target(mic))) App_Common dapp;

  // Examine argument 1, number of ki elements in data array.
  //
  const int data_array_elts = app.data_array_elts =
    argc < 2 ? 1 << 14 : int( atof(argv[1]) * (1<<10) );

  // Examine argument 2, number of Mi pieces. Fractional values okay.
  //
  const int num_pieces = app.num_pieces = 
    argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );

  const int idx_array_elts = app.idx_array_elts = app.num_pieces * clength;

  const int idx_array_bytes = app.idx_array_elts * sizeof(app.idx_array[0]);
  const int data_array_bytes = app.data_array_elts * sizeof(app.data_array[0]);
  const int sum_array_bytes = app.num_pieces * sizeof(app.sum_array[0]);

  // Allocate storage for CPU copy of data.
  //
  posix_memalign( (void**)& app.idx_array, 64, idx_array_bytes );
  app.data_array = new float[data_array_elts];
  app.sum_array = new float[num_pieces];
  app.sum_array_check = new float[num_pieces];

  // MIC storage is allocated when offload pragmata are used.

  printf("Data array size:  %10d elements, %5.1f kiB.\n",
         app.data_array_elts, data_array_bytes / double(1<<10));
  printf("Index array size: %10d elements, %5.1f MiB.\n",
         app.idx_array_elts, idx_array_bytes / double(1<<20));

  // Initialize input arrays.
  //
  for ( int i=0; i<app.data_array_elts; i++ )
    app.data_array[i] = drand48();

  for ( int i=0; i<app.idx_array_elts; i++ )
    app.idx_array[i] = random() % app.data_array_elts;


  // Compute correct answer (for checking).
  //
  for ( int p=0; p<app.num_pieces; p++ )
    {
      float sum = 0;
      int idx_base = p * clength;
      for ( int i=0; i<clength; i++ )
        sum += app.data_array[app.idx_array[idx_base+i]];
      app.sum_array_check[p] = sum;
    }

  // Copy input array from CPU to MIC.
  //
# pragma offload target(mic) nocopy(app,dapp) \
  in(  app.idx_array:length(app.idx_array_elts) free_if(false)  )
  {
    dapp.idx_array = app.idx_array;
    dapp.num_pieces = num_pieces;
    dapp.idx_array_elts = idx_array_elts;
    dapp.data_array_elts = data_array_elts;
  }
# pragma offload target(mic) nocopy(app,dapp) \
  in(  app.data_array:length(app.data_array_elts) free_if(false)  )
  dapp.data_array = app.data_array;

  // Amount of data transferred if all elts in a request are used.
  // For sum_0 and sum_1 only some elts are used, so this ideal
  // amount is not the answer to Problem 1.
  //
  const double __attribute__((unused)) data_size_ideal =
    idx_array_bytes + app.idx_array_elts * sizeof(app.data_array[0])
    + sum_array_bytes;

  const int cache_size = 1 << 19;

  // Compute the probability that an access to a data array element
  // hits the cache (after the cache has warmed up). This is easy to
  // compute because elements are accessed randomly.
  //
  const double warm_hit_ratio = 
    min( 1.0, double(cache_size) / data_array_bytes );

  const int line_size = 64;

  const double data_size_sums_0 =
    idx_array_bytes 
    + app.idx_array_elts * line_size * ( 1 - warm_hit_ratio )
    + sum_array_bytes;

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
      printf("\nRunning kernel %s.\n", info.ki[kernel].name);

      printf(" %3s %11s    %6s  %5s\n", "Num", "Time", "Data", "" );
      printf(" %3s %11s    %6s  %5s\n", "Tds", "µs", " GB/s", "Pct" );

      const int inc = num_free_cores >> 1;
      const int thread_limit = 4 * num_free_cores;
      float *sum_array = app.sum_array;

      for ( int num_thds=inc; num_thds <= thread_limit; num_thds += inc )
        {
          const int trials = 5;
          double elapsed_time_sum = 0;
          double elapsed_time_min = 0;

#pragma offload target(mic) nocopy(app,dapp)        \
  out(sum_array:length(app.num_pieces))
          {
            dapp.sum_array = sum_array;

            // Zero result array (to catch errors when kernel
            // skips elements).
            //
            memset(dapp.sum_array,0,sum_array_bytes);

            dapp.num_threads = num_thds;

            for ( int r = 0;  r < trials;  r++ )
              {
                // Measure execution time starting "now", which is after
                // input data is prepared.
                //
                const double time_start = time_fp();

                Func kernel_starts[] = {Func(sums_0),Func(sums_1),Func(sums_2)};
                const Func kernel_start = kernel_starts[kernel];

#pragma omp parallel num_threads(num_thds) proc_bind(close)
                  {
                    const int tid = omp_get_thread_num();
                    Thread_Data td;
                    td.tid = tid;
                    td.app = &dapp;
                    kernel_start(&td);
                  }

                // Stop measuring execution time now, which is before is data
                // returned from GPU.
                //
                const double elapsed_time_s = time_fp() - time_start;
                elapsed_time_sum += elapsed_time_s;
                if ( elapsed_time_min == 0 
                     || elapsed_time_min > elapsed_time_s )
                  elapsed_time_min = elapsed_time_s;
              }
          }

          const double elapsed_time_s = elapsed_time_min;

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

          const double data_size = data_size_sums_0;
          const double chip_bw_Bps = 240e9;

          const double frac = data_size / elapsed_time_s / chip_bw_Bps;
          const int s_idx = max(0.0,full_width * ( 1 - frac ));

          printf(" %3d  %11.3f  %6.2f %5.1f%%  %s\n",
                 num_thds, 1e6 * elapsed_time_s,
                 1e-9 * data_size / elapsed_time_s,
                 100 * frac, &stars[kernel][s_idx] );
        }
    }
}
