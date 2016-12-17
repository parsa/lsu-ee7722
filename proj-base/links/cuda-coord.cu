///
/// Useful Functions and Types
///

typedef float3 pCoor;
typedef float3 pVect;

struct pMatrix3x3 { float3 r0, r1, r2; };
__device__ float3
make_float3(float4 f4){return make_float3(f4.x,f4.y,f4.z);}

__device__ float3 m3(float a, float b, float c){ return make_float3(a,b,c); }
__device__ float3 m3(float4 a){ return make_float3(a); }
__device__ float3 xyz(float4 a){ return m3(a); }
__device__ float4 m4(float3 v, float w) { return make_float4(v.x,v.y,v.z,w); }
__device__ float4 m4(float3 v) { return make_float4(v.x,v.y,v.z,0); }

__device__ float4 make_float4(float f) { return make_float4(f,f,f,f); }
__device__ float4 m4(float f) { return make_float4(f); }

__device__ pVect operator +(pVect a,pVect b)
{ return make_float3(a.x+b.x,a.y+b.y,a.z+b.z); }
__device__ pVect operator -(pVect a,pVect b)
{ return make_float3(a.x-b.x,a.y-b.y,a.z-b.z); }
__device__ pVect operator -(float4 a,float4 b)
{ return make_float3(a.x-b.x,a.y-b.y,a.z-b.z); }
__device__ pVect operator -(pCoor a,float4 b)
{ return make_float3(a.x-b.x,a.y-b.y,a.z-b.z); }
__device__ pVect operator *(float s, pVect v)
{return make_float3(s*v.x,s*v.y,s*v.z);}
__device__ pVect operator *(pVect v, float s)
{return make_float3(s*v.x,s*v.y,s*v.z);}
__device__ float4 operator *(float s, float4 v)
{return make_float4(s*v.x,s*v.y,s*v.z,s*v.w);}
__device__ pVect operator *(pVect u, pVect v)
{return make_float3(u.x*v.x,u.y*v.y,u.z*v.z);}
__device__ pVect operator -(pVect v) { return make_float3(-v.x,-v.y,-v.z); }
__device__ float3 operator -=(float3& a, pVect b) {a = a - b; return a;}
__device__ float3 operator +=(float3& a, pVect b) {a = a + b; return a;}

__device__ float3 operator *=(float3& a, float b)
{ a.x *= b;  a.y *= b; a.z *= b;  return a;}

struct pNorm {
  pVect v;
  float mag_sq, magnitude;
};

__device__ pVect operator *(float s, pNorm n) { return s * n.v;}

// Make a Coordinate
__device__ pCoor 
mc(float x, float y, float z){ return make_float3(x,y,z); }
__device__ pCoor mc(float4 c){ return make_float3(c.x,c.y,c.z); }

__device__ void set_f3(float3& a, float4 b){a.x = b.x; a.y = b.y; a.z = b.z;}
__device__ void set_f4(float4& a, float3 b)
{a.x = b.x; a.y = b.y; a.z = b.z; a.w = 1;}
__device__ void set_f4(float4& a, float3 b, float c)
{a.x = b.x; a.y = b.y; a.z = b.z; a.w = c;}

// Make a Vector
__device__ pVect
mv(float x, float y, float z){ return make_float3(x,y,z); }
__device__ pVect mv(float3 a, float3 b) { return b-a; }
__device__ pVect mv(float a) { return make_float3(a,a,a); }

__device__ float dot(float4 a, float4 b)
{ return a.x*b.x + a.y*b.y + a.z*b.z + a.w*b.w;}
__device__ float dot(pVect a, pVect b){ return a.x*b.x + a.y*b.y + a.z*b.z;}
__device__ float dot(pVect a, pNorm b){ return dot(a,b.v); }
__device__ float dot(pNorm a, pVect b){ return dot(a.v,b); }
__device__ float dot3(float4 a, float4 b){ return dot(m3(a),m3(b)); }

__device__ float mag_sq(pVect v){ return dot(v,v); }
__device__ float length(pVect a) {return sqrtf(mag_sq(a));}
__device__ pVect normalize(pVect a) { return rsqrtf(mag_sq(a))*a; }

// Make a Normal (a structure containing a normalized vector and length)
__device__ pNorm mn(pVect v)
{
  pNorm n;
  n.mag_sq = mag_sq(v);
  if ( n.mag_sq == 0 )
    {
      n.magnitude = 0;
      n.v.x = n.v.y = n.v.z = 0;
    }
  else
    {
      const float rsq = 1.0f/sqrtf(n.mag_sq);
      n.magnitude = 1.0f/rsq;
      n.v = rsq * v;
    }
  return n;
}
__device__ pNorm mn(float4 a, float4 b) {return mn(b-a);}
__device__ pNorm mn(pCoor a, pCoor b) {return mn(b-a);}
__device__ pNorm mn(float x, float y, float z) {return mn(mv(x,y,z));}
__device__ pNorm mn(float4 v4)
{ pNorm n; n.v = m3(v4);  n.magnitude = v4.w;  return n; }
__device__ pNorm mn(float3 v3, float mag)
{ pNorm n; n.v = v3;  n.magnitude = mag;  return n; }

// The unary - operator doesn't seem to work when used in an argument.
__device__ pNorm operator -(pNorm n)
{
  pNorm m;
  m.magnitude = n.magnitude;
  m.mag_sq = n.mag_sq;
  m.v = -n.v;
  return m;
}

struct pQuat {
  float3 v;
  float w;
};

// Make Quaternion
__device__ pQuat mq(pNorm axis, float angle)
{
  pQuat q;
  q.v = __sinf(angle/2) * axis.v;
  q.w = __cosf(angle/2);
  return q;
}

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

__device__ pVect fabs(pVect v){ return mv(fabs(v.x),fabs(v.y),fabs(v.z)); }
__device__ float min(pVect v){ return min(min(v.x,v.y),v.z); }
__device__ float max(pVect v){ return max(max(v.x,v.y),v.z); }
__device__ float sum(pVect v){ return v.x+v.y+v.z; }

// Cross Product of Two Vectors
__device__ float3
cross(float3 a, float3 b)
{
  return make_float3
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}
__device__ pVect cross(pVect a, pNorm b){ return cross(a,b.v); }
__device__ pVect cross(pNorm a, pVect b){ return cross(a.v,b); }
__device__ pVect crossf3(float4 a, float4 b) { return cross(m3(a),m3(b)); }

// Cross Product of Vectors Between Coordinates
__device__ float3
 cross3(float3 a, float3 b, float3 c)
{
  float3 ab = a - b;
  float3 cb = c - b;
  return cross(ab,cb);
}
__device__ pVect cross3(pVect a, pVect b, pNorm c) { return cross3(a,b,c.v); }


__device__ pQuat quat_mult(pQuat a, pQuat b)
{
  float w = a.w * b.w - dot(a.v,b.v);
  float3 v = a.w * b.v + b.w * a.v + cross(a.v,b.v);
  pQuat q;
  q.w = w;
  q.v = v;
  return q;
  //  return cast_quat(v.x,v.y,v.z,w);
};

__device__ inline pQuat operator * (pQuat q, pQuat v)
{ return quat_mult(q,v); }


__device__ void
pMatrix_set_rotation(pMatrix3x3& m, pVect u, float theta)
{
  const float cos_theta = __cosf(theta);
  const float sin_theta = sqrtf(1.0f - cos_theta * cos_theta );
  m.r0.x = u.x * u.x + cos_theta * ( 1 - u.x * u.x );
  m.r0.y = u.x * u.y * ( 1 - cos_theta ) - u.z * sin_theta;
  m.r0.z = u.z * u.x * ( 1 - cos_theta ) + u.y * sin_theta;
  m.r1.x = u.x * u.y * ( 1 - cos_theta ) + u.z * sin_theta;
  m.r1.y = u.y * u.y + cos_theta * ( 1 - u.y * u.y );
  m.r1.z = u.y * u.z * ( 1 - cos_theta ) - u.x * sin_theta;
  m.r2.x = u.z * u.x * ( 1 - cos_theta ) - u.y * sin_theta;
  m.r2.y = u.y * u.z * ( 1 - cos_theta ) + u.x * sin_theta;
  m.r2.z = u.z * u.z + cos_theta * ( 1 - u.z * u.z );
}

// Set matrix m to a rotation matrix based on quaternion q.
__device__ void
pMatrix_set_rotation(pMatrix3x3& m, float4 q)
{
  m.r0.x = 1.f - 2.f * q.y * q.y - 2.f * q.z * q.z;
  m.r0.y = 2.f * q.x * q.y - 2.f * q.w * q.z;
  m.r0.z = 2.f * q.x * q.z + 2.f * q.w * q.y;
  m.r1.x = 2.f * q.x * q.y + 2.f * q.w * q.z;
  m.r1.y = 1.f - 2.f * q.x * q.x - 2.f * q.z * q.z;
  m.r1.z = 2.f * q.y * q.z - 2.f * q.w * q.x;
  m.r2.x = 2.f * q.x * q.z - 2.f * q.w * q.y;
  m.r2.y = 2.f * q.y * q.z + 2.f * q.w * q.x;
  m.r2.z = 1.f - 2.f * q.x * q.x - 2.f * q.y * q.y;
}

__device__ void
pMatrix_set_rotation(pMatrix3x3& m, pQuat q)
{
  pMatrix_set_rotation(m,c4(q));
}

__device__ pMatrix3x3 mrot(pQuat q)
{
  pMatrix3x3 m;
  pMatrix_set_rotation(m,q);
  return m;
}

__device__ float3 operator *(pMatrix3x3 m, float3 coor)
{ return make_float3(dot(m.r0,coor), dot(m.r1,coor), dot(m.r2,coor)); }

