/// LSU EE 4702-1 (Fall 2014), GPU Programming
//
 /// Homework 4
 //
 /// DO NOT MODIFY THIS FILE.
 //
 //  Use file hw04-shdr.cc for your solution.
 //
 //  Contact the instructor if you believe that something in this file
 //  needs to be modified to solve a problem.

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2014/hw04.pdf
 //
 //  Edit the code in hw04-shdr.cc.


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
 //  'm'    Switch between rendering methods.
 //  'd'    Toggle debug Boolean, debug_bool.x in shader code.
 //  'D'    Toggle debug Boolean, debug_bool.y in shader code.

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
 //  VAR Number of segments per spiral.
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

enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };

class World {
public:
  World(pOpenGL_Helper &fb, int argc, char **argv):ogl_helper(fb)
  {init(argc,argv);}
  void init(int argc, char **argv);
  void init_graphics();
  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();
  void render();
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
  pCoor *balls_pos;
  Sphere sphere;

  bool opt_debug_x, opt_debug_y;
  float opt_debug_float;

  GLuint balls_bo;
  GLuint indices_bo;
  int indices_segments; // Number of segments used to generate indices bo.
  pShader *vs_fixed;
  pShader *vs_geo_simple;
  pShader *vs_geo_sol;
};


#include "hw04-graphics.cc"

void
World::init(int argc, char **argv)
{
  indices_segments = -1;
  balls_bo = 0;
  indices_bo = 0;
  chain_length = 18;
  balls = new Ball[chain_length];
  balls_pos = new pCoor[chain_length];

  opt_segments = 50;
  variable_control.insert(opt_segments,"Number of segments per spiral.");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 1000;
  // variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  // variable_control.insert(opt_gravity_accel,"Gravity");

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

  opt_debug_x = opt_debug_y = false;
  opt_debug_float = 1.0;
  variable_control.insert(opt_debug_float,"Debug Float");


  PSplit exe_pieces(argv[0],'/');
  pString this_exe_name(exe_pieces.pop());
  
  const char* const shader_code_file =
    this_exe_name == "hw04sol" ? "hw04-shdr-sol.cc" : "hw04-shdr.cc";

  vs_geo_simple = 
    new pShader
    (shader_code_file,
     "vs_main();", "gs_main_simple();", "fs_main();");
  vs_geo_sol = 
    new pShader
    (shader_code_file,
     "vs_main();", "gs_main_solution();", "fs_main();");
  vs_fixed = new pShader();
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


void
World::render_spiral1()
{
  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_purple);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_lsu_spirit_gold);

  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  float theta = 0;
  const float spiral_radius = 0.5;
  const float delta_t = 1.0 / opt_segments;
  const float omega = 10;

  glBegin(GL_TRIANGLE_STRIP);

  for ( int i=1; i<chain_length; i++ )
    {
      Ball *const ball1 = &balls[i-1];
      Ball *const ball2 = &balls[i];
      pCoor pos1 = ball1->position;
      pCoor pos2 = ball2->position;

      //
      // Render a spiral slide from position of ball1 to ball2.
      //

      pVect v12 = pos2 - pos1;

      // Find a vector that's orthogonal to v12.
      //
      pNorm ax = v12.x == 0 ? pVect(0,v12.z,-v12.y) : pVect(v12.y,-v12.x,0);
      pNorm ay = cross(v12,ax);

      pVect vx = ax * spiral_radius;
      pVect vy = ay * spiral_radius;

      for ( float t=0; t<0.999; t += delta_t )
        {
          pCoor p = pos1 + t * v12;
          theta += delta_t * omega;

          // Compute a vector from the spiral axis to a point on the spiral.
          //
          pVect radial = vx * cos(theta) + vy * sin(theta);

          // Find a vector in the "direction" of the spiral motion as
          // if t were time.
          //
          pVect tangial = -omega * vx * sin(theta) + omega * vy * cos(theta);
          //
          // Note: expression above is derivative of radial w.r.t. t.

          pCoor p_outer = p + radial;
          const float inner_frac = 0.5;
          pCoor p_inner = p + inner_frac * radial;
          pVect tang = v12 + tangial;
          pVect tang_inner = v12 + inner_frac * tangial;

          // Compute a vector pointing up.
          //
          pNorm norm = cross(radial,tang);
          pNorm norm_inner = cross(radial,tang_inner);

          const float du = 0.5 / chain_length;
          const float u = float(i) * du;

          glTexCoord2f(t,u+du);
          glNormal3fv(norm_inner);
          glVertex3fv(p_inner);

          glTexCoord2f(t,u);
          glNormal3fv(norm);
          glVertex3fv(p_outer);
        }
    }

  glEnd();

  vs_fixed->use();

  glEnable(GL_COLOR_MATERIAL);
}

void
World::render_spiral2()
{
  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_FRONT,GL_DIFFUSE,color_lsu_spirit_gold);
  glMaterialfv(GL_FRONT,GL_AMBIENT,color_gray);
  glMaterialfv(GL_BACK,GL_DIFFUSE,color_lsu_spirit_purple);

  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  if ( !balls_bo ) glGenBuffers(1, &balls_bo);
  glBindBuffer(GL_ARRAY_BUFFER, balls_bo);
  for ( int i=0; i<chain_length; i++ ) balls_pos[i] = balls[i].position;
  glBufferData
    (GL_ARRAY_BUFFER,chain_length*sizeof(balls_pos[0]),
     balls_pos, GL_DYNAMIC_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  const int num_elts = ( chain_length - 1 ) * opt_segments * 2;

  if ( !indices_bo ) glGenBuffers(1, &indices_bo );

  if ( indices_segments != opt_segments )
    {
      indices_segments = opt_segments;
      struct ivec3 { int i, j, k; ivec3(){}; ivec3(int ip, int jp, int kp):i(ip),j(jp),k(kp){}};
      ivec3* const indices = new ivec3[ num_elts ];
      ivec3 *ip = indices;
      for ( int i=1; i<chain_length; i++ )
        for ( int t=0; t<opt_segments; t++ )
          for ( int inner=0; inner<2; inner++ )
            *ip++ = ivec3(i,t,inner);
      glBindBuffer(GL_ARRAY_BUFFER, indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         num_elts * sizeof(indices[0]),
         indices,
         GL_STATIC_DRAW);
      delete indices;
    }

  if ( opt_vtx_method == 1 )
    vs_geo_simple->use();
  else
    vs_geo_sol->use();

  glColor3fv(color_powder_blue);

  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,1,balls_bo);
  glUniform1i(1,opt_segments);
  glUniform1i(2,chain_length);
  glUniform2i(3,opt_debug_x,opt_debug_y);
  glUniform1f(4,opt_debug_float);

  glBindBuffer(GL_ARRAY_BUFFER, indices_bo);
  glVertexPointer(3,GL_INT,3*sizeof(int),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  glDrawArrays(GL_TRIANGLE_STRIP, 0, num_elts );

  glDisableClientState(GL_VERTEX_ARRAY);
  vs_fixed->use();
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
main(int argc, char **argv)
{
  pOpenGL_Helper popengl_helper(argc,argv);
  World world(popengl_helper,argc,argv);

  popengl_helper.ogl_debug_set(false);
  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
