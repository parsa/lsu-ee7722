
// Simple CUDA Example, using LSU ECE helper classes.

#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "stream.cuh"

int
main(int argc, char** argv)
{
  srand48(1);                   // Seed random number generator.
  const int size_lg = argc > 1 ? atoi(argv[1]) : 10;
  const int array_size = 1 << size_lg;

  device_addr_get();

  // Instantiate data arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<Vector2> a;  // Array of Vector2 structures, size not yet set.
  pCUDA_Memory<float> b;

  a.alloc(array_size);  // Specify size of array.

  // Send address of array to a CUDA constant variable named "a".
  //
  a.ptrs_to_cuda("a");

  b.alloc(array_size); b.ptrs_to_cuda("b");

  // Initialize input array.
  //
  float xi = drand48(), yi = drand48();
  for ( int i=0; i<array_size; i++ )
    {
      a[i].x = xi; a[i].y = yi;
      xi += 0.1; yi += 0.1;
    }

  a.to_cuda(); // Move input array to CUDA.

  // Initialize coefficients and send them to CUDA.
  //
  const float v0 = drand48(), v1 = drand48(), v2 = drand48();

  // Send value of v0 to a CUDA constant variable of the same name (v0).
  //
  TO_DEV(v0);

  // Send other constants, including the size of the array.
  //
  TO_DEV(v1);  TO_DEV(v2); TO_DEV(array_size);

  // Specify Launch Configuration
  //
  dim3 db, dg;  // Type is a three integer vector.

  // Prepare for block size of 64.  (Block size is db.x * db.y * db.z )
  //
  db.x = 64;
  db.y = db.z = 1;

  // Prepare for the number of blocks to array_size / block_size.
  //
  dg.x = int(ceil(double(array_size) / db.x));
  dg.y = dg.z = 1;

  // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
  //
  dots_launch(dg,db);

  // When execution reaches this point kernel has completed.

  // Retrieve data from CUDA.
  //
  b.from_cuda();

  // Print something out to avoid compiler optimizing out everything.
  //
  printf("Finished with %d elements, element %d is %.5f\n",
         array_size, argc, b[argc]);

}
