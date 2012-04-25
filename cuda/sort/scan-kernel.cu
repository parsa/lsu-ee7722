#include "sort.cuh"

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

__global__ void prefix_sum_0(int tree_level);
__global__ void prefix_sum_1_pass_1();
template <int BLOCK_LG> __global__ void prefix_sum_1_opt_pass_1();
__global__ void prefix_sum_1_pass_2();
__global__ void sort_segments_1_bit_split();
__global__ void sort_block_batcher();
__global__ void sort_block_batcher_1();
template <int BLOCK_LG> __global__ void sort_block_batcher_opt();
template <int BLOCK_LG, int BIN_LG>
__global__ void radix_sort_1_pass_1(int bin_idx);
__global__ void radix_sort_1_pass_2(int bin_idx);

static __host__ int
kernels_get_attr_(pCUDA_Func_Attributes *attr)
{
  int count = 0;

#define GETATTR(func)                                                         \
  count++;                                                                    \
  if ( attr ) {                                                               \
      attr->err = cudaFuncGetAttributes(&attr->attr,func);                    \
      attr->name = #func;                                                     \
      attr++;                                                                 \
    }

  GETATTR(prefix_sum_0);
  GETATTR(prefix_sum_1_pass_1);
  GETATTR(prefix_sum_1_opt_pass_1<8>);
  GETATTR(prefix_sum_1_pass_2);
  GETATTR(sort_segments_1_bit_split);
  GETATTR(sort_block_batcher);
  GETATTR(sort_block_batcher_1);
  GETATTR(sort_block_batcher_opt<8>);
  GETATTR((radix_sort_1_pass_1<6,4>));
  GETATTR(radix_sort_1_pass_2);
  return count;
#undef GETATTR
}

__host__ int
kernels_get_attr(pCUDA_Func_Attributes **attr)
{
  int count = kernels_get_attr_(NULL);
  *attr = (pCUDA_Func_Attributes*) calloc(count,sizeof(**attr));
  return kernels_get_attr_(*attr);
}

// This routine executes on the CPU.
//
__host__ void
scan_launch(dim3 dg, dim3 db, int version, int array_size, int array_size_lg)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  switch ( version ){
  case 0:
    {
      for ( int tree_level = 0; tree_level < array_size_lg; tree_level++ )
        prefix_sum_0<<<dg,db>>>(tree_level);
    }
    break;
  case 1:
    {
      int size_per_elt = 4 * 2;
      int shared_size = db.x * size_per_elt;
      prefix_sum_1_pass_1<<<dg,db,shared_size>>>();
      prefix_sum_1_pass_2<<<dg,db>>>();
    }
    break;
  case 2:
    {
      int size_per_elt = 4 * 4;
      int shared_size = db.x * size_per_elt;
      switch ( db.x ) {
      case 64:
        prefix_sum_1_opt_pass_1<6><<<dg,db,shared_size>>>();
        break;
      case 256:
        prefix_sum_1_opt_pass_1<8><<<dg,db,shared_size>>>();
        break;
      case 1024:
        prefix_sum_1_opt_pass_1<10><<<dg,db,shared_size>>>();
        break;
      }
      prefix_sum_1_pass_2<<<dg,db>>>();
    }
    break;

  case 4:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4 + 2;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      sort_segments_1_bit_split<<<dg,db,shared_size>>>();
    }
    break;

  case 5:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      sort_block_batcher<<<dg,db,shared_size>>>();
    }
    break;

  case 6:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      sort_block_batcher_1<<<dg,db,shared_size>>>();
    }
    break;

  case 7:
    {
      int elt_per_thread = 4;
      int size_per_elt = 4;
      int shared_size = db.x * size_per_elt * elt_per_thread;
      switch ( db.x ) {
      case 64: sort_block_batcher_opt<6><<<dg,db,shared_size>>>(); break;
      case 128: sort_block_batcher_opt<7><<<dg,db,shared_size>>>(); break;
      case 256: sort_block_batcher_opt<8><<<dg,db,shared_size>>>(); break;
      default:break;
      }
    }
    break;

  case 8:
    {
      const int bin_lg = 4;
      const int bin_size = 1 << bin_lg;
      int elt_per_thread = 4;
      int size_per_elt_1 = 4 + 2; // Assuming sort_bin_size < block_size
      int shared_size_pass_1 = db.x * size_per_elt_1 * elt_per_thread
        + 4 * bin_size * 4;
      int shared_size_pass_2 = (bin_size+1) * 4 * 3;
      int bins = int( ceil( 32.0 / bin_lg ) );
      for ( int bin_idx = 0; bin_idx < bins; bin_idx++ )
        {
          switch(db.x){
          case 64:
            radix_sort_1_pass_1<6,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx);
          break;
          case 128:
            radix_sort_1_pass_1<7,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx);
          break;
          case 256:
            radix_sort_1_pass_1<8,bin_lg><<<dg,db,shared_size_pass_1>>>
              (bin_idx);
          break;
          }

          radix_sort_1_pass_2<<<dg,db,shared_size_pass_2>>>(bin_idx);

        }
    }
    break;

  default:
    break;
  }
}

__device__ int lg_ceil(uint n)
{
  if ( n == 0 ) return 0;
  return 32 - __clz(n-1);
}

__device__ int div_ceil(int a, int b){return int( ceilf( ((float)a)/b ) );}


__global__ void
prefix_sum_0(int tree_level)
{
  /// Simple Prefix Sum Kernel
  //
  // Limited to one thread per element.

  // Does not work because writes can occur before reads.

  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  if ( tid >= array_size ) return;

  int idx = tid;
  int key_1;

  if ( tree_level == 0 )
    {
      key_1 = scan_in[ idx ];
      scan_out[idx] = key_1;
    }
  else
    {
      key_1 = scan_out[ idx ];
    }

  int dist = 1 << tree_level;
  if ( dist > idx ) return;
  int idx_0 = idx - dist;
  int key_0 = scan_out[ idx_0 ];
  scan_out[ idx ] = key_0 + key_1;
}


__device__ int
prefix_sum_1_pass_1_chunk(int idx_block_start, int sum_in);

__global__ void
prefix_sum_1_pass_1()
{
  int chunks_per_array = int( ceilf( float(array_size) / blockDim.x ));
  int chunks_per_block = int( ceilf( float(chunks_per_array) / gridDim.x ));
  int elt_per_block = chunks_per_block * blockDim.x;
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_stop = min( array_size, idx_block_start + elt_per_block );
  int sum = 0;
  for ( int idx_block = idx_block_start; idx_block < idx_stop;
        idx_block += blockDim.x )
    sum = prefix_sum_1_pass_1_chunk(idx_block, sum);

  scan_r2[blockIdx.x] = sum;
}

__device__ int
prefix_sum_1_pass_1_chunk(int idx_block_start, int sum_in)
{
  int idx = idx_block_start + threadIdx.x;

  // Copy input array to local memory.
  //
  s[ threadIdx.x ] = scan_in[idx];

  // Pointers to Read- and Write- Shared Memory Areas.
  //
  // Code will read one area of shared memory and write a different
  // one.
  //
  int sidx_rd = 0;
  int sidx_wr = blockDim.x;

  for ( int tree_level = 0; tree_level < block_lg; tree_level++ )
    {
      // Compute the distance to the neighbor to be read.
      //
      int dist = 1 << tree_level;

      __syncthreads();

      // Location of "our" element in read area of shared memory.
      //
      int sidx_1r = sidx_rd + threadIdx.x;

      // Location of our element in write area.
      //
      int sidx_1w = sidx_wr + threadIdx.x;

      // Read neighbor's element, or zero if there is no neighbor at that
      // distance.
      //
      int key_0 = threadIdx.x >= dist ? s[sidx_1r-dist] : 0;

      // Write sum.
      //
      s[sidx_1w] = key_0 + s[sidx_1r];

      // Swap indexes to read and write areas of shared memory.
      //
      int old_rd = sidx_rd; sidx_rd = sidx_wr; sidx_wr = old_rd;
    }

  // Write prefix to global memory, adding on value from previous chunk.
  //
  scan_out[idx] = s[ sidx_rd + threadIdx.x ] + sum_in;

  __syncthreads();

  // Return maximum value found in this chunk + prior chunks.
  //
  return s[ sidx_rd + blockDim.x-1] + sum_in;
}

template <int BLOCK_LG> __device__ int
prefix_sum_1_opt_pass_1_chunk(int idx_block_start, int sum_in);


template <int BLOCK_LG> __global__ void
prefix_sum_1_opt_pass_1()
{
  int chunks_per_array = int( ceilf( float(array_size) / blockDim.x ));
  int chunks_per_block = int( ceilf( float(chunks_per_array) / gridDim.x ));
  int elt_per_block = chunks_per_block * blockDim.x;
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_stop = min( array_size, idx_block_start + elt_per_block );
  int sum = 0;
  s[ threadIdx.x ] = 0;
  s[ threadIdx.x + 2 * blockDim.x ] = 0;
  for ( int idx_block = idx_block_start; idx_block < idx_stop;
        idx_block += blockDim.x )
    sum = prefix_sum_1_opt_pass_1_chunk<BLOCK_LG>(idx_block, sum);

  scan_r2[blockIdx.x] = sum;
}

template <int BLOCK_LG> __device__ int
prefix_sum_1_opt_pass_1_chunk(int idx_block_start, int sum_in)
{
  /// Optimized Prefix Sum Code
  //
  //  Routine is custom compiled for each needed block size using templates.


  int idx = idx_block_start + threadIdx.x;
  int block_size = 1 << BLOCK_LG;
  int sidx_rd = block_size;
  int sidx_wr = 3 * block_size;

  s[ sidx_rd + threadIdx.x ] = scan_in[idx];

  for ( int tree_level = 0; tree_level < BLOCK_LG; tree_level++ )
    {
      int dist = 1 << tree_level;

      // No need to sync if 32 (or fewer) threads.
      //
      if ( BLOCK_LG > 5 ) __syncthreads();

      int sidx_1r = sidx_rd + threadIdx.x;
      int sidx_1w = sidx_wr + threadIdx.x;

      // Shared memory has been padded with zeros so there is
      // no need to check whether dist <= threadIdx.x.
      //
      int key_0 = s[sidx_1r-dist];

      s[sidx_1w] = key_0 + s[sidx_1r];

      // Because loop is unrollable these should not generate
      // any code.
      //
      int old_rd = sidx_rd; sidx_rd = sidx_wr; sidx_wr = old_rd;
    }

  scan_out[idx] = s[ sidx_rd + threadIdx.x ] + sum_in;

  if ( BLOCK_LG > 5 ) __syncthreads();
  return s[ sidx_rd + block_size - 1 ] + sum_in;
}

__global__ void
prefix_sum_1_pass_2()
{
  __shared__ int sum_in;
  if ( threadIdx.x == 0 )
    {
      int sum = 0;
      for ( int i=0; i<((int)blockIdx.x); i++ )
        sum += scan_r2[i];
      sum_in = sum;
    }
  __syncthreads();
  int chunks_per_array = int( ceilf( float(array_size) / blockDim.x ));
  int chunks_per_block = int( ceilf( float(chunks_per_array) / gridDim.x ));
  int elt_per_block = chunks_per_block * blockDim.x;
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_stop = min( array_size, idx_block_start + elt_per_block );
  int idx_thread_start = idx_block_start + threadIdx.x;
  for ( int idx = idx_thread_start; idx < idx_stop; idx += blockDim.x )
    scan_out[idx] += sum_in;
}

__device__ void sort_block_1_bit_split(int bit_low, int bit_count);


__global__ void
sort_segments_1_bit_split()
{
  int elt_per_thread = 4;
  int elt_per_block = elt_per_thread * blockDim.x;
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_block_stop = idx_block_start + elt_per_block;

  int idx_start = idx_block_start + threadIdx.x;
  int key_base_rd = 0;

  // Load Elements
  //
  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += blockDim.x )
    s[sidx] = sort_in[ idx_block_start + sidx ];

  sort_block_1_bit_split(0,32);

  for ( int idx = idx_start, sidx = threadIdx.x;
        idx < idx_block_stop; sidx += blockDim.x, idx += blockDim.x )
        sort_out[idx] = s[ key_base_rd + sidx ];
}

__device__ void
sort_block_1_bit_split(int bit_low, int bit_count)
{
  const int elt_per_thread = 4;
  int elt_per_block = elt_per_thread * blockDim.x;
  int pfe_base_rd = elt_per_block;
  int pfi_base_rd = elt_per_block + 1;

  volatile __shared__ int col_total[16];
  if ( threadIdx.x < 16 )
    {
      s[ pfe_base_rd ] = 0;
      col_total[threadIdx.x] = 0;
    }

  // Sort Elements From LSB to MSB.
  //
  for ( int bit_pos=bit_low; bit_pos<bit_low+bit_count; bit_pos++ )
    {
      int bit_mask = 1 << bit_pos;
      int prefix_vector = 0;
      int count_bit = 1;

      int keys[elt_per_thread];

      __syncthreads();

      // Initialize data for prefix sum of bit bit_pos, and make copy of key.
      //
      for ( int sidx = threadIdx.x, i = 0;
            i < elt_per_thread; i++, sidx += blockDim.x )
        {
          keys[i] = s[ sidx ];
          if ( keys[i] & bit_mask ) prefix_vector += count_bit;
          count_bit = count_bit << 8;
        }

      s[ pfi_base_rd + threadIdx.x ] = prefix_vector;
      __syncthreads();
      uint pfv_1 = s[ pfe_base_rd + threadIdx.x ];

      // Compute Prefix Sum of Columns
      //
      for ( int tree_level = 0; tree_level < block_lg; tree_level++ )
        {
          int dist = 1 << tree_level;
          int idx_0 = threadIdx.x - dist;
          __syncthreads();
          uint pfv_0 = threadIdx.x >= dist ? s[ pfe_base_rd + idx_0 ] : 0;
          pfv_1 += pfv_0;
          s[ pfe_base_rd + threadIdx.x ] = pfv_1;
        }

      __syncthreads();

      const int ct_wbase = 8;
      if ( threadIdx.x < 8 )
        {
          int pfv = s[pfe_base_rd + blockDim.x - ( threadIdx.x & 0x1 ) ];
          int shift = ( threadIdx.x & 0x6 ) << 2;
          int my_val = ( pfv >> shift ) & 0xff;
          int sidx = ct_wbase + threadIdx.x;
          col_total[ sidx ] = my_val;
          col_total[ sidx ] = my_val += col_total[ sidx - 1 ] ;
          col_total[ sidx ] = my_val += col_total[ sidx - 2 ] ;
          col_total[ sidx ] = my_val += col_total[ sidx - 4 ] ;
        }

      __syncthreads();
      int ct_base = ct_wbase - 1;

#if 0
      if ( threadIdx.x == 0 && blockIdx.x == 0 )
        {
          for ( int i=0; i<5; i++ )
            scan_out[(bit_pos-bit_low)*16+i] = col_total[ct_base + 2*i];
        }
#endif

       int total_ones = col_total[ct_base+8];

      for ( int sidx = threadIdx.x, i = 0;
            i < elt_per_thread; i++, sidx += blockDim.x )
        {
          int count = ( pfv_1 & 0xff ) + col_total[ct_base+2*i];
          int key = keys[i];
          int new_idx = key & bit_mask
            ? elt_per_block - total_ones + count
            : sidx - count;
          s[ new_idx ] = key;
          pfv_1 >>= 8;
        }
    }
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

  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    sort_out[ idx_block_start + sidx ] = s[sidx];

}

template <int BLOCK_LG, int BIN_LG>
__device__ void radix_sort_1_pass_1_tile(int bin_idx, int tile_idx);

template <int BLOCK_LG, int BIN_LG> __global__ void
radix_sort_1_pass_1(int bin_idx)
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

  if ( threadIdx.x < bin_size ) s[ ghisto_sbase + threadIdx.x ] = 0;

  for ( int tile_idx = tile_start; tile_idx < tile_stop; tile_idx ++ )
    radix_sort_1_pass_1_tile<BLOCK_LG,BIN_LG>(bin_idx,tile_idx);

  if ( threadIdx.x >= bin_size ) return;
  int histo_idx = blockIdx.x * bin_size + threadIdx.x;
  sort_histo[ histo_idx ] = s[ ghisto_sbase + threadIdx.x ];
}

template <int BLOCK_LG, int BIN_LG> __device__ void
radix_sort_1_pass_1_tile(int bin_idx, int tile_idx)
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

  int *sort_src = bin_idx == 0 ? sort_in : sort_out;

  // Load Elements
  //
  for ( int sidx = threadIdx.x, i = 0;
        i < elt_per_thread; i++, sidx += block_size )
    s[sidx] = sort_src[ idx_block_start + sidx ];

  sort_block_1_bit_split(start_bit,sort_bin_lg);

  for ( int idx = idx_start, sidx = threadIdx.x;
        idx < idx_block_stop; sidx += block_size, idx += block_size )
    {
      sort_out_b[idx] = s[sidx];
      int digit = ( s[sidx] >> start_bit ) & sort_bin_mask;
      s[sidx] = digit;
    }

  if ( threadIdx.x == 0 ) s[elt_per_tile] = bin_size;

  if ( threadIdx.x < bin_size )
    s[ thisto_sbase + threadIdx.x ] = 0;

  __syncthreads();

  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = s[sidx];
      int digit_1 = s[sidx+1];
      if ( digit != digit_1 )
        s[ runend_sbase + digit ] = sidx;
    }

  __syncthreads();

  for ( int i = 0; i < elt_per_thread; i++ )
    {
      int sidx = threadIdx.x + i * block_size;
      int digit = s[sidx];
      int digit_0 = sidx > 0 ? s[sidx-1] : -1;
      if ( digit != digit_0 )
        {
          int run_end_sidx = s[ runend_sbase + digit ];
          int count = run_end_sidx - sidx + 1;
          s[ ghisto_sbase + digit ] += count;
          s[ thisto_sbase + digit ] = count;
        }
    }

  __syncthreads();

  if ( threadIdx.x >= bin_size ) return;

  int offset_idx = tile_idx * bin_size + threadIdx.x;
  sort_tile_histo[ offset_idx ] = s[ thisto_sbase + threadIdx.x ];
}

__device__ void radix_sort_1_pass_2_tile(int bin_idx, int tile_idx);

__device__ void
radix_sort_1_pass_2(int bin_idx)
{
  int elt_per_thread = 4;
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);

  int tile_start = tiles_per_block * blockIdx.x;
  int tile_stop = min( tiles_per_array, tile_start + tiles_per_block );

  int pf_prefix_sbase = 0;
  int pf_global_sbase = 1;
  int pf_offset_sbase_base = pf_global_sbase + sort_bin_size;
  int pf_prefix_sidx = pf_prefix_sbase + threadIdx.x;

  if ( threadIdx.x < sort_bin_size )
    {
      // Code only correct for sort_bin_size <= 32.

      int idx_for_us = blockIdx.x * sort_bin_size + threadIdx.x;
      int pidx_stop = gridDim.x * sort_bin_size;

      int global_bin_sum = 0;
      int overhead_bin_sum = 0;
      for ( int idx = threadIdx.x; idx < pidx_stop; idx += sort_bin_size )
        {
          if ( idx == idx_for_us ) overhead_bin_sum = global_bin_sum;
          global_bin_sum += sort_histo[idx];
        }

      int * volatile global_prefix = &s[ pf_global_sbase ];
      global_prefix[ threadIdx.x ] = global_bin_sum;

      int global_bin_prefix = global_bin_sum;

      for ( int i=0; i<sort_bin_lg; i++ )
        {
          int dist = 1 << i;
          int sum_0 = dist <= threadIdx.x
            ? global_prefix[ threadIdx.x - dist ] : 0;
          global_prefix[ threadIdx.x ] = global_bin_prefix += sum_0;
        }

      if ( threadIdx.x == 0 ) s[ pf_prefix_sbase ] = 0;
      s[ pf_prefix_sidx ] += overhead_bin_sum;
    }

  __syncthreads();

  int * volatile tile_offsets = &s[pf_offset_sbase_base];
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
          
          // int so_idx = tile_idx * sort_bin_size + threadIdx.x;
          //  if ( bin_idx == 1 ) scan_out[so_idx] = offset;
        }
      __syncthreads();
      radix_sort_1_pass_2_tile(bin_idx,tile_idx);
      __syncthreads();
      if ( threadIdx.x < sort_bin_size ) s[ pf_prefix_sidx ] += count;
    }
}

__device__ void
radix_sort_1_pass_2_tile(int bin_idx, int tile_idx)
{
  const int elt_per_thread = 4;
  int elt_per_tile = elt_per_thread * blockDim.x;
  int tiles_per_array = div_ceil(array_size,elt_per_tile);
  int tiles_per_block = div_ceil(tiles_per_array,gridDim.x);
  int idx_tile_start = tile_idx * elt_per_tile;

  int start_bit = bin_idx * sort_bin_lg;

  int pf_prefix_sbase = 0;
  int pf_global_sbase = 1;
  int pf_offset_sbase_base = pf_global_sbase + sort_bin_size;
  int pf_offset_sbase = pf_offset_sbase_base + sort_bin_size - 1;

  for ( int i=0; i<elt_per_thread; i++ )
    {
      int local_idx = threadIdx.x + i * blockDim.x;
      int idx = idx_tile_start + local_idx;
      uint key = sort_out_b[idx];
      uint digit = ( key >> start_bit ) & sort_bin_mask;
      int local_offset = s[ pf_offset_sbase + digit ];
      int key_digit_rank = local_idx - local_offset;
      int idx_digit_index = s[ pf_prefix_sbase + digit ] + key_digit_rank;
      sort_out[idx_digit_index] = key;
      //sort_out[idx] = idx_digit_index;
    }
}

#if 0
__global__ void
radix_sort_0_pass_1()
{
  int elt_per_block = int( ceilf( float(array_size) / blockDim.x ) );
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_block_stop = idx_block_start + elt_per_block;

  int idx_start = idx_block_start + threadIdx.x;

  for ( int idx = idx_start; idx < idx_block_stop; idx += blockDim.x )
    {
      int key = sort_in[idx];
      int digit = ( key >> sort_key_shift ) & sort_bin_mask;
      s[ threadIdx.x + ( digit << block_lg ) ]++;
    }

  __syncthreads();

  for ( int tree_level = 1; tree_level < block_lg; tree_level++ )
    {
      int dist = 1 << tree_level;
      int participation_mask = dist - 1;
      if ( threadIdx.x & participation_mask != participation_mask ) continue;
      int bin_neighbor = threadIdx.x - ( dist >> 1 );
      for ( int digit = 0; digit < sort_bin_size; digit++ )
        {
          int h_base = digit << block_lg;
          s[ h_base + threadIdx.x ] += s[ h_base + bin_neighbor ];
        }
    }

  if ( threadIdx.x >= sort_bin_size ) return;
  int so_base = sort_bin_count * blockIdx.x;
  scan_in[ so_base + threadIdx.x ] =
    s[ ( threadIdx.x << blockDim.x ) + blockDim.x - 1 ];
}

__global__ void
radix_sort_0_pass_2()
{
  int total_bin_count = sort_bin_count * gridDim.x;

  for ( int idx = threadIdx.x; idx < sort_all_bin_count; idx += blockDim.x )
    {
      int digit = idx & sort_bin_mask;
      int chunk = idx >> sort_bin_lg;
      int sidx = chunk + digit * gridDim.x;
      s[sidx] = scan_in[idx];
    }

  int base_rd = 0;
  int base_wr = total_bin_count;

  for ( int tree_level = 0; tree_level < sort_all_bin_lg; tree_level++ )
    {
      int dist = 1 << tree_level;
      for ( int idx = threadIdx.x; idx < total_bin_count; idx += blockDim.x )
        {
          int idx_0 = idx - dist;
          int key_0 = idx_0 >= 0 ? s[ base_rd + idx_0 ] : 0;
          s[ base_wr + idx ] = s[ base_rd + idx ] + key_0;
        }
      int base_rd_old = base_rd; base_rd = base_wr; base_wr = base_rd_old;
      __syncthreads();
    }

  if ( threadIdx.x < sort_bin_count )
    {
      int sidx = threadIdx.x * gridDim.x + blockIdx.x - 1;
      int my_bin = sidx >= 0 ? s[ base_rd + sidx ] : 0;
      __syncthreads();
      s[ threadIdx.x ] = my_bin;
    }

  int elt_per_block = int( ceilf( float(array_size) / blockDim.x ) );
  int idx_block_start = elt_per_block * blockIdx.x;
  int idx_block_stop = idx_block_start + elt_per_block;

  int idx_start = idx_block_start + threadIdx.x;

  for ( int idx = idx_start; idx < idx_block_stop; idx += blockDim.x )
    {
      int key = sort_in[idx];
      int digit = ( key >> sort_key_shift ) & sort_bin_mask;
      //  int idx_out = atomicAdd( &s[ digit ], 1 );
      int idx_out = s[ digit ]++;
      sort_out[idx_out] = key;
      __syncthreads();
    }
}
#endif
