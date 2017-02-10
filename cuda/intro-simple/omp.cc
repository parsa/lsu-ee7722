/// LSU EE 7722 GPU Microarchitecture
//
 /// Simple, Self-Contained, One-File OpenMP Example

// Very simple, completely self-contained, example of a multithreaded
// program using OpenMP.

 /// How to Compile from the Command Line
//
//   Compile command:  g++ omp.cc -o omp -O3 -fopenmp -Wall
//   Run command:      ./omp

 /// Documentation
//
//   OpenMP: http://www.openmp.org/specifications/
//   C++:    http://en.cppreference.com/w/


#include <stdio.h>
#include <vector>
#include <cstdlib>

using namespace std;

int
main(int argc, char **argv)
{
  const int SIZE = 100000000;

  // Get number of threads to spawn from the command-line argument.
  //
  // If no argument given, use 4 as the default number of threads.
  //
  const int nthds = argc == 1 ? 4 : atoi(argv[1]);

  // Declare arrays for inputs and output.
  //
  vector<float> a(SIZE);
  vector<float> b(SIZE);
  vector<float> x(SIZE);

  // Initialize values.
  //
#pragma omp parallel for num_threads(nthds)
  for ( int i=0; i<SIZE; i++ )
    {
      a[i] = i + argc;
      b[i] = float(argc) / (i+1);
    }

  // Perform computation.
  //
#pragma omp parallel for num_threads(nthds)
  for ( int i=0; i<SIZE; i++ )
    x[i] = a[i] + b[i];

  // Note: Print out the value to prevent optimizer from eliminating
  // code.
  //
  printf("Using %d threads, value of element number %d is %f\n",
         nthds, argc, x[argc]);

  return 0;
}
