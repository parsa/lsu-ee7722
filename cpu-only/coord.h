/// LSU EE 7700-1 (Sp 09), Graphics Processors  -*- c++ -*-
//
 ///  CPU-Only Demos' Include File

 // $Id:$

 /// Purpose
//
//   A set of classes and functions for storing and manipulating
//   coordinates and vectors.  Intended to demonstrate basic 3D
//   graphics techniques, not for production use.


#ifndef COORD_H
#define COORD_H

#include <stdlib.h>
#include <math.h>

class pCoor;
class pVect;
class pMatrix;

pCoor operator * (pMatrix a, pCoor c);
pMatrix invert3x3(pMatrix& original);
inline pVect cross(pCoor a, pCoor b, pCoor c);

class pMatrix {
public:
  float a[4][4];

  //
  // Initialization Functions
  //

  void set_zero(){ bzero(a,sizeof(a)); }

  void set_scale(float factor)
  {
    set_zero();
    a[0][0] = a[1][1] = a[2][2] = factor;
    a[3][3] = 1;
  }
  void set_scale(float xfactor, float yfactor)
  {
    set_zero();
    a[0][0] = xfactor;
    a[1][1] = yfactor;
    a[2][2] = a[3][3] = 1;
  }
  void set_identity(){ set_scale(1); }

  void set_translate(float dx, float dy, float dz)
  {
    set_identity();
    a[0][3] = dx;
    a[1][3] = dy;
    a[2][3] = dz;
  }

  void set_rotation(pVect u, double theta);
  
  void set_frustrum
  (float width, float height, float near, float far)
  {
    set_zero();
    a[0][0] = 2 * near / width;
    a[1][1] = 2 * near / height;
    a[2][2] = - ( far + near ) / ( far - near );
    a[2][3] = - 2 * far * near / ( far - near );
    a[3][2] = -1;
  }

  void set_frustrum
  (float left, float right, float bottom, float top, float near, float far)
  {
    set_zero();
    a[0][0] = 2 * near / ( right - left );
    a[0][2] = ( right + left ) / ( right - left );
    a[1][1] = 2 * near / ( top - bottom );
    a[1][2] = ( top + bottom ) / ( top - bottom );
    a[2][2] = - ( far + near ) / ( far - near );
    a[2][3] = - 2 * far * near / ( far - near );
    a[3][2] = -1;
  }

  void transpose()
  {
    for ( int row=0; row<4; row++ )
      for ( int col=row+1; col<4; col++ )
        {
          const float t = a[row][col];
          a[row][col] = a[col][row]; a[col][row] = t;
        }
  }

  // Invert submatrix in first three rows and columns.
  void invert3x3()
  {
    pMatrix result = ::invert3x3(*this);
    bcopy(result.a,a,sizeof(a));
  }

  //
  // Member functions used for matrix inversion.
  //

  float* row_get(int row_num) { return &a[row_num][0]; }
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
    a[row_dest][0] -= a[row_src][0] * mult;
    a[row_dest][1] -= a[row_src][1] * mult;
    a[row_dest][2] -= a[row_src][2] * mult;
    a[row_dest][3] -= a[row_src][3] * mult;
  }
};

//
// Pre-Initialized Matrices
//

class pMatrix_Scale : public pMatrix {
public:
  pMatrix_Scale(float factor){set_scale(factor);}
  pMatrix_Scale(float xfactor, float yfactor){set_scale(xfactor,yfactor);}
};

class pMatrix_Translate : public pMatrix {
public:
  pMatrix_Translate(float dx, float dy, float dz){set_translate(dx,dy,dz);}
};

class pMatrix_Frustrum : public pMatrix {
public:
  pMatrix_Frustrum
  (float left, float right, float bottom, float top, float near, float far)
  { set_frustrum(left,right,bottom,top,near,far); }
  pMatrix_Frustrum
  (float width, float height, float near, float far)
  { set_frustrum(width,height,near,far); }
};

//
// Coordinate and Vector Classes
//

class pCoor {
public:
  pCoor(){}
  pCoor(float x, float y, float z):x(x), y(y), z(z), w(1){}
  pCoor(float x, float y, float z, float w):x(x), y(y), z(z), w(w){}
  pCoor(pCoor *c):x(c->x), y(c->y), z(c->z), w(c->w){}
  void homogenize()
  {
    const float winv = 1 / w;
    float* const a = array();
    for( int i=0; i<3; i++ ) a[i] *= winv;
    w = 1;
  }
  inline void operator *= (pMatrix m)
  {
    pCoor cpy(this);
    float* const a = array();
    float* const c = cpy.array();
    for ( int i = 0; i < 4; i++ )
      {
        a[i] = 0;
        for ( int j = 0; j < 4; j++ ) a[i] += m.a[i][j] * c[j];
      }
  }
  float x,y,z,w;
  float* array(){ return &x; }
};

class pVect {
public:
  pVect(){};
  pVect(float x, float y, float z):x(x), y(y), z(z){}
  pVect(pCoor p, pCoor q):x(q.x-p.x), y(q.y-p.y), z(q.z-p.z){}
  pVect(pCoor a, pCoor b, pCoor c){set(cross(a,b,c));}
  pVect(const pVect& v){ set(v); }
  void set(const pVect& v){ x=v.x; y=v.y; z=v.z; }
  void set(float xp, float yp, float zp){ x=xp; y=yp; z=zp; }
  float normalize() {
    const float mag = magnitude();
    const float mag_inv = 1.0 / mag;
    x *= mag_inv;  y *= mag_inv;  z *= mag_inv;
    return mag;
  }
  float magnitude() { return sqrt( x*x + y*y + z*z ); }
  float* array(){ return &x; }
  inline void operator *= (const pMatrix& m)
  {
    pCoor cpy(x,y,z,0);
    pCoor prd;
    float* const a = prd.array();
    float* const c = cpy.array();
    for ( int i = 0; i < 4; i++ )
      {
        a[i] = 0;
        for ( int j = 0; j < 4; j++ ) a[i] += m.a[i][j] * c[j];
      }
    x=prd.x; y=prd.y; z=prd.z;
  }

  float x,y,z;
};

//
// Vector, Coordinate, and Matrix Operations
//

void 
pMatrix::set_rotation(pVect u, double theta)
{
  const double rpd = 2.0 * M_PI / 360.0;
  set_zero();
  const double cos_theta = cos(theta*rpd);
  const double sin_theta = sin(theta*rpd);
  a[0][0] = u.x * u.x + cos_theta * ( 1.0 - u.x * u.x );
  a[0][1] = u.x * u.y * ( 1.0 - cos_theta ) - u.z * sin_theta;
  a[0][2] = u.z * u.x * ( 1.0 - cos_theta ) + u.y * sin_theta;
  a[1][0] = u.x * u.y * ( 1.0 - cos_theta ) + u.z * sin_theta;
  a[1][1] = u.y * u.y + cos_theta * ( 1 - u.y * u.y );
  a[1][2] = u.y * u.z * ( 1.0 - cos_theta ) - u.x * sin_theta;
  a[2][0] = u.z * u.x * ( 1.0 - cos_theta ) - u.y * sin_theta;
  a[2][1] = u.y * u.z * ( 1.0 - cos_theta ) + u.x * sin_theta;
  a[2][2] = u.z * u.z + cos_theta * ( 1 - u.z * u.z );
  a[3][3] = 1.0;
}

class pMatrix_Rotation : public pMatrix {
public:
  pMatrix_Rotation(pVect& axis, double angle)
  { set_rotation(axis,angle); }
};

inline pVect cross(pVect a, pVect b)
{
  return pVect
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}

inline pVect cross(pCoor a, pCoor b, pCoor c)
{
  return cross(pVect(b,a),pVect(b,c));
}

inline float dot(pVect a, pVect b){return a.x * b.x + a.y * b.y + a.z * b.z;}

pMatrix operator * (pMatrix a, pMatrix b)
{
  pMatrix p;  p.set_zero();
  for ( int i = 0; i < 4; i++ )
    for ( int j = 0; j < 4; j++ )
      for ( int k = 0; k < 4; k++ )
        p.a[i][j] += a.a[i][k] * b.a[k][j];
  return p;
}

pCoor operator * (pMatrix a, pCoor c)
{
  c *= a;
  return c;
}

pMatrix
invert3x3(pMatrix& original)
{
  const bool check = true;
  pMatrix a = original;
  pMatrix b; b.set_identity();
  const int size = 3;

  for ( int dia = 0; dia < size; dia++ )
    {
      if ( a.a[dia][dia] == 0 )
        for ( int row = dia + 1; row < size; row++ )
          if ( a.a[row][dia] != 0 )
            { a.row_swap(row,dia);  b.row_swap(row,dia);  break;}
      const float a00 = a.a[dia][dia];
      //  if ( a00 == 0 ) pError_Exit();
      const double mult = 1.0 / a00;
      a.row_mult(dia,mult);  b.row_mult(dia,mult);
      for ( int row = 0; row < size; row++ )
        {
          if ( row == dia ) continue;
          const float adc = a.a[row][dia];
          if ( adc == 0 ) continue;
          a.row_ssub(row,dia,adc);  b.row_ssub(row,dia,adc);
        }
    }

  if ( check )
    {
      pMatrix ihope = original * b;
      pMatrix iis; iis.set_identity();
      float sum = 0;
      for ( int r=0; r<size; r++ )
        for ( int c=0; c<size; c++ )
          sum += fabs(ihope.a[r][c]-iis.a[r][c]);
      if ( sum > 1e-5 )
        {
          printf("Can't invert, sum: %f\n",sum);
          exit(1);
          //  pError_Exit();
        }
    }
  return b;
}

#endif
