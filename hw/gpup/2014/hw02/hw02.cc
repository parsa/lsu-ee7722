/// LSU EE 4702-1 (Fall 2014), GPU Programming
//
 /// Homework 2
 //
 /// Your Name:

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2014/hw02.pdf


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
 //  'w'    Turn twirling on and off. (Problem 2 solution.)
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
 //  '3'    Set up scene 3.
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

enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  void init_graphics();
  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();
  void render();
  void render_spiral0();
  void render_spiral1();
  void render_spiral2();
  void render_objects(Render_Option render_option);
  void cb_keyboard();
  void modelview_update();

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  double last_frame_wall_time;
  int time_step_count;
  float opt_gravity_accel;      // Value chosen by user.
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  bool opt_gravity;
  bool opt_head_lock, opt_tail_lock;
  bool opt_time_step_alt;
  int opt_vtx_method;
  int opt_segments;

  // Tiled platform for ball.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_pi_xwidth_inv;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  pVect platform_normal;
  GLuint texid_syl;
  GLuint texid_emacs;
  bool opt_platform_texture;
  void platform_update();
  bool platform_collision_possible(pCoor pos);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;
  bool opt_single_frame;      // Simulate for one frame.
  bool opt_single_time_step;  // Simulate for one time step.
  int viewer_shadow_volume;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix transform_mirror;

  void ball_setup_1();
  void ball_setup_2();
  void ball_setup_3();
  void ball_setup_4();
  void ball_setup_5();
  void time_step_cpu(double);
  void balls_stop();
  void balls_freeze();
  void balls_translate(pVect amt, int idx);
  void balls_translate(pVect amt);
  void balls_push(pVect amt, int idx);
  void balls_push(pVect amt);

  float opt_spring_constant;
  float opt_air_resistance;
  float distance_relaxed;
  int chain_length;
  Ball *balls;
  Sphere sphere;

  /// Problem 3: Items can be added here.

};



#include "hw02-graphics.cc"


void
World::init()
{
  chain_length = 18;
  balls = new Ball[chain_length];

  opt_segments = 50;
  variable_control.insert(opt_segments,"Number of segments per spiral.");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 1000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.001;

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  eye_location = pCoor(24.2,11.6,-38.7);
  eye_location = pCoor(18.9,11.6,-22.6);
  eye_direction = pVect(-0.42,-0.09,0.9);

  init_graphics();

  ball_setup_1();

  opt_vtx_method = 1;

  /// Problem 3:  Items can be added here.


}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

void
World::ball_setup_1()
{
  // Arrange and size balls to form a pendulum.
  //
  pCoor next_pos(5.2,15.8,-2.9);

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = next_pos;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.5 * distance_relaxed;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
      next_pos += pVect(distance_relaxed,0,0);
    }

  opt_tail_lock = false;
  opt_head_lock = true;
}


void
World::ball_setup_2()
{
  pCoor first_ball(20,11,-9.2);
  pCoor ref_pos(8,11,-9.2);

  const float radius = 0.3 * distance_relaxed;

  pNorm direction(first_ball,ref_pos);
  pVect delta_v = distance_relaxed * direction;

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = first_ball + i * delta_v;
      ball->velocity = pVect(0,0,0);
      ball->radius = radius;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  opt_head_lock = true;
  opt_tail_lock = true;
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
      for ( int direction = -1; direction <= +1; direction += 2 )
        {
          const int n_idx = i + direction;  // Compute neighbor index.
          if ( n_idx < 0 ) continue;
          if ( n_idx == chain_length ) break;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor(ball->position,neighbor_ball->position);

          const float distance_between_balls = ball_to_neighbor.magnitude;

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          const float spring_stretch =
            distance_between_balls - distance_relaxed;

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

pMatrix
make_transform(pCoor from_p1, pCoor from_p2, pCoor to_p1, pCoor to_p2)
{
  pNorm from_v12(from_p1,from_p2);
  pNorm to_v12(to_p1,to_p2);
  float scale_factor = to_v12.magnitude / from_v12.magnitude;
  pMatrix bo_to_orig = pMatrix_Translate(-pVect(from_p1));
  pMatrix scale = pMatrix_Scale(scale_factor);
  pMatrix rot = pMatrix_Rotation_Shortest(from_v12,to_v12);
  pMatrix orig_to_p1 = pMatrix_Translate(pVect(to_p1));
  pMatrix m = orig_to_p1 * rot * scale * bo_to_orig;
  return m;
}


void
World::render_spiral1()
{
  /// Modify for Problem 1 and 2.

  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_gold);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_purple);

  glEnable(GL_TEXTURE_2D);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  float theta_0 = 0;

  for ( int i=1; i<chain_length; i++ )
    {
      Ball *const ball1 = &balls[i-1];
      Ball *const ball2 = &balls[i];
      pCoor pos1 = ball1->position;
      pCoor pos2 = ball2->position;

      //
      // Render a spiral slide from position of ball1 to ball2.
      //
      const float omega = 10;

      pNorm v12(pos1,pos2);

      // Find a vector that's orthogonal to v12.
      //
      pNorm van =
        v12.x == 0 ? pVect(0,v12.z,-v12.y) : pVect(v12.y,-v12.x,0);

      pNorm vbn = cross(v12,van);

      pVect va = van * ball1->radius;
      pVect vb = vbn * ball1->radius;

      pCoor p_prev, p_outer_prev, p_inner_prev;
      const float v12_dist = v12.magnitude;
      pVect norm_prev, norm_inner_prev;

      const float delta_t = 1.0 / opt_segments;

      for ( float t=0; t<1.001; t += delta_t )
        {
          const bool last_iter = t + delta_t > 1.001;
          const float dist = t * v12_dist;
          pCoor p = ball1->position + dist * v12;
          const float theta = theta_0 + dist * omega;
          if ( last_iter ) theta_0 = theta;
          pCoor p_outer = p + va * cos(theta) + vb * sin(theta);
          const float inner_frac = 0.5;
          pCoor p_inner = p
            + inner_frac * va * cos(theta) + inner_frac * vb * sin(theta);
          pVect tang = v12
            - v12_dist * omega * va * sin(theta)
            + v12_dist * omega * vb * cos(theta);
          pVect tang_inner = v12
            - inner_frac * v12_dist * omega * va * sin(theta)
            + inner_frac * v12_dist * omega * vb * cos(theta);
          pNorm norm = cross(tang,pVect(p_outer,p));
          pNorm norm_inner = cross(tang_inner,pVect(p_outer,p));
          if ( t > 0 )
            {
              glBegin(GL_TRIANGLES);

              glTexCoord2f(0,0);
              glNormal3fv(norm_inner);
              glVertex3fv(p_inner);
              glTexCoord2f(0,1);
              glNormal3fv(norm_inner_prev);
              glVertex3fv(p_inner_prev);
              glTexCoord2f(1,1);
              glNormal3fv(norm_prev);
              glVertex3fv(p_outer_prev);

              glTexCoord2f(1,0);
              glNormal3fv(norm);
              glVertex3fv(p_outer);
              glTexCoord2f(0,0);
              glNormal3fv(norm_inner);
              glVertex3fv(p_inner);
              glTexCoord2f(1,1);
              glNormal3fv(norm_prev);
              glVertex3fv(p_outer_prev);
              glEnd();
            }
          p_prev = p;  p_outer_prev = p_outer;  norm_prev = norm;
          p_inner_prev = p_inner; norm_inner_prev = norm_inner;
        }
    }

  glEnable(GL_COLOR_MATERIAL);
}

void
World::render_spiral2()
{
  /// Modify for Problem 3.

  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_gold);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_purple);

  glEnable(GL_TEXTURE_2D);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  float theta_0 = 0;

  for ( int i=1; i<chain_length; i++ )
    {
      Ball *const ball1 = &balls[i-1];
      Ball *const ball2 = &balls[i];
      pCoor pos1 = ball1->position;
      pCoor pos2 = ball2->position;

      //
      // Render a spiral slide from position of ball1 to ball2.
      //
      const float omega = 10;

      pNorm v12(pos1,pos2);

      // Find a vector that's orthogonal to v12.
      //
      pNorm van =
        v12.x == 0 ? pVect(0,v12.z,-v12.y) : pVect(v12.y,-v12.x,0);

      pNorm vbn = cross(v12,van);

      pVect va = van * ball1->radius;
      pVect vb = vbn * ball1->radius;

      pCoor p_prev, p_outer_prev, p_inner_prev;
      const float v12_dist = v12.magnitude;
      pVect norm_prev, norm_inner_prev;

      const float delta_t = 1.0 / opt_segments;

      for ( float t=0; t<1.001; t += delta_t )
        {
          const bool last_iter = t + delta_t > 1.001;
          const float dist = t * v12_dist;
          pCoor p = ball1->position + dist * v12;
          const float theta = theta_0 + dist * omega;
          if ( last_iter ) theta_0 = theta;
          pCoor p_outer = p + va * cos(theta) + vb * sin(theta);
          const float inner_frac = 0.5;
          pCoor p_inner = p
            + inner_frac * va * cos(theta) + inner_frac * vb * sin(theta);
          pVect tang = v12
            - v12_dist * omega * va * sin(theta)
            + v12_dist * omega * vb * cos(theta);
          pVect tang_inner = v12
            - inner_frac * v12_dist * omega * va * sin(theta)
            + inner_frac * v12_dist * omega * vb * cos(theta);
          pNorm norm = cross(tang,pVect(p_outer,p));
          pNorm norm_inner = cross(tang_inner,pVect(p_outer,p));
          if ( t > 0 )
            {
              glBegin(GL_TRIANGLES);

              glTexCoord2f(0,0);
              glNormal3fv(norm_inner);
              glVertex3fv(p_inner);
              glTexCoord2f(0,1);
              glNormal3fv(norm_inner_prev);
              glVertex3fv(p_inner_prev);
              glTexCoord2f(1,1);
              glNormal3fv(norm_prev);
              glVertex3fv(p_outer_prev);

              glTexCoord2f(1,0);
              glNormal3fv(norm);
              glVertex3fv(p_outer);
              glTexCoord2f(0,0);
              glNormal3fv(norm_inner);
              glVertex3fv(p_inner);
              glTexCoord2f(1,1);
              glNormal3fv(norm_prev);
              glVertex3fv(p_outer_prev);
              glEnd();
            }
          p_prev = p;  p_outer_prev = p_outer;  norm_prev = norm;
          p_inner_prev = p_inner; norm_inner_prev = norm_inner;
        }
    }

  glEnable(GL_COLOR_MATERIAL);
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
