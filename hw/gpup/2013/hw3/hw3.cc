/// LSU EE 4702-1 (Fall 2013), GPU Programming
//
 /// Homework 3
 //

 /// Solution will require some changes in this file.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2013/hw03.pdf


// $Id:$

/// Purpose
//
//   Demonstrate simulation of string modeled as point masses and springs


/// What Code Does

// Simulates a string bouncing over a platform. The string is modeled
// as point masses connected by springs with a long relaxed
// length. The platform consists of tiles, some are purple-tinted
// mirrors (showing a reflection of the ball), the others show the
// course syllabus.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //        Move object or push ball, depending on mode.
 //        With shift key pressed, motion is 5x faster.
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move head (first) ball. (Change position but not velocity.)
 //   'B': Push head ball. (Add velocity.)
 //
 /// Eye Direction
 //   Home, End, Delete, Insert
 //   Turn the eye direction.
 //   Home should rotate eye direction up, End should rotate eye
 //   down, Delete should rotate eye left, Insert should rotate eye
 //   right.  The eye direction vector is displayed in the upper left.

 /// Simulation Options
 //  (Also see variables below.)
 //
 //  'a'    Switch between different methods of computing physics.
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
 //  '3'    Set up scene 3.
 //  'x'    Toggle value of Boolean variable opt_test1, use for tuning.
 //  'X'    Toggle value of Boolean variable opt_test2, use for tuning.
 //  'p'    Pause simulation. (Press again to resume.)
 //  ' '    (Space bar.) Advance simulation by 1/30 second.
 //  'S- '  (Shift-space bar.) Advance simulation by one time step.
 //  'k'    Freeze position of first ball. (Press again to release.)
 //  't'    Freeze position of last ball. (Press again to release.)
 //  's'    Stop ball.
 //  'S'    Freeze ball. (Set velocity of all vertices to zero.)
 //  'g'    Turn gravity on and off.
 //  'F12'  Write screenshot to file.

 /// Variables
 //   Selected program variables can be modified using the keyboard.
 //   Use "Tab" to cycle through the variable to be modified, the
 //   name of the variable is displayed next to "VAR" on the bottom
 //   line of green text.

 //  'Tab' Cycle to next variable.
 //  '`'   Cycle to previous variable.
 //  '+'   Increase variable value.
 //  '-'   Decrease variable value.
 //
 //  VAR Grid Size - Number of blocks.
 //  VAR Block Size - Number of threads per block.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)


#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include <gp/cuda-util.h>

#include "shapes.h"

#include "hw3.cuh"


///
/// Main Data Structures
///
//
// class World: All data about scene.


class World;

#include "hw3-graphics.cc"

float
random(float min, float max)
{
  return min + (max-min) * double(random()) / RAND_MAX;
}


void
World::init()
{
  c.chain_length = 256;
  balls = new Ball[c.chain_length];
  opt_physics = P_GPU_Sol;
  c.opt_test1 = c.opt_test2 = false;

  // Device storage for ball positions.
  // For Homework 3, assign a value near the bottom of this routine.
  c.d_pos = NULL;

  // Allocate storage for balls on GPU.
  //
  CE( cudaMalloc( &c.d_balls, c.chain_length*sizeof(c.d_balls[0])) );

  c.distance_relaxed = 0.1;
  c.opt_spring_constant = 1000;
  //  variable_control.insert(c.opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  c.gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  c.opt_air_resistance = 0.0001;

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  duration_physics_id = frame_timer.user_timer_define("Physics",false);
  frame_timer.work_unit_set("Steps / s");

  duration_physics_samples = 0;
  duration_physics_sum = 0;
  duration_physics_deadline = 0;

  init_graphics();

  light_location = pCoor(27.4,44,-44.2);

  ball_setup_3();

  cuda_init();

  // Helpful information for solution.
  //
  const int number_of_multiprocessors = cuda_prop.multiProcessorCount;

  Kernel_Info *ki_part_1 = NULL;
  for ( int i=0; i<gpu_info.num_kernels; i++ )
    if ( pString(gpu_info.ki[i].name) == "time_step_gpu_sol_part_1" )
      ki_part_1 = &gpu_info.ki[i];

  const int max_threads_part_1 =
    ki_part_1 ? ki_part_1->cfa.maxThreadsPerBlock : 0;

  // Set launch configuration to "arbitrary" values.
  // These are used for all kernels, but the solution may use
  // different configurations for different kernels.
  //
  opt_grid_size = 13;
  opt_block_size = 256;

  /// Put Solution Here.
  //



  variable_control.insert(opt_grid_size,"Grid Size",1,1);
  variable_control.insert_power_of_2
    (opt_block_size,"Block Size",1,max_threads_part_1);

  // Copy values in structure c to GPU. Values are also copied
  // whenever user presses a key.
  //
  data_cpu_to_gpu_constants();
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//
void
World::ball_setup_1()
{
  // Set initial position to a visibly interesting point.
  //
  pCoor next_pos(12.5,1,-13.7);

  for ( int i=0; i<c.chain_length; i++ )
    {
      // Put the first ball on top because that one can be moved and locked.
      //
      Ball* const ball = &balls[c.chain_length-i-1];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->radius = c.distance_relaxed * 0.75;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->mass_inv = 1.0 / ball->mass;
      ball->contact = false;
      next_pos += pVect(1.0 / c.chain_length,c.distance_relaxed,0)
        + 0.001 * c.distance_relaxed
        * pVect(random(-1,1),random(-1,1),random(-1,1));
    }
  c.opt_head_lock = false;
  c.opt_tail_lock = false;
}

void
World::ball_setup_2()
{
  // Arrange and size balls to form a pendulum.
  //
  pCoor next_pos(13.4,21.8,-9.2);

  const float radius = c.distance_relaxed * 0.75;

  for ( int i=0; i<c.chain_length; i++ )
    {
      // Put the first ball on top because that one can be moved and locked.
      //
      Ball* const ball = &balls[i];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->radius = i == c.chain_length - 1 ? 2 * radius : radius;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->mass_inv = 1.0 / ball->mass;
      ball->contact = false;
      next_pos += pVect(c.distance_relaxed,0,0)
        + 0.001 * c.distance_relaxed
        * pVect(random(-1,1),random(-1,1),random(-1,1));
    }

  c.opt_head_lock = true;
  c.opt_tail_lock = false;
}

void
World::ball_setup_3()
{
  // Arrange balls to form a spiral, initially held up by center point.

  pCoor center_pos(20,15,-30);

  const float ball_radius = c.distance_relaxed * 0.95;
  float r = c.distance_relaxed;
  float theta = 0;

  for ( int i=0; i<c.chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Note: This is crude. Ideally, the distance between balls
      // would be exactly distance_relaxed.
      //
      const float balls_per_rev = 2 * M_PI * r / c.distance_relaxed;
      const float delta_r = 2 * ball_radius / balls_per_rev;
      const float delta_theta = c.distance_relaxed  / r;
      r += delta_r;
      theta += delta_theta;

      ball->position = center_pos + r * pVect(cos(theta),sin(theta),0);
      ball->velocity = pVect(0,0,0);
      ball->radius = ball_radius;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->mass_inv = 1.0 / ball->mass;
      ball->contact = false;

    }

  c.opt_head_lock = true;
  c.opt_tail_lock = true;
}

void
World::ball_setup_4()
{
  // Set up balls to from a knot.
  //

  const float ball_radius = c.distance_relaxed * .75;

  pCoor start_pos(13.4,5,-9.2);
  pCoor next_pos = start_pos;
  pVect jog(-0.2,0,0);
  const float jog_len = jog.mag();

  // Up part.

  int i=0;

  for ( ; i<120; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = next_pos;
      next_pos.y += c.distance_relaxed;
    }

  pCoor circ_1_ctr = next_pos;

  pCoor circ_2_ctr = next_pos + jog;
  pVect c2_x = -jog;
  pVect c2_y = cross(c2_x,pVect(0,1,0));
  const float delta_theta = c.distance_relaxed / jog_len;
  float y = 0;
  const float delta_y = -0.02;
  for ( float theta=0; theta<1.5*M_PI; theta += delta_theta )
    {
      balls[i++].position = 
        circ_2_ctr + cos(theta) * c2_x + sin(theta) * c2_y +
        pCoor(0,y,0);
      y += delta_y;
    }

  next_pos = balls[i-1].position;
  y = 0;

  const int steps = jog_len / c.distance_relaxed;

  for ( int j=1; j<=steps; j++ )
    {
      balls[i++].position = next_pos - j/float(steps) * jog + pVect(0,y,0);
      y += delta_y;
    }

  next_pos = balls[i-1].position;
  y = 0;

  for ( float theta=-0.5*M_PI; theta<M_PI; theta += delta_theta )
    {
      balls[i++].position = 
        circ_1_ctr + cos(theta) * c2_x + sin(theta) * c2_y + pVect(0,y,0);
      y += delta_y;
    }

  next_pos = balls[i-1].position;

  for ( ; i<c.chain_length; i++ )
    {
      next_pos.y += c.distance_relaxed;
      balls[i].position = next_pos;
    }
  
  for ( int i=0; i<c.chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->velocity = pVect(0,0,0);
      ball->radius = i == 0 ? 4 * ball_radius : ball_radius;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->mass_inv = 1.0 / ball->mass;
      ball->contact = false;
    }

  c.opt_tail_lock = true;
}

void
World::ball_setup_5()
{
}


 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu(double delta_t)
{
  //
  /// Compute force and update velocity of each ball.
  //
  for ( int i=0; i<c.chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Skip locked balls.
      //
      if ( c.opt_head_lock && i == 0
           || c.opt_tail_lock && i == c.chain_length - 1 )
        {
          ball->velocity = pVect(0,0,0);
          continue;
        }

      pVect force(0,0,0);

      // Gravitational Force
      //
      force += ball->mass * c.gravity_accel;

      // Spring Force from Neighbor Balls
      //
      for ( int j = -3;  j < 4;  j++ )
        {
          const int n_idx = i + j;
          if ( n_idx < 0 ) continue;
          if ( n_idx >= c.chain_length ) continue;

          // Distance (in units of balls) from us to neighbor.
          //
          const int idx_dist = abs(j);
          if ( idx_dist == 0 ) continue;

          // If true, apply only repulsion forces. This is a
          // quick and dirty way of simulating stiffness.
          //
          const bool rep_only = idx_dist > 1;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor(ball->position,neighbor_ball->position);

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );

          const float distance_relaxed =
            rep_only ? idx_dist * c.distance_relaxed : c.distance_relaxed;

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          const float spring_stretch =
            ball_to_neighbor.magnitude - distance_relaxed;

          // Determine whether spring is gaining energy (whether its length
          // is getting further from its relaxed length).
          //
          const bool gaining_e = ( delta_s > 0.0 ) == ( spring_stretch > 0 );

          // Use a smaller spring constant when spring is loosing energy,
          // a quick and dirty way of simulating energy loss due to spring
          // friction.
          //
          const float spring_constant =
            gaining_e ? c.opt_spring_constant : c.opt_spring_constant * 0.7;

          if ( !rep_only || spring_stretch < 0 )
            force += spring_constant * spring_stretch * ball_to_neighbor;
        }

      // Check for contact between us and other balls, except our immediate
      // neighbors.
      //
      for ( int j=0; j<c.chain_length; j++ )
        {
          if ( abs(j-i)<=1 ) continue;
          Ball* const ball2 = &balls[j];
          pNorm ball_to_2(ball->position,ball2->position);
          const float rsum = ball->radius + ball2->radius;
          if ( rsum * rsum < ball_to_2.mag_sq ) continue;
          const float compression = rsum - ball_to_2.magnitude;
          const float f = compression * 1000;
          force -= f * ball_to_2;
        }

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // when spring constant is large for the time step.
      //
      ball->velocity += ball->mass_inv * delta_t * force;

      // Air Resistance
      //
      const double fs = pow(1+c.opt_air_resistance,-delta_t);
      ball->velocity *= fs;
    }

  ///
  /// Update Position of Each Ball
  ///

  for ( int i=0; i<c.chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball->position += ball->velocity * delta_t;

      //
      // Possible Collision with Platform
      //

      // Skip if collision impossible.
      //
      if ( !platform_collision_possible(ball->position) ) continue;
      if ( ball->position.y >= ball->radius ) continue;
      if ( ball->position.y < 0 ) continue;

      // Apply spring forces due to collision with platform.
      //
      const float spr_const = ball->velocity.y > 0 ? 500000 : 1000000;
      ball->velocity.y +=
        ( ball->radius - ball->position.y ) * delta_t * spr_const;
    }
}


void
World::data_cpu_to_gpu_constants()
{
  TO_DEV_DS(dc,c);
}

void
World::data_cpu_to_gpu_dynamic()
{
  CE( cudaMemcpy
      ( c.d_balls, balls, c.chain_length * sizeof(Ball),
        cudaMemcpyHostToDevice ) );
}

void
World::data_gpu_to_cpu_dynamic()
{
  CE( cudaMemcpy
      ( balls, c.d_balls, c.chain_length * sizeof(Ball),
        cudaMemcpyDeviceToHost ) );
}

bool
World::platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.x >= c.platform_xmin && pos.x <= c.platform_xmax
    && pos.z >= c.platform_zmin && pos.z <= c.platform_zmax;
}

 /// External Modifications to State
//
//   These allow the user to play with state while simulation
//   running.

// Move the ball.
//
void Ball::translate(pVect amt) {position += amt;}

// Add velocity to the ball.
//
void Ball::push(pVect amt) {velocity += amt;}

// Set the velocity to zero.
//
void Ball::stop() {velocity = pVect(0,0,0); }

// Set the velocity and rotation (not yet supported) to zero.
//
void Ball::freeze() {velocity = pVect(0,0,0); }



void World::balls_translate(pVect amt,int b){balls[b].translate(amt);}
void World::balls_push(pVect amt,int b){balls[b].push(amt);}
void World::balls_translate(pVect amt)
{ for(int i=0;i<c.chain_length;i++)balls[i].translate(amt);}
void World::balls_push(pVect amt)
{ for(int i=0;i<c.chain_length;i++)balls[i].push(amt);}
void World::balls_stop()
{ for(int i=0;i<c.chain_length;i++)balls[i].stop();}
void World::balls_freeze(){balls_stop();}


void
World::frame_callback()
{
  // This routine called whenever window needs to be updated.

  const double time_now = time_wall_fp();

  if ( !opt_pause || opt_single_frame || opt_single_time_step )
    {
      /// Advance simulation state.

      // Amount of time since the user saw the last frame.
      //
      const double wall_delta_t = time_now - last_frame_wall_time;

      const double time_step_duration = 0.0001;

      // Compute amount by which to advance simulation state for this frame.
      //
      const double duration =
        opt_single_time_step ? time_step_duration :
        opt_single_frame ? 1/30.0 :
        wall_delta_t;

      const double world_time_target = world_time + duration;

      // Minimum frame rate that we'll tolerate.
      const double deadline = time_wall_fp() + 1/5.0;

      frame_timer.user_timer_start(duration_physics_id);

      if ( opt_physics != P_CPU )
        {
          data_cpu_to_gpu_dynamic();
          CE(cudaEventRecord(frame_start_ce,0));
        }

      if ( opt_physics == P_GPU_Sol )
        launch_data_pack(opt_grid_size,opt_block_size);

      while ( world_time < world_time_target && time_wall_fp() < deadline )
        {
          time_step_count++;
          duration_physics_samples++;
          frame_timer.work_amt_set(1);
          if ( opt_physics == P_GPU_Base )
            {
              launch_time_step_gpu_base_part_1
                (opt_grid_size, opt_block_size, time_step_duration);
              launch_time_step_gpu_base_part_2
                (opt_grid_size, opt_block_size, time_step_duration);
            }
          else if ( opt_physics == P_GPU_Sol )
            {
              launch_time_step_gpu_sol_part_1
                (opt_grid_size, opt_block_size, time_step_duration);
              launch_time_step_gpu_sol_part_2
                (opt_grid_size, opt_block_size, time_step_duration);
            }
          else
            {
              time_step_cpu(time_step_duration);
            }
          world_time += time_step_duration;
        }

      if ( opt_physics == P_GPU_Sol )
        launch_data_unpack(opt_grid_size,opt_block_size);

      if ( opt_physics != P_CPU )
        {
          // Collect amount of time CUDA took to compute this frame.
          //
          CE(cudaEventRecord(frame_stop_ce,0));
          CE(cudaEventSynchronize(frame_stop_ce));
          float cuda_time = -1.1;
          CE(cudaEventElapsedTime(&cuda_time,frame_start_ce,frame_stop_ce));
          frame_timer.cuda_frame_time_set(cuda_time);

          data_gpu_to_cpu_dynamic();
        }

      const double time_after = time_wall_fp();
      duration_physics_sum += time_after - time_now;
      if ( time_after > duration_physics_deadline )
        {
          duration_physics = duration_physics_sum / duration_physics_samples;
          duration_physics_deadline = time_after + 0.5;
          duration_physics_samples = 0;
          duration_physics_sum = 0;
        }

      frame_timer.user_timer_end(duration_physics_id);

      // Reset these, just in case they were set.
      //
      opt_single_frame = opt_single_time_step = false;
    }

  last_frame_wall_time = time_now;
  render();
}




int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
