/// LSU EE 4702-1 (Fall 2009), GPU Programming
///
/// Homework 2

 /// Due:   Friday, 9 October 2009
 //  E-mail this file (with solution).


 /// Team Member Names
 /// Name:
 /// Name:
 /// Name:
 /// Name:


/// Instructions

// Follow the class account setup instructions linked to the
// class procedures page, http://www.ece.lsu.edu/koppel/gpup/proc.html

// For instructions on how to check out edit, compile, and debug, see
// the "Programming Homework Work Flow" entry on the procedures page,
// http://www.ece.lsu.edu/koppel/gpup/proc.html .
//
// For those instructions you need to know that:
//
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/hw2
//
//  The assignment instructions are in file hw2.cc. (This file.)

// For the solutions to the problems below edit this file, even if
// it makes more sense to edit others (e.g.,, coord.h). If it seems
// that come other file must be edited, contact me.

 /// Please:  Do not make unnecessary changes, such as formatting.
 //  Solutions will be graded by comparing your submission to the
 //  original using a 'diff' program.  Doing things like renaming
 //  a variable or changing indentation but making no "real" changes
 //  to a region of code will make it harder to find regions with "real"
 //  changes.


/// Coding Guidelines

// [ ] Use pVect, pCoor, pNorm where possible.
// [ ] Code should be clear and easy to read.
// [ ] Don't name a variable temp unless it's related to temperature.
// [ ] Follow surrounding style, including indentation and naming.
// [ ] Lines should be no more than 80 characters.
// [ ] Frequently-executed code should be fast.


/// Problem 1
//
 /// Show seams graphically.

// Show graphically the seam between tiles that was just in the
// physical model of Homework 1. The graphical representation should
// make it easy to see when the ball hits a seam. It would also be
// nice if it looked like some kind of seam, say grout or some kind of
// separator.

// [ ] Pre-compute an array of coordinates for the seam in platform_update.
// [ ] Choose colors and other styling appropriate for the seam.
// [ ] Code should be clean and fast.


/// Problem 2
//
 /// Improve Homework 1 Physics

// Re-solve homework 1 so that the ball bounces as it hits the
// seam and does so in a realistic manor.

// [ ] Don't compute the distance from the ball to axis more than once.
// [ ] Reflect velocity of ball based on point of impact.


/// Problem 3
//
 /// Show some indication of ball impact on seam.

// Change the appearance of the seam to indicate location ball impact.
// The change in appearance should be at the correct location
// and should be interesting to look at.

// [ ] Change in appearance with impact.

 /// Optional

// [ ] Base change in appearance on speed and angle of ball impact.
// [ ] Have change fade with time.




/// What Code Does

// Simulates balls bouncing over a curved platform. The platform
// consists of tiles and the shape is a half cylinder.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move a ball. (Change position but not velocity.)
 //   'B': Push a ball. (Add velocity.)
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
 //  'x'    Release another ball. (Try holding it in.)
 //  'n'    Toggle visibility of platform normals.
 //  's'    Stop balls.
 //  'g'    Turn gravity on and off.
 //  'F11'  Change size of text.
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
 //  VAR Ball Radius


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
  Ball();
  pCoor position;
  pVect velocity;

  bool contact;                 // If true, in contact with platform.
  int row_num, col_num;         // Refers to tile.

  pVect axis;                   // Direction of ball's axis.
  double angle;                 // Angle around axis.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void cb_keyboard();
  void modelview_update();

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  float opt_gravity_accel;      // Value chosen by user.
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  bool opt_gravity;

  float opt_ball_radius;

  // Tiled platform for ball.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_xmid, platform_xrad, platform_xrad_inv;
  float delta_theta_inv, tile_size_inv;
  float platform_pi_xwidth_inv;
  pBuffer_Object<pVect> platform_tile_norms;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  GLuint texid_syl;
  GLuint texid_emacs;
  bool opt_normals_visible;
  void platform_update();
  bool platform_collision_possible(pCoor pos);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_shadow;

  double ball_countdown;

  void ball_init();
  void balls_render();
  void balls_stop();
  void time_step_cpu(double);
  void time_step_cpu_ball(double delta_t, Ball* ball);

  PStack<Ball*> balls;
  Sphere sphere;
  Cone cone;                    // Used to show platform normals.
};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  world_time = 0;
  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  opt_normals_visible = false;

  eye_location = pCoor(17.9,-2,117.2);
  eye_direction = pVect(-0.15,-0.06,-0.96);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  texid_syl = pBuild_Texture_File("gpup.png",false,255);
  texid_emacs = pBuild_Texture_File("mult.png", false,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(28.2,-2.8,-14.3);

  opt_ball_radius = 2;

  variable_control.insert(opt_gravity_accel,"Gravity");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_ball_radius,"Ball Radius");

  opt_move_item = MI_Eye;
  opt_pause = false;

  ball_countdown = 1e10;
  balls += new Ball();
  sphere.init(40);   // Argument indicates amount of detail.
  sphere.radius = opt_ball_radius;

  platform_update();
  modelview_update();

}

void
World::platform_update()
{
  const float tile_count = 19;
  const float ep = 1.00001;
  const float platform_delta_x = platform_xmax - platform_xmin;
  const float zdelta = ( platform_zmax - platform_zmin ) / tile_count * ep;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<pVect> p_tile_norms;
  PStack<pVect> p1_tile_norms;
  PStack<float> p_tex_coords;
  bool even = true;
  platform_pi_xwidth_inv = M_PI / platform_delta_x;

  const double delta_theta = M_PI / tile_count;
  delta_theta_inv = 1.0 / delta_theta;
  tile_size_inv = 1 / zdelta;
  platform_xmid = 0.5 * ( platform_xmax + platform_xmin );
  platform_xrad = 0.5 * platform_delta_x;
  platform_xrad_inv = 1 / platform_xrad;

  for ( int i = 0; i < tile_count; i++ )
    {
      const double theta0 = i * delta_theta;
      const double theta1 = theta0 + delta_theta;
      const float x0 = platform_xmid - platform_xrad * cos(theta0);
      const float x1 = platform_xmid - platform_xrad * cos(theta1);
      const float y0 = -0.01 - platform_xrad * sin(theta0);
      const float y1 = -0.01 - platform_xrad * sin(theta1);
      pVect norm0( cos(theta0), sin(theta0), 0);
      pVect norm1( cos(theta1), sin(theta1), 0);
      for ( float z = platform_zmin; z < platform_zmax; z += zdelta )
        {
          PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
          PStack<pVect>& t_norms = even ? p_tile_norms : p1_tile_norms;
          p_tex_coords += trmax; p_tex_coords += tsmax;
          t_coords += pVect(x0,y0,z);
          t_norms += norm0;  t_norms += norm0;
          p_tex_coords += trmax; p_tex_coords += tsmin;
          t_coords += pVect(x0,y0,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmin;
          t_coords += pVect(x1,y1,z+zdelta);
          t_norms += norm1;  t_norms += norm1;
          p_tex_coords += trmin; p_tex_coords += tsmax;
          t_coords += pVect(x1,y1,z);
          even = !even;
        }
    }

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;
  while ( pVect* const v = p1_tile_norms.iterate() ) p_tile_norms += *v;

  platform_tile_norms.re_take(p_tile_norms);
  platform_tile_norms.to_gpu();
  platform_tile_coords.re_take(p_tile_coords);
  platform_tile_coords.to_gpu();
  platform_tex_coords.re_take(p_tex_coords);
  platform_tex_coords.to_gpu();
}

void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}


///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

Ball::Ball()
{
  position = pCoor(30,22,-15.4);
  velocity = pVect(random()/(0.0+RAND_MAX),0,random()/(0.0+RAND_MAX));
  axis = pNorm(0,1,0);
  angle = 0;
}


bool
World::platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.y < opt_ball_radius
    && pos.x >= platform_xmin && pos.x <= platform_xmax
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
void World::balls_stop()
{
  for ( Ball *ball; balls.iterate(ball); ) ball->stop();
}

void
World::time_step_cpu(double delta_t)
{
  const float deep = -100;

  // Iterate over balls.
  //
  for ( Ball *ball; balls.iterate(ball); )
    {
      // Simulate ball.
      //
      time_step_cpu_ball(delta_t,ball);

      // Remove ball if it has fallen too far.
      //
      if ( ball->position.y < deep ) { balls.iterate_yank(); delete ball; }

    }

  // Possibly add more balls to simulation.
  //
  ball_countdown -= delta_t;
  if ( ball_countdown <= 0 || balls.occ() == 0 )
    {
      balls += new Ball();
      ball_countdown = 1e10;
    }
}

void
World::time_step_cpu_ball(double delta_t, Ball* ball)
{
  // Compute new ball position, accounting for current speed and
  // acceleration, and assuming no collision.
  //
  ball->position +=
    ball->velocity * delta_t + 0.5 * gravity_accel * delta_t * delta_t;

  // Compute new velocity, assuming no collision.
  //
  ball->velocity += gravity_accel * delta_t;

  // Return quickly if collision impossible.
  //
  if ( !platform_collision_possible(ball->position) ) return;

  // Compute y coordinate of platform under ball.
  //
  // Note that this is not really the closest point on the platform to the ball.
  //
  const float cos_th = ( platform_xmid - ball->position.x ) * platform_xrad_inv;
  const float sin_th =  sqrt(1.0 - cos_th * cos_th );
  const float platform_y = -platform_xrad * sin_th;

  const bool contact_prev = ball->contact;
  const bool true_contact = ball->position.y <= platform_y + 0.01;
  ball->contact = ball->position.y <= platform_y + 0.5;
  if ( !ball->contact ) return;

  ball->position.y = max(ball->position.y,platform_y);
  pVect platform_norm( cos_th, sin_th, 0);

  const int row_num_prev = ball->row_num;
  const int col_num_prev = ball->col_num;
  const int row_num = int(ball->position.z * tile_size_inv);
  const int col_num = int(acos(cos_th) * delta_theta_inv);
  ball->col_num = col_num;
  ball->row_num = row_num;
  if ( contact_prev &&
       ( row_num_prev != row_num || col_num_prev != col_num ) )
    {
      // Ball has rolled from one tile to another.
    }

  if ( !true_contact ) return;

  const float speed_to_surface = dot(platform_norm,ball->velocity);

  ball->velocity -= 1.9 * speed_to_surface * platform_norm;
}

void
World::balls_render()
{
  for ( Ball *ball; balls.iterate(ball); )
    sphere.render(ball->position,ball->axis,ball->angle);
}

void
World::render()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

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
      const double delta_t = min(1./20,time_now - world_time);
      time_step_cpu(delta_t);
      world_time += delta_t;
    }

  /// Emit a Graphical Representation of Simulation State
  //
  
  // Understanding of the code below not required for introductory
  // lectures.

  const pColor white(0xffffff);
  const pColor gray(0x303030);
  const pColor lsu_business_purple(0x7f5ca2);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);
  const pColor lsu_official_purple(0x2f0462);
  const pColor dark(0);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();

  glClearColor(0,0,0,0.5);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x999999);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

  pColor color_ball(0x666666);
  pColor scolor_ball(0x111111);
  const float shininess_ball = 5;

  // Common to all textures.
  //
  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
                  GL_LINEAR_MIPMAP_LINEAR);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  glEnable(GL_RESCALE_NORMAL);
  glEnable(GL_NORMALIZE);

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z);

  Ball& ball = *balls[0];
  ogl_helper.fbprintf
    ("Ball Pos  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]\n",
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  // Setup texture for platform.
  //
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  // Blend dark tiles with existing ball reflection.
  //
  glEnable(GL_STENCIL_TEST);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_CONSTANT_ALPHA,GL_ONE_MINUS_CONSTANT_ALPHA); // src, dst
  glBlendColor(0,0,0,0.5);

  glDepthFunc(GL_ALWAYS);

  glEnable(GL_TEXTURE_2D);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  platform_tile_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  platform_tile_norms.bind();
  glNormalPointer
    (GL_FLOAT,sizeof(platform_tile_norms.data[0]), 0);
  glEnableClientState(GL_NORMAL_ARRAY);

  for ( int pass = 0;  pass < 2;  pass++ )
    {
      if ( pass == 0 )
        {
          // Prepare to write unshadowed parts of frame buffer.
          //
          glStencilFunc(GL_NOTEQUAL,1,1);
        }
      else
        {
          // Prepare to write shadowed parts of frame buffer.
          //
          glStencilFunc(GL_EQUAL,1,1);
          glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 6.0);
        }

      glEnable(GL_TEXTURE_2D);

      // Write lighter-colored, textured tiles.
      //
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,gray);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
      glColor3f(0.35,0.35,0.35);
      glDrawArrays(GL_QUADS,0,half_elements+4);

      // Write darker-colored, untextured, mirror tiles.
      //
      glEnable(GL_BLEND);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,white);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,20);
      glDisable(GL_TEXTURE_2D);
      glColor3fv(lsu_spirit_purple);
      glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
      glDisable(GL_BLEND);
    }

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glDisable(GL_STENCIL_TEST);
  glDepthFunc(GL_LESS);

  // Render Ball
  //
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glMaterialf(GL_BACK,GL_SHININESS,shininess_ball);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid_emacs);

  balls_render();

  glDisable(GL_TEXTURE_2D);

  if ( opt_normals_visible )
    {
      glColor3fv(lsu_spirit_gold);
      for ( int i=0; i<platform_tile_coords.elements; i++ )
        cone.render(platform_tile_coords[i],0.2,5 * platform_tile_norms[i]);
    }

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  glDisable(GL_LIGHTING);
  glDisable(GL_BLEND);
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_STENCIL_TEST);
  frame_timer.frame_end();

  glutSwapBuffers();
}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const float move_amt = 0.4;

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -move_amt; break;
  case FB_KEY_RIGHT: adjustment.x = move_amt; break;
  case FB_KEY_PAGE_UP: adjustment.y = move_amt; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -move_amt; break;
  case FB_KEY_DOWN: adjustment.z = move_amt; break;
  case FB_KEY_UP: adjustment.z = -move_amt; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_normals_visible = !opt_normals_visible; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 's': balls_stop(); break;
  case 'x': case 'X': balls += new Ball(); break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;
  sphere.radius = opt_ball_radius;

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(eye_direction,pVect(0,0,-1));
      user_rot_axis *= invert(rotall);
      eye_direction *= pMatrix_Rotation(user_rot_axis, M_PI * 0.03);
      modelview_update();
    }

  // Update eye_location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Ball: balls[0]->translate(adjustment); break;
      case MI_Ball_V: balls[0]->push(adjustment); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      default: break;
      }
      modelview_update();
    }
}



int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.render_w,&world);
}

