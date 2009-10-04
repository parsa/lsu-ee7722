/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Simple Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// Purpose
//
//   Test out ideas for collision detection demo.


/// What Code Does


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
 //  'n'    Toggle visibility of platform normals.
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
  Ball(World *w);
  ~Ball(){ glDeleteQueries(1,&query_occlusion_id); }
  World& w;
  pCoor prev_position;
  pVect prev_velocity;
  bool prev_bcontact;
  double ts_t;
  double contact_t;
  int serial;

  GLuint query_occlusion_id;
  bool occlusion_query_active;
  bool occluded;
  int occluded_run;
  int occlusion_countdown;

  pColor color_event;
  pColor color_natural;

  pCoor position;
  pVect velocity;

  bool bcontact;

  pMatrix rotation_matrix;
  pMatrix orientation;
  pVect angular_momentum;
  int collision_count;

  void fly(double t);
  void fly_to(double t);
  pVect point_rot_vel(pNorm tact_dir);
  void apply_deltao(pNorm tact_dir, pNorm force_dir, double deltao);
  void apply_tan_do(pNorm tact_dir, pVect force);
  void apply_tan_dv(pNorm tact_dir, pVect force);
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};


const pColor red(0.8,0.1,0.1);
const pColor green(0.1,0.8,0.1);
const pColor blue(0.1,0.1,0.8);
const pColor cyan(0.1,0.8,0.8);
const pColor light_gray(0.8,0.8,0.8);
const pColor dark_gray(0.15,0.15,0.15);
const pColor lsu_business_purple(0x7f5ca2);
const pColor lsu_spirit_purple(0x580da6);
const pColor lsu_spirit_gold(0xf9b237);
const pColor lsu_official_purple(0x2f0462);
const pColor* const colors[8] =
  { &lsu_spirit_gold, &lsu_spirit_purple, &green, &blue,
    &red, &cyan, &light_gray, &dark_gray };
const int colors_mask = 0x7;


class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb),pball(this){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void cb_keyboard();
  void modelview_update();
  void shadow_update();
  void shadow_transform_create(pMatrix& m, pCoor light);
  void benchmark_setup(int tiers=1);

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;

  bool opt_normals_visible;
  bool opt_color_events;

  bool opt_spray_on;
  int spray_cnt, spray_run;
  double ball_countdown;

  bool opt_drip;
  int drip_cnt, drip_run;
  Ball *dball;

  bool opt_verify;
  bool opt_debug;

  bool opt_gravity;
  float opt_gravity_accel;      // Value chosen by user.
  float opt_ball_mass;
  float opt_ball_radius;
  float opt_bounce_loss;
  float opt_elasticity;
  float opt_friction_coeff;
  float opt_friction_roll;

  Ball pball;

  double delta_t;
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  pVect gravity_accel_dt;
  double ball_mass_inv;
  double elasticity_dt;
  double ball_mo_inertia;
  double two_r_sq;
  double two_r;
  double mo_vel_factor;
  double v_to_do;
  double r_inv;
  double short_xrad_sq;
  float platform_xmin_mr;
  float platform_xmax_pr;
  float platform_zmin_mr;
  float platform_zmax_pr;


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
  void platform_update();
  bool platform_collision_possible(pCoor pos, float ts_mov_max = 0);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_shadow;
  pMatrix transform_mirror;

  int balls_occluded;

  void ball_init();
  void variables_update();
  void balls_render();
  void balls_stop();
  void balls_rot_stop();
  void fly_to_pc(Ball *ball, double ts_t);
  void ball_surface_snap(Ball *ball);
  double ball_platform_collision_time(Ball *ball);
  double ball_ball_collision_time(Ball *ball1, Ball *ball2);
  double collision_platform_resolve(Ball *ball);
  double collision_ball_resolve(Ball *ball1, Ball *ball2, double limit_t);
  bool penetration_balls_resolve
  (Ball *ball1, Ball *ball2, bool b2_real = true);
  void time_step_cpu();

  PStack<Ball*> balls;
  Sphere sphere;
  Sphere sphere_lite;
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
  opt_spray_on = false;
  opt_color_events = false;
  opt_debug = true;

  eye_location = pCoor(17.9,-2,117.2);
  eye_direction = pVect(-0.15,-0.06,-0.96);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -80; platform_zmax = 80;
  texid_syl = pBuild_Texture_File("../gpup/gpup.png",false,255);
  texid_emacs = pBuild_Texture_File
    ( //"shot-emacs.png",
      "../gpgpu/mult.png",
     false,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(28.2,-2.8,-14.3);

  opt_ball_mass = 0.25;
  opt_ball_radius = 2;
  opt_friction_coeff = 0.2;
  opt_friction_roll = 0.1;
  opt_bounce_loss = 0.55;
  opt_elasticity = 1600;
  opt_drip = false;
  drip_cnt = spray_cnt = 0;
  drip_run = 3;
  spray_run = 8;
  dball = NULL;
  opt_verify = true;

  variable_control.insert(opt_ball_mass,"Ball Mass");
  variable_control.insert(opt_elasticity,"Elasticity");
  variable_control.insert(opt_friction_coeff,"Sliding Friction");
  variable_control.insert(opt_friction_roll,"Rolling Friction");
  variable_control.insert(opt_bounce_loss,"Bounce Energy Loss");
  variable_control.insert(opt_gravity_accel,"Gravity");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_ball_radius,"Ball Radius");

  opt_move_item = MI_Eye;
  opt_pause = false;

  pball.prev_velocity = pVect(0,0,0);

  ball_countdown = 0.1;
  sphere.init(40);
  sphere_lite.init(4);

  variables_update();
  platform_update();
  modelview_update();

  if ( opt_spray_on )
    {
      balls += new Ball(this);
      return;
    }

  const float r_short = platform_xrad - opt_ball_radius;

  if (true){
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(0,-r_short,40);
      b->velocity = pVect(0,0,0);
      balls += b;
    }
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(r_short*cos(1.75*M_PI),r_short*sin(1.75*M_PI),40);
      b->velocity = pVect(0,0,0);
      balls += b;
    }
  }

  if ( false )
    {
      Ball *b = new Ball(this);
      b->position = pCoor(0,-r_short,48);
      b->velocity = pVect(0,0,0);
      b->angular_momentum = pVect(0,6,0);
      balls += b;
      b = new Ball(this);
      b->position = pCoor(0,-r_short+3*opt_ball_radius,48);
      b->velocity = pVect(0,0,0);
      b->angular_momentum = pVect(0,1,0);
      balls += b;
    }

}

void
World::variables_update()
{
  ball_mass_inv = 1 / opt_ball_mass;
  r_inv = 1.0 / opt_ball_radius;
  const double r_sq = opt_ball_radius * opt_ball_radius;
  two_r_sq = 4 * r_sq;
  two_r = 2 * opt_ball_radius;
  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;
  gravity_accel_dt = delta_t * gravity_accel;
  sphere.radius = opt_ball_radius;
  sphere_lite.radius = opt_ball_radius;
  elasticity_dt = opt_elasticity * delta_t;
  if ( opt_bounce_loss > 1 ) opt_bounce_loss = 1;
  ball_mo_inertia = 0.4 * opt_ball_mass * r_sq;
  v_to_do = opt_ball_mass * opt_ball_radius / ball_mo_inertia;
  mo_vel_factor = 0.5 / ( 1 + v_to_do * opt_ball_radius );
  short_xrad_sq = pow(platform_xrad - opt_ball_radius,2);
  platform_xmin_mr = platform_xmin - opt_ball_radius;
  platform_zmin_mr = platform_zmin - opt_ball_radius;
  platform_xmax_pr = platform_xmax + opt_ball_radius;
  platform_zmax_pr = platform_zmax + opt_ball_radius;
}

void
World::platform_update()
{
  const float platform_delta_z = platform_zmax - platform_zmin;
  const int tile_count = int(max(1.0,platform_delta_z * 0.5));
  const float zdelta = platform_delta_z / tile_count;
  const float platform_delta_x = platform_xmax - platform_xmin;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<pVect> p_tile_norms;
  PStack<pVect> p1_tile_norms;
  PStack<float> p_tex_coords;
  platform_pi_xwidth_inv = M_PI / platform_delta_x;

  const int th_tile_count = 19;
  const double delta_theta = M_PI / th_tile_count;
  delta_theta_inv = 1.0 / delta_theta;
  tile_size_inv = 1 / zdelta;
  platform_xmid = 0.5 * ( platform_xmax + platform_xmin );
  platform_xrad = 0.5 * platform_delta_x;
  platform_xrad_inv = 1 / platform_xrad;

  const float platform_depth = platform_xrad;

  for ( int i = 0; i < th_tile_count; i++ )
    {
      const double theta0 = i * delta_theta;
      const double theta1 = theta0 + delta_theta;
      bool even = i & 1;
      const float x0 = platform_xmid - platform_xrad * cos(theta0);
      const float x1 = platform_xmid - platform_xrad * cos(theta1);
      const float y0 = -0.01 - platform_depth * sin(theta0);
      const float y1 = -0.01 - platform_depth * sin(theta1);
      pNorm norm0( platform_depth * cos(theta0), platform_xrad*sin(theta0), 0);
      pNorm norm1( platform_depth * cos(theta1), platform_xrad*sin(theta1), 0);
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
  shadow_update();
}

void
World::shadow_update()
{
  // These routines need to be made more general.
  pCoor platform_point(platform_xmin,0,platform_zmin);
  pVect platform_normal(0,1,0);
  shadow_transform_create(modelview_shadow,light_location);
  pCoor eye_loc_mirror(eye_location.x, -eye_location.y, eye_location.z);
  pMatrix reflect; reflect.set_identity(); reflect.rc(1,1) = -1;
  transform_mirror = modelview * reflect * invert(modelview);
}

void
World::shadow_transform_create(pMatrix& m, pCoor light_location)
{
  pVect platform_normal(0,1,0);
  pVect eye_normal(0,0,-1);
  pMatrix_Translate center_light(-light_location);
  pNorm axis(-platform_normal,eye_normal);
  const double angle = asin(axis.magnitude);
  pMatrix_Rotation rotate_platform(axis,angle);
  pMatrix frustum; frustum.set_zero();
  frustum.rc(0,0) = frustum.rc(1,1) = light_location.y;
  frustum.rc(3,2) = -1;
  pMatrix_Translate restore_z(0,0,-light_location.y);
  pMatrix step1 = rotate_platform * center_light;
  pMatrix to_platform = restore_z * frustum * rotate_platform * center_light;
  pMatrix_Rotation un_rotate_platform(axis,-angle);
  pMatrix_Translate un_center_light(light_location);
  pMatrix from_platform = un_center_light * un_rotate_platform;
  pMatrix project = from_platform * to_platform;
  modelview_shadow = modelview * from_platform * to_platform;

  // Compute coordinates to help with debugging.
  //
  pCoor test_pt(1.1,0,2.2);
  pCoor test_pt2(1.1,1,2.2);
  pCoor test_pt_a = step1 * test_pt;
  pCoor test_pt_b = to_platform * test_pt;  test_pt_b.homogenize();
  pCoor test_pt_pr = project * test_pt;  test_pt_pr.homogenize();
  pCoor test_pt2_pr = project * test_pt2;  test_pt2_pr.homogenize();
}

void
World::benchmark_setup(int tiers)
{
  while ( balls.occ() ) delete balls.pop();
  const float delta_z = opt_ball_radius * 5;
  const float delta_x = opt_ball_radius * 2.1;
  const float hdeltaz = delta_z / 2;
  const float hdeltax = delta_x / 2;
  const float delta_y = 2.1 * opt_ball_radius;
  const float ymax = delta_y * tiers - 0.001;
  opt_drip = false;
  opt_spray_on = false;
  opt_verify = false;
  //  opt_friction_roll = 0.01; opt_friction_coeff = 0.01;
  for ( float z = platform_zmin + hdeltaz; z < platform_zmax; z+= delta_z )
    for ( float x = platform_xmin + hdeltax; x < platform_xmax; x += delta_x )
      for ( float y = 0; y < ymax; y+= delta_y )
        {
          Ball* const b = new Ball(this);
          b->velocity.z = 0;
          b->position = pCoor(x,y,z);
          balls += b;
        }
}


///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

int ball_serial_next = 0;

Ball::Ball(World* w):w(*w)
{
  occluded = false;
  occlusion_query_active = false;
  occluded_run = 0;
  occlusion_countdown = 0;
  glGenQueries(1,&query_occlusion_id);
  collision_count = 0;
  color_event = pColor(0.5,0.5,0.5);
  color_natural = pColor(0.5,0.5,0.5);
  serial = ball_serial_next++;
  position = pCoor(30,22,-15.4);
  velocity = pVect(random()/(0.0+RAND_MAX),0,random()/(0.0+RAND_MAX));

  orientation.set_identity();
  rotation_matrix.set_identity();

  angular_momentum = pVect(0,0,0);
  contact_t = -1000;
}


bool
World::platform_collision_possible(pCoor pos, float ts_mov_max)
{
  return pos.y < opt_ball_radius + ts_mov_max
    && pos.x - ts_mov_max >= platform_xmin_mr
    && pos.x + ts_mov_max <= platform_xmax_pr
    && pos.z - ts_mov_max >= platform_zmin_mr
    && pos.z + ts_mov_max <= platform_zmax_pr;
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
void Ball::stop()
{
  velocity = pVect(0,0,0);
}
void World::balls_stop()
{
  for ( Ball *ball; balls.iterate(ball); ) ball->stop();
}
void World::balls_rot_stop()
{
  for ( Ball *ball; balls.iterate(ball); ) ball->angular_momentum = pVect(0,0,0);
}

double
World::ball_ball_collision_time(Ball *ball1, Ball *ball2)
{
  const double ball2_dt = ball1->ts_t - ball2->ts_t;
  const pCoor pos1(ball1->position);
  const pCoor pos2 = ball2->position + ball2->velocity * ball2_dt;
  const pVect cp0(pos2,pos1);
  const pVect delta_v = ball1->velocity - ball2->velocity;
  const double delta_s_sq = dot(delta_v,delta_v);
  const double rsq = 4 * opt_ball_radius * opt_ball_radius;
  const double dist_sq = dot(cp0,cp0);
  const double separation = dist_sq - rsq;
  if ( separation < -0.001 ) ball1->bcontact = ball2->bcontact = true;
  if ( delta_s_sq < 1e-10 ) return 1e20;
  const double vcp0 = dot(delta_v,cp0);
  const double radical = 4 * ( vcp0 * vcp0 - delta_s_sq * separation );
  if ( radical < 0 ) return 1e20;
  const double sqrt_radical = sqrt(radical);
  const double t1 = ( -2 * vcp0 + sqrt_radical ) / ( 2 * delta_s_sq );
  const double t2 = ( -2 * vcp0 - sqrt_radical ) / ( 2 * delta_s_sq );
  const double tmin = min(t1,t2);
  return ball1->ts_t + tmin;
}

double
World::collision_ball_resolve(Ball *ball1, Ball *ball2, double limit_t)
{
  const double check = distance(ball1->position,ball2->position);
  ASSERTS ( fabs( check - 2 * opt_ball_radius ) < 0.01 );
  const pNorm norm_12(ball1->position,ball2->position);
  const pVect delta_v = ball1->velocity - ball2->velocity;
  double coll_spd = dot(delta_v,norm_12);
  const float coll_spd_min = 0;
  if ( coll_spd < coll_spd_min ) coll_spd = coll_spd_min;

  pVect coll_vel = coll_spd  * norm_12 * ( 1 - 0.5 * opt_bounce_loss );

  ball1->collision_count++;  ball2->collision_count++;
  ball1->velocity = ball1->velocity - coll_vel;
  ball2->velocity = ball2->velocity + coll_vel;
  return 0;
}

double
World::collision_platform_resolve(Ball *ball)
{
  pCoor axis(0,0,ball->position.z);
  pNorm ax_normal(ball->position,axis);
  const float v_to_axis = dot(ball->velocity,ax_normal);
  if ( v_to_axis < 0 )
    ball->velocity -= (2 - opt_bounce_loss ) * v_to_axis * ax_normal;
  return v_to_axis;
}

bool
World::penetration_balls_resolve(Ball *ball1, Ball *ball2, bool b2_real)
{
  const pNorm dist(ball1->position,ball2->position);

  if ( dist.mag_sq >= two_r_sq ) return false;

  ball1->collision_count++;  ball2->collision_count++;

  pVect appr_vel = ball1->velocity - ball2->velocity;
  pVect prev_appr_vel = ball1->prev_velocity - ball2->prev_velocity;
  const double approach_speed = dot( appr_vel, dist );
  const double prev_approach_speed = dot( prev_appr_vel, dist );

  const double loss_factor = 1 - opt_bounce_loss;

  const double appr_deltas_no_loss =
    ( two_r - dist.magnitude ) * elasticity_dt * ball_mass_inv;

  const double appr_deltas =
    approach_speed > 0
    ? appr_deltas_no_loss : loss_factor * appr_deltas_no_loss;

  ball1->velocity -= appr_deltas * dist;
  if ( b2_real ) ball2->velocity += appr_deltas * dist;

  pVect tact1_rot_vel = ball1->point_rot_vel(dist);
  pVect tact2_rot_vel = ball2->point_rot_vel(-dist);

  const bool use_prev_vel = true;

  pVect tan_vel_prev = prev_appr_vel - prev_approach_speed * dist;
  pVect tan_vel_curr = appr_vel - approach_speed * dist;
  pVect tan_vel = use_prev_vel ? tan_vel_prev : tan_vel_curr;
  pNorm tact_vel_dir = tact1_rot_vel - tact2_rot_vel + tan_vel;

  const double fric_dv_potential =
    fabs(appr_deltas_no_loss) * opt_friction_coeff;

  const double dv_limit_raw = tact_vel_dir.magnitude * mo_vel_factor;
  const double dv_limit = b2_real ? dv_limit_raw : 2 * dv_limit_raw;
  const bool will_roll = dv_limit <= fric_dv_potential;
  const double sliding_fric_deltav =
    will_roll ? dv_limit : fric_dv_potential;

  const double dv_tolerance = 0.000001;

  if ( sliding_fric_deltav > dv_tolerance )
    {
      const double fric_deltao = sliding_fric_deltav * v_to_do;

      ball1->apply_deltao(dist,tact_vel_dir,-fric_deltao);
      ball1->velocity -= sliding_fric_deltav * tact_vel_dir;

      if ( b2_real )
        {
          ball2->apply_deltao(-dist,tact_vel_dir,fric_deltao);
          ball2->velocity += sliding_fric_deltav * tact_vel_dir;;
        }
    }

  if ( !use_prev_vel && opt_verify && b2_real && will_roll )
    {
      pVect appr_vel2 = ball1->velocity - ball2->velocity;
      const double approach_speed2 = dot( appr_vel2, dist );

      pVect tact1_rot_vel2 = ball1->point_rot_vel(dist);
      pVect tact2_rot_vel2 = ball2->point_rot_vel(-dist);

      pVect tan_vel2 = appr_vel2 - approach_speed2 * dist;
      pNorm tan_vel_dir2 = tact1_rot_vel2 - tact2_rot_vel2 + tan_vel2;
      ASSERTS( tan_vel_dir2.magnitude <= 0.0001 + 100 * dv_tolerance );
      ball1->color_event = ball2->color_event = pColor(1,1,1);
    }

  {
    /// Torque
    //
    const double appr_omega =
      dot(ball1->angular_momentum,dist) - dot(ball2->angular_momentum,dist);
    const double fric_deltao_pot = fric_dv_potential * v_to_do;
    const bool rev = appr_omega < 0;
    const double fric_deltao = min(fabs(appr_omega),fric_deltao_pot);
    pVect delta_am = rev ? -fric_deltao * dist : fric_deltao * dist;
    ball1->angular_momentum -= delta_am;
    if ( b2_real ) ball2->angular_momentum += delta_am;
  }

  if ( !opt_debug ) return true;

  {
    /// Rolling Friction
    //
    pVect tan_b12_vel = b2_real ? 0.5 * tan_vel : pVect(0,0,0);
    const double torque_limit_sort_of = appr_deltas_no_loss
      * sqrt( opt_ball_radius - 0.25 * dist.mag_sq * r_inv );

    pVect tact1_rot_vel = ball1->point_rot_vel(dist);
    pVect tact1_roll_vel = tact1_rot_vel + tan_b12_vel;
    pNorm tact1_roll_vel_dir = tact1_roll_vel;
    pVect lost_vel(0,0,0);

    const double rfric_loss1 =
      torque_limit_sort_of *
      ( tact1_roll_vel_dir.magnitude * opt_friction_roll /
        ( 1 + tact1_roll_vel_dir.magnitude * opt_friction_roll ) );
    
    pVect lost_vel1 =
      min(tact1_roll_vel_dir.magnitude, rfric_loss1) * tact1_roll_vel_dir;

    lost_vel = -lost_vel1;
    
    if ( b2_real )
      {
        pVect tact2_rot_vel = ball2->point_rot_vel(-dist);
        pVect tact2_roll_vel = tact2_rot_vel - tan_b12_vel;
        pNorm tact2_roll_vel_dir = tact2_roll_vel;
        const double rfric_loss2 =
          torque_limit_sort_of *
          ( tact2_roll_vel_dir.magnitude * opt_friction_roll /
            ( 1 + tact2_roll_vel_dir.magnitude * opt_friction_roll ) );
        pVect lost_vel2 =
          min(tact2_roll_vel_dir.magnitude, rfric_loss2 ) * tact2_roll_vel_dir;

        lost_vel += lost_vel2;
      }

    ball1->apply_tan_dv(dist,lost_vel);
    if ( b2_real ) ball2->apply_tan_dv(dist,lost_vel);

    if ( opt_verify )
      {
        pVect ch_tact1_rot_vel = ball1->point_rot_vel(dist);
        pVect ch_tact1_roll_vel = ch_tact1_rot_vel + tan_b12_vel;
        const double magloss = tact1_roll_vel.mag() - ch_tact1_roll_vel.mag();
        ASSERTS( magloss >= -10.0 );
      }
  }

  return true;
}

class Contact {
public:
  Contact(){};
  Contact(double t, Ball *ball):t(t),ball1(ball),ball2(NULL){};
  Contact(double t, Ball *ball1, Ball *ball2):
    t(t),ball1(ball1),ball2(ball2){};
  double t;
  Ball *ball1, *ball2;
};

void Ball::fly_to(double goal_ts){ fly(goal_ts-ts_t); }
void Ball::fly(double t){ position += t * velocity; ts_t += t; }

pVect
Ball::point_rot_vel(pNorm direction)
{
  return w.opt_ball_radius * cross( angular_momentum, direction );
}

void
Ball::apply_deltao(pNorm tact_dir, pNorm force_dir, double deltao)
{
  apply_tan_do(tact_dir, deltao * force_dir );
}

void
Ball::apply_tan_do(pNorm tact_dir, pVect force)
{
  pVect axis_torque = cross( tact_dir, force );
  angular_momentum += axis_torque;
}

void
Ball::apply_tan_dv(pNorm tact_dir, pVect force)
{
  apply_tan_do(tact_dir, force * w.r_inv );
}


void
World::fly_to_pc(Ball *ball, double ts_t)
{
  ball->fly_to(ts_t);
}

void
World::ball_surface_snap(Ball *ball)
{
  ASSERTS( false );
  if ( !platform_collision_possible(ball->position) ) return;
  const float short_r = platform_xrad - 1.001 * opt_ball_radius;
  pNorm norm(ball->position.x,ball->position.y,0);
  if ( norm.magnitude < short_r ) return;
  ball->position = pCoor(0,0,ball->position.z) + norm * short_r;
}

void
World::time_step_cpu()
{
  const float deep = -100;

  for ( Ball *ball; balls.iterate(ball); )
    if ( ball->position.y < deep ) { balls.iterate_yank(); delete ball; }

  for ( Ball *ball; balls.iterate(ball); )
    {

      ball->prev_velocity = ball->velocity;
#if 0
      ball->prev_position = ball->position;
      ball->prev_bcontact = ball->bcontact;
      ball->bcontact = false;
#endif
      ball->ts_t = 0;
    }

  for ( Ball *ball; balls.iterate(ball); ) ball->velocity += gravity_accel_dt;

  const float region_length = two_r;

  PSList<Ball*,double> z;
  for ( Ball *ball; balls.iterate(ball); ) z.insert(ball->position.z,ball);
  z.sort();
  for ( int idx0 = 0, idx9 = 0; idx9 < z.occ(); idx9++ )
    {
      Ball* const ball9 = z[idx9];
      const float z_min = ball9->position.z - region_length;

      while ( idx0 < idx9 && z[idx0]->position.z < z_min ) idx0++;

      for ( int i=idx0; i<idx9; i++ )
        penetration_balls_resolve(z[i],ball9);
    }

  for ( Ball *ball; balls.iterate(ball); )
    {
      const pCoor pos(ball->position);
      if ( !platform_collision_possible(pos) ) continue;

      pCoor axis(platform_xmid,0,pos.z);

      if ( pos.y > 0 )
        {
          pCoor tact
            (pos.x > platform_xmid ? platform_xmax : platform_xmin, 0, pos.z);
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= two_r_sq ) continue;
          pball.position = tact + opt_ball_radius * tact_dir;
        }
      else if ( pos.z > platform_zmax || pos.z < platform_zmin )
        {
          pNorm ball_dir(axis,pos);
          if ( ball_dir.mag_sq <= short_xrad_sq ) continue;
          const float zedge =
            pos.z > platform_zmax ? platform_zmax : platform_zmin;
          pCoor axis_edge(platform_xmid,0,zedge);
          pCoor tact = axis_edge + platform_xrad * ball_dir;
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= two_r_sq ) continue;
          pball.position = tact + opt_ball_radius * tact_dir;
        }
      else
        {
          pNorm tact_dir(axis,pos);
          if ( tact_dir.mag_sq <= short_xrad_sq ) continue;
          pball.position = axis + (opt_ball_radius+platform_xrad) * tact_dir;
        }

      pball.angular_momentum = pVect(0,0,0);
      pball.velocity = pVect(0,0,0);
      penetration_balls_resolve(ball,&pball,false);
    }

  for ( Ball *ball; balls.iterate(ball); ) fly_to_pc(ball,delta_t);

  float contact_y_max = -platform_xrad;

  for ( Ball *ball; balls.iterate(ball); )
    {
      pNorm axis(ball->angular_momentum);
      if ( axis.mag_sq < 0.000001 ) continue;
      ball->rotation_matrix = pMatrix_Rotation(axis,delta_t * axis.magnitude);
      pMMultiply3x3
        (ball->orientation,ball->rotation_matrix,ball->orientation);
      if ( ball->collision_count && ball->position.y > contact_y_max )
        contact_y_max = ball->position.y;
    }

  ball_countdown -= delta_t;

  if ( opt_drip && ( !dball || dball->collision_count ) )
    {
      dball = new Ball(this);
      dball->position =
        pCoor(60,max(20.0f,contact_y_max) + 3 * opt_ball_radius,20);
      dball->velocity = pVect(0,0,0);
      dball->color_natural = *colors[ ( drip_cnt >> drip_run ) & colors_mask ];
      drip_cnt++;
      balls += dball;
    }

  if ( opt_spray_on && ball_countdown <= 0 || balls.occ() == 0 )
    {
      Ball* const nball = new Ball(this);
      double r = opt_ball_radius * 5;
      double c = 2 * M_PI * r;
      const double delta_theta =
        0.0001 + 2 * M_PI / ( c / (2 * opt_ball_radius ) );
      static double th = 0;  th += delta_theta;
      nball->position.x = platform_xmax - r - 2 * opt_ball_radius
        + (r+opt_ball_radius) * cos(th);
      nball->position.z = (r+opt_ball_radius) * sin(th);
      nball->position.y = max(20.0f,contact_y_max + 3 * opt_ball_radius);
      nball->color_natural = *colors[ ( spray_cnt>>spray_run ) & colors_mask ];
      spray_cnt++;
      balls += nball;
      ball_countdown = 0.1;
    }
}

class Collide_Line_Sphere {
public:
  Collide_Line_Sphere(pCoor& p0, pVect& v, pCoor c, float r)
  {init(p0,v,c,r);}
  void init(pCoor& p0, pVect& v, pCoor c, float r)
  {
    t1 = t2 = tmin = tmax = 1e20;
    const pVect cp0(c,p0);
    delta_s_sq = dot(v,v);
    const double rsq = r * r;
    dist_sq = dot(cp0,cp0);
    const double separation = dist_sq - rsq;
    if ( delta_s_sq < 1e-10 ) return;
    const double vcp0 = dot(v,cp0);
    const double radical = 4 * ( vcp0 * vcp0 - delta_s_sq * separation );
    if ( radical < 0 ) return;
    const double sqrt_radical = sqrt(radical);
    t1 = ( -2 * vcp0 + sqrt_radical ) / ( 2 * delta_s_sq );
    t2 = ( -2 * vcp0 - sqrt_radical ) / ( 2 * delta_s_sq );
    tmin = min(t1,t2);
    tmax = max(t1,t2);
  }
  double delta_s_sq, dist_sq;
  double delta_s;
  double t1, t2, tmin, tmax;
};

double
World::ball_platform_collision_time(Ball *ball)
{
  if ( ! platform_collision_possible(ball->position) ) return 1e20;
  pCoor pos_xy(ball->position.x,ball->position.y,0);
  pVect vel_xy(ball->velocity.x,ball->velocity.y,0);
  const float short_r = platform_xrad - opt_ball_radius;
  Collide_Line_Sphere collide(pos_xy,vel_xy,pVect(0,0,0),short_r);
  const double t = collide.tmin < 0 ? collide.tmax : collide.tmin;
  return t + ball->ts_t;
}

void
World::balls_render()
{
  PSList<Ball*,double> eye_dist;
  for ( Ball *ball; balls.iterate(ball); )
    {
      pVect ve(ball->position,eye_location);
      eye_dist.insert(dot(ve,ve),ball);
    }
  eye_dist.sort();
  balls_occluded = 0;

  for ( Ball *ball; eye_dist.iterate(ball); )
    {
      sphere.color = opt_color_events ? ball->color_event : ball->color_natural;

      while ( ball->occlusion_query_active )
        {
          GLint avail = -1;
          glGetQueryObjectiv
            (ball->query_occlusion_id,GL_QUERY_RESULT_AVAILABLE,&avail);
          if ( !avail ) break;
          GLint samples_passed = -1;
          glGetQueryObjectiv
            (ball->query_occlusion_id,GL_QUERY_RESULT,&samples_passed);
          ball->occlusion_query_active = false;
          ball->occluded = samples_passed == 0;
          if ( ball->occluded ) ball->occluded_run++;
          else                  ball->occluded_run = 0;
          ball->occlusion_countdown = 3;
          break;
        }
      const bool do_ot = ball->occlusion_countdown-- <= 0;

      if ( ball->occluded ) balls_occluded++;
      
      if ( ball->occluded_run > 10 && !do_ot ) continue;

      if ( do_ot )
        glBeginQuery(GL_SAMPLES_PASSED,ball->query_occlusion_id);
      if ( ball->occluded_run > 10 )
        sphere_lite.render_simple(ball->position);
      else
        sphere.render(ball->position,ball->orientation);
      if ( do_ot )
        {
          ball->occlusion_query_active = true;
          glEndQuery(GL_SAMPLES_PASSED);
        }
    }
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
      const double new_delta_t = min(1.0/160,time_now - world_time);
      if ( delta_t != new_delta_t )
        {
          delta_t = new_delta_t;
          variables_update();
        }
      int iters = 0;
      while ( world_time < time_now && iters++ < 10 )
        {
          time_step_cpu();
          world_time += delta_t;
        }
      frame_timer.work_amt_set(iters);
    }

  /// Emit a Graphical Representation of Simulation State
  //
  
  // Understanding of the code below not required for introductory
  // lectures.

  // That said, much of the complexity of the code is to show
  // the ball shadow and reflection.

  const pColor white(0xffffff);
  const pColor gray(0x303030);
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

  pCoor light1_location(0,40,100);
  glLightfv(GL_LIGHT1, GL_POSITION, light1_location);
  glLightf(GL_LIGHT1, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT1, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT1, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x555555);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);

  glLightfv(GL_LIGHT1, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT1, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT1, GL_SPECULAR, white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHT1);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

  pColor color_ball(0x666666);
  pColor scolor_ball(0x111111);
  const float shininess_ball = 1;

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

  Ball& ball = *balls.peek();
  ogl_helper.fbprintf
    ("Ball Count %d (%d/%d) %d  Last Ball Pos  "
     "[%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]  Verify %d\n",
     balls.occ(), 
     balls.occ() - balls_occluded, balls_occluded,
     opt_debug,
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z, opt_verify );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  if ( false )
    {
      // Note: This code only works for a planar platform.

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

      balls_render();

      glFrontFace(GL_CCW);
      glMatrixMode(GL_PROJECTION);
      glPopMatrix();
      glDisable(GL_STENCIL_TEST);
    }

  if ( false )
    {
      // Note: This code only works for a planar platform.

      //
      // Write framebuffer stencil with shadow.
      //

      // Use transform that maps vertices to platform surface.
      //
      glMatrixMode(GL_MODELVIEW);
      glPushMatrix();
      glLoadTransposeMatrixf(modelview_shadow);

      glDisable(GL_LIGHTING);
      glDisable(GL_TEXTURE_2D);

      glEnable(GL_STENCIL_TEST);
      glStencilFunc(GL_NEVER,1,-1); // ref, mask
      glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);  // sfail, dfail, dpass

      balls_render();

      glEnable(GL_LIGHTING);
      glDisable(GL_STENCIL_TEST);
      glPopMatrix();
    }

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

  glDisable(GL_LIGHTING);
  glDisable(GL_BLEND);
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_STENCIL_TEST);
  frame_timer.frame_end();

  glColor3f(0.5,1,0.5);
  ogl_helper.user_text_reprint();
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
  case FB_KEY_F8:
    {
      opt_elasticity = 10;
      opt_friction_roll = 300;
      opt_friction_coeff = 0.0001;
      break;
    }
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'c': case 'C': opt_color_events = !opt_color_events; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'd': case 'D': opt_drip = !opt_drip; if(!opt_drip)dball=NULL; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_normals_visible = !opt_normals_visible; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 's': balls_stop(); break;
  case 'S': balls_rot_stop(); break;
  case 'T': benchmark_setup(); break;
  case 't': benchmark_setup(5); break;
  case 'q': opt_debug = !opt_debug; break;
  case 'v': opt_verify = !opt_verify; break;
  case 'x': opt_spray_on = !opt_spray_on; break;
  case 'X':
    {
      Ball* const b1 = new Ball(this);
      b1->position = pCoor(30,22,20);
      b1->velocity = pVect(0,0,0);
      b1->color_natural = lsu_spirit_purple;
      balls += b1;
      Ball* const b2 = new Ball(this);
      b2->position = b1->position;
      b2->position.z += 4 * opt_ball_radius;
      b2->velocity = pVect(0,0,0);
      b2->color_natural = lsu_spirit_gold;
      balls += b2;
    }
    break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  variables_update();

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
      case MI_Ball: balls.peek()->translate(adjustment); break;
      case MI_Ball_V: balls.peek()->push(adjustment); break;
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

