

 /// Show implementation of sorting on CUDA

#define NO_OPENGL
#include <stdio.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include "sort.cuh"
#include <ptable.h>


typedef unsigned Sort_Elt;


class Sort {
public:

  Sort(int argc, char **argv){ init(argc,argv); }

  GPU_Info gpu_info;
  cudaEvent_t cuda_start_ce, cuda_stop_ce;
  static const int max_gpu_rounds = 4;
  cudaEvent_t cuda_ce[max_gpu_rounds+1];

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

  pTable table;

  void init(int argc, char **argv)
  {
    gpu_info_print();

    const int dev = gpu_choose_index();
    CE(cudaSetDevice(dev));
    printf("Using GPU %d\n",dev);
    gpu_info.get_gpu_info(dev);
    kernels_get_attr(&gpu_info);

    // Prepare events used for timing.
    //
    CE(cudaEventCreate(&cuda_start_ce));
    CE(cudaEventCreate(&cuda_stop_ce));
    for ( auto& ce: cuda_ce ) CE( cudaEventCreate( &ce ) );

    // Print information about kernel.
    //
    printf("\nCUDA Kernel Resource Usage:\n");

    for ( int i=0; i<gpu_info.num_kernels; i++ )
      {
        printf("For %s:\n", gpu_info.ki[i].name);
        printf("  %6zd shared, %zd const, %zd loc, %d regs; "
               "%d max threads per block.\n",
               gpu_info.ki[i].cfa.sharedSizeBytes,
               gpu_info.ki[i].cfa.constSizeBytes,
               gpu_info.ki[i].cfa.localSizeBytes,
               gpu_info.ki[i].cfa.numRegs,
               gpu_info.ki[i].cfa.maxThreadsPerBlock);
      }


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
    table.stream = stdout;
    if ( false )
      {
        // Run just 1-bit-split block sort.
        //  run_sort(8,4,4); return;

        //  run_sort(2,4,0); run_sort(3,4,0); run_sort(4,4,0); run_sort(5,4,0);
        run_sort(6,4,0);
        //  run_sort(7,4,0);
        run_sort(8,4,0);
        return;
      }

    if ( false )
      {
        run_sort(6,16,4);
        run_sort(7,16,4);
        run_sort(8,16,4);
        return;
      }

    for ( int bl = 6;  bl <= 10;  bl++ )
      {
        run_sort(bl,1,0);
        run_sort(bl,1,1);
        run_sort(bl,1,2);
        run_sort(bl,1,3);
        for ( int elt_per_thread_lg: {0,1,2,3} )
          {
            const int bl_lg = bl + 3 - elt_per_thread_lg;
            if ( bl_lg > 10 ) continue;
            run_sort(bl_lg,1,4,elt_per_thread_lg);
          }
      }

    return;

    run_sort(6,4,0);
    run_sort(6,4,1);
    run_sort(6,4,2);
    run_sort(6,4,3);
    run_sort(6,4,4);


    run_sort(8,4,0);
    run_sort(8,4,1);
    run_sort(8,4,2);
    run_sort(8,4,3);
    run_sort(8,4,4);

    run_sort(10,2,0);
    run_sort(10,2,1);
    run_sort(10,2,2);
    run_sort(10,2,3);
    run_sort(10,2,4);

    run_sort(10,1,0);
    run_sort(10,1,1);
    run_sort(10,1,2);
    run_sort(10,1,3);
    run_sort(10,1,4);

    return;
    //
    run_sort(8,4,1);
    run_sort(8,4,2);
    run_sort(8,4,3);
    return;

  }

  void run_sort(int block_lg, int bl_per_mp = 1, int version = 3,
                int elt_per_thread_lg = 2)
  {
    const int elt_per_thread = 1 << elt_per_thread_lg;
    const int block_size = 1 << block_lg;
    const int cpu_rounds = 1;
    const int gpu_rounds = 3;
    assert( gpu_rounds <= max_gpu_rounds );

    Kernel_Info& ki = gpu_info.ki[version];
    cudaFuncAttributes& cfa = ki.cfa;
    cudaDeviceProp& cuda_prop = gpu_info.cuda_prop;

    if ( block_size > cfa.maxThreadsPerBlock ) return;

    // Specify Launch Configuration
    //
    dim3 db, dg;
    dim3 dg0; dg0.x = dg0.y = dg0.z = 0;

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
    const int dynamic_sm_bytes =
      sort_launch(dg0,db,version,array_size,array_size_lg); // Hack.
    const int active_bl_per_mp_max =
      gpu_info.get_max_active_blocks_per_mp(version,db.x,dynamic_sm_bytes);
    const int warps_per_block = (31 + db.x ) >> 5;
    const int active_bl_per_mp = min(block_per_mp,active_bl_per_mp_max);
    const int active_wp = active_bl_per_mp * warps_per_block;

    const int elt_per_block = elt_per_thread << block_lg;

    int sort_total_rounds = 0;

    switch ( version ) {
    case 0: case 1:// 1-bit split
      sort_total_rounds = 32; break;
    case 2: case 3: case 4: // Batcher
      sort_total_rounds =
        ( block_lg + elt_per_thread_lg ) * ( block_lg + elt_per_thread_lg );
      break;
    default:
      sort_total_rounds = 0;
    }

    table.row_start();
    table.entry("wp",warps_per_block);
    table.entry("ac",active_wp);
    table.entry("tl",elt_per_thread_lg);

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

        for ( int i=0; i<gpu_rounds; i++ )
          {
            CE( cudaEventRecord(cuda_ce[i]) );
            // Launch Kernel
            //
            sort_launch
              (dg,db,version,array_size,array_size_lg,elt_per_thread_lg);
            //
            // (Actually, call code in stream-kernel.cu to launch).
          }

        CE( cudaEventRecord(cuda_ce[gpu_rounds]) );

        // When execution reaches this point kernel has completed.

        // Retrieve data from CUDA.
        //
        sort_out.from_cuda();

        CE( cudaEventSynchronize( cuda_ce[gpu_rounds] ) );

        float cuda_time_ms = -1;
        for ( int i=0; i<gpu_rounds; i++ )
          {
            float time_ms;
            CE(cudaEventElapsedTime(&time_ms,cuda_ce[i],cuda_ce[i+1]));
            if ( i == 0 || time_ms < cuda_time_ms ) cuda_time_ms = time_ms;
        }

        if ( cpu_round + 1 < cpu_rounds ) continue;

        sort_tile_histo.from_cuda();
        sort_histo.from_cuda();
        sort_out_b.from_cuda();
        scan_out.from_cuda();
        scan_r2.from_cuda();

        if ( false && version == 4 ) for ( int tile = 0; tile < 4; tile ++ )
          {
            printf("T %2d: ",tile);
            const int idx_base = tile * sort_bin_size;
            for ( int i=0; i<8; i++ )
              {
                printf("%4d  ",sort_tile_histo[idx_base +i]);
              }
            printf("\n");
          }

        table.entry("t/ms","%7.3f", cuda_time_ms);
        table.entry("G elt/s","%7.3f", array_size / ( cuda_time_ms * 1e6 ));
        table.entry("M elt/s","%6.2f",
                    elt_per_block * active_bl_per_mp / ( cuda_time_ms * 1e3 ));
        table.entry("Per R","%8.4f",
                    1e3 * cuda_time_ms / sort_total_rounds);
        table.entry("K Name",ki.name);
        table.row_end();

#if 0
        printf("CUDA Time %6.3f ms  Throughput %7.3f GFlop/s  Cycles %d  "
               "Comp %.3f\n",
               cuda_time_ms,
               computation_flops / ( cuda_time_ms * 1e6 ),
               t_all[0],
               comp_ratios.get_key(t_compute.elements>>1)
               );
#endif
        check_sort(db.x,version==5?array_size:elt_per_thread*db.x);

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
