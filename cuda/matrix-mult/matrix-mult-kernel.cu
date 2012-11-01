#include "matrix-mult.cuh"
#include <gp/cuda-util-kernel.h>

// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ int array_size, array_size_lg;
__constant__ int row_stride, row_stride_lg, dim_block_lg;
__constant__ float *a, *b, *c;
__constant__ int32_t *t_compute, *t_all;
extern __shared__ float s[]; // Shared memory for buffering a elements.

__constant__ int cs_itid_stride;

texture<float> a_tex, b_tex;

__global__ void mm();
__global__ void mm_iter();
__global__ void mm_blk_cache_ab();
__global__ void mm_blk_cache_ab_opt();
__global__ void mm_blk_cache_ab_tc();
__global__ void mm_blk_cache_a_local();

template <int dim_block> __global__ void
mm_blk_cache_a_local_t();


static __host__ void
collect_symbols()
{
  CU_SYM(array_size); CU_SYM(array_size_lg);
  CU_SYM(row_stride); CU_SYM(row_stride_lg); CU_SYM(dim_block_lg);
  CU_SYM(a); CU_SYM(b); CU_SYM(c);
  CU_SYM(t_compute); CU_SYM(t_all);
  CU_SYM(cs_itid_stride);
}


static __host__ int
kernels_get_attr_(pCUDA_Func_Attributes *attr)
{
  collect_symbols();

  int count = 0;

#define GETATTR(func)                                                         \
  count++;                                                                    \
  if ( attr ) {                                                               \
      attr->err = cudaFuncGetAttributes(&attr->attr,func);                    \
      attr->name = #func;                                                     \
      attr++;                                                                 \
    }

  GETATTR(mm);
  GETATTR(mm_iter);
  GETATTR(mm_blk_cache_ab);
  GETATTR(mm_blk_cache_ab_opt);
  GETATTR(mm_blk_cache_a_local_t<3>);
  GETATTR(mm_blk_cache_a_local_t<4>);
  GETATTR(mm_blk_cache_ab_tc);
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
mmult_launch(dim3 dg, dim3 db, int version,
             void *a_dev, void *b_dev, int array_size)
{
  static bool tex_bound = false;

  const bool need_tex = version == 6;

  if ( need_tex && !tex_bound )
    {
      const size_t size = array_size * sizeof(float);
      size_t offset;
      const cudaChannelFormatDesc fd =
        cudaCreateChannelDesc(32,0,0,0,cudaChannelFormatKindFloat);
      cudaBindTexture(&offset, a_tex, a_dev, fd, size);
      cudaBindTexture(&offset, b_tex, b_dev, fd, size);
      tex_bound = true;
    }
  else if ( !need_tex && tex_bound )
    {
      cudaUnbindTexture(a_tex);
      cudaUnbindTexture(b_tex);
      tex_bound = false;
    }

  // Launch the kernel, using the provided configuration (block size, etc).
  //
  switch ( version ){
  case 1: mm_iter<<<dg,db>>>(); break;
  case 2:
    {
      int shared_size = 2 * 4 * db.x;
      mm_blk_cache_ab<<<dg,db,shared_size>>>();
    }
    break;
  case 3:
    {
      int shared_size = 2 * 4 * db.x;
      mm_blk_cache_ab_opt<<<dg,db,shared_size>>>();
    }
    break;
  case 4:
    {
      int shared_size = 4 * db.x;
      if ( db.x == 64 ) mm_blk_cache_a_local_t<3><<<dg,db,shared_size>>>();
    }
    break;
  case 5:
    {
      int shared_size = 4 * db.x;
      if ( db.x == 256 ) mm_blk_cache_a_local_t<4><<<dg,db,shared_size>>>();
    }
    break;
  case 6:
    {
      mm_blk_cache_ab_tc<<<dg,db>>>();
    }
    break;
  }
}

__global__ void
mm()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = threadIdx.x + blockIdx.x * blockDim.x;

  if ( idx > array_size ) return;

  int row_mask = row_stride - 1;
  int col = idx & row_mask;
  int row = idx >> row_stride_lg;
  int idx_base = row << row_stride_lg;

  float c_value = 0;

  for ( int k=0; k<row_stride; k++ )
    {
      int a_idx = idx_base | k;
      int b_idx = ( k << row_stride_lg ) | col;
      c_value += a[a_idx] * b[b_idx];
    }

  c[idx] = c_value;
}

__global__ void
mm_iter()
{
  bool lane_0 = ( threadIdx.x & 0x1f ) == 0;
  int time_start = clock();

  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;
  int row_mask = row_stride - 1;

  ///
  /// Iteration Strategy
  //
  // Value of c_idx in first iteration of loop below assuming:
  //   Array size is 1024 x 1024
  //   Block size is 256 threads.
  //
  //    9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0   <- Bit position.
  //   |              blockIdx |     threadIdx |  <- Relationship to threads.
  //   |   row             |     col           |  <- Array element.
  //
  // Value of c_idx in the second iteration of the loop below:
  //
  //    9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0   <- Bit position.
  //   |    gridDim + blockIdx |     threadIdx |  <- Relationship to threads.
  //   |   row             |     col           |  <- Array element.
  //
  // Value of c_idx in the third iteration of the loop below:
  //
  //    9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0   <- Bit position.
  //   |    2 * gridDim + blockIdx | threadIdx |  <- Relationship to threads.
  //   |   row             |     col           |  <- Array element.


  for ( int c_idx = tid; c_idx < array_size; c_idx += thread_count )
    {
      int col = c_idx & row_mask;
      int row = c_idx >> row_stride_lg;
      int a_idx_base = row << row_stride_lg;

      float c_value = 0;

      for ( int k=0; k<row_stride; k++ )
        {
          int a_idx = a_idx_base | k;
          int b_idx = ( k << row_stride_lg ) | col;
          c_value += a[a_idx] * b[b_idx];
        }

      c[c_idx] = c_value;
    }

  if ( !lane_0 ) return;
  t_all[tid>>5] = clock() - time_start;
  t_compute[tid>>5] = 0;
}

__global__ void
mm_blk_cache_ab()
{
  int group_count_lg = row_stride_lg - dim_block_lg;
  int group_count = 1 << group_count_lg;
  int dim_block = 1 << dim_block_lg;
  int local_row_mask = dim_block - 1;
  int block_lg = dim_block_lg << 1;

  int local_col = threadIdx.x & local_row_mask;
  int local_row = threadIdx.x >> dim_block_lg;
  int b_sidx_base = blockDim.x;
  int a_sidx = threadIdx.x;
  int b_sidx = threadIdx.x + b_sidx_base;

  int row_idx_pos = row_stride_lg;
  int row_sidx_pos = dim_block_lg;

  int c_col = ( blockIdx.x << dim_block_lg ) + local_col;
  int c_row = local_row << row_stride_lg;
  int itid_stride = gridDim.x << dim_block_lg;

  for ( ;; c_col += itid_stride )
    {
      int col_overflow = c_col >> row_stride_lg;
      c_row += col_overflow << ( dim_block_lg + row_stride_lg );
      c_col &= row_stride - 1;

      int c_idx = c_row + c_col;

      if ( c_row >= array_size ) break;

      float c_value = 0;

      int a_idx = c_row + local_col;
      int b_idx = ( local_row << row_idx_pos ) | c_col;

      for ( int k_group = 0; k_group < group_count; k_group++ )
        {
          s[a_sidx] = a[a_idx];
          s[b_sidx] = b[b_idx];

          a_idx += 1 << dim_block_lg;
          b_idx += 1 << ( block_lg + group_count_lg );

          __syncthreads();

          for ( int kk = 0; kk < dim_block; kk++ )
            {
              int a_sidx_k = ( local_row << row_sidx_pos ) | kk;
              int b_sidx_k =
                b_sidx_base + ( ( kk << row_sidx_pos ) | local_col );

              c_value += s[a_sidx_k] * s[b_sidx_k];
            }

          __syncthreads();
        }

      c[c_idx] = c_value;
    }
}

__global__ void
mm_blk_cache_ab_tc()
{
  int group_count_lg = row_stride_lg - dim_block_lg;
  int group_count = 1 << group_count_lg;
  int dim_block = 1 << dim_block_lg;
  int local_row_mask = dim_block - 1;

  int local_col = threadIdx.x & local_row_mask;
  int local_row = threadIdx.x >> dim_block_lg;

  int c_col = ( blockIdx.x << dim_block_lg ) + local_col;
  int c_row = local_row << row_stride_lg;
  int itid_stride = gridDim.x << dim_block_lg;

  for ( ;; c_col += itid_stride )
    {
      int col_overflow = c_col >> row_stride_lg;
      c_row += col_overflow << ( dim_block_lg + row_stride_lg );
      c_col &= row_stride - 1;

      int c_idx = c_row + c_col;

      if ( c_row >= array_size ) break;

      float c_value = 0;

      int a_idx = c_row;
      int b_idx = c_col;

      for ( int k_group = 0; k_group < group_count; k_group++ )
        {
          __syncthreads();


#define LOOP(DIM_BLOCK)                                                       \
          for ( int kk = 0; kk < DIM_BLOCK; kk++ )                            \
            {                                                                 \
              c_value += tex1Dfetch(a_tex,a_idx) * tex1Dfetch(b_tex,b_idx);   \
              a_idx++; b_idx += row_stride;                                   \
            }

          if ( dim_block == 16 ) { LOOP(16); }
          else if ( dim_block == 8 ) { LOOP(8); }
          else { LOOP(dim_block); }
#undef LOOP

        }

      c[c_idx] = c_value;
    }
}

__global__ void
mm_blk_cache_ab_opt()
{
  bool lane_0 = ( threadIdx.x & 0x1f ) == 0;
  int time_start = clock();
  int time_compute = 0;

  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;
  int group_count_lg = row_stride_lg - dim_block_lg;
  int group_count = 1 << group_count_lg;
  int dim_block = 1 << dim_block_lg;
  int local_row_mask = dim_block - 1;
  int block_lg = dim_block_lg << 1;

  int col_group_itid_pos = block_lg;
  int row_group_itid_pos = block_lg + group_count_lg;
  int col_group_mask = group_count - 1;
  int row_group_idx_pos = row_group_itid_pos;
  int col_group_idx_pos = dim_block_lg;
  int row_idx_pos = row_stride_lg;
  int row_sidx_pos = dim_block_lg;

  int local_col = threadIdx.x & local_row_mask;
  int local_row = threadIdx.x >> row_sidx_pos;
  int b_sidx_base = blockDim.x;
  int a_sidx = threadIdx.x;
  int b_sidx = threadIdx.x + b_sidx_base;

  for ( int itid = tid; itid < array_size; itid += thread_count )
    {
      int row_group = itid >> row_group_itid_pos;
      int col_group = itid >> col_group_itid_pos & col_group_mask;
      if ( row_group > group_count ) break;

      int c_idx =
        ( row_group << row_group_idx_pos )
        | ( local_row << row_idx_pos )
        | ( col_group << col_group_idx_pos )
        | local_col;

      float c_value = 0;

      int a_idx =
        ( row_group << row_group_idx_pos )
        | ( local_row << row_idx_pos )
        | local_col;
      int a_idx_stride = 1 << col_group_idx_pos;
      int b_idx =
        ( local_row << row_idx_pos )
        | ( col_group << col_group_idx_pos )
        | local_col;
      int b_idx_stride = 1 << row_group_idx_pos;


      for ( int k_group = 0; k_group < group_count; k_group++ )
        {
          s[a_sidx] = a[a_idx];
          s[b_sidx] = b[b_idx];
          a_idx += a_idx_stride;
          b_idx += b_idx_stride;

          __syncthreads();
          int compute_start = clock();

          int a_sidx_k = ( local_row << row_sidx_pos );
          int b_sidx_k = b_sidx_base | local_col;

#define LOOP                                                                  \
          for ( int kk = 0; kk < dim_block; kk++ )                            \
            {                                                                 \
              c_value += s[a_sidx_k] * s[b_sidx_k];                           \
              a_sidx_k++;                                                     \
              b_sidx_k += row_sidx_stride;                                    \
            }

          if ( row_sidx_pos == 3 )
            {
              int row_sidx_stride = 8;
              #pragma unroll 8
              LOOP;
            }
          else if ( row_sidx_pos == 4 )
            {
              int row_sidx_stride = 16;
              #pragma unroll 16
              LOOP;
            }
          else
            {
              int row_sidx_stride = 1 << row_sidx_pos;
              LOOP;
            }

          __syncthreads();
          time_compute += clock() - compute_start;
        }

      c[c_idx] = c_value;
    }
  if ( !lane_0 ) return;
  t_all[tid>>5] = clock() - time_start;
  t_compute[tid>>5] = time_compute;
}


template <int DIM_BLOCK_LG> __global__ void
mm_blk_cache_a_local_t()
{
  int dim_block = 1 << DIM_BLOCK_LG;
  int block_lg = DIM_BLOCK_LG << 1;

  int local_a_col = threadIdx.x & ( dim_block - 1 );
  int local_a_row = threadIdx.x >> DIM_BLOCK_LG;
  int c_idx_col = threadIdx.x;
  int b_sidx_copy = threadIdx.x;

  int itid_stride = gridDim.x << ( DIM_BLOCK_LG + row_stride_lg );
  int c_idx_row = blockIdx.x << ( DIM_BLOCK_LG + row_stride_lg );

  /// C Block Loop: Each iteration computes blk values of C.
  //
  for ( ;; c_idx_row += itid_stride )
    {
      int row_overflow = c_idx_row >> array_size_lg << block_lg;
      c_idx_col += row_overflow;
      c_idx_row &= array_size - 1;
      if ( c_idx_col >= row_stride ) break;

      int c_idx = c_idx_row + c_idx_col;

      int a_idx = ( local_a_row << row_stride_lg ) + c_idx_row + local_a_col;
      int b_idx = c_idx_col;

      float cloc[1 << DIM_BLOCK_LG];

      for ( int kk=0; kk<dim_block; kk++ ) cloc[kk] = 0;

      /// A Block Loop:  Each iteration uses a blk x blk submatrix of A.
      //  The iterations move across columns.
      //
      while ( b_idx < array_size )
        {
          __syncthreads();
          s[b_sidx_copy] = a[a_idx];
          a_idx += dim_block;
          __syncthreads();

          /// B Value Loop: Each iteration uses one value of B.
#         pragma unroll
          for ( int kk = 0; kk < dim_block; kk++, b_idx += row_stride )
            {
              float b_val = b[b_idx];
              for ( int ii = 0; ii < dim_block; ii++ )
                cloc[ii] +=  s[ kk + dim_block * ii ] * b_val;
            }
        }

      for ( int ii = 0 ; ii < dim_block; ii++ )
        c[ c_idx + ii * row_stride ] = cloc[ ii ];
    }
}
