/// LSU EE 7722 GPU Microarchitecture
//
 ///  Homework 1 - Spring 2017
//
//  Assignment: http://www.ece.lsu.edu/koppel/gp/2017/hw01.pdf


 /// How to Compile from the Command Line
//
//   Compile command:  g++ thds.cc -o thds -O3 -Wall -std=c++11 -lpthread

 /// Documentation
//
//   Thread Library: http://en.cppreference.com/w/cpp/thread


#include <stdio.h>
#include <vector>
#include <cstdlib>
#include <thread>

using namespace std;

inline double
time_fp()
{
  struct timespec tp;
  clock_gettime(CLOCK_REALTIME,&tp);
  return ((double)tp.tv_sec)+((double)tp.tv_nsec) * 0.000000001;
}

struct App {
  int nt;       // Number of threads.
  int size;     // Array size.
  float *a, *b; // Input arrays.
  float *x;     // Output array
};


void
thread_main(int tid, App* app)
{
  // Welcome to thread number tid.

  const auto nt = app->nt;
  const auto size = app->size;
  const auto a = app->a;
  const auto b = app->b;
  const auto x = app->x;

  // Using arguments determine which section of the array to work on.
  //
  const int elt_per_thd = size / nt;
  const int start = tid * elt_per_thd;
  const int stop = start + elt_per_thd;

  // Initialize values.
  //
  if ( ( tid & 1 ) == 0 )
    for ( int i=start; i<stop; i++ )
      {
        a[i] = i + nt;
        b[i] = float(nt) / (i+1);
      }

  // Perform computation.
  //
  if ( ( tid & 1 ) == 1 )
    for ( int i=start; i<stop; i++ )
      x[i] = a[i] + b[i];
}

int
main(int argc, char **argv)
{
  const int SIZE = 100000000;

  // Get number of threads to spawn from the command-line argument.
  //
  // If no argument given, use 20 as the default number of threads.
  //
  const int nthds = argc == 1 ? 20 : atoi(argv[1]);

  // Declare arrays for inputs and output.
  //
  vector<float> a(SIZE);
  vector<float> b(SIZE);
  vector<float> x(SIZE);
  vector<float> xcheck(SIZE);

  App app;
  app.nt = nthds;
  app.size = SIZE;
  app.a = a.data();
  app.b = b.data();
  app.x = x.data();

  for ( int i=0; i<SIZE; i++ )
    xcheck[i] = float(i + nthds) + float(nthds) / (i+1);

  // Routine for checking results.
  //
  auto check = [&]()
    {
      int errs = 0;

      for ( int i=0; i<SIZE; i++ )
        if ( xcheck[i] != x[i] )
          {
            if ( errs < 10 )
              printf("Error at element %d.  %f != %f (correct).\n",
                     i, x[i], xcheck[i] );
            errs++;
          }
      if ( errs ) printf("Total of %d errors.\n", errs); 

      // Note: Print out the value to prevent optimizer from eliminating
      // code.
      //
      printf("Using %d threads value of element number %d is %f\n",
             nthds, argc, x[argc]);
    };

  printf("Running parent-syncs version...\n");
  for ( auto v: { &a, &b, &x } ) for ( auto& xv: *v ) xv = 0;
  const double ps_start = time_fp();

  // Create new threads by constructing std::thread objects.
  //
  for ( int j=0; j<2; j++ )
    {
      vector<thread> psync_threads;

      // Start either odd or even threads ...
      //
      for ( int i=j; i<nthds; i+=2 )
        psync_threads.emplace_back( thread_main,  i, &app );
      //                            Start proc.   Arguments to start procedure.

      // ... and wait for them to finish.
      //
      for ( auto& t: psync_threads ) t.join();
    }

  printf("... took %.6f ms\n",time_fp() - ps_start);
  check();

  printf("Running child-threads-sync version.\n");
  for ( auto v: { &a, &b, &x } ) for ( auto& xv: *v ) xv = 0;
  const double cs_start = time_fp();

  // Declare an array of threads.
  //
  vector<thread> our_threads;

  // Create new threads by constructing std::thread objects.
  //
  for ( int i=0; i<nthds; i++ )
    our_threads.emplace_back( thread_main,  i, &app );
  //                          Start proc.   Arguments to start procedure.

  // Wait for threads to finish.
  //
  for ( auto& t: our_threads ) t.join();

  printf("... took %.6f ms\n",time_fp() - cs_start);
  check();

  return 0;
}
