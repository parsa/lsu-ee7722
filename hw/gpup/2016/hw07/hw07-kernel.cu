
#include "cuda-coord.cu"
#include "hw07.cuh"
#include <gp/cuda-util-kernel.h>

// opt_air_resistance

// ball:: mass, mass_min, fdt_to_do
// ball:: force, torque, omatrix, position, velocity, omega, orientation
// link:: ball1, ball2, cb1, cb2, distance_relaxed
// link:: torque1, torque2, spring_force_12


__global__ void
time_step_gpu(double delta_t)
{
  const int tid = threadIdx.x + blockDim.x * blockIdx.x;
  const int n_threads = blockDim.x * gridDim.x;

  const int n_balls = balls;
  const int n_links = links;

  for ( int i=0; i<n_links; i++ )
    {
      Link* const link = links[i];
      if ( !link->is_simulatable ) continue;

      // Spring Force from Neighbor Balls
      //
      Ball* const ball1 = link->ball1;
      Ball* const ball2 = link->ball2;

      // Find position and velocity of the point where the link touches
      // the surface of ball 1 ...
      //
      pVect dir1 = ball1->omatrix * link->cb1;
      pCoor pos1 = ball1->position + dir1;
      pVect vel1 = ball1->velocity + ball1->point_rot_vel(dir1);

      // ... and ball 2.
      //
      pVect dir2 = ball2->omatrix * link->cb2;
      pCoor pos2 = ball2->position + dir2;
      pVect vel2 = ball2->velocity + ball2->point_rot_vel(dir2);

      // Construct a normalized (Unit) Vector from ball to neighbor
      // based on link connection points and ball centers.
      //
      pNorm link_dir(pos1,pos2);
      pNorm c_to_c(ball1->position,ball2->position);

      const float link_length = link_dir.magnitude;

      // Compute the speed of ball's end of link towards neighbor's end of link.
      //
      pVect delta_v = vel2 - vel1;
      float delta_s = dot( delta_v, link_dir );

      // Compute by how much the spring is stretched (positive value)
      // or compressed (negative value).
      //
      const float spring_stretch = link_length - link->distance_relaxed;

      // Determine whether spring is gaining energy (whether its length
      // is getting further from its relaxed length).
      //
      const bool gaining_e = ( delta_s > 0.0 ) == ( spring_stretch > 0 );

      // Use a smaller spring constant when spring is loosing energy,
      // a quick and dirty way of simulating energy loss due to spring
      // friction.
      //
      const float spring_constant =
        gaining_e ? opt_spring_constant : opt_spring_constant * 0.7;

      const float force_mag = spring_constant * spring_stretch;
      pVect spring_force_12 = force_mag * link_dir;

      // Apply forces affecting linear momentum.
      //
      link->spring_force_12 = spring_force_12;

      if ( ! link->is_surface_connection ) continue;

      // Apply torque.
      //
      link->torque1 = cross(pNorm(dir1), spring_force_12);
      link->torque2 = cross(pNorm(dir2), spring_force_12);
    }

  for ( int bi=tid; bi<n_balls; bi += n_threads )
    {
      Ball* const ball = balls[bi];
      ball->force = ball->mass * gravity_accel;
      ball->torque = pVect(0,0,0);
    }

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

  ///
  /// Update Position of Each Ball
  ///

  for ( int bi=0; bi<n_balls; bi++ )
    {
      Ball* const ball = balls[bi];
      if ( ball->locked )
        {
          ball->velocity = pVect(0,0,0);
          ball->omega = pVect(0,0,0);
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
      const float mass = max( ball->mass, ball->mass_min );

      pVect delta_v = ( ball->force / mass ) * delta_t;

      if ( platform_collision_possible(ball->position) && ball->position.y < 0 )
        {
          const float spring_constant_plat =
            ball->velocity.y < 0 ? 100000 : 50000;
          const float fric_coefficient = 0.1;
          const float force_up = -ball->position.y * spring_constant_plat;
          const float delta_v_up = force_up / mass * delta_t;
          const float fric_force_mag = fric_coefficient * force_up;
          pNorm surface_v(ball->velocity.x,0,ball->velocity.z);
          const float delta_v_surf = fric_force_mag / mass * delta_t;

          if ( delta_v_surf > surface_v.magnitude )
            {
              // Ignoring other forces?
              delta_v =
                pVect(-ball->velocity.x,delta_v.y,-ball->velocity.z);
            }
          else
            {
              delta_v -= delta_v_surf * surface_v;
            }
          delta_v.y += delta_v_up;
        }

      ball->velocity += delta_v;

      // Air Resistance
      //
      const double fs = pow(1+opt_air_resistance,-delta_t);
      ball->velocity *= fs;

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball->position += ball->velocity * delta_t;

      ball->omega += delta_t * ball->fdt_to_do * ball->torque;

      pNorm axis(ball->omega);

      // Update Orientation
      //
      // If ball isn't spinning fast skip expensive rotation.
      //
      if ( axis.mag_sq < 0.000001 ) continue;

      // Update ball orientation.
      //
      ball->orientation_set
        ( pQuat(axis,delta_t * axis.magnitude) * ball->orientation );
    }
}
