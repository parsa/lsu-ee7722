
#include "vtx-xform-s2.h"
#include <string.h>

extern "C" void
acc_cuda_m(App* aptr)
{
  // Make local copies because PGI gets confused by structure members.
  //
  Elt_Type* const __restrict din = aptr->d_in;
  Elt_Type* const __restrict dout = aptr->d_out;
  Elt_Type m[M][N]; memcpy(m,aptr->matrix,sizeof(m));
  const int nv = aptr->num_vecs;

#pragma acc parallel loop deviceptr(din,dout) independent
  for ( int i=0; i<nv; i++ )
#pragma acc loop seq
    for ( int r=0; r<M; r++ )
      {
        Elt_Type sum = 0;
#pragma acc loop seq
        for ( int c=0; c<N; c++ )
          sum += din[ i * N + c ] * m[r][c];
        dout[ i * M + r ] = sum;
      }

  /// Notes on code above. ( 9 January 2017, 13:34:47 CST)
  //
  // Tuned for PGI ACC 16.10.
  //
  // Code was much better using copies of the d_in and d_out pointers
  // and copies of matrix.
  //
  // With only the single pragma at the top of the loop, open ACC
  // will distribute inner loop iterations across threads, resulting
  // in horrible performance.  Placing the "loop seq" pragmata before
  // the two inner loops helps alot.
  //
  // The hand-written CUDA code uses constant memory for matrix. There
  // is no obvious way to provide a hint for the use of constant
  // memory in OpenACC 2.5 or in PGI acc. Using the cache attribute
  // doesn't work, I guess it's asking alot for that to be interpreted
  // as a hint to use something other than CUDA shared memory.
  //
  // Performance on a K20: 

// ACC:       -- -- wp    3744 µs    72 GF    36 GB/s ********
// mxv_i_lbuf 12 24 wp    3159 µs    85 GF    42 GB/s **********
// mxv_vls     8 16 wp    1197 µs   224 GF   112 GB/s **************************
// mxv_sh_oc. 16 32 wp    1253 µs   214 GF   107 GB/s *************************

// Without the loop seq pragmata execution time would be 267568 µs.

}

