

 /// Show implementation of matrix multiply on CUDA

#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "matrix-mult.cuh"

GPU_Info gpu_info;
cudaEvent_t cuda_start_ce, cuda_stop_ce;

void
cuda_init()
{
  // Print info about available GPUs.
  //
  gpu_info_print();

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  ASSERTS( device_count );

  const int dev_prefer = 1;
  const int dev = min(dev_prefer,device_count-1);

  printf("Using GPU %d\n",dev);
  CE(cudaSetDevice(dev));
  gpu_info.get_gpu_info(dev);

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&cuda_start_ce));
  CE(cudaEventCreate(&cuda_stop_ce));

  kernels_get_attr(gpu_info);

  printf("CUDA Routine Resource Usage:\n");

  for ( int i=0; i<gpu_info.num_kernels; i++ )
    {
      auto& ki = gpu_info.ki[i];
      printf(" %-20s:\n"
             "%6zd B shared,  %4zd B const,  %4zd B loc,  %3d regs; "
             "%4d max thr / block\n",
             ki.name,
             ki.cfa.sharedSizeBytes,
             ki.cfa.constSizeBytes,
             ki.cfa.localSizeBytes,
             ki.cfa.numRegs,
             ki.cfa.maxThreadsPerBlock);
    }
}

class Matrix_Mult {
public:

  Matrix_Mult(int argc, char **argv){ init(argc,argv); }

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<float> a;
  pCUDA_Memory<float> b;
  pCUDA_Memory<float> c;
  float *c_check;

  int row_cnt, row_stride, row_stride_lg;
  int col_cnt;

  int array_cnt;                // Number of elements
  int array_size;               // Amount of space in element units.

  //  int dim_size_lg;

  pCUDA_Memory<int32_t> t_compute;
  pCUDA_Memory<int32_t> t_all;

  void init(int argc, char **argv)
  {
    cuda_init();

    srand48(1);                   // Seed random number generator.

    const int dim_cnt_lg = argc > 1 ? atoi(argv[1]) : 8;

    //
    // Initialize Array Shape Variables
    //
    // For now both arrays are square and row count is a power of 2,
    // but prepare for non-square, non-power-of-2 arrays by having
    // separate variables such as row_stride and col_cnt.
    //
    const int array_size_lg = dim_cnt_lg << 1;
    array_cnt = array_size = 1 << array_size_lg;
    row_stride_lg = dim_cnt_lg;
    row_stride = 1 << row_stride_lg;
    row_cnt = col_cnt = row_stride;

    printf("Matrix Size %d x %d  ( 0x%x x 0x%x )\n",
           row_cnt, row_cnt, row_cnt, row_cnt);

    a.alloc(array_size);
    b.alloc(array_size);
    c.alloc(array_size);

    // Send address of array to a CUDA constant variable named "a".
    //
    a.ptrs_to_cuda("a");
    b.ptrs_to_cuda("b");
    c.ptrs_to_cuda("c");

    bzero(c.data,array_size*sizeof(c[0]));
    c.to_cuda();

    // Initialize input arrays.
    //
    for ( int i=0; i<array_size; i++ )
      {
        const int row = i >> row_stride_lg;
        const int col = i & ( row_stride - 1 );
        const bool debug_friendly = true;
        if ( debug_friendly )
          {
            a[i] = row + col / 1000.0;
            b[i] = row + col / 1000.0;
          }
        else
          {
            a[i] = drand48();
            b[i] = drand48();
          }
      }

    // Send values of array size variables to CUDA.
    //
    TO_DEV(array_size);  TO_DEV(array_size_lg);
    TO_DEV(row_stride);  TO_DEV(row_stride_lg);

    // Prepare cpu-side array for checking results.
    c_check = new float[array_size];
    bzero(c_check,array_size*sizeof(c_check[0]));
    matrix_mult_cpu(a.data,b.data,c_check);
  }

  void matrix_mult_cpu(float *a, float *b, float *c)
  {
    for ( int row = 0; row < row_cnt; row++ )
      {
        const int idx_base = row << row_stride_lg;

        for ( int col = 0; col < col_cnt; col++ )
          {
            const int c_idx = idx_base | col;
            float c_value = 0;

            for ( int k = 0; k < row_stride; k++ )
              {
                const int a_idx = idx_base | k;
                const int b_idx = ( k << row_stride_lg ) | col;
                c_value += a[a_idx] * b[b_idx];
              }

            c[c_idx] = c_value;
          }
      }
  }

  void check()
  {
    int err_count = 0;
    for ( int i=0; i<array_size; i++ )
      {
        const float diff = fabs( c[i] - c_check[i] );
        const double err_frac = c_check[i] > 0 ? diff / c_check[i] : diff;
        if ( err_frac > 0.00001 )
          {
            printf("*** Incorrect result at 0x%x  %.3f != %.3f (correct)\n",
                   i, c[i], c_check[i]);
            if ( err_count++ > 8 ) return;
          }
      }
  }

  void start()
  {
    int block_lg[] = {7,8};
    const int cnt = sizeof(block_lg) / sizeof(block_lg[0]);

    //  run(6,12,4); return;

    //  run(8,4,6); return;

    run(8,8,1);
    run(8,8,2);
    run(8,8,3);
    run(6,8,4);
    run(8,8,5);
#if 0
    run(8,6,5);
    run(8,8,5);
    run(6,8,6);
    run(8,8,6);
#endif
    //  run(6,8,5);
    return;

    run(8,2,3);
    run(8,4,3);
    run(6,1,4);
    run(6,2,4);
    run(6,4,4);
    run(6,8,4);

    return;

    if ( gpu_info.cuda_prop.major >= 2 )
      {
        run(8,1,4);
        run(8,2,4);
        run(8,4,4);
      }

    return;

    run(6,1,1); run(6,4,1);
    run(6,1,2);
    run(6,4,2);
    run(8,1,2);
    run(8,16,2);
    run(6,1,3);
    run(6,2,3);
    run(6,4,3);
    run(6,8,3);
    run(8,1,3);
    run(8,2,3);
    run(6,1,4);
    run(8,1,4);
    return;

    for ( int i=0; i<cnt; i++ )
      {
        run(block_lg[i],1,0);
        run(block_lg[i],8,0);
        run(block_lg[i],1,1);
        run(block_lg[i],8,1);
      }

  }

  void run(int block_lg, int bl_per_mp = 1, int version = 2)
  {
    const int block_size = 1 << block_lg;
    const int dim_block_lg = block_lg >> 1;
    const int cpu_rounds = 5;
    const int gpu_rounds = 5;
    void* const a_dev = a.get_dev_addr();
    void* const b_dev = b.get_dev_addr();

    if ( block_size > gpu_info.ki[version].cfa.maxThreadsPerBlock ) return;

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
      dg.x =
        min(grid_size_max,gpu_info.cuda_prop.multiProcessorCount * bl_per_mp);
    else
      dg.x = grid_size_max;
    dg.y = dg.z = 1;

    const int thread_count = dg.x * db.x;
    const int warp_count = thread_count >> 5;
    t_compute.realloc(warp_count);
    t_compute.ptrs_to_cuda("t_compute");
    t_all.realloc(warp_count);
    t_all.ptrs_to_cuda("t_all");

    TO_DEV(dim_block_lg);

    const int cs_itid_stride = dg.x << ( dim_block_lg + row_stride_lg );
    TO_DEV(cs_itid_stride);

    printf("Grid Dim %3d,  Block Dim %3d,  BL/MP %.2f,  %s\n",
           dg.x, db.x,
           double(dg.x)/gpu_info.cuda_prop.multiProcessorCount,
           gpu_info.ki[version].name
           );

    if ( int(dg.x) > gpu_info.cuda_prop.maxGridSize[0] )
      {
        printf("*** Maximum grid size exceeded, doing nothing. Sorry.\n");
        return;
      }

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {

        // Zero result array and send to GPU, to detect
        // skipped-element errors occurring after a prior invocation
        // wrote the correct results.
        //
        for ( int i=0; i<array_size; i++ ) c[i] = 0;
        c.to_cuda();

        a.to_cuda(); // Move input array to CUDA.
        b.to_cuda(); // Move input array to CUDA.

        // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
        //
        CE(cudaEventRecord(cuda_start_ce));

        for ( int i=0; i<gpu_rounds; i++ )
          mmult_launch(dg,db,version,a_dev,b_dev,array_size);
        CE(cudaEventRecord(cuda_stop_ce));

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        c.from_cuda();

        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        if ( cpu_round + 1 < cpu_rounds ) continue;

        t_compute.from_cuda();
        t_all.from_cuda();
        PSList<int,double> comp_ratios;
        for ( int i=0; i<t_compute.elements; i++ )
          comp_ratios.insert(double(t_compute[i])/max(1,t_all[i]),i);
        comp_ratios.sort();

        // Print something out to avoid compiler optimizing out everything.
        //
        const int sidx = min(block_size,array_size) - 1;
        if ( sidx == -1 )
          printf("Round %d.   Finished %d elements, element %d is %.5f\n",
                 cpu_round, array_size, sidx, b[sidx]);

        const double computation_flops =
          gpu_rounds * 2.0 * row_stride * array_size;

        const double computation_insn =
          gpu_rounds * double(array_size) * ( row_cnt + 3.0 );

        const double computation_insn_a_cached =
          gpu_rounds * double(array_size) *
          ( row_cnt // Computation
            + 1.0   // Write c elements.
            + max(1,row_cnt >> block_lg) // Read elements of a.
            + max(1,row_cnt >> dim_block_lg) // Read elements of b.
            );

        const double peak_insn = cuda_time_ms * 1e-3 * gpu_info.chip_sp_flops;

        printf("CUDA Time %7.3f ms  Throughput %7.3f GFlop/s  Eff %.4f  "
               "Eff ac %.4f\n",
               cuda_time_ms,
               computation_flops / ( cuda_time_ms * 1e6 ),
               computation_insn / peak_insn,
               computation_insn_a_cached / peak_insn
               );

#if 0
        printf("CUDA Time %6.3f ms  Throughput %7.3f GFlop/s  Cycles %d  "
               "Comp %.3f\n",
               cuda_time_ms,
               computation_flops / ( cuda_time_ms * 1e6 ),
               t_all[0],
               comp_ratios.get_key(t_compute.elements>>1)
               );
#endif
        check();

      }
  }
};


int
main(int argc, char** argv)
{
  Matrix_Mult matrix_mult(argc,argv);
  matrix_mult.start();
  return 0;
}
