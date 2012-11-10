// -*- c++ -*-
#ifndef WORLD_H
#define WORLD_H

#include "boxes.h"
#include "k-main.cuh"
#include "gra-shapes.h"

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

  bool opt_cuda_prox;           // If true use cuda to compute proximity.
  int contact_pairs_proximity_check
  (int zidx, double lifetime_delta_t, bool verify);
  void cuda_contact_pairs_find();

  static void main_callback_w(void *moi){((World*)moi)->main_callback();}
  void main_callback();
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
  int opt_fixed_lod;

  // Time in simulated world.
  //
  double world_time, last_frame_time;

  // Physical objects (Balls, Tiles, etc.) being Simulated
  //
  Phys_List physs;
  PSList<Phys*,double> eye_dist; // Balls sorted by eye distance.
  bool phys_live_iterate(Phys*& phy);
  bool balls_iterate(Ball*& ball);
  bool boxes_iterate(Box*& box);
  Ball* ball_first();           // Oldest surviving ball.
  Phys* phys_last();            // Youngest surviving phys.

  // Options controlling ball shower.
  //
  bool opt_spray_on;
  int spray_cnt, spray_run;
  double ball_countdown;

  // Options controlling ball drip.
  //
  bool opt_drip, opt_drop_boxes;
  int drip_cnt, drip_run;
  pCoor drip_location;
  Phys *dball;
  Ball* pball;

  int physs_occluded;

  // Lists used for computing which phys pairs are in proximity.
  //
  PSList<Phys*,double> phys_zsort;
  PStack<Contact> contact_pairs;

  void ball_init();
  void benchmark_setup(int tiers=1);
  void setup_debug();
  void setup_staircase();
  void setup_brick_wall(float max_y = -5);
  void setup_tower(float base, int layers, bool balls);
  void setup_house_of_cards();

  void contact_pairs_find();
  bool penetration_balls_resolve
  (Ball *ball1, Ball *ball2, bool b2_real = true);
  bool penetration_boxes_resolve_force(Tact_Box_Box *cpair);
  bool penetration_boxes_resolve_fric(Tact_Box_Box *cpair);
  bool penetration_box_ball_resolve(Box *box, Ball *ball);

  void balls_render(bool attempt_ot);
  void render_objects_simple();

  void phys_check();
  void all_remove();
  void balls_remove();
  void phys_stop();
  void phys_rot_stop();

  bool opt_gravity;
  float opt_gravity_accel;      // Value chosen by user.
  float opt_ball_density;
  float opt_ball_radius;
  float opt_bounce_loss;
  float opt_bounce_loss_box;
  float opt_elasticity;
  float opt_friction_coeff;
  float opt_friction_roll;
  float opt_air_resistance;
  int opt_time_step_factor;

  // Pre-computed values.
  //
  double delta_t, delta_th;
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  pVect gravity_accel_dt;
  double elasticity_inv_dt;

  Tile_Manager* tile_manager;
  Box_Manager* box_manager;

  // For debugging box code.
  PStack<SectTT> sects;

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
  bool opt_outline_intersection;
  bool opt_color_events;

  int tri_count; // For tuning, demo.

  pShader *vs_fixed;       // Use fixed functionality.
  pShader *vs_reflect;     // Render reflections of primitives.
  pShader *vs_plain;       // Reproduce fixed func., can get better performance.
  pShader *vs_xfrom_only;  // No lighting, color not assigned.

  GLint sun_axis_e, sun_axis_ne, sun_platform_xrad_sq, sun_light_num;
  GLint sun_platform_xmid, sun_platform_xrad; 
  GLint sun_eye_location, sun_eye_to_world, sun_world_to_clip;
  GLint sun_opt_mirror_method, sun_opt_color_events;
  GLint sun_vs_options;

  GLuint texid_plat;
  GLuint texid_ball;
  GLuint texid_mural;

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
  void pt_init();
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
  void time_step_cuda(int iter, int iters_per_frame);

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
  cudaEvent_t pairs_start_ce, pairs_stop_ce, xx_pairs_start_ce;
  cudaEvent_t platform_stop_ce;
  float pairs_cumulative, xx_pairs_cumulative, platform_cumulative;
  int pairs_cumulative_count;

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
  cudaFuncAttributes cfa_xx_intersect;
  int balls_per_block_max;
  int block_count_prev;        // Maximum number of blocks in last pairs pass.
  int round_count_prev;        // Total number of rounds in all pairs passes.
  bool cuda_constants_stale;   // When true, need to update constants.

  pCUDA_Memory<int> z_sort_indices;
  pCUDA_Memory<float> z_sort_z_max;
  pCUDA_Memory<uint8_t> cuda_prox;

  pCUDA_Memory<XX_Pair> xx_pairs;   // Box/Box pairs for intersection testing.
  pCUDA_Memory<SectTT> xx_pairs_debug;
  int xx_pairs_count;
  pCUDA_Memory<float4> xx_sects_center; // Box/Box Intersections
  pCUDA_Memory<float4> xx_sects_dir; // Box/Box Intersections
  pCUDA_Memory<float4> xx_sects_debug; // Box/Box Intersections

  pCUDA_Memory<float3> pass_sched_debug;

  // Number of pairs that CPU checks for proximity.
  int prox_test_per_ball;
  int prox_test_per_ball_prev;  // A copy of above.

  // Number of balls for which CUDA could not compute proximity.
  int cuda_prox_full, cuda_prox_full_prev;

  int timer_id_cuda_prox;
  int ball_cnt_sched;
};

#endif
