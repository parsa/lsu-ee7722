/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
/// Homework 2 -- PARTIAL SOLUTION
/// Homework 3 -- Assignment (Edit this file.)

 // This file has a solution to Homework 2 Problem 3(a).
 // Edit this file to solve Homework 3.


#include "sol.cuh"

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
__constant__ int homework_R;
extern __shared__ float s[]; // Shared memory for buffering a elements.

__global__ void stencil();
__global__ void stencil_iter();
__global__ void stencil_shared();
__global__ void stencil_shared_2();
__global__ void stencil_shared_3();

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
  GETATTR(stencil_shared_3,'3');
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
  case '3': stencil_shared_3<<<dg,db,shared_bytes>>>(); break;
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
  // This code operates on a square array of pixels.

  // Compute the array_row_stride, which for this code is also equal
  // to the number of rows and the number of columns.
  //
  int array_row_stride = 1 << dim_size_lg;

  int array_row_mask = array_row_stride - 1;

  // Determine how many pixels each block will compute. The number is
  // based on the fact that the first and last thread of each block
  // never compute a pixel, the other threads compute at most one
  // pixel each.
  //
  int block_compute_width = blockDim.x - 2;

  // Determine how many blocks are needed to compute all of the
  // pixels in one row.  The computation is based on the fact that
  // the first and last pixels in a row should be left untouched.
  //
  int blocks_per_row =
    ceilf( float(array_row_stride-2) / block_compute_width );

  // Determine how many rows each block computes.
  //
  int rows_per_block =
    ceilf( float(blocks_per_row) * array_row_stride / gridDim.x );

  int cols_per_block = block_compute_width;

  // If this thread is past the last column that a block is supposed
  // to compute or load, then return.
  //
  if ( threadIdx.x >= cols_per_block + 2 ) return;

  // Compute a "large" row number for this block. These large
  // row numbers can exceed the number of rows in the array.
  // The actual row number to use is row_0_large mod blockDim.x,
  // the column number is 
  //  ( row_0_large / blockDim.x ) * cols_per_block + threadIdx.x.
  //
  int row_0_large = rows_per_block * blockIdx.x;       // Starting row.
  int row_9_large = row_0_large + rows_per_block + 2;  // Ending row.

  // A column group is a set of columns handled by one block. If
  // blocks_per_row < gridDim.x (the number of blocks) then a block
  // will have to cover more than one sets of columns (put another
  // way, a thread will have to cover more than one column).
  //
  int col_group_0 = row_0_large >> dim_size_lg;        // Starting column.
  int col_group_9 = row_9_large >> dim_size_lg;        // Ending column.

  // Compute indices into shared memory. At any one time shared memory
  // will hold three rows of pixels.  Index siu holds the upper row,
  // sidx holds the middle row (corresponding to the pixel to be written),
  // and sid is the lower (down) row.  A single shared memory array
  // is used to hold all three rows.
  //
  int siu = threadIdx.x;
  int sidx = siu + blockDim.x;
  int sid = sidx + blockDim.x;

  for ( int col_group = col_group_0; col_group <= col_group_9; col_group++ )
    {
      // The starting row will be zero if this isn't the first column
      // group (because computation reached the bottom of one column
      // and is now wrapping around to the top [row 0] of another column).
      //
      int row_0 =
        col_group == col_group_0 ? row_0_large & array_row_mask : 0;

      int row_9 = col_group == col_group_9
        ? ( row_9_large & array_row_mask ) : array_row_mask;

      // Compute the first column number for the block.
      //
      int col_0 = col_group * cols_per_block;

      // Compute the column number for this thread.
      //
      int col = col_0 + threadIdx.x;
      if ( col >= array_row_stride ) return;

      // Shift the row numbers over so that they can easily be used
      // to compute the array idx.
      //
      int row_0s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      // Check whether we should just load a value to shared memory.
      // If load_only is false then we both load the value and compute
      // a pixel.
      //
      bool load_only =
        threadIdx.x == 0 || threadIdx.x == cols_per_block + 1
        || col == array_row_stride - 1;

      // Compute the array index for the "up" row. This will be loaded
      // to shared memory but nothing will be computed for it.
      //
      int idx = row_0s | col;
      s[siu] = a[idx];

      // Increment by the row stride to obtain the address of the middle
      // row. We will compute a value for this in the first iteration
      // of the while loop below.
      //
      idx += array_row_stride;
      s[sidx] = a[idx];

      // Compute the array index at which we should stop.
      //
      int idx_stop = row_9s | col;

      // Compute pixels for column col, starting from row_0s +
      // array_row_stride and ending at row_9s.
      //
      while ( idx < idx_stop )
        {
          // Compute the address of the pixel in the row below us,
          // idx_next, and load it into shared memory.
          //
          int idx_next = idx + array_row_stride;
          s[sid] = a[idx_next];

          // Wait for other threads in this block to finish writing
          // shared memory.
          //
          __syncthreads();

          if ( !load_only )
            {
              // Compute the pixel value and write it to b.
#ifdef DEBUG_STENCIL
              b[idx] = v0 * s[sidx];
#else
              b[idx] = v0 * s[sidx]
                + v1 * ( s[sidx-1] + s[sidx+1] + s[siu] + s[sid] )
                + v2 * ( s[siu-1] + s[siu+1] + s[sid-1] + s[sid+1] );
#endif
            }


          // Wait for other threads in this block to finish reading
          // shared memory.
          //
          __syncthreads();

          // Rotate indices so that what is currently the middle row,
          // sidx, becomes the up row, and what is currently the down
          // row, sid, becomes the current row, and siu will be the sid.
          //
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;

          // Move the idx down one row.
          //
          idx = idx_next;
        }

    }
}


__global__ void
stencil_shared_2()
{
  /// SOLUTION - Homework 2

  /// DO NOT edit this routine for Homework 3, instead modify stencil_shared_3.

  /// NOTE: This solution is inefficient.
  //
  //  The code here will run more slowly than stencil_shared, at least
  //  on CC 1.x devices, due to inefficient global and shared memory
  //  access patterns.
  //
  //  This code does not include unrolling.  That will be added
  //  later to another routine.

  //
  // For the solution to Problem 3a the code here is adjusted so that
  // each thread can operate on R pixels. Look for the "Times R"
  // comments.
  //

  int array_row_stride = 1 << dim_size_lg;
  int array_row_mask = array_row_stride - 1;

  // Adjust the number of columns that each block computes.
  //
  int cols_per_block = blockDim.x * homework_R - 2;          //  Times R
  int blocks_per_row =
    ceilf( float(array_row_stride-2) / cols_per_block );

  int rows_per_block =
    ceilf( float(blocks_per_row) * array_row_stride / gridDim.x );

  int row_0_large = rows_per_block * blockIdx.x;
  int row_9_large = row_0_large + rows_per_block + 2;
  int col_group_0 = row_0_large >> dim_size_lg;
  int col_group_9 = row_9_large >> dim_size_lg;

  // Adjust the indices into shared memory.
  //
  int siu = threadIdx.x * homework_R;                        // Times R
  int sidx = siu + blockDim.x * homework_R;                  // Times R
  int sid = sidx + blockDim.x * homework_R;                  // Times R

  for ( int col_group = col_group_0; col_group <= col_group_9; col_group++ )
    {
      int row_0 =
        col_group == col_group_0 ? row_0_large & array_row_mask : 0;
      int row_9 = col_group == col_group_9
        ? ( row_9_large & array_row_mask ) : array_row_mask;

      int col_0 = col_group * cols_per_block;
      int col_9 = min( col_0 + cols_per_block, array_row_stride - 2 );

      // Since each thread handles R pixels need to multiply by R to
      // find the starting column number for a thread.
      //
      int col = col_0 + threadIdx.x * homework_R;            // Times R
      if ( col >= array_row_stride ) return;

      int row_s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      // Use loops to load data.
      //
      for ( int i=0; i<homework_R; i++ )
        {
          // Compute column number for this element.
          //
          int coli = col + i;

          // If column out of range skip this element.
          //
          if ( coli >= array_row_stride ) continue;

          // Compute array index, and cache elements.
          //
          int idx = row_s + coli;
          s[siu+i] = a[ idx ];
          s[sidx+i] = a[ idx + array_row_stride ];
        }

      row_s += array_row_stride;

      while ( row_s < row_9s )
        {
          int row_next = row_s + array_row_stride;
          
          for ( int i=0; i<homework_R; i++ )
            {
              // Cache the next row of elements.
              //
              int coli = col + i;
              if ( coli < array_row_stride ) s[sid + i] = a[ row_next + coli ];
            }

          __syncthreads();

          // Use a loop for computation.
          //
          for ( int i=0; i<homework_R; i++ )
            {
              // Compute column and if out of range, skip this element.
              //
              int coli = col + i;
              if ( coli == col_0 || coli > col_9 ) continue;
              int idx = row_s + coli;
#ifdef DEBUG_STENCIL
              b[idx] = v0 * s[sidx+i];
#else
              b[idx] = v0 * s[sidx+i]
                + v1 * ( s[sidx+i-1] + s[sidx+i+1] + s[siu+i] + s[sid+i] )
                + v2 * ( s[siu+i-1] + s[siu+i+1] + s[sid+i-1] + s[sid+i+1] );
#endif
            }
          __syncthreads();
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;
          row_s = row_next;
        }

    }
}

__global__ void
stencil_shared_3()
{
  /// SOLVE HOMEWORK 3 HERE

  /// NOTE: This code is inefficient.
  //
  //  The code here will run more slowly than stencil_shared, at least
  //  on CC 1.x devices, due to inefficient global and shared memory
  //  access patterns.
  //
  //  Fix it.

  int array_row_stride = 1 << dim_size_lg;
  int array_row_mask = array_row_stride - 1;

  // Adjust the number of columns that each block computes.
  //
  int cols_per_block = blockDim.x * homework_R - 2;          //  Times R
  int blocks_per_row =
    ceilf( float(array_row_stride-2) / cols_per_block );

  int rows_per_block =
    ceilf( float(blocks_per_row) * array_row_stride / gridDim.x );

  int row_0_large = rows_per_block * blockIdx.x;
  int row_9_large = row_0_large + rows_per_block + 2;
  int col_group_0 = row_0_large >> dim_size_lg;
  int col_group_9 = row_9_large >> dim_size_lg;

  // Adjust the indices into shared memory.
  //
  int siu = threadIdx.x * homework_R;                        // Times R
  int sidx = siu + blockDim.x * homework_R;                  // Times R
  int sid = sidx + blockDim.x * homework_R;                  // Times R

  for ( int col_group = col_group_0; col_group <= col_group_9; col_group++ )
    {
      int row_0 =
        col_group == col_group_0 ? row_0_large & array_row_mask : 0;
      int row_9 = col_group == col_group_9
        ? ( row_9_large & array_row_mask ) : array_row_mask;

      int col_0 = col_group * cols_per_block;
      int col_9 = min( col_0 + cols_per_block, array_row_stride - 2 );

      // Since each thread handles R pixels need to multiply by R to
      // find the starting column number for a thread.
      //
      int col = col_0 + threadIdx.x * homework_R;            // Times R
      if ( col >= array_row_stride ) return;

      int row_s = row_0 << dim_size_lg;
      int row_9s = row_9 << dim_size_lg;

      // Use loops to load data.
      //
      for ( int i=0; i<homework_R; i++ )
        {
          // Compute column number for this element.
          //
          int coli = col + i;

          // If column out of range skip this element.
          //
          if ( coli >= array_row_stride ) continue;

          // Compute array index, and cache elements.
          //
          int idx = row_s + coli;
          s[siu+i] = a[ idx ];
          s[sidx+i] = a[ idx + array_row_stride ];
        }

      row_s += array_row_stride;

      while ( row_s < row_9s )
        {
          int row_next = row_s + array_row_stride;
          
          for ( int i=0; i<homework_R; i++ )
            {
              // Cache the next row of elements.
              //
              int coli = col + i;
              if ( coli < array_row_stride ) s[sid + i] = a[ row_next + coli ];
            }

          __syncthreads();

          // Use a loop for computation.
          //
          for ( int i=0; i<homework_R; i++ )
            {
              // Compute column and if out of range, skip this element.
              //
              int coli = col + i;
              if ( coli == col_0 || coli > col_9 ) continue;

              int idx = row_s + coli;
#ifdef DEBUG_STENCIL
              b[idx] = v0 * s[sidx+i];
#else
              b[idx] = v0 * s[sidx+i]
                + v1 * ( s[sidx+i-1] + s[sidx+i+1] + s[siu+i] + s[sid+i] )
                + v2 * ( s[siu+i-1] + s[siu+i+1] + s[sid+i-1] + s[sid+i+1] );
#endif
            }
          __syncthreads();
          int sid_new = siu; siu = sidx; sidx = sid; sid = sid_new;
          row_s = row_next;
        }

    }
}
