
// Simple CUDA Example, using LSU ECE helper classes.

/// Points

 /// Show implementatoin of simple stencil program on  CUDA.

 /// Variations

 // Shared Memory vs. Multiple Loads

 // Block Size



#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "stencil.cuh"

cudaEvent_t cuda_start_ce, cuda_stop_ce;
cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).

void
cuda_init()
{
  // Get information about GPU and its ability to run CUDA.
  //

  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  ASSERTS( device_count );
  for ( int dev = 0; dev < device_count; dev ++ )
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      printf
        ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
         dev, cuda_prop.name, cuda_prop.clockRate/1e6,
         int(cuda_prop.totalGlobalMem >> 20));

      printf
        ("GPU %d: CAP: %d.%d  MP: %2d  TH/WP: %3d  TH/BL: %4d  "
         "BL/GR %d/%d/%d\n",
         dev, cuda_prop.major, cuda_prop.minor,
         cuda_prop.multiProcessorCount,
         cuda_prop.warpSize,
         cuda_prop.maxThreadsPerBlock,
         cuda_prop.maxGridSize[0],
         cuda_prop.maxGridSize[1],
         cuda_prop.maxGridSize[2]
         );

      printf
        ("GPU %d: SHARED: %5d  CONST: %5d  # REGS: %5d\n",
         dev,
         int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
         cuda_prop.regsPerBlock);
    }

  //  const int dev = device_count - 1;;
  const int dev = 0;

  printf("Using GPU %d\n",dev);
  CE(cudaSetDevice(dev));
  CE(cudaGetDeviceProperties(&cuda_prop,dev));

  const int max_routines = 10;
  cudaFuncAttributes attr_dots[max_routines];
  char *names[max_routines];

  CE(kernels_get_attr(attr_dots,names));

  printf("CUDA Routine Resource Usage:\n");

  for ( int i=0; names[i]; i++ )
    {
      printf(" %-20s:\n   %6zd B shared,  %zd B const,  %zd B loc,  %d regs; "
             "%d max thr / block\n",
             names[i],
             attr_dots[i].sharedSizeBytes,
             attr_dots[i].constSizeBytes,
             attr_dots[i].localSizeBytes,
             attr_dots[i].numRegs,
             attr_dots[i].maxThreadsPerBlock);
    }

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&cuda_start_ce));
  CE(cudaEventCreate(&cuda_stop_ce));
}


class Stencil_Demo {
public:

  Stencil_Demo(int argc, char **argv){ init(argc,argv); }

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<float> a_full;  // Includes extra elements.
  float *a;
  pCUDA_Memory<float> b;
  float v0, v1, v2;
  float *b_check;
  int dim_size_lg;
  int array_size;
  int row_stride;

  bool show_wall;

  void init(int argc, char **argv)
  {
    // Print information about available GPUs.
    //
    cuda_init();

    srand48(1);                   // Seed random number generator.

    // Run options.
    //
    show_wall = false;          // Whether to show CPU visible time.
    dim_size_lg = argc > 1 ? atoi(argv[1]) : 10;

    array_size = 1 << dim_size_lg;

    // Allocate array with extra 256 /guard/ elements at beginning
    // and end, to keep code simple.
    //
    // Variable a_full: array with guard, 1st element is a_full[256];
    //          a     : Pointer to a_full[256]. First element is a[0].
    //
    const int a_guard_size = 256;
    int array_size_full = array_size + 2 * a_guard_size;

    a_full.alloc(array_size_full);  // Specify size of array.
    a = a_full.data + a_guard_size;

    // Send address of array to a CUDA constant variable named "a".
    //
    float* const a_full_dev = a_full.get_dev_addr();
    float* const a_dev = a_full_dev + a_guard_size;
    TO_DEV_DS(a,a_dev);
    a_full.set_dev_addr_seen(0);

    b.alloc(array_size);
    bzero(b.data,array_size*sizeof(b_check[0]));
    b.ptrs_to_cuda("b");
    b.to_cuda();

    // Initialize input array.
    //
    for ( int i=0; i<array_size; i++ ) a[i] = drand48();

    // Initialize coefficients.
    //
    v0 = 0.8;  v1 = 0.1;

    // Send value of v0-v1 and array_size to CUDA.
    //
    TO_DEV(array_size);
    TO_DEV(v0); TO_DEV(v1);

    // Prepare cpu-side array for checking results.
    //
    // Array b_check holds the correct answer, as computed on the
    // CPU.  In production (real-life) code this step would only
    // be done in a special debug mode.
    //
    b_check = new float[array_size];
    bzero(b_check,array_size*sizeof(b_check[0]));
    stencil_cpu(a,b_check);     // Compute solution on CPU.

    printf("Initialized for %d elements.\n",array_size);
  }

  void stencil_cpu(float *a, float *b)
  {
    // Compute result on CPU.
    //
    for ( int idx = 0; idx < array_size; idx++ )
      b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] );
  }

  void check()
  {
    // Compare CPU-computed result to GPU computed result.
    //
    for ( int i=0; i<array_size; i++ )
      {
        const float diff = fabs( b[i] - b_check[i] );
        const double err_frac = b_check[i] > 0 ? diff / b_check[i] : diff;
        if ( err_frac > 0.00001 )
          {
            printf("*** Incorrect result at %d  %.3f != %.3f (correct)\n",
                   i, b[i], b_check[i]);
            return;
          }
      }
  }

  void start()
  {
    // Run kernel in a variety of configurations.
    //
    const int block_sizes[] = {32, 512};
    int bl_per_mp[] = {1,2,4,6,8,0};
    int cnt = sizeof(bl_per_mp) / sizeof(bl_per_mp[0]);
    for ( int i=0; i<cnt; i++ )
      {
        for ( int j=0; j<2; j++ )
          {
            const int block_size = block_sizes[j];
            run(block_size,bl_per_mp[i],false);
            run(block_size,bl_per_mp[i],true);
          }
      }
  }

  void run(int block_size, int bl_per_mp = 1, bool shared_kernel = false)
  {
    const int cpu_rounds = 5;  // Warm up CPU caches.
    const int gpu_rounds = 5;  // Simulate iterative GPU algorithm.

    // Specify Launch Configuration
    //
    dim3 db, dg;  // Type is a three integer vector.

    // Prepare for block size of 64.  (Block size is db.x * db.y * db.z )
    //
    db.x = block_size;
    db.y = db.z = 1;

    // Prepare for the number of blocks to array_size / block_size.
    //
    if ( bl_per_mp )
      dg.x = cuda_prop.multiProcessorCount * bl_per_mp;
    else
      dg.x = int(ceil(double(array_size) / db.x));
    dg.y = dg.z = 1;

    printf
      ("GPU Rounds %d,  Grid Dim %d,  Block Dim %d,  BL/MP %.2f,  Shared %d\n",
       gpu_rounds, dg.x, db.x,
       double(dg.x)/cuda_prop.multiProcessorCount,
       shared_kernel);
    if ( int(dg.x) > cuda_prop.maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        // Measure wall-clock time (full delay seen by CPU) from
        // the start of sending data to GPU to when the result is
        // back on the CPU.
        //
        const double wall_all_start = time_wall_fp();

        a_full.to_cuda(); // Move input array to CUDA.

        CE(cudaEventRecord(cuda_start_ce));

        // Launch Kernel Multiple Times
        //
        for ( int i=0; i<gpu_rounds; i++ ) stencil_launch(dg,db,shared_kernel);

        CE(cudaEventRecord(cuda_stop_ce));
        CE(cudaEventSynchronize(cuda_stop_ce));

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        b.from_cuda();

        const double wall_all = time_wall_fp() - wall_all_start;

        // Retrieve time taken by GPU between two cudaEventRecord calls.
        //
        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        // Don't print anything if this is a warm-up iteration.
        //
        if ( cpu_round + 1 < cpu_rounds ) continue;

        const int sidx = min(block_size,array_size) - 1;
        if ( false )
          printf("Round %d.   Finished %d elements, element %d is %.5f\n",
                 cpu_round, array_size, sidx, b[sidx]);

        const size_t data_size =
          gpu_rounds * array_size * ( sizeof(a[0]) + sizeof(b[0]) );

        printf("CUDA Time %6.3f ms  Throughput %11.3f MB/s\n",
               cuda_time_ms,
               data_size / ( cuda_time_ms * 1000 ));
        if ( show_wall )
          printf("Wall Time %6.3f ms  Throughput %11.3f MB/s\n",
                 wall_all * 1000,
                 data_size / ( wall_all * 1e6 ));

        // Check whether result is correct.
        //
        check();
      }
  }
};


int
main(int argc, char** argv)
{
  Stencil_Demo stencil_demo(argc,argv);
  stencil_demo.start();
  return 0;
}
