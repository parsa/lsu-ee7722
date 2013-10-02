/// LSU EE 4702-1 (Fall 2013), GPU Programming
//
 /// Homework 2
 //
 /// Your Name:

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2013/hw02.pdf


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
 //  'v'    Switch between using "proba" and "probb" version of cone.
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
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
 //  VAR Level of Detail - Set level of detail to be used for cone. (opt_lod)
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

int opt_lod;
bool opt_use_buffer_objects;

class Cone {
public:
  Cone(){
    apex_radius = 0.1; 
    dont_set_color = true;
  };
  void render_shadow_volume(pCoor base, float radius, pVect to_apex){}
  void render(pCoor base, float radius, pVect to_apex)
    {
      if ( opt_use_buffer_objects )
        render_probb(base,radius,to_apex);
      else
        render_proba(base,radius,to_apex);
    }
  void render_proba(pCoor base, float radius, pVect to_apex)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_height = 1;
    const double alpha = atan2(apex_height,base_radius-apex_radius);
    const double vec_z = sin(alpha);
    const float to_height = to_apex.mag();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pNorm rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);
    pMatrix_Translate trans_transl(base);
    pMatrix_Rotation trans_rot(rn,rot_angle);
    pMatrix_Scale trans_scale(radius); 
    trans_scale.rc(2,2) = to_height;
    pMatrix xform = trans_transl * trans_rot * trans_scale;

    glMultTransposeMatrixf(xform.a);

    if ( !dont_set_color ) glColor3fv(color);

    glBegin(GL_QUAD_STRIP);
    for ( int i=0; i<=sides; i++ )
      {
        const double theta = delta_theta * i;
        const double cos_t = cos(theta);
        const double sin_t = sin(theta);
        glNormal3f( cos_t, sin_t, vec_z );
        glVertex3f( apex_radius * cos_t, apex_radius * sin_t, apex_height);
        glVertex3f( base_radius * cos_t, base_radius * sin_t, 0);
      }
    glEnd();

    glPopMatrix();
  }
  void render_probb(pCoor base, float radius, pVect to_apex)
    {
      PStack<float> floats;
      for ( float f = 0; f < 10; f++ ) floats += f;
      float* farray = floats.get_storage();
      static bool msg = false;
      if ( !msg ) printf("Element 3: %f\n", farray[3]);
      msg = true;
      // Note: array will be freed when routine returns. 
      // Use take_storage if you want farray to not be freed.
    }

  void set_color(const pColor &c) { color = c;  dont_set_color = false; }

  bool dont_set_color;
  pColor color;
  pCoor light_pos;
  double apex_radius;
};


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
  float radius;
  bool contact;
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

#include "hw2-graphics.cc"


void
World::init()
{
  opt_lod = 1;
  variable_control.insert(opt_lod,"Level of Detail",1,1);

  opt_use_buffer_objects = false;

  chain_length = 10;
  balls = new Ball[chain_length];
 
  distance_relaxed = 25 / chain_length;
  opt_spring_constant = 1000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.001;
  variable_control.insert(opt_air_resistance,"Air Resistance");  

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  init_graphics();

  light_location = pCoor(30.8,12.8,-9.9);

  cone_fixed.set_color(color_chocolate);
  cone_fixed_position = pCoor(28.5,0,-8.4);
  cone_fixed_radius = 3;
  cone_fixed_height = 40;

  ball_setup_2();
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
  pCoor next_pos(12.5,0.1,-13.7);

  for ( int i=0; i<chain_length; i++ )
    {
      // Put the first ball on top because that one can be moved and locked.
      //
      Ball* const ball = &balls[chain_length-i-1];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.5;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
      next_pos += pVect(0.1,distance_relaxed,0);
    }
}

void
World::ball_setup_2()
{
  // Arrange and size balls to form a pendulum.
  //
  pCoor next_pos(13.4,21.8,-9.2);

  for ( int i=0; i<chain_length; i++ )
    {
      // Put the first ball on top because that one can be moved and locked.
      //
      Ball* const ball = &balls[i];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->radius = i == chain_length - 1 ? 1 : 0.5;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
      next_pos += pVect(distance_relaxed,0,0);
    }

  opt_head_lock = true;
}

void
World::ball_setup_3()
{
}

void
World::ball_setup_4()
{
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
      for ( int n_idx = i-1; n_idx <= i+1; n_idx += 2 )
        {
          if ( n_idx < 0 ) continue;
          if ( n_idx == chain_length ) break;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor(ball->position,neighbor_ball->position);

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );

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
          time_step_cpu(time_step_duration);
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
