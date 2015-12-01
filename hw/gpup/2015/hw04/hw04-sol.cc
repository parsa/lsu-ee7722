/// LSU EE 4702-1 (Fall 2015), GPU Programming
//
 /// Homework 4 -- SOLUTION
 //

 /// Instructions
 //
 //  Assignment: http://www.ece.lsu.edu/koppel/gpup/2015/hw04.pdf
 //  Solution:   http://www.ece.lsu.edu/koppel/gpup/2015/hw04_sol.pdf


/// Purpose
//
//   Demonstrate simulation of point masses connected by springs.


/// What Code Does

// Simulates balls connected by springs over a platform. Balls and
// springs can be initialized in different arrangements (called
// scenes). Currently scene 1 is a simple string of beads, and scenes
// 2, 3, and 4 are trusses. The platform consists of tiles, some are
// purple-tinted mirrors (showing a reflection of the ball), the
// others show the course syllabus.



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
 //  'v'    Cycle through display of links/balls (SKEL) and triangles (SKIN).
 //  'w'    Twirl balls around axis formed by head and tail. (Prob 2 soln).
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
 //  'y'    Toggle value of opt_tryout1. Intended for experiments and debugging.
 //  'Y'    Toggle value of opt_tryout2. Intended for experiments and debugging.
 //  'F11'  Change size of green text (in upper left).
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
 //  VAR Time Step Duration - Set physics time step.
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
#include <gp/colors.h>

#include "util-containers.h"
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
  Ball():velocity(pVect(0,0,0)),locked(false),
         color(color_lsu_spirit_gold),contact(false){};
  pCoor position;
  pVect velocity;
  int idx; // Position in balls_pos_rad;

  float mass;
  float mass_min; // Mass below which simulation is unstable.
  float radius;

  bool locked;

  pVect force;
  pColor color;
  bool contact;                 // When true, ball rendered in gray.
  float spring_constant_sum;    // Used to compute minimum mass.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

class Link {
public:
  Link(Ball *b1, Ball *b2):ball1(b1),ball2(b2),
     distance_relaxed(pDistance(b1->position,b2->position)), snapped(false),
     natural_color(color_lsu_spirit_purple),color(color_lsu_spirit_purple){}
  Link(Ball *b1, Ball *b2, pColor colorp):ball1(b1),ball2(b2),
     distance_relaxed(pDistance(b1->position,b2->position)), snapped(false),
     natural_color(colorp),color(colorp){}
  Ball* const ball1;
  Ball* const ball2;
  float distance_relaxed;
  bool snapped;
  pColor natural_color;
  pColor color;
};

// Declare containers and iterators for Balls and Links.
// (See util_container.h.)
//
typedef pVectorI<Link> Links;
typedef pVectorI_Iter<Link> LIter;
typedef pVectorI<Ball> Balls;
typedef pVectorI_Iter<Ball> BIter;


//
//   Use this class to define variables and member functions.
//
class My_Piece_Of_The_World {
public:

  float link_stressed_thd;  // Amount of stretch to be considered stressed.
  float link_snap_thd;      // Amount of stretch needed to snap link.

  pColor color_stressed;
};


struct Truss_Info {

  // See make_truss for a description of what the members are for.

  // Inputs
  PStack<pCoor> base_coors;  // Coordinates of first set of balls.
  pVect unit_length;
  int num_units;

  // Output
  Balls balls;
  Links links;
};



enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };
enum Shader_Option { SO_Fixed, SO_Phong, SO_Instance, SO_ENUM_SIZE };

struct ivec2 { int x; int y; };

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  void init_graphics();
  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();
  void render();
  void render_objects(Render_Option render_option);
  void render_my_piece();
  void objects_erase();
  void cb_keyboard();
  void modelview_update();

  My_Piece_Of_The_World mp;

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  double last_frame_wall_time;
  float opt_time_step_duration;
  int time_step_count;
  float opt_gravity_accel;      // Value chosen by user.
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  bool opt_gravity;
  bool opt_head_lock, opt_tail_lock;
  bool opt_ride; // When true, move eye to ball_eye.
  int opt_tri_cull;  // =0, don't cull; =1, cull back, =2, cull front.
  bool opt_tryout1, opt_tryout2;  // For ad-hoc experiments.
  int opt_sides;  // Number of arms on thing in scene 3.

  bool opt_ball_texture;

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

  pVect adj_vector;
  double adj_t_prev;
  double adj_t_stop;
  double adj_duration;

  int opt_shader;
  bool opt_shadows;
  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_phong;          // Phong shading.
  pShader *sp_instances;
  pShader *sp_links;

  GLuint balls_pos_rad_bo;
  GLuint balls_color_bo;
  GLuint links_indices_bo;

  /// SOLUTION -- Problem 2
  //
  //  Variables used for transferring link colors to OpenGL.
  GLuint links_color_bo;
  pColor *links_color;

  /// SOLUTION -- Problem 3
  //
  //  Variables for transferring ball velocity to OpenGL.
  pCoor *balls_velocity;    // Note: Alignment problems with 3-elt type.
  GLuint balls_velocity_bo;

  pColor *balls_color;
  pCoor *balls_pos_rad;
  ivec2 *links_indices;
  size_t balls_size;
  size_t links_size;
  int last_setup; // Last scene set up.
  bool link_change;

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
  void balls_twirl();
  void lock_update();

  Ball *make_marker(pCoor pos, pColor col);
  void make_truss(Truss_Info *ti);

  Ball *ball_eye, *ball_gaze, *ball_down;

  float opt_spring_constant;
  float opt_air_resistance;
  float distance_relaxed;
  int chain_length;
  Balls balls;
  Ball *head_ball, *tail_ball;
  Links links;
  Sphere sphere;
  Cylinder cyl;
};


void
World::init_graphics()
{
  ///
  /// Graphical Model Initialization
  ///

  balls_pos_rad = NULL;
  balls_pos_rad_bo = 0;
  balls_color = NULL;
  balls_color_bo = 0;
  balls_size = 0;
  links_size = 0;
  links_indices = NULL;
  links_indices_bo = 0;
  link_change = true;

  opt_platform_texture = true;
  opt_head_lock = false;
  opt_tail_lock = false;
  opt_ball_texture = false;
  opt_tryout1 = opt_tryout2 = false;

  opt_sides = 8;

  eye_location = pCoor(24.2,11.6,-38.7);
  eye_direction = pVect(-0.42,-0.09,0.9);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  texid_syl = pBuild_Texture_File("gpup.png",false,255);
  texid_emacs = pBuild_Texture_File("mult.png", false,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(platform_xmax,platform_xmax,platform_zmin);

  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;
  opt_pause = false;
  opt_single_time_step = false;
  opt_single_frame = false;

  sphere.init(15);

  platform_update();
  modelview_update();

  adj_t_stop = 0;
  adj_duration = 0.25;

}


void
World::platform_update()
{
  const float tile_count = 19;
  const float ep = 1.00001;
  const float delta_x = ( platform_xmax - platform_xmin ) / tile_count * ep;
  const float zdelta = ( platform_zmax - platform_zmin ) / tile_count * ep;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  platform_normal = pVect(0,1,0);

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<float> p_tex_coords;
  bool even = true;

  for ( int i = 0; i < tile_count; i++ )
    {
      const float x0 = platform_xmin + i * delta_x;
      const float x1 = x0 + delta_x;
      const float y = 0;
      for ( float z = platform_zmin; z < platform_zmax; z += zdelta )
        {
          PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
          p_tex_coords += trmax; p_tex_coords += tsmax;
          t_coords += pVect(x0,y,z);
          p_tex_coords += trmax; p_tex_coords += tsmin;
          t_coords += pVect(x0,y,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmin;
          t_coords += pVect(x1,y,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmax;
          t_coords += pVect(x1,y,z);
          even = !even;
        }
    }

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;

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
  pMatrix reflect; reflect.set_identity(); reflect.rc(1,1) = -1;
  transform_mirror = modelview * reflect * invert(modelview);
}

void
World::render_objects(Render_Option option)
{
  const float shininess_ball = 5;
  pColor spec_color(0.2,0.2,0.2);
  const bool show_links = true;

  if ( option == RO_Shadow_Volumes )
    viewer_shadow_volume = 0;

  if ( option == RO_Normally )
    {
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
      if ( opt_ball_texture )
        {
          glEnable(GL_TEXTURE_2D);
          glBindTexture(GL_TEXTURE_2D,texid_emacs);
        }
      else
        {
          glDisable(GL_TEXTURE_2D);
        }
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
      glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
      glEnable(GL_COLOR_SUM);
    }

  cyl.apex_radius = 1; cyl.set_color(color_lsu_spirit_purple);
  if ( option == RO_Shadow_Volumes )
    {
#ifdef DB_SV
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
      glEnable(GL_COLOR_SUM);
      glColor3f(0.5,0,0);
#endif
      cyl.light_pos = light_location;
      sphere.light_pos = light_location;

      for ( BIter ball(balls); ball; )
        sphere.render_shadow_volume(ball->radius,ball->position);

      if ( show_links )
        for ( LIter link(links); link; )
          {
            if ( link->snapped ) continue;
            Ball *const ball1 = link->ball1;
            Ball *const ball2 = link->ball2;
            cyl.render_shadow_volume
              (ball1->position,0.3*ball1->radius,
               ball2->position-ball1->position);
          }
    }
  else
    {
      sphere.opt_texture = opt_ball_texture;

      if ( opt_shader != SO_Instance )
        {
          if ( opt_shader == SO_Phong )
            sp_phong->use();
          else if ( opt_shader == SO_Fixed )
            sp_fixed->use();

          if ( opt_shader != SO_Fixed )
            {
              glUniform1i(2, opt_tri_cull);
              glUniform2i(3, opt_tryout1, opt_tryout2);
            }

          for ( BIter ball(balls); ball; )
            {
              if ( ball->contact )
                sphere.color = color_gray;
              else if ( ball->mass > 0 && ball->mass < ball->mass_min )
                sphere.color = color_red;
              else if ( ball->mass > 0 && ball->locked )
                sphere.color = color_pale_green;
              else
                sphere.color = ball->color;
              sphere.render(ball->radius,ball->position);
            }
          if ( show_links )
            for ( LIter link(links); link; )
              {
                if ( link->snapped ) continue;
                Ball *const ball1 = link->ball1;
                Ball *const ball2 = link->ball2;
                cyl.set_color(link->color);
                cyl.render(ball1->position,0.3*ball1->radius,
                           ball2->position-ball1->position);
              }
          sp_fixed->use();
        }
      else
        {
          sp_instances->use();

          if ( balls_pos_rad_bo == 0 )
            {
              glGenBuffers(1,&balls_pos_rad_bo);
              glGenBuffers(1,&balls_color_bo);
              glGenBuffers(1,&links_indices_bo);

              /// SOLUTION -- Problem 2
              glGenBuffers(1,&links_color_bo);

              /// SOLUTION -- Problem 3
              glGenBuffers(1,&balls_velocity_bo);
            }

          if ( balls_size < balls.size() )
            {
              delete balls_pos_rad;
              delete balls_color;
              balls_pos_rad = new pCoor[balls.size()];

              /// SOLUTION -- Problem 2
              balls_color = new pColor[balls.size()];

              /// SOLUTION -- Problem 3
              //  Note that a four-component type, pCoor, used even
              //  though velocity has three components.
              balls_velocity = new pCoor[balls.size()];

              balls_size = balls.size();
            }

          if ( links_size < links.size() )
            {
              delete links_indices;
              links_size = links.size();
              links_indices = new ivec2[links_size];

              /// SOLUTION -- Problem 2
              links_color = new pColor[links_size];
            }

          int color_change = 0;

          for ( BIter ball(balls); ball; )
            {
              pColor color;
              if ( ball->contact )
                color = color_gray;
              else if ( ball->mass > 0 && ball->mass < ball->mass_min )
                color = color_red;
              else if ( ball->mass > 0 && ball->locked )
                color = color_pale_green;
              else
                color = ball->color;
              if ( balls_color[ball] != color ) color_change++;
              ball->idx = ball; // Position of ball in balls.
              balls_color[ball->idx] = color;
              pCoor pos_rad = ball->position;
              pos_rad.w = ball->radius;
              balls_pos_rad[ball->idx] = pos_rad;

              /// SOLUTION -- Problem 3
              balls_velocity[ball->idx] = ball->velocity;
            }
          if ( link_change )
            for ( LIter link(links); link; )
              {
                links_indices[link].x = link->ball1->idx;
                links_indices[link].y = link->ball2->idx;
                /// SOLUTION -- Problem 2
                links_color[link] = link->color;
              }

          GE();
          glBindBuffer(GL_SHADER_STORAGE_BUFFER,balls_pos_rad_bo);
          glBufferData
            (GL_SHADER_STORAGE_BUFFER,
             // Amount of data (bytes) to copy.
             balls.size() * sizeof(balls_pos_rad[0]),
             balls_pos_rad,
             GL_DYNAMIC_DRAW); // Hint about who, when, how accessed.

          /// SOLUTION -- Problem 3
          glBindBuffer(GL_SHADER_STORAGE_BUFFER,balls_velocity_bo);
          glBufferData
            (GL_SHADER_STORAGE_BUFFER,
             // Amount of data (bytes) to copy.
             balls.size() * sizeof(balls_velocity[0]),
             balls_velocity,
             GL_DYNAMIC_DRAW); // Hint about who, when, how accessed.

          if ( link_change )
            {
              glBindBuffer(GL_ARRAY_BUFFER,links_indices_bo);
              glBufferData
                (GL_ARRAY_BUFFER,
                 // Amount of data (bytes) to copy.
                 links.size() * sizeof(links_indices[0]),
                 links_indices,
                 GL_STATIC_DRAW); // Hint about who, when, how accessed.

              /// SOLUTION -- Problem 2
              glBindBuffer(GL_ARRAY_BUFFER,links_color_bo);
              glBufferData
                (GL_ARRAY_BUFFER,
                 // Amount of data (bytes) to copy.
                 links.size() * sizeof(links_color[0]),
                 links_color,
                 GL_STATIC_DRAW); // Hint about who, when, how accessed.
            }
          if ( color_change )
            {
              glBindBuffer(GL_SHADER_STORAGE_BUFFER,balls_color_bo);
              glBufferData
                (GL_SHADER_STORAGE_BUFFER,
                 // Amount of data (bytes) to copy.
                 balls.size() * sizeof(balls_color[0]),
                 balls_color,
                 GL_STATIC_DRAW); // Hint about who, when, how accessed.
            }
          GE();

          glUniform1i(2, opt_tri_cull);
          glUniform2i(3, opt_tryout1, opt_tryout2);

          glBindBufferBase(GL_SHADER_STORAGE_BUFFER,1,balls_pos_rad_bo);
          glBindBufferBase(GL_SHADER_STORAGE_BUFFER,2,balls_color_bo);

          /// SOLUTION -- Problem 3
          glBindBufferBase(GL_SHADER_STORAGE_BUFFER,4,balls_velocity_bo);

          sphere.points_bo.bind();
          glVertexPointer(3,GL_FLOAT,0,0);
          glEnableClientState(GL_VERTEX_ARRAY);
          GE();
          glDrawArraysInstanced
            (GL_TRIANGLE_STRIP,0,sphere.points_bo.elements,balls);
          GE();

          glBindBuffer(GL_ARRAY_BUFFER,0);
          glDisableClientState(GL_VERTEX_ARRAY);
          glDisableClientState(GL_TEXTURE_COORD_ARRAY);

          /// Homework 4 Problem 2 Solution Here (and other places).
          sp_links->use();
          link_change = false;

          /// SOLUTION -- Problem 2
          glBindBufferBase(GL_SHADER_STORAGE_BUFFER,3,links_color_bo);

          glBindBuffer(GL_ARRAY_BUFFER,links_indices_bo);
          glVertexPointer(2,GL_INT,0,0);
          glEnableClientState(GL_VERTEX_ARRAY);
          glDrawArrays(GL_POINTS,0,links_size);
          glBindBuffer(GL_ARRAY_BUFFER,0);
          glDisableClientState(GL_VERTEX_ARRAY);
        }

      sp_fixed->use();
    }

  glDisable(GL_COLOR_SUM);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR);
  glLightfv(GL_LIGHT0, GL_SPECULAR, color_black);

  //
  // Render Platform
  //
  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  glEnable(GL_TEXTURE_2D);

  // Set up attribute (vertex, normal, etc.) arrays.
  //
  glBindTexture(GL_TEXTURE_2D,texid_syl);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormal3fv(platform_normal);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Write lighter-colored, textured tiles.
  //
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
  glColor3f(0.35,0.35,0.35);
  glColor3f(0.55,0.55,0.55);
  glDrawArrays(GL_QUADS,0,half_elements+4);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
}

void
World::render()
{
  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

  /// Emit a Graphical Representation of Simulation State
  //

  // Understanding of the code below not required for introductory
  // lectures.

  // That said, much of the complexity of the code is to show
  // the ball shadow and reflection.


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
  glClearStencil(0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.5);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x555555);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, color_white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, color_black);
  glLightfv(GL_LIGHT0, GL_SPECULAR, color_white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

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

  const double time_now = time_wall_fp();
  const bool blink_visible = int64_t(time_now*3) & 1;
# define BLINK(txt,pad) ( blink_visible ? txt : pad )

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Code Compiled: %s\n",
#ifdef __OPTIMIZE__
     "WITH OPTIMIZATION"
#else
     BLINK("WITHOUT OPTIMIZATION","")
#endif
     );

  const int cyl_sides = 20;
  const int cyl_vtx = cyl_sides * 2 + 2;
  const int cyl_vtx_tot = cyl_vtx * links.size();
  const int ball_vtx_tot = sphere.points_bo.elements * balls.size();
  const int vtx_total = cyl_vtx_tot + ball_vtx_tot;

  ogl_helper.fbprintf
    ("Balls: %3d   Links: %3d  Vtx/Ball: %3d  Vtx/Link: %2d  Total: %d\n",
     balls.size(), links.size(),
     sphere.points_bo.elements,
     cyl_vtx,
     vtx_total);

  ogl_helper.fbprintf
    ("Time Step: %8d  World Time: %11.6f  %s\n",
     time_step_count, world_time,
     opt_pause ? BLINK("PAUSED, 'p' to unpause, SPC or S-SPC to step.","") :
     "Press 'p' to pause."
     );

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  Ball& ball = *balls[0];

  if ( 0 )
  ogl_helper.fbprintf
    ("Head Ball Pos  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]\n",
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z );

  ogl_helper.fbprintf
    ("Shader: %s  ('v' to change)  "
     "Tryout 1: %s  ('y' to change)  Tryout 2: %s  ('Y' to change)\n",
     opt_shader == SO_Fixed ? "FIXED" :
     opt_shader == SO_Phong ? "PLAIN" :
     opt_shader == SO_Instance ? "INSTANCE" : "other",
     opt_tryout1 ? BLINK("ON","  ") : "OFF",
     opt_tryout2 ? BLINK("ON","  ") : "OFF");

  ogl_helper.fbprintf
    ("Cull %d-%s ('c' to change)  "
     "Shadows: %s ('o' to change)\n",
     opt_tri_cull,
     opt_tri_cull == 0 ? "OFF  " : opt_tri_cull == 1 ? "BACK " :
     opt_tri_cull == 2 ? "FRONT" : "???",
     opt_shadows ? "ON" : "OFF" );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  //
  // Render ball reflection.  (Will be blended with dark tiles.)
  //

  // Write stencil at location of dark (mirrored) tiles.
  //
  glDisable(GL_LIGHTING);
  glEnable(GL_STENCIL_TEST);
  glStencilFunc(GL_NEVER,2,2);
  glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
  glEnable(GL_LIGHTING);
  glDisableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);

  // Prepare to write only stenciled locations.
  //
  glStencilFunc(GL_EQUAL,2,2);
  glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

  // Use a transform that reflects objects to other side of platform.
  //
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glMultTransposeMatrixf(transform_mirror);

  // Reflected front face should still be treated as the front face.
  //
  glFrontFace(GL_CW);

  render_objects(RO_Normally);

  glFrontFace(GL_CCW);
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glDisable(GL_STENCIL_TEST);


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

  if ( opt_platform_texture )
    {
      glEnable(GL_TEXTURE_2D);
      platform_tex_coords.bind();
      glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }

  platform_tile_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormal3fv(platform_normal);

  if ( opt_platform_texture ) glEnable(GL_TEXTURE_2D);

  // Write lighter-colored, textured tiles.
  //
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,color_gray);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
  glColor3f(0.35,0.35,0.35);
  glDrawArrays(GL_QUADS,0,half_elements+4);

  // Write darker-colored, untextured, mirror tiles.
  //
  glEnable(GL_BLEND);
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,color_white);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,20);
  glDisable(GL_TEXTURE_2D);
  glColor3fv(color_lsu_spirit_purple);
  glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
  glDisable(GL_BLEND);

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glDisable(GL_STENCIL_TEST);
  glDepthFunc(GL_LESS);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);

  if ( !opt_shadows )
    {
      // Render.
      //
      render_objects(RO_Normally);
    }
  else
    {
      //
      // First pass, render using only ambient light.
      //
      glDisable(GL_LIGHT0);

      // Send balls, tiles, and platform to opengl.
      // Do occlusion test too.
      //
      render_objects(RO_Normally);

      //
      // Second pass, add on light0.
      //

      // Turn off ambient light, turn on light 0.
      //
      glLightModelfv(GL_LIGHT_MODEL_AMBIENT, color_black);
      glEnable(GL_LIGHT0);


      glClear(GL_STENCIL_BUFFER_BIT);

      // Make sure that only stencil buffer written.
      //
#ifndef DB_SV
      glColorMask(false,false,false,false);
      glDepthMask(false);

      // Don't waste time computing lighting.
      //
      glDisable(GL_LIGHTING);
#endif
      glDisable(GL_TEXTURE_2D);

      // Set up stencil test to count shadow volume surfaces: plus 1 for
      // entering the shadow volume, minus 1 for leaving the shadow
      // volume.
      //
      glEnable(GL_STENCIL_TEST);
      // sfail, dfail, dpass
      glStencilOpSeparate(GL_FRONT,GL_KEEP,GL_KEEP,GL_INCR_WRAP);
      glStencilOpSeparate(GL_BACK,GL_KEEP,GL_KEEP,GL_DECR_WRAP);
      glStencilFuncSeparate(GL_FRONT_AND_BACK,GL_ALWAYS,1,-1); // ref, mask
 
      // Write stencil with shadow locations based on shadow volumes
      // cast by light0 (light_location).  Shadowed locations will
      // have a positive stencil value.  Routine will set viewer_shadow_volume
      // to the number of view volumes containing the eye.
      //
      render_objects(RO_Shadow_Volumes);

      glEnable(GL_LIGHTING);
      glColorMask(true,true,true,true);
      glDepthMask(true);

      // Use stencil test to prevent writes to shadowed areas.
      //
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,viewer_shadow_volume,-1); // ref, mask

      // Allow pixels to be re-written.
      //
      glDepthFunc(GL_LEQUAL);
      glEnable(GL_BLEND);
      glBlendEquation(GL_FUNC_ADD);
      glBlendFunc(GL_ONE,GL_ONE);

      // Render.
      //
      render_objects(RO_Normally);

      glDisable(GL_BLEND);
      glDisable(GL_STENCIL_TEST);

    }


  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  frame_timer.frame_end();

  ogl_helper.user_text_reprint();

  glutSwapBuffers();
}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const bool shift = ogl_helper.keyboard_shift;
  const float move_amt = shift ? 2.0 : 0.4;
  const int opt_sides_before = opt_sides;

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
  case '1': ball_setup_1(); break;
  case '2': ball_setup_2(); break;
  case '3': ball_setup_3(); break;
  case '4': ball_setup_4(); break;
  case '5': ball_setup_5(); break;
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'c': case 'C':
    opt_tri_cull++; if ( opt_tri_cull == 3 ) opt_tri_cull = 0;
    break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'h': case 'H': opt_head_lock = !opt_head_lock; break;
  case 't': case 'T': opt_tail_lock = !opt_tail_lock; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_platform_texture = !opt_platform_texture; break;
  case 'o': case 'O': opt_shadows = !opt_shadows; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'r': case 'R': opt_ride = !opt_ride; break;
  case 's': case 'S': balls_stop(); break;
  case 'v': case 'V': opt_shader++; if ( opt_shader > 2 ) opt_shader = 0; break;
  case 'w': case 'W': balls_twirl(); break;
  case 'y': opt_tryout1 = !opt_tryout1; break;
  case 'Y': opt_tryout2 = !opt_tryout2; break;
  case ' ':
    if ( shift ) opt_single_time_step = true; else opt_single_frame = true;
    opt_pause = true;
    break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  if ( opt_sides_before != opt_sides && last_setup == 3 )
    ball_setup_3();

  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;

  lock_update();

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
      case MI_Ball:
        adj_vector = adjustment;
        if ( adj_t_stop == 0 )
          adj_t_prev = adj_t_stop = world_time;
        adj_t_stop += adj_duration;
        break;
      case MI_Ball_V: balls_push(adjustment,0); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      default: break;
      }
      modelview_update();
    }

}




void
World::init()
{
  mp.color_stressed = pColor(1,0,0); // Red, what else?
  mp.link_stressed_thd = 1.01;
  mp.link_snap_thd = 1.5;

  chain_length = 14;

  opt_sides = 8;
  variable_control.insert(opt_sides,"Scene 3 Object Number of Sides",1,3);

  opt_time_step_duration = 0.0003;
  variable_control.insert(opt_time_step_duration,"Time Step Duration");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 15000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.04;
  variable_control.insert(opt_air_resistance,"Air Resistance");

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  opt_shadows = false;
  opt_shader = SO_Instance;

  ball_eye = NULL;
  opt_ride = false;

  opt_tri_cull = 0;

  init_graphics();

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  sp_phong = new pShader
    ("hw04-sol-shdr.cc",// File holding shader program.
     "vs_main(); ",     // Name of vertex shader main routine.
     "gs_main_simple();",
     "fs_main();"       // Name of fragment shader main routine.
     );
  sp_instances = new pShader
    ("hw04-sol-shdr.cc",// File holding shader program.
     "vs_main_instances(); ",
     "gs_main_simple();",
     "fs_main();"
     );

  sp_links = new pShader
    ("hw04-sol-shdr-links.cc",// File holding shader program.
     "vs_main(); ",     // Name of vertex shader main routine.
     "gs_main_links();",
     "fs_main();"       // Name of fragment shader main routine.
     );

  ball_setup_3();
  lock_update();
}

Ball*
World::make_marker(pCoor position, pColor color)
{
  Ball* const ball = new Ball;
  ball->position = position;
  ball->locked = true;
  ball->velocity = pVect(0,0,0);
  ball->radius = 0.2;
  ball->mass = 0;
  ball->contact = false;
  ball->color = color;
  return ball;
}

void
World::lock_update()
{
  // This routine called when options like opt_head_lock might have
  // changed.

  // Update locked status.
  //
  if ( head_ball ) head_ball->locked = opt_head_lock;
  if ( tail_ball ) tail_ball->locked = opt_tail_lock;

  // Re-compute minimum mass needed for stability.
  //
  for ( BIter ball(balls); ball; ) ball->spring_constant_sum = 0; 
  const double dtis = pow( opt_time_step_duration, 2 );
  for ( LIter link(links); link; )
    {
      Ball* const b1 = link->ball1;
      Ball* const b2 = link->ball2;
      b1->spring_constant_sum += opt_spring_constant;
      b2->spring_constant_sum += opt_spring_constant;
    }
  for ( BIter ball(balls); ball; )
    ball->mass_min = ball->spring_constant_sum * dtis;
}

void
World::balls_twirl()
{
  if ( !head_ball || !tail_ball ) return;

  pNorm axis(head_ball->position, tail_ball->position);

  for ( BIter ball(balls); ball; )
    {
      pVect b_to_top(ball->position,head_ball->position);
      const float dist_along_axis = dot(b_to_top,axis);
      const float lsq = b_to_top.mag_sq() - dist_along_axis * dist_along_axis;
      if ( lsq <= 1e-5 ) { ball->velocity = pVect(0,0,0); continue; }
      const float dist_to_axis = sqrt(lsq);
      pNorm rot_dir = cross(b_to_top,axis);
      ball->velocity += 2 * dist_to_axis * rot_dir;
    }
}

void
World::objects_erase()
{
  ball_eye = NULL;
  link_change = true;
  balls.erase();
  links.erase();
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
  last_setup = 1;

  pCoor first_pos(13.4,17.8,-9.2);
  pVect delta_pos = pVect(distance_relaxed,0,0);

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();

  for ( int i=0; i<chain_length; i++ )
    {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = balls += new Ball;

      // Initialize position and other information.
      //
      ball->position = first_pos + i * delta_pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;

      // If it's not the first ball link it to the previous ball.
      if ( i > 0 ) links += new Link( ball, balls[i-1] );
    }

  // The balls pointed to by head_ball and tail_ball can be manipulated
  // using the user interface (by pressing 'h' or 't', for example).
  // Set these variables.
  //
  head_ball = balls[0];
  tail_ball = balls[balls-1];

  opt_head_lock = true;    // Head ball will be frozen in space.
  opt_tail_lock = false;   // Tail ball can move freely.
}


void
World::make_truss(Truss_Info *truss_info)
{
  /// Construct a truss based on members of truss_info.
  //

  //            <---- num_units (=9) ----------->
  //  j          
  //  0         O---O---O---O---O---O---O---O---O     ^
  //            |   |   |   |   |   |   |   |   |     |
  //  1         O---O---O---O---O---O---O---O---O   num_sides (=3)
  //            |   |   |   |   |   |   |   |   |     |
  //  2         O---O---O---O---O---O---O---O---O     v
  //            
  //      i ->  0   1   2   3   4   5   6   7   8          
  //
  //  Note: Not all links are shown in the diagram above.

  /// Truss_Info Inputs
  //
  //  truss_info->num_units
  //    The number of sections in the truss (see diagram above).
  //
  //  truss_info->base_coors
  //    A list containing num_sides coordinates, the coordinates of
  //    balls at i=0 (see diagram above). (num_sides is the number of
  //    elements in this list.)  These coordinates should all be
  //    in the same plane.
  //
  //  truss_info->unit_length
  //    A vector pointing from the ball at (i,j) to the ball at (i+1,j).
  //
  /// Truss_Info Outputs
  //
  //  truss_info->balls
  //    A list that should be filled with the balls making up the truss.
  //
  //  truss_info->links
  //    A list that should be filled with the links making up the truss.


  const int num_sides = truss_info->base_coors.occ();
  const int num_units = truss_info->num_units;

  // Lists to hold balls and links created for truss.
  //
  Balls& bprep = truss_info->balls;
  Links& lprep = truss_info->links;

  // Create balls for truss.
  //
  for ( int i=0; i<num_units; i++ )
    for ( pCoor bcoor; truss_info->base_coors.iterate(bcoor); )
      {
        Ball* const ball = bprep += new Ball;
        ball->position = bcoor + i * truss_info->unit_length;
        ball->locked = false;
        ball->velocity = pVect(0,0,0);
        ball->radius = 0.15;
        ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
        ball->contact = false;
      }

  // Create links.
  //
  for ( int i=0; i<num_units; i++ )
    for ( int j=0; j<num_sides; j++ )
      {
        const int idx = j + num_sides * i;

        // Retrieve the ball corresponding to (i,j).
        //
        Ball* const ball = bprep[idx];

        // Compute the index of the ball at (i, (j-1) mod num_sides ).
        //
        const int pn_idx = idx + ( j == 0 ? num_sides - 1 : -1 );

        // Insert link to neighbor ball with name i.
        //
        lprep += new Link( ball, bprep[pn_idx], color_gray );

        // Insert links to balls with same i that are not neighbors.
        //
        if ( j == i % num_sides )
          for ( int k = 2; k < num_sides-1; k++ )
            lprep += new Link
              ( ball, bprep[ idx + (k+j)%num_sides - j ], color_white );

        if ( i == 0 ) continue;

        // Insert link to ball at (i-1,j).
        //
        lprep +=
          new Link( ball, bprep[idx-num_sides], color_lsu_official_purple );

        // Insert link to ball at (i-1, j-1 mod num_sides ).
        //
        lprep += new Link( ball, bprep[pn_idx-num_sides], color_green );
      }
}

void
World::ball_setup_2()
{
  last_setup = 2;

  pCoor first_pos(13.4,17.8,-9.2);
  const float spacing = distance_relaxed;
  pVect delta_pos = pVect(spacing*0.05,-spacing,0);
  pNorm loc_y = delta_pos;
  pNorm loc_x = pVect(0,0,1);
  pNorm loc_z = cross(loc_y,loc_x);

  // Erase the existing balls and links.
  //
  objects_erase();

  Truss_Info truss_info;

  truss_info.num_units = chain_length;
  truss_info.unit_length = delta_pos;

  const int sides = 4;

  for ( int j=0; j<sides; j++ )
    {
      const double angle = double(j)/sides*2*M_PI;
      pCoor chain_first_pos =
        first_pos
        + 0.5 * spacing * cos(angle) * loc_x
        + 0.5 * spacing * sin(angle) * loc_z;

      truss_info.base_coors += chain_first_pos;
    }

  make_truss(&truss_info);

  // Insert links to balls at either end.
  //
  head_ball = balls += new Ball;
  head_ball->position = first_pos - delta_pos;
  for ( int j=0; j<sides; j++ )
    links += new Link( head_ball, truss_info.balls[j], color_chocolate );

  tail_ball = balls += new Ball;
  tail_ball->position = first_pos + chain_length * delta_pos;

  const int bsize = truss_info.balls.size();

  for ( int j=0; j<sides; j++ )
    links += new Link( tail_ball, truss_info.balls[bsize-sides+j],
                       color_chocolate );

  for ( BIter ball(balls); ball; )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.15;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  balls += truss_info.balls;
  links += truss_info.links;

  opt_tail_lock = false;
  opt_head_lock = false;
}

void
World::ball_setup_3()
{
  last_setup = 3;

  pCoor first_pos(13.4,17.8,-9.2);
  const int factor = 2;
  const float spacing = distance_relaxed / factor;
  pVect delta_pos = pVect(spacing*0.05,-spacing,0);
  pNorm delta_dir = delta_pos;
  pNorm tan_dir = pVect(0,0,1);
  pNorm um_dir = cross(tan_dir,delta_dir);

  // Erase the existing balls and links.
  //
  objects_erase();

  Truss_Info truss_info;

  const int length = chain_length * factor;

  truss_info.num_units = length;
  truss_info.unit_length = delta_pos;

  const int sides = opt_sides;

  for ( int j=0; j<sides; j++ )
    {
      const double angle = double(j)/sides*2*M_PI;
      pCoor chain_first_pos =
        first_pos
        + 0.5 * spacing * cos(angle) * tan_dir
        + 0.5 * spacing * sin(angle) * um_dir;

      truss_info.base_coors += chain_first_pos;
    }

  make_truss(&truss_info);

  const int idx_center = length / 2 * sides;

  for ( int i=0; i<sides; i++ )
    {
      Truss_Info ti;
      ti.num_units = length / 2;
      const int idx_1 = idx_center + ( i == 0 ? sides - 1 : i - 1 );
      const int idx_2 = idx_center + i;

      Ball* const b0 = truss_info.balls[idx_1];
      Ball* const b1 = truss_info.balls[idx_1 - sides];
      Ball* const b2 = truss_info.balls[idx_2 - sides];
      Ball* const b3 = truss_info.balls[idx_2];
      ti.base_coors += b0->position;
      ti.base_coors += b1->position;
      ti.base_coors += b2->position;
      ti.base_coors += b3->position;

      pNorm v_head = cross(b1->position,b2->position,b3->position);
      ti.unit_length = delta_dir.magnitude * v_head;
      make_truss(&ti);
      links += new Link(b0,ti.balls[0],color_red);
      links += new Link(b1,ti.balls[1],color_red);
      links += new Link(b2,ti.balls[2],color_red);
      links += new Link(b3,ti.balls[3],color_red);
      links += ti.links;
      balls += ti.balls;

      int tsz = ti.balls.size();

      if ( i == 2 )
        {
          ball_eye = ti.balls[tsz-2];
          ball_down = ti.balls[tsz-1];
        }
      else if ( i == 1 )
        {
          ball_gaze = ti.balls[tsz/2];
        }

    }

  // Insert links to balls at either end.
  //
  head_ball = balls += new Ball;
  head_ball->position = first_pos - delta_pos;
  for ( int j=0; j<sides; j++ )
    links += new Link( head_ball, truss_info.balls[j], color_chocolate );

  tail_ball = balls += new Ball;
  tail_ball->position = first_pos + length * delta_pos;

  const int bsize = truss_info.balls.size();

  for ( int j=0; j<sides; j++ )
    links += new Link( tail_ball, truss_info.balls[bsize-sides+j],
                       color_chocolate );

  for ( BIter ball(balls); ball; )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.15;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  balls += truss_info.balls;
  links += truss_info.links;

  opt_tail_lock = false;
  opt_head_lock = true;
}


void
World::ball_setup_4()
{
  //  last_setup = 4;
}

void
World::ball_setup_5()
{
  //  last_setup = 5;
}


 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu(double delta_t)
{
  time_step_count++;

  // Smoothly move ball in response to user input.
  //
  if ( adj_t_stop )
    {
      const double dt = min(world_time,adj_t_stop) - adj_t_prev;
      pVect adj = dt/adj_duration * adj_vector;
      balls_translate(adj,0);
      adj_t_prev = world_time;
      if ( world_time >= adj_t_stop ) adj_t_stop = 0;
    }

  for ( BIter ball(balls); ball; )
    ball->force = ball->mass * gravity_accel;

  for ( LIter link(links); link; )
    {
      if ( link->snapped ) continue;

      // Spring Force from Neighbor Balls
      //
      Ball* const ball1 = link->ball1;
      Ball* const ball2 = link->ball2;

      // Construct a normalized (Unit) Vector from ball to neighbor.
      //
      pNorm ball_to_neighbor(ball1->position,ball2->position);

      const float distance_between_balls = ball_to_neighbor.magnitude;

      // Compute the speed of ball towards neighbor_ball.
      //
      pVect delta_v = ball2->velocity - ball1->velocity;
      float delta_s = dot( delta_v, ball_to_neighbor );

      // Compute by how much the spring is stretched (positive value)
      // or compressed (negative value).
      //
      const float spring_stretch =
        distance_between_balls - link->distance_relaxed;

      if ( link->distance_relaxed > 0.001
           && distance_between_balls
           > link->distance_relaxed * mp.link_stressed_thd )
        {
          if ( distance_between_balls
               > link->distance_relaxed * mp.link_snap_thd )
            link->snapped = true;
          const float factor =
            ( distance_between_balls / link->distance_relaxed
              - mp.link_stressed_thd )
            / ( mp.link_snap_thd - 1 );
          link->color = max(0.0f,1-factor) * link->natural_color
            + factor * mp.color_stressed;
        }
      else
        {
          link->color = link->natural_color;
        }

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

      ball1->force += spring_constant * spring_stretch * ball_to_neighbor;
      ball2->force -= spring_constant * spring_stretch * ball_to_neighbor;
    }

  ///
  /// Update Position of Each Ball
  ///

  for ( BIter ball(balls); ball; )
    {
      if ( ball->locked )
        {
          ball->velocity = pVect(0,0,0);
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



void World::balls_translate(pVect amt,int b){head_ball->translate(amt);}
void World::balls_push(pVect amt,int b){head_ball->push(amt);}
void World::balls_translate(pVect amt)
{ for ( BIter ball(balls); ball; ) ball->translate(amt); }
void World::balls_push(pVect amt)
{ for ( BIter ball(balls); ball; ) ball->push(amt); }
void World::balls_stop()
{ for ( BIter ball(balls); ball; ) ball->stop(); }
void World::balls_freeze(){balls_stop();}


void
World::render_my_piece()
{
}


void
World::frame_callback()
{
  // This routine called whenever window needs to be updated.

  frame_timer.phys_start();
  const double time_now = time_wall_fp();

  if ( !opt_pause || opt_single_frame || opt_single_time_step )
    {
      /// Advance simulation state.

      // Amount of time since the user saw the last frame.
      //
      const double wall_delta_t = time_now - last_frame_wall_time;

      // Compute amount by which to advance simulation state for this frame.
      //
      const double duration =
        opt_single_time_step ? opt_time_step_duration :
        opt_single_frame ? 1/30.0 :
        wall_delta_t;

      const double world_time_target = world_time + duration;
      const double wall_time_limit = time_now + 0.05;

      while ( world_time < world_time_target )
        {
          time_step_cpu(opt_time_step_duration);
          world_time += opt_time_step_duration;
          const double time_right_now = time_wall_fp();
          if ( time_right_now > wall_time_limit ) break;
        }

      // Reset these, just in case they were set.
      //
      opt_single_frame = opt_single_time_step = false;
    }

  last_frame_wall_time = time_now;

  if ( opt_ride && ball_eye )
    {
      pNorm b_eye_down(ball_eye->position,ball_down->position);
      pVect b_eye_up = -b_eye_down;
      pCoor eye_pos = ball_eye->position + 2.2 * ball_eye->radius * b_eye_up;
      pNorm b_eye_direction(eye_pos,ball_gaze->position);

      pNorm b_eye_left = cross(b_eye_direction,b_eye_up);
      pMatrix_Translate center_eye(-eye_pos);
      pMatrix rotate; rotate.set_identity();
      for ( int i=0; i<3; i++ ) rotate.rc(0,i) = b_eye_left.elt(i);
      for ( int i=0; i<3; i++ ) rotate.rc(1,i) = b_eye_up.elt(i);
      for ( int i=0; i<3; i++ ) rotate.rc(2,i) = -b_eye_direction.elt(i);
      modelview = rotate * center_eye;
      pMatrix reflect; reflect.set_identity(); reflect.rc(1,1) = -1;
      transform_mirror = modelview * reflect * invert(modelview);
    }

  render();
}

int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  glDisable(GL_DEBUG_OUTPUT);
  glDebugMessageControl(GL_DONT_CARE,GL_DONT_CARE,
                        GL_DEBUG_SEVERITY_NOTIFICATION,0,NULL,false);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
