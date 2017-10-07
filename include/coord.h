/// LSU EE 4702-X / EE 77XX   -*- c++ -*-
//
 ///  Geometry Classes and Functions

 /// Purpose
//
//   A set of classes and functions for storing and manipulating
//   coordinates and vectors.  Intended to demonstrate basic 3D
//   graphics techniques, not for production use.


#ifndef COORD_H
#define COORD_H

#include <math.h>
#include "misc.h"

#define SQ(x) ((x)*(x))

class pMatrix;
class pCoor;
class pColor;
class pVect;
inline pCoor mult_MC(pMatrix& m, pCoor c);
inline void pMMultiply(pMatrix& p, pMatrix m1, pMatrix m2);
pVect cross(pCoor a, pCoor b, pCoor c);
pVect cross(pVect a, pVect b);
float dot(pVect a, pVect b);
float dot(pVect a);
double dotd(pVect a, pVect b);

class pCoor {
public:
  pCoor(){};
  pCoor(pVect v);
  pCoor(pCoor v, float wp){ *this = v; w = wp; }
  pCoor(float x, float y):x(x),y(y),z(0),w(1){};
  pCoor(float x, float y, float z):x(x),y(y),z(z),w(1){};
  pCoor(float x, float y, float z, float w):x(x),y(y),z(z),w(w){};
  float *v() { return &x; }
  operator float*() { return v(); }

  void set(pCoor c){ x = c.x; y = c.y; z = c.z; w = c.w; }
  void set(float xp, float yp, float zp){ x=xp; y=yp; z=zp; w=1; };
  void set(float xp, float yp, float zp, float wp){ x=xp; y=yp; z=zp; w=wp; };
  void homogenize()
  {
    const float winv = 1.0 / w;
    x *= winv;
    y *= winv;
    z *= winv;
    w = 1;
  }

  void apply(pMatrix& m){ set(mult_MC(m,*this)); }
  inline void operator *= (pMatrix& m){apply(m);}
  inline void add_vector(pVect v);
  inline void operator += (pVect v);
  inline void operator += (pCoor v)
  { x += v.x;  y += v.y;  z += v.z;  w += v.w; }
  inline pCoor operator + (pVect v);

  float x, y, z, w;
};

class pMatrix {
public:
  float a[16];

  pMatrix(){set_identity();}

  pMatrix(pVect c0, pVect c1, pVect c2);

  pMatrix(pMatrix m1, pMatrix m2){pMMultiply(*this,m1,m2);}

  operator float* () { return &a[0]; }

  void copy(pMatrix m){ memcpy(a,m.a,sizeof(a)); }

  void set_zero(){memset(a,0,sizeof(a));}

  void set_identity()
  {
    set_zero();
    for ( int i=0; i<4; i++ ) rc(i,i) = 1;
  };
  void set_rotation(pVect u, double theta);
  void set_translation(pVect pos);
  void set_translation(float x, float y, float z);

  void set_scale(float factor)
  {
    set_zero();
    for ( int i=0; i<3; i++ ) rc(i,i) = factor;
    rc(3,3) = 1;
  }

  void set_frustum
  (float left, float right, float bottom, float top, float near, float far)
  {
    set_zero();
    rc(0,0) = 2 * near / ( right - left );
    rc(0,2) = ( right + left ) / ( right - left );
    rc(1,1) = 2 * near / ( top - bottom );
    rc(1,2) = ( top + bottom ) / ( top - bottom );
    rc(2,2) = - ( far + near ) / ( far - near );
    rc(2,3) = - 2 * far * near / ( far - near );
    rc(3,2) = -1;
  }

  void set_transpose3x3(pMatrix m)
  {
    for ( int r=0; r<3; r++ )
      for ( int c=0; c<3; c++ ) rc(r,c) = m.rc(c,r);
  }
  void set_transpose(pMatrix m)
  {
    for ( int r=0; r<4; r++ )
      for ( int c=0; c<4; c++ ) rc(r,c) = m.rc(c,r);
  }

  inline float det();
  inline pMatrix inverse();

#if 0
  void apply_translation(pVect displ);

  void apply_scale(float factor)
  {
    pMatrix mt; mt.set_scale(factor);
    apply(mt);
  }

  void apply_rotation(pVect u, float theta);
#endif
  void local_rotation(pVect u, float theta);

  void pre_multiply(pMatrix m) {pMatrix mprod(m,*this); copy(mprod);}
  void local(pMatrix& m) {pMatrix mprod(*this,m); copy(mprod);}

  float* row_get(int row_num) { return &a[row_num<<2]; }
  float rc_get(int row, int col) const {return a[ ( row << 2 ) + col ];}
  float& rc(int row, int col) {return a[ ( row << 2 ) + col ];}
  pCoor r(int row_num){
    float* const row = row_get(row_num);
    return pCoor(row[0],row[1],row[2],row[3]);
  }

  void set_row(int r,pVect v);
  void set_col(int c, pVect v);
  void set_col(int c, pCoor v);

  // Return first three elements of column as a vector.
  pVect cv(int col);

  void row_swap(int r1, int r2)
  {
    static float buffer[4];
    float* const row1 = row_get(r1);
    float* const row2 = row_get(r2);
    row_copy(buffer,row1); row_copy(row1,row2); row_copy(row2,buffer);
  }

  void row_mult(int r, double factor)
  {
    float* const row = row_get(r);
    row[0] *= factor;  row[1] *= factor;
    row[2] *= factor;  row[3] *= factor;
  }

  void row_copy(float *row_dest, float *row_src)
  {
    row_dest[0] = row_src[0];  row_dest[1] = row_src[1];
    row_dest[2] = row_src[2];  row_dest[3] = row_src[3];
  }

  void row_ssub(int row_dest, int row_src, double mult)
  {
    rc(row_dest,0) -= rc(row_src,0) * mult;
    rc(row_dest,1) -= rc(row_src,1) * mult;
    rc(row_dest,2) -= rc(row_src,2) * mult;
    rc(row_dest,3) -= rc(row_src,3) * mult;
  }

  inline void column_set(int col, pVect v);
};

template <int stride>
class pMatrix3x3x {
public:
  float a[3*stride];

  pMatrix3x3x(){set_identity();}
  pMatrix3x3x(pMatrix& m, int r = 3, int c = 3)
  {
    int rj = 0;
    for ( int ri=0; ri<4; ri++ )
      {
        if ( ri == r ) continue;
        int cj = 0;
        for ( int ci=0; ci<4; ci++ )
          {
            if ( ci == c ) continue;
            rc(rj,cj) = m.rc(ri,ci);
            cj++;
          }
        rj++;
      }
  }

  template<int s2>
  pMatrix3x3x(pMatrix3x3x<s2> m)
    {
      for ( int r=0; r<3; r++ )
        for ( int c=0; c<3; c++ ) rc(r,c) = m.rc(r,c);
    }

  operator float* () { return &a[0]; }

  void copy(pMatrix m){ memcpy(a,m.a,sizeof(a)); }

  void set_zero(){memset(a,0,sizeof(a));}

  void set_identity()
  {
    set_zero();
    for ( int i=0; i<3; i++ ) rc(i,i) = 1;
  };

  void set_transpose(pMatrix3x3x<stride> m)
  {
    for ( int r=0; r<3; r++ )
      for ( int c=0; c<3; c++ ) rc(r,c) = m.rc(c,r);
  }

  inline float det();
  inline pMatrix inverse();

  float* row_get(int row_num) { return &a[row_num*stride]; }
  float rc_get(int row, int col) const {return a[ ( row * stride ) + col ];}
  float& rc(int row, int col) {return a[ ( row * stride ) + col ];}
  inline pVect r(int row_num);

  void row_swap(int r1, int r2)
  {
    static float buffer[3];
    float* const row1 = row_get(r1);
    float* const row2 = row_get(r2);
    row_copy(buffer,row1); row_copy(row1,row2); row_copy(row2,buffer);
  }

  void row_mult(int r, double factor)
  {
    float* const row = row_get(r);
    row[0] *= factor;  row[1] *= factor;
    row[2] *= factor;
  }

  void row_copy(float *row_dest, float *row_src)
  {
    row_dest[0] = row_src[0];  row_dest[1] = row_src[1];
    row_dest[2] = row_src[2];
  }

  void row_ssub(int row_dest, int row_src, double mult)
  {
    rc(row_dest,0) -= rc(row_src,0) * mult;
    rc(row_dest,1) -= rc(row_src,1) * mult;
    rc(row_dest,2) -= rc(row_src,2) * mult;
  }

};

typedef pMatrix3x3x<3> pMatrix3x3;
typedef pMatrix3x3x<4> pMatrix3x3p;

inline pCoor operator * (pMatrix m, pCoor c) { return mult_MC(m,c); }

inline void
pMMultiply(pMatrix& p, pMatrix m1, pMatrix m2)
{
  p.set_zero();
  for ( int row=0; row<4; row++ )
    for ( int col=0; col<4; col++ )
      for ( int i=0; i<4; i++ )
        p.rc(row,col) += m1.rc(row,i) * m2.rc(i,col);
}

inline void
pMMultiply3x3(pMatrix& p, pMatrix m1, pMatrix m2)
{
#define T(r,c,i) m1.rc(r,i) * m2.rc(i,c)
#define E(r,c) p.rc(r,c) = T(r,c,0) + T(r,c,1) + T(r,c,2);
#define C(r) E(r,0) E(r,1) E(r,2)
  C(0) C(1) C(2)
#undef T
#undef E
#undef C
}

#define VEC_REDUCE_AND(v,f) ( f(v.x) && f(v.y) && f(v.z) )

class pVect {
public:
  pVect(){};
  pVect(pCoor c):x(c.x),y(c.y),z(c.z){};
  pVect(float x, float y, float z):x(x),y(y),z(z){};
  pVect(float *a):x(a[0]),y(a[1]),z(a[2]){};
  pVect(pCoor from, pCoor to)
  {
    x = to.x - from.x;
    y = to.y - from.y;
    z = to.z - from.z;
  }
  pVect(pVect a, pVect b){ *this = cross(a,b); }
  pVect(pCoor a, pCoor b, pCoor c){ *this = cross(a,b,c); }
  pVect(float s, pVect v):x(s*v.x),y(s*v.y),z(s*v.z){};

  // Use with caution.
  /*  float *v() {return &x;}  */
  //  operator float*() const { return v(); }
  operator const float*() const { return &x; }
  float elt(int idx) const { return (&x)[idx]; }

  pVect mask(int8_t components) const
  {
    return pVect( components & 4 ? x : 0.0f,
                  components & 2 ? y : 0.0f,
                  components & 1 ? z : 0.0f );
  }
  pVect sign_mask(int8_t components) const
  {
    return pVect( components & 4 ? x : -x,
                  components & 2 ? y : -y,
                  components & 1 ? z : -z );
  }

  float normalize()
  {
    const float length = mag();
    const float len_inv = 1.0 / length;
    x *= len_inv;  y *= len_inv;  z *= len_inv;
    return length;
  };

  pVect normal()
  {
    const float minv = 1.0/mag();
    return pVect(x*minv,y*minv,z*minv);
  }
  void flip() {x = -x;  y = -y;  z = -z;}
  inline void operator += (pVect v){ x+=v.x; y+=v.y; z+=v.z; }
  inline void operator -= (pVect v){ x-=v.x; y-=v.y; z-=v.z; }
  inline void operator *= (float s){ x*=s; y*=s; z*=s; }

  inline void operator *= (const pMatrix m)
  {
    pVect v(*this);
    const int x = 0, y = 1, z = 2;  // Don't try this at home.
#   define T(i,j) m.rc_get(i,j) * v.j
#   define ELT(i) this->i = T(i,x) + T(i,y) + T(i,z);
    ELT(x); ELT(y); ELT(z);
#   undef T
#   undef ELT
  }

  void set(const pVect& v){ x=v.x; y=v.y; z=v.z; }
  void set(float xp, float yp, float zp){ x=xp; y=yp; z=zp; }

#if 0
  inline pVect operator - (void){ return pVect(-x,-y,-z); }
  inline pVect operator - (pVect v){ return pVect(x-v.x,y-v.y,z-v.z); }
#endif
  float mag() const { return sqrtf( mag_sq() ); }
  float mag_sq() const { return dot(*this,*this); }
  float mag_xy() const { return sqrtf( x*x + y*y ); }
  float mag_xz() const { return sqrtf( x*x + z*z ); }
  float mag_yz() const { return sqrtf( y*y + z*z ); }

  float x, y, z;
};

// Intended for situations where a power-of-2 stride element is needed.
class pVect4 {
public:
  float x, y, z, w;
  operator const pVect () const { return pVect(x,y,z); }
  void operator = (pVect v) { x=v.x; y=v.y; z=v.z; }
};


class pColor {
public:
  pColor(float r, float g, float b):r(r),g(g),b(b),a(1){}
  pColor(float r, float g, float b, float a):r(r),g(g),b(b),a(a){}
  pColor(int rgb):
    r( ( rgb >> 16 ) / 255.0 ),
    g( ( ( rgb >> 8 ) & 0xff ) / 255.0 ),
    b( ( ( rgb ) & 0xff ) / 255.0 ),a(1){}
  pColor(){}
  pColor inv() { return pColor(1-r,1-g,1-b,a); }
  const float* v() const { return &r; }
  operator const float* () const { return v(); }
  float r, g, b, a;
};

inline pColor operator * (pColor c, float scale)
{
  return pColor(c.r*scale, c.g*scale, c.b*scale, c.a);
}
inline pColor operator * (float scale, pColor c)
{
  return pColor(c.r*scale, c.g*scale, c.b*scale, c.a);
}
inline pColor operator * (pColor c, pColor d)
{
  return pColor(c.r*d.r, c.g*d.g, c.b*d.b, c.a);
}

inline pColor operator + (pColor c, pColor d)
{
  return pColor(c.r+d.r, c.g+d.g, c.b+d.b, c.a);
}

inline float dot(pVect a, pVect b){return a.x * b.x + a.y * b.y + a.z * b.z;}
inline double dotd(pVect a, pVect b)
{return double(a.x) * b.x + double(a.y) * b.y + double(a.z) * b.z;}

inline float dot(pCoor a, pCoor b)
{return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;}
inline double dotd(pCoor a, pCoor b)
{return double(a.x) * b.x + double(a.y) * b.y + double(a.z) * b.z
    + double(a.w) * b.w;}

inline pVect cross(pVect a, pVect b)
{
  return pVect
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}

inline pVect cross(pCoor a, pCoor b, pCoor c)
{
  return cross(pVect(b,a),pVect(b,c));
}

inline double
pangle(pVect a, pVect b)
{
  const double mag = a.mag() * b.mag();
  if ( mag == 0 ) return 0;
  return acos(max(-1.0,min(1.0,dot(a,b) / mag)));
}

inline double
pangle(pCoor a, pCoor b, pCoor c)
{
  return pangle(pVect(b,a),pVect(b,c));
}


inline
pMatrix::pMatrix(pVect c0, pVect c1, pVect c2)
{ set_identity(); set_col(0,c0); set_col(1,c1);  set_col(2,c2); }

inline pVect pMatrix::cv(int col)
{ return pVect(rc_get(0,col),rc_get(1,col),rc_get(2,col)); }

inline void
pMatrix::set_row(int r,pVect v)
{
  float* const a = row_get(r);
  for ( int c=0; c<3; c++ ) a[c] = v[c];
  a[3] = 0;
}

inline void
pMatrix::set_col(int c, pVect v)
{
  for ( int r=0; r<3; r++ ) rc(r,c) = v[r];
}
inline void
pMatrix::set_col(int c, pCoor v)
{
  for ( int r=0; r<4; r++ ) rc(r,c) = v[r];
}

inline pCoor mult_MC(pMatrix& m, pCoor c)
{
  return pCoor(dot(m.r(0),c),dot(m.r(1),c),dot(m.r(2),c),dot(m.r(3),c));
}

inline pVect mult_MV(pMatrix3x3 m, pVect c)
{
  return pVect(dot(m.r(0),c),dot(m.r(1),c),dot(m.r(2),c));
}

inline pVect operator * (pMatrix3x3 m, pVect c) { return mult_MV(m,c); }
inline pVect operator * (pMatrix m, pVect c) { return mult_MV(m,c); }

// Multiply M transposed times V.
inline pVect mult_MTV(pMatrix3x3 m, pVect v)
{
  pVect q(0,0,0);
  float* const qf = &q.x;
  for ( int r=0; r<3; r++ )
    for ( int c=0; c<3; c++ ) qf[r] += m.rc(c,r) * v.elt(c);
  return q;
}

inline void
pCoor::add_vector(pVect v)
{
  x += v.x;
  y += v.y;
  z += v.z;
}

inline void pCoor::operator += (pVect v) { add_vector(v); }
inline pCoor pCoor::operator + (pVect v)
{return pCoor(x + v.x, y + v.y, z + v.z);}
inline pCoor::pCoor(pVect v):x(v.x),y(v.y),z(v.z),w(1){}
inline pCoor operator - (pCoor c, pVect v)
{return pCoor(c.x-v.x,c.y-v.y,c.z-v.z); }
inline pVect operator + (pVect v, pVect q)
{return pVect(v.x+q.x,v.y+q.y,v.z+q.z); }
inline pVect operator - (pVect v, pVect q)
{return pVect(v.x-q.x,v.y-q.y,v.z-q.z); }
inline pVect operator - (pVect q){return pVect(-q.x,-q.y,-q.z); }
inline pVect operator - (pCoor c1, pCoor c2){return pVect(c2,c1);}
inline pVect operator + (pVect v, float s){return pVect(v.x+s,v.y+s,v.z+s); }
inline pVect operator * (pVect v, float s){return pVect(s,v); }
inline pVect operator * (float s,pVect v){return pVect(s,v); }
inline pVect operator * (pVect v,pVect q)
{return pVect(v.x*q.x,v.y*q.y,v.z*q.z);}
inline pVect operator / (pVect v,pVect q)
{return pVect(v.x/q.x,v.y/q.y,v.z/q.z);}
inline pVect operator / (float f,pVect q)
{return pVect(f/q.x,f/q.y,f/q.z);}
inline pVect operator / (pVect v, float f)
{
  const float finv = 1.0 / f;
  return pVect(v.x*finv,v.y*finv,v.z*finv);
}

inline pVect fabs(pVect v){ return pVect(fabs(v.x),fabs(v.y),fabs(v.z)); }
inline float min(pVect v){ return min(min(v.x,v.y),v.z); }
inline float max(pVect v){ return max(max(v.x,v.y),v.z); }
inline float sum(pVect v){ return v.x+v.y+v.z; }

inline pMatrix operator * (pMatrix m1, pMatrix m2){ return pMatrix(m1,m2); }

template<int stride> inline pVect
pMatrix3x3x<stride>::r(int row_num)
{
  float* const row = row_get(row_num);
  return pVect(row[0],row[1],row[2]);
}

template<int stride> inline float
pMatrix3x3x<stride>::det()
{
  return dot( r(0), cross( r(1), r(2) ) );
}

inline float
pMatrix::det()
{
  pMatrix3x3 m00(*this,0,0);
  pMatrix3x3 m01(*this,0,1);
  pMatrix3x3 m02(*this,0,2);
  pMatrix3x3 m03(*this,0,3);
  return 
    rc(0,0) * m00.det()
    - rc(0,1) * m01.det()
    + rc(0,2) * m02.det()
    - rc(0,3) * m03.det();
}

inline pMatrix
pMatrix::inverse()
{
  pMatrix minv;

  const float d = det();
  if ( d == 0 )
    {
      for ( int rc=0; rc<4; rc++ ) minv.rc(rc,rc) = 0;
      return minv;
    }

  const float dinv = 1/d;

  for ( int r=0; r<4; r++ )
    for ( int c=0; c<4; c++ )
      {
        pMatrix3x3 mrc(*this,r,c);
        const bool pos = (r & 1) == (c & 1);
        const float val = mrc.det() * dinv;
        minv.rc(c,r) = pos ? val : -val;
      }

  return minv;
}

class pNorm : public pVect {
public:
  pNorm(){}
  pNorm(float x, float y, float z){set(pVect(x,y,z));}
  pNorm(pVect from, pVect to){set(pVect(from,to));}
  pNorm(pCoor from, pCoor to){set(pVect(from,to));}
  pNorm(pVect v){set(v);}
  void set(pVect v)
  {
    mag_sq = dot(v,v);
    magnitude = sqrtf(mag_sq);
    pVect v2 = magnitude == 0 ? pVect(0,0,0) : v / magnitude;
    pVect::set(v2);
  }
  void operator = (pVect v) { set(v); }
  float magnitude;
  float mag_sq;
};


class pQuat {
public:
  pQuat(){}
  pQuat(pNorm axis, float angle){ set(axis,angle); }
  pQuat(float x, float y, float z, float w):v(x,y,z),w(w){}
  void set(pNorm axis, float angle)
  {
    w = cosf(angle/2);
    v = sinf(angle/2) * axis;
  }
  void normalize()
  {
    const float mag_sq = v.mag_sq() + w * w;
    if ( mag_sq == 0 ) return;
    const float mag_inv = powf(mag_sq,-0.5f);
    v *= mag_inv;
    w *= mag_inv;
  }
  pVect v;
  float w;
};

inline pQuat operator *(pQuat a, pQuat b)
{
  pQuat p;
  p.w = a.w * b.w - dot(a.v,b.v);
  p.v = a.w * b.v + b.w * a.v + cross(a.v,b.v);
  return p;
};

inline void
pMatrix::column_set(int col, pVect v)
{
  rc(0,col) = v.x;
  rc(1,col) = v.y;
  rc(2,col) = v.z;
  rc(3,col) = 0;
}


inline void
pMatrix::set_rotation(pVect u, double theta)
{
  set_zero();
  const double cos_theta = cos(theta);
  const double sin_theta = sin(theta);
  rc(0,0) = u.x * u.x + cos_theta * ( 1.0 - u.x * u.x );
  rc(0,1) = u.x * u.y * ( 1.0 - cos_theta ) - u.z * sin_theta;
  rc(0,2) = u.z * u.x * ( 1.0 - cos_theta ) + u.y * sin_theta;
  rc(1,0) = u.x * u.y * ( 1.0 - cos_theta ) + u.z * sin_theta;
  rc(1,1) = u.y * u.y + cos_theta * ( 1 - u.y * u.y );
  rc(1,2) = u.y * u.z * ( 1.0 - cos_theta ) - u.x * sin_theta;
  rc(2,0) = u.z * u.x * ( 1.0 - cos_theta ) - u.y * sin_theta;
  rc(2,1) = u.y * u.z * ( 1.0 - cos_theta ) + u.x * sin_theta;
  rc(2,2) = u.z * u.z + cos_theta * ( 1 - u.z * u.z );
  rc(3,3) = 1.0;
}

inline void
pMatrix::set_translation(pVect pos)
{ set_translation(pos.x,pos.y,pos.z); }

inline void
pMatrix::set_translation(float x, float y, float z)
{
  set_identity();
  rc(0,3) = x;
  rc(1,3) = y;
  rc(2,3) = z;
  rc(3,3) = 1;
}

inline void
pMatrix::local_rotation(pVect u, float theta)
{
  pMatrix mt; mt.set_rotation(u,theta);
  local(mt);
}

inline float pDistance(pCoor a, pCoor b)
{
  pVect diff(a,b); return diff.mag();
}

inline float pDistance_sq(pCoor a, pCoor b)
{
  pVect diff(a,b); return dot(diff,diff);
}

//
// Pre-Initialized Matrices
//

class pMatrix_Rows : public pMatrix {
public:
  pMatrix_Rows(pVect r0, pVect r1, pVect r2)
    { set_identity(); set_row(0,r0); set_row(1,r1); set_row(2,r2); }
};

class pMatrix_Cols : public pMatrix {
public:
  pMatrix_Cols(pVect c0, pVect c1, pVect c2)
    { set_identity(); set_col(0,c0); set_col(1,c1); set_col(2,c2); }
  pMatrix_Cols(pVect c0, pVect c1, pVect c2, pCoor c3)
    {
      set_identity(); set_col(0,c0); set_col(1,c1); set_col(2,c2);
      set_col(3,c3);
    }
};

class pMatrix_Scale : public pMatrix {
public:
  pMatrix_Scale(float factor){set_scale(factor);}
  pMatrix_Scale(float x, float y, float z)
  {
    set_identity();
    rc(0,0) = x; rc(1,1) = y; rc(2,2) = z;
  }
};

class pMatrix_Translate : public pMatrix {
public:
  pMatrix_Translate(float dx, float dy, float dz){set_translation(dx,dy,dz);}
  pMatrix_Translate(pVect d){set_translation(d);}
};

class pMatrix_Frustum : public pMatrix {
public:
  pMatrix_Frustum
  (float left, float right, float bottom, float top, float near, float far)
  { set_frustum(left,right,bottom,top,near,far); }
};


class pMatrix_Rotation_Shortest : public pMatrix {
public:
  pMatrix_Rotation_Shortest(pVect dir_from, pVect dir_to)
  {
    // Akeinine-Moeller, 4.3.2
    const double e = dot(dir_from,dir_to);
    const double epsilon = 0.00001;
    if ( e + epsilon >= 1 ) { set_identity(); return; }
    if ( e - epsilon <= -1 )
      {
        pVect ref(-dir_from.z,dir_from.x,dir_from.y);
        pVect axis = cross(ref,dir_from);
        set_rotation(axis,M_PI);
        return;
      }
    const pVect v = cross(dir_from,dir_to);
    const double h = 1 / ( 1 + e );
    set_identity();
    rc(0,0) = e + h * v.x * v.x;
    rc(0,1) = h * v.x * v.y - v.z;
    rc(0,2) = h * v.x * v.z + v.y;
    rc(1,0) = h * v.x * v.y + v.z;
    rc(1,1) = e + h * v.y * v.y;
    rc(1,2) = h * v.y * v.z - v.x;
    rc(2,0) = h * v.x * v.z - v.y;
    rc(2,1) = h * v.y * v.z + v.x;
    rc(2,2) = e + h * v.z * v.z;
  }
};

class pMatrix_Rotation_yz : public pMatrix {
public:
  pMatrix_Rotation_yz(pVect y, pVect z)
  {
    pNorm yn(y);
    pNorm zn(z);
    pNorm xn = cross(y,z);
    set_row(0,xn);
    set_row(1,yn);
    set_row(2,zn);
    set_row(3,pCoor(0,0,0,1));
  }
};

class pMatrix_Rotation : public pMatrix {
public:
  pMatrix_Rotation(pQuat q)
  {
    pVect v = q.v;
    set_identity();
    rc(0,0) = 1 - 2 * v.y * v.y - 2 * v.z * v.z;
    rc(0,1) = 2 * v.x * v.y - 2 * q.w * v.z;
    rc(0,2) = 2 * v.x * v.z + 2 * q.w * v.y;
    rc(1,0) = 2 * v.x * v.y + 2 * q.w * v.z;
    rc(1,1) = 1 - 2 * v.x * v.x - 2 * v.z * v.z;
    rc(1,2) = 2 * v.y * v.z - 2 * q.w * v.x;
    rc(2,0) = 2 * v.x * v.z - 2 * q.w * v.y;
    rc(2,1) = 2 * v.y * v.z + 2 * q.w * v.x;
    rc(2,2) = 1 - 2 * v.x * v.x - 2 * v.y * v.y;
  }
  pMatrix_Rotation(pVect axis, double angle)
  { set_rotation(axis,angle); }
  pMatrix_Rotation(pVect dir_from, pVect dir_to)
  { set_rotation_flat(dir_from,dir_to); }
  pMatrix_Rotation(pNorm dir_from, pNorm dir_to)
  { set_rotation_flat(dir_from,dir_to); }
  void set_rotation_flat(pVect dir_from, pVect dir_to)
  { set_rotation_flat(pNorm(dir_from),pNorm(dir_to)); }
  void set_rotation_flat(pNorm dir_from, pNorm dir_to)
  {
    const double epsilon = 0.00001;

    pNorm xz_from(dir_from.x,0,dir_from.z);
    pNorm xz_to(dir_to.x,0,dir_to.z);
    const bool do_xz = xz_from.mag_sq > epsilon && xz_to.mag_sq > epsilon;

    const double fix =
      xz_to.magnitude < epsilon ? 0.0 : xz_from.magnitude / xz_to.magnitude;
    pVect y_from(fix * dir_to.x, dir_from.y, fix * dir_to.z);
    const bool do_y = dot(y_from,y_from) > epsilon;

    pMatrix rot_xz, rot_y;
    if ( do_xz ) rot_xz = pMatrix_Rotation_Shortest(xz_from,xz_to);
    if ( do_y  ) rot_y = pMatrix_Rotation_Shortest(y_from,dir_to);

    if ( do_xz && rot_y ) copy( rot_y * rot_xz );
    else if ( do_xz )     copy(rot_xz);
    else if ( do_y )      copy(rot_y); 
    else                  set_identity(); 

    rot_check(*this,dir_from,dir_to);
  }
private:
  static void rot_check(pMatrix& r4x4, pVect f_raw, pVect t_raw)
  {
    pMatrix3x3 r(r4x4);
    pVect f(f_raw);
    pVect t(t_raw);
    pVect t2 = r * f;
    pVect check = t2 - t;
    const double err = dot(check,check);
    if ( err > 0.0001 )
      abort();
  }

};


class pMatrix3x3_Rotation : public pMatrix3x3 {
public:
  pMatrix3x3_Rotation(pQuat q)
  {
    pVect v = q.v;
    set_identity();
    rc(0,0) = 1 - 2 * v.y * v.y - 2 * v.z * v.z;
    rc(0,1) = 2 * v.x * v.y - 2 * q.w * v.z;
    rc(0,2) = 2 * v.x * v.z + 2 * q.w * v.y;
    rc(1,0) = 2 * v.x * v.y + 2 * q.w * v.z;
    rc(1,1) = 1 - 2 * v.x * v.x - 2 * v.z * v.z;
    rc(1,2) = 2 * v.y * v.z - 2 * q.w * v.x;
    rc(2,0) = 2 * v.x * v.z - 2 * q.w * v.y;
    rc(2,1) = 2 * v.y * v.z + 2 * q.w * v.x;
    rc(2,2) = 1 - 2 * v.x * v.x - 2 * v.y * v.y;
  }
};



#ifdef GP_UTIL_DECLARE_ONLY
pMatrix invert(pMatrix& original);
#else
pMatrix invert(pMatrix& original)
{
  const bool check = true;
  pMatrix b = original.inverse();

  if ( check )
    {
      pMatrix ihope = original * b;
      pMatrix iis; iis.set_identity();
      float sum = 0;
      for ( int r=0; r<4; r++ )
        for ( int c=0; c<4; c++ )
          sum += fabs(ihope.rc(r,c)-iis.rc(r,c));
      if ( sum > 1e-4 )
        {
          printf("Can't invert, sum: %f\n",sum);
          //  pError_Exit();
        }
    }
  return b;
}
#endif


#endif

