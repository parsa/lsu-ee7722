/// LSU EE 4702-1 (Fall 2016), GPU Programming
//
 /// Homework 7
 //
 //  See http://www.ece.lsu.edu/koppel/gpup/2016/hw07.pdf

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
 //        With control key pressed, motion is 5x slower.
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

#include <gp/util-containers.h>
#include <gp/coord-containers.h>
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
  Ball():velocity(pVect(0,0,0)),omega(pVect(0,0,0)),
         density(1.00746),
         fdt_to_do(0),
         locked(false),
         color(color_lsu_spirit_gold),contact(false)
         {
           orientation_set(pVect(0,1,0),0);
         }
  pCoor position;
  pVect velocity;
  pQuat orientation;
  pMatrix3x3 omatrix;
  pVect omega;                  // Spin rate and axis.

  int idx; // Position in balls_pos_rad;

  float mass;
  float mass_min; // Mass below which simulation is unstable.
  float radius;
  float radius_sq, radius_inv;  // Pre-computed based on radius.
  float density;
  float mass_inv;
  float fdt_to_do; // Radius / moment of inertia.

  bool locked;

  pVect force;
  pVect torque;
  pColor color;
  bool contact;                 // When true, ball rendered in gray.
  float spring_constant_sum;    // Used to compute minimum mass.

  void orientation_set(pNorm dir, float angle)
    { orientation_set(pQuat(dir,angle)); }
  void orientation_set(pQuat ori)
    {
      orientation = ori;
      omatrix = pMatrix3x3_Rotation(orientation);
    }
  void constants_update();
  pVect point_rot_vel(pNorm tact_dir);
  pVect point_rot_vel(pVect tact_dir);
  void apply_tan_force(pNorm tact_dir, pNorm force_dir, double force_mag);
  void apply_tan_force(pNorm tact_dir, pVect force);
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};


void
Ball::constants_update()
{
  assert( radius );
  radius_sq = radius * radius;
  mass = 4.0 / 3 * M_PI * radius_sq * radius * density;
  radius_inv = 1 / radius;
  mass_inv = 1 / mass;
  // FYI, notice simplifications:
  //   const float mo_inertia = 0.4 * mass * radius_sq;
  //   fdt_to_do = radius / mo_inertia;
  fdt_to_do = radius_inv * 2.5 * mass_inv;
}

pVect
Ball::point_rot_vel(pNorm direction)
{
  /// Return velocity of point on surface of ball.
  //
  return radius * cross( omega, direction );
}

pVect
Ball::point_rot_vel(pVect rel_pos)
{
  /// Return velocity of point relative to center.
  //
  return cross( omega, rel_pos );
}

void
Ball::apply_tan_force(pNorm tact_dir, pVect force)
{
  torque += cross(tact_dir, force);
}

void
Ball::apply_tan_force(pNorm tact_dir, pNorm force_dir, double force_mag)
{
  apply_tan_force(tact_dir, force_mag * force_dir);
}

class Link {
public:
  Link(Ball *b1, Ball *b2):ball1(b1),ball2(b2),
     snapped(false),
     natural_color(color_lsu_spirit_purple),color(color_lsu_spirit_purple)
  { init(); }
  Link(Ball *b1, Ball *b2, pColor colorp):ball1(b1),ball2(b2),
     snapped(false),
     natural_color(colorp),color(colorp)
  { init(); }
  Link(Link *link, pVect cb1p, pVect cb2p, float drp):
    ball1(link->ball1), ball2(link->ball2), cb1(cb1p), cb2(cb2p),
    is_surface_connection(true), is_renderable(false),
    is_simulatable(true), distance_relaxed(drp),
    snapped(false){ link->is_simulatable = false; }
  void init()
    {
      assert( ball1->radius > 0 );
      assert( ball2->radius > 0 );
      is_simulatable = true;
      is_renderable = true;
      pNorm n12(ball1->position,ball2->position);
      const float rad_sum = ball1->radius + ball2->radius;
      is_surface_connection = n12.magnitude >= rad_sum;
      if ( !is_surface_connection )
        {
          distance_relaxed = n12.magnitude;
          cb1 = cb2 = pVect(0,0,0);
          return;
        }
      distance_relaxed = n12.magnitude - rad_sum;
      cb1 = ball1->radius * mult_MTV( ball1->omatrix, n12 );
      cb2 = ball2->radius * mult_MTV( ball2->omatrix, -n12 );
    }
  int serial;
  Ball* const ball1;
  Ball* const ball2;
  pVect cb1, cb2, b1_dir, b2_dir;
  bool is_surface_connection;
  bool is_renderable, is_simulatable;
  float distance_relaxed;
  bool snapped;
  pColor natural_color;
  pColor color;

  pVect spring_force_12;
  pVect torque1,torque2;

};

// Declare containers for Balls and Links. The containers are derived
// from std::vector and use overloaded operator += for push_back. (See
// include/util-containers.h.)
//
typedef pVectorI<Link> Links;
typedef pVectorI<Ball> Balls;


enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };
enum Shader_Option { SO_Phong, SO_Set_1, SO_Set_2, SO_ENUM_SIZE };

class World {
public:
  World(pOpenGL_Helper &fb, int argc, char **argv):ogl_helper(fb)
  {init(argc,argv);}
  void init(int argc, char **argv);
  void init_graphics();
  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();
  void render();
  void render_objects(Render_Option render_option);
  void objects_erase();
  void cb_keyboard();
  void modelview_update();

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
  bool opt_tryout1, opt_tryout2;  // For ad-hoc experiments.

  // Tiled platform for ball.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_pi_xwidth_inv;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  pVect platform_normal;
  GLuint texid_hw;
  GLuint texid_syl;
  GLuint texid_emacs;
  void platform_update();
  bool platform_collision_possible(pCoor pos);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;
  bool opt_single_frame;      // Simulate for one frame.
  bool opt_single_time_step;  // Simulate for one time step.

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix transform_mirror;

  pVect adj_vector;
  double adj_t_prev;
  double adj_t_stop;
  double adj_duration;

  int opt_shader;
  bool opt_mirror;
  bool opt_shadows;
  bool opt_shadow_volumes;      // Make shadow volumes visible.
  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_phong;          // Basic stuff.
  pShader *sp_instances_sphere;
  pShader *sp_instances_sv;

  GLuint balls_pos_rad_bo;
  GLuint balls_color_bo;
  GLuint links_indices_bo;

  pColor *balls_color;
  pCoor *balls_pos_rad;
  size_t balls_size;
  size_t links_size;
  int last_setup; // Last scene set up.
  bool link_change;

  void ball_setup_1();
  void ball_setup_2();
  void ball_setup_3();
  void ball_setup_4();
  void ball_setup_5();
  void setup_at_end();
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

  float opt_spring_constant;
  float opt_air_resistance;
  float distance_relaxed;
  int chain_length;
  Balls balls;
  Ball *head_ball, *tail_ball;
  Links links;
  Sphere sphere;
  Cylinder cyl;

  Links link_new(Ball *ball1, Ball *ball2, float stiffness = 0.2);

  // Homework 6

  void render_link_1(Link *link);
  void render_link_2_start();
  void render_link_2_gather(Link *link);
  void render_link_2_render();

  pShader *sp_set_1;
  pShader *sp_set_2;
  GLuint link_bo_vtx, link_bo_nrm, link_bo_tco;
  double world_time_link_update;

  int opt_sides, opt_segments;

  pVectorI<pCoors> lis_pvects;

  pCoors lis_pos1, lis_pos2;
  pCoors lis_v1, lis_v2, lis_b1_ydir, lis_b2_ydir, lis_tex_rad;
  GLuint *lis_bos;
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
  link_change = true;

  opt_head_lock = false;
  opt_tail_lock = false;
  opt_tryout1 = opt_tryout2 = false;

  eye_location = pCoor(24.2,11.6,-38.7);
  eye_direction = pVect(-0.42,-0.09,0.9);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  texid_syl = pBuild_Texture_File("gpup.png",false,255);
  texid_emacs = pBuild_Texture_File("mult.png", false,-1);
  texid_hw = pBuild_Texture_File("hw05-assign.png", false,255);

  opt_light_intensity = 100.2;
  light_location = pCoor(platform_xmax,platform_xmax,platform_zmin);

  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;
  opt_pause = false;
  opt_single_time_step = false;
  opt_single_frame = false;

  sphere.init(35);

  platform_update();
  modelview_update();

  adj_t_stop = 0;
  adj_duration = 0.25;

  link_bo_vtx = 0;
  opt_sides = 20;
  opt_segments = 15;
  variable_control.insert(opt_sides,"Link Sides");
  variable_control.insert(opt_segments,"Link Segments");
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
  pColor spec_color(1,1,1);
  pColor spec_light = color_white * opt_light_intensity;
  GLboolean l0, l1;
  glGetBooleanv(GL_LIGHT0,&l0);
  glGetBooleanv(GL_LIGHT1,&l1);
  int light_state = l0 | (l1<<1);
  glLightfv(GL_LIGHT0, GL_SPECULAR, spec_light);
  const double wt = world_time;

  if ( option == RO_Normally )
    {
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D,texid_emacs);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
      glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
      glEnable(GL_COLOR_SUM);
    }

  cyl.apex_radius = 1; cyl.set_color(color_lsu_spirit_purple);
  if ( option == RO_Shadow_Volumes )
    {
      if ( opt_shadow_volumes )
        {
          glEnable(GL_LIGHTING);
          glColorMask(true,true,true,true);
          glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
          glEnable(GL_BLEND);
          glBlendEquation(GL_FUNC_ADD);
          glBlendFunc(GL_ONE,GL_ONE);
          glColor3f(0.8,0,0);
        }
      cyl.light_pos = light_location;
      sphere.light_pos = light_location;

      sphere.render_bunch_gather_sv(wt);
      for ( Ball *ball: balls )
        sphere.render_shadow_volume(ball->radius,ball->position);

      sp_instances_sv->use();
      glUniform2i(3, opt_tryout1, opt_tryout2);
      sphere.render_bunch_render_sv();
      sp_fixed->use();

      for ( Link *link: links )
        {
          if ( link->snapped ) continue;
          if ( !link->is_renderable ) continue;
          if ( !link->is_simulatable ) continue; // Should check if straight.
          Ball *const ball1 = link->ball1;
          Ball *const ball2 = link->ball2;
          cyl.render_shadow_volume
            (ball1->position,0.3*ball1->radius,
             ball2->position-ball1->position);
        }
    }
  else
    {
      sphere.opt_texture = true;

      sphere.render_bunch_gather(wt);
      for ( Ball *ball: balls )
        {
          if ( ball->contact )
            sphere.color = color_gray;
          else if ( ball->mass > 0 && ball->mass < ball->mass_min )
            sphere.color = color_red;
          else if ( ball->mass > 0 && ball->locked )
            sphere.color = color_pale_green;
          else
            sphere.color = ball->color;
          sphere.render
            (ball->radius,ball->position,
             pMatrix_Rotation(ball->orientation));
        }

      sp_instances_sphere->use();
      glUniform1i(2, light_state);

      glUniform2i(3, opt_tryout1, opt_tryout2);
      sphere.render_bunch_render();

      glBindTexture(GL_TEXTURE_2D,texid_hw);

      const bool rl2 = opt_shader >= SO_Set_1;

      if ( rl2 )
        {
          render_link_2_start();
        }
      else
        {
          sp_phong->use();
          glUniform1i(2, light_state);
          glUniform2i(3, opt_tryout1, opt_tryout2);
        }

      for ( Link *link: links )
        {
          if ( !link->is_renderable ) continue;
          if ( !rl2 )
            render_link_1(link);
          else
            render_link_2_gather(link);
          continue;

          Ball *const ball1 = link->ball1;
          Ball *const ball2 = link->ball2;
          pVect dir1 = ball1->omatrix * link->cb1;
          pCoor pos1 = ball1->position + dir1;

          pVect dir2 = ball2->omatrix * link->cb2;
          pCoor pos2 = ball2->position + dir2;

          cyl.set_color(link->color);
          cyl.render(pos1,0.3*ball1->radius, pos2-pos1);
        }

      if ( rl2 )
        render_link_2_render();

    }

  sp_fixed->use();

  if ( option == RO_Shadow_Volumes ) return;

  sp_phong->use();
  glUniform1i(2, light_state);
  glUniform2i(3, opt_tryout1, opt_tryout2);

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
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,5.0);
  glColor3f(0.55,0.55,0.55);
  glDrawArrays(GL_QUADS,0,half_elements+4);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);

  sp_fixed->use();
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
  const float xr = .08;
  glFrustum(-xr,xr,-xr/aspect,xr/aspect,.1,5000);

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

  ogl_helper.fbprintf
    ("Head Ball Pos  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]\n",
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z );

  const char *sh_names[] = { "PLAIN", "SET 1", "SET 2" };

  ogl_helper.fbprintf
    ("Shader: %s  ('v' to change)  "
     "Tryout 1: %s  ('y' to change)  Tryout 2: %s  ('Y' to change)\n",
     sh_names[opt_shader],
     opt_tryout1 ? BLINK("ON","  ") : "OFF",
     opt_tryout2 ? BLINK("ON","  ") : "OFF");

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  //
  // Render ball reflection.  (Will be blended with dark tiles.)
  //

  if ( opt_mirror )
    {
      // Write stencil value 2 at location of dark (mirrored) tiles.
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
    }

  // Blend mirror tiles with possibly existing ball reflection.
  //
  glDepthFunc(GL_ALWAYS);

  glDisable(GL_STENCIL_TEST);
  glDisable(GL_TEXTURE_2D);

  glEnable(GL_LIGHTING);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR);
  glLightfv(GL_LIGHT0, GL_SPECULAR, color_black);

  glColor3fv(color_lsu_spirit_purple);

  glEnable(GL_BLEND);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_CONSTANT_ALPHA,GL_ONE_MINUS_CONSTANT_ALPHA); // src, dst
  glBlendColor(0,0,0,0.5);

  platform_tile_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);

  glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);

  glDisableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);

  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

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
      glDepthMask(false);

      glColorMask(false,false,false,false);

      // Don't waste time computing lighting.
      //
      glDisable(GL_LIGHTING);
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
      // have a positive stencil value.
      //
      render_objects(RO_Shadow_Volumes);

      glEnable(GL_LIGHTING);
      glColorMask(true,true,true,true);
      glDepthMask(true);

      // Use stencil test to prevent writes to shadowed areas.
      //
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,0,-1); // ref, mask

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

  glDepthFunc(GL_LESS);

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
  const bool kb_mod_s = ogl_helper.keyboard_shift;
  const bool kb_mod_c = ogl_helper.keyboard_control;
  const float move_amt = kb_mod_s ? 2.0 : kb_mod_c ? 0.08 : 0.4;

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
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'h': case 'H': opt_head_lock = !opt_head_lock; break;
  case 't': case 'T': opt_tail_lock = !opt_tail_lock; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'r': case 'R': opt_mirror = !opt_mirror; break;
  case 'o': opt_shadows = !opt_shadows; break;
  case 'O':
    opt_shadow_volumes = !opt_shadow_volumes;
    if ( opt_shadow_volumes ) opt_shadows = true;
    break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 's': case 'S': balls_stop(); break;
  case 'v': case 'V': opt_shader++; if ( opt_shader > 2 ) opt_shader = 0; break;
  case 'w': case 'W': balls_twirl(); break;
  case 'y': opt_tryout1 = !opt_tryout1; break;
  case 'Y': opt_tryout2 = !opt_tryout2; break;
  case ' ':
    if ( kb_mod_s ) opt_single_time_step = true; else opt_single_frame = true;
    opt_pause = true;
    break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;

  lock_update();
  sphere.bunch_invalidate();

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
World::init(int argc, char **argv)
{
  chain_length = 14;

  opt_time_step_duration = 0.0003;
  variable_control.insert(opt_time_step_duration,"Time Step Duration");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 500;
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

  world_time_link_update = 0;

  opt_mirror = true;
  opt_shadows = true;
  opt_shadow_volumes = false;
  opt_shader = SO_Set_1;

  init_graphics();

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  sp_phong = new pShader
    ("hw07-shdr.cc",// File holding shader program.
     "vs_main(); ",       // Name of vertex shader main routine.
     "gs_main_simple();", // Name of geometry shader main routine.
     "fs_main();"         // Name of fragment shader main routine.
     );

  sp_instances_sphere = new pShader
    ("hw07-shdr.cc",// File holding shader program.
     "vs_main_instances_sphere(); ", // Used to render many spheres at once.
     "gs_main_simple();", // Name of geometry shader main routine.
     "fs_main();"         // Name of fragment shader main routine.
     );

  sp_instances_sv = new pShader
    ("hw07-shdr.cc",// File holding shader program.
     "vs_main_instances_sv();" // Instances of vtx coord only. Use gl_Color.
     ,"gs_main_sv();",
     "fs_main_sv();"
     );


  PSplit exe_pieces(argv[0],'/');
  pString this_exe_name(exe_pieces.pop());

  const char* const links_shader_code_path = "hw07-shdr-links.cc";

  sp_set_1 = new pShader
    (links_shader_code_path,
     "vs_main_1(); ",     // Name of vertex shader main routine.
     "gs_main_1();",      // Name of geometry shader main routine.
     "fs_main();"       // Name of fragment shader main routine.
     );
  sp_set_2 = new pShader
    (links_shader_code_path,
     "vs_main_2(); ",     // Name of vertex shader main routine.
     "gs_main_2();",      // Name of geometry shader main routine.
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
  for ( Ball *ball: balls ) ball->spring_constant_sum = 0;
  const double dtis = pow( opt_time_step_duration, 2 );
  for ( Link *link: links )
    {
      Ball* const b1 = link->ball1;
      Ball* const b2 = link->ball2;
      b1->spring_constant_sum += opt_spring_constant;
      b2->spring_constant_sum += opt_spring_constant;
    }
  for ( Ball *ball: balls )
    {
      ball->mass_min = ball->spring_constant_sum * dtis;
      ball->constants_update();
    }
}

void
World::balls_twirl()
{
  if ( !head_ball || !tail_ball ) return;

  pNorm axis(head_ball->position, tail_ball->position);

  for ( Ball *ball: balls )
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
  link_change = true;
  balls.erase();
  links.erase();
}

Links
World::link_new(Ball *ball1, Ball *ball2, float stiffness)
{
  Links links_rv;
  assert( ball1->radius > 0 );
  assert( ball2->radius > 0 );

  Link* const rlink = new Link(ball1,ball2);
  links_rv += rlink;

  pNorm n12(ball1->position,ball2->position);
  const float rad_sum = ball1->radius + ball2->radius;
  pMatrix3x3 b1rot = ball1->omatrix;
  pMatrix3x3 b2rot = ball2->omatrix;
  pCoor ctr = ball1->position
    + ( ball1->radius + 0.5 * ( n12.magnitude - rad_sum ) ) * n12;

  pNorm b1_y = b1rot * pVect(0,1,0);
  pNorm b1_x = b1rot * pVect(1,0,0);
  bool b1_dir_is_y = fabs(dot(b1_y,n12)) < 0.999;
  pNorm b1_dir = b1_dir_is_y ? b1_y : b1_x;

  pNorm con_x = cross(b1_dir,n12);
  pVect con_y = cross(n12,con_x);
  rlink->b1_dir = mult_MTV( b1rot, con_y );
  rlink->b2_dir = mult_MTV( b2rot, con_y );

  const float lrad = stiffness * ball1->radius;

  for ( int i=0; i<3; i++ )
    {
      const double theta = i * 2 * M_PI / 3;
      pVect convec = lrad * ( cos(theta) * con_x + sin(theta) * con_y );
      pCoor con = ctr + convec;
      pVect cb1 = mult_MTV( b1rot, con - ball1->position );
      pVect cb2 = mult_MTV( b2rot, con - ball2->position );
      links_rv += new Link(rlink, cb1, cb2, 0);
    }
  return links_rv;
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

void
World::ball_setup_1()
{
  // Arrange balls to form sort of an umbrella.

  last_setup = 1;

  float ball_rad = 1;  // Warning: Re-assigned, changes behavior of nb.

  pCoor first_pos(17.2,ball_rad,-20.2);

  pVect dir_up(0.1,3,0.1);
  pVect dir_z(3*distance_relaxed,0,0);
  pVect dir_x(0,0,3*distance_relaxed);

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();

  auto nb =
    [&] (pCoor pos) {
      Ball* const ball = new Ball;
      ball->position = pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = ball_rad;
      ball->contact = false;
      balls += ball;
      return ball;
      };

  tail_ball = nb(first_pos);

  pCoor last_pos = tail_ball->position;

  Balls tail_balls;
  for ( int i=1; i<8; i++ )
    {
      ball_rad *= 0.8;
      Ball* const ball = nb(last_pos + (i==1?1.0:ball_rad) * dir_up);
      tail_balls += ball;
      links += link_new(balls[balls-2],ball,0.8);
      last_pos = ball->position;
    }

  head_ball = balls[balls-1];

  pNorm dir_zn(dir_z);
  pNorm dir_xn(dir_x);
  for ( Ball *ball: tail_balls )
    {
      if ( ball == head_ball ) break;
      pNorm to_top(ball->position,head_ball->position);
      const float r = to_top.magnitude;
      int num_hairs = max(4,int(7*r));
      ball_rad = ball->radius / 4;
      const float delta_theta = 2 * M_PI / num_hairs;
      for ( int i=0; i<num_hairs; i++ )
        {
          const float theta = i * delta_theta;
          pCoor pos = ball->position +
            r * cos(theta) * dir_xn + r * sin(theta) * dir_zn;
          Ball* const ballr = nb(pos);
          links += link_new(ballr,ball);
        }
    }

  opt_head_lock = false;
  opt_tail_lock = true; 
  setup_at_end();
}

void
World::ball_setup_2()
{
  // Arrange balls to form sort of an umbrella.

  last_setup = 2;

  pCoor first_pos(17.2,14.8f,-20.2);

  pVect dir_dn(0.5,first_pos.y/8,0.5);
  pVect dir_z(3*distance_relaxed,0,0);
  pVect dir_x(0,0,3*distance_relaxed);

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();

  float ball_rad = 0.3;  // Warning: Re-assigned, changes behavior of nb.

  auto nb =
    [&] (pCoor pos) {
      Ball* const ball = new Ball;
      ball->position = pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = ball_rad;
      ball->contact = false;
      balls += ball;
      return ball;
      };

  head_ball = nb(first_pos);
  for ( int j: {-1,1} )
    for ( int i: {-1,0,1} )
      {
        Ball* const ball = nb(first_pos - dir_dn + i * dir_x + j * dir_z );
        if ( i != 0 ) links += link_new(head_ball,ball);
        if ( i != -1 ) links += link_new(balls[balls-2],ball);
        if ( j == 1 && i != 0 )  links += link_new(balls[balls-4],ball);
      }

  Ball* const tail_start = nb(first_pos - dir_dn);
  links += link_new(balls[balls-6],tail_start);
  links += link_new(balls[balls-3],tail_start);
  pCoor last_pos = tail_start->position;
  Balls tail_balls;
  for ( int i=1; i<5; i++ )
    {
      Ball* const ball = nb(last_pos - 0.5 * dir_dn);
      tail_balls += ball;
      links += link_new(balls[balls-2],ball);
      last_pos = ball->position;
    }

  tail_ball = balls[balls-1];

  pNorm dir_zn(dir_z);
  pNorm dir_xn(dir_x);
  int num_hairs = 20;
  ball_rad = 0.1;
  for ( Ball *ball: tail_balls )
    {
      const float delta_theta = 2 * M_PI / num_hairs;
      for ( int i=0; i<num_hairs; i++ )
        {
          const float theta = i * delta_theta;
          const float r = ball->radius * 10;
          pCoor pos = ball->position +
            r * cos(theta) * dir_xn + r * sin(theta) * dir_zn;
          Ball* const ballr = nb(pos);
          links += link_new(ballr,ball);
        }
    }

  opt_head_lock = true;    // Head ball will be frozen in space.
  opt_tail_lock = false;   // Tail ball can move freely.
  setup_at_end();
}

void
World::ball_setup_3()
{
  last_setup = 3;
  objects_erase();

  pCoor first_pos(17.2,14.8f,-10.2);

  float ball_radius = 1;

  auto nb =
    [&] (pCoor pos) {
      Ball* const ball = new Ball;
      ball->position = pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = ball_radius;
      ball->contact = false;
      balls += ball;
      return ball;
      };

  head_ball = nb(first_pos);
  ball_radius = ball_radius * .1;

  for ( int i=0; i<500; i++ )
    {
      pNorm dir(0.5-drand48(),0.5-drand48(),0.5-drand48());
      Ball* const ball = nb(first_pos + head_ball->radius * 3 * dir);
      links += link_new(ball,head_ball,2);
    }

  tail_ball = balls[1];

  opt_head_lock = false;    // Head ball will be frozen in space.
  opt_tail_lock = false;   // Tail ball can move freely.

  setup_at_end();
}


void
World::ball_setup_4()
{
  last_setup = 4;
  objects_erase();
  setup_at_end();
}

void
World::ball_setup_5()
{
  last_setup = 5;
  objects_erase();
  setup_at_end();
}


void
World::setup_at_end()
{
}


 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu(double delta_t)
{
  time_step_count++;
  const int n_balls = balls;
  const int n_links = links;

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

#pragma omp parallel for
  for ( int bi=0; bi<n_balls; bi++ )
    {
      Ball* const ball = balls[bi];
      assert( ball->fdt_to_do );
      ball->force = ball->mass * gravity_accel;
      ball->torque = pVect(0,0,0);
    }

#pragma omp parallel for
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

#pragma omp parallel for
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
{ for ( Ball *ball: balls ) ball->translate(amt); }
void World::balls_push(pVect amt)
{ for ( Ball *ball: balls ) ball->push(amt); }
void World::balls_stop()
{ for ( Ball *ball: balls ) ball->stop(); }
void World::balls_freeze(){balls_stop();}


void
World::render_link_1(Link *link)
{
  Ball *const ball1 = link->ball1;
  Ball *const ball2 = link->ball2;

  // Direction of link relative to center off ball.
  //
  pVect dir1 = ball1->omatrix * link->cb1;

  // Place on surface of ball where link connects.
  //
  pCoor pos1 = ball1->position + dir1;

  // Direction and connection location for ball 2.
  //
  pVect dir2 = ball2->omatrix * link->cb2;
  pCoor pos2 = ball2->position + dir2;

  pVect p1p2(pos1,pos2);
  pNorm p1p2n(p1p2);

  // Number of segments used to construct link.  Each segment is
  // approximately a cylinder.
  //
  const int segments = opt_segments;

  // Number of sides of each cylinder.
  //
  const int sides = opt_sides;

  const float delta_tee = 1.0 / segments;

  // Radius of link.
  //
  const float rad = ball1->radius * 0.3;

  // Compute scale factors for texture.
  const float tex_aspect_ratio = 3147 / 1151;
  const float page_width_o = 2.5;  // Width of texture in object-space coords.
  const float tex_t_scale = link->distance_relaxed / page_width_o;
  const float tex_angle_scale = rad * tex_aspect_ratio / page_width_o;

  pNorm dirn1(dir1);
  pNorm dirn2(dir2);

  // Vectors used to describe the cubic Hermite curve.
  //
  pVect v1 = p1p2n.magnitude * dirn1;
  pVect v2 = p1p2n.magnitude * dirn2;

  // Convert link's local x and y axes to global coordinates.
  //
  pVect b1_ydir = ball1->omatrix * link->b1_dir;

  pVect b2_ydir = ball2->omatrix * link->b2_dir;

  pCoor pts[sides+1];
  pVect vecs[sides+1];

  pCoors coords;
  pVects norms;
  pVector<float> tcoords;

  for ( int i=0; i<=segments; i++ )
    {
      const float t = i * delta_tee;
      const float t2 = t * t;
      const float t3 = t2 * t;

      // Cubic Hermite interpolation.
      // Compute point along core of link.
      //
      pCoor ctr =
        ( 2*t3 - 3*t2 + 1 ) * pos1 + (-2*t3 + 3*t2 ) * pos2
        + (t3 - 2*t2 + t ) * v1 - (t3 - t2 ) * v2;

      // Compute direction of link at this point.
      //
      pNorm tan =
        ( 6*t2 - 6*t ) * pos1 + (-6*t2 + 6*t ) * pos2
        + (3*t2 - 4*t + 1 ) * v1 - (3*t2 - 2*t ) * v2;

      // Compute local x and y axes for drawing a cylinder.
      //
      pVect ydir = (1-t) * b1_ydir + t * b2_ydir;
      pNorm norm = cross(tan,ydir);
      pVect binorm = cross(tan,norm);

      for ( int j=0; j<sides; j++ )
        {
          const float theta = j * ( 2 * M_PI / sides );
          pCoor pt = pts[j];
          pVect vec = vecs[j];
          vecs[j] = cosf(theta) * norm + sinf(theta) * binorm;
          pts[j] = ctr + rad * vecs[j];

          if ( opt_shader == SO_Set_1 ) pts[j].w = theta;

          if ( i == 0 ) continue;

          tcoords += t * tex_t_scale;
          tcoords += theta * tex_angle_scale;

          norms += vecs[j];
          coords += pts[j];

          tcoords += ( t - delta_tee ) * tex_t_scale;
          tcoords += theta * tex_angle_scale;

          norms += vec;
          coords += pt;

        }
    }

  if ( !link_bo_vtx ) glGenBuffers(3,&link_bo_vtx);

  glBindBuffer(GL_ARRAY_BUFFER, link_bo_vtx);
  glBufferData
    (GL_ARRAY_BUFFER,           // Kind of buffer object.
     sizeof(coords[0])*coords.size(), coords.data(),
     GL_STREAM_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, link_bo_nrm);
  glBufferData
    (GL_ARRAY_BUFFER,           // Kind of buffer object.
     sizeof(norms[0])*norms.size(), norms.data(),
     GL_STREAM_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, link_bo_tco);
  glBufferData
    (GL_ARRAY_BUFFER,           // Kind of buffer object.
     sizeof(tcoords[0])*tcoords.size(), tcoords.data(),
     GL_STREAM_DRAW);

  const int num_vtx = coords.size();

  glColor3fv( color_dim_gray );

  glEnableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER, link_bo_vtx);
  glVertexPointer( 4, GL_FLOAT, sizeof(coords[0]), NULL);
  glEnableClientState(GL_NORMAL_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER, link_bo_nrm);
  glNormalPointer( GL_FLOAT, 0, NULL );
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER, link_bo_tco);
  glTexCoordPointer(2,GL_FLOAT,0,NULL);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  glDrawArrays(GL_TRIANGLE_STRIP, 0, num_vtx );

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);

}

void
World::render_link_2_start()
{
  if ( world_time_link_update == world_time ) return;

  if ( lis_pvects.size() == 0 )
    {
      lis_pvects += &lis_pos1;
      lis_pvects += &lis_pos2;

      lis_pvects += &lis_v1;
      lis_pvects += &lis_v2;
      lis_pvects += &lis_b1_ydir;
      lis_pvects += &lis_b2_ydir;
      lis_pvects += &lis_tex_rad;
      const int n_pvects = lis_pvects.size();
      lis_bos = new GLuint[n_pvects];
      glGenBuffers(n_pvects,lis_bos);
    }

  // Empty containers in preparation for a new pass.
  for ( auto vl: lis_pvects ) vl->clear();
}

void
World::render_link_2_gather(Link *link)
{
  // Place data needed to render link (the argument to this function)
  // in arrays. Just before rendering those arrays will be placed in
  // buffer objects.


  // If we've already collected links, just return.  This happens
  // when doing multiple passes to render shadows and reflections.
  //
  if ( world_time_link_update == world_time ) return;

  Ball *const ball1 = link->ball1;
  Ball *const ball2 = link->ball2;

  // Direction of link relative to center off ball.
  //
  pVect dir1 = ball1->omatrix * link->cb1;

  // Place on surface of ball where link connects.
  //
  pCoor pos1 = ball1->position + dir1;

  // Direction and connection location for ball 2.
  //
  pVect dir2 = ball2->omatrix * link->cb2;
  pCoor pos2 = ball2->position + dir2;

  pVect p1p2(pos1,pos2);
  pNorm p1p2n(p1p2);

  // Number of segments used to construct link.  Each segment is
  // approximately a cylinder.
  //
  const int segments = opt_segments;

  // Number of sides of each cylinder.
  //
  const int sides = opt_sides;

  const float delta_tee = 1.0 / segments;

  // Radius of link.
  //
  const float rad = ball1->radius * 0.3;

  // Compute scale factors for texture.
  const float tex_aspect_ratio = 8.5 / 11;  // Yes, inches. Can't remember mm.
  const float page_width_o = 2.5;  // Width of texture in object-space coords.
  const float tex_t_scale = link->distance_relaxed / page_width_o;
  const float tex_angle_scale = rad * tex_aspect_ratio / page_width_o;

  pNorm dirn1(dir1);
  pNorm dirn2(dir2);

  // Vectors used to describe the cubic Hermite curve.
  //
  pVect v1 = p1p2n.magnitude * dirn1;
  pVect v2 = p1p2n.magnitude * dirn2;

  // Convert link's local x and y axes to global coordinates.
  //
  pVect b1_ydir = ball1->omatrix * link->b1_dir;
  pVect b2_ydir = ball2->omatrix * link->b2_dir;


  // Place data needed to render links in lists. Note that
  // the += operator appends the right-hand side to the container
  // on the left-hand side.
  //
  lis_pos1 += pos1;
  lis_pos2 += pos2;
  lis_v1 += v1;
  lis_v2 += v2;
  lis_b1_ydir += b1_ydir;
  lis_b2_ydir += b2_ydir;
  pVect misc(tex_t_scale,tex_angle_scale,rad);
  lis_tex_rad += misc;
}



void
World::render_link_2_render()
{
  // Perform a rendering pass to render all the links collected
  // by the routine render_link_2.


  // Check whether this is the first time we are rendering this data.
  //
  const bool first_render = world_time_link_update != world_time;
  world_time_link_update = world_time;

  if ( opt_shader == SO_Set_1 )
    {
      // Use shaders vs_main_1 and gs_main_1
      //
      sp_set_1->use();
    }
  else
    {
      // Use shaders vs_main_2 and gs_main_2
      //
      sp_set_2->use();
    }

  // Number of segments used to construct link.  Each segment is
  // approximately a cylinder.
  //
  const int segments = opt_segments;

  // Number of sides of each cylinder.
  //
  const int sides = opt_sides;

  const float delta_tee = 1.0 / segments;
  const size_t n_instances = lis_pos1.size();

  // Bind buffer objects holding link and ball info to locations
  // specified in file hw07-shdr-links.cc
  //
  for ( size_t i=0; i<lis_pvects.size(); i++ )
    {
      GLuint bo = lis_bos[i];
      assert( lis_pvects[i]->size() == n_instances );
      glBindBuffer(GL_ARRAY_BUFFER,bo);
      if ( first_render )
        glBufferData
          (GL_ARRAY_BUFFER, lis_pvects[i]->size_chars(),
           lis_pvects[i]->data(), GL_STREAM_DRAW);
      glBindBufferBase(GL_SHADER_STORAGE_BUFFER,i+1,bo);
    }
  glBindBuffer(GL_ARRAY_BUFFER,0);

  glUniform4fv(1, 1, color_dim_gray ); // color_front
  glUniform4fv(2, 1, color_salmon ); // color_back
  glUniform2f(4, sides, 0 );
  glUniform1f(5, delta_tee );

  GLboolean l0, l1;
  glGetBooleanv(GL_LIGHT0,&l0);
  glGetBooleanv(GL_LIGHT1,&l1);
  int light_state = l0 | (l1<<1);
  glUniform1i(6, light_state);
  glUniform2i(3, opt_tryout1, opt_tryout2);

  glDrawArraysInstanced
    (GL_LINE_STRIP, 0, segments+1, n_instances);

  sp_fixed->use();
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

  frame_timer.phys_end();

  last_frame_wall_time = time_now;

  render();
}

int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper,argv,argc);

  glDisable(GL_DEBUG_OUTPUT);
  glDebugMessageControl(GL_DONT_CARE,GL_DONT_CARE,
                        GL_DEBUG_SEVERITY_NOTIFICATION,0,NULL,false);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
