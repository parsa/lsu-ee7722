

 /// Show implementation of sorting on CUDA

#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "sort.cuh"

cudaEvent_t cuda_start_ce, cuda_stop_ce;
cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).

double cuda_ips_get(cudaDeviceProp cuda_prop)
{
  const int peak_ipc =
  cuda_prop.major == 1 ? 8 :
    cuda_prop.major == 2 & cuda_prop.minor == 0 ? 32 :
    cuda_prop.major == 2 & cuda_prop.minor == 1 ? 48 : 0;

  return peak_ipc
    * 1000.0 * cuda_prop.multiProcessorCount * cuda_prop.clockRate;
}

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
        ("GPU %d: PEAK EXEC RATE: %7.3f GI/s\n",
         dev, cuda_ips_get(cuda_prop));

    }

  const int dev_prefer = 0;
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

typedef unsigned Sort_Elt;


class Sort {
public:

  Sort(int argc, char **argv){ init(argc,argv); }

  // Data Arrays.
  //
  // These classes automatically allocate storage on both CPU and GPU
  // and move data back and forth.
  //
  pCUDA_Memory<Sort_Elt> sort_in;     // Input array.
  pCUDA_Memory<Sort_Elt> sort_out;    // Output or intermediate array.
  pCUDA_Memory<Sort_Elt> sort_out_b;  // Output or intermediate array.
  pCUDA_Memory<int> sort_histo;       // Histogram bins.
  pCUDA_Memory<int> sort_tile_histo;  // First elt in tile with dig val.
  PSList<Sort_Elt,Sort_Elt> sort_check;

  pCUDA_Memory<int> scan_in;
  pCUDA_Memory<int> scan_out;
  pCUDA_Memory<int> scan_r2;

  int array_size;               // Number of elements in array.
  int array_size_lg;            // ceil( log_2 ( array_size ) )

  pCUDA_Func_Attributes *cuda_func_attr;
  int cuda_func_attr_count;

  void init(int argc, char **argv)
  {
    cuda_init();
    cuda_func_attr = cuda_func_attr_get(cuda_func_attr_count);

    srand48(1);                   // Seed random number generator.

    array_size_lg = argc > 1 ? atoi(argv[1]) : 20;

    //
    // Initialize Array Shape Variables
    //
    array_size = 1 << array_size_lg;

    printf("List size %d ( 0x%x )\n", array_size, array_size );

    sort_in.alloc(array_size);
    sort_out.alloc(array_size);
    sort_out_b.alloc(array_size);

    scan_in.alloc(array_size);
    scan_in.ptrs_to_cuda("scan_in");
    scan_out.alloc(array_size);
    scan_out.ptrs_to_cuda("scan_out");

    // Send address of array to a CUDA constant variable named "a".
    //
    sort_in.ptrs_to_cuda("sort_in");
    sort_out.ptrs_to_cuda("sort_out");
    sort_out_b.ptrs_to_cuda("sort_out_b");

    bzero(sort_out.data,array_size*sizeof(sort_out[0]));
    sort_out.to_cuda();

    const int db_friendly_offset = ( ( ( array_size_lg + 3 ) >> 2 ) + 1 ) << 2;

    // Initialize input arrays.
    //
    for ( int i=0; i<array_size; i++ )
      {
        const bool debug_friendly = false;
        if ( debug_friendly )
          {
            //  sort_in[i] = i << 1;
            //  sort_in[i] = ( ( random() & 0x5 ) << db_friendly_offset ) + i;
            sort_in[i] = ( ( random() & 0xf50 ) ) | 0x6000;
            //  sort_in[i] = -1;
              //  + i;
          }
        else
          {
            sort_in[i] = random();
          }
        sort_check.insert(sort_in[i],sort_in[i]);
      }
    sort_check.sort();

    // Send values of array size variables to CUDA.
    //
    TO_DEV(array_size);  TO_DEV(array_size_lg);

  }

  void check_sort(int block_size, int limit)
  {
    int err_count = 0;
    PSList<Sort_Elt,Sort_Elt> sort_check_short, re_sort_out;

    Sort_Elt* const sort_out_use = sort_out.data;

    for ( int i=0; i<limit; i++ )
      {
        re_sort_out.insert(sort_out_use[i],sort_out_use[i]);
        sort_check_short.insert(sort_in[i],sort_in[i]);
      }
    re_sort_out.sort();
    sort_check_short.sort();

    const int zlimit = 3;
    int run_count = 3;
    int zcount = 0;
    for ( int i=0; i<limit; i++ )
      {
        if ( sort_out_use[i] != 0 || i == limit - 1 )
          {
            if ( zcount )
              {
                printf("*** Total of %d zeros.\n",zcount);
                run_count--;
                if ( run_count < 0 ) break;
                zcount = 0;
              }
            continue;
          }
        zcount++;
        if ( zcount > zlimit ) continue;
        printf("*** Zero at 0x%x (%d)\n",i,i);
      }

    for ( int i=0; i<limit; i++ )
      {
        if ( re_sort_out[i] == sort_check_short[i] ) continue;
        printf("*** At element 0x%x, sorted mismatch %#010x != %#010x (c)\n",
               i, re_sort_out[i], sort_check_short[i]);
        break;
      }

#ifdef DEBUG_SORT
    int next_prefix = 0;
    int oerr_count = 5;
    int tile_count = array_size / ( 4 * block_size );
    for ( int bin =0; bin<16; bin++ )
      {
        for ( int tile=0; tile<tile_count; tile++ )
          {
            const int prefix = scan_out[tile * 16 + bin];
            const int count = sort_tile_histo[tile * 16 + bin];
            if ( prefix != next_prefix )
              {
                if ( oerr_count-- > 0 )
                printf("Wrong next prefix at tile %d, bin %d: %d != %d\n",
                       tile, bin, next_prefix, prefix);
              }
            next_prefix = prefix + count;
          }
      }

    PStack<int> expected_new_idx;
    int idx = 0;
    oerr_count = 5;
    int derr_count = 5;
    for ( int tile=0; tile<tile_count; tile++ )
      {
        for ( int bin =0; bin<16; bin++ )
          {
            const int prefix = scan_out[tile * 16 + bin];
            const int offset_local_c = scan_r2[tile * 16 + bin];
            const int count = sort_tile_histo[tile * 16 + bin];
            for ( int i = 0; i < count; i++ )
              {
                const uint val = sort_out[idx++];
                const int digit = -1;
                const int digit_idx = val & 0xfff;
                const int local_offset = val & 0xfff;
                const int new_idx = val >> 12;
                const int expect = prefix + i;
                if ( local_offset != offset_local_c )
                  if ( derr_count-- > 0 )
                    printf("Wrong local offset at tile %d, bin %d, i %d: "
                           "idx %d:  %d != %d (c)\n",
                           tile, bin, i, idx-1, local_offset, offset_local_c);
#if 0
                if ( digit_idx != i )
                  if ( derr_count-- > 0 )
                    printf("Wrong bin idx at tile %d, bin %d: idx %d:  %d != %d (c)\n",
                           tile, bin, idx-1, digit_idx, i);
                if ( digit >= 0 && digit != bin )
                  if ( derr_count-- > 0 )
                    printf("Wrong bin at tile %d, bin %d: idx %d:  %d != %d (c)\n",
                           tile, bin, idx-1, digit, bin);
#endif

                if ( new_idx != expect )
                  {
                    if ( oerr_count-- > 0 )
                      printf("Wrong idx at tile %d, bin %d: idx %d:  %d != %d (c)\n",
                             tile, bin, idx-1, new_idx, expect);
                  }
              }
          }
      }
#endif

    for ( int i=0; i<limit; i++ )
      {
        if ( sort_out_use[i] == sort_check_short[i] ) continue;
        printf("*** Incorrect result at %d  %#010x != %#010x (correct)\n",
               i, sort_out_use[i], sort_check_short[i]);
        if ( err_count++ > 15 ) return;
      }
  }

  void start()
  {
    //  run_sort(8,4,4); return;
    if ( true )
      {
        run_sort(8,4,2);
        run_sort(8,4,3);
        run_sort(6,4,4);
        run_sort(7,4,4);
        run_sort(8,3,4);
        return;
      }

    //  run(8,0,0);
    //  run_sort(6,4,4);
    //  run_sort(7,4,4);
    run_sort(6,4,0);
    run_sort(6,4,1);
    run_sort(6,4,2);
    run_sort(8,4,0);
    run_sort(8,4,1);
    run_sort(8,4,2);
    return;
    //
    run_sort(8,4,1);
    run_sort(8,4,2);
    run_sort(8,4,3);
    return;

  }

  void run_sort(int block_lg, int bl_per_mp = 1, int version = 2)
  {
    const int block_size = 1 << block_lg;
    const int cpu_rounds = 1;
    const int gpu_rounds = 1;

    if ( block_size > cuda_func_attr[version].attr.maxThreadsPerBlock ) return;

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

    TO_DEV(block_lg);

    int sort_bin_lg = 4;
    int sort_bin_size = 1 << sort_bin_lg;
    int sort_bin_mask = sort_bin_size - 1;
    int sort_bin_count = ( sizeof(Sort_Elt) * 8 ) >> sort_bin_lg;
    TO_DEV(sort_bin_lg);
    TO_DEV(sort_bin_size);
    TO_DEV(sort_bin_mask);
    TO_DEV(sort_bin_count);
    int sort_all_bin_count = sort_bin_count * dg.x;
    int sort_all_bin_lg = lg( sort_all_bin_count );
    TO_DEV(sort_all_bin_count);
    TO_DEV(sort_all_bin_lg);

    scan_r2.realloc(array_size);
    scan_r2.ptrs_to_cuda("scan_r2");

    int prefix_sum_array_size =
      int(ceil(sort_bin_size * array_size / ( 4.0 * dg.x )));
    sort_histo.realloc(prefix_sum_array_size);
    sort_histo.ptrs_to_cuda("sort_histo");
    sort_tile_histo.realloc(prefix_sum_array_size);
    sort_tile_histo.ptrs_to_cuda("sort_tile_histo");

    const int block_per_mp = 
      0.999 + double(dg.x)/cuda_prop.multiProcessorCount;
    const int warps_per_block = (31 + db.x ) >> 5;
    // Ignoring memory and regs.
    const int active_bl_per_mp_1 = min(block_per_mp,8);
    const int active_bl_by_warps = 48 / warps_per_block;
    const int active_bl_per_mp = min(active_bl_per_mp_1,active_bl_by_warps);
    const int active_wp = active_bl_per_mp * warps_per_block;

    printf("Grid Sz %3d,  Block Sz %3d,  BL/MP %.2f,  Active WP, %2d   %s\n",
           dg.x, db.x,
           double(dg.x)/cuda_prop.multiProcessorCount,
           active_wp,
           cuda_func_attr[version].name
           );

    if ( int(dg.x) > cuda_prop.maxGridSize[0] )
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
        for ( int i=0; i<array_size; i++ )
          sort_out_b[i] = sort_out[i] = 0;
        sort_out.to_cuda();
        sort_out_b.to_cuda();

        sort_in.to_cuda(); // Move input array to CUDA.

        // Launch Kernel  (Actually, call code in stream-kernel.cu to launch).
        //
        CE(cudaEventRecord(cuda_start_ce));

        for ( int i=0; i<gpu_rounds; i++ )
          sort_launch(dg,db,version,array_size,array_size_lg);

        CE(cudaEventRecord(cuda_stop_ce));

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        sort_out.from_cuda();

        float cuda_time_ms;
        CE(cudaEventElapsedTime(&cuda_time_ms,cuda_start_ce,cuda_stop_ce));

        if ( cpu_round + 1 < cpu_rounds ) continue;

        sort_tile_histo.from_cuda();
        sort_histo.from_cuda();
        sort_out_b.from_cuda();
        scan_out.from_cuda();
        scan_r2.from_cuda();

        if ( true ) for ( int tile = 0; tile < 4; tile ++ )
          {
            printf("T %2d: ",tile);
            const int idx_base = tile * sort_bin_size;
            for ( int i=0; i<8; i++ )
              {
                printf("%4d  ",sort_tile_histo[idx_base +i]);
              }
            printf("\n");
          }

        const double computation_insn = // Currently bogus!!
          gpu_rounds * double(array_size) * ( 0 + 3.0 );

        const double peak_insn = cuda_time_ms * 1e-3 * cuda_ips_get(cuda_prop);

        printf("CUDA Time %7.3f ms  Throughput %7.3f elt/s  Eff %.4f  "
               "Eff ac %.4f\n",
               cuda_time_ms,
               array_size / ( cuda_time_ms * 1e6 ),
               computation_insn / peak_insn,
               0.0
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
        check_sort(db.x,version==4?array_size:4*db.x);

      }
  }


};


int
main(int argc, char** argv)
{
  Sort sort(argc,argv);
  sort.start();
  return 0;
}
