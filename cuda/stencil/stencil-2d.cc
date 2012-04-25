

 /// Show implementatoin of simple 2D stencil program on  CUDA.

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
    }

  const int dev_prefer = 0;
  const int dev = min(dev_prefer,device_count-1);

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


class Stream_Demo {
public:

  Stream_Demo(int argc, char **argv){ init(argc,argv); }

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

  void init(int argc, char **argv)
  {
    cuda_init();

    srand48(1);                   // Seed random number generator.

    dim_size_lg = argc > 1 ? atoi(argv[1]) : 5;
    row_stride = 1 << dim_size_lg;
    array_size = 1 << ( dim_size_lg << 1 );

    a.alloc(array_size);  // Specify size of array.

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
    int block_lg[] = {7,8};
    const int cnt = sizeof(block_lg) / sizeof(block_lg[0]);

    for ( int i=0; i<cnt; i++ )
      {
        run(block_lg[i],1,false);
        run(block_lg[i],8,false);
        run(block_lg[i],1,true);
        run(block_lg[i],8,true);
      }

  }

  void run(int block_lg, int bl_per_mp = 1, bool shared = false)
  {
    const int block_size = 1 << block_lg;
    const int dim_block_lg = block_lg >> 1;
    const int cpu_rounds = 5;
    const int gpu_rounds = 5;
    const bool show_wall = false;
    if ( block_size > cuda_prop.maxThreadsPerBlock ) return;

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

    TO_DEV(dim_block_lg);

    printf("GPU Rounds %d,  Grid Dim %d,  Block Dim %d,  BL/MP %.2f,  "
           "Buffered %d\n",
           gpu_rounds, dg.x, db.x,
           double(dg.x)/cuda_prop.multiProcessorCount,
           shared
           );
    if ( int(dg.x) > cuda_prop.maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        for ( int i=0; i<array_size; i++ ) b[i] = 0;
        b.to_cuda();

        const double wall_all_start = time_wall_fp();

        a.to_cuda(); // Move input array to CUDA.

        // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
        //
        CE(cudaEventRecord(cuda_start_ce));

        for ( int i=0; i<gpu_rounds; i++ ) stencil_launch(dg,db,shared);
        CE(cudaEventRecord(cuda_stop_ce));

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        b.from_cuda();

        const double wall_all = time_wall_fp() - wall_all_start;

        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        if ( cpu_round + 1 < cpu_rounds ) continue;

        // Print something out to avoid compiler optimizing out everything.
        //
        const int sidx = min(block_size,array_size) - 1;
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
