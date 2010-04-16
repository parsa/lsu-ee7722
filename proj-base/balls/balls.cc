/// LSU EE 7700-1 (Spring 2010),  GPU Course
//
 /// Demo of Dynamic Simulation, Multiple Balls on Curved Platform

// $Id:$

/// This file set up for Spring 2010 Homework 3

/// Purpose
//
//   Demonstrate Several Graphical and Simulation Techniques.
//   Base for course projects.

// Image: http://www.ece.lsu.edu/koppel/gpup/code/gpup/balls.png


/// What Code Does

//  Simulates balls bouncing on a half-cylinder platform with
//    a water wheel and some steps.

//  Features

//    Ball friction and angular momentum modeled.

//    Physics computed by CPU or by GPU/CUDA (user selectable).
//      Demonstrates use of CUDA for GPU physics, also use of
//      CPU multi-threading (currently only in conjunction with CUDA).

//    Balls cast shadows on platform:
//      Demonstrates use of stencils and shadow volumes.

//    Ball reflections visible on mirrored tiles.
//      Demonstrates stencils, blending, vertex, and geometry shaders.
//      Vertex shader computes reflection locations (> 1 per vertex).
//      Geometry shader emits triangles for all reflection points.
//      Later, tile image is blended over reflected image of balls.

//    Occlusion queries used to limit number of balls rendered.

//    Two-color specular lighting used for balls.




///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move ball. (Change position but not velocity.)
 //   'D': Move ball drip location.
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
 //  'a'    Switch physics method (CPU to GPU/CUDA).

 //  'd'    Toggle dripping of balls.
 //  'x'    Toggle shower of balls.
 //  'X'    Release one pair of balls.
 //  't'    Run 5-tier-of-balls benchmark.
 //  'T'    Run 1-tier-of-balls benchmark.
 //  'R'    Remove all but one ball.

 //  'm'    Toggle reflections on mirror tiles.
 //  'w'    Toggle shadows.
 //  'W'    Toggle visibility of shadow volumes.
 //  'n'    Toggle visibility of platform normals.

 //  's'    Stop balls linear motion.
 //  'S'    Stop balls rotational motion.

 //  'c'    Use colors to show number of reflected points, and other info.
 //  'M'    Switch between different shortcuts in computing reflections.

 //  'g'    Turn gravity on and off.
 //  'F10'  Write video to file.
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
 //  VAR Light Intensity 
 //              - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)
 //  VAR Ball Mass
 //  VAR Ball Radius
 //  VAR Elasticity 
 //              - Softness of balls. (Inverse of spring constant
 //                used to compute repulsion forces when balls touch.)
 //  VAR Sliding Friction 
 //              - Dynamic friction coefficient. Used for ball/ball
 //                and ball/platform contact.  The standard friction model
 //                is used, frictional force is proportional to force
 //                between two sliding surfaces.
 //  VAR Rolling Friction
 //              - Rolling friction coefficient. Used both for
 //                ball/ball and ball/platform rolling. Frictional
 //                model is ad-hoc, with force proportional to ball
 //                rotation with respect to contact point and ball
 //                deformation.
 //  VAR Bounce Energy Loss
 //              - Amount of energy lost in contact.
 //  VAR Block Size
 //              - Size of CUDA thread block, used both for the
 //                platform and pairs passes.
 //  VAR Color by Block in Pass
 //              - If opt_color_events is on, use block number
 //                in PASS to determine color of ball.


#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <math.h>
#include <pthread.h>

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
#include <gp/cuda-util.h>
#include "shapes.h"
#include "balls.cuh"


///
/// Main Data Structures
///
//

// Class World: All data about scene.
class World;

// Class Contact: Information about pair of nearby balls.
class Contact;

// Struct Pairs_Chunk_Info: Information used for CPU parallelization.
struct Pairs_Chunk_Info;

// Class Tile: Physical rectangular object.
class Tile;

// Class Pass: Information needed for a CUDA launch of a pair pass kernel.
//
class Pass {
public:
  Pass(){ block_cnt = 0; round_cnt = 0; }
  dim3 dim_grid, dim_block;
  int balls_per_block_max;
  int balls_per_thread_max;
  int block_num_base, block_num_next_pass;
  int block_cnt;
  int round_cnt;
  int thread_num_max;           // Maximum thread number of any block.
  int thread_cnt_max;           // Maximum number of threads used in any block.
  int prefetch_offset;
  int schedule_offset;
  int prefetch_elts_per_block;
  int ball_cnt;
};


// Cast a Phys to a more specialized compatible class, or NULL.
//
#define BALL(p) \
  ({Phys* const _p = p; _p->phys_type == PT_Ball ? (Ball*) _p : NULL;})
#define TILE(p) \
  ({Phys* const _p = p; _p->phys_type == PT_Tile ? (Tile*) _p : NULL;})


// Class describing a physical object.
//
class Phys {
public:
  Phys(Phys_Type phys_type);
  Phys(Phys& phys);
  virtual ~Phys();
  const Phys_Type phys_type;
  Phys* const original;         // Pointer to original if this is a copy.
  int idx;                      // Index into an array.
  int serial;                   // For debugging.
  bool read_only;               // If true, no need to update position, etc.
  
  virtual void constants_update(){};

  // Routines below for axis sorting.
  virtual float max_z_get(double delta_t) { return 0; }
  virtual float min_z_get(double delta_t) { return 0; }

  GLuint query_occlusion_id;
  bool occlusion_query_active;
  bool occluded;
  int occluded_run;
  int occlusion_countdown;

  int contact_count;        // Number of other objects in contact with.
  bool collision;           // True if object collided with something.
  uint32_t debug_pair_calls;

  // Members needed for scheduling proximity pairs on CUDA. Values
  // assigned are temporary and usually change during scheduling. For
  // example, a ball can be in multiple CUDA passes so a value for
  // pass does not indicate that it's the only pass it can be in.
  //
  PStack<int> proximity;     // Nearby phys objects.
  int proximity_cnt;         // S10 HW3: Number of nearby physs.
  int pass;
  int pass_todo;
  int rounds;
  bool placed;
  int block;
  int color_block; // Block number to use for coloring ball.
  int sm_idx;      // Index into CUDA shared memory array.
};


// Class representing physical ball.
//
class Ball : public Phys {
public:
  Ball(World *w, float r = 0);
  Ball(Ball &b):Phys(b),w(b.w)
  {
#define C(m) m=b.m
    C(position);C(velocity);C(orientation);C(omega);
    C(prev_velocity);
#undef C
  }
  ~Ball();

  float max_z_get(double delta_t);
  float min_z_get(double delta_t);

  void set_radius(float r)
  {
    radius = r;
    constants_update();
  }

  void constants_update();

  World& w;
  float radius, radius_sq, radius_inv;
  float density;
  float mass;
  float mass_inv;
  float fdt_to_do;

  float short_xrad_sq;

  pCoor position;
  pVect velocity;
  pQuat orientation;
  pVect omega;

  pVect prev_velocity;
  pVect prev_omega;

  pColor color_event;           // Color based on a recent event.
  pColor color_natural;         // The ball's "real" color.

  pVect point_rot_vel(pNorm tact_dir);
  void apply_tan_force_dt(pNorm tact_dir, pNorm force_dir, double force_dt);
  void apply_tan_force_dt(pNorm tact_dir, pVect force_dt);
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};


// Class representing physical water wheel, composed of a collection
// of tiles.
//
class Wheel {
public:
  Wheel(World* w):w(*w){};
  void init(pCoor center, pVect axis, double r_inner, double blade_len);
  void to_cuda();
  void from_cuda();
  void variables_update();
  void spin();
  void collect_tile_force(Tile *tile, pCoor tact, pVect delta_mo);
  float friction_torque;
  double theta, omega, torque_dt;
  bool cpu_stale, cuda_constants_stale;
  pCUDA_Memory<float> cuda_omega;
  PStack<Tile*> tiles;
  pCoor center;
  pNorm axis_dir;
  float base_moment_of_inertia_inv, moment_of_inertia_inv;
  World& w;
};


const pColor red(0.8,0.1,0.1);
const pColor green(0.1,0.8,0.1);
const pColor blue(0.1,0.1,0.8);
const pColor cyan(0.1,0.8,0.8);
const pColor dark(0);
const pColor light_gray(0.8,0.8,0.8);
const pColor dark_gray(0.15,0.15,0.15);
const pColor white(0xffffff);
const pColor lsu_business_purple(0x7f5ca2);
const pColor lsu_spirit_purple(0x580da6);
const pColor lsu_spirit_gold(0xf9b237);
const pColor lsu_official_purple(0x2f0462);

const pColor color_orange_red(0xff4500);
const pColor color_dark_orange(0xff8c00);
const pColor color_orange(0xffa500);
const pColor color_gold(0xffd700);
const pColor color_yellow(0xffff00);
const pColor color_chartreuse(0x7fff00);
const pColor color_lawn_green(0x7cfc00);
const pColor color_spring_green(0x00ff7f);
const pColor color_medium_spring_green(0x00fa9a);
const pColor color_deep_sky_blue(0x00bfff);
const pColor color_medium_blue(0x0000cd);
const pColor color_dark_violet(0x9400d3);
const pColor color_dark_magenta(0x8b008b);
const pColor color_magenta(0xff00ff);
const pColor color_dark_red(0x8b0000);
const pColor color_brown(0xa52a2a);
const pColor color_firebrick(0xb22222);
const pColor color_indian_red(0xcd5c5c);
const pColor color_light_coral(0xf08080);
const pColor color_salmon(0xfa8072);
const pColor color_light_salmon(0xffa07a);
const pColor color_tomato(0xff6347);
const pColor color_coral(0xff7f50);
const pColor color_dark_salmon(0xe9967a);
const pColor color_rosy_brown(0xbc8f8f);
const pColor color_sienna(0xa0522d);
const pColor color_saddle_brown(0x8b4513);
const pColor color_chocolate(0xd2691e);
const pColor color_peru(0xcd853f);
const pColor color_sandy_brown(0xf4a460);
const pColor color_burlywood(0xdeb887);
const pColor color_tan(0xd2b48c);
const pColor color_navajo_white(0xffdead);
const pColor color_wheat(0xf5deb3);
const pColor color_dark_goldenrod(0xb8860b);
const pColor color_goldenrod(0xdaa520);
const pColor color_light_goldenrod(0xeedd82);
const pColor color_pale_goldenrod(0xeee8aa);
const pColor color_cornsilk(0xfff8dc);
const pColor color_dark_khaki(0xbdb76b);
const pColor color_khaki(0xf0e68c);
const pColor color_lemon_chiffon(0xfffacd);
const pColor color_dark_olive_green(0x556b2f);
const pColor color_olive_drab(0x6b8e23);
const pColor color_yellow_green(0x9acd32);
const pColor color_green_yellow(0xadff2f);
const pColor color_light_green(0x90ee90);
const pColor color_forest_green(0x228b22);
const pColor color_lime_green(0x32cd32);
const pColor color_pale_green(0x98fb98);
const pColor color_dark_sea_green(0x8fbc8f);
const pColor color_sea_green(0x2e8b57);
const pColor color_medium_sea_green(0x3cb371);
const pColor color_light_sea_green(0x20b2aa);
const pColor color_medium_aquamarine(0x66cdaa);
const pColor color_aquamarine(0x7fffd4);
const pColor color_dark_cyan(0x008b8b);
const pColor color_medium_turquoise(0x48d1cc);
const pColor color_turquoise(0x40e0d0);
const pColor color_pale_turquoise(0xafeeee);
const pColor color_powder_blue(0xb0e0e6);
const pColor color_light_blue(0xadd8e6);
const pColor color_sky_blue(0x87ceeb);
const pColor color_light_sky_blue(0x87cefa);
const pColor color_cadet_blue(0x5f9ea0);
const pColor color_steel_blue(0x4682b4);
const pColor color_dark_slate_gray(0x2f4f4f);
const pColor color_slate_gray(0x708090);
const pColor color_light_slate_gray(0x778899);
const pColor color_royal_blue(0x4169e1);
const pColor color_dodger_blue(0x1e90ff);
const pColor color_cornflower_blue(0x6495ed);
const pColor color_light_steel_blue(0xb0c4de);
const pColor color_dark_blue(0x00008b);
const pColor color_navy(0x000080);
const pColor color_midnight_blue(0x191970);
const pColor color_dark_slate_blue(0x483d8b);
const pColor color_slate_blue(0x6a5acd);
const pColor color_medium_slate_blue(0x7b68ee);
const pColor color_light_slate_blue(0x8470ff);
const pColor color_medium_purple(0x9370db);
const pColor color_blue_violet(0x8a2be2);
const pColor color_purple(0xa020f0);
const pColor color_dark_orchid(0x9932cc);
const pColor color_medium_orchid(0xba55d3);
const pColor color_orchid(0xda70d6);
const pColor color_thistle(0xd8bfd8);
const pColor color_plum(0xdda0dd);
const pColor color_violet(0xee82ee);
const pColor color_medium_violet_red(0xc71585);
const pColor color_violet_red(0xd02090);
const pColor color_pale_violet_red(0xdb7093);
const pColor color_maroon(0xb03060);
const pColor color_deep_pink(0xff1493);
const pColor color_hot_pink(0xff69b4);
const pColor color_pink(0xffc0cb);
const pColor color_light_pink(0xffb6c1);
const pColor color_snow(0xfffafa);

const int colors_mask = 0xf;
const pColor* const colors[colors_mask+1] =
  { &lsu_spirit_gold, &lsu_spirit_purple, &green, &blue,
    &red, &cyan, &light_gray, &dark_gray,
    &color_orange, &color_spring_green, &color_dark_violet, &color_salmon,
    &color_burlywood, &color_cornsilk, &color_sky_blue, &color_deep_pink };



// Constants for Location of Data (CUDA or CPU)
//
// Used to decide whether to copy data to or from CUDA.
//
enum Data_Location
  { 
    DL_PO  = 0x1, // Position, Orientation
    DL_CV  = 0x2, // Collision Count, Velocity
    DL_OT  = 0x4, // Other.
    DL_ALL = 0x7,
    DL_PO_CPU  = 0x1, // Position, Orientation
    DL_CV_CPU  = 0x2, // Collision Count, Velocity
    DL_OT_CPU  = 0x4, // Other.
    DL_ALL_CPU = 0x7,
    DL_PO_CUDA = 0x10,
    DL_CV_CUDA = 0x20,
    DL_OT_CUDA = 0x40,
    DL_ALL_CUDA = 0x70 };


enum GPU_Physics_Method { GP_cpu, GP_cuda, GP_ENUM_SIZE };
const char* const gpu_physics_method_str[] = { "CPU", "CUDA" };


typedef PStack<Phys*> Phys_List;
typedef PStackIterator<Phys*> Phys_Iterator;

// Include class definitions for tiles.  Yes, this code
// is disorganized.
//
#include "tiles.h"

///
/// Main Class: World
///

class World {
public:
  World(pOpenGL_Helper &fb):
    ogl_helper(fb){init();}
  void init();

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;


  /// Added for Spring 2010 Homework 3
  bool opt_cuda_prox;           // If true use cuda to compute proximity cnt.
  int proximity_cnt_errors;
  void cuda_contact_pairs_find();
  

  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void render_objects(bool attempt_occlusion_test);
  void render_shadow_volumes(pCoor light_pos);
  void cb_keyboard();

  void variables_update();
  void modelview_update();
  void time_step_cpu();
  bool sphere_empty(pCoor center, float radius);
  void balls_add(float contact_y_max);

  // For debugging and tuning.
  //
  bool opt_verify;  // If true verify correctness in certain places.
  bool opt_debug;   // Turns something on and off. Changes frequently.
  bool opt_debug2;  // Turns something else on and off. Changes frequently.
  bool opt_info;    // Request info to be printed to stdout.

  // Time in simulated world.
  //
  double world_time;

  // Physical objects (Balls, Tiles, etc.) being Simulated
  //
  Phys_List physs;
  PSList<Phys*,double> eye_dist; // Balls sorted by eye distance.
  bool balls_iterate(Ball*& ball);
  Ball* ball_first();           // Oldest surviving ball.
  Ball* ball_last();            // Youngest surviving ball.

  // Options controlling ball shower.
  //
  bool opt_spray_on;
  int spray_cnt, spray_run;
  double ball_countdown;

  // Options controlling ball drip.
  //
  bool opt_drip;
  int drip_cnt, drip_run;
  pCoor drip_location;
  Ball *dball;
  Ball* pball;

  int physs_occluded;

  // Lists used for computing which phys pairs are in proximity.
  //
  PSList<Phys*,double> phys_zsort;
  PStack<Contact> contact_pairs;

  void ball_init();
  void benchmark_setup(int tiers=1);

  void contact_pairs_find();
  bool penetration_balls_resolve
  (Ball *ball1, Ball *ball2, bool b2_real = true);
  void balls_render(bool attempt_ot);
  void balls_render_simple();
  void balls_remove();
  void balls_stop();
  void balls_rot_stop();

  bool opt_gravity;
  float opt_gravity_accel;      // Value chosen by user.
  float opt_ball_density;
  float opt_ball_radius;
  float opt_bounce_loss;
  float opt_elasticity;
  float opt_friction_coeff;
  float opt_friction_roll;
  int opt_time_step_factor;

  // Pre-computed values.
  //
  double delta_t;
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  pVect gravity_accel_dt;
  double elasticity_inv_dt;

  Tile_Manager tile_manager;

  Wheel* wheel;
  float opt_wheel_tile_density; // Per area, for computing moment of inertia.

  /// Tiled platform for ball.  (Not to be confused with Tile class.)
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_xmid, platform_xrad, platform_xrad_inv;
  float delta_theta_inv, tile_size_inv;
  float platform_pi_xwidth_inv;
  float trmin, trmax, tsmin, tsmax; // Platform texture boundary.
  pBuffer_Object<pVect> platform_tile_norms;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  int platform_even_vtx_cnt, platform_odd_vtx_cnt;

  pColor mirror_tint;           // Color of mirrored tiles.

  void platform_update();
  bool platform_collision_possible(Ball *ball, float ts_mov_max = 0);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_Drip, MI_Wheel, MI_COUNT } 
    opt_move_item;
  bool opt_pause;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_inv;
  pMatrix modelview_projection;

  bool opt_shadows;
  bool opt_shadow_volumes;
  bool opt_mirror;
  int opt_mirror_method;
  bool opt_normals_visible;
  bool opt_color_events;

  int tri_count; // For tuning, demo.

  pShader *vs_fixed;
  pShader *vs_reflect;

  GLint sun_axis_e, sun_axis_ne, sun_platform_xrad_sq, sun_light_num;
  GLint sun_platform_xmid, sun_platform_xrad; 
  GLint sun_eye_location, sun_eye_to_world, sun_world_to_clip;
  GLint sun_opt_mirror_method, sun_opt_color_events;

  GLuint texid_plat;
  GLuint texid_ball;

  // Pre-Computed Spheres
  //
  Sphere sphere;
  Sphere* spheres;
  Sphere sphere_lite;
  int sphere_lod_max;
  int sphere_lod_min;
  double sphere_delta_lod, sphere_lod_factor, sphere_lod_offset;
  int sphere_count;
  Sphere* sphere_get(Ball *ball);

  Cone cone;                    // Used to show platform normals.

  int opt_physics_method;
  int data_location;            // Is data on CPU, CUDA or both.

  /// Variables controlling CUDA schedule computation thread.
  //
  pthread_cond_t pt_render_cond, pt_sched_cond;
  pthread_mutex_t pt_mutex, pt_pairs_mutex;
  pthread_t pt_sched_tid;
  void pt_sched_main();    // Entry routine for schedule thread.
  void pt_sched_start();    // Tell schedule thread to compute a sched.
  void pt_sched_waitfor(); // Wait for schedule thread to finish.
  bool pt_sched_is_idle();
  
  char pt_render_cmd;          // Command for schedule thread.
  bool pt_sched_waiting;       // True if sched thread waiting for cmd.
  bool pt_sched_data_pending;  // True if sched data ready and uncollected.

  ///
  /// CUDA Routines
  ///

  void cuda_init();

  // Copy constants (such as ball radius) to CUDA.
  //
  void cuda_constants_update();

  // Advance physical state by one time step.
  //
  void time_step_cuda(int iters_per_frame, bool just_before_render);

  int opt_block_size;           // Number of threads to use in CUDA block.
  int block_size_max;           // Maximum possible based on our CUDA code.
  int opt_block_color_pass;     // Pass to use for coloring balls.
  dim3 dim_grid, dim_block;     // Dimensions for platform pass.

  // Phys Data for CUDA
  //
  // This contains essential information from the Phys class
  // and is passed to CUDA as a structure of arrays.  The structure
  // members are named for ball elements, but are used for tiles also.
  //
  pCUDA_Memory_X<CUDA_Ball,CUDA_Ball_X> cuda_balls;

  // Copy data from balls to cuda_balls, if necessary.
  //
  bool cpu_data_to_cuda();

  // Copy data from cuda_balls to balls, if necessary.
  //
  void cuda_data_to_cpu(uint which_data);

  // Compute CUDA Schedule
  //
  // The schedule is a list of ball pairs for each CUDA thread
  // to handle.  
  //
  // This routine runs on the CPU, but in a separate thread to
  // take advantage of multi-core CPUs.
  //
  void cuda_schedule(); // Compute CUDA schedule.

  // When positive CUDA schedule needs to be recomputed.
  //
  int cuda_schedule_stale;

  // Number of timesteps before CUDA schedule needs to be recomputed.
  //
  int schedule_lifetime_steps;

  // CUDA timing information, for tuning.
  cudaEvent_t frame_start_ce, frame_stop_ce;
  int timer_id_sched;           // Measure time of whole scheduler routine.
  int timer_id_spart;           // Measure time of part of sched. routine.

  PStack<Pass> *passes_curr;  // Info needed to launch contact pair kernel.
  PStack<Pass> *passes_next;
  PStack<Pass> passes_0, passes_1;

  // Balls needed by each block executing contact pair kernel.
  //
  pCUDA_Memory<int> block_balls_needed;

  // Pairs of balls to handle in contact pair kernel.
  //
  pCUDA_Memory<SM_Idx2> cuda_tacts_schedule;

  // Reset things when ball added or removed, or when switching to CPU
  // physics.
  //
  void cuda_at_balls_change();

  int cuda_ball_cnt;
  bool cuda_initialized;
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  cudaFuncAttributes cfa_platform; // Properties of code to run on device.
  cudaFuncAttributes cfa_pairs;
  int balls_per_block_max;
  int block_count_prev;        // Maximum number of blocks in last pairs pass.
  int round_count_prev;        // Total number of rounds in all pairs passes.
  bool cuda_constants_stale;   // When true, need to update constants.
};

#define CP(f) { const int rv=f; ASSERTS( rv == 0 ); }

// Wrapper to call scheduler main thread in World class.
void* pt_sched_main(void *arg){((World*)arg)->pt_sched_main();return NULL;}

void
World::init()
{
  /// Initialize scheduler thread, used for computing CUDA schedule.
  //

  // Initialize pthread condition variables and mutex, thread interaction.
  //
  CP(pthread_cond_init(&pt_render_cond,NULL));
  CP(pthread_cond_init(&pt_sched_cond,NULL));
  CP(pthread_mutex_init(&pt_mutex,NULL));
  CP(pthread_mutex_init(&pt_pairs_mutex,NULL));
  pt_sched_waiting = false;
  pt_render_cmd = 0;

  // Create scheduler thread and wait for it to be ready.
  //
  CP(pthread_create(&pt_sched_tid, NULL, ::pt_sched_main, (void*)this));
  pt_sched_waitfor();

  tile_manager.init(&physs);

  data_location = DL_ALL_CPU;
  cuda_initialized = false;
  cuda_schedule_stale = 1;
  opt_physics_method = GP_cuda;
  opt_block_size = 128;

  frame_timer.work_unit_set("Steps / s");
  world_time = 0;
  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  opt_normals_visible = false;
  opt_shadows = true;
  opt_shadow_volumes = false;
  opt_mirror = true;
  opt_mirror_method = 0;
  opt_spray_on = false;
  opt_color_events = false;
  opt_debug = false;
  opt_debug2 = false;
  opt_block_color_pass = 0;

  mirror_tint = lsu_spirit_purple * 0.5;

  // Instantiate shaders used for reflections.
  //
  // Creating reflections uses both a vertex shader and a geometry
  // shader, see code in balls-shdr.cc for details.
  //
  vs_reflect =
    new pShader
    ("balls-shdr.cc","vs_main_reflect();", "gs_main_reflect();", NULL);
  if ( vs_reflect->okay() )
    {
      sun_platform_xrad = vs_reflect->uniform_location("platform_xrad");
      sun_platform_xmid = vs_reflect->uniform_location("platform_xmid");
      sun_eye_location = vs_reflect->uniform_location("eye_location");
      sun_eye_to_world = vs_reflect->uniform_location("eye_to_world");
      sun_world_to_clip = vs_reflect->uniform_location("world_to_clip");
      sun_opt_mirror_method = vs_reflect->uniform_location("opt_mirror_method");
      sun_opt_color_events = vs_reflect->uniform_location("opt_color_events");
    }

  // Instantiate a non-shader shader object, which will be used to
  // tell OpenGL to used fixed functionality for all programmable
  // stages, rather than using one of our shaders.
  //
  vs_fixed = new pShader();

  eye_location = pCoor(17.9,-2,117.2);
  eye_direction = pVect(-0.15,-0.06,-0.96);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -80; platform_zmax = 80;

  // Platform and Ball Textures
  //
  texid_plat = pBuild_Texture_File("gp.png", false, 255);
  texid_ball = pBuild_Texture_File("mult.png", false, -1);

  // Limits of texture coordinates for platform tiles.
  //
  trmax = 0.05;
  trmin = 0.7;
  tsmax = 0;
  tsmin = 0.4;

  opt_light_intensity = 100.2;
  light_location = pCoor(0,25.8,-14.3);

  opt_ball_radius = 2;
  opt_ball_density = 0.0074603942589580438;
  opt_friction_coeff = 0.1;
  opt_friction_roll = 0.1;
  opt_bounce_loss = 0.55;
  opt_elasticity = 1.0 / 16;
  opt_drip = true;
  drip_cnt = spray_cnt = 0;
  drip_run = 3;
  spray_run = 8;
  dball = NULL;
  opt_verify = true;
  opt_time_step_factor = 6;
  opt_wheel_tile_density = 0.01;

  variable_control.insert_power_of_2(opt_block_size,"Block Size");
  variable_control.insert(opt_block_color_pass,"Color by Block in Pass");
  variable_control.insert(opt_ball_density,"Ball Density");
  variable_control.insert(opt_wheel_tile_density,"Tile Density");
  variable_control.insert(opt_elasticity,"Elasticity");
  variable_control.insert(opt_friction_coeff,"Sliding Friction");
  variable_control.insert(opt_friction_roll,"Rolling Friction");
  variable_control.insert(opt_bounce_loss,"Bounce Energy Loss");
  variable_control.insert(opt_gravity_accel,"Gravity");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_ball_radius,"Ball Radius");
  variable_control.insert(opt_time_step_factor,"Time Step Factor",1,1);

  opt_move_item = MI_Eye;
  opt_pause = false;

  pball = new Ball(this); 
  pball->prev_velocity = pVect(0,0,0);
  pball->set_radius(1);

  drip_location = pCoor(30,20,60);

  ball_countdown = 0.1;
  sphere.init(40);
  sphere.tri_count = &tri_count;
  sphere_lite.init(4);
  sphere_lite.tri_count = &tri_count;

  // Initialize spheres with varying levels of detail (lod).
  // For performance reasons, sphere with lowest lod that provides
  // acceptable results is used.

  sphere_lod_max = 40;
  sphere_lod_min = 8;
  sphere_count = 16;
  sphere_delta_lod = ( sphere_lod_max - sphere_lod_min ) / (sphere_count-1);
  spheres = new Sphere[sphere_count];

  for ( int i=0; i<sphere_count; i++ )
    {
      const int lod = sphere_lod_min + int( i * sphere_delta_lod + 0.5 );
      spheres[i].init(lod);
      spheres[i].tri_count = &tri_count;
    }


  wheel = new Wheel(this);

  variables_update();
  platform_update();
  modelview_update();

  if ( wheel )
    wheel->init(pCoor(0.6 * platform_xrad,-10,65), pVect(0,0,-10),3,8);

  {
    //  Use tiles to construct a staircase.
    //
    const int step_count = 10;
    const float x2 = platform_xmax - 0.1 * platform_xrad;
    const float x1 = platform_xmid + 0.1 * platform_xrad;
    const float step_size = ( x2 - x1 ) / step_count;
    const pVect step_hor(step_size,0,0);
    const pVect step_ver(0,step_size,0);
    const pVect step_wid(0,0,5);
    const pCoor step_start(x1,-platform_xrad*0.9,-50);
    pColor step_color(0.5,0.5,0.5);
    for ( int i=0; i<step_count; i++ )
      {
        const pCoor step_ll = step_start + i * ( step_hor + step_ver );
        tile_manager.new_tile(step_ll,step_hor,step_wid,step_color);
        tile_manager.new_tile(step_ll+step_hor,step_ver,step_wid,step_color);
      }

    variables_update();
  }

  /// Initialize Ball Positions
  //
  //  Code below places balls in one of several ways.
  //  Some of the ball arrangements are intended for debugging.

  if ( opt_spray_on )
    {
      physs += new Ball(this);
      return;
    }

  const float r_short = platform_xrad - opt_ball_radius;

  if ( true )
    {
      const double sa = asin( opt_ball_radius / r_short );
      const double ca = 1.5 * M_PI;
      const double a[] = { ca - sa, ca + sa, ca };
      const double r[] =
        { r_short, r_short,
          r_short - sqrt(3) * opt_ball_radius
        };
      for ( int i=0; i<3; i++ )
        {
          Ball* const b = new Ball(this);
          b->position = pCoor( r[i] * cos(a[i]), r[i] * sin(a[i]), 45);
          b->velocity = pVect(0,0,0);
          physs += b;
        }
    }

  if (false){
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(0,-r_short,40);
      b->velocity = pVect(0,0,0);
      physs += b;
    }
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(r_short*cos(1.75*M_PI),r_short*sin(1.75*M_PI),40);
      b->velocity = pVect(0,0,0);
      physs += b;
    }
  }

  if ( false )
    {
      Ball *b = new Ball(this);
      b->position = pCoor(0,-r_short,48);
      b->velocity = pVect(0,0,0);
      b->omega = pVect(0,6,0);
      physs += b;
      b = new Ball(this);
      b->position = pCoor(0,-r_short+3*opt_ball_radius,48);
      b->velocity = pVect(0,0,0);
      b->omega = pVect(0,1,0);
      physs += b;
    }
}


void
World::variables_update()
{
  // Updated pre-computed constants.
  //
  // This routine is called after user changes something.
  delta_t = 1.0 / ( 60 * opt_time_step_factor );
  cuda_constants_stale = true;  // Force cuda variables to be updated too.
  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;
  gravity_accel_dt = delta_t * gravity_accel;
  elasticity_inv_dt = 100 * delta_t / opt_elasticity;
  if ( opt_bounce_loss > 1 ) opt_bounce_loss = 1;
  if ( wheel ) wheel->variables_update();
}

void
World::platform_update()
{
  /// Set up Platform

  const float platform_delta_z = platform_zmax - platform_zmin;
  const int tile_count = int(max(1.0,platform_delta_z * 0.15));
  const float zdelta = platform_delta_z / tile_count;
  const float platform_delta_x = platform_xmax - platform_xmin;

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<pVect> p_tile_norms;
  PStack<pVect> p1_tile_norms;
  PStack<float> p_tex_coords, p1_tex_coords;
  platform_pi_xwidth_inv = M_PI / platform_delta_x;

  const int tess_bits = 2;
  const int tess_mask = 1 << tess_bits;
  const int th_tile_count = 19 << tess_bits;
  const double delta_theta = M_PI / th_tile_count;
  delta_theta_inv = 1.0 / delta_theta;
  tile_size_inv = 1 / zdelta;
  platform_xmid = 0.5 * ( platform_xmax + platform_xmin );
  platform_xrad = 0.5 * platform_delta_x;
  platform_xrad_inv = 1 / platform_xrad;
  const float trdelta = ( trmax - trmin ) / tess_mask;

  for ( int i = 0; i < th_tile_count; i++ )
    {
      const double theta0 = i * delta_theta;
      const double theta1 = theta0 + delta_theta;
      bool even = i & tess_mask;
      const float x0 = platform_xmid - platform_xrad * cos(theta0);
      const float x1 = platform_xmid - platform_xrad * cos(theta1);
      const float y0 = -0.01 - platform_xrad * sin(theta0);
      const float y1 = -0.01 - platform_xrad * sin(theta1);
      pVect norm0( cos(theta0), sin(theta0), 0);
      pVect norm1( cos(theta1), sin(theta1), 0);

      const float trma = trmax - trdelta * ( i & ( tess_mask - 1 ) );
      const float trmi = trma - trdelta;

      for ( float z = platform_zmin; z + 0.001 < platform_zmax; z += zdelta )
        {
          PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
          PStack<pVect>& t_norms = even ? p_tile_norms : p1_tile_norms;
          PStack<float>& tex_coords = even ? p_tex_coords : p1_tex_coords;
          tex_coords += trma; tex_coords += tsmax;
          t_coords += pVect(x0,y0,z);
          t_norms += norm0;  t_norms += norm0;
          tex_coords += trma; tex_coords += tsmin;
          t_coords += pVect(x0,y0,z+zdelta);
          tex_coords += trmi; tex_coords += tsmin;
          t_coords += pVect(x1,y1,z+zdelta);
          t_norms += norm1;  t_norms += norm1;
          tex_coords += trmi; tex_coords += tsmax;
          t_coords += pVect(x1,y1,z);
          even = !even;
        }
    }

  platform_even_vtx_cnt = p_tile_coords.occ();
  platform_odd_vtx_cnt = p1_tile_coords.occ();

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;
  while ( pVect* const v = p1_tile_norms.iterate() ) p_tile_norms += *v;
  while ( float* const v = p1_tex_coords.iterate() ) p_tex_coords += *v;

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
  modelview_inv = invert(modelview);
}

void
World::benchmark_setup(int tiers)
{
  // Set up an arrangement of balls intended for performance measurement.

  cuda_at_balls_change();

  for ( Ball *ball; balls_iterate(ball); )
    { physs.iterate_yank(); delete ball; }

  // Note that number of balls determined by ball size.
  opt_ball_radius = 1.08;

  const float delta_z = opt_ball_radius * 3;
  const float delta_x = opt_ball_radius * 2.1;
  const float hdeltaz = delta_z / 2;
  const float hdeltax = delta_x / 2;
  const float delta_y = 2.1 * opt_ball_radius;
  const float ymax = delta_y * tiers - 0.001;
  opt_drip = false;
  opt_spray_on = false;
  opt_verify = false;
  opt_mirror = false;
  opt_shadows = false;
  opt_friction_coeff = 2.0;
  for ( float z = platform_zmin + hdeltaz; z < platform_zmax; z+= delta_z )
    for ( float x = platform_xmin + hdeltax; x < platform_xmax; x += delta_x )
      for ( float y = 0; y < ymax; y+= delta_y )
        {
          Ball* const b = new Ball(this);
          b->velocity.z = 0;
          b->position = pCoor(x,y,z);
          physs += b;
        }
  variables_update();
}

void
World::cuda_init()
{
  if ( cuda_initialized ) return;
  ASSERTS( sizeof(CUDA_Ball_W) == sizeof(CUDA_Tile_W) );
  cuda_initialized = true;
  cuda_constants_stale = true;

  cuda_ball_cnt = 5;  // Set initial size of CUDA ball_x array.
  schedule_lifetime_steps = 6; // Number of steps schedule good for.
  passes_curr = &passes_0;
  passes_next = &passes_1;

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  ASSERTS( device_count );
  const int dev = 0;
  CE(cudaGetDeviceProperties(&cuda_prop,dev));
  CE(cudaGLSetGLDevice(dev));
  printf
    ("GPU: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
     cuda_prop.name, cuda_prop.clockRate/1e6,
     int(cuda_prop.totalGlobalMem >> 20));
  printf
    ("CAP: %d.%d  NUM MP: %d  TH/BL: %d  SHARED: %d  CONST: %d  "
     "# REGS: %d\n",
     cuda_prop.major, cuda_prop.minor,
     cuda_prop.multiProcessorCount, cuda_prop.maxThreadsPerBlock,
     int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
     cuda_prop.regsPerBlock
     );

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&frame_start_ce));
  CE(cudaEventCreate(&frame_stop_ce));

  timer_id_sched = frame_timer.user_timer_per_start_define("Sched");
  timer_id_spart = frame_timer.user_timer_per_start_define("SPart");

  // Set up cuda_balls class.
  //
  // Identify structure members so they can be transposed into arrays.
  //
  CMX_SETUP(cuda_balls,orientation);
  CMX_SETUP(cuda_balls,position);
  CMX_SETUP(cuda_balls,velocity);
  CMX_SETUP(cuda_balls,prev_velocity);
  CMX_SETUP(cuda_balls,omega);
  CMX_SETUP(cuda_balls,tact_counts);
  CMX_SETUP(cuda_balls,ball_props);

  // Allocate initial storage for cuda_balls.
  //
  cuda_balls.alloc_locked(cuda_ball_cnt);

  // Send pointer to this storage to cuda.
  //
  cuda_balls.ptrs_to_cuda("balls_x");

  // Determine resources used by each CUDA kernel.
  // See balls-kernel.cu for code.
  //
  CE(cuda_get_attr_plat_pairs(&cfa_platform,&cfa_pairs));

  block_size_max =
    min(cfa_platform.maxThreadsPerBlock, cfa_pairs.maxThreadsPerBlock);
  set_min(block_size_max,cuda_prop.maxThreadsPerBlock);

  printf("CUDA Routine Resource Usage:\n");
  printf(" pass_platform: %6zd shared, %zd const, %zd loc, %d regs; "
         "%d max thr\n",
         cfa_platform.sharedSizeBytes,
         cfa_platform.constSizeBytes,
         cfa_platform.localSizeBytes,
         cfa_platform.numRegs,
         cfa_platform.maxThreadsPerBlock);
  printf(" pass_pairs: %6zd shared, %zd const, %zd loc, %d regs; %d max thr\n",
         cfa_pairs.sharedSizeBytes,
         cfa_pairs.constSizeBytes,
         cfa_pairs.localSizeBytes,
         cfa_pairs.numRegs,
         cfa_pairs.maxThreadsPerBlock);
  balls_per_block_max = int(cuda_prop.sharedMemPerBlock / sizeof(CUDA_Phys_W));
  printf(" Shared Memory: %d balls, based on ball size of %zd chars.\n",
         balls_per_block_max, sizeof(CUDA_Phys_W));
}


 ///
 /// CUDA Scheduler Thread Routines
 ///


void
World::pt_sched_main()
{
  /// Main Scheduler Thread Routine

  // Initialize.
  pt_sched_data_pending = false;

  while ( true )
    {
      // Wait for a command from the render (main) thread.
      //
      CP(pthread_mutex_lock(&pt_mutex));
      pt_sched_waiting = true;
      while ( !pt_render_cmd )
        pthread_cond_wait(&pt_sched_cond,&pt_mutex);

      // Main thread has woken us up (with pthread_cond_signal),
      // perform command we were roused for.
      //
      const char cmd = pt_render_cmd;
      pt_render_cmd = 0;
      pt_sched_waiting = false;
      pthread_mutex_unlock(&pt_mutex);
      // After unlocking main thread can "see" that we are awake and
      // received the command (since it's now zero).

      // Exit scheduler thread, perhaps because program is exiting.
      //
      if ( cmd == 'x' ) break;

      // Wake up render thread.
      //
      if ( cmd == 'w' )
        {
          pthread_mutex_lock(&pt_mutex);
          pthread_cond_signal(&pt_render_cond);
          pthread_mutex_unlock(&pt_mutex);
          continue;
        }

      ASSERTS( cmd == 's' );

      // Compute a CUDA schedule.
      //
      cuda_schedule();
    }
}

bool
World::pt_sched_is_idle()
{
  /// Return true if scheduling thread is idle.

  CP(pthread_mutex_lock(&pt_mutex));
  const bool rv = pt_sched_waiting && !pt_render_cmd;
  CP(pthread_mutex_unlock(&pt_mutex));
  return rv;
}

void
World::pt_sched_waitfor()
{
  /// Wait for schedule thread to be idle.

  CP(pthread_mutex_lock(&pt_mutex));

  while ( pt_sched_waiting && pt_render_cmd )
    {
      // Schedule thread is idle, but has work to do (pt_render_cmd),
      // so wait for that to be finished.
      //
      pthread_mutex_unlock(&pt_mutex);
      pthread_yield();
      pthread_mutex_lock(&pt_mutex);
    }

  while ( true )
    {
      if ( pt_sched_waiting ) break;

      // Schedule thread isn't waiting, to request a wakeup and
      // go to sleep.
      //
      pt_render_cmd = 'w';
      pthread_cond_wait(&pt_render_cond,&pt_mutex);
    }
  ASSERTS( !pt_render_cmd );
  CP(pthread_mutex_unlock(&pt_mutex));
}

void
World::pt_sched_start()
{
  /// Command scheduler thread to compute schedule. 
  //
  // Called from render (main) thread.

  ASSERTS( pt_sched_waiting );

  // Get data from CUDA.
  // This can only be done from one thread, here the render thread.
  //
  cuda_data_to_cpu( DL_PO | DL_CV );

  // Spring 2010 HW 3
  if ( opt_cuda_prox ) cuda_contact_pairs_find();

  // Set command and then wake up scheduler thread.
  //
  CP(pthread_mutex_lock(&pt_mutex));
  pt_render_cmd = 's';
  pthread_cond_signal(&pt_sched_cond); // Wake up scheduler.
  pt_sched_data_pending = true;
  CP(pthread_mutex_unlock(&pt_mutex));
}


void
World::cuda_at_balls_change()
{
  /// Reset scheduler and other CUDA data.
  //
  // Called when a ball is added or removed, or there is some other
  // disrupting change.

  if ( opt_physics_method == GP_cpu ) return;

  // Wait for scheduler thread to finish whatever it's currently doing.
  //
  pt_sched_waitfor();

  // Forget about the schedule it may have just finished.
  //
  pt_sched_data_pending = false;
  cuda_schedule_stale = 1;

  // Bring data back to CPU.
  //
  cuda_data_to_cpu(DL_ALL);
  data_location = DL_ALL_CPU;
}


void
World::cuda_constants_update()
{
  /// If necessary, copy constants to CUDA. 
  //
  // Performed during program initialization and after user changes to
  // options such as ball mass.

  if ( !cuda_constants_stale ) return;
  cuda_constants_stale = false;

  set_max(opt_block_size, 1);
  set_min(opt_block_size, block_size_max);

  // The macros below copy values to CUDA device variables with
  // the same name.
  //
  TO_DEV(gravity_accel_dt);
  TO_DEV(opt_bounce_loss);
  TO_DEV(platform_xmin); TO_DEV(platform_xmax);
  TO_DEV(platform_zmin); TO_DEV(platform_zmax);
  TO_DEV(platform_xmid); TO_DEV(platform_xrad);
  TO_DEVF(delta_t);
  TO_DEVF(elasticity_inv_dt); 
  TO_DEVF(opt_friction_coeff); TO_DEVF(opt_friction_roll);
}

bool
World::cpu_data_to_cuda()
{
  /// Copy data to CUDA.

  ASSERTS( ( DL_ALL & ( data_location | ( data_location >> 4 ) ) ) == DL_ALL );

  if ( wheel ) wheel->to_cuda();

  const int cnt = physs.occ();

  // Allocate additional cuda storage, if necessary.
  //
  if ( cnt > cuda_ball_cnt )
    {
      cuda_balls.realloc(cnt);
      cuda_balls.ptrs_to_cuda_soa("balls_x");
      cuda_ball_cnt = cnt;
    }
  cuda_constants_update();

  // Just return if data already has valid values.
  //
  if ( ( data_location & DL_ALL_CUDA ) == DL_ALL_CUDA ) return false;
  data_location |= DL_ALL_CUDA;

  // Copy CPU's phys information to arrays, in preparation for
  // transfer to CUDA.
  //
  for ( int idx=0; idx<cnt; idx++ )
    {
      Phys* const phys = physs[idx];
      Tile* const tile = TILE(phys);

      int4 tact_counts;
      tact_counts.x = phys->phys_type;
      tact_counts.y = 0;        // phys->contact_count, init to 0
      tact_counts.z = 0;        // phys->debug_pair_calls, init to 0.
      tact_counts.w = tile && tile->marker ? 1 : 0; // 1 if wheel.
      cuda_balls.soa.tact_counts[idx] = tact_counts;

      if ( Ball* const ball = BALL(phys) )
        {
          vec_set(cuda_balls.soa.orientation[idx],ball->orientation);
          vec_sets3(cuda_balls.soa.position[idx],ball->position);
          vec_sets3(cuda_balls.soa.prev_velocity[idx],ball->velocity);
          vec_sets3(cuda_balls.soa.velocity[idx],ball->velocity);
          vec_sets3(cuda_balls.soa.omega[idx],ball->omega);
          float4 ball_props;
          ball_props.x = ball->radius;
          ball_props.y = ball->mass_inv;
          ball_props.z = ball->fdt_to_do;
          ball_props.w = 0;
          cuda_balls.soa.ball_props[idx] = ball_props;
        } 
      else if ( tile )
        {
          float4 wht;
          wht.x = tile->width;
          wht.y = tile->height;
          wht.z = 0;     // Torque, initialized to zero.
          wht.w = 0;
          vec_sets3(cuda_balls.soa.position[idx],tile->pt_ll);
          cuda_balls.soa.velocity[idx] = wht;
          vec_sets3(cuda_balls.soa.omega[idx],tile->norm_rt);
          vec_sets3(cuda_balls.soa.prev_velocity[idx],tile->norm_up);
          vec_sets3(cuda_balls.soa.ball_props[idx],tile->normal);
        }
      else
        {
          ASSERTS( false );
        }
    }

  // Transfer the data.
  cuda_balls.to_cuda();
  return true;
}

void
World::cuda_data_to_cpu(uint which_data)
{
  /// Copy data from CUDA.

  ASSERTS( ( DL_ALL & ( data_location | ( data_location >> 4 ) ) ) == DL_ALL );
  ASSERTS( which_data & DL_ALL );

  // If the needed data is already on the CPU, return.
  //
  const uint mask = which_data & ~data_location;
  if ( !mask ) return;

  // Mark that the needed data is on the CPU (not yet, but it will be soon).
  //
  data_location |= which_data;

  cuda_balls.from_cuda();       // Transfer data.

  const int cnt = physs.occ();

  // Copy data to physs array, copying only the data that's
  // needed and not already present.
  //
  for ( int idx=0; idx<cnt; idx++ )
    {
      Phys* const phys = physs[idx];
      Ball* const ball = BALL(phys);
      Tile* const tile = TILE(phys);

      if ( mask & DL_CV_CPU )
        {
          const int4 tact_counts = cuda_balls.soa.tact_counts[idx];
          phys->contact_count = tact_counts.y;
          phys->collision |= phys->contact_count;
          phys->debug_pair_calls = tact_counts.z;
        }

      if ( tile && tile->marker && ( mask & DL_PO_CPU ) )
        {
          pCoor pt_ll; pt_ll.w = 1;
          pVect norm_rt, norm_up;
          vec_sets3(pt_ll,cuda_balls.soa.position[idx]);
          vec_sets4(norm_rt,cuda_balls.soa.omega[idx]);
          vec_sets4(norm_up,cuda_balls.soa.prev_velocity[idx]);
          tile->set(pt_ll, tile->height * norm_up, tile->width * norm_rt);
        }

      if ( !ball ) continue;
      if ( mask & DL_PO_CPU )
        {
          vec_sets3(ball->position,cuda_balls.soa.position[idx]);
          vec_set(ball->orientation,cuda_balls.soa.orientation[idx]);
        }
      if ( mask & DL_CV_CPU )
        {
          vec_sets4(ball->velocity,cuda_balls.soa.velocity[idx]);
          const int4 tact_counts = cuda_balls.soa.tact_counts[idx];
          ball->contact_count = tact_counts.y;
          ball->collision |= ball->contact_count;
          ball->debug_pair_calls = tact_counts.z;
        }
      if ( mask & DL_OT_CPU )
        {
          vec_sets4(ball->omega,cuda_balls.soa.omega[idx]);
        }
    }
}

void 
Wheel::init(pCoor centerp, pVect axis, double r_inner, double blade_len)
{
  cpu_stale = false;
  cuda_constants_stale = true;
  center = centerp;
  axis_dir = axis;
  const int slices = 10;
  const double r_outer = r_inner + blade_len;
  pVect y_axis(0,1,0);
  pNorm x_axis = cross(axis,y_axis);
  const double wheel_width = axis_dir.magnitude;

  const double r_inner_sq = r_inner * r_inner;
  const double r_outer_sq = r_outer * r_outer;

  const double base_moment_of_inertia_rim =
    r_inner_sq *
    wheel_width * 2 * M_PI * r_inner;
  const double base_moment_of_inertia_blades =
    slices * wheel_width *
    (1.0/3) * ( r_outer_sq * r_outer - r_inner_sq * r_inner );
  
  base_moment_of_inertia_inv =
    1.0 / ( base_moment_of_inertia_rim + base_moment_of_inertia_blades );

  moment_of_inertia_inv =
    base_moment_of_inertia_inv / w.opt_wheel_tile_density;

  torque_dt = 0;
  omega = 0;
  theta = 0;
  friction_torque = 10;

  const double delta_theta = 2 * M_PI / slices;
  pColor wheel_color(0,0.8,0);
  for ( int i=0; i<slices; i++ )
    {
      const double theta_1 = i * delta_theta;
      const double theta_2 = (i+1) * delta_theta;
      pCoor pt1 = center + cos(theta_1) * r_inner * x_axis
        + sin(theta_1) * r_inner * y_axis;
      pVect pt1o = cos(theta_1) * blade_len * x_axis
        + sin(theta_1) * blade_len * y_axis;
      pCoor pt2 = center + cos(theta_2) * r_inner * x_axis
        + sin(theta_2) * r_inner * y_axis;
      pVect pt12(pt1,pt2);
      tiles += w.tile_manager.new_tile(pt1,pt12,axis,wheel_color);
      tiles += w.tile_manager.new_tile(pt1,pt1o,axis,wheel_color);
    }
  for ( Tile *tile; tiles.iterate(tile); )
    {
      tile->read_only = false;
      tile->marker = this;
    }
}

void
Wheel::to_cuda()
{
  from_cuda();
  cpu_stale = true;

  if ( cuda_constants_stale )
    {
      cuda_constants_stale = false;
      CUDA_Wheel wheel;
      vec_set(wheel.center,center);
      vec_set(wheel.axis_dir,axis_dir);
      wheel.moment_of_inertia_inv = moment_of_inertia_inv;
      wheel.friction_torque = friction_torque;
      Tile* const tf = tiles[0];
      Tile* const tl = tiles.peek();
      const int tig_check = tl->idx - tf->idx + 1;
      ASSERTS( tig_check == tiles.occ() );
      wheel.idx_start = tf->idx;
      wheel.idx_stop = tl->idx + 1;
      if ( cuda_omega.elements == 0 ) cuda_omega.alloc(1);
      wheel.omega = cuda_omega.get_dev_addr();
      TO_DEV(wheel);
    }

  cuda_omega[0] = omega;
  cuda_omega.to_cuda();

}

void
Wheel::from_cuda()
{
  if ( !cpu_stale ) return;
  cpu_stale = false;
  cuda_omega.from_cuda();
  omega = cuda_omega[0];
}

void
Wheel::variables_update()
{
  moment_of_inertia_inv =
    base_moment_of_inertia_inv / w.opt_wheel_tile_density;
  cuda_constants_stale = true;
}

void
Wheel::spin()
{
  from_cuda();

  // Change in spin due to ball contact torques (torque_dt).
  //
  omega -= torque_dt * moment_of_inertia_inv;
  torque_dt = 0;

  // Change in spin due to rotational friction.
  //
  const float friction_delta_omega = 
    friction_torque * moment_of_inertia_inv * w.delta_t;
  if ( fabs(omega) <= friction_delta_omega )
    omega = 0;
  else if ( omega > 0 )
    omega -= friction_delta_omega;
  else
    omega += friction_delta_omega;

  const double delta_theta = omega * w.delta_t;
  pMatrix_Translate tr_center(-center);
  pMatrix_Translate tr_restore(center);
  pMatrix_Rotation tr_rotate(axis_dir,delta_theta);
  pMatrix transform = tr_restore * tr_rotate * tr_center;
  for ( Tile *tile; tiles.iterate(tile); )
    {
      pCoor ll = transform * tile->pt_ll;
      pVect vec_up = tr_rotate * tile->vec_up;
      pVect vec_rt = tr_rotate * tile->vec_rt;
      tile->set(ll,vec_up,vec_rt);
    }
}

void
Wheel::collect_tile_force(Tile *tile, pCoor tact, pVect delta_mo)
{
  if ( tile->marker != this ) return;
  pVect to_center(center,tact);
  // Formula below needs to be checked.
  torque_dt += dot(axis_dir,cross(to_center,delta_mo));
}


///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

int phys_serial_next = 0;

Phys::Phys(Phys_Type phys_type):
  phys_type(phys_type),original(NULL)
{
  read_only = false;
  occluded = false;
  occlusion_query_active = false;
  occluded_run = 0;
  occlusion_countdown = 0;
  glGenQueries(1,&query_occlusion_id);
  contact_count = 0;
  collision = false;
  serial = phys_serial_next++;
  debug_pair_calls = 0;
}

Phys::Phys(Phys& phys)
  :phys_type(phys.phys_type),original(&phys)
{
#define C(m) m=phys.m
  C(read_only);
  C(serial);C(idx);
  C(proximity);
  C(contact_count); C(debug_pair_calls); C(collision);
  query_occlusion_id = 0;
#undef C
}

Phys::~Phys()
{
  if ( query_occlusion_id )
    glDeleteQueries(1,&query_occlusion_id);
}

bool
World::balls_iterate(Ball*& ball)
{
  for ( Phys *p; physs.iterate(p); ) if ( ( ball = BALL(p) ) ) return true;
  return false;
}

Ball*
World::ball_first()
{
  for ( Phys_Iterator phys(physs); phys; phys++ )
    if ( Ball* const ball = BALL(phys) ) return ball;
  return NULL;
}

Ball*
World::ball_last()
{
  for ( int i = physs.occ() - 1; i>=0; i-- )
    if ( Ball* const ball = BALL(physs[i]) ) return ball;
  return NULL;
}


Ball::Ball(World* wp, float r):Phys(PT_Ball),w(*wp)
{
  w.cuda_at_balls_change();
  density = w.opt_ball_density;
  set_radius( r == 0 ? w.opt_ball_radius : r );

  color_event = pColor(0.5,0.5,0.5);
  color_natural = pColor(0.5,0.5,0.5);
  position = pCoor(30,22,-15.4);
  velocity = pVect(random()/(0.0+RAND_MAX),0,random()/(0.0+RAND_MAX));

  orientation.set(pVect(0,1,0),0);
  omega = pVect(0,0,0);
}

void
Ball::constants_update()
{
  radius_sq = radius * radius;
  mass = 4.0 / 3 * M_PI * radius_sq * radius * density;
  radius_inv = 1 / radius;
  mass_inv = 1 / mass;
  short_xrad_sq = ( w.platform_xrad - radius ) * ( w.platform_xrad - radius );
  // FYI, notice simplifications:
  //   const float mo_inertia = 0.4 * mass * radius_sq;
  //   fdt_to_do = radius / mo_inertia;
  fdt_to_do = radius_inv * 2.5 * mass_inv;
}


float
Ball::max_z_get(double lifetime_delta_t)
{
  const float max_z =
    position.z + max(0.0,fabs(velocity.z)) * lifetime_delta_t + radius;
  return max_z;
}

float
Ball::min_z_get(double lifetime_delta_t)
{
  const float z_min =
    position.z + min(0.0,-fabs(velocity.z)) * lifetime_delta_t - radius;
  return z_min;
}

Ball::~Ball()
{ 
  if ( original ) return;
  ASSERTS( ! ( w.data_location & DL_ALL_CUDA ) );
  ASSERTS( w.pt_sched_is_idle() );
}

bool
World::platform_collision_possible(Ball *ball, float ts_mov_max)
{
  const pCoor pos = ball->position;
  const float r = ball->radius;

  return pos.y <= r + ts_mov_max
    && pos.x - ts_mov_max >= platform_xmin - r
    && pos.x + ts_mov_max <= platform_xmax + r
    && pos.z - ts_mov_max >= platform_zmin - r
    && pos.z + ts_mov_max <= platform_zmax + r;
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

// Remove all but one ball.
//
void World::balls_remove()
{
  cuda_at_balls_change();
  PStack<Phys*> survivors;
  bool ball_found = false;
  while ( physs.occ() )
    {
      Phys* const phys = physs.pop();
      const bool is_ball = phys->phys_type == PT_Ball;
      if ( !ball_found || !is_ball )
        {
          survivors += phys;
          ball_found = ball_found || is_ball;
        }
      else
        {
          delete phys;
        }
    }
  while ( survivors.occ() ) physs += survivors;
}

void World::balls_stop()
{
  for ( Ball *ball; balls_iterate(ball); ) ball->stop();
}
void World::balls_rot_stop()
{
  for ( Ball *ball; balls_iterate(ball); )
    ball->omega = pVect(0,0,0);
}

bool
World::penetration_balls_resolve(Ball *ball1, Ball *ball2, bool b2_real)
{
  /// Update velocity and angular momentum for a pair of balls in contact.

  const pNorm dist(ball1->position,ball2->position);

  // Return if balls aren't touching.  Note avoidance of square root.
  //
  if ( dist.mag_sq >= 3 * (ball1->radius_sq+ball2->radius_sq) ) return false;

  const double radii_sum = ball1->radius + ball2->radius;

  if ( dist.magnitude >= radii_sum ) return false;

  // Update counters used for optimization and to decide when to
  // release new balls (collision_count).
  //
  ball1->contact_count++;
  if ( b2_real ) ball2->contact_count++;

  // Compute relative (approach) velocity.
  //
  pVect prev_appr_vel = ball1->prev_velocity - ball2->prev_velocity;
  const double prev_approach_speed = dot( prev_appr_vel, dist );

  const double loss_factor = 1 - opt_bounce_loss;

  // Compute change in speed based on how close balls touching, ignoring
  // energy loss.
  //
  const double appr_force_dt_no_loss =
    ( radii_sum - dist.magnitude ) * elasticity_inv_dt;

  // Change in speed accounting for energy loss. Only applied when
  // balls separating.
  //
  const double appr_force_dt =
    prev_approach_speed > 0
    ? appr_force_dt_no_loss : loss_factor * appr_force_dt_no_loss;

  const double appr_deltas_1 = appr_force_dt * ball1->mass_inv;

  /// Update Linear Velocity
  //
  ball1->velocity -= appr_deltas_1 * dist;
  if ( b2_real ) ball2->velocity += appr_force_dt * ball2->mass_inv * dist;

  // Find speed on surface of balls at point of contact.
  //
  pVect tact1_rot_vel = ball1->point_rot_vel(dist);
  pVect tact2_rot_vel = ball2->point_rot_vel(-dist);

  // Find relative velocity of surfaces at point of contact
  // in the plane formed by their surfaces.
  //
  pVect tan_vel = prev_appr_vel - prev_approach_speed * dist;
  pNorm tact_vel_dir = tact1_rot_vel - tact2_rot_vel + tan_vel;

  // Find change in velocity due to friction.
  //
  const double fric_force_dt_potential =
    appr_force_dt_no_loss * opt_friction_coeff;

  const double mass_inv_sum =
    b2_real ? ball1->mass_inv + ball2->mass_inv : ball1->mass_inv;

  const double force_dt_limit =
    tact_vel_dir.magnitude / ( 3.5 * mass_inv_sum );

  // If true, surfaces are not sliding or will stop sliding after
  // frictional forces applied. (If a ball surface isn't sliding
  // against another surface than it must be rolling.)
  //
  const bool will_roll = force_dt_limit <= fric_force_dt_potential;

  const double sliding_fric_force_dt =
    will_roll ? force_dt_limit : fric_force_dt_potential;

  const double dv_tolerance = 0.000001;

  const double sliding_fric_dv_1 = sliding_fric_force_dt * ball1->mass_inv;

  if ( sliding_fric_dv_1 > dv_tolerance )
    {
      // Apply tangential force (resulting in angular momentum change) and
      // linear force (resulting in velocity change).
      //
      ball1->apply_tan_force_dt(dist,tact_vel_dir,-sliding_fric_force_dt);
      ball1->velocity -= sliding_fric_dv_1 * tact_vel_dir;
    }

  const double sliding_fric_dv_2 = sliding_fric_force_dt * ball2->mass_inv;

  if ( b2_real && sliding_fric_dv_2 > dv_tolerance )
    {
      // Apply frictional forces for ball 2.
      //
      ball2->apply_tan_force_dt(-dist,tact_vel_dir,sliding_fric_force_dt);
      ball2->velocity += sliding_fric_dv_2 * tact_vel_dir;;
    }

  // Check for correctness.
  //
  if ( false && opt_verify && b2_real && will_roll )
    {
      // Check only works if current velocity used for friction calc.
      //
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
    //
    // Account for forces of surfaces twisting against each
    // other. (For example, if one ball is spinning on top of
    // another.)
    //
    const double appr_omega = dot(ball2->omega,dist) - dot(ball1->omega,dist);
    const double fdt_to_do_sum =
      b2_real ? ball1->fdt_to_do + ball2->fdt_to_do : ball1->fdt_to_do;
    const double fdt_limit = fabs(appr_omega) / fdt_to_do_sum;
    const bool rev = appr_omega < 0;
    const double fdt_raw = min(fdt_limit,fric_force_dt_potential);
    const pVect fdt_v = ( rev ? -fdt_raw : fdt_raw ) * dist;
    ball1->omega += ball1->fdt_to_do * fdt_v;
    if ( b2_real ) ball2->omega -= ball2->fdt_to_do * fdt_v;
  }

  // This code turned off since multiple-radius ball modification.
  //
  if(0){
    /// Rolling Friction
    //
    // The rolling friction model used here is ad-hoc.

    pVect tan_b12_vel = b2_real ? 0.5 * tan_vel : pVect(0,0,0);
    const double torque_limit_sort_of = appr_force_dt_no_loss
      * sqrt( radii_sum - dist.mag_sq / radii_sum );
      //  * sqrt( ball1->radius - 0.25 * dist.mag_sq * r_inv );

    pVect tact1_rot_vel = ball1->point_rot_vel(dist);
    pVect tact1_roll_vel = tact1_rot_vel + tan_b12_vel;
    pNorm tact1_roll_vel_dir = tact1_roll_vel;
    pVect lost_vel(0,0,0);

    const double rfric_loss_dv_1 =
      torque_limit_sort_of * 2.5 * ball1->mass_inv *
      ( tact1_roll_vel_dir.magnitude * opt_friction_roll /
        ( 1 + tact1_roll_vel_dir.magnitude * opt_friction_roll ) );
    
    pVect lost_vel1 =
      min(tact1_roll_vel_dir.magnitude, rfric_loss_dv_1) * tact1_roll_vel_dir;

    lost_vel = -lost_vel1;
    
    if ( b2_real )
      {
        pVect tact2_rot_vel = ball2->point_rot_vel(-dist);
        pVect tact2_roll_vel = tact2_rot_vel - tan_b12_vel;
        pNorm tact2_roll_vel_dir = tact2_roll_vel;
        const double rfric_loss_dv_2 =
          torque_limit_sort_of * 2.5 * ball2->mass_inv *
          ( tact2_roll_vel_dir.magnitude * opt_friction_roll /
            ( 1 + tact2_roll_vel_dir.magnitude * opt_friction_roll ) );
        pVect lost_vel2 =
          min(tact2_roll_vel_dir.magnitude, rfric_loss_dv_2 )
          * tact2_roll_vel_dir;

        lost_vel += lost_vel2;
      }

    ball1->apply_tan_force_dt(dist,0.4 * ball1->mass * lost_vel);
    if ( b2_real ) ball2->apply_tan_force_dt(dist, 0.4*ball2->mass * lost_vel);

    if ( false && opt_verify )
      {
        pVect ch_tact1_rot_vel = ball1->point_rot_vel(dist);
        pVect ch_tact1_roll_vel = ch_tact1_rot_vel + tan_b12_vel;
        const double magloss = tact1_roll_vel.mag() - ch_tact1_roll_vel.mag();
        ASSERTS( magloss >= -10.0 );
      }
  }

  return true;
}

pVect
Ball::point_rot_vel(pNorm direction)
{
  /// Return velocity of point on surface of ball.
  //
  return radius * cross( omega, direction );
}

void
Ball::apply_tan_force_dt(pNorm tact_dir, pNorm force_dir, double force_dt)
{
  /// Change rotation rate due to force_dt at tact_dir in direction force_dir.
  //
  omega += cross(tact_dir, fdt_to_do * force_dt * force_dir);
}


void
Ball::apply_tan_force_dt(pNorm tact_dir, pVect force_dt)
{
  omega += cross(tact_dir, fdt_to_do * force_dt );
}

void
World::balls_add(float contact_y_max)
{
  /// If dripping is on, release a new ball if last one hit something.
  //
  if ( opt_drip && ( !dball || dball->collision ) )
    {
      if ( !sphere_empty(drip_location,opt_ball_radius) ) return;
      dball = new Ball(this);
      dball->position = drip_location + pVect(0,dball->radius,0);
      dball->velocity = pVect(0,0,0);
      dball->color_natural = *colors[ ( drip_cnt >> drip_run ) & colors_mask ];
      drip_cnt++;
      physs += dball;
    }

  /// If spray is on, release a new ball if it's time.
  //
  ball_countdown -= delta_t;
  if ( opt_spray_on && ball_countdown <= 0 || physs.occ() == 0 )
    {
      const double min_radius = 0.8;
      const double max_rad = 2 * opt_ball_radius;
      const double dr = max_rad - min_radius;
      const double radius = min_radius + dr * random()/(0.0+RAND_MAX);
      const double r = 10;
      const double delta_theta = 0.001 + asin(radius/r);
      static double th = 0;  
      th += delta_theta;
      pCoor position
        ( platform_xmax - r - 2 * opt_ball_radius + (r+max_rad) * cos(th),
          20.0 + 3 * max_rad,
          (r+max_rad) * sin(th) );

      th += delta_theta;

      if ( !sphere_empty(position,radius) ) return;
 
      Ball* const nball = new Ball(this);
      nball->position = position;
      nball->set_radius(radius);

      nball->color_natural = *colors[ ( spray_cnt>>spray_run ) & colors_mask ];
      spray_cnt++;

      physs += nball;
      ball_countdown = 0.1;
    }
}

bool
World::sphere_empty(pCoor center, float radius)
{
  // Determine if volume of space is ball-free within radius of center.
  //
  for ( Phys_Iterator phys(physs); phys; phys++ )
    if ( Ball* const ball = BALL(phys) )
      {
        const double radii = radius + ball->radius;
        pNorm dist(ball->position,center);
        if ( dist.mag_sq <= radii * radii ) return false;
      }
  return true;
}

void
World::time_step_cpu()
{
  const float deep = -100;

  if ( wheel ) wheel->spin();

  if ( data_location & DL_ALL_CUDA )
    {
      pt_sched_waitfor();
      cuda_data_to_cpu(DL_ALL);
      data_location = DL_ALL_CPU;
    }

  /// Remove balls that have fallen away from the platform.
  //
  for ( Ball *ball; balls_iterate(ball); )
    if ( ball->position.y < deep ) { physs.iterate_yank(); delete ball; }

  for ( Ball *ball; balls_iterate(ball); )
    {
      ball->prev_omega = ball->omega;
      ball->prev_velocity = ball->velocity;
    }

  /// Sort balls in z in preparation for finding balls that touch.
  //
  phys_zsort.reset();
  for ( Phys *phys; physs.iterate(phys); )
    phys_zsort.insert(phys->max_z_get(0),phys);
  phys_zsort.sort();

  /// Apply forces for balls that are touching.
  //
  for ( int idx9 = 1; idx9 < phys_zsort.occ(); idx9++ )
    {
      Phys* const prop9 = phys_zsort[idx9];
      const float z_min = prop9->min_z_get(0);
      Ball* const ball9 = BALL(prop9);

      for ( int idx8 = idx9 - 1;
            idx8 >= 0 && phys_zsort.get_key(idx8) >= z_min;
            idx8-- )
        {
          Phys* const prop8 = phys_zsort[idx8];
          Ball* const ball8 = BALL(prop8);
          if ( ball8 && ball9 )
            {
              penetration_balls_resolve(ball8,ball9);
              continue;
            }
          if ( !ball8 && !ball9 ) continue;
          Tile* const tile = ball8 ? TILE(prop9) : TILE(prop8);
          Ball* const ball = ball8 ? ball8 : ball9;
          pCoor tact_pos;
          pNorm tact_dir;
          if ( !tile_sphere_intersect
               (tile,ball->position,ball->radius,tact_pos,tact_dir) ) continue;
          pball->position = tact_pos + pball->radius * tact_dir;
          pball->omega = pVect(0,0,0);
          pball->velocity = pVect(0,0,0);
          pVect vbefore = ball->velocity;
          penetration_balls_resolve(ball,pball,false);
          pVect delta_mo = ball->mass * ( ball->velocity - vbefore );
          if ( wheel ) wheel->collect_tile_force(tile,tact_pos,delta_mo);
        }
    }

  /// Apply gravitational force.
  //
  for ( Ball *ball; balls_iterate(ball); ) ball->velocity += gravity_accel_dt;

  /// Apply force for platform contact.
  //
  for ( Ball *ball; balls_iterate(ball); )
    {
      const pCoor pos(ball->position);
      if ( !platform_collision_possible(ball) ) continue;
      pCoor axis(platform_xmid,0,pos.z);

      // Test for different ways ball can touch platform. If contact
      // is found find position of an artificial platform ball (pball)
      // that touches the real ball at the same place and angle as
      // the platform. This pball will be used for the ball-ball penetration
      // routine, penetration_balls_resolve.

      if ( pos.y > 0 )
        {
          // Possible contact with upper edge of platform.
          //
          pCoor tact
            (pos.x > platform_xmid ? platform_xmax : platform_xmin, 0, pos.z);
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= ball->radius_sq ) continue;
          pball->position = tact + pball->radius * tact_dir;
        }
      else if ( pos.z > platform_zmax || pos.z < platform_zmin )
        {
          // Possible contact with side (curved) edges of platform.
          //
          pNorm ball_dir(axis,pos);
          if ( ball_dir.mag_sq <= ball->short_xrad_sq ) continue;
          const float zedge =
            pos.z > platform_zmax ? platform_zmax : platform_zmin;
          pCoor axis_edge(platform_xmid,0,zedge);
          pCoor tact = axis_edge + platform_xrad * ball_dir;
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= ball->radius_sq ) continue;
          pball->position = tact + pball->radius * tact_dir;
        }
      else
        {
          // Possible contact with surface of platform.
          //
          pNorm tact_dir(axis,pos);
          if ( tact_dir.mag_sq <= ball->short_xrad_sq ) continue;
          pball->position = axis + (pball->radius+platform_xrad) * tact_dir;
        }

      // Finish initializing platform ball, and call routine to
      // resolve penetration.
      //
      pball->omega = pVect(0,0,0);
      pball->velocity = pVect(0,0,0);
      penetration_balls_resolve(ball,pball,false);
    }

  /// Based on updated velocity, update ball positions.
  //
  for ( Ball *ball; balls_iterate(ball); ) 
    ball->position += delta_t * ball->velocity;

  float contact_y_max = -platform_xrad;

  /// Update orientation of balls. (Also find highest ball that hit something.)
  //
  for ( Ball *ball; balls_iterate(ball); )
    {
      pNorm axis(ball->omega);

      // If ball isn't spinning fast skip expensive rotation.
      //
      if ( axis.mag_sq < 0.000001 ) continue;

      // Update ball orientation.
      //
      ball->orientation =
        pQuat(axis,delta_t * axis.magnitude) * ball->orientation;

      if ( ball->contact_count )
        ball->collision = true;

      // Find position of highest ball that has hit something.
      //
      if ( ball->collision && ball->position.y > contact_y_max )
        contact_y_max = ball->position.y;
    }

  balls_add(contact_y_max);
}

// Class providing information about pair of phys in proximity (and
// so potentially in contact).
//
class Contact {
public:
  Contact():phys1(NULL),phys2(NULL),code_path(0){};
  Contact(Contact *c):
    phys1(c->phys1),phys2(c->phys2),code_path(c->code_path),pass(-1){};
  Contact(Phys *phys1, Phys *phys2, int code_path):
    phys1(phys1),phys2(phys2),code_path(code_path),pass(-1){};
  Phys* const phys1;
  Phys* const phys2;
  const int code_path;   // Code path expected, for grouping warps.
  Phys* other_phys(Phys* ball) { return ball == phys1 ? phys2 : phys1; }
  int pass;   // Index of pass_pairs launch: 0 is first, 1 is second, ..
  int block;  // Like blockIdx, but numbering is within time step, not pass.
  int thread; // Index of thread within block.
  int round;  // Index within thread. Zero is 1st pair done by thd, etc.
};

void
World::contact_pairs_find()
{
  /// Find pairs of phys that are in proximity: in contact now or maybe soon.

  // The pair list should include phys that may touch within
  // schedule_lifetime_steps (a constant); from that compute
  // a time.
  //
  const double lifetime_delta_t = schedule_lifetime_steps * delta_t;

  /// Sort phys in z in preparation for finding phys in proximity.
  //
  if ( !opt_cuda_prox )
    {
      phys_zsort.reset();
      for ( Phys_Iterator ball(physs); ball; ball++ )
        {
          const float max_z = ball->max_z_get(lifetime_delta_t);
          phys_zsort.insert(max_z,ball);
          ball->proximity.reset();
        }
      phys_zsort.sort();
    }

  contact_pairs.reset();

  frame_timer.user_timer_start(timer_id_spart);

  const double delta_d_min = 0.1 * schedule_lifetime_steps * opt_ball_radius;

  /// Find pairs of balls that are, or might soon be, touching.
  //
  for ( int idx9 = 0; idx9 < phys_zsort.occ(); idx9++ )
    {
      Phys* const prop9 = phys_zsort[idx9];
      Ball* const ball9 = BALL(prop9);
      Tile* const tile9 = TILE(prop9);
      const float z_min = prop9->min_z_get(lifetime_delta_t);

      for ( int i=idx9-1; i>=0 && phys_zsort.get_key(i) >= z_min; i-- )
        {
          Phys* const prop1 = phys_zsort[i];
          Ball* const ball1 = BALL(prop1);
          Tile* const tile1 = TILE(prop1);
          Phys *propa, *propb;
          int code_path = 0;

          if ( tile1 && tile9 ) continue;

          if ( ball1 && ball9 )
            {
              pNorm dist(ball1->position,ball9->position);
              const float region_length_small =
                1.1 * ( ball1->radius + ball9->radius );

              if ( dist.mag_sq > region_length_small * region_length_small )
                {
                  pVect delta_v(ball1->velocity,ball9->velocity);
                  const double delta_d = lifetime_delta_t * delta_v.mag();
                  const double dist2 =
                    dist.magnitude - max(delta_d,delta_d_min);
                  if ( dist2 > region_length_small ) continue;
                }
              propa = prop1;
              propb = prop9;
              code_path = 1;
            }
          else
            {
              Ball* const ball = ball1 ? ball1 : ball9;
              Tile* const tile = tile1 ? tile1 : tile9;
              const float delta_s = 
                max(delta_d_min,ball->velocity.mag() * lifetime_delta_t);
              if ( !tile_sphere_intersect
                   (tile, ball->position, ball->radius + delta_s) ) continue;
              propa = tile;
              propb = ball;
              code_path = 2;
            }

          const int c_idx = contact_pairs.occ();
          new (contact_pairs.pushi()) Contact(propa,propb,code_path);
          prop1->proximity += c_idx;
          prop9->proximity += c_idx;
        }
    }

  proximity_cnt_errors = 0;
  if ( opt_cuda_prox )
    for ( Phys_Iterator phys(physs); phys; phys++ )
      if ( phys->proximity.occ() != phys->proximity_cnt )
        proximity_cnt_errors++;
  
  frame_timer.user_timer_end(timer_id_spart);
}


void
World::cuda_contact_pairs_find()
{
  /// Added for Spring 2010 Homework 3

  /// Find pairs of phys that are in proximity: in contact now or maybe soon.

  // The pair list should include phys that may touch within
  // schedule_lifetime_steps (a constant); from that compute
  // a time.
  //
  const double lifetime_delta_t = schedule_lifetime_steps * delta_t;

  /// Sort phys in z in preparation for finding phys in proximity.
  //
  phys_zsort.reset(); // Avoid reallocation by resetting rather than declaring.
  for ( Phys_Iterator ball(physs); ball; ball++ )
    {
      const float max_z = ball->max_z_get(lifetime_delta_t);
      phys_zsort.insert(max_z,ball);
      ball->proximity.reset();
      ball->proximity_cnt = 0;
    }
  phys_zsort.sort();

  // Host-side CUDA code to determine proximity count goes here.
  // Also edit balls-kernel.cu and balls.cuh.
  

}

void
World::cuda_schedule()
{
  /// Prepare CUDA Schedule for Contact Pair Handling
  //
  //  Each CUDA thread reads the schedule to determine which
  //  phys pairs to handle (by calling penetration_balls_resolve).
  //
  //  The schedule consists of two arrays, block_balls_needed and
  //  cuda_tacts_schedule. 
  //
  //  The block_balls_needed array lists all the balls needed by each
  //  block in each pass. At the beginning of a pass threads will read
  //  ball numbers from this array and load (prefetch) data for those
  //  balls from device memory into shared memory.
  //
  //  The cuda_tacts_schedule lists pairs of phys, threads
  //  will call penetration_balls_resolve on these pairs, which
  //  will read and write shared memory.
  //
  //  At the end of a pass data from shared memory is copied back
  //  to device memory.

  frame_timer.user_timer_start(timer_id_sched);

  const int block_size = opt_block_size;

  // Find pairs of phys that are in contact or might soon be.
  // The pairs are assigned to variable pairs and the identity of
  // phys near to a ball are put in its proximity member.
  //
  contact_pairs_find();

  // Prepare Ball Lists
  //
  // neighborhood:     Most desirable phys to schedule in the current pass.
  // physs_todo_now:   Phys to schedule in the current pass, after neighbors.
  // physs_todo_later: Phys to schedule in the next pass.
  //
  static PQueue<Phys*> physs_todo_a, physs_todo_b;
  static PQueue<Phys*> neighborhood;
  physs_todo_a.reset(); physs_todo_b.reset(); neighborhood.reset();
  PQueue<Phys*> *physs_todo_now = &physs_todo_a;
  PQueue<Phys*> *physs_todo_later = &physs_todo_b;

  // Initialize phys members for scheduling, and initialize physs_todo_now.
  //
  for ( Phys_Iterator phys(physs); phys; phys++ )
    {
      phys->idx = phys.get_idx();
      phys->color_block = -1; // Used for coloring based on block num.
      if ( !phys->proximity.occ() ) continue;
      phys->pass = -1;
      phys->pass_todo = 0;
      phys->block = -1;
      physs_todo_later->enqueue(phys);
    }

  const double block_size_inv = 1.0 / block_size;

  int block_num = -1;
  int ball_count = -1;
  const int max_rounds = 32;
  const int ball_limit = balls_per_block_max;
  int iterations = 0;           // Used for algorithm tuning.
  int thd_rounds = 0;           // Used for placement tuning.
  bool new_block = false;
  const int ball_idx_bits = 18;

# define WARP_LG 5
# define WARP_SIZE (1<<WARP_LG)
# define WARP_MASK (WARP_SIZE-1)  

  const int warp_per_block = ( block_size + WARP_MASK ) >> WARP_LG;
  const int max_code_paths = 3;
  const int cp_limit = min(warp_per_block,max_code_paths);
  const int round_retry_limit = max( block_size >> 2, 4 );
  int next_thd[cp_limit+1][max_rounds];

  // Return next thread to use for a given contact pair code path and
  // round. To avoid branch divergence, contact pairs with different
  // code paths are placed in different warps.
  //
# define next_thd_get(code_path,round)                                        \
  ({ int& cthd = next_thd[min(code_path,cp_limit)][round];                    \
     if ( ( cthd & WARP_MASK ) == 0 ) {                                       \
       cthd = next_thd[0][round]; next_thd[0][round] += WARP_SIZE; }          \
     cthd >= block_size ? -1 : cthd++; })

  PQueue<int> tacts;

  passes_next->reset();
  PSList<Phys*,uint> pref_balls;
  int soft_ball_limit = 0;
  int new_seed_ball_limit = 0;

  while ( true )
    {
      // If there are no more neighbors of placed balls to
      // work on, grab any unplaced ball.
      //
      if ( !neighborhood.occ() && physs_todo_now->occ() )
        {
          Pass* const p = &passes_next->peek();
          const int block_num_base = p->block_num_base;

          while ( physs_todo_now->occ() )
            {
              Phys* const phys = physs_todo_now->dequeue();
              const bool placed = phys->block >= block_num_base;
              if ( placed ) continue;
              if ( ball_count > new_seed_ball_limit ) new_block = true;
              neighborhood += phys;
              break;
            }
        }

      const bool new_pass = !neighborhood.occ();

      // Check for end of this pass.
      //
      if ( new_pass )
        {
          // If there is nothing in the next pass, exit the loop.
          //
          if ( !physs_todo_later->occ() ) break;

          // Prepare for the next pass by swapping todo lists.
          //
          PQueue<Phys*>* const todo_x = physs_todo_now;
          physs_todo_now = physs_todo_later; physs_todo_later = todo_x;

          neighborhood += physs_todo_now->dequeue();
        }

      ASSERTS( ball_count <= ball_limit );

      // If necessary, initialize a new block.
      //
      // A new block is prepared if the old block reached the ball limit
      // or if this is the start of a new pass and the current block isn't
      // empty.
      //
      if ( new_pass && ball_count || new_block )
        {
          new_block = false;
          ball_count = 0;  block_num++;
          bzero(next_thd,sizeof(next_thd));
        }

      // If necessary, initialize a new pass.
      //
      if ( new_pass )
        {
          Pass* const p = passes_next->pushi();
          p->block_num_next_pass = p->block_num_base = block_num;
          p->ball_cnt = 0;
          p->thread_num_max = 0;
          p->balls_per_block_max = 0;
          p->round_cnt = 0;
          soft_ball_limit =
            passes_next->occ() == 1 ?
            min(max(8, 2 * block_size), ball_limit ) : ball_limit;
          new_seed_ball_limit = min(30,soft_ball_limit-2);
        }

      const int pass_num = passes_next->occ() - 1;
      Pass* const p = &passes_next->peek();
      const int block_num_base = p->block_num_base;

      // Get a phys to consider.
      //
      Phys* const phys1 = neighborhood.dequeue();

      // Check whether this ball already used in this pass.
      //
      const bool b1_placed = phys1->block >= block_num_base;

      // Macro for adding ball to todo list.
#define NEXT_PASS_ADD(ba)                                                     \
      { if ( ba->pass_todo <= pass_num )                                 \
          { ba->pass_todo = pass_num + 1; physs_todo_later->enqueue(ba); } }

      // If ball used in this pass but not in this block then we have no
      // choice but to schedule it in a future pass.
      //
      if ( b1_placed && phys1->block != block_num )
        { NEXT_PASS_ADD(phys1);  continue; }

      // Initialize schedule for this ball if it's new to this block.
      //
      if ( !b1_placed ) phys1->rounds = 0;

      // Look for balls near phys1 that have not been considered,
      // and add suitable ones to tacts (contacts).
      //
      tacts.reset();

      for ( int c_idx = phys1->proximity.iterate_reset();
            phys1->proximity.iterate(c_idx); )
        {
          iterations++;
          Contact* const c = &contact_pairs[c_idx];
          if ( c->pass >= 0 ) continue;
          Phys* const phys2 = c->other_phys(phys1);
          const bool b2_placed = phys2->block >= block_num_base;

          // If other ball used in this pass but not this block
          // then we can't consider the phys1/phys2 contact in this
          // pass, so try again in the next pass. (Either phys1 or phys2
          // could be added, phys1 may be more efficient.)
          //
          if ( b2_placed && phys2->block != block_num )
            { NEXT_PASS_ADD(phys1);  continue; }

          if ( !b2_placed ) phys2->rounds = 0;
          tacts += c_idx;
        }

      int rounds_skipped = 0;
      int dwell_count = 0;
      int round = 0;
      int round_full_cnt = 0;
      while ( tacts.occ() && round < max_rounds )
        {
          // Counter used for tuning CPU time of this scheduling algorithm.
          iterations++;

          // Get a contact pair to try.
          //
          const int c_idx = tacts.dequeue();
          Contact* const c = &contact_pairs[c_idx];
          Phys* const phys2 = c->other_phys(phys1);
          const bool b1_placed = phys1->block >= block_num_base;
          const bool b2_placed = phys2->block >= block_num_base;
          const int code_path = c->code_path;

          // Bit positions indicate rounds in which ball is used.
          const uint32_t mask = 1 << round;

          // If phys1 used elsewhere in this round move to next round.
          //
          if ( phys1->rounds & mask )
            {
              round++;  dwell_count = 0;
              rounds_skipped++;
              tacts += c_idx;   // Put contact pair back in list.
              continue;
            }

          // Check if phys2 used elsewhere in this round.
          //
          if ( phys2->rounds & mask )
            {
              // Move to next round if we've already tried scheduling
              // other balls in this round.
              //
              if ( dwell_count++ >= tacts.occ() )
                {
                  round++;  dwell_count = 0;
                  rounds_skipped++;
                }

              tacts += c_idx;   // Put contact pair back in list.
              continue;
            }
          dwell_count = 0;

          const int next_ball_count = ball_count + !b1_placed + !b2_placed;

          // If this contact pair would exceed ball limit, then try again
          // next pass.
          //
          if ( next_ball_count > soft_ball_limit )
            { NEXT_PASS_ADD(phys1); continue; }

          const int thd = next_thd_get(code_path,round);
          if ( thd < 0 )
            {
              round++;  round_full_cnt++;
              tacts += c_idx;   // Put contact pair back in list.
              if ( round_full_cnt > round_retry_limit )
                { new_block = true;  break; }
              continue;
            }

          if ( !b1_placed )
            {
              phys1->block = block_num;
              p->ball_cnt++;

              // Add ball to prefetch list.  Used to load CUDA
              // shared memory.
              //
              pref_balls.insert
                ( ( block_num << ball_idx_bits ) | phys1->idx, phys1 );
            }

          if ( !b2_placed )
            {
              phys2->block = block_num;
              p->ball_cnt++;
              pref_balls.insert
                ( ( block_num << ball_idx_bits ) | phys2->idx, phys2 );

              // Put phys2 at the head of the todo list since phys1 and phys2
              // are likely to have common neighbors.
              //
              neighborhood += phys2;
            }

          ball_count = next_ball_count;
          set_max(p->balls_per_block_max,ball_count);

          /// Scheduling of this Contact Pair Complete
          //
          c->pass = pass_num;
          c->block = block_num;
          c->thread = thd;
          set_max(p->thread_num_max,c->thread);
          c->round = round;
          p->block_num_next_pass = block_num + 1;

          // Update bit vectors indicating which rounds ball used.
          if ( !phys1->read_only ) phys1->rounds |= mask;
          if ( !phys2->read_only ) phys2->rounds |= mask;

          round++;
          thd_rounds += rounds_skipped + 1;
          rounds_skipped = 0;
          set_max(p->round_cnt,round);
        }

      // If anything is left over, re-consider ball in next pass.
      //
      if ( tacts.occ() ) NEXT_PASS_ADD(phys1);
    }

  // Compute number of blocks in each pass and collect tuning information.
  //
  int pass_blocks = 0;
  int pass_block_rounds = 0;
  int total_rounds = 0;
  int max_blocks = 0;
  while ( Pass* const p = passes_next->iterate() )
    {
      p->thread_cnt_max = p->thread_num_max + 1;
      p->block_cnt = p->block_num_next_pass - p->block_num_base;
      p->balls_per_thread_max =
        int( ceil( p->balls_per_block_max * block_size_inv ) );
      pass_blocks += p->block_cnt;
      total_rounds += p->round_cnt;
      pass_block_rounds += p->block_cnt * p->round_cnt;
      set_max(max_blocks,p->block_cnt);
    }

  // Prepare the pair_check sorted list, which is used for scheduling,
  // sanity checks, and collecting tuning information.
  //
  static PSList<Contact*,int64_t> pair_check;
  pair_check.reset();
  while ( Contact* const c = contact_pairs.iterate() )
    pair_check.insert
      ( c->block * max_rounds * block_size
        + c->round * block_size + int64_t(c->thread) , 
        c );
  pair_check.sort();

  // Sanity Check: Make sure phys scheduled in at most one
  // block per pass.
  //
  for ( Phys_Iterator ball(physs); ball; ball++ ) ball->pass = -1;
  while ( Contact* const c = pair_check.iterate() )  
    {
      const int pass = c->pass;
      const int round = c->round;
      const int block = c->block;
      ASSERTS( pass >= 0 );
      for ( int i=0; i<2; i++ )
        {
          Phys* const b = i ? c->phys2 : c->phys1;
          ASSERTS( b->pass < pass || b->read_only
                   || b->block == block && b->rounds < round );
          b->pass = pass;
          b->block = block;
          b->rounds = round;
        }
    }

  // Tuning Info: Determine how much each warp being used.
  //
  int warp_rounds = 0;
  const int warp_lg = 5;
  const int warps_per_block = max(1,block_size >> warp_lg);
  const int warp_limit = ( block_num + 1 ) * warps_per_block;
  int warp_rounds_each[warp_limit];
  bzero(warp_rounds_each,sizeof(warp_rounds_each));
  int warp_path = 0, idx_last = -1;
  int warp_cnt = 0;
  int warp_broken_cnt = 0;
  while ( Contact* const c = pair_check.iterate() )
    {
      const int round_cnt = c->round + 1;
      const int warp_idx = c->thread >> WARP_LG;
      const int idx = c->block * warps_per_block + warp_idx;

      if ( idx != idx_last )
        {
          warp_cnt++;
          warp_path = c->code_path;
          idx_last = idx;
        }
      else if ( warp_path && warp_path != c->code_path )
        {
          warp_broken_cnt++;
          warp_path = 0;
        }

      const int a = round_cnt - warp_rounds_each[idx];
      if ( a <= 0 ) continue;
      warp_rounds_each[idx] = round_cnt;
      warp_rounds += a;
    }

  round_count_prev = total_rounds;
  static int total_rounds_max = 0;
  if ( opt_info || total_rounds > total_rounds_max )
    {
      opt_info = false;
      printf("For %d tacts, %d p, %d tot rnds; "
             "Max Bl %d/%d/%d W %d/%d  Eff %.3f %.3f\n",
             contact_pairs.occ(),
             passes_next->occ(),
             total_rounds,
             max_blocks, pass_blocks, pass_block_rounds,
             warp_rounds << warp_lg,
             thd_rounds,
             contact_pairs.occ() / double(warp_rounds<<warp_lg),
             contact_pairs.occ() / double(iterations)
             );
      total_rounds_max = total_rounds;
    }

  // Determine size of schedule data (cuda_tacts_schedule and
  // block_balls_needed) for each pass, and remember offsets into
  // these arrays.
  //
  int ba_size = 0;
  int pa_size = 0;

  while ( Pass* const p = passes_next->iterate() )
    {
      p->dim_block.x = block_size;
      p->dim_block.y = p->dim_block.z = 1;
      p->dim_grid.x = p->block_cnt;
      p->dim_grid.y = p->dim_grid.z = 1;
      p->prefetch_offset = pa_size;
      const int prefetch_elts_per_block = p->balls_per_thread_max * block_size;
      p->prefetch_elts_per_block = prefetch_elts_per_block;
      pa_size += prefetch_elts_per_block * p->block_cnt;
      p->schedule_offset = ba_size;
      ba_size += block_size * p->block_cnt * p->round_cnt;
    }

  // Update size of schedule arrays and initialize.
  //
  cuda_tacts_schedule.realloc_locked(ba_size);
  block_balls_needed.realloc_locked(pa_size);
  memset(cuda_tacts_schedule.data,-1,cuda_tacts_schedule.chars);
  memset(block_balls_needed.data,-1,block_balls_needed.chars);

  pref_balls.sort();

  // Write schedule arrays.
  //
  int block_curr = -1;
  int pbi = 0;
  while ( Contact* const c = pair_check.iterate() )
    {
      const int round = c->round;
      const int block = c->block;
      Pass& p = passes_next[0][c->pass];

      // Fill in prefetch (balls_needed) array.
      //
      if ( block_curr != block )
        {
          block_curr = block;
          const int idx_base =
            p.prefetch_offset
            + ( block - p.block_num_base ) * p.prefetch_elts_per_block;
          int ball_sidx_next = 0;
          while ( pbi < pref_balls.occ() )
            {
              const int pb_block = pref_balls.get_key(pbi) >> ball_idx_bits;
              if ( pb_block > block_curr ) break;
              Phys* const b = pref_balls[pbi++];
              const int idx = idx_base + ball_sidx_next;
              ASSERTS( ball_sidx_next < ball_limit );
              ASSERTS( pb_block == block );
              ASSERTS( block_balls_needed[idx] == -1 );
              b->sm_idx = ball_sidx_next++;
              block_balls_needed[ idx ] = b->idx;
              if ( c->pass == opt_block_color_pass ) b->color_block = block;
            }
        }

      // Fill in cuda_tacts_schedule array.
      //
      SM_Idx2 pair = { c->phys1->sm_idx, c->phys2->sm_idx };
      const int ba_idx =
        p.schedule_offset
        + ( block - p.block_num_base ) * p.round_cnt * block_size
        + round * block_size
        + c->thread;
      ASSERTS( ba_idx < ba_size && ba_idx >= 0 );
      SM_Idx2 old_pair = cuda_tacts_schedule[ba_idx];
      ASSERTS( old_pair.x == 0xffff && old_pair.y == 0xffff );
      cuda_tacts_schedule[ ba_idx ] = pair;
    }

  frame_timer.user_timer_end(timer_id_sched);
}

void
World::time_step_cuda(int iters_per_frame, bool just_before_render)
{
  /// Advance physical state by one time step using CUDA for computation.

  cuda_init();
  const int ball_cnt = physs.occ();

  const int plat_block_size_1pmp =
    max(32,int(ceil(double(ball_cnt) / cuda_prop.multiProcessorCount)));
  const int plat_block_size =
    min(plat_block_size_1pmp, cfa_platform.maxThreadsPerBlock);

  // Set configuration for platform pass.
  //
  dim_grid.x = int(ceil(double(ball_cnt)/plat_block_size));
  dim_grid.y = dim_grid.z = 1;
  dim_block.x = plat_block_size;
  dim_block.y = dim_block.z = 1;

  // If necessary, command scheduler thread to start working on a schedule.
  // We rather do this at the end of the routine because if we do it
  // here we are forced to wait.
  //
  if ( !pt_sched_data_pending && cuda_schedule_stale > 0 )
    pt_sched_start();

  // If a freshly computed schedule is waiting, send it to CUDA.
  //
  if ( pt_sched_data_pending )
    {
      pt_sched_waitfor();
      { PStack<Pass>* const x = passes_curr;
        passes_curr = passes_next; passes_next = x; }
      if ( opt_color_events )
        for ( Ball *b; balls_iterate(b); )
          b->color_event =
            b->color_block >= 0 ? *colors[b->color_block & colors_mask] : dark;
      block_balls_needed.ptrs_to_cuda("block_balls_needed");
      block_balls_needed.to_cuda();
      cuda_tacts_schedule.ptrs_to_cuda("tacts_schedule");
      cuda_tacts_schedule.to_cuda();
      pt_sched_data_pending = false;
      cuda_schedule_stale = -schedule_lifetime_steps;
      if ( wheel ) wheel->cuda_constants_stale = true; // Only if idx changed.
    }

  cuda_schedule_stale++;

  // Make copy of ball structures for debugging.
  Ball ball_a = *ball_first();

  if ( passes_curr->occ() ) block_count_prev = passes_curr[0][0].dim_grid.x;

  // Start timer. (Used for code tuning.)
  //
  CE(cudaEventRecord(frame_start_ce,0));

  cpu_data_to_cuda();
  data_location = DL_ALL_CUDA;

  // Launch the contact pair kernel for as many passes as needed.
  //
  while ( Pass* const p = passes_curr->iterate() )
    pass_pairs_launch
      (p->dim_grid,p->dim_block,
       p->prefetch_offset,p->schedule_offset,p->round_cnt,
       p->balls_per_thread_max,p->balls_per_block_max);

  // Launch the platform kernel.
  //
  pass_platform_launch(dim_grid,dim_block,physs.occ());

  // If data is needed to render a frame, copy from CUDA to CPU.
  //
  if ( just_before_render )
    cuda_data_to_cpu(DL_ALL);

  // Stop timer.
  CE(cudaEventRecord(frame_stop_ce,0));
  CE(cudaEventSynchronize(frame_stop_ce));
  float cuda_time = -1.1;
  CE(cudaEventElapsedTime(&cuda_time,frame_start_ce,frame_stop_ce));
  frame_timer.cuda_frame_time_set(cuda_time);
  pError_Check();

  // Copy an "after" ball, for hand debugging.
  Ball ball_b = *ball_first();

  // Sanity Check: Make sure CUDA ran penetration_balls_resolve enough times.
  //
  if ( data_location & DL_OT_CPU )
    for ( Phys *phys; physs.iterate(phys); )
      {
        Ball* const ball = BALL(phys);
        Tile* const tile = TILE(phys);
        ASSERTS( ball || tile );
        // Number of other props to check for collision with.
        const int px = phys->proximity.occ();

        // Number of times CUDA code checked for a collision.
        const int ca = phys->debug_pair_calls >> 16;
        ASSERTS( phys->read_only || px == ca ); // Fatal error if not equal.
      }

  // Update counter used for shower spray.
  //
  ball_countdown -= delta_t;

  if ( ! ( data_location & DL_CV_CPU ) ) return;

  if ( !just_before_render ) return;

  float contact_y_max = -platform_xrad;

  for ( Ball *ball; balls_iterate(ball); )
    if ( ball->collision ) set_max(contact_y_max,ball->position.y);

  balls_add(contact_y_max);

  const float deep = -100;
  for ( Ball *ball; balls_iterate(ball); )
    if ( ball->position.y < deep )
      {
        cuda_at_balls_change();
        physs.iterate_yank(); delete ball;
      }

  if ( just_before_render && cuda_schedule_stale + iters_per_frame - 1 > 0 )
    pt_sched_start();
}


// Return a sphere with a detail level appropriate for the ball's distance
// from the viewer's eye.
//
Sphere*
World::sphere_get(Ball *ball)
{
  const float dist =
    ball->radius_inv * ( distance(ball->position,eye_location) - 1 );
  const int lod_raw =
    int( 0.99 + sphere_lod_factor / dist - sphere_lod_offset );
  const int lod = max(min(lod_raw,sphere_count-1),0);
  return &spheres[lod];
}

void
World::balls_render_simple()
{
  // Render balls without textures. Intended for casting shadows.

  tile_manager.render_simple();

  for ( Ball *ball; balls_iterate(ball); )
    {
      const int c = ball->contact_count;

      // Assume that a ball in contact with more than 6 others
      // won't cast a visible shadow.
      //
      if ( c > 6 ) continue;

      Sphere* const s = opt_pause ? &sphere : sphere_get(ball);

      s->render_simple(ball->radius,ball->position);
    }
}

void
World::balls_render(bool attempt_ot)
{
  physs_occluded = 0;
  int iter=0;
  for ( Phys *phys; eye_dist.iterate(phys); )
    {
      Ball* const ball = BALL(phys);
      iter++;
      if ( !ball ) continue;
      pColor color =
        opt_color_events ? ball->color_event : ball->color_natural;

      // Retrieve the result of an occlusion test on this ball.
      //
      while ( attempt_ot && ball->occlusion_query_active )
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

      if ( ball->occluded ) physs_occluded++;
      
      // Decide whether to perform an occlusion test.
      //
      const bool do_ot = attempt_ot && ball->occlusion_countdown-- == 0;

      // Don't render this ball because it hasn't resulted in
      // anything being written to the frame buffer more than
      // 10 consecutive times.
      //
      if ( ball->occluded_run > 10 && !do_ot ) continue;

      // Maybe start an occlusion query.
      if ( do_ot )
        glBeginQuery(GL_SAMPLES_PASSED,ball->query_occlusion_id);

      if ( ball->occluded_run > 10 )
        {
          // Ball is probably not visible, so render it with
          // a simple sphere.
          //
          sphere_lite.render_simple(ball->radius,ball->position);
        }
      else
        {
          // Get sphere with detail level appropriate for viewer distance.
          //
          Sphere* const s = opt_pause ? &sphere : sphere_get(ball);

          // Set ball's color, position, and orientation, and
          // render it.
          //
          pMatrix_Rotation rot(ball->orientation);
          s->color = color;
          s->render(ball->radius,ball->position,rot);
        }
      if ( do_ot )
        {
          ball->occlusion_query_active = true;
          glEndQuery(GL_SAMPLES_PASSED);
        }
    }
}

void
World::render_shadow_volumes(pCoor light_pos)
{
  // Render objects' shadow volumes.

  // Make sure that only stencil buffer written.
  //
  glColorMask(false,false,false,false);
  glDepthMask(false);

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

  if ( opt_shadow_volumes )
    {
      // Make shadow volumes visible.

      glColorMask(true,true,true,true);
      glColor3f(0.8,0,0);
    }

  // Render balls' shadow volumes.
  //
  for ( Ball *ball; balls_iterate(ball); )
    {
      Sphere* const s = opt_pause ? &sphere : sphere_get(ball);
      s->light_pos = light_pos;
      s->render_shadow_volume(ball->radius,ball->position);
    }

  // Render tiles' shadow volumes.
  //
  tile_manager.render_shadow_volume(light_pos);

  // Restore assumed state.
  //
  glColorMask(true,true,true,true);
  glDepthMask(true);
}

void
World::render_objects(bool attempt_ot)
{
  // Render objects normally.

  const float shininess_ball = 20;
  pColor spec_color(0.2,0.2,0.2);

  glEnable(GL_LIGHTING);
  glEnable(GL_TEXTURE_2D);

  //
  // Render Balls
  //

  // Set up cool specular lighting parameters.
  //
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
  glEnable(GL_COLOR_SUM);

  glBindTexture(GL_TEXTURE_2D,texid_ball);

  // Render each ball.
  //
  balls_render(attempt_ot);

  glDisable(GL_COLOR_SUM);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR);

  // Render each tile.
  //
  tile_manager.render();

  //
  // Render Platform
  //

  // Set up attribute (vertex, normal, etc.) arrays.
  //
  glBindTexture(GL_TEXTURE_2D,texid_plat);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  platform_tile_norms.bind();
  glNormalPointer(GL_FLOAT,sizeof(platform_tile_norms.data[0]), 0);
  glEnableClientState(GL_NORMAL_ARRAY);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Write lighter-colored, textured tiles.
  //
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
  glColor3f(0.35,0.35,0.35);
  glDrawArrays(GL_QUADS,0,platform_even_vtx_cnt);

  // Write darker-colored, untextured, mirror tiles.
  //
  glEnable(GL_BLEND);
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,white);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,20);
  glDisable(GL_TEXTURE_2D);
  glColor3fv(mirror_tint);
  glDrawArrays(GL_QUADS,platform_even_vtx_cnt,platform_odd_vtx_cnt);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
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
      // If we are recording a video base world time on video frame
      // rate rather than wall clock time.
      //
      if ( ogl_helper.animation_record )
        world_time = time_now - ogl_helper.frame_period;

      // Advance simulation state by wall clock time.
      //
      const double elapsed_time = time_now - world_time;
      const int iter_limit =
        min( opt_time_step_factor * 3, int ( 0.5 + elapsed_time / delta_t));
      for ( int iter=0; true; iter++ )
        {
          const bool last = iter == iter_limit - 1;
          if ( opt_physics_method == GP_cpu )
            time_step_cpu();
          else
            time_step_cuda(iter_limit,last);

          world_time += delta_t;
          if ( last ) break;
        }
      frame_timer.work_amt_set(iter_limit);
    }

  /// Emit a Graphical Representation of Simulation State
  //
  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  // Frustum: left, right, bottom, top, near, far
  pMatrix_Frustum projection(-.8,.8,-.8/aspect,.8/aspect,1,5000);
  glLoadTransposeMatrixf(projection);

  glViewport(0, 0, win_width, win_height);
  pError_Check();

  const double tri_edge_len_px = 4;

  sphere_lod_factor =
    win_width * 2.0 * M_PI
    / ( 1.6 * tri_edge_len_px * sphere_delta_lod );
  sphere_lod_offset = sphere_lod_min / sphere_delta_lod;

  glClearColor(0,0,0,0);
  glClearDepth(1.0);
  glClearStencil(0);
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

  const float shininess_ball = 20;
  pColor spec_color(0.2,0.2,0.2);

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

  ogl_helper.fbprintf("F2010 HW3: CUDA Prox %d ('F4' to change), Errors %d\n",
                      opt_cuda_prox, proximity_cnt_errors);

  if ( 0 )
  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Shadows: %-3s ('w')  Mirror: %-3s %d "
     "Light location: [%5.1f, %5.1f, %5.1f]\n",
     opt_shadows ? "on" : "off",
     opt_mirror ? "on" : "off", opt_mirror_method,
     light_location.x, light_location.y, light_location.z);

  Ball& ball = *ball_first();
  ogl_helper.fbprintf
    ("Balls %4d (%4d/%4d)  Tiles %3d  Last Ball Pos  "
     "[%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]  Tri Count %d\n",
     physs.occ(), 
     physs.occ() - physs_occluded, physs_occluded,
     tile_manager.occ(),
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z,
     tri_count);

  ogl_helper.fbprintf
    ("Physics: %s ('a')  Debug Options: %d %d ('qQ')  "
     "Physics Verification %d ('v')\n",
     gpu_physics_method_str[opt_physics_method], 
     opt_debug, opt_debug2, opt_verify);
  if ( opt_physics_method == GP_cuda && cuda_initialized )
    {
      ogl_helper.fbprintf
        ("MPs: %d  Blocks: %d  (%.1f Bl/MP)  Th/Bl: %d  WP/Bl: %.3f  "
         "Passes: %d  Rounds: %d  Time %.0f\n",
         cuda_prop.multiProcessorCount,
         block_count_prev,
         block_count_prev / double(cuda_prop.multiProcessorCount),
         opt_block_size,
         opt_block_size / 32.0,
         passes_curr->occ(), round_count_prev,
         ceil(block_count_prev / double(cuda_prop.multiProcessorCount))
         * ceil(opt_block_size / 32.0)
         * round_count_prev
         );

      pString pass_txt;
      pString cp_txt;
      int time_total = 0;
      while ( Pass* const p = passes_curr->iterate() )
        {
          const int blocks_per_mp =
            int(0.99999 + double(p->block_cnt)/cuda_prop.multiProcessorCount);
          const int active_warps_per_block =
            int( 0.99999 + p->thread_cnt_max / 32.0 );
          cp_txt.sprintf(" %2d * %2d * %2d + ",
                         blocks_per_mp, active_warps_per_block, p->round_cnt);
          time_total += blocks_per_mp * active_warps_per_block * p->round_cnt;
        }

      ogl_helper.fbprintf("Time %3d: %s\n",
                          time_total, cp_txt.s);

      ogl_helper.fbprintf
        ("Platform Block cnt/size: %d / %d\n",
         dim_grid.x, dim_block.x
         );
    }

  tri_count = 0;

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());

  // Sort balls by distance from user's eye.
  // This is needed for the occlusion test.
  //
  eye_dist.reset();
  for ( Ball *ball; balls_iterate(ball); )
    {
      pVect ve(ball->position,eye_location);
      eye_dist.insert(dot(ve,ve),ball);
    }
  eye_dist.sort();

  if ( opt_mirror && vs_reflect->okay() )
    {
      //
      // Render ball reflection.  (Will be blended with dark tiles.)
      //

      // Write stencil at location of dark (mirrored) tiles.
      //
      glDisable(GL_LIGHTING);
      glEnable(GL_STENCIL_TEST);
      glStencilFunc(GL_NEVER,4,-1);
      glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);
      platform_tile_coords.bind();
      glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
      glEnableClientState(GL_VERTEX_ARRAY);
      glDrawArrays(GL_QUADS,platform_even_vtx_cnt,platform_odd_vtx_cnt);

      glEnable(GL_LIGHTING);
      glDisableClientState(GL_VERTEX_ARRAY);
      glBindBuffer(GL_ARRAY_BUFFER,0);

      // Prepare to write only stenciled locations.
      //
      glStencilFunc(GL_EQUAL,4,4);
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

      // Reflected front face should still be treated as the front face.
      //
      glFrontFace(GL_CW);
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D,texid_ball);

      glEnable(GL_LIGHT0);
      glEnable(GL_LIGHT1);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);

      glEnable(GL_BLEND);
      glBlendEquation(GL_FUNC_ADD);
      glBlendFunc(GL_CONSTANT_ALPHA,GL_ZERO); // src, dst
      glBlendColor(0,0,0,0.5);

      // Use a shader that reflects objects.
      //
      vs_reflect->use();

      // Send constants to shader.
      //
      glUniform1f(sun_platform_xmid, platform_xmid);
      glUniform1f(sun_platform_xrad, platform_xrad);
      glUniform1i(sun_opt_mirror_method, opt_mirror_method);
      glUniform1i(sun_opt_color_events, opt_color_events);
      glUniform4fv(sun_eye_location, 1, eye_location);
      glUniformMatrix4fv(sun_eye_to_world, 1, true, modelview_inv);
      modelview_projection = projection * modelview;
      glUniformMatrix4fv(sun_world_to_clip, 1, true, modelview_projection);

      balls_render(false);
      tile_manager.render();

      // Change back to fixed functionality (no user shader).
      //
      vs_fixed->use();

      glFrontFace(GL_CCW);
      glDisable(GL_STENCIL_TEST);
    }


  // At this point, frame buffer contains only object reflections.

  glDisable(GL_BLEND);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_ONE,GL_ONE);

  if ( !opt_shadows )
    {
      //
      /// Render objects in just a single pass, no shadows.
      //

      glEnable(GL_LIGHT1);
      glEnable(GL_LIGHT0);

      render_objects(true);
    }
  else
    {
      //
      /// Render objects and the shadows they cast.
      //

      //
      // First pass, render using only ambient light.
      //
      glDisable(GL_LIGHT1);
      glDisable(GL_LIGHT0);

      // Send balls, tiles, and platform to opengl.
      // Do occlusion test too.
      //
      render_objects(true);

      //
      // Second pass, add on light0.
      //

      // Turn off ambient light, turn on light 0.
      //
      glLightModelfv(GL_LIGHT_MODEL_AMBIENT, dark);
      glEnable(GL_LIGHT0);

      // Write stencil with shadow locations based on shadow volumes
      // cast by light0 (light_location).  Shadowed locations will
      // have a positive stencil value.
      //
      glClear(GL_STENCIL_BUFFER_BIT);
      render_shadow_volumes(light_location);

      // Use stencil test to prevent writes to shaded areas.
      //
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,0,-1); // ref, mask

      // Allow pixels to be re-written.
      //
      glDepthFunc(GL_LEQUAL);

      // Render, but don't do occlusion test again.
      //
      render_objects(false);

      //
      // Third pass, add on light1.
      //

      glDisable(GL_LIGHT0);
      glEnable(GL_LIGHT1);

      glClear(GL_STENCIL_BUFFER_BIT);
      render_shadow_volumes(light1_location);

      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
      glStencilFunc(GL_EQUAL,0,-1); // ref, mask

      render_objects(false);
    }

  // Maybe render platform normals.
  //
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
  case FB_KEY_F4: opt_cuda_prox = !opt_cuda_prox; break;
  case FB_KEY_F8:
    {
      opt_elasticity = 10;
      opt_friction_roll = 300;
      opt_friction_coeff = 0.0001;
      break;
    }
  case 'a':
    if ( opt_physics_method == GP_cuda ) cuda_at_balls_change();
    opt_physics_method++;
    if ( opt_physics_method > GP_cuda ) opt_physics_method = GP_cpu;
    break;
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'c': case 'C': opt_color_events = !opt_color_events; break;
  case 'd': opt_drip = !opt_drip; if(!opt_drip)dball=NULL; break;
  case 'D': opt_move_item = MI_Drip; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'i': opt_info = true; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'm': opt_mirror = !opt_mirror; break;
  case 'M': opt_mirror_method++;
    if ( opt_mirror_method == 4 ) opt_mirror_method = 0;
    break;
  case 'n': case 'N': opt_normals_visible = !opt_normals_visible; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'q': opt_debug = !opt_debug; break;
  case 'Q': opt_debug2 = !opt_debug2; break;
  case 'R': balls_remove(); break;
  case 's': balls_stop(); break;
  case 'S': balls_rot_stop(); break;
  case 'T': benchmark_setup(1); break;
  case 't': benchmark_setup(5); break;
  case 'v': opt_verify = !opt_verify; break;
  case 'w': opt_shadows = !opt_shadows; break;
  case 'W': opt_shadow_volumes = !opt_shadow_volumes; break;
  case 'x': opt_spray_on = !opt_spray_on; break;
  case 'X':
    {
      Ball* const b1 = new Ball(this);
      b1->position = pCoor(30,22,20);
      b1->velocity = pVect(0,0,0);
      b1->color_natural = lsu_spirit_purple;
      physs += b1;
      Ball* const b2 = new Ball(this);
      b2->position = b1->position;
      b2->position.z += 4 * opt_ball_radius;
      b2->velocity = pVect(0,0,0);
      b2->color_natural = lsu_spirit_gold;
      physs += b2;
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

  // Update object location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      if ( opt_move_item == MI_Eye )
        adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Ball: ball_last()->translate(adjustment); break;
      case MI_Ball_V: ball_last()->push(adjustment); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      case MI_Drip: drip_location += adjustment; break;
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
