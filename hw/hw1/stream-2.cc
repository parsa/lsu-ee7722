/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 1

 ///
 /// Instructions
 ///

 // First read the assignment at:
 //
 //  http://www.ece.lsu.edu/koppel/gp/2011/hw01.pdf

 // Before solving the problems familiarize yourself with this code.

 ///
 /// Code Description
 ///

 // This code is a simple example of a stream program implemented in
 // CUDA. It is intended to demonstrate basic techniques for
 // programming in CUDA and to serve as a template for Homework 1
 // (Spring 2011).

 // The code computes the function (kernel)
 //
 //       b[idx] = v0 + v1 * a[idx].x + v2 * a[idx].y;
 //
 // where a is an input array of 2-element vectors and b is an
 // output array of scalars.

 // This code runs the function under CUDA at a variety of block sizes
 // and grid sizes (numbers of blocks).

///
/// Program Output
///

 /// Sample Program output.

 // All comments on the output are tabbed (like this line).


 // The program starts by printing information about available GPUs,
 // followed by the GPU actually used.

// GPU 0: GeForce GTX 480 @ 1.40 GHz WITH 1535 MiB GLOBAL MEM
// GPU 0: CAP: 2.0  MP: 15  TH/WP:  32  TH/BL: 1024  BL/GR 65535/65535/1
// GPU 0: SHARED: 49152  CONST: 65536  # REGS: 32768
// GPU 1: Quadro FX 3800 @ 1.20 GHz WITH 1023 MiB GLOBAL MEM
// GPU 1: CAP: 1.3  MP: 24  TH/WP:  32  TH/BL:  512  BL/GR 65535/65535/1
// GPU 1: SHARED: 16384  CONST: 65536  # REGS: 16384
// Using GPU 0

  // CAP: CUDA compute capability.
  // MP: Number of multiprocessors, TH/WP: Warp size, TH/BL: max block size.
  // BL/GR: Maximum number of blocks along each grid dimension.


  /// Next the program shows resources used by the various kernels.

// CUDA Routine Resource Usage:
//  dots_loopless       :
//         0 B shared,  32 B const,  0 B loc,  10 regs; 1024 max thr / block
//  dots_stride_large   :
//         0 B shared,  32 B const,  0 B loc,  14 regs; 1024 max thr / block
//  dots_stride_small   :
//         0 B shared,  32 B const,  0 B loc,  14 regs; 1024 max thr / block


 /// This is the size of the array, obviously.

// Array size 4194304 elements,  data size (in and out) 50.332 MB.


 /// Timing results appear below

// GPU Rounds 5,  Grid Dim     15,  Block Dim   32,  BL/MP     1.0,  TH/MP      32

  // Grid Dim: Number of blocks.
  // BL/MP: Blocks per multiprocessor.
  // TH/MP: Threads per multiprocessor.


// CUDA Time 20.859 ms  Throughput   12064.523 MB/s

  // Time for five kernel invocations. Does not include CPU data transfer.


// Wall Time 30.940 ms  Throughput    8133.736 MB/s

  // Time for five kernel invocations, does include CPU data transfer.


 /// Additional block and grid sizes:

// GPU Rounds 5,  Grid Dim     15,  Block Dim   64,  BL/MP     1.0,  TH/MP      64
// CUDA Time 10.610 ms  Throughput   23719.074 MB/s
// Wall Time 22.020 ms  Throughput   11428.569 MB/s



// *** Maximum grid size exceeded, doing nothing. Sorry.

  // The requested grid size was too large for GPU. This is expected
  // for some configurations.


///
/// Code Overview
///

 // Most of the code is in class Stream_Demo.  An overview is provied
 // below, see the respective routines for details.

 /// Stream_Demo::init (called from the constructor):
 //
 //  Calls CUDA_Device_Manager::init to print out info on GPUs.
 //  Allocates and initializes the input (a) and output (b) arrays,
 //    and other variables.
 //  Uses the CPU to compute and write the correct output to variable b_check.

 /// Stream_Demo::check
 //
 //  Checks whether the data in b (computed on the GPU) is correct.
 //  If not prints an error message.

 /// Stream_Demo::start
 //
 //  Runs the kernel on CUDA by calling Stream_Demo::run, it does
 //  so several times, varying grid size (blocks per multiprocessor).

 /// Stream_Demo::run
 //
 //  Runs the code on CUDA for a particular block and grid size, and
 //  prints timing data. The kernel is actually run 25 times in sets
 //  of 5. Each set of 5 runs starts with a transfer of data from the
 //  CPU to GPU, then the kernel is run 5 times (though using the same
 //  input data each time), finally data is transferred from the GPU
 //  to CPU. Timing is reported for the last set.  The code also
 //  checks the results computed on the GPU.
 //

#include <stdio.h>
#define NO_OPENGL
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "stream-2.cuh"

class CUDA_Device_Manager {
  //
  // Manage information about available GPUs.
  //
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

    // Print information about kernels.

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
  cudaEvent_t cuda_start_ce, cuda_stop_ce;  // Events for timing.

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<Vector2> a;  // Array of Vector2 structures, size not yet set.
  pCUDA_Memory<float> b;

  float *b_check;               // Correct output, used to check GPU.
  int array_size;

  void init(int argc, char **argv)
  {
    srand48(1);                   // Seed random number generator.


    /// Change device_number_requested to change GPU. Value should be 0 or 1.
    // Print information about GPUs and select one of them.
    //
    int device_number_requested = 1; // This will request the less-capable GPU.
    cuda_device_manager.init(device_number_requested);

    // Get information about the GPU in use.
    //
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
  }

  void check()
  {
    // Determine whether GPU data is correct.  Note that due to
    // differences in rounding, etc. GPU data may not exactly match
    // GPU data.

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

    // Get maximum block size for GPU.  In general, the
    // maximum block size for a particular kernel can be lower,
    // though not for the simple kernels used here.
    //
    const int max_block_size = cuda_prop->maxThreadsPerBlock;

    // Vary number of blocks per multiprocessor.
    //
    // A 0 means the maximum number of blocks (one iteration per thread).
    //
    int bl_per_mp[] = {1,2,4,8,0}; // Blocks per multiprocessor.
    int cnt = sizeof(bl_per_mp) / sizeof(bl_per_mp[0]);

    for ( int i=0; i<cnt; i++ )
      {
        // First argument of run is block size, second argument is blocks
        // per multiprocessor.
        //
        run(32,bl_per_mp[i]);
        run(64,bl_per_mp[i]);
        run(max_block_size>>1,bl_per_mp[i]);
        run(max_block_size,bl_per_mp[i]);
      }

  }

  void run(int block_size, int bl_per_mp = 1)
  {
    const int cpu_rounds = 5;
    const int gpu_rounds = 5;

    // Specify Launch Configuration
    //
    dim3 db, dg;  // Type is a three integer vector.

    // Set block size.  (Block size is db.x * db.y * db.z )
    //
    db.x = block_size;
    db.y = db.z = 1;

    // Set the grid size to get a particular number of blocks per
    // multiprocessor, or if bl_per_mp is zero use the maximum
    // number of blocks.
    //
    if ( bl_per_mp )
      dg.x = cuda_prop->multiProcessorCount * bl_per_mp;
    else
      dg.x = int(ceil(double(array_size) / db.x));
    dg.y = dg.z = 1;

    printf("GPU Rounds %d,  Grid Dim %6d,  Block Dim %4d,  BL/MP %7.1f,  "
           "TH/MP %7.0f\n",
           gpu_rounds, dg.x, db.x,
           double(dg.x)/cuda_prop->multiProcessorCount,
           double(dg.x)/cuda_prop->multiProcessorCount * db.x
           );

    if ( int(dg.x) > cuda_prop->maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        const double wall_all_start = time_wall_fp();

        a.to_cuda(); // Move input array to CUDA.

        // Start GPU timing at first kernel launch.
        //
        CE(cudaEventRecord(cuda_start_ce));

        // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
        //
        for ( int i=0; i<gpu_rounds; i++ ) dots_launch(dg,db);

        // End GPU timing at end of last kernel launch.
        //
        CE(cudaEventRecord(cuda_stop_ce));

        // Retrieve data from CUDA.
        //
        b.from_cuda();

        // End CPU timing after data back in CPU.
        //
        const double wall_all = time_wall_fp() - wall_all_start;

        // Retrieve GPU timing.
        //
        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        // Only show timing for the last set of kernel launches.
        //
        if ( cpu_round + 1 < cpu_rounds ) continue;

        const size_t data_size =
          gpu_rounds * array_size * ( sizeof(a[0]) + sizeof(b[0]) );

        printf("CUDA Time %6.3f ms  Throughput %11.3f MB/s\n",
               cuda_time_ms,
               data_size / ( cuda_time_ms * 1000 ));
        printf("Wall Time %6.3f ms  Throughput %11.3f MB/s\n",
               wall_all * 1000,
               data_size / ( wall_all * 1e6 ));

        // Make sure that GPU data is correct.
        //
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
