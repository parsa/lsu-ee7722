/// LSU EE X70X GPU Prog / Microarch
//
 /// Code for computing reflection points on cylinder.

#include <complex>
#include "gra-alhazan.h"

using std::complex;
typedef complex<double> cdouble;

double
alhazan_check(pCoor center,pCoor eye,pCoor vertex,pCoor mirror)
{
  pNorm me(mirror,eye);
  pNorm mv(mirror,vertex);
  pNorm mc(mirror,center);
  const double de = dot(me,mc);
  const double dv = dot(mv,mc);
  const double err = fabs(dv-de);
  return err;
}

pCoor
alhazan(pCoor center, double radius, pCoor eye, pCoor vertex)
{
  //  http://mathworld.wolfram.com/AlhazensBilliardProblem.html
  //  http://www.math.sjsu.edu/~alperin/Alhazen.pdf

  pVect c_to_e(center,eye);
  pVect c_to_v(center,vertex);

  pNorm dir_a(c_to_e);
  pNorm dir_b(c_to_v);

  const double close = 0.001;

#define RETURN(rvp)                                                           \
  {                                                                           \
    pCoor rv = rvp;                                                           \
    double err = alhazan_check(center,eye,vertex,rv);                         \
    ASSERTS( err < 0.001 );                                                   \
    return rv;                                                                \
  }

  if ( dir_a.magnitude < close ) RETURN(center + radius * dir_b);
  if ( dir_b.magnitude < close ) RETURN(center + radius * dir_a);

  const double ab_dot = dot(dir_a,dir_b);

  pNorm e_to_v(eye,vertex);

  const double rad_inv = 1/radius;

  pNorm dir_ab( dir_a + dir_b );
  pNorm dir_ev( c_to_e + c_to_v );

  pCoor rv1 = center + radius * dir_ab;
  pCoor rv2 = center + radius * ( -dir_ev + 2 * dir_ab );
  pCoor rv3 = center + radius * ( 2 * dir_ev -  dir_ab );
  pCoor rva = center + radius * dir_a;
  pCoor rvb = center + radius * dir_b;
  double err1 = alhazan_check(center,eye,vertex,rv1);
  double err2 = alhazan_check(center,eye,vertex,rv2);
  double err3 = alhazan_check(center,eye,vertex,rv3);
  double erra = alhazan_check(center,eye,vertex,rva);
  double errb = alhazan_check(center,eye,vertex,rvb);

  if ( fabs(ab_dot) > 0.9999 )
    {
      if ( err1 < errb ) RETURN(rv1);
      RETURN(rvb);
    }

  const double cos_th = dir_ab.x;
  const double sin_th = -dir_ab.y;

  pCoor mx(0,0,0,0);

  static int bail_count = 0;

# define BAIL(reason) \
  { bail_count++; \
    if ( bail_count < 10 ) \
      printf("Can't solve, (%6.3f,%6.3f)  (%6.3f,%6.3f)  %s\n", \
             a.x,a.y, b.x, b.y, reason); \
    return mx; \
  }

  pCoor a;
  a.x = eye.x * cos_th - eye.y * sin_th;
  a.y = eye.x * sin_th + eye.y * cos_th;
  a.z = 0; a.w = 1;
  pCoor b;
  b.x = vertex.x * cos_th - vertex.y * sin_th;
  b.y = vertex.x * sin_th + vertex.y * cos_th;
  b.z = 0; b.w = 1;

  a = a * rad_inv;
  b = b * rad_inv;

  const double p = a.x * b.y + a.y * b.x;
  const double q = a.x * b.x - a.y * b.y;
  const double r = a.x + b.x;
  const double s = a.y + b.y;
  const double ssq = s * s;
  const double qsq = q * q;
  const double rsq = r * r;

  ASSERTS( fabs(p) < 0.001 );

  const double k1 = (-4.0 * qsq + rsq + ssq);
  const double k1cu = k1 * k1 * k1;
  const double k2 = 2.0 * k1cu + 432.0 * qsq * ssq * ( k1 + 4.0 * qsq - ssq );

  const double k4 = 4 * qsq - rsq - ssq;
  const double k4sq = k4 * k4;

  const double k3pre = -4.0 * k1cu * k1cu + k2 * k2;

  const bool k3_neg = k3pre < 0;
  const double k3sp = sqrt( fabs(k3pre) );

  const double k3_re = k2 + ( k3_neg ? 0 : k3sp );
  const double k3_imsq = max(-k3pre,0.0);
  const double k3_im = k3_neg ? k3sp : 0;
  const double k3_car = (1/3.) * atan2(k3_im,k3_re);
  const double k3cr_cm = pow( k3_re * k3_re + k3_imsq, 1/6.);
  const double k3_real_n = cos(k3_car);
  const double k21 =
    k3_real_n *
    ( 1.5874010519681996 * k3cr_cm + 2.5198420997897464 * k4sq / k3cr_cm );

  //  if ( k3pre < 0 ) BAIL("k3pre");

  const double k20 = sqrt( -4.*k1 + k21 + 6.*ssq );

  const double k6 = 8.*k1 + k21 - 12.*ssq;
  const double k7 = 29.393876913398135 * s * (k1 + 8.*qsq - ssq) / k20;

  const double k14 = -k6 - k7;
  const double k15 = -k6 + k7;

  const double k9 = 0.25 * s;
  const double k11b = 2.449489742783178 / 24.0;
  const double k10 = k11b * k20;

  const bool set1 = k14 >= 0;
  const bool set2 = k15 >= 0;

  if ( !set1 && k15 < 0 ) BAIL("both");

  const double qinv = 1/q;

  const double k14sr = k11b * sqrt( k14 );
  const double k15sr = k11b * sqrt( k15 );

  const double ys11 = ( -k9 - k10 - k14sr ) * qinv;
  const double ys12 = ( -k9 - k10 + k14sr ) * qinv;
  const double ys21 = ( -k9 + k10 - k15sr ) * qinv;
  const double ys22 = ( -k9 + k10 + k15sr ) * qinv;

  const double y1 = set1 ? ys11 : ys21;
  const double y2 = set1 ? ys12 : ys22;

  const double x1t = r * y1 / ( 2 * q * y1 + s );
  const double x2t = r * y2 / ( 2 * q * y2 + s );

  const double x1m = sqrt( 1 - y1 * y1 );
  const double x2m = sqrt( 1 - y2 * y2 );
  const double x1 = x1t < 0 ? -x1m : x1m;
  const double x2 = x2t < 0 ? -x2m : x2m;

  if ( ab_dot == 2735.65 )
    printf("Don't warn about unused vars %f, %f, %f, %f, %f\n",
           err2, err3, erra, x1, x2);

  //  pCoor m1(x1a * cos_th + y1 * sin_th, -x1a * sin_th + y1 * cos_th, 0, 1);
  //  pCoor m2(x2a * cos_th + y2 * sin_th, -x2a * sin_th + y2 * cos_th, 0, 1);

#if 0
  pNorm m1n(x1,y1,0),m2n(x2,y2,0);

  const bool sol1 = fabs(m1n.magnitude - 1 ) < 0.01;
  const bool sol2 = fabs(m2n.magnitude - 1 ) < 0.01;

  double errs1 = alhazan_check(center,eye,vertex,m1);
  double errs1n = alhazan_check(center,eye,vertex,m1n);
  double errs2 = alhazan_check(center,eye,vertex,m2);
  double errs2n = alhazan_check(center,eye,vertex,m2n);

  ASSERTS( sol1 && sol2 );
#endif

  const double y = y2;
  const double xt = r * y / ( 2 * q * y + s );
  const double xm = sqrt( 1 - y * y );
  const double x = xt < 0 ? -xm : xm;

  pCoor m;
  m.x = x * cos_th + y * sin_th;
  m.y = -x * sin_th + y * cos_th;
  m.z = 0; m.w = 1;
  pNorm mc(-m);
  ASSERTS( fabs( mc.magnitude - 1 ) < 0.01 );

  m = m * radius;
  pNorm ma(m,eye);
  pNorm mb(m,vertex);

  const double da = dot(ma,mc);
  const double db = dot(mb,mc);

  const double err = fabs(da-db);
  const bool okay = err < 0.0001;
  //  ASSERTS( okay );
  static int msg = 10;
  if ( msg-- > 0 )
    printf("Okay %d, set1/2, %d/%d (%.3f,%.3f) (%.3f,%.3f) (%.3f,%.3f) %.3f\n",
           okay, set1,set2,
           a.x, a.y, b.x, b.y, x,y, m.y);

  if ( !okay ) BAIL("not okay");
  RETURN( m );
}
