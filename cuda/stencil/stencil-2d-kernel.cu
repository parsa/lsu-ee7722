#include "stencil-2d.cuh"
#include <gp/cuda-util-kernel.h>


// Constants holding array sizes and pointers and coefficients.
//
// Values are set by cuda calls, they don't automatically take values
// of variables in the C program with the same name.
//
__constant__ float v0, v1, v2;
__constant__ int array_size;
__constant__ int row_stride, dim_size_lg, dim_block_lg;
__constant__ float* a;
__constant__ float* b;
extern __shared__ float s[]; // Shared memory for buffering a elements.

__global__ void stencil();
__global__ void stencil_iter();
__global__ void stencil_blocked();
__global__ void stencil_shared();

__host__ cudaError_t
kernels_get_attr(struct cudaFuncAttributes *attr, char **names)
{
  cudaError_t er;

  CU_SYM(a); CU_SYM(b);
  CU_SYM(array_size);
  CU_SYM(row_stride); CU_SYM(dim_size_lg); CU_SYM(dim_block_lg);
  CU_SYM(v0); CU_SYM(v1); CU_SYM(v2);

#define GETATTR(func)                                                         \
  er = cudaFuncGetAttributes(attr,func); *names = #func; attr++; names++;     \
  if ( er ) return er;
  GETATTR(stencil);
  GETATTR(stencil_iter);
  GETATTR(stencil_blocked);
  GETATTR(stencil_shared);
  *names = NULL;
  return er;
#undef GETATTR
}

// This routine executes on the CPU.
//
__host__ void
stencil_launch(dim3 dg, dim3 db, bool blocked)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
  //  stencil<<<dg,db>>>();
  if ( blocked )
    {
      stencil_shared<<<dg,db,db.x*3*sizeof(float)>>>();
    }
  else
    {
      stencil_iter<<<dg,db>>>();
    }
}

__global__ void
stencil()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int row_mask = row_stride - 1;

  int col = idx & row_mask;
  int row = idx >> dim_size_lg;
  if ( row == 0 || row >= row_mask || col == 0 || col == row_mask ) return;

  int iu = idx - row_stride;
  int id = idx + row_stride;

  b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] + a[iu] + a[id] )
    + v2 * ( a[iu-1] + a[iu+1] + a[id-1] + a[id+1] );
}

__global__ void
stencil_iter()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int row_mask = row_stride - 1;
  int thread_count = blockDim.x * gridDim.x;

  for ( int idx = tid;  idx < array_size;  idx += thread_count )
    {
      int col = idx & row_mask;
      int row = idx >> dim_size_lg;
      if ( row == 0 || row >= row_mask || col == 0 || col == row_mask )
        continue;

      int iu = idx - row_stride;
      int id = idx + row_stride;

      b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] + a[iu] + a[id] )
        + v2 * ( a[iu-1] + a[iu+1] + a[id-1] + a[id+1] );
    }
}

__global__ void
stencil_blocked()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int tix = threadIdx.x;
  int tid = tix + blockIdx.x * blockDim.x;
  int thread_count = blockDim.x * gridDim.x;

  int last_lrow = ( 1 << dim_block_lg ) - 1;
  int last_row = ( 1 << dim_size_lg ) - 1;

  int col_mask = ( 1 << dim_block_lg ) - 1;
  int array_row_stride = 1 << dim_size_lg;

  int thd_lrow = tix >> dim_block_lg;
  int thd_lcol = tix & col_mask;

  int block_col_shift = dim_block_lg << 1;
  int block_row_shift = dim_size_lg + dim_block_lg;
  int dim_umm_lg = dim_size_lg - dim_block_lg;
  int block_side_mask = ( 1 << dim_umm_lg ) - 1;

  int fat_row_stride = ( 1 << dim_block_lg ) + 2;

  int sidx = ( thd_lrow + 1 ) * fat_row_stride + ( thd_lcol + 1 );
  int siu = sidx - fat_row_stride;
  int sid = sidx + fat_row_stride;

  for ( int itid = tid; itid < array_size; itid += thread_count )
    {
      int block_col_start = ( itid >> block_col_shift ) & block_side_mask;
      int block_row_start = ( itid >> block_row_shift ) & block_side_mask;

      int thd_col = ( block_col_start << dim_block_lg ) + thd_lcol;
      int thd_row = ( block_row_start << dim_block_lg ) + thd_lrow;

      int idx = ( thd_row << dim_size_lg ) | thd_col;

      int iu = idx - array_row_stride;
      int id = idx + array_row_stride;
      s[sidx] = a[idx];

      bool edge = thd_row == 0 || thd_col == 0
        || thd_row == last_row || thd_col == last_row;

      if ( thd_lrow == 0 && thd_row > 0 )
        s[siu] = a[iu];
      if ( thd_lrow == last_lrow && thd_row < last_row )
        s[sid] = a[id];
      if ( thd_lcol == 0 && thd_col > 0 )
        s[sidx-1] = a[idx-1];
      if ( thd_lcol == last_lrow && thd_col < last_row )
        s[sidx+1] = a[idx+1];
      if ( thd_lrow == 0 && thd_lcol == 0 && !edge )
        s[siu-1] = a[iu-1];
      if ( thd_lrow == 0 && thd_lcol == last_lrow &&
           thd_row > 0 && thd_col < last_row )
        s[siu+1] = a[iu+1];
      if ( thd_lrow == last_lrow && thd_lcol == last_lrow
           && thd_row < last_row && thd_col < last_row )
        s[sid+1] = a[id+1];
      if ( thd_lrow == last_lrow && thd_lcol == 0
           && thd_row < last_row && thd_col > 0 )
        s[sid-1] = a[id-1];

      __syncthreads();

      if ( edge ) continue;

#if DEBUG_STENCIL
      b[idx] = v0 * s[sid+1];
#else
      b[idx] = v0 * s[sidx] + v1 * ( s[sidx-1] + s[sidx+1] + s[siu] + s[sid] )
        + v2 * ( s[siu-1] + s[siu+1] + s[sid-1] + s[sid+1] );
#endif
    }

}


__global__ void
stencil_shared()
{
  // Compute a unique index (number) for this thread.
  // This will be used as an array index.
  //
  int array_row_stride = 1 << dim_size_lg;
  int array_row_mask = array_row_stride - 1;

  int block_compute_width = blockDim.x - 2;
  int blocks_per_row =
    int( ceilf( float(array_row_stride-2) / block_compute_width ) );

  int rows_per_block =
    float(blocks_per_row) * array_row_stride / gridDim.x + 0.999f;

  int row_0_large = rows_per_block * blockIdx.x;
  int row_9_large = row_0_large + rows_per_block + 2;
  int col_group_0 = row_0_large >> dim_size_lg;
  int col_group_9 = row_9_large >> dim_size_lg;

  int siu = threadIdx.x;
  int sidx = siu + blockDim.x;
  int sid = sidx + blockDim.x;

  for ( int col_group = col_group_0; col_group <= col_group_9; col_group++ )
    {
      int row_0 = 
        col_group == col_group_0 ? row_0_large & array_row_mask : 0;
      int row_9 = col_group == col_group_9
        ? ( row_9_large & array_row_mask ) : array_row_mask;

      int col_0 = col_group * block_compute_width;
      int col_9 = min( col_0 + blockDim.x, array_row_stride );

      int col = col_0 + threadIdx.x;
      if ( col >= array_row_stride ) return;
      int row_0s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      bool load_only =
        threadIdx.x == 0 || threadIdx.x == blockDim.x-1
        || col == array_row_stride - 1;

      int rows = row_0s;
      int idx = rows | col;
      int idx_stop = row_9s | col;
      s[siu] = a[idx];
      idx += array_row_stride;
      s[sidx] = a[ idx ];
      while ( idx < idx_stop )
        {
          int idx_next = idx + array_row_stride;
          s[sid] = a[idx_next];
          s[sid+1] = a[idx_next+1];
          __syncthreads();
          if ( !load_only )
            {
#if DEBUG_STENCIL
              b[idx] = v0 * s[sidx];
#else
              b[idx] = v0 * s[sidx]
                + v1 * ( s[sidx-1] + s[sidx+1] + s[siu] + s[sid] )
                + v2 * ( s[siu-1] + s[siu+1] + s[sid-1] + s[sid+1] );
#endif
            }
          //  __syncthreads();
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;
          idx = idx_next;
        }

    }


}
