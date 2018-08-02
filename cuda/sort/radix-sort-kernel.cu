/// LSU EE 7722 GPU Microarchitecture
//

#include "radix-sort.cuh"
#include <gp/cuda-util-kernel.h>
#include <assert.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//

__constant__ Radix_Sort_GPU_Constants dapp;

__device__ int lg_ceil(uint n)
{
  if ( n == 0 ) return 0;
  return 32 - __clz(n-1);
}

__constant__ Sort_Elt *sort_in, *sort_out, *sort_out_b;
__constant__ int *sort_tile_histo;
__constant__ int *sort_histo;

template <int BLOCK_LG, int RADIX_LG>
__global__ void radix_sort_pass_1(int digit_pos, bool first_iter);
template <int BLOCK_LG, int RADIX_LG>
__global__ void radix_sort_pass_2(int digit_pos, bool last_iter);

__host__ void
kernels_get_attr(GPU_Info *gpu_info)
{
  CU_SYM(dapp);

  CU_SYM(sort_in); CU_SYM(sort_out); CU_SYM(sort_out_b);
  CU_SYM(sort_tile_histo);
  CU_SYM(sort_histo);

#define GETATTR(func) gpu_info->GET_INFO(func)

#define GAPAIR(block_lg,radix_lg)                                             \
  GETATTR((radix_sort_pass_1<block_lg,radix_lg>));                          \
  GETATTR((radix_sort_pass_2<block_lg,radix_lg>));

#define GASET(radix_lg)                                                       \
  GAPAIR(5,radix_lg); GAPAIR(6,radix_lg); GAPAIR(7,radix_lg);                 \
  GAPAIR(8,radix_lg); GAPAIR(9,radix_lg); GAPAIR(10,radix_lg);

  GASET(4);
  GASET(5);
  GASET(6);
  GASET(8);
#undef GETATTR
#undef GASET
#undef GAPAIR
}

typedef void (*KPtr)(int,bool);

// This routine executes on the CPU.
//
__host__ Kernel_Info*
sort_launch_pass_1
(GPU_Info *gpu_info, int dg, int db,
 int radix_lg, int digit_pos, bool first_iter)
{

#define LAUNCH_RD(BLG,RD_LG)                                                  \
  case 1<<BLG: kfunc = radix_sort_pass_1<BLG,RD_LG>; break;

#define LAUNCH_BLKS(RD_LG)                                                    \
    case RD_LG: switch ( db ){                                                \
      LAUNCH_RD(5,RD_LG); LAUNCH_RD(6,RD_LG); LAUNCH_RD(7,RD_LG);             \
      LAUNCH_RD(8,RD_LG); LAUNCH_RD(9,RD_LG); LAUNCH_RD(10,RD_LG);            \
    default: assert( false );                                                 \
    } break;

    KPtr kfunc = NULL;

    switch ( radix_lg ) {
      LAUNCH_BLKS(4);
      LAUNCH_BLKS(5);
      LAUNCH_BLKS(6);
      LAUNCH_BLKS(8);
    default: assert( false );
    }

# undef LAUNCH_RD
# undef LAUNCH_BLKS

    if ( dg == 0 ) return &gpu_info->get_info(GPU_Info_Func(kfunc));

    kfunc<<<dg,db>>>(digit_pos,first_iter);

    return NULL;
}

__host__ Kernel_Info*
sort_launch_pass_2
(GPU_Info *gpu_info, int dg, int db,
 int radix_lg, int digit_pos, bool last_iter)
{
#define LAUNCH_RD(BLG,RD_LG)                                                  \
  case 1<<BLG: kfunc = radix_sort_pass_2<BLG,RD_LG>; break;

#define LAUNCH_BLKS(RD_LG)                                                    \
  case RD_LG: switch ( db ){                                                  \
    LAUNCH_RD(5,RD_LG); LAUNCH_RD(6,RD_LG); LAUNCH_RD(7,RD_LG);               \
    LAUNCH_RD(8,RD_LG); LAUNCH_RD(9,RD_LG); LAUNCH_RD(10,RD_LG);              \
  default: assert( false );                                                   \
  } break;

  KPtr kfunc = NULL;

  switch ( radix_lg ) {
    LAUNCH_BLKS(4);
    LAUNCH_BLKS(5);
    LAUNCH_BLKS(6);
    LAUNCH_BLKS(8);
    default: assert( false );
  }

  if ( dg == 0 ) return &gpu_info->get_info(GPU_Info_Func(kfunc));

  kfunc<<<dg,db>>>(digit_pos,last_iter);

  return NULL;

# undef LAUNCH_RD
# undef LAUNCH_BLKS
}


#ifdef DEBUG_SORT
const int debug_sort = true;
#else
const int debug_sort = false;
#endif

template<int BLOCK_LG, int RADIX_LG>
struct Pass_1_Stuff
{
  Sort_Elt keys[elt_per_thread+(elt_per_thread<<BLOCK_LG)];
  int prefix[4 + (1<<BLOCK_LG)];
  int runend[1<<RADIX_LG];
  int thisto[1<<RADIX_LG];
  int ghisto[1<<RADIX_LG];
};

template <int BLOCK_LG, int RADIX_LG>
__device__ void
sort_block_1_bit_split
(int bit_low, int bit_count,
 Pass_1_Stuff<BLOCK_LG,RADIX_LG>& p1s);

template <int BLOCK_LG, int RADIX_LG>
__device__ void radix_sort_pass_1_tile
(int digit_pos, int tile_idx, bool first_iter,
 Pass_1_Stuff<BLOCK_LG,RADIX_LG>& p1s);

template <int BLOCK_LG, int RADIX_LG> __global__ void
radix_sort_pass_1(int digit_pos, bool first_iter)
{
  __shared__ Pass_1_Stuff<BLOCK_LG,RADIX_LG> p1s;
  int block_size = 1 << BLOCK_LG;
  int radix = 1 << RADIX_LG;
  int elt_per_tile = block_size * elt_per_thread;
  int tiles_per_array = div_ceil(dapp.array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block);

  const int dig_per_thd = BLOCK_LG >= RADIX_LG ? 1 : radix/block_size;
  const bool rad_participant = block_size <= radix || threadIdx.x < radix;
# define DIG(i) (threadIdx.x + (i) * block_size)

  if ( rad_participant )
    for ( int i = 0;  i < dig_per_thd;  i++ )
      p1s.ghisto[ DIG(i) ] = 0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    radix_sort_pass_1_tile<BLOCK_LG,RADIX_LG>
      (digit_pos,tile_idx,first_iter,p1s);

  if ( !rad_participant ) return;

  for ( int i = 0;  i < dig_per_thd;  i++ )
    {
      const int histo_idx = blockIdx.x * radix + DIG(i);
      sort_histo[ histo_idx ] = p1s.ghisto[ DIG(i) ];
    }
}

template <int BLOCK_LG, int RADIX_LG> __device__ void
radix_sort_pass_1_tile
(int digit_pos, int tile_idx,
 bool first_iter, Pass_1_Stuff<BLOCK_LG,RADIX_LG>& p1s)
{
  int start_bit = digit_pos * RADIX_LG;
  int block_size = 1 << BLOCK_LG;
  int radix = 1 << RADIX_LG;
  const int digit_mask = radix - 1;
  int elt_per_tile = elt_per_thread * block_size;
  int idx_block_start = elt_per_tile * tile_idx;
  const int dig_per_thd = BLOCK_LG >= RADIX_LG ? 1 : radix/block_size;
  const bool rad_participant = block_size <= radix || threadIdx.x < radix;

  int idx_block_stop = min( dapp.array_size, idx_block_start + elt_per_tile );
  int idx_start = idx_block_start + threadIdx.x;

  Sort_Elt *sort_src = first_iter ? sort_in : sort_out;

  // Load Element Keys
  //
  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    {
      Sort_Elt key = sort_src[ idx_block_start + sidx ];
      assert( key );
      p1s.keys[sidx] = key;
    }

  // Sort based upon current digit position
  //
  sort_block_1_bit_split<BLOCK_LG,RADIX_LG>(start_bit,RADIX_LG,p1s);

  // Write sorted elements to global memory and prepare for histogram.
  //
  for ( int idx = idx_start, sidx = threadIdx.x;
        idx < idx_block_stop; sidx += block_size, idx += block_size )
    {
      // Write element.
      //
      sort_out_b[idx] = p1s.keys[sidx];

      // Extract digit and write to shared memory.
      //
      int digit = ( p1s.keys[sidx] >> start_bit ) & digit_mask;
      p1s.keys[sidx] = digit;
    }

  if ( threadIdx.x == 0 ) p1s.keys[elt_per_tile] = radix;

  // Initialize histogram for this tile to zero.
  //
  if ( rad_participant )
    for ( int i = 0;  i < dig_per_thd;  i++ )
      p1s.thisto[ DIG(i) ] = 0;

  __syncthreads();

  // Find highest index for each digit.
  //
  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = p1s.keys[sidx];      // Our digit.
      int digit_1 = p1s.keys[sidx+1];  // Next guy's digit.

      // If "next guy's" digit is different then sidx is highest index
      // for digit.
      //
      if ( digit != digit_1 )
        p1s.runend[ digit ] = sidx;
    }

  __syncthreads();

  // Finish histogram by looking for smallest index for each digit.
  //
  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = p1s.keys[sidx];                      // Our digit.
      int digit_0 = sidx > 0 ? int(p1s.keys[sidx-1]) : -1; // Previous guy's digit.
      if ( digit != digit_0 )
        {
          int run_end_sidx = p1s.runend[ digit ];
          int count = run_end_sidx - sidx + 1;
          p1s.ghisto[ digit ] += count;     // Histogram for block.
          p1s.thisto[ digit ] = count;        // Histogram for tile.
        }
    }

  __syncthreads();

  if ( !rad_participant ) return;

  for ( int i = 0;  i < dig_per_thd;  i++ )
    {
      const int thisto_idx = tile_idx * radix + DIG(i);
      sort_tile_histo[ thisto_idx ] = p1s.thisto[ DIG(i) ];
    }
}

template <int block_lg, int RADIX_LG>
__device__ void
sort_block_1_bit_split
(int bit_low, int bit_count, Pass_1_Stuff<block_lg,RADIX_LG>& p1s)
{
  const int block_size = 1 << block_lg;
  const int elt_per_tile = elt_per_thread * block_size;

  if ( threadIdx.x == 0 ) p1s.prefix[0] = 0;

  // Sort Elements From LSB to MSB.
  //
  for ( int bit_pos=bit_low; bit_pos<bit_low+bit_count; bit_pos++ )
    {
      const uint bit_mask = 1 << bit_pos;

      // Storage for thread's keys.
      //
      Sort_Elt keys[elt_per_thread];

      __syncthreads();

      // Initialize data for prefix sum of bit bit_pos, and make copy of key.
      //
      int my_ones_write = 0;

      const bool use_pop = false;

      const int wp_lg = 5;
      const int wp_sz = 1 << wp_lg;
      const int wp_mk = wp_sz - 1;
      const int lane = threadIdx.x & wp_mk;
      const int wp_idx = threadIdx.x >> wp_lg;
      const uint32_t msk = 0xffffffff;
      int my_pf_wp = 0;

      for ( int i = 0; i < elt_per_thread; i++ )
        {
          const int sidx = threadIdx.x * elt_per_thread + i;

          // Make a copy of key.
          //
          const Sort_Elt key = p1s.keys[ sidx ];
          keys[i] = key;
          const bool one = key & bit_mask;
          if ( one ) my_ones_write++;
          if ( !use_pop ) continue;

          // Compute intra-warp prefix sum for one set of 32 keys.

          // Get vector showing which lanes have a 1.
          //
          const uint32_t have_work_wp_v = __ballot_sync(msk,one);

          // Shift off bits corresponding to higher-numbered lanes.
          //
          const uint32_t have_work_pf_v = have_work_wp_v << ( 31 - lane );

          // Use popc (population count, which is number of bits = 1)
          // to compute prefix.
          //
          const uint32_t my_pf_wp_i = __popc(have_work_pf_v);

          my_pf_wp += my_pf_wp_i;
        }

      if ( !use_pop )
        {
          my_pf_wp = my_ones_write;

          // Compute intra-warp prefix sum. (Sum within warp.)
          //
          for ( int tree_level = 0; tree_level < wp_lg; tree_level++ )
            {
              int dist = 1 << tree_level;
              uint neighbor_prefix = __shfl_up_sync(msk,my_pf_wp,dist);
              if ( dist <= lane ) my_pf_wp += neighbor_prefix;
            }
        }

      // Write total number of 1's in warp to shared memory. This
      // will be used to compute prefix sum between warps.
      //
      if ( lane == wp_mk ) p1s.prefix[wp_idx+1] = my_pf_wp;

      __syncthreads();

      // Compute inter-warp prefix sum.  Only warp 0 does this.
      //
      if ( wp_idx == 0 )
        {
          uint wp_prefix = p1s.prefix[threadIdx.x+1];
          for ( int tree_level = 0; tree_level < block_lg - wp_lg;
                tree_level++ )
            {
              int dist = 1 << tree_level;
              uint neighbor_prefix = __shfl_up_sync(msk,wp_prefix,dist);
              if ( dist <= threadIdx.x ) wp_prefix += neighbor_prefix;
            }
          p1s.prefix[threadIdx.x+1] = wp_prefix;
        }
      __syncthreads();
      const uint wp_prefix = p1s.prefix[wp_idx];
      __syncthreads();

      // Combine inter-warp prefix (wp_prefix) with intra-warp prefix
      // (my_pf_wp) to get prefix sum within block.
      //
      p1s.prefix[threadIdx.x+1] = wp_prefix + my_pf_wp;

      // At this point p1s.prefix contains exclusive prefix of each group.

      __syncthreads();

      const int all_threads_num_ones = p1s.prefix[ block_size ];
      const int idx_one_tid_0 = elt_per_tile - all_threads_num_ones;
      const int smaller_tids_num_ones = p1s.prefix[ threadIdx.x ];

      int idx_zero_me = threadIdx.x * elt_per_thread - smaller_tids_num_ones;
      int idx_one_me = idx_one_tid_0 + smaller_tids_num_ones;

      for ( int i = 0;  i < elt_per_thread;  i++ )
        {
          const int key = keys[i];
          const int new_idx = key & bit_mask ? idx_one_me++ : idx_zero_me++;
          p1s.keys[ new_idx ] = key;
        }

    }
  __syncthreads();
}


template <int BLOCK_LG, int RADIX_LG>
__global__ void
radix_sort_pass_2(int digit_pos, bool last_iter)
{
  const int block_size = 1 << BLOCK_LG;
  int elt_per_tile = elt_per_thread * block_size;
  int tiles_per_array = div_ceil(dapp.array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);

  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block );

  const int sort_radix = 1 << RADIX_LG;
  const int digit_mask = sort_radix - 1;
  const int start_bit = digit_pos * RADIX_LG;

  volatile __shared__ int g_prefix[ sort_radix + 1 ];

  if ( threadIdx.x == 0 ) g_prefix[ 0 ] = 0;

  const int warp_sz = 32;
  const int dig_per_thd = BLOCK_LG >= RADIX_LG ? 1 : sort_radix/block_size;
  const bool rad_participant =
    block_size <= sort_radix || threadIdx.x < sort_radix;
  const bool rad_attendee = rad_participant || sort_radix > warp_sz;
  volatile __shared__ int tile_offsets[ 2 * sort_radix ];

  if ( rad_attendee )
    {
      int overhead_bin_sum[dig_per_thd];
      int global_bin_sum[dig_per_thd];
      int global_bin_prefix[dig_per_thd];

      for ( auto& e: global_bin_sum ) e = 0;

      if ( rad_participant )
        {
          for ( int gh_idx = 0; gh_idx < gridDim.x; gh_idx++ )
            {
              for ( int i = 0;  i < dig_per_thd;  i++ )
                {
                  const int d = threadIdx.x + i * block_size;
                  const int gh_bin_idx = gh_idx * sort_radix + d;
                  if ( gh_idx == blockIdx.x )
                    overhead_bin_sum[i] = global_bin_sum[i];
                  global_bin_sum[i] += sort_histo[gh_bin_idx];
                }
            }

          //
          // Compute Global Prefix Sum
          //

          for ( int i = 0;  i < dig_per_thd;  i++ )
            {
              const int d = threadIdx.x + i * block_size;
              g_prefix[ 1 + d ] = global_bin_sum[i];
            }
          //
          // At this point g_prefix holds a global histogram.

          for ( int i=0; i<dig_per_thd; i++ )
            global_bin_prefix[i] = global_bin_sum[i];
        }

      for ( int lev=0; lev<RADIX_LG; lev++ )
        {
          const int dist = 1 << lev;
          int sum_0[dig_per_thd];

          if ( sort_radix > warp_sz ) __syncthreads();
          if ( rad_participant )
            for ( int i = 0;  i < dig_per_thd;  i++ )
              {
                const int d = threadIdx.x + i * block_size;
                sum_0[i] = dist <= d ? g_prefix[ 1 + d - dist ] : 0;
              }
          if ( sort_radix > warp_sz ) __syncthreads();
          if ( rad_participant )
            for ( int i = 0;  i < dig_per_thd;  i++ )
              {
                const int d = threadIdx.x + i * block_size;
                g_prefix[ 1 + d ] = global_bin_prefix[i] += sum_0[i];
              }
        }


      // Now, g_prefix holds a global prefix sum.
      //
      // E.g., g_prefix[3] is the location where the first key having
      // digit value 3 in the entire array is to be written. That key
      // is probably being handled by block 0.

      if ( sort_radix > warp_sz ) __syncthreads();
      if ( rad_participant )
        for ( int i = 0;  i < dig_per_thd;  i++ )
          {
            const int d = threadIdx.x + i * block_size;
            g_prefix[ d ] += overhead_bin_sum[i];
          }

      //
      // Now, g_prefix holds a prefix sum for this block.
      //
      // E.g., g_prefix[3] is the location where the first key having
      // digit value 3 in this block is to be written.

    }

  __syncthreads();

  if ( rad_participant )
    for ( int i=0;  i<dig_per_thd;  i++ )
      {
        const int d = threadIdx.x + i * block_size;
        tile_offsets[d] = 0;
      }

  __syncthreads();

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    {
      int counts[dig_per_thd];

      if ( rad_attendee )
        {
          int offsets[dig_per_thd];
          if ( rad_participant )
            for ( int i = 0;  i < dig_per_thd;  i++ )
              {
                const int d = threadIdx.x + i * block_size;
                const int bo_idx = tile_idx * sort_radix + d;
                const int to_idx = sort_radix + d;
                offsets[i] = counts[i] = tile_offsets[ to_idx ] =
                  sort_tile_histo[ bo_idx ];
              }

          for ( int lev=0; lev<RADIX_LG; lev++ )
            {
              const int dist = 1 << lev;
              if ( sort_radix > warp_sz ) __syncthreads();
              if ( rad_participant )
                for ( int i = 0;  i < dig_per_thd;  i++ )
                  {
                    const int d = threadIdx.x + i * block_size;
                    int to_idx = sort_radix + d;
                    offsets[i] += tile_offsets[ to_idx - dist ];
                  }
              if ( sort_radix > warp_sz ) __syncthreads();
              if ( rad_participant )
                for ( int i = 0;  i < dig_per_thd;  i++ )
                  {
                    const int d = threadIdx.x + i * block_size;
                    int to_idx = sort_radix + d;
                    tile_offsets[ to_idx ] = offsets[i];
                  }
            }
          if ( rad_participant )
            for ( int i = 0;  i < dig_per_thd;  i++ )
              {
                const int d = threadIdx.x + i * block_size;
                assert( counts[i] <= elt_per_tile );
                assert( tile_offsets[sort_radix + d - 1] <= elt_per_tile );
              }
        }

      __syncthreads();

      int idx_tile_start = tile_idx * elt_per_tile;

      for ( int i=0; i<elt_per_thread; i++ )
        {
          int tile_elt_rank = threadIdx.x + i * block_size;
          int idx = idx_tile_start + tile_elt_rank;
          Sort_Elt key = sort_out_b[idx];
          uint digit = ( key >> start_bit ) & digit_mask;
          int tile_digit_rank = tile_offsets[ sort_radix + digit - 1 ];
          int key_digit_rank = tile_elt_rank - tile_digit_rank;
          assert( key_digit_rank >= 0 );
          int idx_digit_index = g_prefix[ digit ] + key_digit_rank;

          if ( debug_sort && last_iter )
            sort_out[idx] = ( idx_digit_index << 12 ) + tile_digit_rank;
          else
            sort_out[idx_digit_index] = key;

        }

      __syncthreads();

      if ( rad_participant )
        for ( int i = 0;  i < dig_per_thd;  i++ )
          {
            const int d = threadIdx.x + i * block_size;
            g_prefix[ d ] += counts[i];
          }

      //
      // Now, g_prefix holds a prefix sum for the next tile.
      //
      // E.g., g_prefix[3] is the location where the first key having
      // digit value 3 in the next tile is to be written.
    }
}
