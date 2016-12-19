///
/// Useful Functions and Types
///

namespace pCUDA_coord
{

typedef float4 pCoor;

class pVect {
public:
  __device__ pVect(){};
  __device__ pVect(float f):x(f),y(f),z(f){};
  __device__ pVect(float xp, float yp, float zp):x(xp),y(yp),z(zp){};
  float x, y, z;
};

// Intended for situations where a power-of-2 stride element is needed.
class __builtin_align__(16) pVect4 {
public:
  float x, y, z, w;
  __device__ pVect4(){}
  __device__ pVect4(float f):x(f),y(f),z(f),w(f){}
  __device__ pVect4(pVect v){ x=v.x; y=v.y; z=v.z; w=0; }
  __device__ operator const pVect () const { return pVect(x,y,z); }
  __device__ void operator = (pVect v) { x=v.x; y=v.y; z=v.z; }
  __device__ void operator += (pVect v) {x+=v.x; y+=v.y; z+=v.z; }
  __device__ void operator *= (float f) {x*=f; y*=f; z*=f; }
};

class pCoor3 {
  public:
  __device__ pCoor3(pCoor c) { x=c.x; y=c.y; z=c.z; }
  float x, y, z;
};


__device__ pVect operator +(pVect a,pVect b)
{ return pVect(a.x+b.x,a.y+b.y,a.z+b.z); }
__device__ pCoor operator +(pCoor a,pVect b)
{ return make_float4(a.x+b.x,a.y+b.y,a.z+b.z,a.w); }
__device__ pVect operator -(pVect a,pVect b)
{ return pVect(a.x-b.x,a.y-b.y,a.z-b.z); }
__device__ pVect operator -(pCoor a,pCoor b)
{ return pVect(a.x-b.x,a.y-b.y,a.z-b.z); }

__device__ pVect operator *(float s, pVect v)
{return pVect(s*v.x,s*v.y,s*v.z);}
__device__ pVect operator *(pVect v, float s)
{return pVect(s*v.x,s*v.y,s*v.z);}
__device__ pVect operator *(pVect u, pVect v)
{return pVect(u.x*v.x,u.y*v.y,u.z*v.z);}

__device__ pVect operator -(pVect v) { return pVect(-v.x,-v.y,-v.z); }
__device__ pVect operator -=(pVect& a, pVect b) {a = a - b; return a;}
__device__ pVect operator +=(pVect& a, pVect b) {a = a + b; return a;}
__device__ pCoor operator +=(pCoor& a, pVect b) {a = a + b; return a;}
__device__ pVect operator *=(pVect& a, float b)
{ a.x *= b;  a.y *= b; a.z *= b;  return a;}

class pNorm {
public:
  __device__ pNorm(pVect v){ set_vect(v); }
  __device__ pNorm(float x, float y, float z){ set_vect(pVect(x,y,z)); }
  __device__ pNorm(pCoor p1, pCoor p2){ set_vect(p2-p1); }
  __device__ pNorm(){};
  __device__ void set_vect(pVect v);
  pVect v;
  float mag_sq, magnitude;
};

__device__ pVect operator *(float s, pNorm n) { return s * n.v;}

__device__ float dot(float4 a, float4 b)
{ return a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w;}
__device__ float dot(pVect a, pVect b){ return a.x*b.x + a.y*b.y + a.z*b.z;}
__device__ float dot(pVect a, pNorm b){ return dot(a,b.v); }
__device__ float dot(pNorm a, pVect b){ return dot(a.v,b); }

__device__ float mag_sq(pVect v){ return dot(v,v); }
__device__ float length(pVect a) {return sqrtf(mag_sq(a));}
__device__ pVect normalize(pVect a) { return rsqrtf(mag_sq(a))*a; }

__device__ void
pNorm::set_vect(pVect u)
{
  mag_sq = dot(u,u);
  if ( mag_sq == 0 )
    {
      magnitude = 0;
      v.x = v.y = v.z = 0;
    }
  else
    {
      const float rsq = 1.0f/sqrtf(mag_sq);
      magnitude = 1.0f/rsq;
      v = rsq * u;
    }
}

// The unary - operator doesn't seem to work when used in an argument.
__device__ pNorm operator -(pNorm n)
{
  pNorm m;
  m.magnitude = n.magnitude;
  m.mag_sq = n.mag_sq;
  m.v = -n.v;
  return m;
}

class __builtin_align__(16) pQuat {
public:
  __device__ pQuat(){};
  __device__ pQuat(pNorm axis, float angle)
  {
    v = __sinf(angle/2) * axis.v;
    w = __cosf(angle/2);
  }

  pVect v;
  float w;
};

__device__ pQuat cast_quat(float4 v)
{
  pQuat q;
  q.v.x = v.x;
  q.v.y = v.y;
  q.v.z = v.z;
  q.w = v.w;
  return q;
}

__device__ pQuat cq(float4 v){ return cast_quat(v); }

__device__ pQuat quat_normalize(pQuat q)
{
  float len_sq = dot(q.v,q.v) + q.w * q.w;
  float norm_factor = 1.0f / sqrtf(len_sq);
  pQuat r;
  r.v = norm_factor * q.v;
  r.w = norm_factor * q.w;
  return r;
}

// Make float4
__device__ float4 c4(pQuat q){ return make_float4(q.v.x,q.v.y,q.v.z,q.w); }
__device__ float4 m4(pNorm v, float w) { return m4(v.v,w); }

__device__ pVect fabs(pVect v)
{ return pVect(::fabs(v.x),::fabs(v.y),::fabs(v.z)); }
__device__ float min(pVect v){ return ::min(::min(v.x,v.y),v.z); }
__device__ float max(pVect v){ return ::max(::max(v.x,v.y),v.z); }
__device__ float sum(pVect v){ return v.x+v.y+v.z; }

// Cross Product of Two Vectors
__device__ pVect
cross(pVect a, pVect b)
{
  return pVect
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}
__device__ pVect cross(pVect a, pNorm b){ return cross(a,b.v); }
__device__ pVect cross(pNorm a, pVect b){ return cross(a.v,b); }

// Cross Product of Vectors Between Coordinates
__device__ pVect
 cross3(pCoor a, pCoor b, pCoor c)
{
  pVect ab = a - b;
  pVect cb = c - b;
  return cross(ab,cb);
}

__device__ pQuat quat_mult(pQuat a, pQuat b)
{
  float w = a.w * b.w - dot(a.v,b.v);
  pVect v = a.w * b.v + b.w * a.v + cross(a.v,b.v);
  pQuat q;
  q.w = w;
  q.v = v;
  return q;
};

__device__ inline pQuat operator * (pQuat q, pQuat v)
{ return quat_mult(q,v); }


class __builtin_align__(16) pMatrix3x3p {
public:
  __device__ pMatrix3x3p() {};
  __device__ pMatrix3x3p(pQuat q){ set_rotation(q); }
  __device__ pMatrix3x3p(pMatrix3x3p& m){r0=m.r0; r1=m.r1; r2=m.r2;}
  __device__ void set_rotation(pQuat q);
  __device__ void set_rotation(pVect u, float theta);
  pVect4 r0, r1, r2;
};

class pMatrix {
public:
  pVect4 r[4];
};

__device__ void
pMatrix3x3p::set_rotation(pVect u, float theta)
{
  const float cos_theta = __cosf(theta);
  const float sin_theta = sqrtf(1.0f - cos_theta * cos_theta );
  r0.x = u.x * u.x + cos_theta * ( 1 - u.x * u.x );
  r0.y = u.x * u.y * ( 1 - cos_theta ) - u.z * sin_theta;
  r0.z = u.z * u.x * ( 1 - cos_theta ) + u.y * sin_theta;
  r1.x = u.x * u.y * ( 1 - cos_theta ) + u.z * sin_theta;
  r1.y = u.y * u.y + cos_theta * ( 1 - u.y * u.y );
  r1.z = u.y * u.z * ( 1 - cos_theta ) - u.x * sin_theta;
  r2.x = u.z * u.x * ( 1 - cos_theta ) - u.y * sin_theta;
  r2.y = u.y * u.z * ( 1 - cos_theta ) + u.x * sin_theta;
  r2.z = u.z * u.z + cos_theta * ( 1 - u.z * u.z );
}

// Set matrix m to a rotation matrix based on quaternion q.
__device__ void
pMatrix3x3p::set_rotation(pQuat q)
{
  r0.x = 1.f - 2.f * q.v.y * q.v.y - 2.f * q.v.z * q.v.z;
  r0.y = 2.f * q.v.x * q.v.y - 2.f * q.w * q.v.z;
  r0.z = 2.f * q.v.x * q.v.z + 2.f * q.w * q.v.y;
  r1.x = 2.f * q.v.x * q.v.y + 2.f * q.w * q.v.z;
  r1.y = 1.f - 2.f * q.v.x * q.v.x - 2.f * q.v.z * q.v.z;
  r1.z = 2.f * q.v.y * q.v.z - 2.f * q.w * q.v.x;
  r2.x = 2.f * q.v.x * q.v.z - 2.f * q.w * q.v.y;
  r2.y = 2.f * q.v.y * q.v.z + 2.f * q.w * q.v.x;
  r2.z = 1.f - 2.f * q.v.x * q.v.x - 2.f * q.v.y * q.v.y;
  r0.w = r1.w = r2.w = 0;  // Zero these to get vector writes.
}

__device__ pVect operator *(pMatrix3x3p m, pVect coor)
{ return
    pVect(dot(m.r0,coor), dot(m.r1,coor), dot(m.r2,coor)); }

} // namespace pCUDA_coord
