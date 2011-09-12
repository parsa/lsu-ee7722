/// LSU EE 4702-1 (Fall 2011), GPU Programming
//
 /// Simple Demo of Point Masses and Springs

// $Id:$

/// Purpose
//
//   Demonstrate simulation of string modeled as point masses and springs


/// What Code Does

// Simulates a string bouncing over a platform. The string is modeled
// as point masses connected by springs with motion damped by air
// resistance. The platform consists of tiles, some are purple-tinted
// mirrors (showing a reflection of the ball), the others show the
// course syllabus. The ball and the shape of the platform can be
// manipulated by the user.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move ball. (Change position but not velocity.)
 //   'B': Push ball. (Add velocity.)
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
 //  'p'    Pause simulation. (Press again to resume.)
 //  'k'    Freeze position of end of string. (Press again to release.)
 //  's'    Stop ball.
 //  'S'    Freeze ball. (Set velocity of all vertices to zero.)
 //  'g'    Turn gravity on and off.
 //  'f'    Toggle between flat and curved platform.
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
 //  VAR Light Intensity - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)
 //  VAR Platform Depth - Adjust depth of curved platform. (On/off suing 'f'.)


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
  float mass, mass_inv;
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

#include "demo-2-springs-graphics.cc"


void
World::init()
{
  chain_length = 20;
  balls = new Ball[chain_length];

  distance_natural = 1;
  opt_spring_constant = 20;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  ball_init();

  world_time = 0;
  frame_timer.work_unit_set("Steps / s");

  init_graphics();
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//
void
World::ball_init()
{
  // Set initial position to a visibly interesting point.
  //
  pCoor next_pos(13.7,22,-15.4);
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->mass = i == 0 ? 10 : 1;
      next_pos += pVect(distance_natural,0,0);
    }
}

 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu(double delta_t)
{
  //
  /// Compute force and update velocity of each ball.
  //
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      pVect force(0,0,0);

      // Gravitational Force
      //
      force += ball->mass * gravity_accel;

      // Spring Force from Neighbor Balls
      //
      for ( int n_idx = i-1; n_idx <= i+1; n_idx += 2 )
        {
          if ( n_idx < 0 ) continue;
          if ( n_idx == chain_length ) break;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor(ball->position,neighbor_ball->position);

          // Compute how much the spring is stretched.
          //
          const float spring_stretch =
            ball_to_neighbor.magnitude - distance_natural;

          force += opt_spring_constant * spring_stretch * ball_to_neighbor;
        }

      // Air Resistance
      //
      const float air_resistance = 0.02;
      pVect ar_force  = -pow(1.0 - air_resistance,delta_t) * ball->velocity;
      force += ar_force;

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // which tight springs (large opt_spring_constant) and long time
      // steps (large delta_t).
      //
      ball->velocity += ( force / ball->mass ) * delta_t;
    }

  ///
  /// Update Position of Each Ball
  ///

  // Skip first ball if head_lock option true.
  //
  const int ball_first_idx = opt_head_lock ? 1 : 0;

  for ( int i=ball_first_idx; i<chain_length; i++ )
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

  if ( opt_pause || world_time == 0 )
    {
      /// Don't change simulation state.
      //
      world_time = time_now;
    }
  else
    {
      /// Advance simulation state by wall clock time.
      //
      const double delta_t = time_now - world_time;
      time_step_cpu(delta_t);
      world_time += delta_t;
    }

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

