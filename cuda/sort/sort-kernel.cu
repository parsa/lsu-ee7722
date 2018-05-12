#include "sort.cuh"
#include <gp/cuda-util-kernel.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ int block_lg;
__constant__ int array_size, array_size_lg;
__constant__ int *scan_in, *scan_out;
__constant__ int *scan_r2;

extern __shared__ int s[];

__constant__ int *sort_in, *sort_out, *sort_out_b;
__constant__ int *sort_tile_histo;
__constant__ int *sort_histo;

__constant__ int sort_bin_mask;
__constant__ int sort_bin_size, sort_bin_count;
__constant__ int sort_all_bin_count, sort_all_bin_lg;
__constant__ int sort_bin_lg;

__global__ void sort_segments_1_bit_split();
__global__ void sort_segments_1_bit_split_opt();
__global__ void sort_block_batcher();
__global__ void sort_block_batcher_1();
template <int BLOCK_LG> __global__ void sort_block_batcher_opt();
template <int BLOCK_LG, int BIN_LG>
__global__ void radix_sort_1_pass_1(int bin_idx, bool first_iter);
__global__ void radix_sort_1_pass_2(int bin_idx, bool last_iter);

__host__ void
kernels_get_attr(GPU_Info *gpu_info)
{
  CU_SYM(block_lg);
  CU_SYM(array_size); CU_SYM(array_size_lg);
  CU_SYM(scan_in); CU_SYM(scan_out);
  CU_SYM(scan_r2);

  CU_SYM(sort_in); CU_SYM(sort_out); CU_SYM(sort_out_b);
  CU_SYM(sort_tile_histo);
  CU_SYM(sort_histo);

  CU_SYM(sort_bin_mask);
  CU_SYM(sort_bin_size); CU_SYM(sort_bin_count);
  CU_SYM(sort_all_bin_count); CU_SYM(sort_all_bin_lg);
  CU_SYM(sort_bin_lg);

#define GETATTR(func) gpu_info->GET_INFO(func)
  GETATTR(sort_segments_1_bit_split);
  GETATTR(sort_segments_1_bit_split_opt);
  GETATTR(sort_block_batcher);
  GETATTR(sort_block_batcher_1);
  GETATTR(sort_block_batcher_opt<6>);
  GETATTR(sort_block_batcher_opt<8>);
  GETATTR(sort_block_batcher_opt<10>);
  GETATTR((radix_sort_1_pass_1<6,4>));
  GETATTR(radix_sort_1_pass_2);
#undef GETATTR
}


// This routine executes on the CPU.
//
__host__ int
sort_launch(dim3 dg, dim3 db, int version, int array_size, int array_size_lg)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  switch ( version ){
  case 0: case 1:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4 + 2;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      if ( !dg.x ) return shared_size;
      if ( version == 0 )
        sort_segments_1_bit_split<<<dg,db,shared_size>>>();
      else
        sort_segments_1_bit_split_opt<<<dg,db,shared_size>>>();
    }
    break;

  case 2:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      if ( !dg.x ) return shared_size;
      sort_block_batcher<<<dg,db,shared_size>>>();
    }
    break;

  case 3:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      if ( !dg.x ) return shared_size;
      sort_block_batcher_1<<<dg,db,shared_size>>>();
    }
    break;

  case 4:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      if ( !dg.x ) return shared_size;
      switch ( db.x ) {
      case 64: sort_block_batcher_opt<6><<<dg,db,shared_size>>>(); break;
      case 128: sort_block_batcher_opt<7><<<dg,db,shared_size>>>(); break;
      case 256: sort_block_batcher_opt<8><<<dg,db,shared_size>>>(); break;
      case 1024: sort_block_batcher_opt<10><<<dg,db,shared_size>>>(); break;
      default:break;
      }
    }
    break;

  case 5:
    {
      const int bin_lg = 4;
      const int bin_size = 1 << bin_lg;
      int elt_per_thread = 4;
      int size_per_elt_1 = 4 + 2; // Assuming sort_bin_size < block_size
      int shared_size_pass_1 = db.x * size_per_elt_1 * elt_per_thread
        + 4 * bin_size * 4;
      int shared_size_pass_2 = ( 3 * bin_size + 1 ) * 4;
      int bins = int( ceil( 32.0 / bin_lg ) );
      int bin_idx_start = 0;
      int bin_idx_stop = bins;
      if ( !dg.x ) return shared_size_pass_1;
      for ( int bin_idx = bin_idx_start; bin_idx < bin_idx_stop; bin_idx++ )
        {
          const bool first_iter = bin_idx == bin_idx_start;
          switch(db.x){
          case 64:
            radix_sort_1_pass_1<6,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx,first_iter);
          break;
          case 128:
            radix_sort_1_pass_1
              <7,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx,first_iter);
          break;
          case 256:
            radix_sort_1_pass_1
              <8,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx,first_iter);
          break;
          }
          radix_sort_1_pass_2<<<dg,db,shared_size_pass_2>>>
            (bin_idx,bin_idx+1==bin_idx_stop);
        }
    }
    break;

  default:
    assert( false );
    break;
  }
  return 0;
}

__device__ int lg_ceil(uint n)
{
  if ( n == 0 ) return 0;
  return 32 - __clz(n-1);
}

__device__ int div_ceil(int a, int b){return (a+b-1)/b;}

#ifdef DEBUG_SORT
const int debug_sort = true;
#else
const int debug_sort = false;
#endif


__device__ void sort_block_1_bit_split(int bit_low, int bit_count);
__device__ void sort_block_1_bit_split_opt(int bit_low, int bit_count);

template<bool method_opt>
__device__ void
sort_segments_1_bit_split_method()
{
  int elt_per_thread = 4;
  int elt_per_block = elt_per_thread * blockDim.x;
  int idx_block_start = elt_per_block * blockIdx.x;

  int idx_start = idx_block_start + threadIdx.x;

  // Load Elements
  //
  for ( int i = 0;  i < elt_per_thread; i++ )
    {
      const int sidx = threadIdx.x + i * blockDim.x;
      s[ sidx ] = sort_in[ idx_block_start + sidx ];
    }

  if ( method_opt )
    sort_block_1_bit_split_opt(0,32);
  else
    sort_block_1_bit_split(0,32);

  for ( int i = 0;  i < elt_per_thread; i++ )
    {
      const int sidx = threadIdx.x + i * blockDim.x;
      const int idx = idx_start + i * blockDim.x;
      sort_out[idx] = s[ sidx ];
    }
}

__global__ void
sort_segments_1_bit_split()
{ sort_segments_1_bit_split_method<false>(); }
__global__ void
sort_segments_1_bit_split_opt()
{ sort_segments_1_bit_split_method<true>(); }



__device__ void
sort_block_1_bit_split(int bit_low, int bit_count)
{
  // Number of elements operated on per thread.
  //
  const int elt_per_thread = 4;

  int elt_per_block = elt_per_thread * blockDim.x;

  // Indices into shared memory for prefix sum.
  // pfe: Exclusive prefix. (Sum of smaller element values.)
  // pfi: Inclusive prefix. (Sum of this element and smaller element values.)
  //
  int pfe_base_rd = elt_per_block;
  int pfi_base_rd = elt_per_block + 1;

  // Sort Elements From LSB to MSB.
  //
  for ( int bit_pos=bit_low; bit_pos<bit_low+bit_count; bit_pos++ )
    {
      const uint bit_mask = 1 << bit_pos;

      // Storage for thread's keys.
      //
      int keys[elt_per_thread];

      __syncthreads();

      // Initialize data for prefix sum of bit bit_pos, and make copy of key.
      //
      int my_ones_write = 0;

      for ( int i = 0; i < elt_per_thread; i++ )
        {
          //  const int sidx = threadIdx.x + i * blockDim.x;
          const int sidx = threadIdx.x * elt_per_thread + i;

          // Make a copy of key.
          //
          const int key = s[ sidx ];
          keys[i] = key;
          if ( key & bit_mask ) my_ones_write++;
        }

      s[ pfi_base_rd + threadIdx.x ] = my_ones_write;
      if ( threadIdx.x == 0 ) s[ pfe_base_rd ] = 0;

      uint my_prefix = my_ones_write;

      // Compute a prefix sum of vectors.
      for ( int tree_level = 0; tree_level < block_lg; tree_level++ )
        {
          int dist = 1 << tree_level;
          int idx_neighbor = threadIdx.x - dist;
          __syncthreads();
          uint neighbor_prefix =
            threadIdx.x >= dist ? s[ pfi_base_rd + idx_neighbor ] : 0;
          
          my_prefix += neighbor_prefix;
          __syncthreads();
          s[ pfi_base_rd + threadIdx.x ] = my_prefix;
        }

      // At this point my_prefix contains exclusive prefix of each group.

      __syncthreads();

      const int all_threads_num_ones = s[ pfe_base_rd + blockDim.x ];
      const int idx_one_tid_0 = elt_per_block - all_threads_num_ones;
      const int smaller_tids_num_ones = s[ pfe_base_rd + threadIdx.x ];

      int idx_zero_me = threadIdx.x * elt_per_thread - smaller_tids_num_ones;
      int idx_one_me = idx_one_tid_0 + smaller_tids_num_ones;

      for ( int i = 0;  i < elt_per_thread;  i++ )
        {
          const int key = keys[i];
          const int new_idx = key & bit_mask ? idx_one_me++ : idx_zero_me++;
          s[ new_idx ] = key;
        }

    }
  __syncthreads();
}

__device__ void
sort_block_1_bit_split_opt(int bit_low, int bit_count)
{
  const int block_size = blockDim.x;

  // Number of elements operated on per thread.
  //
  const int elt_per_thread = 4;

  int elt_per_block = elt_per_thread * block_size;

  int* const prefix = &s[ elt_per_block ];

  if ( threadIdx.x == 0 ) prefix[ 0 ] = 0;

  // Sort Elements From LSB to MSB.
  //
  for ( int bit_pos=bit_low; bit_pos<bit_low+bit_count; bit_pos++ )
    {
      const uint bit_mask = 1 << bit_pos;

      // Storage for thread's keys.
      //
      int keys[elt_per_thread];

      __syncthreads();

      // Initialize data for prefix sum of bit bit_pos, and make copy of key.
      //
      int my_ones_write = 0;

      const bool use_pop = true;

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
          const int key = s[ sidx ];
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
      if ( lane == wp_mk ) prefix[wp_idx+1] = my_pf_wp;

      __syncthreads();

      // Compute inter-warp prefix sum.  Only warp 0 does this.
      //
      if ( wp_idx == 0 )
        {
          uint wp_prefix = prefix[threadIdx.x+1];
          for ( int tree_level = 0; tree_level < block_lg - wp_lg;
                tree_level++ )
            {
              int dist = 1 << tree_level;
              uint neighbor_prefix = __shfl_up_sync(msk,wp_prefix,dist);
              if ( dist <= threadIdx.x ) wp_prefix += neighbor_prefix;
            }
          prefix[threadIdx.x+1] = wp_prefix;
        }
      __syncthreads();
      const uint wp_prefix = prefix[wp_idx];
      __syncthreads();

      // Combine inter-warp prefix (wp_prefix) with intra-warp prefix
      // (my_pf_wp) to get prefix sum within block.
      //
      prefix[threadIdx.x+1] = wp_prefix + my_pf_wp;

      // At this point p1s.prefix contains exclusive prefix of each group.

      __syncthreads();

      const int all_threads_num_ones = prefix[ block_size ];
      const int idx_one_tid_0 = elt_per_block - all_threads_num_ones;
      const int smaller_tids_num_ones = prefix[ threadIdx.x ];

      int idx_zero_me = threadIdx.x * elt_per_thread - smaller_tids_num_ones;
      int idx_one_me = idx_one_tid_0 + smaller_tids_num_ones;

      for ( int i = 0;  i < elt_per_thread;  i++ )
        {
          const int key = keys[i];
          const int new_idx = key & bit_mask ? idx_one_me++ : idx_zero_me++;
          s[ new_idx ] = key;
        }

    }
  __syncthreads();
}


__global__ void
sort_block_batcher()
{
  int elt_per_thread = 4;
  int elt_per_block = elt_per_thread * blockDim.x;
  int chunk_lg = lg_ceil(elt_per_block);
  int idx_block_start = elt_per_block * blockIdx.x;

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += blockDim.x )
    s[sidx] = sort_in[ idx_block_start + sidx ];

  for ( int m_lg=0; m_lg<chunk_lg; m_lg++ )
    {
      int sort_dir_vector = 1 << ( m_lg + 1 );
      for ( int bit = m_lg; bit >= 0; bit-- )
        {
          int bit_vector = 1 << bit;
          __syncthreads();
          for ( int i=0; i<elt_per_thread; i++ )
            {
              int idx_0 = threadIdx.x + i * blockDim.x;
              int idx_1 = idx_0 | bit_vector;
              if ( idx_0 == idx_1 ) continue;
              bool sort_dir = idx_0 & sort_dir_vector;
              uint key_0 = s[idx_0];
              uint key_1 = s[idx_1];
              if ( (key_0 < key_1 ) == sort_dir )
                { s[idx_0] = key_1;  s[idx_1] = key_0; }
            }
        }

    }

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += blockDim.x )
    sort_out[ idx_block_start + sidx ] = s[sidx];
}

__global__ void
sort_block_batcher_1()
{
  int elt_per_thread = 4;
  int elt_per_thread_half = elt_per_thread >> 1;
  int elt_per_block = elt_per_thread * blockDim.x;
  int chunk_lg = lg_ceil(elt_per_block);
  int idx_block_start = elt_per_block * blockIdx.x;

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += blockDim.x )
    s[sidx] = sort_in[ idx_block_start + sidx ];

  for ( int m_lg=0; m_lg<chunk_lg; m_lg++ )
    {
      int sort_dir_vector = 1 << ( m_lg + 1 );
      for ( int bit = m_lg; bit >= 0; bit-- )
        {
          uint bit_vector = 1 << bit;
          uint shift_mask = ~( bit_vector - 1 );
          __syncthreads();
          for ( int i=0; i<elt_per_thread_half; i++ )
            {
              int idx_ref = threadIdx.x + i * blockDim.x;
              int idx_0 = idx_ref + ( idx_ref & shift_mask );
              int idx_1 = idx_0 + bit_vector;
              bool sort_dir = idx_0 & sort_dir_vector;
              uint key_0 = s[idx_0];
              uint key_1 = s[idx_1];
              if ( ( key_0 < key_1 ) == sort_dir )
                { s[idx_0] = key_1;  s[idx_1] = key_0; }
            }
        }
    }

  __syncthreads();

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += blockDim.x )
    sort_out[ idx_block_start + sidx ] = s[sidx];
}

template <int BLOCK_LG>
__global__ void
sort_block_batcher_opt()
{
  int block_size = 1 << BLOCK_LG;
  int elt_per_thread = 4;
  int elt_per_thread_half = elt_per_thread >> 1;
  int elt_per_block = elt_per_thread * block_size;
  int chunk_lg = 2 + BLOCK_LG;
  int idx_block_start = elt_per_block * blockIdx.x;

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    s[sidx] = sort_in[ idx_block_start + sidx ];

  for ( int m_lg=0; m_lg<BLOCK_LG; m_lg++ )
    {
      int sort_dir_vector = 1 << m_lg;
      bool sort_dir = threadIdx.x & sort_dir_vector;
      for ( int bit = m_lg; bit >= 0; bit-- )
        {
          int bit_vector = 1 << bit;
          uint shift_mask = ~( bit_vector - 1 );
          int idx_0_t = threadIdx.x + ( threadIdx.x & shift_mask );
          int idx_1_t = idx_0_t + bit_vector;
          __syncthreads();
          for ( int i=0; i<elt_per_thread; i += 2 )
            {
              int idx_0 = idx_0_t + ( i << BLOCK_LG );
              int idx_1 = idx_1_t + ( i << BLOCK_LG );
              uint key_0 = s[idx_0];
              uint key_1 = s[idx_1];
              if ( (key_0 < key_1 ) == sort_dir )
                { s[idx_0] = key_1;  s[idx_1] = key_0; }
            }
        }
    }
  for ( int m_lg=BLOCK_LG; m_lg<chunk_lg; m_lg++ )
    {
      int sort_dir_vector = 1 << ( m_lg + 1 );
      for ( int bit = m_lg; bit >= 0; bit-- )
        {
          int bit_vector = 1 << bit;
          uint shift_mask = ~( bit_vector - 1 );
          __syncthreads();
          for ( int i=0; i<elt_per_thread_half; i++ )
            {
              int idx_ref = threadIdx.x + i * block_size;
              int idx_0 = idx_ref + ( idx_ref & shift_mask );
              int idx_1 = idx_0 + bit_vector;
              bool sort_dir = idx_0 & sort_dir_vector;
              uint key_0 = s[idx_0];
              uint key_1 = s[idx_1];
              if ( (key_0 < key_1 ) == sort_dir )
                { s[idx_0] = key_1;  s[idx_1] = key_0; }
            }
        }
    }

  __syncthreads();

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    sort_out[ idx_block_start + sidx ] = s[sidx];

}

template <int BLOCK_LG, int BIN_LG>
__device__ void radix_sort_1_pass_1_tile
(int bin_idx, int tile_idx, bool first_iter);

#define SH_GLOBAL_HISTO(elt) s[ ghisto_sbase + (elt) ]
#define SH_TILE_HISTO(idx) s[ thisto_sbase + (idx) ]

template <int BLOCK_LG, int BIN_LG> __global__ void
radix_sort_1_pass_1(int bin_idx, bool first_iter)
{
  int elt_per_thread = 4;
  int block_size = 1 << BLOCK_LG;
  int bin_size = 1 << BIN_LG;
  int elt_per_tile = block_size * elt_per_thread;
  int tiles_per_array = div_ceil(array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block);
  int sbase_1_bit_split_end = elt_per_tile + block_size + 1;
  int ghisto_sbase = sbase_1_bit_split_end;

  if ( threadIdx.x < bin_size ) SH_GLOBAL_HISTO( threadIdx.x ) = 0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    radix_sort_1_pass_1_tile<BLOCK_LG,BIN_LG>(bin_idx,tile_idx,first_iter);

  if ( threadIdx.x >= bin_size ) return;
  int histo_idx = blockIdx.x * bin_size + threadIdx.x;
  sort_histo[ histo_idx ] = SH_GLOBAL_HISTO( threadIdx.x );
}

template <int BLOCK_LG, int BIN_LG> __device__ void
radix_sort_1_pass_1_tile(int bin_idx, int tile_idx, bool first_iter)
{
  int start_bit = bin_idx * sort_bin_lg;
  int elt_per_thread = 4;
  int block_size = 1 << BLOCK_LG;
  int bin_size = 1 << BIN_LG;
  int elt_per_tile = elt_per_thread * block_size;
  int idx_block_start = elt_per_tile * tile_idx;

  int idx_block_stop = min( array_size, idx_block_start + elt_per_tile );
  int idx_start = idx_block_start + threadIdx.x;

  int sbase_1_bit_split_end = elt_per_tile + block_size + 1;
  int ghisto_sbase = sbase_1_bit_split_end;
  int runend_sbase = ghisto_sbase + bin_size;
  int thisto_sbase = runend_sbase + bin_size;

  int *sort_src = first_iter ? sort_in : sort_out;

  // Load Elements
  //
  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    s[sidx] = sort_src[ idx_block_start + sidx ];

  // Sort based upon current bin (digit position)
  //
  sort_block_1_bit_split(start_bit,sort_bin_lg);

  // Write sorted elements to global memory and prepare for histogram.
  //
  for ( int idx = idx_start, sidx = threadIdx.x;
        idx < idx_block_stop; sidx += block_size, idx += block_size )
    {
      // Write element.
      //
      sort_out_b[idx] = s[sidx];

      // Extract digit and write to shared memory.
      //
      int digit = ( s[sidx] >> start_bit ) & sort_bin_mask;
      s[sidx] = digit;
    }

  if ( threadIdx.x == 0 ) s[elt_per_tile] = bin_size;

  // Initialize histogram for this tile to zero.
  //
  if ( threadIdx.x < bin_size )
    SH_TILE_HISTO( threadIdx.x ) = 0;

  __syncthreads();

  // Find highest index for each digit.
  //
  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = s[sidx];      // Our digit.
      int digit_1 = s[sidx+1];  // Next guy's digit.

      // If "next guy's" digit is different then sidx is highest index
      // for digit.
      //
      if ( digit != digit_1 )
        s[ runend_sbase + digit ] = sidx;
    }

  __syncthreads();

  // Finish histogram by looking for smallest index for each digit.
  //
  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = s[sidx];                        // Our digit.
      int digit_0 = sidx > 0 ? s[sidx-1] : -1;    // Previous guy's digit.
      if ( digit != digit_0 )
        {
          int run_end_sidx = s[ runend_sbase + digit ];
          int count = run_end_sidx - sidx + 1;
          SH_GLOBAL_HISTO( digit ) += count;     // Histogram for block.
          SH_TILE_HISTO( digit ) = count;      // Histogram for tile.
        }
    }

  __syncthreads();

  if ( threadIdx.x >= bin_size ) return;

  // Write out tile histogram.
  //
  int thisto_idx = tile_idx * bin_size + threadIdx.x;
  sort_tile_histo[ thisto_idx ] = SH_TILE_HISTO( threadIdx.x );
}

__device__ void radix_sort_1_pass_2_tile
(int bin_idx, int tile_idx, bool last_iter);

__global__ void
radix_sort_1_pass_2(int bin_idx, bool last_iter)
{
  int elt_per_thread = 4;
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);

  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block );

  int pfe_tile_sbase = 0;
  int pfi_tile_sbase = 1;
  int pf_offset_sbase_base = pfi_tile_sbase + sort_bin_size;
  int pfe_tile_sidx = pfe_tile_sbase + threadIdx.x;

  volatile int *sv = &s[ 0 ]; // Volatile access.

  // Sum of all histogram bins for our digit value (threadIdx.x)
  //
  int global_bin_sum = 0;

  // Sum of histogram bins for our digit value for array indices
  // lower than ours.
  //
  int overhead_bin_sum = 0;

  if ( threadIdx.x == 0 ) sv[ pfe_tile_sbase ] = 0;

  if ( threadIdx.x < sort_bin_size )
    {
      // Code only correct for sort_bin_size <= 32.

      int idx_for_us = blockIdx.x * sort_bin_size + threadIdx.x;
      int pidx_stop = gridDim.x * sort_bin_size;

      // Compute Global Histogram
      //
      // Loop will set global_bin_sum to the total number of digits
      // of value threadIdx.x.
      //
      // Eg: Array:  123, 121, 373, 932, 863, 113
      //     Based on bin_idx, operating on least-significant digit.
      //     threadIdx.x = 3
      //     Then =>  global_bin_sum = 4
      //
      for ( int idx = threadIdx.x; idx < pidx_stop; idx += sort_bin_size )
        {
          if ( idx == idx_for_us ) overhead_bin_sum = global_bin_sum;
          global_bin_sum += sort_histo[idx];
        }
      
      // Compute Global Prefix Sum
      //
      //
      sv[ pfi_tile_sbase + threadIdx.x ] = global_bin_sum;
      int global_bin_prefix = global_bin_sum;

      for ( int i=0; i<sort_bin_lg; i++ )
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

  volatile int *tile_offsets = &s[pf_offset_sbase_base];
  if ( threadIdx.x < sort_bin_size ) tile_offsets[threadIdx.x]=0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx++ )
    {
      int count;
      if ( threadIdx.x < sort_bin_size )
        {
          int bo_idx = tile_idx * sort_bin_size + threadIdx.x;
          count = sort_tile_histo[ bo_idx ];
          int to_idx = sort_bin_size + threadIdx.x;
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
      radix_sort_1_pass_2_tile(bin_idx,tile_idx,last_iter);
      __syncthreads();
      if ( threadIdx.x < sort_bin_size ) sv[ pfe_tile_sidx ] += count;
    }
}

__device__ void
radix_sort_1_pass_2_tile
(int bin_idx, int tile_idx, bool last_iter)
{
  const int elt_per_thread = 4;
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int idx_tile_start = tile_idx * elt_per_tile;

  int start_bit = bin_idx * sort_bin_lg;

  int pfe_tile_sbase = 0;
  int pfi_tile_sbase = 1;
  int pf_offset_sbase_base = pfi_tile_sbase + sort_bin_size;
  int pf_offset_sbase = pf_offset_sbase_base + sort_bin_size - 1;

  for ( int i=0; i<elt_per_thread; i++ )
    {
      int local_idx = threadIdx.x + i * blockDim.x;
      int idx = idx_tile_start + local_idx;
      uint key = sort_out_b[idx];
      uint digit = ( key >> start_bit ) & sort_bin_mask;
      int local_offset = s[ pf_offset_sbase + digit ];
      int key_digit_rank = local_idx - local_offset;
      int idx_digit_index = s[ pfe_tile_sbase + digit ] + key_digit_rank;

      if ( debug_sort && last_iter )
        sort_out[idx] = ( idx_digit_index << 12 ) + local_offset;
      else
        sort_out[idx_digit_index] = key;

    }
}
