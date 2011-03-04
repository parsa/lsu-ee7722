/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 2

 ///
 /// Instructions
 ///

 // First read the assignment at:
 //
 //  http://www.ece.lsu.edu/koppel/gp/2011/hw02.pdf

 // Before solving the problems familiarize yourself with this code.

 ///
 /// Code Description
 ///

 // This code is a simple example of a 2 dimensional stencil program
 // implemented in CUDA. It is intended to demonstrate basic
 // techniques for programming in CUDA and to serve as a template for
 // Homework 2 (Spring 2011).

 // The code computes the function (kernel) over most elements of a
 // 2-dimensional array. It is not computed for the first and last
 // row and column. (The code for skipping these edge cases does not
 // appear below.)
 //
 //       int iu = idx - row_stride;
 //       int id = idx + row_stride;
 //       b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] + a[iu] + a[id] )
 //                + v2 * ( a[iu-1] + a[iu+1] + a[id-1] + a[id+1] );
 //
 // This computation is done in five places, in this file in routine
 // stencil_cpu (performed to check CUDA's results), and in four
 // CUDA kernels, stencil, stencil_iter, stencil_shared, and
 // stencil_shared_2.  

 // Kernel stencil_iter is the naive version first presented in class,
 // in which no shared memory is used thus forcing each element to
 // be read 9 times from memory (on devices without a cache).
 //
 // Kernel stencil_shared is the one presented in class in which
 // shared memory is used.  Kernel stencil_shared_2 is identical, but
 // is to be modified to solve the problem.



#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "stencil-2d.cuh"

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

      printf
        ("GPU %d: INSN BANDWIDTH: %7.3f GI/s\n",
         dev,
         ( cuda_prop.major == 1 ? 8 : cuda_prop.major == 2 ? 32 : 0 )
         * cuda_prop.multiProcessorCount * cuda_prop.clockRate/1e6);

    }

  const int dev_prefer = 1;
  const int dev = min(dev_prefer,device_count-1);

  printf("Using GPU %d\n",dev);
  CE(cudaSetDevice(dev));
  CE(cudaGetDeviceProperties(&cuda_prop,dev));

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&cuda_start_ce));
  CE(cudaEventCreate(&cuda_stop_ce));
}


pCUDA_Func_Attributes*
cuda_func_attr_get(int &count)
{
  pCUDA_Func_Attributes *func_attr;
  count = kernels_get_attr(&func_attr);

  printf("CUDA Routine Resource Usage:\n");

  for ( int i=0; i<count; i++ )
    {
      pStringF err_txt("Err %d",func_attr[i].err);
      printf(" %-20s: %s\n"
             "%6zd B shared,  %zd B const,  %zd B loc,  %d regs; "
             "%d max thr / block\n",
             func_attr[i].name,
             func_attr[i].err ? err_txt.s : "",
             func_attr[i].attr.sharedSizeBytes,
             func_attr[i].attr.constSizeBytes,
             func_attr[i].attr.localSizeBytes,
             func_attr[i].attr.numRegs,
             func_attr[i].attr.maxThreadsPerBlock);
    }
  return func_attr;
}


class Stencil_Demo {
public:

  Stencil_Demo(int argc, char **argv){ init(argc,argv); }

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<float> a;
  pCUDA_Memory<float> b;
  float v0, v1, v2;
  float *b_check;
  int dim_size_lg;
  int array_size;
  int row_stride;

  pCUDA_Func_Attributes *cuda_func_attr;
  int cuda_func_attr_count;
  pCUDA_Func_Attributes*
  func_attr_lookup(char version)
  {
    for ( int i=0; i<cuda_func_attr_count; i++ )
      if ( cuda_func_attr[i].abbrev == version ) return &cuda_func_attr[i];
    return NULL;
  }

  void init(int argc, char **argv)
  {
    cuda_init();
    cuda_func_attr = cuda_func_attr_get(cuda_func_attr_count);

    srand48(1);                   // Seed random number generator.

    dim_size_lg = argc > 1 ? atoi(argv[1]) : 10;
    row_stride = 1 << dim_size_lg;
    array_size = 1 << ( dim_size_lg << 1 );

    a.alloc(array_size);  // Specify size of array.

    printf("Running on array size %d x %d.\n",row_stride,row_stride);

    // Send address of array to a CUDA constant variable named "a".
    //
    a.ptrs_to_cuda("a");

    b.alloc(array_size);
    bzero(b.data,array_size*sizeof(b_check[0]));
    b.ptrs_to_cuda("b");
    b.to_cuda();

    // Initialize input array.
    //
    for ( int i=0; i<array_size; i++ ) a[i] = drand48();

    // Initialize coefficients and send them to CUDA.
    //
    v0 = 0.5;  v1 = 0.3/4.0;  v2 = 0.2/4.0;

    // Send value of v0-v2 and array_size to CUDA.
    //
    TO_DEV(v0);  TO_DEV(v1);  TO_DEV(v2);  TO_DEV(array_size);
    TO_DEV(row_stride);  TO_DEV(dim_size_lg);

    // Prepare cpu-side array for checking results.
    b_check = new float[array_size];
    bzero(b_check,array_size*sizeof(b_check[0]));
    stencil_cpu(a.data,b_check);
  }

  void stencil_cpu(float *a, float *b)
  {
    for ( int row = 1; row < row_stride-1; row++ )
      {
        const int col_base = row << dim_size_lg;
        for ( int col = 1; col < row_stride-1; col++ )
          {
            const int idx = col_base | col;
            const int iu = idx - row_stride;   // Index Up
            const int id = idx + row_stride;   // Index Down
#ifdef DEBUG_STENCIL
            b[idx] = v0 * a[idx];
#else
            b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] + a[iu] + a[id] )
              + v2 * ( a[iu-1] + a[iu+1] + a[id-1] + a[id+1] );
#endif
          }
      }
  }

  void check()
  {
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
    int block_lg[] = {7,8,9,10};
    const int cnt = sizeof(block_lg) / sizeof(block_lg[0]);

    // Reorganize this code as needed.

    for ( int i=0; i<cnt; i++ )
      {
        run(block_lg[i],1,'i');
        run(block_lg[i],2,'i');
        run(block_lg[i],4,'i');
      }
    for ( int i=0; i<cnt; i++ )
      {
        run(block_lg[i],1,'s');
        run(block_lg[i],2,'s');
        run(block_lg[i],4,'s');
      }

  }

  void run(int block_lg, int bl_per_mp = 1, char version = 'i' )
  {
    const int block_size = 1 << block_lg;
    const int dim_block_lg = block_lg >> 1;
    const int cpu_rounds = 5;
    const int gpu_rounds = 5;
    pCUDA_Func_Attributes* const func_attr = func_attr_lookup(version);
    if ( block_size > func_attr->attr.maxThreadsPerBlock ) return;

    // Specify Launch Configuration
    //
    dim3 db, dg;

    // Specify block size.  (Block size is db.x * db.y * db.z )
    //
    db.x = block_size;
    db.y = db.z = 1;

    const int grid_size_max = int(ceil(double(array_size) / db.x));

    // Prepare for the number of blocks to array_size / block_size.
    //
    if ( bl_per_mp )
      dg.x = min(grid_size_max,cuda_prop.multiProcessorCount * bl_per_mp);
    else
      dg.x = grid_size_max;
    dg.y = dg.z = 1;

    int shared_bytes;
    switch ( version ){
    case 'i': shared_bytes = 0; break;
    case 's': shared_bytes = 3 * db.x * sizeof(float); break;
    default:
      shared_bytes = 1000000; // Force an error if value used.
    }

    TO_DEV(dim_block_lg);

    printf("Block Dim %4d,  BL/MP %6.2f,  Shared %5lu,  "
           "Version %s\n",
           db.x,
           double(dg.x)/cuda_prop.multiProcessorCount,
           shared_bytes + func_attr->attr.sharedSizeBytes,
           func_attr->name
           );
    if ( int(dg.x) > cuda_prop.maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        // Zero output data and send to CUDA.  This is only necessary
        // to check for errors in versions that write nothing that run
        // after one that writes the correct results.
        //
        for ( int i=0; i<array_size; i++ ) b[i] = 0;
        b.to_cuda();

        a.to_cuda(); // Move input array to CUDA.

        CE(cudaEventRecord(cuda_start_ce));

        for ( int i=0; i<gpu_rounds; i++ )
          stencil_launch(dg,db,shared_bytes,version);

        CE(cudaEventRecord(cuda_stop_ce));

        // Retrieve data from CUDA.
        //
        b.from_cuda();

        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        if ( cpu_round + 1 < cpu_rounds ) continue;

        const size_t data_size =
          gpu_rounds * array_size * ( sizeof(a[0]) + sizeof(b[0]) );

        printf("CUDA Time %6.3f ms  Throughput %11.3f MB/s\n",
               cuda_time_ms,
               data_size / ( cuda_time_ms * 1000 ));
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
