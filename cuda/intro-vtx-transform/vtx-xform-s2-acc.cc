
#include "vtx-xform-s2.h"

void
acc_cuda_m(App* appptr)
{
  App app = *appptr;
  Elt_Type* __restrict din = app.d_in;
  Elt_Type* __restrict dout = app.d_out;
  const int nv = app.num_vecs;
#pragma acc parallel loop deviceptr(din,dout,app.d_out)
  for ( int i=0; i<nv; i++ )
    for ( int r=0; r<M; r++ )
      {
        Elt_Type sum = 0;
        for ( int c=0; c<N; c++ )
          sum += din[ i * N + c ] * app.matrix[r][c];
        dout[ i * M + r ] = sum;
      }
}

