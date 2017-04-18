

 /// Show implementation of sorting on CUDA

#define NO_OPENGL
#include <stdio.h>
#include <assert.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include <nperf.h>
#include "radix-sort.cuh"
#include <vector>
using namespace std;

class Sort {
public:

  Sort(int argc, char **argv){ init(argc,argv); }

  GPU_Info gpu_info;
  vector<cudaEvent_t> cuda_ces;

  Radix_Sort_GPU_Constants dapp;

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

  pCUDA_Memory<int> scan_out;
  pCUDA_Memory<int> scan_r2;

  int grid_size;
  int array_size;               // Number of elements in array.
  int array_size_lg;            // ceil( log_2 ( array_size ) )

  void init(int argc, char **argv)
  {
    // Must be called before any CUDA API calls.
#   ifdef __P_CUDA_DEBUG__
    NPerf_init(false);
#   else
    NPerf_init(true);
#   endif

    gpu_info_print();

    const int dev = gpu_choose_index();
    CE(cudaSetDevice(dev));
    printf("Using GPU %d\n",dev);
    gpu_info.get_gpu_info(dev);
    kernels_get_attr(&gpu_info);

    // Collect performance data using a wrapper to NVIDIA CUPTI event
    // counter API.
    //
    NPerf_metric_collect("inst_executed");
    NPerf_metric_collect("eligible_warps_per_cycle");
    NPerf_metric_collect("gld_efficiency");
    NPerf_metric_collect("gst_efficiency");
    NPerf_metric_collect("shared_efficiency");
    NPerf_metric_collect("issue_slot_utilization");
    //
    // Note: The more metrics that are collected, the more times a kernel
    // will need to be run.

    // Prepare events used for timing.
    //
    const int max_digits = sizeof(Sort_Elt) * 8;
    cuda_ces.resize(max_digits);
    for ( auto& e: cuda_ces ) CE(cudaEventCreate(&e));

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

    const int num_mp = gpu_info.cuda_prop.multiProcessorCount;

    // Examine argument 1, block count, default is number of MPs.
    //
    const int arg1_int = argc < 2 ? num_mp : atoi(argv[1]);
    grid_size =
      arg1_int == 0 ? num_mp :
      arg1_int < 0  ? -arg1_int * num_mp : arg1_int;

    array_size_lg = argc > 2 ? atoi(argv[2]) : 20;

    //
    // Initialize Array Shape Variables
    //
    array_size = 1 << array_size_lg;

    dapp.array_size = array_size;
    dapp.array_size_lg = array_size_lg;

    const int ref_block_size = 256;
    const int ref_num_tiles =
      div_ceil( array_size, ref_block_size * elt_per_thread );
    const double ref_tiles_per_block = double(ref_num_tiles) / grid_size;

    printf("List size %d ( 0x%x )  Tiles / %d-thd Bl %.1f\n",
           array_size, array_size, ref_block_size, ref_tiles_per_block );

    sort_in.alloc(array_size);
    sort_out.alloc(array_size);
    sort_out_b.alloc(array_size);

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
    run_sort(6);
    run_sort(7);
    run_sort(8);
    run_sort(9);
    run_sort(10);
  }

  void run_sort(int block_lg)
  {
    const int block_size = 1 << block_lg;
    const int cpu_rounds = 1;
    const int num_mp = gpu_info.cuda_prop.multiProcessorCount;

    Kernel_Info& ki = gpu_info.ki[0];
    cudaFuncAttributes& cfa = ki.cfa;

    if ( block_size > cfa.maxThreadsPerBlock ) return;

    int sort_radix_lg = 4;
    int sort_radix = 1 << sort_radix_lg;
#define CPY(m) dapp.m = m;
    CPY(sort_radix_lg);
    CPY(sort_radix);
#undef CPY

    TO_DEV(dapp);

    scan_r2.realloc(array_size);
    scan_r2.ptrs_to_cuda("scan_r2");

    const int elt_per_tile = block_size * elt_per_thread;
    const int num_tiles = div_ceil( array_size, elt_per_tile );
    const int key_size_bits = 8 * sizeof(Sort_Elt);
    const int ndigits = div_ceil( key_size_bits, sort_radix_lg );

    const size_t thisto_array_size_bytes = sizeof(int) * sort_radix * num_tiles;
    const size_t bhisto_array_size_bytes = sizeof(int) * sort_radix * grid_size;

    sort_histo.realloc(bhisto_array_size_bytes);
    sort_histo.ptrs_to_cuda("sort_histo");
    sort_tile_histo.realloc(thisto_array_size_bytes);
    sort_tile_histo.ptrs_to_cuda("sort_tile_histo");

    const int shared_size_pass_1 = 0;
    const int shared_size_pass_2 = ( 3 * sort_radix + 1 ) * sizeof(int);

    const size_t size_keys_bytes = num_tiles * elt_per_tile * sizeof(Sort_Elt);

    const size_t comm_keys_bytes_pass_1 = size_keys_bytes * ndigits * 2;
    const size_t comm_keys_bytes_pass_2 = size_keys_bytes * ndigits * 2;
    const size_t comm_keys_bytes =
      comm_keys_bytes_pass_1 + comm_keys_bytes_pass_2;

    const size_t size_histo_bytes =
      ( num_tiles + 1 ) * sort_radix * sizeof(int);

    const size_t comm_histo_bytes_pass_1 = size_histo_bytes * ndigits;
    const size_t comm_histo_bytes_pass_2 = size_histo_bytes * ndigits;
    const size_t comm_histo_bytes =
      comm_histo_bytes_pass_1 + comm_histo_bytes_pass_2;

    const size_t comm_bytes = comm_keys_bytes + comm_histo_bytes;
    const size_t comm_bytes_pass_1 =
      comm_keys_bytes_pass_1 + comm_histo_bytes_pass_1;
    const size_t comm_bytes_pass_2 =
      comm_keys_bytes_pass_2 + comm_histo_bytes_pass_2;

    const size_t work_per_round_pass_1 = array_size * sort_radix_lg;
    const size_t work_per_round_pass_2 = array_size;
    const int block_per_mp = div_ceil( grid_size, num_mp );
    const int dynamic_sm_bytes = shared_size_pass_1;
    const int active_bl_per_mp_max =
      gpu_info.get_max_active_blocks_per_mp(0,block_size,dynamic_sm_bytes);
    const int warps_per_block = (31 + block_size ) >> 5;
    const int active_bl_per_mp = min(block_per_mp,active_bl_per_mp_max);
    const int active_wp = active_bl_per_mp * warps_per_block;

    printf("Grid Sz %3d,  Block Sz %3d,  BL/MP %2d,  Active WP %2d\n",
           grid_size, block_size, active_bl_per_mp, active_wp);

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        // Zero result array and send to GPU, to detect
        // skipped-element errors occurring after a prior invocation
        // wrote the correct results.
        //
        for ( int i=0; i<array_size; i++ ) sort_out_b[i] = sort_out[i] = 0;
        sort_out.to_cuda();
        sort_out_b.to_cuda();

        sort_in.to_cuda(); // Move input array to CUDA.

        NPerf_data_reset();
        const char* kname_1 = NULL;
        const char* kname_2 = NULL;

        uint next_ce_idx = 0;
        for ( int digit_pos = 0; digit_pos < ndigits;  digit_pos++ )
          {
            const bool first_iter = digit_pos == 0;
            const bool last_iter = digit_pos + 1 == ndigits;
            CE(cudaEventRecord(cuda_ces[next_ce_idx++]));
            sort_launch_pass_1
              ( grid_size, block_size, digit_pos, first_iter );
            kname_1 = NPerf_kernel_last_name_get();
            CE(cudaEventRecord(cuda_ces[next_ce_idx++]));
            sort_launch_pass_2
              ( grid_size, block_size, shared_size_pass_2,
                digit_pos, last_iter );
            kname_2 = NPerf_kernel_last_name_get();
          }
        CE(cudaEventRecord(cuda_ces[next_ce_idx++]));
        assert( next_ce_idx <= cuda_ces.size() );

        // Retrieve data from CUDA.
        //
        sort_out.from_cuda();

        double pass_1_ce_time_s = 0;
        double pass_2_ce_time_s = 0;

        for ( int pos = 0; pos < ndigits;  pos++ )
          {
            float cuda_time_ms;
            int p1_idx = pos * 2;
            CE(cudaEventElapsedTime
               ( &cuda_time_ms, cuda_ces[p1_idx], cuda_ces[p1_idx+1]) );
            pass_1_ce_time_s += cuda_time_ms * 1e-3;
            CE(cudaEventElapsedTime
               ( &cuda_time_ms, cuda_ces[p1_idx+1], cuda_ces[p1_idx+2]) );
            pass_2_ce_time_s += cuda_time_ms * 1e-3;
          }

        if ( cpu_round + 1 < cpu_rounds ) continue;

        const double pass_1_np_time_s = NPerf_kernel_et_get(kname_1) * ndigits;
        const double pass_2_np_time_s = NPerf_kernel_et_get(kname_2) * ndigits;

        const bool nperf_avail = NPerf_metrics_collection_get();

        const double pass_1_time_s =
          nperf_avail ? pass_1_np_time_s : pass_1_ce_time_s;
        const double pass_2_time_s =
          nperf_avail ? pass_2_np_time_s : pass_2_ce_time_s;
        const double rs_time_s = pass_1_time_s + pass_2_time_s;

        sort_tile_histo.from_cuda();
        sort_histo.from_cuda();
        sort_out_b.from_cuda();
        scan_out.from_cuda();
        scan_r2.from_cuda();

        for ( int tile = 0; tile < 4; tile ++ )
          {
            printf("T %2d: ",tile);
            const int idx_base = tile * sort_radix;
            for ( int i=0; i<8; i++ )
              {
                printf("%4d  ",sort_tile_histo[idx_base +i]);
              }
            printf("\n");
          }

        const double thpt_data_gbps = comm_bytes / rs_time_s * 1e-9;

        printf("Time %7.3f + %7.3f = %7.3f ms  Rate %7.3f G elt/s  "
               "Data Thpt %.1f GB/s\n",
               pass_1_time_s * 1e3, pass_2_time_s * 1e3, rs_time_s * 1e3,
               array_size / ( rs_time_s * 1e9 ),
               thpt_data_gbps);
        if ( nperf_avail )
          for ( auto ker : { kname_1, kname_2 } )
            {
              const bool pass_1 = ker == kname_1;
              const size_t work_per_round =
                pass_1 ? work_per_round_pass_1 : work_per_round_pass_2;
              const size_t comm_bytes =
                pass_1 ? comm_bytes_pass_1 : comm_bytes_pass_2;
              const double time_s = pass_1 ? pass_1_time_s : pass_2_time_s;
              printf
                ("Wp/Cy %4.1f  Eff Ld %3.0f%% St %3.0f%%  "
                 "Sh Eff %3.0f%%  I/W %2.0f  IS Util %5.1f%% %.1f GB/s\n",
                 NPerf_metric_value_get("eligible_warps_per_cycle",ker),
                 NPerf_metric_value_get("gld_efficiency",ker),
                 NPerf_metric_value_get("gst_efficiency",ker),
                 NPerf_metric_value_get("shared_efficiency", ker),
                 NPerf_metric_value_get("inst_executed", ker)
                 * 32 / work_per_round,
                 NPerf_metric_value_get("issue_slot_utilization", ker),
                 comm_bytes * 1e-9 / time_s
                 );
            }

        check_sort(block_size,array_size);

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
