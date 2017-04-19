#include "radix-sort.cuh"
#include <gp/cuda-util-kernel.h>
#include <assert.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//

__constant__ Radix_Sort_GPU_Constants dapp;

__constant__ int *scan_out;
__constant__ int *scan_r2;

__device__ int lg_ceil(uint n)
{
  if ( n == 0 ) return 0;
  return 32 - __clz(n-1);
}

__constant__ Sort_Elt *sort_in, *sort_out, *sort_out_b;
__constant__ int *sort_tile_histo;
__constant__ int *sort_histo;

template <int BLOCK_LG, int RADIX_LG>
__global__ void radix_sort_1_pass_1(int digit_pos, bool first_iter);
template <int RADIX_LG>
__global__ void radix_sort_1_pass_2(int digit_pos, bool last_iter);

__host__ void
kernels_get_attr(GPU_Info *gpu_info)
{
  CU_SYM(dapp);
  CU_SYM(scan_out);
  CU_SYM(scan_r2);

  CU_SYM(sort_in); CU_SYM(sort_out); CU_SYM(sort_out_b);
  CU_SYM(sort_tile_histo);
  CU_SYM(sort_histo);

#define GETATTR(func) gpu_info->GET_INFO(func)
  GETATTR((radix_sort_1_pass_1<6,4>));
  GETATTR((radix_sort_1_pass_1<7,4>));
  GETATTR((radix_sort_1_pass_1<8,4>));
  GETATTR((radix_sort_1_pass_1<9,4>));
  GETATTR((radix_sort_1_pass_1<10,4>));
  GETATTR((radix_sort_1_pass_1<6,8>));
  GETATTR((radix_sort_1_pass_1<7,8>));
  GETATTR((radix_sort_1_pass_1<8,8>));
  GETATTR((radix_sort_1_pass_1<9,8>));
  GETATTR((radix_sort_1_pass_1<10,8>));
  GETATTR(radix_sort_1_pass_2<4>);
  GETATTR(radix_sort_1_pass_2<8>);
#undef GETATTR
}


// This routine executes on the CPU.
//
__host__ void
sort_launch_pass_1(int dg, int db, int radix_lg, int digit_pos, bool first_iter)
{
# define LAUNCH_RD(BLG,RD_LG) \
  case 1<<BLG: \
  radix_sort_1_pass_1<BLG,RD_LG><<<dg,db>>>(digit_pos,first_iter); \
  break;

#define LAUNCH_BLKS(RD_LG)                                                    \
  case RD_LG: switch ( db ){                                                  \
    LAUNCH_RD(6,RD_LG); LAUNCH_RD(7,RD_LG);                                   \
    LAUNCH_RD(8,RD_LG); LAUNCH_RD(9,RD_LG); LAUNCH_RD(10,RD_LG);              \
  default: assert( false );                                                   \
  } break;

  switch ( radix_lg ) {
    LAUNCH_BLKS(4);
    LAUNCH_BLKS(8);
    default: assert( false );
  }


# undef LAUNCH_RD
# undef LAUNCH_BLKS
}

__host__ void
sort_launch_pass_2
(int dg, int db, int radix_lg, int sm_bytes, int digit_pos, bool last_iter)
{
#define LAUNCH(RD_LG) \
  case RD_LG: \
    radix_sort_1_pass_2<RD_LG><<<dg,db,sm_bytes>>>(digit_pos,last_iter); \
    break;

  switch ( radix_lg ) {
    LAUNCH(4);
    LAUNCH(8);
    default: assert( false );
  }
#undef LAUNCH
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
__device__ void radix_sort_1_pass_1_tile
(int digit_pos, int tile_idx, bool first_iter,
 Pass_1_Stuff<BLOCK_LG,RADIX_LG>& p1s);

template <int BLOCK_LG, int RADIX_LG> __global__ void
radix_sort_1_pass_1(int digit_pos, bool first_iter)
{
  __shared__ Pass_1_Stuff<BLOCK_LG,RADIX_LG> p1s;
  int block_size = 1 << BLOCK_LG;
  int radix = 1 << RADIX_LG;
  int elt_per_tile = block_size * elt_per_thread;
  int tiles_per_array = div_ceil(dapp.array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block);

  if ( threadIdx.x < radix ) p1s.ghisto[ threadIdx.x ] = 0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    radix_sort_1_pass_1_tile<BLOCK_LG,RADIX_LG>
      (digit_pos,tile_idx,first_iter,p1s);

  if ( threadIdx.x >= radix ) return;

  int histo_idx = blockIdx.x * radix + threadIdx.x;
  sort_histo[ histo_idx ] = p1s.ghisto[ threadIdx.x ];
}

template <int BLOCK_LG, int RADIX_LG> __device__ void
radix_sort_1_pass_1_tile
(int digit_pos, int tile_idx,
 bool first_iter, Pass_1_Stuff<BLOCK_LG,RADIX_LG>& p1s)
{
  int start_bit = digit_pos * RADIX_LG;
  int block_size = 1 << BLOCK_LG;
  int radix = 1 << RADIX_LG;
  const int digit_mask = radix - 1;
  int elt_per_tile = elt_per_thread * block_size;
  int idx_block_start = elt_per_tile * tile_idx;

  int idx_block_stop = min( dapp.array_size, idx_block_start + elt_per_tile );
  int idx_start = idx_block_start + threadIdx.x;

  Sort_Elt *sort_src = first_iter ? sort_in : sort_out;

  // Load Element Keys
  //
  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    p1s.keys[sidx] = sort_src[ idx_block_start + sidx ];

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
  if ( threadIdx.x < radix )
    p1s.thisto[ threadIdx.x ] = 0;

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

  if ( threadIdx.x >= radix ) return;

  // Write out tile histogram.
  //
  int thisto_idx = tile_idx * radix + threadIdx.x;
  sort_tile_histo[ thisto_idx ] = p1s.thisto[ threadIdx.x ];
}

template <int block_lg, int RADIX_LG>
__device__ void
sort_block_1_bit_split
(int bit_low, int bit_count, Pass_1_Stuff<block_lg,RADIX_LG>& p1s)
{
  const int block_size = 1 << block_lg;
  const int elt_per_tile = elt_per_thread * block_size;

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

      for ( int i = 0; i < elt_per_thread; i++ )
        {
          const int sidx = threadIdx.x * elt_per_thread + i;

          // Make a copy of key.
          //
          const Sort_Elt key = p1s.keys[ sidx ];
          keys[i] = key;
          if ( key & bit_mask ) my_ones_write++;
        }

      p1s.prefix[ threadIdx.x + 1 ] = my_ones_write;
      if ( threadIdx.x == 0 ) p1s.prefix[ 0 ] = 0;

      uint my_prefix = my_ones_write;

      // Compute a prefix sum of vectors.
      for ( int tree_level = 0; tree_level < block_lg; tree_level++ )
        {
          int dist = 1 << tree_level;
          int idx_neighbor = threadIdx.x - dist;
          __syncthreads();
          uint neighbor_prefix =
            threadIdx.x >= dist ? p1s.prefix[ idx_neighbor + 1 ] : 0;

          my_prefix += neighbor_prefix;
          __syncthreads();
          p1s.prefix[ threadIdx.x + 1 ] = my_prefix;
        }

      // At this point my_prefix contains exclusive prefix of each group.

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


extern __shared__ Sort_Elt s[];

__device__ void radix_sort_1_pass_2_tile
(int radix_lg, int digit_pos, int tile_idx, bool last_iter);

template <int RADIX_LG>
__global__ void
radix_sort_1_pass_2(int digit_pos, bool last_iter)
{
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(dapp.array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);

  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block );

  const int sort_radix = 1 << RADIX_LG;
  int pfe_tile_sbase = 0;
  int pfi_tile_sbase = 1;
  int pf_offset_sbase_base = pfi_tile_sbase + sort_radix;
  int pfe_tile_sidx = pfe_tile_sbase + threadIdx.x;

  volatile int *sv = &((int*)s)[ 0 ];

  // Sum of all histogram bins for our digit value (threadIdx.x)
  //
  int global_bin_sum = 0;

  // Sum of histogram bins for our digit value for array indices
  // lower than ours.
  //
  int overhead_bin_sum = 0;

  if ( threadIdx.x == 0 ) sv[ pfe_tile_sbase ] = 0;

  if ( threadIdx.x < sort_radix )
    {
      // Code only correct for sort_radix <= 32.

      int idx_for_us = blockIdx.x * sort_radix + threadIdx.x;
      int pidx_stop = gridDim.x * sort_radix;

      // Compute Global Histogram
      //
      // Loop will set global_bin_sum to the total number of digits
      // of value threadIdx.x.
      //
      // Eg: Array:  123, 121, 373, 932, 863, 113
      //     Based on digit_pos, operating on least-significant digit.
      //     threadIdx.x = 3
      //     Then =>  global_bin_sum = 4
      //
      for ( int idx = threadIdx.x; idx < pidx_stop; idx += sort_radix )
        {
          if ( idx == idx_for_us ) overhead_bin_sum = global_bin_sum;
          global_bin_sum += sort_histo[idx];
        }

      // Compute Global Prefix Sum
      //
      //
      sv[ pfi_tile_sbase + threadIdx.x ] = global_bin_sum;
      int global_bin_prefix = global_bin_sum;

      for ( int i=0; i< RADIX_LG; i++ )
        {
          int dist = 1 << i;
          int sum_0 = dist <= threadIdx.x
            ? sv[ pfi_tile_sbase + threadIdx.x - dist ] : 0;
          sv[ pfi_tile_sbase + threadIdx.x ] = global_bin_prefix += sum_0;
        }

      // Initialize Tile Prefix Sum
      //
      sv[ pfe_tile_sidx ] += overhead_bin_sum;
    }

  __syncthreads();

  volatile int *tile_offsets = &((int*)s)[pf_offset_sbase_base];
  if ( threadIdx.x < sort_radix ) tile_offsets[threadIdx.x]=0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    {
      int count;
      if ( threadIdx.x < sort_radix )
        {
          int bo_idx = tile_idx * sort_radix + threadIdx.x;
          count = sort_tile_histo[ bo_idx ];
          int to_idx = sort_radix + threadIdx.x;
          int offset = count;
          tile_offsets[ to_idx ] = offset;
          tile_offsets[ to_idx ] = offset += tile_offsets[ to_idx - 1 ];
          tile_offsets[ to_idx ] = offset += tile_offsets[ to_idx - 2 ];
          tile_offsets[ to_idx ] = offset += tile_offsets[ to_idx - 4 ];
          tile_offsets[ to_idx ] = offset += tile_offsets[ to_idx - 8 ];
          if ( debug_sort && last_iter )
            {
              scan_out[bo_idx] = sv[ pfe_tile_sidx ];
              scan_r2[bo_idx] = tile_offsets[ to_idx - 1];
            }
        }
      __syncthreads();
      radix_sort_1_pass_2_tile(RADIX_LG,digit_pos,tile_idx,last_iter);
      __syncthreads();
      if ( threadIdx.x < sort_radix ) sv[ pfe_tile_sidx ] += count;
    }
}

__device__ void
radix_sort_1_pass_2_tile
(int radix_lg, int digit_pos, int tile_idx, bool last_iter)
{
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(dapp.array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int idx_tile_start = tile_idx * elt_per_tile;

  const int sort_radix = 1 << radix_lg;
  const int digit_mask = sort_radix - 1;
  int start_bit = digit_pos * radix_lg;

  int pfe_tile_sbase = 0;
  int pfi_tile_sbase = 1;
  int pf_offset_sbase_base = pfi_tile_sbase + sort_radix;
  int pf_offset_sbase = pf_offset_sbase_base + sort_radix - 1;

  for ( int i=0; i<elt_per_thread; i++ )
    {
      int tile_elt_rank = threadIdx.x + i * blockDim.x;
      int idx = idx_tile_start + tile_elt_rank;
      uint key = sort_out_b[idx];
      uint digit = ( key >> start_bit ) & digit_mask;
      int tile_digit_rank = s[ pf_offset_sbase + digit ];
      int key_digit_rank = tile_elt_rank - tile_digit_rank;
      int idx_digit_index = s[ pfe_tile_sbase + digit ] + key_digit_rank;

      if ( debug_sort && last_iter )
        sort_out[idx] = ( idx_digit_index << 12 ) + tile_digit_rank;
      else
        sort_out[idx_digit_index] = key;

    }
}
