/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 2

 /// See stencil-2d.cc for instructions.

#include "stencil-2d.cuh"

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
__global__ void stencil_shared();
__global__ void stencil_shared_2();

static __host__ int
kernels_get_attr_(pCUDA_Func_Attributes *attr)
{
  int count = 0;

#define GETATTR(func,version)                                                 \
  count++;                                                                    \
  if ( attr ) {                                                               \
      attr->err = cudaFuncGetAttributes(&attr->attr,func);                    \
      attr->name = #func;                                                     \
      attr->abbrev = version;                                                 \
      attr++;                                                                 \
    }

  GETATTR(stencil,'1');
  GETATTR(stencil_iter,'i');
  GETATTR(stencil_shared,'s');
  GETATTR(stencil_shared_2,'2');
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
stencil_launch(dim3 dg, dim3 db, int shared_bytes, char version)
{
  // Launch the kernel, using the provided configuration (block size, etc).
  //
   switch ( version ) {
  case 'i': stencil_iter<<<dg,db>>>(); break;
  case 's': stencil_shared<<<dg,db,shared_bytes>>>(); break;
  case '2': stencil_shared_2<<<dg,db,shared_bytes>>>(); break;
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

#ifdef DEBUG_STENCIL
      b[idx] = v0 * a[idx];
#else
      b[idx] = v0 * a[idx] + v1 * ( a[idx-1] + a[idx+1] + a[iu] + a[id] )
        + v2 * ( a[iu-1] + a[iu+1] + a[id-1] + a[id+1] );
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
    ceilf( float(array_row_stride-2) / block_compute_width );

  int rows_per_block =
    ceilf( float(blocks_per_row) * array_row_stride / gridDim.x );

  //  int cols_per_block = ceilf( float(array_row_stride) / blocks_per_row );
  int cols_per_block = blockDim.x - 2;
  if ( threadIdx.x >= cols_per_block + 2 ) return;

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

      int col_0 = col_group * cols_per_block;
      int col_9 = min( col_0 + cols_per_block + 2, array_row_stride );

      int col = col_0 + threadIdx.x;
      if ( col >= array_row_stride ) return;
      int row_0s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      bool load_only =
        threadIdx.x == 0 || threadIdx.x == cols_per_block + 1
        || col == array_row_stride - 1;

      int rows = row_0s;
      int idx = rows | col;
      int idx_stop = row_9s | col;
      s[siu] = a[idx];
      idx += array_row_stride;
      s[sidx] = a[idx];
      while ( idx < idx_stop )
        {
          int idx_next = idx + array_row_stride;
          s[sid] = a[idx_next];
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
          __syncthreads();
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;
          idx = idx_next;
        }

    }
}


__global__ void
stencil_shared_2()
{
  /// Modify this code.

  int array_row_stride = 1 << dim_size_lg;
  int array_row_mask = array_row_stride - 1;

  int block_compute_width = blockDim.x - 2;
  int blocks_per_row =
    ceilf( float(array_row_stride-2) / block_compute_width );

  int rows_per_block =
    ceilf( float(blocks_per_row) * array_row_stride / gridDim.x );

  //  int cols_per_block = ceilf( float(array_row_stride) / blocks_per_row );
  int cols_per_block = blockDim.x - 2;
  if ( threadIdx.x >= cols_per_block + 2 ) return;

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

      int col_0 = col_group * cols_per_block;
      int col_9 = min( col_0 + cols_per_block + 2, array_row_stride );

      int col = col_0 + threadIdx.x;
      if ( col >= array_row_stride ) return;
      int row_0s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      bool load_only =
        threadIdx.x == 0 || threadIdx.x == cols_per_block + 1
        || col == array_row_stride - 1;

      int rows = row_0s;
      int idx = rows | col;
      int idx_stop = row_9s | col;
      s[siu] = a[idx];
      idx += array_row_stride;
      s[sidx] = a[idx];
      while ( idx < idx_stop )
        {
          int idx_next = idx + array_row_stride;
          s[sid] = a[idx_next];
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
          __syncthreads();
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;
          idx = idx_next;
        }

    }
}
