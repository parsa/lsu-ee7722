/// LSU EE 7722 (Spring 2017), GPU Microarchitecture
//

// Sample Phi code performing fixed matrix * vector array multiplication.

#pragma offload_attribute(push,target(mic))
#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <ctype.h>
#include <time.h>
#include <new>
#include <vector>
#include <string>
#include <algorithm>
#include <thread>
#include <functional>
#include <chrono>
#include <string.h>
#include <math.h>
#include <omp.h>
#include <errno.h>
#include <offload.h>
#include <sched.h>

#pragma offload_attribute(pop)

using namespace std;

#define CP(c)                                                                 \
 { const int __error = c;                                                     \
   if ( __error )                                                             \
     {                                                                        \
       fprintf(stderr,"Error in pthreads call on line %d:",__LINE__);         \
       errno = __error;                                                       \
       perror("");                                                            \
       exit(1);                                                               \
     }                                                                        \
 }

static int fl1(u_int32_t n) {return 8 * sizeof(n) - __builtin_clz(n);}

__attribute__ ((target(mic))) 
inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}


typedef float Elt_Type;

#define N 128

struct
Vector
{
  Elt_Type a[N];
};

struct App
{
  int num_threads;
  Elt_Type matrix[N][N];
  size_t array_size;
  int *cpu_num;
  Vector *v_in, *v_out, *v_check;
  Vector *v_in_m, *v_out_v;
};

// In host address space.
__attribute__ ((target(mic))) App app;

void
omp_start()
{
#pragma omp parallel for num_threads(app.num_threads)
  for ( unsigned int h=0; h<app.array_size; h++ )
    {
      Vector p = app.v_in[h];
      Vector q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }
}

__attribute__ ((target(mic))) void
omp_start_mic()
{
#pragma omp parallel for num_threads(app.num_threads)
  for ( unsigned int h=0; h<app.array_size; h++ )
    {
      Vector p = app.v_in[h];
      Vector q;
      for ( int i=0; i<N; i++ )
        {
          q.a[i] = 0;
          for ( int j=0; j<N; j++ ) q.a[i] += app.matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }
}

__attribute__ ((target(mic))) void* pt_thread_start(int tid);


__attribute__ ((target(mic))) void*
pt_thread_start_set_af(int proc, int tid)
{
  pthread_t me = pthread_self();
  cpu_set_t mask;
  CPU_ZERO(&mask);
  CPU_SET(proc,&mask);
  CP( pthread_setaffinity_np(me, sizeof(mask), &mask) );
  pt_thread_start(tid);
}


__attribute__ ((target(mic))) void*
pt_thread_start(int tid)
{
  const int elt_per_thread =
    ( app.array_size + app.num_threads - 1 ) / app.num_threads;
  const int start = elt_per_thread * tid;
  const int stop = min(int(app.array_size), start + elt_per_thread );

  __attribute__((aligned(sizeof(Elt_Type[N])))) Elt_Type matrix[N][N];
  //  __attribute__((aligned(512/8))) Type_Elt matrix[N][N];

  const bool transpose = false;

  for ( int r=0;r<N;r++ )
    for( int c=0; c<N; c++)
      matrix[r][c] = transpose ? app.matrix[c][r] : app.matrix[r][c];

  for ( int h=start; h<stop; h++ )
    {
      Vector p = app.v_in[h];
      Vector q;
      for ( int i=0; i<N; i++ )  // Search target.
        {
          q.a[i] = 0;
          if ( transpose )
            for ( int j=0; j<N; j++ ) q.a[i] += matrix[j][i] * p.a[j];
          else
            for ( int j=0; j<N; j++ ) q.a[i] += matrix[i][j] * p.a[j];
        }
      app.v_out[h] = q;
    }

  app.cpu_num[tid] = sched_getcpu();

  return NULL;
}

int
main(int argc, char **argv)
{
  const int nt_raw = argc < 2 ? 1 : atoi(argv[1]);
  app.num_threads = abs(nt_raw);

  const size_t ref_size = size_t(1) << 22;
  const size_t array_size_fp =
    argc < 3 ? ref_size : size_t(atof(argv[2]) * ref_size );
  app.array_size = array_size_fp / N;
  //  app.array_size = argc < 3 ? 1 << 20 : int( atof(argv[2]) * (1<<20) );
  const size_t array_size_bytes = app.array_size * sizeof(app.v_in[0]);

  // Allocate storage for CPU copy of data.
  //
  app.v_in = new Vector[app.array_size];
  app.v_out = new Vector[app.array_size];
  app.v_check = new Vector[app.array_size];

  const int num_procs_cpu = omp_get_num_procs();

  int num_ctx_mic;
#pragma offload target(mic)
  num_ctx_mic = omp_get_num_procs();

  //  comet-mic0.ece.lsu.edu

  const int num_procs_mic = num_ctx_mic / 4;

  const double data_size = array_size_bytes * 2;
  const double fp_op_count = app.array_size * ( 2 * N * N );

  const int nsamples = 2;

  printf("Using %d x %d matrix, %zd elements.  Comp/Comm %.2f\n",
         N, N, app.array_size, fp_op_count / data_size);

  printf("Have %d CPU cores and %d MIC cores. Collecting %d samples.\n",
         num_procs_cpu,num_procs_mic,nsamples);

  int np_lg = fl1(num_procs_cpu);

  // Initialize input array.
  //
  for ( size_t i=0; i<app.array_size; i++ )
    for ( int j=0; j<N; j++ ) app.v_in[i].a[j] = drand48();

  // Initialize transformation matrix.
  //
  for ( int i=0; i<N; i++ )
    for ( int j=0; j<N; j++ )
      app.matrix[i][j] = drand48();

  for ( size_t i=0; i<app.array_size; i++ )
    for ( int r=0; r<N; r++ )
      {
        app.v_check[i].a[r] = 0;
        for ( int c=0; c<N; c++ )
          app.v_check[i].a[r] += app.matrix[r][c] * app.v_in[i].a[c];
      }

  printf("For %zd elements...\n", app.array_size);

  const char* const names[] = { "OMP", "PTH", "OFF" };

  int max_num_thds = num_ctx_mic;
  vector<int> cpu_num;
  cpu_num.resize(max_num_thds);
  app.cpu_num = cpu_num.data();

#pragma offload_transfer target(mic) \
  in(app.v_in:length(app.array_size) free_if(0)) \
  in(app.v_out:length(app.array_size) free_if(0))

#pragma offload_transfer target(mic) \
  in(app.cpu_num:length(cpu_num.size()) free_if(0))

  for ( int k=2; k<3; k++ )
    {
      printf("Running %s...\n", names[k]);
      for ( int ntl = 2; ntl < 3; ntl++ )
        {
          const int num_procs = k < 2 ? num_procs_cpu : num_procs_mic;
          app.num_threads = ntl < 0 ? num_procs >> -ntl : num_procs << ntl;
          if ( app.num_threads == 0 ) continue;

          vector<double> tot_durations(nsamples);
          vector<double> spa_durations(nsamples);

          for ( int s=0; s<nsamples; s++ )
            {

              const double time_start = time_fp();
              double time_end = time_start;
              double spawn_duration = 0;

              switch ( k ) {

              case 0:
                omp_start();
                time_end = time_fp();
                break;

              case 1: // C++11 Threads
                {
                  const double create_start_time = time_fp();
                  vector<thread> threads;
                  for ( int i=0; i<app.num_threads; i++ )
                    threads.emplace_back
                      ( pt_thread_start_set_af, i % num_procs, i );

                  spawn_duration = time_fp() - create_start_time;

                  for ( int i=0; i<app.num_threads; i++ ) threads[i].join();

                  time_end = time_fp();
                }
                break;

              case 2: // Phi a.k.a. Mic
                {
#pragma offload target(mic) in(app)
                  {
                    const double create_start_time = time_fp();
                    vector<thread> threads;
                    for ( int i=0; i<app.num_threads; i++ )
                      {
                        int proc =
                          4 * ( i % num_procs_mic ) + i / num_procs_mic;

                        threads.emplace_back(pt_thread_start_set_af,proc,i);
                      }

                    spawn_duration = time_fp() - create_start_time;

                    for ( int i=0; i<app.num_threads; i++ ) threads[i].join();
                  }


                  time_end = time_fp();

#pragma offload_transfer target(mic) out(app.v_out:length(app.array_size))

                }
                break;
              }

              const double elapsed_time = time_end - time_start;
              tot_durations[s] = elapsed_time;
              spa_durations[s] = spawn_duration;
            }

          const int med = nsamples / 2;
          // auto median = [&](vector<double>& v)
          //   {
          //     nth_element(v.begin(),v.begin() + n,v.end());
          //     return v[n];
          //   };
          sort(tot_durations.begin(),tot_durations.end());
          sort(spa_durations.begin(),spa_durations.end());
          const double elapsed_time = tot_durations[med];
          const double create_duration = spa_durations[med];
          const double err =
            fabs( elapsed_time - tot_durations[med+1] ) / elapsed_time;

          int err_count = 0;
          for ( size_t i=0; i<app.array_size; i++ )
            for ( int r=0; r<N; r++ )
                {
                  if ( fabs( app.v_check[i].a[r] - app.v_out[i].a[r] ) > 1e-3 )
                    {
                      err_count++;
                      if ( err_count < 5 )
                        printf
                          ("Error at vec %zd comp %d: %.7f != %.7f (correct)\n",
                           i, r, app.v_out[i].a[r],
                           app.v_check[i].a[r] );
                    }
                }
          if ( err_count )
            printf("Total errors %d\n", err_count);
          else
            printf("Ran without problems.\n");

          printf(" %4d thds  %8.0f µs e %4.1f%% (%4.1f%% %5.0f µs)  "
                 "%7.3f GFLOPS,  %7.3f GB/s\n",
                 app.num_threads,
                 1e6 * elapsed_time, 100 * err,
                 1e2 * create_duration / elapsed_time,
                 1e6 * create_duration / app.num_threads,
                 1e-9 * fp_op_count / elapsed_time,
                 1e-9 * data_size / elapsed_time);

        }
    }
}
