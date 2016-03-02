
// Simple CUDA Example, using LSU ECE helper classes.

/// Points

 /// Show implementatoin of simple stream program on  CUDA.

 /// Variations

 // User Structure vs. CUDA-defined float2.

 // Single iteration per thread vs. multiple iterations.

 // Block Size


#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "stream-2.cuh"

class CUDA_Device_Manager {
public:
  CUDA_Device_Manager() {};

  cudaDeviceProp *cuda_prop;
  int device_count;

  bool init(int device_try)
  {
    // Get information about GPU and its ability to run CUDA.
    //
    CE(cudaGetDeviceCount(&device_count)); // Get number of GPUs.

    if ( !device_count )
      {
        printf("No CUDA devices found.\n");
        return false;
      }

    cuda_prop = new cudaDeviceProp[device_count];

    for ( int dev = 0; dev < device_count; dev ++ )
      {
        cudaDeviceProp* const cdp = &cuda_prop[dev];
        CE(cudaGetDeviceProperties(cdp,dev));

        printf
          ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
           dev, cdp->name, cdp->clockRate/1e6,
           int(cdp->totalGlobalMem >> 20));

        printf
          ("GPU %d: CAP: %d.%d  MP: %2d  TH/WP: %3d  TH/BL: %4d  "
           "BL/GR %d/%d/%d\n",
           dev, cdp->major, cdp->minor,
           cdp->multiProcessorCount,
           cdp->warpSize, cdp->maxThreadsPerBlock,
           cdp->maxGridSize[0], cdp->maxGridSize[1], cdp->maxGridSize[2]
           );

        printf
          ("GPU %d: SHARED: %5d  CONST: %5d  # REGS: %5d\n",
           dev,
           int(cdp->sharedMemPerBlock), int(cdp->totalConstMem),
           cdp->regsPerBlock
           );
      }

    const int dev = min(device_try,device_count-1);
    CE(cudaSetDevice(dev));
    printf("Using GPU %d\n",dev);

    const int max_routines = 10;
    cudaFuncAttributes attr_dots[max_routines];
    char *names[max_routines+1];
    CE(kernels_get_attr(attr_dots,names,max_routines));
    printf("CUDA Routine Resource Usage:\n");
    for ( int i=0; names[i]; i++ )
      printf(" %-20s:\n   %6zd B shared,  %zd B const,  %zd B loc,  %d regs; "
             "%d max thr / block\n",
             names[i],
             attr_dots[i].sharedSizeBytes,
             attr_dots[i].constSizeBytes,
             attr_dots[i].localSizeBytes,
             attr_dots[i].numRegs,
             attr_dots[i].maxThreadsPerBlock);
    return true;
  }

  cudaDeviceProp* get_cudaDeviceProp()
  {
    int device_in_use;
    CE(cudaGetDevice(&device_in_use));
    return &cuda_prop[device_in_use];
  }

};

class Stream_Demo {
public:

  Stream_Demo(int argc, char **argv){ init(argc,argv); }

  CUDA_Device_Manager cuda_device_manager;
  cudaDeviceProp *cuda_prop; // Properties of device in use.
  cudaEvent_t cuda_start_ce, cuda_stop_ce;

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<Vector2> a;  // Array of Vector2 structures, size not yet set.
  pCUDA_Memory<float> b;
  float *b_check;
  int array_size;
  bool printed_header;

  void init(int argc, char **argv)
  {
    srand48(1);                   // Seed random number generator.
    cuda_device_manager.init(0);
    cuda_prop = cuda_device_manager.get_cudaDeviceProp();

    // Prepare events used for timing.
    //
    CE(cudaEventCreate(&cuda_start_ce));
    CE(cudaEventCreate(&cuda_stop_ce));

    const int size_lg = argc > 1 ? atoi(argv[1]) : 22;
    array_size = 1 << size_lg;

    a.alloc(array_size);  // Specify size of array.

    // Send address of array to a CUDA constant variable named "a".
    //
    a.ptrs_to_cuda("a");

    b.alloc(array_size);
    b.ptrs_to_cuda("b");

    // Initialize input array.
    //
    float xi = drand48(), yi = drand48();
    for ( int i=0; i<array_size; i++ )
      {
        a[i].x = xi; a[i].y = yi;
        xi += 0.1; yi += 0.1;
      }

    // Initialize coefficients and send them to CUDA.
    //
    const float v0 = drand48(), v1 = drand48(), v2 = drand48();

    // Send value of v0 to a CUDA constant variable of the same name (v0).
    //
    TO_DEV(v0);

    // Send other constants, including the size of the array.
    //
    TO_DEV(v1);  TO_DEV(v2);  TO_DEV(array_size);

    // Prepare cpu-side array for checking results.
    //
    b_check = new float[array_size];
    for ( int i=0; i<array_size; i++ )
      b_check[i] = v0 + v1 * a[i].x + v2 * a[i].y;

    printf("Array size %d elements,  data size (in and out) %.3f MB.\n",
           array_size,
           array_size * ( sizeof(a[0]) + sizeof(b[0]) ) * 1e-6);

    printed_header = false;
  }

  void check()
  {
    for ( int i=0; i<array_size; i++ )
      {
        const float diff = fabs( b[i] - b_check[i] );
        const double err_frac = b_check[i] > 0 ? diff / b_check[i] : diff;
        if ( err_frac > 0.00001 )
          {
            printf("*** Incorrect result at %d:  %.3f != %.3f (correct)\n",
                   i, b[i], b_check[i]);
            return;
          }
      }
  }

  void start()
  {
    // Run kernel in a variety of configurations.
    //
    const int max_block_size = cuda_prop->maxThreadsPerBlock;

    // Vary number of blocks per multiprocessor.
    //
    int bl_per_mp[] = {1,2,4,8};
    int cnt = sizeof(bl_per_mp) / sizeof(bl_per_mp[0]);

    for ( int k=0; k<3; k++ )
    for ( int i=0; i<cnt; i++ )
      {
        run(16,bl_per_mp[i]);
        for ( int j=0; j<6; j++ )
          {
            run(32<<j,bl_per_mp[i],k);
          }
      }

  }

  void run(int block_size, int bl_per_mp = 1, int kernel = 0)
  {
    const int cpu_rounds = 5;
    const int gpu_rounds = 5;

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
      dg.x = cuda_prop->multiProcessorCount * bl_per_mp;
    else
      dg.x = int(ceil(double(array_size) / db.x));
    dg.y = dg.z = 1;

    if ( int(dg.x) > cuda_prop->maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        const double wall_all_start = time_wall_fp();

        a.to_cuda(); // Move input array to CUDA.

        // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
        //
        CE(cudaEventRecord(cuda_start_ce));
        for ( int i=0; i<gpu_rounds; i++ )
          dots_iterate_launch(dg,db,kernel);

        CE(cudaEventRecord(cuda_stop_ce));

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        b.from_cuda();

        const double wall_all = time_wall_fp() - wall_all_start;

        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        if ( cpu_round + 1 < cpu_rounds ) continue;

        const size_t data_size =
          gpu_rounds * array_size * ( sizeof(a[0]) + sizeof(b[0]) );

        if ( !printed_header )
          printf
            ("-Grid-Sz---  -Block-Sz-------               -Time----   -Data Thpt--\n");
        printed_header = true;

     //  "Array13 bl    32 th    1 wp     1.0 bl/mp   31.472 ms      7996 GB/s"
        printf(" %6d bl  %4d th  %3d wp  %6.1f bl/mp  %7.3f ms  %8.0f GB/s\n",
               dg.x, db.x, db.x + 31 >> 5,
               double(dg.x)/cuda_prop->multiProcessorCount,
               cuda_time_ms,
               data_size / ( cuda_time_ms * 1000 ));
        check();
      }
  }
};

int
main(int argc, char** argv)
{
  Stream_Demo stream_demo(argc,argv);
  stream_demo.start();
  return 0;
}
