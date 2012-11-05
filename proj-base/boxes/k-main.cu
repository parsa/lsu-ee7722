/// LSU EE X70X-X (Fall 2012), GPU Programming
//
 /// CUDA code for computing intersections and time-stepping physics model.

// $Id:$

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   This file contains GPU/cuda code.
//   See demo-x-collide.cc for main program.

#include <gp/cuda-util-kernel.h>
#include "k-main.cuh"


///
/// Variables Read or Written By With Host Code
///

 /// Ball Information Structure
//
// This is in soa (structure of arrays) form, rather than
// in the programmer-friendly aos (array of structure) form.
// In soa form it is easier for multiple thread to read contiguous
// blocks of data.
//
__constant__ CUDA_Ball_X balls_x;

///
 /// Ball Contact (tact) Pair Information
///

 /// Balls needed by block.
//
// This array identifies those balls that will be used by each block
// during each contact pass. When a thread starts balls are placed in
// shared memory, then contact between a pair of balls is tested for
// and resolved.
//
__constant__ int *block_balls_needed;

 /// Shared memory array holding balls updated cooperating threads in a block.
#undef USE_STRUCT
#ifdef USE_STRUCT
extern __shared__ CUDA_Phys_W sm_balls[];
#else
extern __shared__ float3 sm_balls[];
__shared__ uchar4 sm_balls_misc[300];
#endif

 /// Pairs of Balls to Check
//
__constant__ SM_Idx2 *tacts_schedule;

 /// Box/Box Intersect
//
__constant__ XX_Pair *xx_pairs;
__constant__ float4 *xx_sects_center;
__constant__ float4 *xx_sects_dir;
__constant__ float4 *xx_sects_debug;


__constant__ float3 gravity_accel_dt;
__constant__ float opt_bounce_loss, opt_bounce_loss_box;
__constant__ float opt_friction_coeff, opt_friction_roll;
__constant__ float platform_xmin, platform_xmax;
__constant__ float platform_zmin, platform_zmax;
__constant__ float platform_xmid, platform_xrad;
__constant__ float delta_t;
__constant__ float elasticity_inv_dt;
__constant__ bool opt_debug, opt_debug2;

__constant__ CUDA_Wheel wheel;
extern __shared__ float block_torque_dt[];

static __host__ void collect_symbols();


///
/// Useful Functions and Types
///

typedef float3 pCoor;
typedef float3 pVect;

__device__ float3 make_float3(float4 f4){return make_float3(f4.x,f4.y,f4.z);}
__device__ float3 m3(float4 a){ return make_float3(a); }
__device__ float3 xyz(float4 a){ return m3(a); }
__device__ float4 m4(float3 v, float w) { return make_float4(v.x,v.y,v.z,w); }

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
__device__ float4 operator *(float s, float4 v)
{return make_float4(s*v.x,s*v.y,s*v.z,s*v.w);}
__device__ pVect operator *(pVect u, pVect v)
{return make_float3(u.x*v.x,u.y*v.y,u.z*v.z);}
__device__ pVect operator -(pVect v) { return make_float3(-v.x,-v.y,-v.z); }
__device__ float3 operator -=(float3& a, pVect b) {a = a - b; return a;}
__device__ float3 operator +=(float3& a, pVect b) {a = a + b; return a;}

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
      n.magnitude = sqrtf(n.mag_sq);
      n.v = (1.0f/n.magnitude) * v;
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
  float w;
  pVect v;
};

// Make Quaternion
__device__ float4 mq(pNorm axis, float angle)
{
  return m4( __sinf(angle/2) * axis.v, __cosf(angle/2) );
}

__device__ float4 quat_normalize(float4 q)
{
  float len_sq = dot(q,q);
  float norm_factor = 1.0f / sqrtf(len_sq);
  return norm_factor * q;
}

// Make float4
__device__ float4 m4(pQuat q){ return make_float4(q.v.x,q.v.y,q.v.z,q.w); }
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

__device__ float4 quat_mult(float4 a, float4 b)
{
  float w = a.w * b.w - dot3(a,b);
  float3 v = a.w * m3(b) + b.w * m3(a) + crossf3(a,b);
  return make_float4(v.x,v.y,v.z,w);
};


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

__device__ float3 operator *(pMatrix3x3 m, float3 coor)
{ return make_float3(dot(m.r0,coor), dot(m.r1,coor), dot(m.r2,coor)); }


//
/// Ball Physics Functions
//
// See demo-x-collide.cc for details.

__device__ pVect
point_rot_vel(float3 omega, float r, pNorm direction)
{
  /// Return velocity of point on surface of sphere of radius r.
  //
  return r * cross( omega, direction );
}

__device__ float
get_fdt_to_do(float r, float mass_inv) { return 2.5f * mass_inv / r; }

__device__ float3
tan_force_dt
(pNorm tact_dir, float3 force_dt, float fdt_to_do)
{
  /// Change rotation rate due to force_dt at tact_dir in direction force_dir.
  //
  return cross(tact_dir, fdt_to_do * force_dt );
}


///
/// Major Ball Physics Routines
///

// A time step is computed using two kernels, pass_pairs and
// pass_platform. The pass_pairs kernel, which might be launched
// several times, handles collisions between balls. The pass_platform
// kernel handles collision between balls and the platform, and also
// updates position and orientation, and spins the wheel.


__device__ bool
tile_ball_collide
(CUDA_Tile_W& tile, CUDA_Ball_W& ball, pCoor& tact_pos, pVect& tact_dir)
{
  // If tile in contact with ball return true and write contact
  // point on tile to tact_pos and ball-center-to-tact-pos direction
  // to tact_dir.

  pVect tile_to_ball = mv(tile.pt_ll,ball.position);

  // Distance from tile's plane to the ball.
  const float dist = dot(tile_to_ball,tile.normal);
  const float radius = ball.radius;

  if ( fabs(dist) > radius ) return false;

  // The closest point on tile plane to the ball.
  pCoor pt_closest = ball.position - dist * tile.normal; 

  // How far up the tile in the y direction the center of the ball sits
  const float dist_ht = dot(tile.norm_up,tile_to_ball);  

  if ( dist_ht < -radius ) return false;
  if ( dist_ht > tile.height + radius ) return false;

  // How far up the tile in the x direction the center of the ball sits
  const float dist_wd = dot(tile.norm_rt,tile_to_ball);
  if ( dist_wd < -radius ) return false;
  if ( dist_wd > tile.width + radius ) return false;

  // If ball touching tile surface (not including an edge or corner)
  // then set up the pseudo ball for collision handling
  if ( dist_ht >= 0 && dist_ht <= tile.height
       && dist_wd >= 0 && dist_wd <= tile.width )
    {
      tact_pos = pt_closest;
      tact_dir = dist > 0 ? -tile.normal : tile.normal;
      return true;
    }

  float3 pt_lr = tile.pt_ll + tile.width * tile.norm_rt;
  float3 pt_ul = tile.pt_ll + tile.height * tile.norm_up;
  float3 pt_ur = pt_lr + tile.height * tile.norm_up;

  // Test whether the ball is touching a corner
  if ( ( dist_ht < 0 || dist_ht > tile.height ) 
       && ( dist_wd < 0 || dist_wd > tile.width) )
    {
      pCoor ref_pt;

      // We need to place the pseudo ball based upon the vector from
      // ball position to the corner. First step is to figure out which
      // corner.

      if ( dist_ht < 0 && dist_wd < 0 ) 
        {
          ref_pt = tile.pt_ll;
        }
      else if ( dist_ht < 0 && dist_wd > tile.width ) 
        {
          ref_pt = pt_lr;
        }
      else if ( dist_ht > tile.height && dist_wd < 0 ) 
        {
          ref_pt = pt_ul;
        }
      else 
        {
          ref_pt = pt_ur;
        }

      tact_pos = ref_pt;
      tact_dir = normalize(mv(ball.position,ref_pt));
      return true;
    }

  // Else the ball is touching an edge

  const bool tact_horiz = dist_ht < 0 || dist_ht > tile.height;
  const pVect corner_to_tact =
    tact_horiz ? dist_wd * tile.norm_rt : dist_ht * tile.norm_up;
  const pCoor ref_pt =
    tact_horiz ? ( dist_ht < 0 ? tile.pt_ll : pt_ul ) :
    ( dist_wd < 0 ? tile.pt_ll : pt_lr );

  // Find the closest edge point of the tile to the ball
  tact_pos = ref_pt + corner_to_tact;
  tact_dir = normalize(mv(ball.position,tact_pos));

  return true;
}

__device__ void
wheel_collect_tile_force(CUDA_Tile_W& tile, pCoor tact, pVect delta_mo)
{
  pVect to_center = mv(wheel.center,tact);
  // Formula below needs to be checked.
  const float torque_dt = dot(wheel.axis_dir,cross(to_center,delta_mo));
  tile.torque += torque_dt;
}


///
/// Collision (Penetration) Detection and Resolution Routines
///

// Used in both passes.


__device__ bool
penetration_balls_resolve
(CUDA_Ball_W& ball1, CUDA_Ball_W& ball2, bool b2_real, Force_Types ft)
{
  /// Update velocity and angular momentum for a pair of balls in contact.

  // Later, separate friction and other forces.
  if ( ft == FT_Friction ) return false;

  pVect zero_vec = mv(0,0,0);
  pNorm dist = mn(ball1.position,ball2.position);

  float3 v1 = ball1.velocity;
  float3 v2 = ball2.velocity;
  float3 omega1 = ball1.omega;
  float3 omega2 = ball2.omega;
  const float mass_inv1 = ball1.mass_inv;
  const float mass_inv2 = ball2.mass_inv;
  const float r1 = ball1.radius;
  const float r2 = ball2.radius;

  const float radii_sum = r1 + r2;

  if ( dist.magnitude >= radii_sum ) return false;

  /// WARNING:  This doesn't work: somefunc(-dist); 
  pNorm ndist = -dist;

  // Compute relative (approach) velocity.
  //
  pVect prev_appr_vel = ball1.prev_velocity - ball2.prev_velocity;
  const float prev_approach_speed = dot( prev_appr_vel, dist );

  const float loss_factor = 1 - opt_bounce_loss;

  // Compute change in speed based on how close balls touching, ignoring
  // energy loss.
  //
  const float appr_force_dt_no_loss =
    ( radii_sum - dist.magnitude ) * 
    ( radii_sum - dist.magnitude ) * elasticity_inv_dt;

  // Change in speed accounting for energy loss. Only applied when
  // balls separating.
  //
  const float appr_force_dt =
    prev_approach_speed > 0
    ? appr_force_dt_no_loss : loss_factor * appr_force_dt_no_loss;

  const float appr_deltas_1 = appr_force_dt * mass_inv1;

  /// Update Linear Velocity
  //
  v1 -= appr_deltas_1 * dist;
  if ( b2_real ) v2 += appr_force_dt * mass_inv2 * dist;


  const float fdt_to_do_1 = get_fdt_to_do(r1,mass_inv1);
  const float fdt_to_do_2 = get_fdt_to_do(r2,mass_inv2);

  // Find speed on surface of balls at point of contact.
  //
  pVect tact1_rot_vel = point_rot_vel(omega1,r1,dist);
  pVect tact2_rot_vel = point_rot_vel(omega2,r2,ndist);

  // Find relative velocity of surfaces at point of contact
  // in the plane formed by their surfaces.
  //
  pVect tan_vel = prev_appr_vel - prev_approach_speed * dist;
  pNorm tact_vel_dir = mn(tact1_rot_vel - tact2_rot_vel + tan_vel);

  // Find change in velocity due to friction.
  //
  const float fric_force_dt_potential =
    appr_force_dt_no_loss * opt_friction_coeff;

  const float mass_inv_sum = b2_real ? mass_inv1 + mass_inv2 : mass_inv1;

  const float force_dt_limit = tact_vel_dir.magnitude / ( 3.5f * mass_inv_sum );

  // If true, surfaces are not sliding or will stop sliding after
  // frictional forces applied. (If a ball surface isn't sliding
  // against another surface than it must be rolling.)
  //
  const bool will_roll = force_dt_limit <= fric_force_dt_potential;

  const float sliding_fric_force_dt =
    will_roll ? force_dt_limit : fric_force_dt_potential;

  const float dv_tolerance = 0.000001f;

  const float sliding_fric_dv_1 = sliding_fric_force_dt * mass_inv1;
  const float3 sliding_fric_fdt_vec = sliding_fric_force_dt * tact_vel_dir;

  if ( sliding_fric_dv_1 > dv_tolerance )
    {
      // Apply tangential force (resulting in angular momentum change) and
      // linear force (resulting in velocity change).
      //
      omega1 += tan_force_dt(dist, sliding_fric_fdt_vec, -fdt_to_do_1);
      v1 -= sliding_fric_dv_1 * tact_vel_dir;
    }

  const float sliding_fric_dv_2 = sliding_fric_force_dt * mass_inv2;

  if ( b2_real && sliding_fric_dv_2 > dv_tolerance )
    {
      // Apply frictional forces for ball 2.
      //
      omega2 += tan_force_dt(ndist, sliding_fric_fdt_vec, fdt_to_do_2);
      v2 += sliding_fric_dv_2 * tact_vel_dir;;
    }

  {
    /// Torque
    //
    //
    // Account for forces of surfaces twisting against each
    // other. (For example, if one ball is spinning on top of
    // another.)
    //
    const float appr_omega = dot(omega2,dist) - dot(omega1,dist);
    const float fdt_to_do_sum =
      b2_real ? fdt_to_do_1 + fdt_to_do_2 : fdt_to_do_1;
    const float fdt_limit = fabs(appr_omega) / fdt_to_do_sum;
    const bool rev = appr_omega < 0;
    const float fdt_raw = min(fdt_limit,fric_force_dt_potential);
    const pVect fdt_v = ( rev ? -fdt_raw : fdt_raw ) * dist;
    omega1 += fdt_to_do_1 * fdt_v;
    if ( b2_real ) omega2 -= fdt_to_do_2 * fdt_v;
  }

  ball1.velocity = v1;
  ball1.omega = omega1;
  if ( !b2_real ) return true;
  ball2.velocity = v2;
  ball2.omega = omega2;

  return true;

  {
    /// Rolling Friction
    //
    // The rolling friction model used here is ad-hoc.

    pVect tan_b12_vel = b2_real ? 0.5f * tan_vel : zero_vec;
    const float torque_limit_sort_of = appr_force_dt_no_loss
      * sqrt( radii_sum - dist.mag_sq / radii_sum );
      //  * sqrt( ball1.radius - 0.25 * dist.mag_sq * r_inv );

    pVect tact1_rot_vel = point_rot_vel(omega1,r1,dist);
    pVect tact1_roll_vel = tact1_rot_vel + tan_b12_vel;
    pNorm tact1_roll_vel_dir = mn(tact1_roll_vel);
    pVect lost_vel = zero_vec;

    const float rfric_loss_dv_1 =
      torque_limit_sort_of * 2.5f * mass_inv1 *
      ( tact1_roll_vel_dir.magnitude * opt_friction_roll /
        ( 1 + tact1_roll_vel_dir.magnitude * opt_friction_roll ) );
    
    pVect lost_vel1 =
      min(tact1_roll_vel_dir.magnitude, rfric_loss_dv_1) * tact1_roll_vel_dir;

    lost_vel = -lost_vel1;
    
    if ( b2_real )
      {
        pVect tact2_rot_vel = point_rot_vel(omega2,r2,ndist);
        pVect tact2_roll_vel = tact2_rot_vel - tan_b12_vel;
        pNorm tact2_roll_vel_dir = mn(tact2_roll_vel);
        const float rfric_loss_dv_2 =
          torque_limit_sort_of * 2.5f * mass_inv2 *
          ( tact2_roll_vel_dir.magnitude * opt_friction_roll /
            ( 1 + tact2_roll_vel_dir.magnitude * opt_friction_roll ) );
        pVect lost_vel2 =
          min(tact2_roll_vel_dir.magnitude, rfric_loss_dv_2 )
          * tact2_roll_vel_dir;

        lost_vel += lost_vel2;
      }

    omega1 += tan_force_dt(dist, 0.4f / mass_inv1 * lost_vel, fdt_to_do_1);
    if ( b2_real )
      omega2 += tan_force_dt(dist, 0.4f / mass_inv2 * lost_vel, fdt_to_do_2);
  }
  return true;
}

//
// Generic operations used by box code.
//

__device__ float3
sign_mask(int idx, float3 v)
{
  return make_float3
    (idx & 4 ? v.x : -v.x, idx & 2 ? v.y : -v.y, idx & 1 ? v.z : -v.z );
}

// Multiply transpose of matrix m by column vector v.
__device__ float3 mm_transpose(pMatrix3x3 m, float3 v)
{ return v.x * m.r0 + v.y * m.r1 + v.z * m.r2; }

__device__ float
set_min(float &a, float b)
{
  if ( b < a ) a = b;
  return a;
}

__device__ float
set_max(float &a, float b)
{
  if ( b > a ) a = b;
  return a;
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

// Set transpose of matrix m to a rotation matrix based on quaternion q.
__device__ void
pMatrix_set_rotation_transpose(pMatrix3x3& m, float4 q)
{
  m.r0.x = 1.f - 2.f * q.y * q.y - 2.f * q.z * q.z;
  m.r1.x = 2.f * q.x * q.y - 2.f * q.w * q.z;
  m.r2.x = 2.f * q.x * q.z + 2.f * q.w * q.y;
  m.r0.y = 2.f * q.x * q.y + 2.f * q.w * q.z;
  m.r1.y = 1.f - 2.f * q.x * q.x - 2.f * q.z * q.z;
  m.r2.y = 2.f * q.y * q.z - 2.f * q.w * q.x;
  m.r0.z = 2.f * q.x * q.z - 2.f * q.w * q.y;
  m.r1.z = 2.f * q.y * q.z + 2.f * q.w * q.x;
  m.r2.z = 1.f - 2.f * q.x * q.x - 2.f * q.y * q.y;
}

//
// Box operations.
//

struct pLine {
  __device__ pLine() {};
  __device__ pLine(pCoor s, pVect d, float l):start(s),dir(d),len(l){};
  pCoor start;
  pVect dir;
  float len;
};


__device__ int8_t
get_edge_vtx_idx(int edge)
{
  // Index: xyz (z is LSB).
#if 1
  const int axis = edge >> 2;
  const int mask = 0xc >> axis;
  const int face_vtx = edge & 3;
  const int box_vtx_check = ( face_vtx & mask ) + face_vtx;
  return box_vtx_check;
#else
  static const int8_t bi[12] =
    {
      0, 1, 2, 3,
      0, 1, 4, 5,
      0, 2, 4, 6
    };
  return bi[edge];
#endif
}

__device__ float3
box_get_vertices(CUDA_Box_W& box, int vertex)
{
  return box.position + mm_transpose(box.rot_inv,sign_mask(vertex,box.to_111));
}

__device__ float3
box_get_axis_norm(CUDA_Box_W& box, int axis)
{
  return axis == 0 ? box.rot_inv.r0 :
    axis == 1 ? box.rot_inv.r1 : box.rot_inv.r2;
}

__device__ float3
box_get_face_norm(CUDA_Box_W& box, int face)
{
  pVect norm_raw = box_get_axis_norm(box,face>>1);
  return face & 1 ? norm_raw : -norm_raw;
}

__device__ float
box_get_axis_len(CUDA_Box_W& box, int axis)
{
  return 2.0f * 
    ( axis == 0 ? box.to_111.x : axis == 1 ? box.to_111.y : box.to_111.z );
}

__device__ pLine
box_get_edge(CUDA_Box_W& box, int edge)
{
  const int axis = edge >> 2;
  const int8_t box_vtx = get_edge_vtx_idx(edge);
  return
    pLine(box_get_vertices(box,box_vtx), 
          box_get_axis_norm(box,axis), 
          box_get_axis_len(box,axis));
}

__device__ void
box_set_mi_vec(CUDA_Box_W& box,float3 to_111)
{
  pVect dsq = to_111 * to_111;
  float dsqs = dsq.x + dsq.y + dsq.z;
  float mass_factor = 1.0f / ( box.mass_inv * 3.0f );
  box.mi_vec = mass_factor * ( mv(dsqs) - dsq );
}

__device__ void
box_set_mi_vec(CUDA_Box_W& box)
{
  box_set_mi_vec(box,box.to_111);
}

__device__ float
box_get_moment_of_inertia_inv(CUDA_Box_W& box, pNorm axis);


__device__ float3
box_get_vel(CUDA_Box_W&box, float3 pos)
{
  pVect cent_to_pt = mv(box.position,pos);
  pVect rot_vel = cross(box.omega,cent_to_pt);
  return rot_vel + box.velocity;
}

__device__ void
box_geometry_update(CUDA_Box_W& box)
{
  pMatrix_set_rotation_transpose(box.rot_inv, box.orientation);
  box_set_mi_vec(box);
}

__device__ void
box_apply_force_dt(CUDA_Box_W& box, float3 tact, float3 force)
{
  box.velocity += box.mass_inv * force;
  pVect cent_to_tact = mv(box.position,tact);
  pVect torque = cross(cent_to_tact,force);
  pNorm torqueN = mn(torque);
  float mi_inv = box_get_moment_of_inertia_inv(box,torqueN);
  box.omega += mi_inv * torque;
}

__device__ float
box_get_moment_of_inertia_inv(CUDA_Box_W& box, pNorm axis)
{
  if ( axis.mag_sq < 1e-11f || box.mass_inv == 0 ) return 0;
  pVect tl = box.rot_inv * axis.v;
  pVect tls = tl * tl;
  float mi = dot(tls,box.mi_vec);
  return 1.0f / mi;
}

__device__ float
box_get_moment_of_inertia_inv(CUDA_Box_W& box, float3 tact, pNorm dir)
{
  pVect cent_to_tact = mv(box.position,tact);
  pNorm torque_axis = mn(cross(cent_to_tact,dir));
  return box_get_moment_of_inertia_inv(box,torque_axis);
}

__device__ void
box_apply_force_fric_dt
(CUDA_Box_W& box, float3 tact, pNorm force_dir, float force_mag_dt)
{
  box_apply_force_dt(box,tact,force_mag_dt*force_dir);
}

__device__ CUDA_SectTT
sect_init()
{
  CUDA_SectTT sect;
  sect.exists = false;
  return sect;
}

#include "k-boxes.h"

///
/// Pass Box/Box Intersect
///

__global__ void pass_xx_intersect(int xx_pairs_count);

__host__ void
pass_xx_intersect_launch(dim3 dg, dim3 db, int xx_pairs_count)
{
  const int shared_amt = 0;
  pass_xx_intersect<<<dg,db,shared_amt>>>(xx_pairs_count);
}

__device__ void
penetration_boxes_resolve_force
(CUDA_Box_W& box1, CUDA_Box_W& box2, float3 pos, pNorm sep_normal)
{
  const float pen_dist = 0.1f * sep_normal.magnitude;

  pVect vel1 = box_get_vel(box1,pos);
  pVect vel2 = box_get_vel(box2,pos);
  pVect velto1 = vel2 - vel1;

  const float sep_vel = dot(velto1,sep_normal.v);

  const float loss_factor = 1 - opt_bounce_loss_box;
  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const bool separating = sep_vel >= 0;
  const float appr_force_dt = separating
    ? force_dt_no_loss * loss_factor : force_dt_no_loss;

  pVect sep_force = appr_force_dt * sep_normal.v;

  box_apply_force_dt(box1, pos, -sep_force );
  box_apply_force_dt(box2, pos, sep_force );
}

__device__ void
penetration_boxes_resolve_fric
(CUDA_Box_W& box1, CUDA_Box_W& box2, float3 pos, pNorm sep_normal)
{
  const float pen_dist = 0.1f * sep_normal.magnitude;
  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const float fric_force_dt_potential =
    force_dt_no_loss * opt_friction_coeff;
  
  /// Torque
  //
  //
  // Account for forces of surfaces twisting against each
  // other. (For example, if one box is spinning on top of
  // another.)
  //
  const float appr_omega =
    dot(box2.omega,sep_normal) - dot(box1.omega,sep_normal);
  {
    const float mi1_inv = box_get_moment_of_inertia_inv(box1,sep_normal);
    const float mi2_inv = box_get_moment_of_inertia_inv(box2,sep_normal);
    const float fdt_limit = fabs(appr_omega) / ( mi1_inv + mi2_inv );
    const bool rev = appr_omega < 0;
    const float fdt_raw = min(fdt_limit,fric_force_dt_potential);
    const pVect fdt_v = ( rev ? -fdt_raw : fdt_raw ) * sep_normal;
    box1.omega += mi1_inv * fdt_v;
    box2.omega -= mi2_inv * fdt_v;
  }

  pVect vel1b = box_get_vel(box1,pos);
  pVect vel2b = box_get_vel(box2,pos);
  pVect velto1b = vel2b - vel1b;

  const float sep_velb = dot(velto1b,sep_normal);
  pNorm tan_vel = mn(velto1b - sep_velb * sep_normal);

  const float fdt_limit =
    0.5f *
    tan_vel.magnitude /
    ( box1.mass_inv + box2.mass_inv
      + box_get_moment_of_inertia_inv(box1,pos,tan_vel)
      + box_get_moment_of_inertia_inv(box2,pos,tan_vel) );

  const float fric_force_dt = min(fdt_limit,fric_force_dt_potential);

  box_apply_force_fric_dt(box1,pos, tan_vel, fric_force_dt);
  box_apply_force_fric_dt(box2,pos, -tan_vel, fric_force_dt);
}


__device__ bool
penetration_boxes_resolve
(CUDA_Phys_W& phys1, CUDA_Phys_W& phys2, int tsidx, Force_Types ft)
{
  /// Update velocity and angular momentum for a pair of boxes in contact.

  CUDA_Box_W& box1 = phys1.box;
  CUDA_Box_W& box2 = phys2.box;

  float4 dir_and_mag = xx_sects_dir[tsidx];
  if ( dir_and_mag.w == 0 ) return false;
  float4 center_and_um = xx_sects_center[tsidx];
  float3 center = m3(center_and_um);
  pNorm sep_normal = mn(dir_and_mag);
  if ( ft & FT_NonFriction )
    penetration_boxes_resolve_force(box1,box2,center,sep_normal);
  if ( ft & FT_Friction )
    penetration_boxes_resolve_fric(box1,box2,center,sep_normal);
  return true;
}


///
/// Pairs Pass
///
//
// Resolve ball collisions with each other.

__global__ void pass_pairs
(int prefetch_offset, int schedule_offset, int round_cnt, 
 int max_balls_per_thread, int balls_per_block, Force_Types ft);

__host__ void
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt,
 int max_balls_per_thread, int balls_per_block, Force_Types ft)
{
#ifdef USE_STRUCT
  const int shared_amt = balls_per_block * sizeof(CUDA_Phys_W);
#else
  const int shared_amt = balls_per_block * sizeof(sm_balls[0]) * 8;
#endif
  pass_pairs<<<dg,db,shared_amt>>>
    (prefetch_offset, schedule_offset, round_cnt,
     max_balls_per_thread, balls_per_block, ft);
}

#ifndef USE_STRUCT
struct SM_Offsets {
  int idx_pos;
  int idx_vel;
  int idx_omega;
  int idx_prev_vel;
  int idx_rad_etc;
  int idx_to_111;
  int idx_ori_xyz;
  int factor;
};

__device__ CUDA_Phys_W
get_sm_ball(SM_Offsets& smo, int idx)
{
  CUDA_Phys_W phys;
  const int sidx = idx * smo.factor;
  phys.box.velocity = sm_balls[smo.idx_vel+sidx];
  phys.box.prev_velocity = sm_balls[smo.idx_prev_vel+sidx];
  phys.box.position = sm_balls[smo.idx_pos+sidx];
  phys.box.omega = sm_balls[smo.idx_omega+sidx];
  phys.box.radius = sm_balls[smo.idx_rad_etc+sidx].x;
  phys.box.mass_inv = sm_balls[smo.idx_rad_etc+sidx].y;
  phys.read_only = phys.box.mass_inv == 0;
  return phys;
}

__device__ void
upgrade_sm_box(CUDA_Phys_W& phys, SM_Offsets& smo, int idx)
{
  const int sidx = idx * smo.factor;
  float4 ori;
  set_f4(ori,sm_balls[smo.idx_ori_xyz+sidx],
         sm_balls[smo.idx_rad_etc+sidx].z);
  pMatrix_set_rotation_transpose(phys.box.rot_inv,ori);
  float3 to_111 = sm_balls[smo.idx_to_111+sidx];
  phys.box.to_111 = to_111;
  box_set_mi_vec(phys.box);
}

__device__ void
put_sm_phys(SM_Offsets& smo, int sidx, CUDA_Phys_W& phys)
{
  sm_balls[smo.idx_vel+sidx] = phys.ball.velocity;
  sm_balls[smo.idx_omega+sidx] = phys.ball.omega;
}
#endif

__global__ void
pass_pairs(int prefetch_offset, int schedule_offset, int round_cnt,
           int max_balls_per_thread, int balls_per_block, Force_Types ft)
{
  const int tid = threadIdx.x;

  // Initialized variables used to access balls_needed and tacts_schedule
  // arrays.
  //
  const int si_block_size = blockIdx.x * max_balls_per_thread * blockDim.x;
  const int si_block_base = prefetch_offset + si_block_size + tid;
  const int sp_block_size = blockIdx.x * round_cnt * blockDim.x;
  const int sp_block_base = schedule_offset + sp_block_size + tid;

  /// Prefetch objects to shared memory.
  //
#ifdef USE_STRUCT
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= balls_per_block ) continue;
      const int m_idx = block_balls_needed[ si_block_base + i * blockDim.x ];
      CUDA_Phys_W& phys = sm_balls[idx];
      CUDA_Ball_W& ball = phys.ball;
      CUDA_Box_W& box = phys.box;
      phys.m_idx = m_idx;
      if ( m_idx < 0 ) continue;

      int4 tact_counts = balls_x.tact_counts[m_idx];
      phys.pt_type = tact_counts.x;
      phys.contact_count = tact_counts.y;
      phys.debug_pair_calls = tact_counts.z;
      phys.part_of_wheel = bool(tact_counts.w & 2);
      phys.read_only = tact_counts.w & 1;

      ball.velocity = xyz(balls_x.velocity[m_idx]);
      ball.prev_velocity = xyz(balls_x.prev_velocity[m_idx]);
      ball.position = xyz(balls_x.position[m_idx]);
      ball.omega = xyz(balls_x.omega[m_idx]);
      float4 ball_props = balls_x.ball_props[m_idx];
      ball.radius = ball_props.x;
      ball.mass_inv = ball_props.y;
      ball.pad1 = ball_props.z;
      ball.pad2 = ball_props.w;
      if ( phys.pt_type == PT_Box )
        {
          set_f3(box.to_111, balls_x.to_111[m_idx]);
          box.orientation = balls_x.orientation[m_idx];
          box_geometry_update(box);
        }
    }
#else

  SM_Offsets smo;
  smo.idx_pos = 0;
  smo.idx_vel = 1;
  smo.idx_omega = 2;
  smo.idx_prev_vel = 3;
  smo.idx_rad_etc = 4;
  smo.idx_to_111 = 5;
  smo.idx_ori_xyz = 6;
  smo.factor = 7;

  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= balls_per_block ) continue;
      const int m_idx = block_balls_needed[ si_block_base + i * blockDim.x ];

      if ( m_idx < 0 ) continue;

      int4 tact_counts = balls_x.tact_counts[m_idx];
      const int pt_type = tact_counts.x;
      sm_balls_misc[idx].x = tact_counts.x; // pt_type
      sm_balls_misc[idx].y = tact_counts.y; // contact count
      sm_balls_misc[idx].z = tact_counts.z; // debug_pair_calls
      sm_balls_misc[idx].w = tact_counts.w; // Part of wheel is bit 0x2

      const int sidx = idx * smo.factor;

      sm_balls[smo.idx_vel+sidx] = m3(balls_x.velocity[m_idx]);
      sm_balls[smo.idx_prev_vel+sidx] = m3(balls_x.prev_velocity[m_idx]);
      sm_balls[smo.idx_pos+sidx] = m3(balls_x.position[m_idx]);
      sm_balls[smo.idx_omega+sidx] = m3(balls_x.omega[m_idx]);
      float4 props =balls_x.ball_props[m_idx];
      sm_balls[smo.idx_rad_etc+sidx] = m3(props);
      if ( pt_type == PT_Box )
        {
          sm_balls[smo.idx_to_111+sidx] = m3(balls_x.to_111[m_idx]);
          const float4 orientation = balls_x.orientation[m_idx];
          sm_balls[smo.idx_ori_xyz+sidx] = m3(orientation);
          sm_balls[smo.idx_rad_etc+sidx].z = orientation.w;
        }
    }
#endif

  const pVect zero_vec = mv(0,0,0);

  /// Resolve Collisions
  //
  for ( int round=0; round<round_cnt; round++ )
    {
      const int tsidx = sp_block_base + round * blockDim.x;
      SM_Idx2 indices = tacts_schedule[ tsidx ];
      const int ix = indices.x;
      const int iy = indices.y;

      // Wait for all threads to reach this point (to avoid having
      // two threads operate on the same ball simultaneously).
      //
      __syncthreads();

      if ( indices.x == indices.y ) continue;

#ifdef USE_STRUCT
      CUDA_Phys_W& physx = sm_balls[ix];
      CUDA_Phys_W& physy = sm_balls[iy];
      const unsigned char ptx = physx.pt_type;
      const unsigned char pty = physy.pt_type;
#else
      const int six = ix * smo.factor;
      const int siy = iy * smo.factor;
      CUDA_Phys_W physx = get_sm_ball(smo,ix);
      CUDA_Phys_W physy = get_sm_ball(smo,iy);
      const int ptx = sm_balls_misc[ix].x;
      const int pty = sm_balls_misc[iy].x;
#endif

      if ( ft & FT_NonFriction )
        {
#ifdef USE_STRUCT          
          physx.debug_pair_calls++; physy.debug_pair_calls++;
#else
          sm_balls_misc[ix].z++; sm_balls_misc[iy].z++;
#endif
        }

      char rv;

      if ( ptx == PT_Box && pty == PT_Box )
        {
#ifndef USE_STRUCT
          upgrade_sm_box(physx,smo,ix);
          upgrade_sm_box(physy,smo,iy);
#endif
          rv = penetration_boxes_resolve(physx,physy,tsidx,ft);
        }
      else if ( ptx == PT_Ball && pty == PT_Box )
        {
#ifndef USE_STRUCT
          upgrade_sm_box(physy,smo,iy);
#endif
          rv = penetration_box_ball_resolve(physy,physx,ft);
        }
      else if ( pty == PT_Ball )
        {
          CUDA_Ball_W& ballx = physx.ball;
          CUDA_Ball_W& bally = physy.ball;
          rv = penetration_balls_resolve(ballx,bally,true,ft);
        }
      else if ( pty == PT_Box )
        {
          // Note: Tile / Box collisions not yet handled.
          rv = 0;
        }
      else
        {
          CUDA_Ball_W& ballx = physx.ball;
          CUDA_Tile_W& tiley = physy.tile;
          pCoor tact_pos;
          pVect tact_dir;
          rv = tile_ball_collide(tiley, ballx, tact_pos, tact_dir);
          if ( !rv ) continue;
          CUDA_Ball_W pball;
          pball.radius = 1;
          pball.omega = pball.prev_velocity = pball.velocity = zero_vec;
          pball.position = tact_pos + tact_dir;
          pVect vbefore = physx.ball.velocity;
          penetration_balls_resolve(ballx, pball, false, ft);
          pVect delta_mo = ( 1.0f / ballx.mass_inv )
            * ( ballx.velocity - vbefore );
#ifdef USE_STRUCT
          const bool part_of_wheel = physy.part_of_wheel;
#else
          const bool part_of_wheel = sm_balls_misc[iy].w & 2;
#endif
          if ( part_of_wheel )
            {
              wheel_collect_tile_force(tiley, tact_pos, delta_mo);
              // Note: Need to fix this.
            }
#ifndef USE_STRUCT
          put_sm_phys(smo,six,physx);
          sm_balls_misc[ix].y += 1;
          continue;
#endif
        }

#ifdef USE_STRUCT
      physx.contact_count += rv; physy.contact_count += rv;
#else
      put_sm_phys(smo,six,physx);
      put_sm_phys(smo,siy,physy);
      sm_balls_misc[ix].y += rv; sm_balls_misc[iy].y += rv;
#endif
    }

  __syncthreads();

  /// Copy Ball Data to Memory
  //
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= balls_per_block ) continue;

#ifdef USE_STRUCT
      CUDA_Phys_W& phys = sm_balls[idx];
      const int m_idx = phys.m_idx;
      if ( m_idx < 0 ) continue;
      if ( phys.read_only ) continue;
#else
      const int sidx = idx * smo.factor;
      const int m_idx = block_balls_needed[ si_block_base + i * blockDim.x ];
      if ( m_idx < 0 ) continue;
      const float mass_inv = sm_balls[smo.idx_rad_etc+sidx].y;
      const bool read_only = mass_inv == 0;
      if ( read_only ) continue;
#endif

#ifdef USE_STRUCT
      CUDA_Ball_W& ball = phys.ball;

      int4 tact_counts;
      tact_counts.x = phys.pt_type;
      tact_counts.y = phys.contact_count;
      tact_counts.z = phys.debug_pair_calls;
      tact_counts.w = phys.part_of_wheel;
      balls_x.tact_counts[m_idx] = tact_counts;
      const char pt_type = phys.pt_type;
      set_f4(balls_x.velocity[m_idx], ball.velocity);
      if ( pt_type == PT_Tile ) continue;
      set_f4(balls_x.omega[m_idx], ball.omega);
#else
      balls_x.tact_counts[m_idx].y = sm_balls_misc[idx].y;
      balls_x.tact_counts[m_idx].z = sm_balls_misc[idx].z;
      const unsigned char pt_type = sm_balls_misc[idx].x;
      set_f4(balls_x.velocity[m_idx], sm_balls[smo.idx_vel+sidx]);
      if ( pt_type == PT_Tile ) continue;
      set_f4(balls_x.omega[m_idx], sm_balls[smo.idx_omega+sidx]);
#endif
    }
}


///
/// Platform Pass
///
//
// Resolve ball collisions with platform, also update ball position
// and orientation.

__device__ void platform_collision(CUDA_Phys_W& phys);
__device__ void platform_collision_box(CUDA_Phys_W& phys);
__global__ void pass_platform(int ball_count);
__device__ void pass_platform_ball(CUDA_Phys_W& phys, int idx);
__device__ void pass_platform_tile(CUDA_Phys_W& phys, int idx);
__device__ void pass_platform_box(CUDA_Phys_W& phys, int idx);


__host__ cudaError_t
cuda_get_attr_plat_pairs
(struct cudaFuncAttributes *attr_platform,
 struct cudaFuncAttributes *attr_pairs,
 struct cudaFuncAttributes *attr_xx_intersect)
{
  collect_symbols();

  // Return attributes of CUDA functions. The code needs the
  // maximum number of threads.
  cudaError_t e1 = cudaFuncGetAttributes(attr_platform,pass_platform);
  if ( e1 ) return e1;
  cudaError_t e2 = cudaFuncGetAttributes(attr_pairs,pass_pairs);
  if ( e2 ) return e2;
  cudaError_t e3 = cudaFuncGetAttributes(attr_xx_intersect,pass_xx_intersect);
  return e3;
}

__host__ void
pass_platform_launch
(dim3 dg, dim3 db, int ball_count)
{
  const int block_lg = 32 - __builtin_clz(db.x-1);
  const int shared_amt = sizeof(float) << block_lg;
  pass_platform<<<dg,db,shared_amt>>>(ball_count);
}

__global__ void
pass_platform(int ball_count)
{
  /// Main CUDA routine for resolving collisions with platform and
  /// updating ball position and orientation.

  // One ball per thread.

  const int idx_base = blockIdx.x * blockDim.x;
  const int idx = idx_base + threadIdx.x;

  if ( idx >= ball_count ) return;

  CUDA_Phys_W phys;

  /// Copy ball data from memory to local variables.
  //
  //  Local variables hopefully will be in GPU registers, not
  //  slow local memory.
  //
  int4 tact_counts = balls_x.tact_counts[idx];
  phys.pt_type = tact_counts.x;
  phys.contact_count = tact_counts.y;
  phys.part_of_wheel = tact_counts.w & 1;

  if ( phys.pt_type == PT_Ball )     pass_platform_ball(phys, idx);
  else if ( phys.pt_type == PT_Box ) pass_platform_box(phys, idx);
  else                               pass_platform_tile(phys, idx);

  /// Copy other updated data to memory.
  //
  tact_counts.y = phys.contact_count << 8;
  tact_counts.z = tact_counts.z << 16;
  balls_x.tact_counts[idx] = tact_counts;
}

__device__ void
pass_platform_ball(CUDA_Phys_W& phys, int idx)
{
  // One ball per thread.

  CUDA_Ball_W& ball = phys.ball;

  /// Copy ball data from memory to local variables.
  //
  //  Local variables hopefully will be in GPU registers, not
  //  slow local memory.
  //

  ball.prev_velocity = xyz(balls_x.prev_velocity[idx]);
  ball.velocity = xyz(balls_x.velocity[idx]) + gravity_accel_dt;
  set_f3(ball.position,balls_x.position[idx]);
  set_f3(ball.omega, balls_x.omega[idx]);
  float4 ball_props = balls_x.ball_props[idx];
  ball.radius = ball_props.x;
  ball.mass_inv = ball_props.y;

  /// Handle Ball/Platform Collision
  //
  platform_collision(phys);

  /// Update Position and Orientation
  //
  ball.position +=
    0.5f * delta_t * ( ball.prev_velocity + ball.velocity );

  pNorm axis = mn(ball.omega);
  balls_x.orientation[idx] =
    quat_normalize
    ( quat_mult
      ( mq( axis, delta_t * axis.magnitude ), balls_x.orientation[idx] ));

  /// Copy other updated data to memory.
  //
  set_f4(balls_x.velocity[idx], ball.velocity);
  set_f4(balls_x.prev_velocity[idx], ball.velocity);
  set_f4(balls_x.omega[idx], ball.omega);
  set_f4(balls_x.position[idx], ball.position, ball.radius);
}


__device__ void
pass_platform_tile(CUDA_Phys_W& phys, int idx)
{
  if ( !phys.part_of_wheel ) return;

  const int tid = threadIdx.x;
  float4 tile_props = balls_x.velocity[idx];
  float torque = tile_props.z;
  block_torque_dt[tid] = torque;
  tile_props.z = 0;
  balls_x.velocity[idx] = tile_props;

  float omega = wheel.omega[0];

  const float3 pt_ll = xyz(balls_x.position[idx]);
  const float3 norm_rt = xyz(balls_x.omega[idx]);
  const float3 norm_up = xyz(balls_x.prev_velocity[idx]);
  const float3 normal = xyz(balls_x.ball_props[idx]);

  float torque_sum = 0;
  // Assuming that all are on same warp. :-)
  for ( int i=wheel.idx_start; i<wheel.idx_stop; i++ )
    torque_sum += block_torque_dt[i];

  omega -= torque_sum * wheel.moment_of_inertia_inv;

  const float friction_delta_omega = 
    wheel.friction_torque * wheel.moment_of_inertia_inv * delta_t;
  if ( fabs(omega) <= friction_delta_omega ) omega = 0;
  else if ( omega > 0 )                      omega -= friction_delta_omega;
  else                                       omega += friction_delta_omega;

  const float delta_theta = omega * delta_t;

  pMatrix3x3 rot;
  pMatrix_set_rotation(rot,wheel.axis_dir,delta_theta);
  const float3 rpt_ll = wheel.center + rot * ( pt_ll - wheel.center );
  const float3 rnorm_rt = rot * norm_rt;
  const float3 rnorm_up = rot * norm_up;
  const float3 rnormal = rot * normal;

  set_f4(balls_x.position[idx],rpt_ll);
  set_f4(balls_x.omega[idx], rnorm_rt);
  set_f4(balls_x.prev_velocity[idx], rnorm_up);
  set_f4(balls_x.ball_props[idx], rnormal);
  if ( idx == wheel.idx_start ) wheel.omega[0] = omega;
}

__device__ void
pass_platform_box(CUDA_Phys_W& phys, int idx)
{
  // One box per thread.

  CUDA_Box_W& box = phys.box;

  /// Copy data from memory to local variables.
  //
  //  Local variables hopefully will be in GPU registers, not
  //  slow local memory.
  //

  float4 box_props = balls_x.ball_props[idx];
  box.mass_inv = box_props.y;
  if ( box.mass_inv == 0 ) return; // Read only.
  box.prev_velocity = xyz(balls_x.prev_velocity[idx]);
  box.velocity = xyz(balls_x.velocity[idx]) + gravity_accel_dt;
  set_f3(box.position,balls_x.position[idx]);
  set_f3(box.omega, balls_x.omega[idx]);
  set_f3(box.to_111, balls_x.to_111[idx]);
  box.orientation = balls_x.orientation[idx];

  /// Handle Ball/Platform Collision
  //
  platform_collision_box(phys);

  /// Update Position and Orientation
  //
  box.position +=
    0.5f * delta_t * ( box.prev_velocity + box.velocity );

  pNorm axis = mn(box.omega);
  balls_x.orientation[idx] =
    quat_normalize
    ( quat_mult
      ( mq( axis, delta_t * axis.magnitude ), box.orientation ));

  /// Copy other updated data to memory.
  //
  set_f4(balls_x.velocity[idx], box.velocity);
  set_f4(balls_x.prev_velocity[idx], box.velocity);
  set_f4(balls_x.omega[idx], box.omega);
  set_f4(balls_x.position[idx], box.position, box_props.x);
}

__device__ void
platform_collision_box(CUDA_Phys_W& phys)
{
  CUDA_Box_W& box = phys.box;

  float radius = length(box.to_111);

  if ( box.position.y - radius >= 0 ) return;
  if ( box.position.z + radius <= platform_zmin ) return;
  if ( box.position.z - radius >= platform_zmax ) return;

  float3 axis = mv(platform_xmid,0,box.position.z);
  pVect btoa = mv(box.position,axis);
  if ( dot(btoa,btoa) < (platform_xrad-radius)*(platform_xrad-radius) ) return;

  box_geometry_update(box);

  int inside = 0;
  int outside_under = 0;
  float pen_dists[8];
  CUDA_SectTT psects[5];
  int ps_next = 0;
  float min_pd = 0;  // For vertices between ends.
  float max_pd = 0;

  // Find vertices that are under the platform.
  //
  for ( int v=0; v<8; v++ )
    {
      int v_bit = 1 << v;
      float3 pos = box_get_vertices(box,v);
      if ( pos.y > 0 ) { pen_dists[v] = 0; continue; }
      float3 axis = mc(platform_xmid,0,pos.z);
      pNorm tact_dir = mn(axis,pos);
      float pen_dist = tact_dir.magnitude - platform_xrad;
      pen_dists[v] = pen_dist;
      if ( pos.z < platform_zmin || pos.z > platform_zmax )
        {
          if ( pen_dist > 0 ) outside_under |= v_bit;
          continue;
        }
      set_min(min_pd,pen_dist);
      set_max(max_pd,pen_dist);
      if ( pen_dist > 1 ) continue;
      inside |= v_bit;
      if ( pen_dist <= 0 ) continue;
      CUDA_SectTT* sect = &psects[ps_next++];
      sect->start = pos;
      sect->dir = tact_dir.v;
      sect->pen_dist = pen_dist;
    }

  bool object_inside = max_pd < -min_pd;
  if ( !object_inside ) return;

  // Examine vertices that are off the edge of the platform (in the
  // z direction), to see if an adjoining edge intersects the platform
  // edge.
  //
  for ( int v=0; v<8; v++ )
    {
      int v_bit = 1 << v;
      if ( ! ( v_bit & outside_under )  ) continue;

      // Outside Vertex (beyond z_max or z_min).
      //
      pCoor pos = box_get_vertices(box,v);
      float pen_dist_out = pen_dists[v];
      float v_z = pos.z;
      float ref_z =
        v_z >= platform_zmax ? platform_zmax : platform_zmin;
      float outside_z_len = fabs(v_z - ref_z);

      // Look for adjoining vertices that are over the platform.
      //
      for ( int axis = 0; axis < 3; axis++ )
        {
          int vn = v ^ ( 1 << axis );
          int vn_bit = 1 << vn;
          if ( ! ( inside & vn_bit ) ) continue;
          float pen_len = pen_dists[vn] - pen_dist_out;
          // Inside Vertex
          pCoor pos_in = box_get_vertices(box,vn);

          // Compute the contact point at penetration distance.
          //
          float z_len = fabs(v_z - pos_in.z);
          if ( z_len < 0.0001f ) continue;
          float scale = outside_z_len / z_len;
          pVect to_inside = mv(pos,pos_in);
          pCoor tact = pos + scale * to_inside;
          float pen_tact = pen_dist_out + scale * pen_len;
          if ( pen_tact <= 0 ) continue;
          CUDA_SectTT* sect = &psects[ps_next++];
          sect->start = tact;
          sect->pen_dist = pen_tact;
          pNorm dir = mn(cross(to_inside,mv(-tact.y,tact.x,0)));
          sect->dir = pen_len >= 0 ? normalize(mv(tact.x,tact.y,0)) : dir.v;
        }
    }

  //  if ( ps_next > 0 ) phys.contact_count++;

  for ( int i=0; i<ps_next; i++ )
    {
      CUDA_SectTT *sect = &psects[i];
      pCoor pos = sect->start;
      pVect tact_dir = sect->dir;
      pNorm ctopos = mn(box.position,pos);
      pVect vel = box_get_vel(box,pos);
      float pen_dist = sect->pen_dist;
      float rad_vel = dot(vel,tact_dir);
      double loss_factor = 1 - opt_bounce_loss;
      float force_dt_no_loss = elasticity_inv_dt * pen_dist;
      float max_fdt_in = rad_vel / box.mass_inv;
      float appr_force_dt = rad_vel > 0
        ? min(max_fdt_in,force_dt_no_loss) : force_dt_no_loss * loss_factor;
      box_apply_force_dt(box,pos, - appr_force_dt * tact_dir );
    }

  for ( int i=0; i<ps_next; i++ )
    {
      CUDA_SectTT *sect = &psects[i];
      pCoor pos = sect->start;
      pVect tact_dir = sect->dir;
      float pen_dist = sect->pen_dist;
      float force_dt_no_loss = elasticity_inv_dt * pen_dist;
      pVect vel2 = box_get_vel(box,pos);
      float rad_vel2 = dot(vel2,tact_dir);
      pNorm tan_vel = mn( vel2 - rad_vel2 * tact_dir );
      float mi_inv = box_get_moment_of_inertia_inv(box,pos,tan_vel);
      float fdt_limit = 
        tan_vel.magnitude / ( box.mass_inv + mi_inv );
      float fric_force_dt_no_loss =
        force_dt_no_loss * opt_friction_coeff;
      float fric_force_dt = min(fdt_limit, fric_force_dt_no_loss);
      box_apply_force_fric_dt(box,pos, tan_vel, -fric_force_dt);
    }
}

__device__ void
platform_collision(CUDA_Phys_W& phys)
{
  /// Check if ball in contact with platform, if so apply forces.

  CUDA_Ball_W& ball = phys.ball;

  pCoor pos = ball.position;
  const float r = ball.radius;
  bool collision_possible =
    pos.y < r
    && pos.x >= platform_xmin - r && pos.x <= platform_xmax + r
    && pos.z >= platform_zmin - r && pos.z <= platform_zmax + r;

  if ( !collision_possible ) return;

  CUDA_Ball_W pball;

  pCoor axis = mc(platform_xmid,0,pos.z);
  const float short_xrad = platform_xrad - r;
  const float short_xrad_sq = short_xrad * short_xrad;
  const float long_xrad = platform_xrad + r;
  const float long_xrad_sq = long_xrad * long_xrad;

  // Test for different ways ball can touch platform. If contact
  // is found find position of an artificial platform ball (pball)
  // that touches the real ball at the same place and angle as
  // the platform. This pball will be used for the ball-ball penetration
  // routine, penetration_balls_resolve.

  if ( pos.y > 0 )
    {
      // Possible contact with upper edge of platform.
      //
      pCoor tact
        = mc(pos.x > platform_xmid ? platform_xmax : platform_xmin, 0, pos.z);
      pNorm tact_dir = mn(pos,tact);
      if ( tact_dir.mag_sq >= r * r ) return;
      pball.position = tact + r * tact_dir;
    }
  else if ( pos.z > platform_zmax || pos.z < platform_zmin )
    {
      // Possible contact with side (curved) edges of platform.
      //
      pNorm ball_dir = mn(axis,pos);
      if ( ball_dir.mag_sq <= short_xrad_sq ) return;
      const float zedge =
        pos.z > platform_zmax ? platform_zmax : platform_zmin;
      pCoor axis_edge = mc(platform_xmid,0,zedge);
      pCoor tact = axis_edge + platform_xrad * ball_dir;
      pNorm tact_dir = mn(pos,tact);
      if ( tact_dir.mag_sq >= r * r ) return;
      pball.position = tact + r * tact_dir;
    }
  else
    {
      // Possible contact with surface of platform.
      //
      pNorm tact_dir = mn(axis,pos);
      if ( tact_dir.mag_sq <= short_xrad_sq
           || tact_dir.mag_sq >= long_xrad_sq ) return;
      
      pball.position = axis +
        ( platform_xrad + ( tact_dir.magnitude < platform_xrad ? r : -r ) )
        * tact_dir;
    }

  // Finish initializing platform ball, and call routine to
  // resolve penetration.
  //
  pVect zero_vec = mv(0,0,0);
  pball.omega = zero_vec;
  pball.prev_velocity = pball.velocity = zero_vec;
  pball.radius = ball.radius;
  pball.mass_inv = ball.mass_inv;
  if ( penetration_balls_resolve(phys.ball,pball,false,FT_All) )
    phys.contact_count++;
}

 /// Compute Phys Proximity Pairs

// Mapping from z-sort index to ball array index.
__constant__ int *z_sort_indices;

// Pre-computed z_max values.
__constant__ float *z_sort_z_max;

// Computed proximity values, sent to CPU.
__constant__ int64_t *cuda_prox;

// An array that can be used to pass values back to the CPU for
// use in debugging.
__constant__ float3 *pass_sched_debug;

texture<float4> balls_pos_tex;
texture<float4> balls_vel_tex;

__global__ void pass_sched(int ball_count, float lifetime_delta_t);
__device__ float ball_min_z_get
(float3 position, float3 velocity, float radius, float lifetime_delta_t);

__host__ bool
pass_sched_launch
(dim3 dg, dim3 db, int ball_count, float lifetime_delta_t,
 void *pos_array_dev, void *vel_array_dev)
{
  size_t offset;
  const size_t size = ball_count * sizeof(float4);
  const cudaChannelFormatDesc fd =
    cudaCreateChannelDesc(32,32,32,32,cudaChannelFormatKindFloat);
  cudaBindTexture(&offset, balls_pos_tex, pos_array_dev, fd, size);
  if ( offset ) return false;
  cudaBindTexture(&offset, balls_vel_tex, vel_array_dev, fd, size);
  if ( offset ) return false;

  pass_sched<<<dg,db>>>(ball_count,lifetime_delta_t);

  return true;
}

__global__ void
pass_sched(int ball_count, float lifetime_delta_t)
{
  // Determine which balls that are in proximity to a ball. This
  // routine only works for balls, if a tile is found an I-give-up
  // value is returned, and the CPU will have to determine proximity.

  const int idx_base = blockIdx.x * blockDim.x;

  // idx9 is an index into z-sorted arrays.
  const int idx9 = idx_base + threadIdx.x;

  if ( idx9 >= ball_count ) return;

  // bidx9 is an index into the balls arrays.
  const int bidx9 = z_sort_indices[idx9];

  // If bidx9 is negative then Phys at index bidx9 is not a ball,
  // so just return a give-up code 't' (tile).
  if ( bidx9 < 0 )
    {
      cuda_prox[idx9] = ( 't' << 8 ) | 0xff;
      return;
    }

  // Fetch position, radius (packed in position vector), and velocity.
  //
  const float4 pos_rad9 = tex1Dfetch(balls_pos_tex,bidx9);
  const float3 pos9 = xyz(pos_rad9);
  const float radius9 = pos_rad9.w;
  const float4 vel9_pad = tex1Dfetch(balls_vel_tex,bidx9);
  const float3 vel9 = xyz(vel9_pad);

  const float z_min = ball_min_z_get(pos9,vel9,radius9,lifetime_delta_t);

  // Number of nearby balls.
  int proximity_cnt = 0;

  // Reason for giving up, 0 means we didn't give up (yet).
  char incomplete = 0;

  // The list of balls in proximity, packed into a single integer.
  Prox_Offsets offsets = 0;

  for ( int idx1 = idx9-1; !incomplete && idx1 >= 0; idx1-- )
    {
      const float z_max = z_sort_z_max[idx1];

      // Break if this and subsequent z-ordered balls could not
      // possibly be in proximity.
      if ( z_max < z_min ) break;

      const int bidx1 = z_sort_indices[idx1];

      // If there's a tile here give up.
      // (t is for tile)
      if ( bidx1 < 0 ) { incomplete = 't'; continue; }

      const float4 pos_rad = tex1Dfetch(balls_pos_tex,bidx1);
      const float3 pos1 = xyz(pos_rad);
      const float4 vel_pad1 = tex1Dfetch(balls_vel_tex,bidx1);
      const float3 vel1 = xyz(vel_pad1);
      const float radius1 = pos_rad.w;

      // Use the pNorm constructor to compute the distance between two balls.
      pNorm dist = mn(pos1,pos9);

      // Balls are considered in proximity if they can be
      // this close over schedule lifetime.
      const float region_length_small = 1.11f * ( radius9 + radius1 );
      
      // Check if balls will be close enough over lifetime.
      pVect delta_v = vel9 - vel1;
      const float delta_d = lifetime_delta_t * length(delta_v);
      const float dist2 = dist.magnitude - delta_d;

      if ( dist2 > region_length_small ) continue; 

      // At this point the balls are considered in proximity, now
      // squeeze the value of bidx1 into eight bits by taking
      // the difference of z-sort indices, which should be close
      // together.
      const int offset = idx9 - idx1;

      // Ooops, exceeded the limit on the number of proximities.
      // (f is for full)
      if ( proximity_cnt >= cuda_prox_per_ball ) incomplete = 'f';

      // Ooops, the offset won't fit into 8 bits.
      // (o is for overflow)
      else if ( offset >= 255 )                  incomplete = 'o';

      // Everything is fine, slide the offset on to the list.
      else offsets = ( offsets << 8 ) | offset;

      proximity_cnt++;
    }

  // If code could not compute all proximities replace offsets with
  // the error code.
  if ( incomplete ) offsets = ( incomplete << 8 ) | 0xff;

  cuda_prox[idx9] = offsets;
}

__device__ float
ball_min_z_get
(float3 position, float3 velocity, float radius, float lifetime_delta_t)
{
  const float m = fabs(velocity.x) + fabs(velocity.y) + fabs(velocity.z);
  const float z_min = position.z + position.x - m * lifetime_delta_t
    - 2 * radius;
  return z_min;
}

static __host__ void collect_symbols()
{
  CU_SYM(balls_x);
  CU_SYM(block_balls_needed);
  CU_SYM(tacts_schedule);
  CU_SYM(xx_pairs);
  CU_SYM(xx_sects_center);
  CU_SYM(xx_sects_dir);
  CU_SYM(xx_sects_debug);
  CU_SYM(gravity_accel_dt);
  CU_SYM(opt_bounce_loss); CU_SYM(opt_bounce_loss_box);
  CU_SYM(opt_friction_coeff); CU_SYM(opt_friction_roll);
  CU_SYM(platform_xmin); CU_SYM(platform_xmax);
  CU_SYM(platform_zmin); CU_SYM(platform_zmax);
  CU_SYM(platform_xmid); CU_SYM(platform_xrad);
  CU_SYM(delta_t);
  CU_SYM(elasticity_inv_dt);
  CU_SYM(opt_debug); CU_SYM(opt_debug2);
  CU_SYM(wheel);
  CU_SYM(z_sort_indices);
  CU_SYM(z_sort_z_max);
  CU_SYM(cuda_prox);
  CU_SYM(pass_sched_debug);
}

