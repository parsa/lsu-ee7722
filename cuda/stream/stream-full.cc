
// Simple CUDA Example, using LSU ECE helper classes.

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cuda_runtime.h>
#include "stream.cuh"

 /// CUDA API Error-Checking Wrapper
///
#define CE(call)                                                              \
 {                                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess )                                                   \
     {                                                                        \
       printf("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));               \
       exit(1);                                                               \
     }                                                                        \
 }


int
main(int argc, char** argv)
{
  srand48(1);                   // Seed random number generator.
  const int size_lg = argc > 1 ? atoi(argv[1]) : 10;
  const int array_size = 1 << size_lg;

  // Instantiate data arrays.
  //
  Vector2 *a = (Vector2*) malloc( array_size * sizeof(a[0]) );
  float *b = (float*) malloc( array_size * sizeof(b[0]) );

  // Allocate on CUDA.

  void *a_dev, *b_dev;
  CE(cudaMalloc(&a_dev, array_size * sizeof(a[0]) ));
  CE(cudaMalloc(&b_dev, array_size * sizeof(b[0]) ));

  CE(cudaMemcpyToSymbol
     ("a", &a_dev, sizeof(a_dev), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol
     ("b", &a_dev, sizeof(b_dev), 0, cudaMemcpyHostToDevice));

  // Initialize input array.
  //
  float xi = drand48(), yi = drand48();
  for ( int i=0; i<array_size; i++ )
    {
      a[i].x = xi; a[i].y = yi;
      xi += 0.1; yi += 0.1;
    }

  // Move input array to CUDA.
  //
  CE(cudaMemcpy(a_dev, a, array_size * sizeof(a[0]), cudaMemcpyHostToDevice));

  // Initialize coefficients and send them to CUDA.
  //
  const float v0 = drand48(), v1 = drand48(), v2 = drand48();

  CE(cudaMemcpyToSymbol("v0", &v0, sizeof(v0), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol("v1", &v1, sizeof(v1), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol("v2", &v2, sizeof(v2), 0, cudaMemcpyHostToDevice));
  CE(cudaMemcpyToSymbol("array_size", &array_size, sizeof(array_size),
                        0, cudaMemcpyHostToDevice));

  // Specify Launch Configuration
  //
  dim3 db, dg;
  db.x = 64;
  db.y = db.z = 1;
  dg.x = int(ceil(double(array_size) / db.x));
  dg.y = dg.z = 1;

  // Launch Kernel
  //
  dots_launch(dg,db);

  // Retrieve data from CUDA.
  //
  CE(cudaMemcpy(b, b_dev, array_size * sizeof(b[0]), cudaMemcpyDeviceToHost));

  printf("Finished with %d elements, element %d is %.5f\n",
         array_size, argc, b[argc]);

}
