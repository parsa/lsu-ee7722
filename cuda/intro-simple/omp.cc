#include <stdio.h>
#include <vector>
#include <cstdlib>
using namespace std;


// Very simple, completely self-contained, example of a multithreaded
// program using OpenMP

// OpenMP Documenation: http://www.openmp.org/specifications/

// Compile command:  g++ omp.cc -o omp -O3 -fopenmp -Wall
// 

int
main(int argc, char **argv)
{
  const int SIZE = 100000000;

  // Get number of threads to spawn from the command-line argument.
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
  printf("Value of element number %d is %f\n", argc, x[argc]);

  return 0;
}
