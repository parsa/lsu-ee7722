/// LSU EE 7700-1 (Spring 2009), Graphics Processors  -*- c++ -*-
//
 ///  Geometry Classes and Functions

 // $Id:$

 /// Purpose
//
//   A set of classes and functions for storing and manipulating
//   coordinates and vectors.  Intended to demonstrate basic 3D
//   graphics techniques, not for production use.


#ifndef COORD_H
#define COORD_H

#include <math.h>

class pMatrix;
class pCoor;
class pColor;
class pVect;
inline pCoor mult_MC(pMatrix& m, pCoor c);
inline void pMMultiply(pMatrix& p, pMatrix m1, pMatrix m2);
pVect cross(pCoor a, pCoor b, pCoor c);
pVect cross(pVect a, pVect b);
float dot(pVect a, pVect b);

class pCoor {
public:
  pCoor(){};
  pCoor(pVect v);
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

  pMatrix(pMatrix m1, pMatrix m2){pMMultiply(*this,m1,m2);}

  operator float* () { return &a[0]; }

  void copy(pMatrix& m){ memcpy(a,m.a,sizeof(a)); }

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

pCoor operator * (pMatrix m, pCoor c) { return mult_MC(m,c); }

inline void
pMMultiply(pMatrix& p, pMatrix m1, pMatrix m2)
{
  p.set_zero();
  for ( int row=0; row<4; row++ )
    for ( int col=0; col<4; col++ )
      for ( int i=0; i<4; i++ )
        p.rc(row,col) += m1.rc(row,i) * m2.rc(i,col);
}


class pVect {
public:
  pVect(){};
  pVect(pCoor c):x(c.x),y(c.y),z(c.z){};
  pVect(float x, float y, float z):x(x),y(y),z(z){};
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
  float mag() { return sqrt( dot(*this,*this) ); }
  float mag_xy() { return sqrt( x*x + y*y ); }
  float mag_xz() { return sqrt( x*x + z*z ); }
  float mag_yz() { return sqrt( y*y + z*z ); }

  float x, y, z;
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
  float *v() { return &r; }
  operator float*() { return v(); }
  uint32_t to_integer()
  {
    const float scale = 255.999;
    return uint(a * scale) << 24
      || uint(r * scale) << 16
      || uint(g * scale) << 8
      || uint(b * scale);
  }
  float r, g, b, a;
};

inline pColor operator * (pColor c, float scale)
{
  return pColor(c.r*scale, c.g*scale, c.b*scale, c.a);
}

inline float dot(pVect a, pVect b){return a.x * b.x + a.y * b.y + a.z * b.z;}

float dot(pCoor a, pCoor b)
{return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;}

pVect cross(pVect a, pVect b)
{
  return pVect
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}

pVect cross(pCoor a, pCoor b, pCoor c)
{
  return cross(pVect(b,a),pVect(b,c));
}

inline double
pangle(pVect a, pVect b)
{
  const double mag = a.mag() * b.mag();
  if ( mag == 0 ) return 0;
  return acos(dot(a,b) / mag);
}

inline double
pangle(pCoor a, pCoor b, pCoor c)
{
  return pangle(pVect(b,a),pVect(b,c));
}


pCoor mult_MC(pMatrix& m, pCoor c)
{
  return pCoor(dot(m.r(0),c),dot(m.r(1),c),dot(m.r(2),c),dot(m.r(3),c));
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
inline pVect operator * (double s,pVect v){return pVect(s,v); }
inline pVect operator / (pVect v, float f)
{
  const float finv = 1.0 / f;
  return pVect(v.x*finv,v.y*finv,v.z*finv);
}
inline pMatrix operator * (pMatrix m1, pMatrix m2){ return pMatrix(m1,m2); }

class pNorm : public pVect {
public:
  pNorm(){}
  pNorm(float x, float y, float z){set(pVect(x,y,z));}
  pNorm(pVect from, pVect to){set(pVect(from,to));}
  pNorm(pCoor from, pCoor to){set(pVect(from,to));}
  pNorm(pVect v){set(v);}
  void set(pVect v)
  {
    magnitude = v.mag();
    pVect v2 = magnitude == 0 ? pVect(0,0,0) : v / magnitude;
    pVect::set(v2);
  }
  void operator = (pVect v) { set(v); }
  float magnitude;
};

inline void
pMatrix::column_set(int col, pVect v)
{
  rc(0,col) = v.x;
  rc(1,col) = v.y;
  rc(2,col) = v.z;
  rc(3,col) = 0;
}


void
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

void
pMatrix::set_translation(pVect pos)
{ set_translation(pos.x,pos.y,pos.z); }

void
pMatrix::set_translation(float x, float y, float z)
{
  set_identity();
  rc(0,3) = x;
  rc(1,3) = y;
  rc(2,3) = z;
  rc(3,3) = 1;
}

#if 0
void
pMatrix::apply_translation(pVect pos)
{
  pMatrix mt; mt.set_translation(pos);
  apply(mt);
}


void
pMatrix::apply_rotation(pVect u, float theta)
{
    pMatrix mt; mt.set_rotation(u,theta);
    apply(mt);
}
#endif
void
pMatrix::local_rotation(pVect u, float theta)
{
  pMatrix mt; mt.set_rotation(u,theta);
  local(mt);
}

float distance(pCoor a, pCoor b)
{
  pVect diff(a,b); return diff.mag();
}

float distance_sq(pCoor a, pCoor b)
{
  pVect diff(a,b); return dot(diff,diff);
}

//
// Pre-Initialized Matrices
//

class pMatrix_Scale : public pMatrix {
public:
  pMatrix_Scale(float factor){set_scale(factor);}
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


class pMatrix_Rotation : public pMatrix {
public:
  pMatrix_Rotation(pVect axis, double angle)
  { set_rotation(axis,angle); }
  pMatrix_Rotation(pVect dir_from, pVect dir_to)
  {
    dir_from.normalize(); dir_to.normalize();
    if ( pangle(dir_from,dir_to) < 0.0001 ) { set_identity(); return; }
    if ( fabs(dot(dir_to,pVect(0,1,0))) > 0.9999 )
      {
        pNorm axis(dir_from, dir_to);
        set_rotation(axis,asin(axis.magnitude));
      }
    else
      {
        const double
          a1 = atan2(dir_from.z,dir_from.x) - atan2(dir_to.z,dir_to.x);
        pMatrix_Rotation rot1(pVect(0,1,0),a1);
        pVect norm(dir_to,pVect(0,1,0));  norm.normalize();
        const double a2 =
          atan2(dir_from.mag_xz(),dir_from.y) - atan2(dir_to.mag_xz(),dir_to.y);
        pMatrix_Rotation rot2(norm,a2);
        pMMultiply(*this,rot2,rot1);
      }
    rot_check(*this,dir_from,dir_to);
  }
private:
  static void rot_check(pMatrix& r, pVect f_raw, pVect t_raw)
  {
    pVect f(f_raw);
    pVect t(t_raw);
    pVect t2 = r * f;
    pVect check = t2 - t;
    const double err = dot(check,check);
    if ( err > 0.0001 )
      abort();
  }

};


pMatrix
invert(pMatrix& original)
{
  const bool check = true;
  pMatrix a = original;
  pMatrix b; b.set_identity();

  for ( int dia = 0; dia < 4; dia++ )
    {
      if ( a.rc(dia,dia) == 0 )
        for ( int row = dia + 1; row < 4; row++ )
          if ( a.rc(row,dia) != 0 )
            { a.row_swap(row,dia);  b.row_swap(row,dia);  break;}
      const float a00 = a.rc(dia,dia);
      if ( a00 == 0 ) pError_Exit();
      const double mult = 1.0 / a00;
      a.row_mult(dia,mult);  b.row_mult(dia,mult);
      for ( int row = 0; row < 4; row++ )
        {
          if ( row == dia ) continue;
          const float adc = a.rc(row,dia);
          if ( adc == 0 ) continue;
          a.row_ssub(row,dia,adc);  b.row_ssub(row,dia,adc);
        }
    }

  if ( check )
    {
      pMatrix ihope = original * b;
      pMatrix iis; iis.set_identity();
      float sum = 0;
      for ( int r=0; r<4; r++ )
        for ( int c=0; c<4; c++ )
          sum += fabs(ihope.rc(r,c)-iis.rc(r,c));
      if ( sum > 1e-5 )
        {
          printf("Can't invert, sum: %f\n",sum);
          //  pError_Exit();
        }
    }
  return b;
}




#endif

