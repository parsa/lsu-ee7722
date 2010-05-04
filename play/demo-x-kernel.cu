/// LSU EE X70X-X (Sp 2010), GPU Microarchitecture
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   This file contains GPU/cuda code.
//   See demo-x-collide.cc for main program.

#include "demo-x.cuh"


// Emulation Code
//
// The code below is only included when the kernel is compiled to
// run on the CPU, for debugging.
//
#ifdef __DEVICE_EMULATION__
#include <stdio.h>
#define ASSERTS(expr) { if ( !(expr) ) abort();}
#endif

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
extern __shared__ CUDA_Phys_W sm_balls[];

 /// Pairs of Balls to Check
//
__constant__ SM_Idx2 *tacts_schedule;


__constant__ float3 gravity_accel_dt;
__constant__ float opt_bounce_loss;
__constant__ float opt_friction_coeff, opt_friction_roll;
__constant__ float platform_xmin, platform_xmax;
__constant__ float platform_zmin, platform_zmax;
__constant__ float platform_xmid, platform_xrad;
__constant__ float delta_t;
__constant__ float elasticity_inv_dt;
__constant__ bool opt_debug, opt_debug2;

__constant__ CUDA_Wheel wheel;
extern __shared__ float block_torque_dt[];


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

// Make float4
__device__ float4 m4(pQuat q){ return make_float4(q.v.x,q.v.y,q.v.z,q.w); }
__device__ float4 m4(pNorm v, float w) { return m4(v.v,w); }


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


struct pMatrix3x3 { float3 r0, r1, r2; };

__device__ void
pMatrix_set_rotation(pMatrix3x3& m, pVect u, float theta)
{
  const float cos_theta = __cosf(theta);
  const float sin_theta = __sinf(theta);
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
/// Collision (Penetration) Detection and Resolution Routine
///

// Used in both passes.


__device__ bool
penetration_balls_resolve
(CUDA_Ball_W& ball1, CUDA_Ball_W& ball2, bool b2_real)
{
  /// Update velocity and angular momentum for a pair of balls in contact.

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

///
/// Pairs Pass
///
//
// Resolve ball collisions with each other.

__global__ void pass_pairs
(int prefetch_offset, int schedule_offset, int round_cnt, 
 int max_balls_per_thread, int balls_per_block);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt,
 int max_balls_per_thread, int balls_per_block)
{
  const int shared_amt = balls_per_block * sizeof(CUDA_Phys_W);
  pass_pairs<<<dg,db,shared_amt>>>
    (prefetch_offset, schedule_offset, round_cnt,
     max_balls_per_thread, balls_per_block);
}

__device__ void
pass_pairs(int prefetch_offset, int schedule_offset, int round_cnt,
           int max_balls_per_thread, int balls_per_block)
{
  const int tid = threadIdx.x;

  // Initialized variables used to access balls_needed and tacts_schedule
  // arrays.
  //
  const int si_block_size = blockIdx.x * max_balls_per_thread * blockDim.x;
  const int si_block_base = prefetch_offset + si_block_size + tid;
  const int sp_block_size = blockIdx.x * round_cnt * blockDim.x;
  const int sp_block_base = schedule_offset + sp_block_size + tid;

  /// Prefetch balls to shared memory.
  //
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= balls_per_block ) continue;
      const int m_idx = block_balls_needed[ si_block_base + i * blockDim.x ];
      CUDA_Phys_W& phys = sm_balls[idx];
      CUDA_Ball_W& ball = phys.ball;
      phys.m_idx = m_idx;
      if ( m_idx < 0 ) continue;

      int4 tact_counts = balls_x.tact_counts[m_idx];
      phys.pt_type = tact_counts.x;
      phys.contact_count = tact_counts.y;
      phys.debug_pair_calls = tact_counts.z;
      phys.part_of_wheel = tact_counts.w;

      ball.velocity = xyz(balls_x.velocity[m_idx]);
      ball.prev_velocity = xyz(balls_x.prev_velocity[m_idx]);
      ball.position = xyz(balls_x.position[m_idx]);
      ball.omega = xyz(balls_x.omega[m_idx]);
      float4 ball_props = balls_x.ball_props[m_idx];
      ball.radius = ball_props.x;
      ball.mass_inv = ball_props.y;
      ball.pad = ball_props.z;
    }

  const pVect zero_vec = mv(0,0,0);

  /// Resolve Collisions
  //
  for ( int round=0; round<round_cnt; round++ )
    {
      SM_Idx2 indices = tacts_schedule[ sp_block_base + round * blockDim.x ];

      // Wait for all threads to reach this point (to avoid having
      // two threads operate on the same ball simultaneously).
      //
      __syncthreads();

      if ( indices.x == indices.y ) continue;

      CUDA_Phys_W& physx = sm_balls[indices.x];
      CUDA_Phys_W& physy = sm_balls[indices.y];
      CUDA_Ball_W& bally = sm_balls[indices.y].ball;

      sm_balls[indices.x].debug_pair_calls++;
      sm_balls[indices.y].debug_pair_calls++;

      if ( physx.pt_type == PT_Ball )
        {
          CUDA_Ball_W& ballx = sm_balls[indices.x].ball;
          int rv = penetration_balls_resolve(ballx,bally,true);
          physx.contact_count += rv;
          physy.contact_count += rv;
        }
      else
        {
          CUDA_Tile_W& tilex = sm_balls[indices.x].tile;
          pCoor tact_pos;
          pVect tact_dir;
          if ( !tile_ball_collide(tilex, bally, tact_pos, tact_dir) ) continue;
          CUDA_Ball_W pball;
          pball.radius = 1;
          pball.omega = pball.prev_velocity = pball.velocity = zero_vec;
          pball.position = tact_pos + tact_dir;
          pVect vbefore = physy.ball.velocity;
          penetration_balls_resolve(bally, pball, false);
          physy.contact_count++;
          pVect delta_mo = ( 1.0f / bally.mass_inv )
            * ( bally.velocity - vbefore );
          if ( !physx.part_of_wheel ) continue;
          wheel_collect_tile_force(tilex, tact_pos, delta_mo);
        }
    }

  __syncthreads();

  /// Copy Ball Data to Memory
  //
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= balls_per_block ) continue;
      CUDA_Phys_W& phys = sm_balls[idx];
      CUDA_Ball_W& ball = phys.ball;
      const int m_idx = phys.m_idx;
      if ( m_idx < 0 ) continue;

      int4 tact_counts;
      tact_counts.x = phys.pt_type;
      tact_counts.y = phys.contact_count;
      tact_counts.z = phys.debug_pair_calls;
      tact_counts.w = phys.part_of_wheel;
      balls_x.tact_counts[m_idx] = tact_counts;

      set_f4(balls_x.velocity[m_idx], ball.velocity);

      if ( phys.pt_type != PT_Ball ) continue;

      set_f4(balls_x.omega[m_idx], ball.omega);
    }
}


///
/// Platform Pass
///
//
// Resolve ball collisions with platform, also update ball position
// and orientation.

__device__ void platform_collision(CUDA_Phys_W& phys);
__global__ void pass_platform(int ball_count);
__device__ void pass_platform_ball(CUDA_Phys_W& phys, int idx);
__device__ void pass_platform_tile(CUDA_Phys_W& phys, int idx);


__host__ cudaError_t
cuda_get_attr_plat_pairs
(struct cudaFuncAttributes *attr_platform,
 struct cudaFuncAttributes *attr_pairs)
{
  // Return attributes of CUDA functions. The code needs the
  // maximum number of threads.
  cudaError_t e1 = cudaFuncGetAttributes(attr_platform,pass_platform);
  if ( e1 ) return e1;
  cudaError_t e2 = cudaFuncGetAttributes(attr_pairs,pass_pairs);
  return e2;
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
  phys.part_of_wheel = tact_counts.w;

  if ( phys.pt_type == PT_Ball ) pass_platform_ball(phys, idx);
  else                           pass_platform_tile(phys, idx);

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
  ball.position += delta_t * ball.velocity;
  pNorm axis = mn(ball.omega);
  balls_x.orientation[idx] =
    quat_mult( mq( axis, delta_t * axis.magnitude ), balls_x.orientation[idx] );

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
      if ( tact_dir.mag_sq <= short_xrad_sq ) return;
      pball.position = axis + (r+platform_xrad) * tact_dir;
    }

  // Finish initializing platform ball, and call routine to
  // resolve penetration.
  //
  pVect zero_vec = mv(0,0,0);
  pball.omega = zero_vec;
  pball.prev_velocity = pball.velocity = zero_vec;
  pball.radius = ball.radius;
  pball.mass_inv = ball.mass_inv;
  if ( penetration_balls_resolve(phys.ball,pball,false) )
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

__host__ void
pass_sched_launch
(dim3 dg, dim3 db, int ball_count, float lifetime_delta_t,
 void *pos_array_dev, void *vel_array_dev)
{
  size_t offset;
  const size_t size = ball_count * sizeof(float4);
  const cudaChannelFormatDesc fd =
    cudaCreateChannelDesc(32,32,32,32,cudaChannelFormatKindFloat);
  cudaBindTexture(&offset, balls_pos_tex, pos_array_dev, fd, size);
  cudaBindTexture(&offset, balls_vel_tex, vel_array_dev, fd, size);

  pass_sched<<<dg,db>>>(ball_count,lifetime_delta_t);
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
      const float region_length_small = 1.1f * ( radius9 + radius1 );
      
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
  const float z_min = position.z - m * lifetime_delta_t - radius;
  return z_min;
}

