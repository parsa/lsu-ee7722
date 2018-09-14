/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 /// Homework 1 -- SOLUTION
 //
 //  Search for SOLUTION in this file to find changed parts.

 /// Instructions
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2018/hw01.pdf
 //
 //  Search for "Problem" in this file to find the places to modify.
 //
 //  Only this file will be collected.


/// Purpose
//
//   Demonstrate simulation of string modeled as point masses and springs


/// What Code Does

// Simulates a string of beads over a platform. The string is modeled
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
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
 //  'p'    Pause simulation. (Press again to resume.)
 //  ' '    (Space bar.) Advance simulation by 1/30 second.
 //  'S- '  (Shift-space bar.) Advance simulation by one time step.
 //  'h'    Freeze position of first (head) ball. (Press again to release.)
 //  't'    Freeze position of last (tail) ball. (Press again to release.)
 //  's'    Stop balls.
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
 //  VAR Spring Constant - Set spring constant.
 //  VAR Air Resistance - Set air resistance.
 //  VAR Light Intensity - The light intensity.
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

#include "shapes.h"


///
/// Main Data Structures
///
//
// class World: All data about scene.


class World;


// Object Holding Ball State
//
class Ball {
public:
  pCoor position;
  pVect velocity;

  float mass;
  float radius;

  bool contact;                 // Can be used for special effects.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

#include "hw01-graphics.cc"


void
World::init()
{
  chain_length = 40;
  balls = new Ball[chain_length];
 
  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 1000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_time_step_hw01 = false;

  opt_air_resistance = 0.001;
  variable_control.insert(opt_air_resistance,"Air Resistance");  

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  init_graphics();

  // Initialize Scene 3/4 positions so that they can be used in
  // Scene 5 without error when Scene 5 is invoked before 3 and 4.
  hw01_center = pCoor(13.4,17.8,-9.2);
  hw01_dir = pVect(0,-10,0);
  hw01_r = 3;

  curr_setup = 1; ball_setup_1();
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//
void
World::ball_setup_1()
{
  /// Arrange balls almost vertically.

  // Desired position of bottom ball.
  //
  pCoor bottom_pos(12.5,distance_relaxed,-13.7);

  // Desired distance between adjacent balls.
  //
  pVect ball_separation(0.02, distance_relaxed, 0.01);  // Points up.

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[chain_length-i-1];

      ball->position = bottom_pos + i * ball_separation;

      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3 * distance_relaxed;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  opt_head_lock = false;
  opt_tail_lock = false;
}

void
World::ball_setup_2()
{
  /// Arrange and size balls to form a pendulum.

  // Desired position of first ball.
  //
  pCoor first_ball_pos(13.4,17.8,-9.2);

  // Desired distance between adjacent balls.
  //
  pVect ball_separation(distance_relaxed, 0, 0);  // Points in +x direction.

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = first_ball_pos + i * ball_separation;

      ball->velocity = pVect(0,0,0);
      ball->radius = ( i == chain_length - 1 ? 0.6 : 0.3 ) * distance_relaxed;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  opt_head_lock = true;
}

void
World::ball_setup_3()
{
  hw01_center = pCoor(13.4,17.8,-9.2);
  hw01_dir = pVect(0,-10,0);
  hw01_r = 3;
  hw01(hw01_center, hw01_dir,hw01_r);
}

void
World::ball_setup_4()
{
  hw01_center = pCoor(13.4,17.8,-9.2);
  hw01_dir = pVect(drand48(),drand48()*4-10,drand48());
  hw01_r = 1 + drand48() * 3;
  hw01(hw01_center,hw01_dir,hw01_r);
}

void
World::ball_setup_5()
{
  hw01_alt(hw01_center,hw01_dir,hw01_r);
}

void
World::hw01(pCoor center, pVect dir, float r)
{
  /// SOLUTION -- Problem 2 -- Good Solution

  // The following solution is reasonable and would receive full
  // credit. See hw01_alt below for an alternative solution which
  // performs less computation by replacing the cosf/sinf with a
  // transformation matrix.

  // Compute angle between neighboring balls based on 8 balls per revolution.
  //
  const float delta_theta = 2 * M_PI / 8;
  //
  // Eight is an arbitrary choice. It looks good.

  //
  // Compute local-space axes used to draw the spiral.
  //

  // First, find one vector orthogonal to dir.
  //
  pNorm ax = dir.x ? pVect( -dir.y, dir.x, 0 ) : pVect( 0, -dir.z, dir.y );

  // Then compute one orthogonal to dir and ax.
  //
  pNorm ay = cross(dir,ax);
  // pNorm az(dir); // This is commented out because we don't need az directly.
  //
  // In the local-space coordinates a circle is drawn on the xy plane.

  // Scale the axes so that we get a spiral of the correct radius
  // and a cylinder of the correct length.
  //
  pVect vx = ax * r;
  pVect vy = ay * r;
  pVect vz = dir / chain_length;  // Or: az * dir.mag() / chain_length.

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      const float theta = i * delta_theta;
      ball->position =
        center + cosf(theta) * vx + sinf(theta) * vy + i * vz;
      //
      // Note: cosf(theta) * vx converts the x component of the
      // local coordinate, cosf(theta), to the global coordinate space.

      ball->velocity = pVect(0,0,0);
      ball->radius = 0.1;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  // Set the spring distance_relaxed to the distance between adjacent
  // balls.
  //
  distance_relaxed = pNorm(balls[0].position,balls[1].position).magnitude;

  // Here is how distance_relaxed can be computed geometrically:
  //
  const float dr =
    pow( dot(vz,vz) /* the length of vz, squared */ +
         r * r * ( pow(1-cosf(delta_theta),2) + pow(sinf(delta_theta),2) ),
         0.5);
  // Make sure that dr is very close to distance_relaxed.
  const float err = fabs( distance_relaxed - dr );
  assert( err < 0.00001 );

  opt_head_lock = true;
  opt_pause = true;
}

void
World::hw01_alt(pCoor center, pVect dir, float r)
{
  /// SOLUTION -- Problem 2 - Alternative solution.

  // This solution uses a transformation matrix to avoid computing
  // cosf and sinf each iteration. The transformation matrix moves pos
  // (the current ball position) to the next position on the spiral.
  //
  // Here are the transformation performed by the matrix, m_next_point:
  //
  //  - Translate pos from its global position to the local position
  //    in which center (see call arguments above) is at the origin.
  //    See matrix to_local.
  //
  //  - Rotate the coordinate space so that dir points in the +z direction.
  //    See rot_local.
  //
  //    At this point the spiral rotates around the z axis and moves
  //    down the z axis.
  //
  //  - Rotate the coordinate space by delta_theta. This rotates
  //    the current pos to the next spiral pos, but doesn't change z.
  //    See rot_local.
  //
  //  - More the position down the z axis. See m_down.
  //
  //  - Rotate the coordinate space so that what was the z axis now
  //    points in direction dir. See rot_to_global.
  //
  //  - Translate pos from its local position back to the global
  //    position. See to_global.
  //

  // Compute angle between neighboring balls based on 8 balls per revolution.
  //
  const float delta_theta = 2 * M_PI / 8;
  //
  // Eight is an arbitrary choice.

  // Compute local-space axes used to draw the spiral.
  //
  pNorm az(dir);
  pNorm ax = dir.x ? pVect( -dir.y, dir.x, 0 ) : pVect( 0, -dir.z, dir.y );
  // No need for pNorm because az and ay are orthonormal:
  //   each is a unit vector and they are orthogonal to each other.
  pVect ay = cross(az,ax);

  //
  // The following two transformations are used to go from global
  // space to local space.
  //
  // Translate so that center (see call argument) is at the origin.
  //
  pMatrix_Translate to_local( -center );
  //
  // Rotate (tilt) so that dir points in the z direction and so that
  // in local space ax is the x axis and ay is the y axis.
  //
  pMatrix_Rows rot_to_local(ax,ay,az); // Construct a matrix using args as rows.

  //
  // The following two transforms move a point in local space along
  // the spiral.
  //
  // Rotate, around the z axis, from one spiral position to the next.
  //
  pMatrix_Rotation rot_local( pVect(0,0,1), delta_theta );
  //
  // Translate down along z axis.
  //
  const float dir_len = az.magnitude;
  const float delta_az = dir_len / chain_length;
  pMatrix_Translate m_down(0,0,delta_az);

  //
  // The following two transformations are used to go from local
  // space back to global space.
  //
  // Rotate (tilt) to that z points to dir.
  //
  pMatrix rot_to_global = transpose(rot_to_local);
  //
  // Translate back to center point.
  //
  pMatrix_Translate to_global( center );

  pCoor pos0_local(r,0,0);  // The first point on the spiral in local coords.

  // The first point on the spiral in global coords.
  //
  pCoor pos = to_global * rot_to_global * pos0_local;

  // Compute matrix that will move a global coordinate to the next
  // spiral position.
  //
  pMatrix m_next_point =
    to_global * rot_to_global * m_down * rot_local * rot_to_local * to_local;

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = pos;

      // Use transformation to move pos to next position on spiral.
      //
      pos = m_next_point * pos;
      //
      // Note that we aren't computing sin/cos functions.

      ball->velocity = pVect(0,0,0);
      ball->radius = i & 1 ? 0.1 : 0.15; // So that it looks different hw01.
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  distance_relaxed = pNorm(balls[0].position,balls[1].position).magnitude;

  opt_head_lock = true;
  opt_pause = true;
}


 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu_hw01(double delta_t)
{
  /// Homework 1 Problem 1 Solution Goes In This Routine

  time_step_count++;

  //
  /// Compute force and update velocity of each ball.
  //
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Skip locked balls.
      //
      if ( opt_head_lock && i == 0 || opt_tail_lock && i == chain_length - 1 )
        {
          ball->velocity = pVect(0,0,0);
          continue;
        }

      pVect force(0,0,0);

      // Gravitational Force
      //
      force += ball->mass * gravity_accel;

      // Spring Force from Neighbor Balls
      //
      /// SOLUTION -- Problem 1 -- Also check distance-2 neighbors.
      for ( int direction: { -2, -1, +1, +2 } )
        {
          const int n_idx = i + direction;  // Compute neighbor index.

          // Skip this neighbor if neighbor doesn't exit.
          //
          if ( n_idx < 0 ) continue;

          /// SOLUTION -- Problem 1 -- Take into account +2.
          if ( n_idx >= chain_length ) continue;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor( ball->position, neighbor_ball->position );

          // Get distance between balls using pNorm member magnitude.
          //
          const float distance_between_balls = ball_to_neighbor.magnitude;

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          /// SOLUTION -- Problem 1 -- Scale relaxed length by neighbor distance.
          const float spring_stretch =
            distance_between_balls - distance_relaxed * abs(direction);

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );


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

          force += spring_constant * spring_stretch * ball_to_neighbor;
        }

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // when spring constant is large for the time step.
      //
      ball->velocity += ( force / ball->mass ) * delta_t;

      // Air Resistance
      //
      const double fs = pow(1+opt_air_resistance,-delta_t);
      ball->velocity *= fs;
    }

  ///
  /// Update Position of Each Ball
  ///

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball->position += ball->velocity * delta_t;

      // Possible Collision with Platform
      //

      // Skip if collision impossible.
      //
      if ( !platform_collision_possible(ball->position) ) continue;
      if ( ball->position.y >= 0 ) continue;

      // Reflect y (vertical) component of velocity, with a reduction
      // due to energy lost in the collision.
      //
      if ( ball->velocity.y < 0 )
        ball->velocity.y = - 0.9 * ball->velocity.y;
    }
}

 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu_orig(double delta_t)
{
  time_step_count++;

  //
  /// Compute force and update velocity of each ball.
  //
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Skip locked balls.
      //
      if ( opt_head_lock && i == 0 || opt_tail_lock && i == chain_length - 1 )
        {
          ball->velocity = pVect(0,0,0);
          continue;
        }

      pVect force(0,0,0);

      // Gravitational Force
      //
      force += ball->mass * gravity_accel;

      // Spring Force from Neighbor Balls
      //
      for ( int direction: { -1, +1 } )
        {
          const int n_idx = i + direction;  // Compute neighbor index.

          if ( n_idx < 0 ) continue;
          if ( n_idx == chain_length ) continue;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor( ball->position, neighbor_ball->position );

          // Get distance between balls using pNorm member magnitude.
          //
          const float distance_between_balls = ball_to_neighbor.magnitude;

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          const float spring_stretch =
            distance_between_balls - distance_relaxed;

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );


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

          force += spring_constant * spring_stretch * ball_to_neighbor;
        }

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // when spring constant is large for the time step.
      //
      ball->velocity += ( force / ball->mass ) * delta_t;

      // Air Resistance
      //
      const double fs = pow(1+opt_air_resistance,-delta_t);
      ball->velocity *= fs;
    }

  ///
  /// Update Position of Each Ball
  ///

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball->position += ball->velocity * delta_t;

      // Possible Collision with Platform
      //

      // Skip if collision impossible.
      //
      if ( !platform_collision_possible(ball->position) ) continue;
      if ( ball->position.y >= 0 ) continue;

      // Snap ball position to surface.
      //
      ball->position.y = 0;

      // Reflect y (vertical) component of velocity, with a reduction
      // due to energy lost in the collision.
      //
      if ( ball->velocity.y < 0 )
        ball->velocity.y = - 0.9 * ball->velocity.y;
    }
}

bool
World::platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.x >= platform_xmin && pos.x <= platform_xmax
    && pos.z >= platform_zmin && pos.z <= platform_zmax;
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
{ for(int i=0;i<chain_length;i++)balls[i].translate(amt);}
void World::balls_push(pVect amt)
{ for(int i=0;i<chain_length;i++)balls[i].push(amt);}
void World::balls_stop()
{ for(int i=0;i<chain_length;i++)balls[i].stop();}
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

      while ( world_time < world_time_target )
        {
          if ( opt_time_step_hw01 )
            time_step_cpu_hw01(time_step_duration);
          else
            time_step_cpu_orig(time_step_duration);
          world_time += time_step_duration;
        }

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

