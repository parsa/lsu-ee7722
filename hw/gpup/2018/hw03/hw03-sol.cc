/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 /// Homework 3 -- SOLUTION and Pre-Final Problem 1 Code
 //
 //  Search for SOLUTION in this file to find solution code.
 //  The pre-final Problem 1 solution is in file pre-fin-shdr.cc.

 /// Instructions -- Homework 3
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2018/hw03.pdf
 //
 //  Modify the code in routine hw03_render.
 //
 //  This file and hw03-shdr.cc will be collected.

 /// Instructions -- Pre-Final Problem 1
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2018/mt.pdf
 //
 //  Modify code in pre-fin-shdr.cc.
 //  The pre-final solution was not to be automatically collected.



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

#include <GL/gl.h>
#include <GL/freeglut.h>

#include <gp/util.h>
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

#include "hw03-graphics.cc"


void
World::init()
{
  chain_length = 7;
  balls = new Ball[chain_length];

  variable_control.insert_linear(opt_tryoutf,"Tryout F",0.1);

  opt_n_segs = 17;
  variable_control.insert(opt_n_segs,"Number of louver segments.");
 
  distance_relaxed = 30.0 / chain_length;
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

  curr_setup = 1; ball_setup_1();
}

void
World::hw03_render(bool shadows)
{
  // Homework 3 -- Problem 2, and maybe other problems.

  switch ( opt_shader ){
  case SO_Fixed: sp_fixed->use(); break;
  case SO_Plain: sp_plain->use(); break;
  case SO_HW03: sp_hw03->use(); break;
  default: assert( false );
  }

  pColor color_inside = 0.5 * color_salmon;
  pColor color_outside = 0.5 * color_chartreuse;

  if ( opt_shader != SO_Fixed )
    {
      glUniform2i(3, opt_tryout_1, opt_tryout_2);
      glUniform1f(4, opt_tryoutf);
    }

  if ( opt_shader == SO_Plain )
    {
      glColor3fv( color_outside );
    }
  else
    {
      glDisable(GL_COLOR_MATERIAL); // Don't worry about re-enabling it.
      glMaterialfv( GL_FRONT, GL_AMBIENT_AND_DIFFUSE, color_inside );
      glMaterialfv( GL_BACK, GL_AMBIENT_AND_DIFFUSE, color_outside );
    }

  glEnable(GL_TEXTURE_2D);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D,texid_spiral_image);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  for ( int i=2; i<chain_length; i++ )
    {
      // Put ball structures and coordinates into convenient variables.
      //
      Ball* const b0 = &balls[i-2];
      Ball* const b1 = &balls[i-1];
      Ball* const b2 = &balls[i-0];
      pCoor p0 = b0->position;
      pCoor p1 = b1->position;
      pCoor p2 = b2->position;

      // Compute location of triangle center.
      //
      pCoor ctr = (p0+p1+p2)/3;

      // Compute vectors from triangle center to each ball location ..
      // .. and put in array va.
      //
      pCoor pa[3] = {p0,p1,p2};
      vector<pVect> va;
      for ( auto& p: pa ) va.emplace_back( ctr, p );

      pNorm nz = cross(p0,p1,p2);
      const float vz_len = is_pre_fin ? 0.3 : 0.1;
      pVect vz = vz_len * nz;

      const float delta_a = ( is_pre_fin ? 0.6 : 0.8 ) / opt_n_segs;

      // Coordinate of previous position in triangular spiral.
      //
      pCoor pprev = ctr;

      /// SOLUTION -- Problem 2
      //
      //  Choose scaling factors for texture image.
      //
      const float tex_scale = 0.2;
      const float tex_ht = 2 * vz_len * tex_scale;
      //
      //  Start the position within the texture image at the
      //  upper-left corner. For Problem 2a the y component is
      //  computed further below. For Problem 2b the y component is
      //  computed in the fragment shader.
      //
      float tex_x = 0;

      /// SOLUTION -- Problem 2 and 3
      //
      if ( opt_shader == SO_HW03 )
        {
          // Send the spiral normal needed for Problem 3.
          //
          glUniform3fv(5, 1, nz);

          // Send the texture height used in Problem 2.
          //
          glUniform1f(6, tex_ht);
        }

      if ( opt_shader != SO_HW03 )
        {
          /// Small Strips Rendering
          //
          // Render spiral using many triangle strips ..
          // .. one triangle strip for each louver.
          //

          for ( int j=0; j<opt_n_segs; j++ )
            {
              // Distance from triangle center.
              //
              const float a = j * delta_a;

              // The vector to use for the current iteration.
              //
              pVect v = va[j%3];

              // Compute point on bend of spiral, and its normal.
              //
              pCoor p = ctr + a * v;
              pNorm n = cross(pVect(pprev,p),vz);

              if ( j )
                {
                  /// SOLUTION -- Problem 2a
                  //
                  //  Compute the length of the segment. This determines
                  //  how wide a piece of the texture image is used.
                  //
                  const float llen = pVect(p,pprev).mag();

                  /// SOLUTION -- Problem 2a
                  //
                  //  Set the y coordinate based on the x coordinate.
                  //
                  const float tex_y = tex_ht * floor(tex_x);

                  glBegin(GL_TRIANGLE_STRIP);
                  glNormal3fv(n);

                  /// SOLUTION -- Problem 2a -- provide texture coordinate.
                  glTexCoord2f( tex_x, tex_y );
                  glVertex3fv(pprev + vz);

                  /// SOLUTION -- Problem 2a -- provide texture coordinate.
                  glTexCoord2f( tex_x, tex_y + tex_ht );
                  glVertex3fv(pprev - vz);

                  /// SOLUTION -- Problem 2a
                  //
                  //  Advance texture x component based on length of
                  //  segment.
                  //
                  tex_x += llen * tex_scale;

                  /// SOLUTION -- Problem 2a -- provide texture coordinate.
                  glTexCoord2f( tex_x, tex_y );
                  glVertex3fv(p + vz);

                  /// SOLUTION -- Problem 2a -- provide texture coordinate.
                  glTexCoord2f( tex_x, tex_y + tex_ht );
                  glVertex3fv(p - vz);
                  glEnd();

                }
              pprev = p;
            }
        }
      else
        {
          /// Large Strip Rendering
          //
          // Render entire spiral using one triangle strip.
          //

          glBegin(GL_TRIANGLE_STRIP);

          for ( int j=0; j<opt_n_segs; j++ )
            {
              // Distance from triangle center.
              //
              const float a = j * delta_a;

              // The vector to use for the current iteration.
              //
              pVect v = va[j%3];

              // Compute point on bend of spiral, and its normal.
              //
              pCoor p = ctr + a * v;
              pNorm n = cross(pVect(pprev,p),vz);

              glNormal3fv(n);

              /// SOLUTION -- Problem 2b
              //
              //  The texture x component is computed in the same way
              //  as for Problem 2a: it is incremented by the width of
              //  the segment.
              //
              //  However, the texture y component is either 0 or 1.
              //  The fragment shader will compute the correct value
              //  based on the value of the x component.


              /// SOLUTION -- Problem 2b -- provide texture coordinate.
              glTexCoord2f(tex_x,0);
              glVertex3fv(p + vz);

              /// SOLUTION -- Problem 2b -- provide texture coordinate.
              glTexCoord2f(tex_x,1);
              glVertex3fv(p - vz);

              /// SOLUTION -- Problem 2b
              //
              //  Advance texture x component based on length of segment.
              //
              const float llen = pVect(p,pprev).mag();
              tex_x += llen * tex_scale;

              pprev = p;
            }

          glEnd();
        }
  }

  sp_fixed->use();
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

  pNorm dir(0.1,1,0.2);

  pCoor bottom_pos(12.5,distance_relaxed,-13.7);

  pNorm ax = dir.x ? pVect(-dir.y,dir.x,0) : pVect(0,-dir.z,dir.y);
  pVect leg_x = distance_relaxed * powf(0.75,0.5) * ax;
  pVect leg_y = distance_relaxed * 0.5f * dir;

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[chain_length-i-1];

      ball->position = bottom_pos + i * leg_y + ( i & 1 ) * leg_x;

      ball->velocity = pVect(0,0,0);
      ball->radius = 0.1 * distance_relaxed;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  opt_head_lock = true;
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
      for ( int direction: { -2, -1, +1, +2 } )
        {
          const int n_idx = i + direction;  // Compute neighbor index.

          // Skip this neighbor if neighbor doesn't exit.
          //
          if ( n_idx < 0 ) continue;

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
  World world(popengl_helper,argv,argc);
# ifdef __OPTIMIZE__
  glDisable(GL_DEBUG_OUTPUT);
# else
  glEnable(GL_DEBUG_OUTPUT);
# endif
  glDebugMessageControl(GL_DONT_CARE,GL_DONT_CARE,
                        GL_DEBUG_SEVERITY_NOTIFICATION,0,NULL,false);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
