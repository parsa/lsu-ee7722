#include <stdio.h>
#include <vector>
#include <cstdlib>
#include <thread>
using namespace std;

// Very simple, completely self-contained, example of a multithreaded
// program using the c++11 thread support library.

// Thread Library Documentation: http://en.cppreference.com/w/cpp/thread

// Compile command:  g++ thds.cc -o thds -O3 -Wall -std=c++11 -lpthread
//


const int SIZE = 100000000;

void
thread_main(int tid, int nt, int size, float *x, float *a, float *b)
{
  // Welcome to thread number tid.

  // Using arguments determine which section of the array to work on.
  //
  const int elt_per_thd = size / nt;
  const int start = tid * elt_per_thd;
  const int stop = start + elt_per_thd;

  // Initialize values.
  //
  for ( int i=start; i<stop; i++ )
    {
      a[i] = i + tid;
      b[i] = float(tid) / (i+1);
    }

  // Perform computation.
  //
  for ( int i=start; i<stop; i++ )
    x[i] = a[i] + b[i];
}

int
main(int argc, char **argv)
{
  // Get number of threads to spawn from the command-line argument.
  //
  const int nthds = argc == 1 ? 4 : atoi(argv[1]);

  // Declare arrays for inputs and output.
  //
  vector<float> a(SIZE);
  vector<float> b(SIZE);
  vector<float> x(SIZE);

  // Declare an array of threads.
  //
  vector<thread> our_threads;

  // Create new threads by constructing std::thread objects.
  //
  for ( int i=0; i<nthds; i++ )
    our_threads.emplace_back
      ( thread_main,  i, nthds, SIZE, x.data(), a.data(), b.data() );
  //    Start proc.   Arguments to start procedure ---------------.

  // Wait for threads to finish.
  //
  for ( auto& t: our_threads ) t.join();

  // Note: Print out the value to prevent optimizer from eliminating
  // code.
  //
  printf("Value of element number %d is %f\n", argc, x[argc]);

  return 0;
}
