

 /// Show implementation of sorting on CUDA

#define NO_OPENGL
#include <stdio.h>
#include <assert.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include <nperf.h>
#include "radix-sort.cuh"
#include <vector>
#include <algorithm>
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

  // Variables below are valid only during the current run.
  //
  int thisto_array_size_elts;
  int bhisto_array_size_elts;

  // Shadow Sort
  vector<Sort_Elt> ss_keys_1, ss_keys_2;
  vector<int> ss_thisto, ss_bhisto;

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
            sort_in[i] = random() | 1;
          }
        sort_check.insert(sort_in[i],sort_in[i]);
      }
    sort_check.sort();
  }

  void shadow_sort_init(int block_size)
  {
    if ( ss_keys_1.size() != size_t(array_size) )
      {
        ss_keys_1.resize(array_size);
        ss_keys_2.resize(array_size);
      }

    for ( int i=0; i<array_size; i++ ) ss_keys_2[i] = sort_in[i];
    ss_thisto.resize(dapp.thisto_array_size_elts);
    ss_bhisto.resize(dapp.bhisto_array_size_elts);

  }

  void shadow_sort_advance(int digit_pos)
  {
    const int bit_pos = digit_pos * dapp.radix_lg;
    const int elt_per_tile = dapp.elt_per_tile;
    const int radix = dapp.radix;
    const Sort_Elt ss_digit_mask = radix - 1;
    const Sort_Elt digit_mask = ss_digit_mask << bit_pos;
    const int tiles_per_block = div_ceil(dapp.num_tiles,grid_size);
    ss_keys_1 = ss_keys_2;
    Sort_Elt* const all_keys = ss_keys_1.data();
    int* const all_thisto = ss_thisto.data();
    int* const all_bhisto = ss_bhisto.data();
    for ( auto& e: ss_bhisto ) e = 0;

    for ( int tile_idx = 0; tile_idx < dapp.num_tiles; tile_idx++ )
      {
        Sort_Elt* const keys = all_keys + tile_idx * elt_per_tile;
        stable_sort( keys, keys + elt_per_tile,
                     [&] (Sort_Elt a, Sort_Elt b)
                     { return ( a & digit_mask ) < ( b & digit_mask ); } );
        int* const thisto = all_thisto + tile_idx * radix;
        int* const bhisto =
          all_bhisto + (tile_idx/tiles_per_block) * radix;
        for ( int d=0; d<radix; d++ ) thisto[d] = 0;
        for ( int i=0; i<elt_per_tile; i++ )
          thisto[ keys[i] >> bit_pos & ss_digit_mask ]++;
        for ( int d=0; d<radix; d++ ) bhisto[d] += thisto[d];
      }
    vector<int> ghisto(radix);
    for ( auto& e: ghisto ) e = 0;
    for ( int i=0; i<grid_size; i++ )
      for ( int d=0; d<radix; d++ )
        ghisto[d] += ss_bhisto[i*radix+d];
    vector<int> psum(radix);
    psum[0] = 0;
    for ( int d=1; d<radix; d++ ) psum[d] = psum[d-1] + ghisto[d-1];
    const Sort_Elt ss_unused_key = 0;
    for ( auto& e: ss_keys_2 ) e = ss_unused_key;
    for ( int idx = 0;  idx < array_size;  idx++ )
      {
        Sort_Elt key = ss_keys_1[idx];
        Sort_Elt digit = key >> bit_pos & ss_digit_mask;
        const int idx_next = psum[digit]++;
        assert( ss_keys_2[idx_next] == ss_unused_key );
        ss_keys_2[idx_next] = key;
      }
  }

  void shadow_sort_check_pass_1(int digit_pos)
  {
    sort_tile_histo.from_cuda();
    sort_histo.from_cuda();
    sort_out_b.from_cuda();

    int terr_count = 0;
    int berr_count = 0;
    int serr_count = 0;

    for ( int i = 0;  i < dapp.thisto_array_size_elts;  i++ )
      {
        if ( sort_tile_histo[i] == ss_thisto[i] ) continue;
        if ( terr_count++ > 10 ) continue;
        printf("D%dp1,  Digit %3d,  Tile %4d error: "
               "%3d != %3d (correct)\n",
               digit_pos,  i % dapp.radix, i / dapp.radix,
               sort_tile_histo[i], ss_thisto[i]);
      }
    for ( int i = 0;  i < dapp.bhisto_array_size_elts;  i++ )
      {
        if ( sort_histo[i] == ss_bhisto[i] ) continue;
        if ( berr_count++ > 10 ) continue;
        printf("D%dp1,  Digit %3d,  Block %4d error: "
               "%3d != %3d (correct)\n",
               digit_pos,  i % dapp.radix, i / dapp.radix,
               sort_histo[i], ss_bhisto[i]);
      }
    for ( int i=0; i<array_size; i++ )
      {
        if ( sort_out_b[i] == ss_keys_1[i] ) continue;
        if ( serr_count++ > 10 ) continue;
        printf("D%dp1,  TPos %3d,  Tile %4d error: "
               "%#11x != %#11x (correct)\n",
               digit_pos,  i % dapp.elt_per_tile, i / dapp.elt_per_tile,
               sort_out_b[i], ss_keys_1[i]);

      }

    assert( terr_count == 0 );
    assert( berr_count == 0 );
    assert( serr_count == 0 );
  }

  void shadow_sort_check_pass_2(int digit_pos)
  {
    sort_out.from_cuda();

    int serr_count = 0;
    const int tiles_per_block = div_ceil(dapp.num_tiles,grid_size);
    const int elt_per_block = tiles_per_block * dapp.elt_per_tile;

    for ( int i=0; i<array_size; i++ )
      {
        if ( sort_out[i] == ss_keys_2[i] ) continue;
        if ( serr_count++ > 10 ) continue;
        printf("D%dp2, B %2d  TPos %3d,  Tile %4d  %3d error: "
               "%#11x != %#11x (cor)\n",
               digit_pos, i/elt_per_block,
               i % dapp.elt_per_tile,
               i / dapp.elt_per_tile,
               i / dapp.elt_per_tile % tiles_per_block,
               sort_out[i], ss_keys_2[i]);

      }

    assert( serr_count == 0 );
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
    for ( int b=6; b<=10; b++ )
      for ( int r: {4,6,8} )
        run_sort(b,r);
  }

  void run_sort(int block_lg, int sort_radix_lg)
  {
    const int block_size = 1 << block_lg;
    const int cpu_rounds = 1;
    const int num_mp = gpu_info.cuda_prop.multiProcessorCount;

    Kernel_Info& ki = gpu_info.ki[0];
    cudaFuncAttributes& cfa = ki.cfa;

    if ( block_size > cfa.maxThreadsPerBlock ) return;

    const int sort_radix = 1 << sort_radix_lg;

    dapp.radix_lg = sort_radix_lg;
    dapp.radix = sort_radix;

    scan_r2.realloc(array_size);
    scan_r2.ptrs_to_cuda("scan_r2");

    dapp.elt_per_tile = block_size * elt_per_thread;
    const int num_tiles = dapp.num_tiles =
      div_ceil( array_size, dapp.elt_per_tile );
    const int key_size_bits = 8 * sizeof(Sort_Elt);
    const int ndigits = div_ceil( key_size_bits, sort_radix_lg );

    dapp.thisto_array_size_elts = sort_radix * num_tiles;
    dapp.bhisto_array_size_elts = sort_radix * grid_size;
    const size_t thisto_array_size_bytes =
      sizeof(sort_tile_histo[0]) * dapp.thisto_array_size_elts;
    const size_t bhisto_array_size_bytes =
      sizeof(sort_histo[0]) * dapp.bhisto_array_size_elts;

    sort_histo.realloc(bhisto_array_size_bytes);
    sort_histo.ptrs_to_cuda("sort_histo");
    sort_tile_histo.realloc(thisto_array_size_bytes);
    sort_tile_histo.ptrs_to_cuda("sort_tile_histo");

    const size_t size_keys_bytes =
      num_tiles * dapp.elt_per_tile * sizeof(Sort_Elt);

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
    const int active_bl_per_mp_max =
      gpu_info.get_max_active_blocks_per_mp(0,block_size,0);
    const int warps_per_block = (31 + block_size ) >> 5;
    const int active_bl_per_mp = min(block_per_mp,active_bl_per_mp_max);
    const int active_wp = active_bl_per_mp * warps_per_block;

    printf("Radix Lg %2d,  Grid Sz %3d,  Block Sz %3d,  BL/MP %2d,  "
           "Active WP %2d\n",
           sort_radix_lg, grid_size, block_size, active_bl_per_mp, active_wp);

    TO_DEV(dapp);
    const bool ss_check = true;

    for ( int cpu_round=0; cpu_round<cpu_rounds; cpu_round++ )
      {
        if ( ss_check ) shadow_sort_init(block_size);

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

            if ( ss_check ) shadow_sort_advance(digit_pos);

            CE(cudaEventRecord(cuda_ces[next_ce_idx++]));
            sort_launch_pass_1
              ( grid_size, block_size, sort_radix_lg, digit_pos, first_iter );
            kname_1 = NPerf_kernel_last_name_get();

            if ( ss_check ) shadow_sort_check_pass_1(digit_pos);

            CE(cudaEventRecord(cuda_ces[next_ce_idx++]));
            sort_launch_pass_2
              ( grid_size, block_size, sort_radix_lg, digit_pos, last_iter );
            kname_2 = NPerf_kernel_last_name_get();

            if ( ss_check ) shadow_sort_check_pass_2(digit_pos);
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

        assert( is_sorted( ss_keys_2.begin(), ss_keys_2.end() ) );

        for ( int tile = 0; tile < 4; tile ++ )
          {
            int bin_sum = 0;
            printf("T %2d: ",tile);
            const int idx_base = tile * sort_radix;
            for ( int i=0; i<8; i++ )
              {
                printf("%4d  ",sort_tile_histo[idx_base +i]);
              }
            for ( int i=0; i<sort_radix; i++ )
              bin_sum += sort_tile_histo[ idx_base + i ];
            printf("  Sum = %d\n",bin_sum);
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
