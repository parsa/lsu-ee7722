

#include "cuda-coord.cu"

using namespace pCUDA_coord;

#include "links.cuh"
#include <gp/cuda-util-kernel.h>
#include <gp/cuda-gpuinfo.h>
#include <assert.h>

__constant__ CPU_GPU_Common dc;

void
data_cpu_to_gpu_common(CPU_GPU_Common *host_c)
{
  CE( cudaMemcpyToSymbol( dc, host_c, sizeof(*host_c) ) );
}

__global__ void time_step_gpu_zero();
__global__ void time_step_gpu_links(float delta_t);
__global__ void time_step_gpu_balls(float delta_t);

__host__ void
launch_time_step(double delta_t)
{
  time_step_gpu_zero<<<13,256>>>();
  time_step_gpu_links<<<13,256>>>(delta_t);
  time_step_gpu_balls<<<13,256>>>(delta_t);
}



__device__ bool
platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.x >= dc.platform_xmin && pos.x <= dc.platform_xmax
    && pos.z >= dc.platform_zmin && pos.z <= dc.platform_zmax;
}


__global__ void
time_step_gpu_links(float delta_t)
{
  const int tid = threadIdx.x + blockDim.x * blockIdx.x;
  const int n_threads = blockDim.x * gridDim.x;

#define link(mem) dc.links.mem[li]
#define ball1(mem) dc.balls.mem[ball_1_idx]
#define ball2(mem) dc.balls.mem[ball_2_idx]


  for ( int li=tid; li<dc.n_links; li += n_threads )
    {
      if ( !link(is_simulatable) ) continue;

      // Spring Force from Neighbor Balls
      //
      const int ball_1_idx = link(ball1_idx);
      const int ball_2_idx = link(ball2_idx);

      pCoor ball1_pos = ball1(position);
      pCoor ball2_pos = ball2(position);

      // Find position and velocity of the point where the link touches
      // the surface of ball 1 ...
      //
      pVect dir1 = ball1(omatrix) * link(cb1);
      pCoor pos1 = ball1_pos + dir1;
      pVect vel1 = ball1(velocity) + cross( ball1(omega), dir1 );

      // ... and ball 2.
      //
      pVect dir2 = ball2(omatrix) * link(cb2);
      pCoor pos2 = ball2_pos + dir2;
      pVect vel2 = ball2(velocity) + cross( ball2(omega), dir2 );

      // Construct a normalized (Unit) Vector from ball to neighbor
      // based on link connection points and ball centers.
      //
      pNorm link_dir(pos1,pos2);
      pNorm c_to_c(ball1_pos,ball2_pos);

      const float link_length = link_dir.magnitude;

      // Compute the speed of ball's end of link towards neighbor's end of link.
      //
      pVect delta_v = vel2 - vel1;
      float delta_s = dot( delta_v, link_dir );

      // Compute by how much the spring is stretched (positive value)
      // or compressed (negative value).
      //
      const float spring_stretch = link_length - link(distance_relaxed);

      // Determine whether spring is gaining energy (whether its length
      // is getting further from its relaxed length).
      //
      const bool gaining_e = ( delta_s > 0.0 ) == ( spring_stretch > 0 );

      // Use a smaller spring constant when spring is loosing energy,
      // a quick and dirty way of simulating energy loss due to spring
      // friction.
      //
      const float spring_constant =
        gaining_e ? dc.opt_spring_constant : dc.opt_spring_constant * 0.7;

      const float force_mag = spring_constant * spring_stretch;
      pVect spring_force_12 = force_mag * link_dir;

      // Apply forces affecting linear momentum.
      //
      //  link(spring_force_12) = spring_force_12;

#define ATOMIC(d,s) \
      atomicAdd(&d.x,s.x); atomicAdd(&d.y,s.y); atomicAdd(&d.z,s.z);

      ATOMIC(ball1(force),spring_force_12);
      ATOMIC(ball2(force),-spring_force_12);
#if 0
      ball1->force += link->spring_force_12;
      ball2->force -= link->spring_force_12;
      ball1->torque += link->torque1;
      ball2->torque -= link->torque2;
#endif

      if ( ! link(is_surface_connection) ) continue;

      pNorm dir1n(dir1);
      pNorm dir2n(dir2);

      // Apply torque.
      //
      pVect torque1 = cross(dir1n, spring_force_12);
      pVect torque2 = cross(dir2n, spring_force_12);

      ATOMIC(ball1(torque),torque1);
      ATOMIC(ball2(torque),-torque2);
    }

#if 0
  // Note: Because two links can reference the same ball this should
  // not be done in parallel.
  for ( Link *link: links )
    {
      if ( !link->is_simulatable ) continue;
      Ball* const ball1 = link->ball1;
      Ball* const ball2 = link->ball2;
      ball1->force += link->spring_force_12;
      ball2->force -= link->spring_force_12;
      ball1->torque += link->torque1;
      ball2->torque -= link->torque2;
    }
#endif

}

__global__ void
time_step_gpu_zero()
{
  const int tid = threadIdx.x + blockDim.x * blockIdx.x;
  const int n_threads = blockDim.x * gridDim.x;
#define ball(mem) dc.balls.mem[bi]

  for ( int bi=tid; bi<dc.n_balls; bi += n_threads )
    {
      ball(force) = pVect4(0);
      ball(torque) = pVect4(0);
    }
}

__global__ void
time_step_gpu_balls(float delta_t)
{
  const int tid = threadIdx.x + blockDim.x * blockIdx.x;
  const int n_threads = blockDim.x * gridDim.x;


#if 0
  // Note: Because two links can reference the same ball this should
  // not be done in parallel.
  for ( Link *link: links )
    {
      if ( !link->is_simulatable ) continue;
      Ball* const ball1 = link->ball1;
      Ball* const ball2 = link->ball2;
      ball1->force += link->spring_force_12;
      ball2->force -= link->spring_force_12;
      ball1->torque += link->torque1;
      ball2->torque -= link->torque2;
    }
#endif

#define ball(mem) dc.balls.mem[bi]


  ///
  /// Update Position of Each Ball
  ///

  for ( int bi=tid; bi<dc.n_balls; bi += n_threads )
    {
      if ( ball(locked) )
        {
          ball(velocity) = pVect(0);
          ball(omega) = pVect(0);
          continue;
        }

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // when spring constant is large for the time step.
      //
      const float mass = ball(mass);
      pCoor ball_position = ball(position);
      pVect ball_velocity = ball(velocity);
      pVect ball_force = ball(force);
      ball(force) = pVect(0);
      ball_force += mass * dc.gravity_accel;

      pVect delta_v = ( delta_t / mass ) * ball_force;

      if ( platform_collision_possible(ball_position) && ball_position.y < 0 )
        {
          const float spring_constant_plat =
            ball_velocity.y < 0 ? 100000 : 50000;
          const float fric_coefficient = 0.1;
          const float force_up = -ball_position.y * spring_constant_plat;
          const float delta_v_up = force_up / mass * delta_t;
          const float fric_force_mag = fric_coefficient * force_up;
          pNorm surface_v(ball_velocity.x,0,ball_velocity.z);
          const float delta_v_surf = fric_force_mag / mass * delta_t;

          if ( delta_v_surf > surface_v.magnitude )
            {
              // Ignoring other forces?
              delta_v = pVect(-ball_velocity.x,delta_v.y,-ball_velocity.z);
            }
          else
            {
              delta_v -= delta_v_surf * surface_v;
            }
          delta_v.y += delta_v_up;
        }

      ball_velocity += delta_v;

      // Air Resistance
      //
      const float fs = powf(1+dc.opt_air_resistance,-delta_t);
      ball_velocity *= fs;
      ball(velocity) = ball_velocity;

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball_position += ball_velocity * delta_t;
      ball(position) = ball_position;

      pVect ball_omega = ball(omega);

      ball_omega += delta_t * ball(fdt_to_do) * ball(torque);
      ball(omega) = ball_omega;

      pNorm axis(ball_omega);

      // Update Orientation
      //
      // If ball isn't spinning fast skip expensive rotation.
      //
      //  if ( axis.mag_sq < 0.000001 ) continue;

      pQuat orientation =
        pQuat( axis, delta_t * axis.magnitude ) * ball(orientation);
      ball(orientation) = orientation;
      ball(omatrix) = pMatrix3x3(orientation);
    }

#undef ball

}
