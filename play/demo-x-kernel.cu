/// LSU EE 4702-1 (Fall 2009), GPU Programming
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

 /// Pairs of Balls to Check
//
__constant__ SM_Idx2 *tacts_schedule;


__constant__ float3 gravity_accel_dt;
__constant__ float opt_ball_radius, opt_bounce_loss;
__constant__ float opt_friction_coeff, opt_friction_roll;
__constant__ float platform_xmin, platform_xmax;
__constant__ float platform_zmin, platform_zmax;
__constant__ float platform_xmin_mr, platform_xmax_pr;
__constant__ float platform_zmin_mr, platform_zmax_pr;
__constant__ float platform_xmid, platform_xrad;
__constant__ float delta_t;
__constant__ float short_xrad_sq;
__constant__ float r_inv, two_r, two_r_sq;
__constant__ float elasticity_inv_dt, ball_mass_inv;
__constant__ float mo_vel_factor, v_to_do;


///
/// Usefull Functions and Types
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
{a.x = b.x; a.y = b.y; a.z = b.z; a.w = 1.0;}

// Make a Vector
__device__ pVect
mv(float x, float y, float z){ return make_float3(x,y,z); }

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
      n.v = (1.0/n.magnitude) * v;
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
  return m4( sin(angle/2) * axis, cos(angle/2) );
}

// Make float4
__device__ float4 m4(pQuat q){ return make_float4(q.v.x,q.v.y,q.v.z,q.w); }
__device__ float4 m4(pNorm v, float w) { return m4(v.v,w); }


__device__ int
div_p2_ceil(int num, int den_lg)
{
  const int quot = num >> den_lg;
  return quot << den_lg == num ? quot : quot + 1;
}

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


//
 /// Ball Physics Functions
//
// See demo-x-collide.cc for details.

__device__ pVect
point_rot_vel(CUDA_Ball_W ball, pNorm direction)
{
  return opt_ball_radius * cross( ball.angular_momentum, direction );
}

__device__ void
apply_tan_do(CUDA_Ball_W& ball, pNorm tact_dir, pVect force)
{
  pVect axis_torque = cross( tact_dir, force );
  ball.angular_momentum += axis_torque;
}

__device__ void
apply_deltao(CUDA_Ball_W& ball, pNorm tact_dir, pNorm force_dir, double deltao)
{
  apply_tan_do(ball, tact_dir, deltao * force_dir );
}

__device__ void
apply_tan_dv(CUDA_Ball_W& ball, pNorm tact_dir, pVect force)
{
  apply_tan_do(ball, tact_dir, r_inv * force);
}


///
/// Major Ball Physics Routines
///

// A time step is computed using two kernels, pass_pairs and
// pass_platform. The pass_pairs kernel, which might be launched
// several times, handles collisions between balls.  The pass_platform
// kernel handles collision between balls and the platform, and also
// updates position and orientation.


///
/// Collision (Penetration) Detection and Resolution Routine
///

// Used in both passes.

__device__ void
penetration_balls_resolve
(CUDA_Ball_W& ball1_r, CUDA_Ball_W& ball2_r, bool b2_real)
{
  /// Update velocity and angular momentum for a pair of balls in contact.

  CUDA_Ball_W *ball1 = &ball1_r;
  CUDA_Ball_W *ball2 = &ball2_r;
  pVect zero_vec = mv(0,0,0);
  pNorm dist = mn(ball1->position,ball2->position);

  // For Debugging
  //
  if ( b2_real ) { ball1->debug_pair_calls++;  ball2->debug_pair_calls++; }

  // Return if balls aren't touching.  Note avoidance of square root.
  //
  if ( dist.mag_sq >= two_r_sq ) return;

  // Update counters used for optimization (contact_count) and
  // to decide when to release new balls (collision_count).
  //
  ball1->collision_count++;  ball1->contact_count++;
  if ( b2_real ) { ball2->collision_count++; ball2->contact_count++; }


  /// WARNING:  This doesn't work: somefunc(-dist); 
  pNorm ndist = -dist;

  // Compute relative (approach) velocity.
  //
  pVect prev_appr_vel = ball1->prev_velocity - ball2->prev_velocity;
  const double prev_approach_speed = dot( prev_appr_vel, dist );

  const double loss_factor = 1 - opt_bounce_loss;

  // Compute change in speed based on how close balls touching, ignoring
  // energy loss.
  //
  const double appr_deltas_no_loss =
    ( two_r - dist.magnitude ) * elasticity_inv_dt * ball_mass_inv;

  // Change in speed accounting for energy loss. Only applied when
  // balls separating.
  //
  const double appr_deltas =
    prev_approach_speed > 0
    ? appr_deltas_no_loss : loss_factor * appr_deltas_no_loss;

  /// Update Linear Velocity
  //
  ball1->velocity -= appr_deltas * dist;
  if ( b2_real ) ball2->velocity += appr_deltas * dist;

  // Find speed on surface of balls at point of contact.
  //
  pVect tact1_rot_vel = point_rot_vel(ball1_r,dist);
  pVect tact2_rot_vel = point_rot_vel(ball2_r,ndist);

  // Find relative velocity of surfaces at point of contact
  // in the plane formed by their surfaces.
  //
  pVect tan_vel = prev_appr_vel - prev_approach_speed * dist;
  pNorm tact_vel_dir = mn(tact1_rot_vel - tact2_rot_vel + tan_vel);

  // Find change in velocity due to friction.
  //
  const double fric_dv_potential =
    fabs(appr_deltas_no_loss) * opt_friction_coeff;
  const double dv_limit_raw = tact_vel_dir.magnitude * mo_vel_factor;
  const double dv_limit = b2_real ? dv_limit_raw : 2 * dv_limit_raw;

  // If true, surfaces are not sliding or will stop sliding after
  // frictional forces applied. (If a ball surface isn't sliding
  // against another surface than it must be rolling.)
  //
  const bool will_roll = dv_limit <= fric_dv_potential;
  const double sliding_fric_deltav =
    will_roll ? dv_limit : fric_dv_potential;

  const double dv_tolerance = 0.000001;

  if ( sliding_fric_deltav > dv_tolerance )
    {
      // Apply frictional force.

      // Compute change in angular momentum due to friction.
      //
      const double fric_deltao = sliding_fric_deltav * v_to_do;

      // Apply torque (resulting in angular momentum change) and
      // linear force (resulting in velocity change).
      //
      apply_deltao(ball1_r,dist,tact_vel_dir,-fric_deltao);
      ball1->velocity -= sliding_fric_deltav * tact_vel_dir;

      // Ditto for the other ball, if it's real.
      if ( b2_real )
        {
          apply_deltao(ball2_r,dist,tact_vel_dir,-fric_deltao);
          ball2->velocity += sliding_fric_deltav * tact_vel_dir;
        }
    }

  {
    /// Torque
    //
    //
    // Account for forces of surfaces twisting against each
    // other. (For example, if one ball is spinning on top of
    // another.)
    //
    const double appr_omega =
      dot(ball1->angular_momentum,dist) - dot(ball2->angular_momentum,dist);
    const double fric_deltao_pot = fric_dv_potential * v_to_do;
    const bool rev = appr_omega < 0;
    const double fric_deltao = min(fabs(appr_omega),fric_deltao_pot);
    pVect delta_am = rev ? -fric_deltao * dist : fric_deltao * dist;
    ball1->angular_momentum -= delta_am;
    if ( b2_real ) ball2->angular_momentum += delta_am;
  }

  {
    /// Rolling Friction
    //
    // The rolling friction model used here is ad-hoc.

    pVect tan_b12_vel = b2_real ? 0.5 * tan_vel : zero_vec;
    const double torque_limit_sort_of = appr_deltas_no_loss
      * sqrt( opt_ball_radius - 0.25 * dist.mag_sq * r_inv );

    pVect tact1_rot_vel = point_rot_vel(ball1_r,dist);
    pVect tact1_roll_vel = tact1_rot_vel + tan_b12_vel;
    pNorm tact1_roll_vel_dir = mn(tact1_roll_vel);
    pVect lost_vel = zero_vec;

    const double rfric_loss1 =
      torque_limit_sort_of *
      ( tact1_roll_vel_dir.magnitude * opt_friction_roll /
        ( 1 + tact1_roll_vel_dir.magnitude * opt_friction_roll ) );
    
    pVect lost_vel1 =
      min(tact1_roll_vel_dir.magnitude, rfric_loss1) * tact1_roll_vel_dir;

    lost_vel = -lost_vel1;
    
    if ( b2_real )
      {
        pVect tact2_rot_vel = point_rot_vel(ball2_r,ndist);
        pVect tact2_roll_vel = tact2_rot_vel - tan_b12_vel;
        pNorm tact2_roll_vel_dir = mn(tact2_roll_vel);
        const double rfric_loss2 =
          torque_limit_sort_of *
          ( tact2_roll_vel_dir.magnitude * opt_friction_roll /
            ( 1 + tact2_roll_vel_dir.magnitude * opt_friction_roll ) );
        pVect lost_vel2 =
          min(tact2_roll_vel_dir.magnitude, rfric_loss2 ) * tact2_roll_vel_dir;

        lost_vel += lost_vel2;
      }

    apply_tan_dv(ball1_r,dist,lost_vel);
    if ( b2_real ) apply_tan_dv(ball2_r,dist,lost_vel);
  }
}

///
/// Pairs Pass
///
//
// Resolve ball collisions with each other.

__global__ void pass_pairs
(int prefetch_offset, int schedule_offset, int round_cnt);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int prefetch_offset, int schedule_offset, int round_cnt)
{
  pass_pairs<<<dg,db>>>(prefetch_offset,schedule_offset,round_cnt);
}

__device__ void
pass_pairs(int prefetch_offset, int schedule_offset, int round_cnt)
{
  const int tid = threadIdx.x;
  const int max_balls_per_thread =
    int( ceil( float(BALLS_PER_BLOCK) / blockDim.x ) );

  // Initialized variables used to access balls_needed and tacts_schedule
  // arrays.
  //
  const int si_block_size = blockIdx.x * max_balls_per_thread * blockDim.x;
  const int si_block_base = prefetch_offset + si_block_size + tid;
  const int sp_block_size = blockIdx.x * round_cnt * blockDim.x;
  const int sp_block_base = schedule_offset + sp_block_size + tid;

  /// Shared memory array holding balls updated by this block.
  //
  __shared__ CUDA_Ball_W sm_balls[BALLS_PER_BLOCK];

  /// Prefetch balls to shared memory.
  //
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= BALLS_PER_BLOCK ) continue;
      const int m_idx = block_balls_needed[ si_block_base + i * blockDim.x ];
      CUDA_Ball_W& ball = sm_balls[idx];
      ball.m_idx = m_idx;
      if ( m_idx < 0 ) continue;
      ball.velocity = xyz(balls_x.velocity[m_idx]);
      ball.prev_velocity = xyz(balls_x.prev_velocity[m_idx]);
      ball.position = xyz(balls_x.position[m_idx]);
      ball.angular_momentum = xyz(balls_x.angular_momentum[m_idx]);

      int4 tact_counts = balls_x.tact_counts[m_idx];
      ball.collision_count = tact_counts.x;
      ball.contact_count = tact_counts.y;
      ball.debug_pair_calls = tact_counts.z;
    }

  __syncthreads();

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
      penetration_balls_resolve(sm_balls[indices.x],sm_balls[indices.y],true);
    }

  __syncthreads();

  /// Copy Ball Data to Memory
  //
  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= BALLS_PER_BLOCK ) continue;
      CUDA_Ball_W& ball = sm_balls[idx];
      const int m_idx = ball.m_idx;
      if ( m_idx < 0 ) continue;

      set_f4(balls_x.velocity[m_idx], ball.velocity);
      set_f4(balls_x.angular_momentum[m_idx], ball.angular_momentum);

      int4 tact_counts;
      tact_counts.x = ball.collision_count;
      tact_counts.y = ball.contact_count;
      tact_counts.z = ball.debug_pair_calls;
      balls_x.tact_counts[m_idx] = tact_counts;
    }
}


///
/// Platform Pass
///
//
// Resolve ball collisions with platform, also update ball position
// and orientation.

__device__ void platform_collision(CUDA_Ball_W& ball);
__global__ void pass_platform(int ball_count);

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
  pass_platform<<<dg,db>>>(ball_count);
}

__global__ void
pass_platform(int ball_count)
{
  /// Main CUDA routine for resolving collisions with platform and
  /// updating ball position and orientation.

  // One ball per thread.

  const int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if ( idx >= ball_count ) return;

  CUDA_Ball_W ball;

  /// Copy ball data from memory to local variables.
  //
  //  Local variables hopefully will be in GPU registers, not
  //  slow local memory.
  //
  ball.prev_velocity = xyz(balls_x.prev_velocity[idx]);
  ball.velocity = xyz(balls_x.velocity[idx]) + gravity_accel_dt;
  set_f3(ball.position,balls_x.position[idx]);
  set_f3(ball.angular_momentum, balls_x.angular_momentum[idx]);
  int4 tact_counts = balls_x.tact_counts[idx];
  ball.collision_count = tact_counts.x;
  ball.contact_count = tact_counts.y;

  /// Handle Ball/Platform Collision
  //
  platform_collision(ball);

  /// Update Position and Orientation
  //
  ball.position += delta_t * ball.velocity;
  pNorm axis = mn(ball.angular_momentum);
  balls_x.orientation[idx] =
    quat_mult( balls_x.orientation[idx],
               mq( axis, delta_t * axis.magnitude ) );

  /// Copy other updated data to memory.
  //
  set_f4(balls_x.velocity[idx], ball.velocity);
  set_f4(balls_x.prev_velocity[idx], ball.velocity);
  set_f4(balls_x.angular_momentum[idx], ball.angular_momentum);
  set_f4(balls_x.position[idx],ball.position);
  tact_counts.x = ball.collision_count;
  tact_counts.y = ball.contact_count << 8;
  tact_counts.z = tact_counts.z << 16;
  balls_x.tact_counts[idx] = tact_counts;
}

__device__ void
platform_collision(CUDA_Ball_W& ball)
{
  /// Check if ball in contact with platform, if so apply forces.

  pCoor pos = ball.position;
  bool collision_possible =
    pos.y < opt_ball_radius
    && pos.x >= platform_xmin_mr && pos.x <= platform_xmax_pr
    && pos.z >= platform_zmin_mr && pos.z <= platform_zmax_pr;

  if ( !collision_possible ) return;

  CUDA_Ball_W pball;

  pCoor axis = mc(platform_xmid,0,pos.z);

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
      pVect pos_tact = tact - pos;
      float tact_dir_mag_sq = mag_sq(pos_tact);
      if ( tact_dir_mag_sq >= two_r_sq ) return;
      pball.position =
        tact + opt_ball_radius / sqrt(tact_dir_mag_sq) * pos_tact;
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
      if ( tact_dir.mag_sq >= two_r_sq ) return;
      pball.position = tact + opt_ball_radius * tact_dir;
    }
  else
    {
      // Possible contact with surface of platform.
      //
      pNorm tact_dir = mn(axis,pos);
      if ( tact_dir.mag_sq <= short_xrad_sq ) return;
      pball.position = axis + (opt_ball_radius+platform_xrad) * tact_dir;
    }

  // Finish initializing platform ball, and call routine to
  // resolve penetration.
  //
  pVect zero_vec = mv(0,0,0);
  pball.angular_momentum = zero_vec;
  pball.prev_velocity = pball.velocity = zero_vec;
  penetration_balls_resolve(ball,pball,false);
}

