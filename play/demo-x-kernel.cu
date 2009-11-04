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

#ifdef __DEVICE_EMULATION__
#include <stdio.h>
#define ASSERTS(expr) { if ( !(expr) ) abort();}
#endif


__constant__ CUDA_Ball_X balls_x_0, balls_x_1;

__constant__ int *schedule_inputs;
__constant__ SM_Idx2 *schedule;

__constant__ float3 gravity_accel_dt;
__constant__ float opt_ball_radius, opt_bounce_loss;
__constant__ float opt_friction_coeff, opt_friction_roll;
__constant__ bool opt_debug;
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

typedef float3 pCoor;
typedef float3 pVect;

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

__device__ pCoor 
mc(float x, float y, float z){ return make_float3(x,y,z); }

__device__ pCoor mc(float4 c){ return make_float3(c.x,c.y,c.z); }

__device__ void set_f3(float3& a, float4 b){a.x = b.x; a.y = b.y; a.z = b.z;}
__device__ void set_f4(float4& a, float3 b){a.x = b.x; a.y = b.y; a.z = b.z;}

__device__ pVect
mv(float x, float y, float z){ return make_float3(x,y,z); }

__device__ float
dot(pVect a, pVect b){return a.x*b.x + a.y*b.y + a.z*b.z;}

__device__ float dot(pVect a, pNorm b){ return dot(a,b.v); }

__device__ float mag_sq(pVect v){ return dot(v,v); }
__device__ float length(pVect a) {return sqrtf(mag_sq(a));}
__device__ pVect normalize(pVect a) { return rsqrtf(mag_sq(a))*a; }

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

__device__ pQuat mq(pNorm axis, float angle)
{
  pQuat q;
  q.w = cos(angle/2);
  q.v = sin(angle/2) * axis;
  return q;
}

__device__ pQuat mq(float4 a)
{
  pQuat q;
  q.w = a.w; q.v.x = a.x; q.v.y = a.y; q.v.z = a.z;
  return q;
}

__device__ float4 m4(pQuat q){ return make_float4(q.v.x,q.v.y,q.v.z,q.w); }



__device__ float3 make_float3(float4 f4){return make_float3(f4.x,f4.y,f4.z);}

__device__ int
div_p2_ceil(int num, int den_lg)
{
  const int quot = num >> den_lg;
  return quot << den_lg == num ? quot : quot + 1;
}


__device__ float3
cross(float3 a, float3 b)
{
  return make_float3
    ( a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x );
}

__device__ pVect cross(pVect a, pNorm b){ return cross(a,b.v); }
__device__ pVect cross(pNorm a, pVect b){ return cross(a.v,b); }


__device__ float3
cross3(float3 a, float3 b, float3 c)
{
  float3 ab = a - b;
  float3 cb = c - b;
  return cross(ab,cb);
}

__device__ pVect
cross3(pVect a, pVect b, pNorm c) { return cross3(a,b,c.v); }

__device__ pQuat operator *(pQuat a, pQuat b)
{
  pQuat p;
  p.w = a.w * b.w - dot(a.v,b.v);
  p.v = a.w * b.v + b.w * a.v + cross(a.v,b.v);
  return p;
};


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


__device__ void
fly_to_pc(CUDA_Ball_W& ball, double ts_t)
{
  ball.position += ts_t * ball.velocity;
}



__global__ void pass_something(int read_side, int ball_count);

__host__ void 
pass_something_launch
(dim3 dg, dim3 db, int read_side, int ball_count)
{
  pass_something<<<dg,db>>>(read_side,ball_count);
}

__device__ void
penetration_balls_resolve
(CUDA_Ball_W& ball1_r, CUDA_Ball_W& ball2_r, bool b2_real)
{
  CUDA_Ball_W *ball1 = &ball1_r;
  CUDA_Ball_W *ball2 = &ball2_r;
  pVect zero_vec = mv(0,0,0);
  pNorm dist = mn(ball1->position,ball2->position);

  if ( b2_real ) {
    ball1->debug_pair_calls++;  ball2->debug_pair_calls++; }
  if ( dist.mag_sq >= two_r_sq ) return;

  ball1->collision_count++;
  ball1->contact_count++;
  if ( b2_real ) { ball2->collision_count++; ball2->contact_count++; }


  /// WARNING:  This doesn't work: somefunc(-dist); 
  pNorm ndist = -dist;

  pVect appr_vel = ball1->velocity - ball2->velocity;
  pVect prev_appr_vel = ball1->prev_velocity - ball2->prev_velocity;
  const double approach_speed = dot( appr_vel, dist );
  const double prev_approach_speed = dot( prev_appr_vel, dist );

  const double loss_factor = 1 - opt_bounce_loss;

  const double appr_deltas_no_loss =
    ( two_r - dist.magnitude ) * elasticity_inv_dt * ball_mass_inv;

  const double appr_deltas =
    approach_speed > 0
    ? appr_deltas_no_loss : loss_factor * appr_deltas_no_loss;

  ball1->velocity -= appr_deltas * dist;
  if ( b2_real ) ball2->velocity += appr_deltas * dist;

  pVect tact1_rot_vel = point_rot_vel(ball1_r,dist);
  pVect tact2_rot_vel = point_rot_vel(ball2_r,ndist);

  const bool use_prev_vel = true;

  pVect tan_vel_prev = prev_appr_vel - prev_approach_speed * dist;
  pVect tan_vel_curr = appr_vel - approach_speed * dist;
  pVect tan_vel = use_prev_vel ? tan_vel_prev : tan_vel_curr;
  pNorm tact_vel_dir = mn(tact1_rot_vel - tact2_rot_vel + tan_vel);

  const double fric_dv_potential =
    fabs(appr_deltas_no_loss) * opt_friction_coeff;

  const double dv_limit_raw = tact_vel_dir.magnitude * mo_vel_factor;
  const double dv_limit = b2_real ? dv_limit_raw : 2 * dv_limit_raw;
  const bool will_roll = dv_limit <= fric_dv_potential;
  const double sliding_fric_deltav =
    will_roll ? dv_limit : fric_dv_potential;

  const double dv_tolerance = 0.000001;

  if ( sliding_fric_deltav > dv_tolerance )
    {
      const double fric_deltao = sliding_fric_deltav * v_to_do;

      apply_deltao(ball1_r,dist,tact_vel_dir,-fric_deltao);
      ball1->velocity -= sliding_fric_deltav * tact_vel_dir;

      if ( b2_real )
        {
          apply_deltao(ball2_r,dist,tact_vel_dir,-fric_deltao);
          ball2->velocity += sliding_fric_deltav * tact_vel_dir;
        }
    }

#if 0
  if ( !use_prev_vel && opt_verify && b2_real && will_roll )
    {
      pVect appr_vel2 = ball1->velocity - ball2->velocity;
      const double approach_speed2 = dot( appr_vel2, dist );

      pVect tact1_rot_vel2 = point_rot_vel(ball1_r,dist);
      pVect tact2_rot_vel2 = point_rot_vel(ball2_r,ndist);

      pVect tan_vel2 = appr_vel2 - approach_speed2 * dist;
      pNorm tan_vel_dir2 = tact1_rot_vel2 - tact2_rot_vel2 + tan_vel2;
      ASSERTS( tan_vel_dir2.magnitude <= 0.0001 + 100 * dv_tolerance );
      ball1->color_event = ball2->color_event = pColor(1,1,1);
    }
#endif

  {
    /// Torque
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

  if ( opt_debug ) return;

  {
    /// Rolling Friction
    //
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

#if 0
    if ( opt_verify )
      {
        pVect ch_tact1_rot_vel = point_rot_vel(ball1_r,dist);
        pVect ch_tact1_roll_vel = ch_tact1_rot_vel + tan_b12_vel;
        const double magloss = tact1_roll_vel.mag() - ch_tact1_roll_vel.mag();
        ASSERTS( magloss >= -10.0 );
      }
#endif
  }
}


__device__ void
platform_collision(CUDA_Ball_W& ball)
{
  const float ts_mov_max = 0.0;
  pVect zero_vec = mv(0,0,0);

  pCoor pos = ball.position;

  bool collision_possible =
    pos.y < opt_ball_radius + ts_mov_max
    && pos.x - ts_mov_max >= platform_xmin_mr
    && pos.x + ts_mov_max <= platform_xmax_pr
    && pos.z - ts_mov_max >= platform_zmin_mr
    && pos.z + ts_mov_max <= platform_zmax_pr;

  if ( !collision_possible ) return;

  CUDA_Ball_W pball;

  pCoor axis = mc(platform_xmid,0,pos.z);

  if ( pos.y > 0 )
    {
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
      pNorm tact_dir = mn(axis,pos);
      if ( tact_dir.mag_sq <= short_xrad_sq ) return;
      pball.position = axis + (opt_ball_radius+platform_xrad) * tact_dir;
    }

  pball.angular_momentum = zero_vec;
  pball.prev_velocity = pball.velocity = zero_vec;
  penetration_balls_resolve(ball,pball,false);
}

__device__ void
pass_something(int read_side, int ball_count)
{
  //  const int tid = threadIdx.x;
  const int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if ( idx >= ball_count ) return;

  CUDA_Ball_X bi = read_side ? balls_x_1 : balls_x_0;
  CUDA_Ball_X bo = read_side ? balls_x_1 : balls_x_0;


  CUDA_Ball_W ball;

  ball.prev_velocity = bi.prev_velocity[idx];
  ball.velocity = bi.velocity[idx] + gravity_accel_dt;
  set_f3(ball.position,bi.position[idx]);
  ball.angular_momentum = bi.angular_momentum[idx];
  ball.collision_count = bi.collision_count[idx];
  ball.contact_count = bi.contact_count[idx];

  platform_collision(ball);

  ball.position += delta_t * ball.velocity;
  pNorm axis = mn(ball.angular_momentum);
  bo.orientation[idx] =
    m4( mq(axis,delta_t * axis.magnitude) * mq(bi.orientation[idx]) );
  bo.velocity[idx] = ball.velocity;
  bo.prev_velocity[idx] = ball.velocity;
  bo.angular_momentum[idx] = ball.angular_momentum;
  set_f4(bo.position[idx],ball.position);
  bo.collision_count[idx] = ball.collision_count;
  bo.contact_count[idx] = ball.contact_count << 8;
  bo.debug_pair_calls[idx] = bi.debug_pair_calls[idx] << 16;
}

__global__ void pass_pairs
(int read_side, int prefetch_offset, int schedule_offset, int round_cnt);

__host__ void 
pass_pairs_launch
(dim3 dg, dim3 db, int read_side, int prefetch_offset,
 int schedule_offset, int round_cnt)
{
  pass_pairs<<<dg,db>>>(read_side,prefetch_offset,schedule_offset,round_cnt);
}

__device__ void
pass_pairs
(int read_side, int prefetch_offset, int schedule_offset, int round_cnt)
{
  const int tid = threadIdx.x;
  const int max_balls_per_thread =
    int( ceil( float(BALLS_PER_BLOCK) / blockDim.x ) );

  const int si_block_size = blockIdx.x * max_balls_per_thread * blockDim.x;
  const int si_block_base = prefetch_offset + si_block_size + tid;
  const int sp_block_size = blockIdx.x * round_cnt * blockDim.x;
  const int sp_block_base = schedule_offset + sp_block_size + tid;

  __shared__ CUDA_Ball_W sm_balls[BALLS_PER_BLOCK];

  CUDA_Ball_X bi = read_side ? balls_x_1 : balls_x_0;
  CUDA_Ball_X bo = read_side ? balls_x_1 : balls_x_0;

   for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= BALLS_PER_BLOCK ) continue;
      const int m_idx = schedule_inputs[ si_block_base + i * blockDim.x ];
      CUDA_Ball_W& ball = sm_balls[idx];
      ball.m_idx = m_idx;
      if ( m_idx < 0 ) continue;
      ball.velocity = bi.velocity[m_idx];
      ball.prev_velocity = bi.prev_velocity[m_idx];
      set_f3(ball.position,bi.position[m_idx]);
      ball.angular_momentum = bi.angular_momentum[m_idx];
      ball.collision_count = bi.collision_count[m_idx];
      ball.contact_count = bi.contact_count[m_idx];
      ball.debug_pair_calls = bi.debug_pair_calls[m_idx];
    }

  for ( int round=0; round<round_cnt; round++ )
    {
      const SM_Idx2 indices = schedule[ sp_block_base + round * blockDim.x ];
      __syncthreads();
      if ( indices.x == indices.y ) continue;
      penetration_balls_resolve(sm_balls[indices.x],sm_balls[indices.y],true);
    }

  for ( int i=0; i<max_balls_per_thread; i++ )
    {
      int idx = tid + i * blockDim.x;
      if ( idx >= BALLS_PER_BLOCK ) continue;
      CUDA_Ball_W& ball = sm_balls[idx];
      const int m_idx = ball.m_idx;
      if ( m_idx < 0 ) continue;

      bo.velocity[m_idx] = ball.velocity;
      bo.angular_momentum[m_idx] = ball.angular_momentum;
      bo.collision_count[m_idx] = ball.collision_count;
      bo.contact_count[m_idx] = ball.contact_count;
      bo.debug_pair_calls[m_idx] = ball.debug_pair_calls;
    }
}
