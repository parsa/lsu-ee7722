/// LSU EE 4702
//
 /// CUDA Demo 04
 //
 //  This code demonstrates different methods of all-to-all access in
 //  CUDA. such as the accesses to array in the code below:
 //
 //  for ( int i=0; i<n; i++ ) for ( j=0; j<n; j++ ) sum ++ array[i] * array[j];
 //
 //  See routines time_step_intersect_1 and time_step_intersect_2 in
 //  demo-cuda-04-acc-pat-cuda.cu. Instead of array, this code
 //  accesses helix_position.


 ///  Note: Requires OpenGL 4.5 and CUDA

///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push end of spring, depending on mode:
 //   'e': Move eye.
 //   'b': Grab top (last segment of) of spring.
 //   'l': Move light.
 //   'B': Release top (last segment of) spring.
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
 //  'a'    Switch between CPU and GPU physics.
 //  'i'    Cycle three methods of interpenetration handling:
 //           GPU Physics Mode: None, GPU-Prob-1, GPU-Prob-2.
 //           CPU Physics Mode: None, CPU, CPU (last two equivalent).
 //  's'    Toggle alternative use of shared memory.

 //  'b'    Grab free end (last segment) of spring. Once grabbed, can
 //         be controlled with arrow keys (see above).
 //  'B'    Release spring.
 //  'p'    Pause simulation.
 //  'g'    Toggle gravity on and off.
 //  'y'    Toggle state of Boolean opt_tryout1, use it as you like.
 //  'Y'    Toggle state of Boolean opt_tryout2, use it as you like.

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
 //  -- Documented Variables --
 //
 //     Spring Constant (opt_spring_constant)
 //       Spring constant used for the spring.
 //       Higher values makes the spring tighter, but at some maximum
 //       the simulation will become unstable.
 //
 //     Seg / Block (interp_seg_per_block)
 //       The number of segments per CUDA block that the interpenetration
 //       routine will use.



#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#define GL_GLEXT_LEGACY
#include <GL/gl.h>
#include <GL/glext.h>

#include <GL/glu.h>
#include <GL/freeglut.h>

// Include files provided for this course.
//
#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include "shapes.h"
#include <gp/colors.h>

#include <gp/cuda-util.h>

#include "demo-cuda-04-acc-pat.cuh"

// Define storage buffer binding indices and attribute locations.
//
#define UNIF_IDX_BULDGE_LOC 0
#define UNIF_IDX_BULDGE_DIST_THRESH 1
#define UNIF_IDX_WIRE_RADIUS 2
#define ATTR_IDX_HELIX_INDICES 1
#define SB_COORD 1
#define SB_U 2
#define SB_V 3


enum GPU_Physics_Method { GP_cpu, GP_cuda_1, GP_cuda_2, GP_ENUM_SIZE };
const char* const gpu_physics_method_str[] = { "CPU", "CUDA-M1", "CUDA-M2" };

struct Wire_Segment {
  pCoor position;
  pQuat orientation;

  pVect velocity;
  pVect omega;

  pVect ctr_to_right_dir;
  pVect u, v;
  pVect nu, nv, nw;
  pCoor pos_left, pos_right;

  pVect force;
  pVect torque;

};



class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->frame_callback(); }
  void frame_callback();
  void physics_advance();
  void render();
  void cb_keyboard();
  void modelview_update();

  // Class providing utilities, such as showing text.
  //
  pOpenGL_Helper& ogl_helper;

  // Class for easy keyboard control of variables.
  //
  pVariable_Control variable_control;

  // Class for showing frame timing.
  //
  pFrame_Timer frame_timer;

  pCoor light_location;
  float opt_light_intensity;

  pCoor helix_location;
  Wire_Segment *helix_end_ws;  // Last (end) segment of helix.
  bool opt_end_fixed;   // If true position of "end" of helix is fixed in space.
  float helix_radius;   // Radius of helix.
  float wire_radius;    // Radius of wire forming helix.
  int seg_per_helix_revolution;
  int seg_per_wire_revolution;
  int revolutions_per_helix;  // Number of times helix wraps around.

  bool coords_stale;
  bool buffer_objects_stale;

  PStack<int> helix_indices;
  GLuint helix_indices_bo;

  // Coordinates of helix. (Helix runs through center of wire.)
  //
  PStack<pCoor> helix_coords;
  GLuint helix_coords_bo;
  int helix_coords_size;

  pCoor *helix_u, *helix_v;
  GLuint helix_u_bo;
  GLuint helix_v_bo;

  PStack<int> wire_surface_indices;
  GLuint wire_surface_indices_bo;
  int wire_surface_indices_size;

  int helix_indices_size;

  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_geo_shade;

  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  GLuint texture_id_syllabus;

  // Physics
  double world_time, last_frame_wall_time;
  float delta_t;
  bool opt_pause;
  bool opt_single_frame;      // Simulate for one frame.
  bool opt_single_time_step;  // Simulate for one time step.

  PStack<Wire_Segment> wire_segments;

  pVect gravity_accel;
  pQuat helix_rn_trans;
  float helix_seg_hlength;
  float helix_seg_hlength_inv;
  float opt_spring_constant;
  float opt_helix_density;
  bool opt_gravity;
  int opt_use_shared;
  bool opt_test;
  bool opt_tryout1, opt_tryout2;
  float helix_seg_mass;
  float helix_seg_mass_inv;
  float helix_seg_ma_axis;
  float helix_seg_ma_perp_axis;
  void helix_apply_force_at
  (Wire_Segment *ws, pCoor pos, pVect dir, float magnitude);
  pVect helix_get_vel_at(Wire_Segment *ws, pCoor pos);

  float helix_spring_energy;

  void time_step_cpu();

  // CUDA Physics

  int opt_physics_method;
  bool cuda_initialized;
  bool cuda_constants_stale;
  cudaEvent_t frame_start_ce, frame_stop_ce;
  cudaEvent_t interp_start_ce, interp_stop_ce;
  int block_size_max;
  int interp_seg_per_block;
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  GPU_Info gpu_info;
  int cuda_time_step_count;
  int64_t time_inter_cyc;

  int inter_block_size, inter_nblocks;
  int inter_dynamic_sm_size_bytes;

  pCUDA_Memory<pCoor> helix_position;
  pCUDA_Memory<pVect> helix_velocity;
  pCUDA_Memory<pQuat> helix_orientation;
  pCUDA_Memory<pVect> helix_omega;

  void cuda_init();
};

void
World::init()
{
  coords_stale = true;

  seg_per_helix_revolution = 80;
  seg_per_wire_revolution = 20;
  revolutions_per_helix = 8;

  const int num_seg = revolutions_per_helix * seg_per_helix_revolution;

  opt_spring_constant = num_seg / 640.0 * 900000;
  gravity_accel = pVect(0,-.98,0);
  opt_helix_density = 1;

  //  variable_control.insert(seg_per_helix_revolution,"Seg Per Helix Rev");
  //  variable_control.insert(seg_per_wire_revolution,"Seg Per Wire Rev");

  buffer_objects_stale = true;
  helix_coords_bo = 0;
  wire_surface_indices_bo = 0;

  eye_location = pCoor(-1.8,6.9,23.4);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 1.5;
  light_location = pCoor(12.2,4.0,6.9);

  opt_end_fixed = false;
  helix_location = pCoor(0,0,-5);
  helix_radius = 5;
  wire_radius = 0.6;
  variable_control.insert(wire_radius,"Wire Radius");

  //  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;

  texture_id_syllabus = pBuild_Texture_File("gpup.png",false,255);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  const char* const file = "demo-cuda-04-acc-pat-shdr.cc";

  sp_geo_shade = new pShader
    (file,           // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "gs_main_helix();",
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  modelview_update();

  frame_timer.work_unit_set("Steps / s");
  opt_physics_method = GP_cuda_1;


  helix_u = helix_v = NULL;

  variable_control.insert(opt_spring_constant,"Spring Constant");

  delta_t = 1.0 / ( 30 * 200 );
  opt_pause = false;
  opt_single_time_step = false;
  opt_single_frame = false;

  world_time = 0;
  last_frame_wall_time = time_wall_fp();
  opt_gravity = true;
  opt_use_shared = false;
  opt_test = false;
  opt_tryout1 = false;
  opt_tryout2 = false;

  interp_seg_per_block = 32;
  variable_control.insert_power_of_2
    (interp_seg_per_block,"Seg / Block",1,64);

  variable_control.insert_power_of_2
    (inter_block_size, "Interp Block Size", 32, 1024);
  cuda_init();
}

void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}

void
World::frame_callback()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  physics_advance();

  render();
}

void
World::physics_advance()
{
  if ( wire_segments.occ() == 0 ) return;

  // Run the physical simulation if not paused.
  //
  frame_timer.phys_start();
  const double time_now = time_wall_fp();

  // Update data on GPU if necessary.
  //
  if ( cuda_constants_stale )
    {
      cuda_constants_stale = false;
      const int phys_helix_segments = wire_segments.occ();

      // Allocate storage and write GPU variables with addresses of storage.
      //
      helix_position.realloc(phys_helix_segments);
      helix_position.ptrs_to_cuda("helix_position");
      helix_velocity.realloc(phys_helix_segments);
      helix_velocity.ptrs_to_cuda("helix_velocity");
      helix_omega.realloc(phys_helix_segments);
      helix_omega.ptrs_to_cuda("helix_omega");
      helix_orientation.realloc(phys_helix_segments);
      helix_orientation.ptrs_to_cuda("helix_orientation");

      // Copy data from our CPU-friendly wire_segments array of
      // structures to GPU-friendly individual arrays. Note that this
      // loop copies data from one part of CPU memory to
      // another. Since the ultimate destination this extra CPU->CPU
      // copying is wasteful, but that's acceptable because it only
      // needs to be done rarely, at start up and when the user
      // changes a variable.
      //
#pragma omp parallel for
      for ( int i=0; i<phys_helix_segments; i++ )
        {
          Wire_Segment* const ws = &wire_segments[i];
          helix_position[i] = ws->position;
          helix_velocity[i] = ws->velocity;
          helix_orientation[i] = ws->orientation;
          helix_omega[i] = ws->omega;
        }

      // Copy data from CPU to GPU.
      //
      helix_position.to_cuda();
      helix_velocity.to_cuda();
      helix_orientation.to_cuda();
      helix_omega.to_cuda();

      // Write scalar variables to a structure, and then
      // send structure to GPU.
      //
      Helix_Info hi;
      const float delta_t_mass_inv = delta_t * helix_seg_mass_inv;
      const float delta_t_ma_axis = delta_t / helix_seg_ma_axis;
      const float delta_t_ma_perp_axis = delta_t / helix_seg_ma_perp_axis;

#define SET(m) hi.m = m;
      SET(opt_gravity);
      SET(opt_tryout1);
      SET(opt_tryout2);
      SET(opt_end_fixed);
      SET(opt_use_shared);
      SET(opt_spring_constant);
      SET(delta_t);
      SET(delta_t_mass_inv);
      SET(delta_t_ma_axis);
      SET(delta_t_ma_perp_axis);
      SET(phys_helix_segments);
      SET(wire_radius);
      SET(helix_seg_hlength);
      SET(helix_seg_mass_inv);
      SET(gravity_accel);
      SET(helix_rn_trans);
#undef SET
      TO_DEV(hi);

      Timing_Data timing_data;
      timing_data.inter_time = 0;
      timing_data.inter_count = 0;
      TO_DEV(timing_data);
    }


  if ( !opt_pause || opt_single_frame || opt_single_time_step )
    {
      const int phys_helix_segments = wire_segments.occ();

      // Use a small block size under the assumption that
      // phys_helix_segments is small.
      const int block_size = 128;  // Not for intersection code.
      const int grid_size =
        ( phys_helix_segments + block_size - 1 ) / block_size;

      if ( opt_physics_method != GP_cpu )
        CE(cudaEventRecord(frame_start_ce,0));

      // Evolve simulated state in time steps of duration delta_t until
      // simulated time reaches current time.
      //

      // Amount of time since the user saw the last frame.
      //
      const double wall_delta_t = time_now - last_frame_wall_time;

      // Compute amount by which to advance simulation state for this frame.
      //
      const double duration =
        opt_single_time_step ? delta_t :
        opt_single_frame || ogl_helper.animation_record
        ? ogl_helper.frame_period :
        wall_delta_t;

      const double wall_time_deadline =
        time_wall_fp() + ogl_helper.frame_period;

      const double world_time_target = world_time + duration;
      int iter_count = 0;

      inter_nblocks = phys_helix_segments/interp_seg_per_block;
      const int thd_per_a = inter_block_size / interp_seg_per_block;
      inter_dynamic_sm_size_bytes =
        inter_block_size * sizeof(pVect) +
        ( opt_use_shared ? thd_per_a * sizeof(pVect) : 0 );

      while ( world_time < world_time_target )
        {
          iter_count++;
          if ( opt_physics_method != GP_cpu )
            {
              cuda_time_step_count++;
              time_step_launch(grid_size,block_size);
              time_step_intersect_launch
                (inter_nblocks, inter_block_size,
                 opt_physics_method, inter_dynamic_sm_size_bytes);
              time_step_update_pos_launch(grid_size,block_size);
            }
          else
            time_step_cpu();
          world_time += delta_t;
          if ( time_wall_fp() > wall_time_deadline ) break;
        }

      frame_timer.work_amt_set(iter_count);

      // Reset these, just in case they were set.
      //
      opt_single_frame = opt_single_time_step = false;

      if ( opt_physics_method != GP_cpu )
        {
          // Collect amount of time CUDA took to compute this frame.
          //

          Timing_Data timing_data;
          FROM_DEV(timing_data);
          time_inter_cyc =
            timing_data.inter_time / max(1,timing_data.inter_count);

          CE(cudaEventRecord(frame_stop_ce,0));
          CE(cudaEventSynchronize(frame_stop_ce));
          float cuda_time = -1.1;
          CE(cudaEventElapsedTime(&cuda_time,frame_start_ce,frame_stop_ce));
          frame_timer.cuda_frame_time_set(cuda_time);

          // Copy data back to CPU. Some or all of this copying can be
          // eliminated. As things are currently written, there is no
          // need to copy back the velocity and orientation unless
          // simulation is switching to CPU physics. If the same GPU
          // were used for physics and graphics, there would also be
          // no need to copy back the position and orientation. (A
          // CUDA global memory can be mapped to an OpenGL buffer
          // object.)
          //
          helix_position.from_cuda();
          helix_velocity.from_cuda();
          helix_orientation.from_cuda();
          helix_omega.from_cuda();
#pragma omp parallel for
          for ( int i=0; i<phys_helix_segments; i++ )
            {
              Wire_Segment* const ws = &wire_segments[i];
              ws->position = helix_position[i];
              ws->velocity = helix_velocity[i];
              ws->orientation = helix_orientation[i];
              ws->omega = helix_omega[i];
            }
        }

      frame_timer.phys_end();

      // Compute vectors used for drawing wire, and copy helix coordinate.
      //
#pragma omp parallel for
      for ( int i=0; i<phys_helix_segments; i++ )
        {
          Wire_Segment* const ws = &wire_segments[i];

          // Copy helix coordinates to another array before sending
          // back to GPU. This step could easily be eliminated since
          // the coordinates are already linearized in helix_position.
          //
          helix_coords[i] = ws->position;

          // Compute vectors used for drawing wire.
          //
          pMatrix_Rotation c_rot(ws->orientation);
          helix_u[i] = c_rot.cv(2);
          helix_v[i] = c_rot.cv(1);
        }

      // Send data back to GPU.

      glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*4*sizeof(helix_coords[0]),
         helix_coords.get_storage(), GL_STATIC_DRAW);
      glBindBuffer(GL_ARRAY_BUFFER, helix_u_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*sizeof(helix_u[0]),
         helix_u, GL_STATIC_DRAW);
      glBindBuffer(GL_ARRAY_BUFFER, helix_v_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*sizeof(helix_v[0]),
         helix_v, GL_STATIC_DRAW);
    }

  last_frame_wall_time = time_now;

  frame_timer.phys_end();
}

void
World::render()
{
  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

  glClearColor(0,0,0,0);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  glShadeModel(GL_SMOOTH);

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  if ( opt_physics_method != GP_cpu )
    {
      const int bl_p_sm_max =
        gpu_info.get_max_active_blocks_per_mp
        (opt_physics_method,inter_block_size,inter_dynamic_sm_size_bytes);
      const int wp_p_bl = ( inter_block_size + 31 ) >> 5;
      const double bl_p_sm_avail =
        double(inter_nblocks) / gpu_info.cuda_prop.multiProcessorCount;

      const double bl_p_sm = min( bl_p_sm_max + 0.0, bl_p_sm_avail );

      ogl_helper.fbprintf
        ("Interp routine: Bl Sz %3d  N Blocks %4d  Bl/SM %2d %4.1f   "
         "Wp/SM %4.1f   Bl Time %ld cyc\n",
         inter_block_size, inter_nblocks,
         bl_p_sm_max, bl_p_sm, bl_p_sm * wp_p_bl,
         time_inter_cyc);
    }

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]  "
     "Helix Location[%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z,
     helix_location.x, helix_location.y, helix_location.z
     );

  if ( !sp_geo_shade->pobject )
    ogl_helper.fbprintf
      ("Programmable GPU API: %savailable.  GPU Code: %s\n",
       ptr_glCreateShader ? "" : "not",
       sp_geo_shade->pobject ? "okay" : "problem");

  const bool blink_visible = int64_t(time_wall_fp()*3) & 1;
# define BLINK(txt,pad) ( blink_visible ? txt : pad )

  ogl_helper.fbprintf
    ("Physics: %7s ('a')  Pause: %s ('p')  Gravity: %s ('g')  Grabbed: %s ('%s')  Shared Mem: %d ('s')  Tryouts: %d %d ('y' 'Y')\n",
     opt_physics_method == GP_cpu
     ? BLINK(gpu_physics_method_str[opt_physics_method],"")
     : gpu_physics_method_str[opt_physics_method],
     opt_pause ? BLINK("ON","  ") : "OFF",
     opt_gravity ? "ON" : "OFF",
     opt_end_fixed ? "YES" : "NO",
     opt_end_fixed ? "B" : "b",
     opt_use_shared,
     opt_tryout1,
     opt_tryout2);

  //  ogl_helper.fbprintf("Spring Energy: %f\n", helix_spring_energy);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  glEnable(GL_LIGHTING);

  const pColor white(1,1,1);
  const pColor red(1,0,0);
  const pColor blue(0,0,1);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);

  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);

  // Set lighting parameters for when shader is not used, as for the
  // big triangle.
  //
  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);

  pError_Check();

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Set parameter for texture unit.
  //
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  sp_fixed->use();

  ///
  /// Paint Single Triangle.
  ///

  pColor color_tri(0x7815b6); // Red, Green, Blue
  glColor3fv( color_tri );

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  // Specify vertices for a triangle.
  //

  pCoor p1( 9.5, -5, -1.2 );
  pCoor p2( 0,    5, -3 );
  pCoor p3( 9,    6, -7 );
  pNorm triangle_normal = cross(p3,p2,p1);

  // Specify normal and vertex using course-defined objects pCoor and
  // pNorm. OpenGL sees these as pointers to floats.

  glNormal3fv(triangle_normal);
  glTexCoord2f(0.95,1.0); glVertex3fv(p1);
  glTexCoord2f(0.00,0.1); glVertex3fv(p2);
  glTexCoord2f(0.90,0.0); glVertex3fv(p3);

  glEnd();

  glDisable(GL_TEXTURE_2D);


  ///
  /// Construct a Helix
  ///

  if ( coords_stale )
    {
      // Recompute helix coordinates, etc.

      coords_stale = false;
      cuda_constants_stale = true;
      buffer_objects_stale = true;

      // Reset existing storage.
      helix_coords.reset();
      helix_indices.reset();
      wire_surface_indices.reset();
      wire_segments.reset();

      const int segments_per_helix =
        revolutions_per_helix * seg_per_helix_revolution;

      const double delta_eta = 2 * M_PI / seg_per_helix_revolution;
      const double delta_y = 4 * wire_radius / seg_per_helix_revolution;

      int wire_surface_idx = 0;
      pVect vZero(0,0,0);

      const float helix_seg_hlength_xy = helix_radius * tan(0.5 * delta_eta);
      helix_seg_hlength =
        sqrtf( helix_seg_hlength_xy * helix_seg_hlength_xy
               + 0.25 * delta_y * delta_y );

      const float angle_seg = asinf(delta_y /( 2 * helix_seg_hlength ));
      helix_seg_hlength_inv = 1 / helix_seg_hlength;

      pQuat tilt_up_seg(pVect(0,0,1),angle_seg);
      pQuat tilt_up_inv(pVect(0,0,1),-angle_seg);

      pQuat rot(pVect(0,-1,0),delta_eta);

      // Compute the transform to segment's right neighbor's coordinate space.
      helix_rn_trans = tilt_up_inv * rot * tilt_up_seg;

      const float wire_rad_sq = wire_radius * wire_radius;

      // Compute mass.
      helix_seg_mass =
        opt_helix_density * M_PI * wire_rad_sq * 2 * helix_seg_hlength;
      helix_seg_mass_inv = 1 / helix_seg_mass;

      // Compute moments of inertia.
      helix_seg_ma_axis = helix_seg_mass * wire_rad_sq / 2;
      helix_seg_ma_perp_axis = helix_seg_mass *
        ( 4 * helix_seg_hlength * helix_seg_hlength + 3 * wire_rad_sq ) / 12;

      for ( int i = 0; i < segments_per_helix; i++ )
        {
          const bool last_i_iteration = i + 1 == segments_per_helix;

          const double eta = i * delta_eta;

          // Point on core.
          pCoor p0( helix_radius * cos(eta),
                    i * delta_y,
                    helix_radius * sin(eta));

          helix_coords += p0;

          // Initialize a helix (wire) segment, used for physical simulation.
          //
          Wire_Segment* const ws = wire_segments.pushi();
          ws->position = p0;
          ws->velocity = vZero;
          ws->omega = vZero;     // Rotation rate.

          // Rotate cylinder coordinates to world coordinates.
          pQuat rot(pVect(0,-1,0),eta + M_PI / 2);
          ws->orientation = rot * tilt_up_seg;

          for ( int j = 0; j < seg_per_wire_revolution; j++ )
            {
              const int idx = wire_surface_idx++;
              helix_indices += i;  helix_indices += j;
              if ( last_i_iteration ) continue;
              // Insert indices for triangle with one vertex on eta.
              wire_surface_indices += idx; // This vertex.
              wire_surface_indices += idx + seg_per_wire_revolution;
            }
        }

      wire_surface_indices_size = wire_surface_indices.occ();
      helix_coords_size = helix_coords.occ();
      helix_indices_size = helix_indices.occ();
      helix_end_ws = &wire_segments.peek();
    }

  // If necessary, update data in buffer objects.
  if ( buffer_objects_stale )
    {
      buffer_objects_stale = false;

      // Generate buffer id (name), if necessary.
      //
      glGenBuffers(1,&helix_indices_bo);
      glGenBuffers(1,&helix_coords_bo);
      glGenBuffers(1,&helix_u_bo);
      glGenBuffers(1,&helix_v_bo);
      glGenBuffers(1,&wire_surface_indices_bo);

      if ( helix_u ) { free(helix_u); free(helix_v); }
      helix_u = (pCoor*) malloc( helix_coords_size * sizeof(helix_u[0]) );
      helix_v = (pCoor*) malloc( helix_coords_size * sizeof(helix_v[0]) );

      glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*4*sizeof(helix_coords[0]),
         helix_coords.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         2 * helix_indices_size * sizeof(helix_indices[0]),
         helix_indices.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, wire_surface_indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         wire_surface_indices_size*sizeof(wire_surface_indices[0]),
         wire_surface_indices.get_storage(),GL_STATIC_DRAW);

      // Tell GL that subsequent array pointers refer to host storage.
      //
      glBindBuffer(GL_ARRAY_BUFFER, 0);

      pError_Check();
    }

  sp_geo_shade->use();

  ///
  /// Paint a Helix
  ///

  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_COORD,helix_coords_bo);
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_U,helix_u_bo);
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_V,helix_v_bo);

  glUniform1f(UNIF_IDX_WIRE_RADIUS,wire_radius);  GE();

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  glTranslatef(helix_location.x,helix_location.y,helix_location.z);
  glRotatef(60,0,1,0);

  // Specify color. Since it's not an array the same color
  // will be used for all vertices, which is what we want.
  //
  glUniform4fv(4,1,lsu_spirit_gold);
  glUniform4fv(5,1,color_red);

  glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
  glEnableVertexAttribArray(ATTR_IDX_HELIX_INDICES);
  glVertexAttribIPointer
    (ATTR_IDX_HELIX_INDICES,
     2, // Two components (as in a 2-element vector).
     GL_INT,
     0, // Tightly packed.
     0);

  glBindBuffer(GL_ARRAY_BUFFER, 0); // Avoid surprises.

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, wire_surface_indices_bo);

  glDrawElements
    (GL_TRIANGLE_STRIP,
     wire_surface_indices_size - 4 * seg_per_wire_revolution,
     GL_UNSIGNED_INT,
     (const GLvoid*) ( 2 * seg_per_wire_revolution * sizeof(GL_UNSIGNED_INT)));

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

  glDisableVertexAttribArray(ATTR_IDX_HELIX_INDICES);

  glPopMatrix();

  sp_fixed->use();

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  frame_timer.frame_end();

  ogl_helper.user_text_reprint();
  glutSwapBuffers();
}

void
World::time_step_cpu()
{
  pVect vZero(0,0,0);
  pVect gravity_force = helix_seg_mass_inv * gravity_accel;
  helix_spring_energy = 0;

  const int phys_helix_segments = wire_segments.occ();

  /// Initialize wire segment variables for time step.
  //
#pragma omp parallel for
  for ( int i=0; i<phys_helix_segments; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];
      pMatrix_Rotation c_rot(cseg->orientation);

      // Compute world-space vectors of segments local coordinate space.
      cseg->u = c_rot.cv(2);
      cseg->v = c_rot.cv(1);
      cseg->ctr_to_right_dir = c_rot.cv(0);
      pQuat cn_rot_q = cseg->orientation * helix_rn_trans;
      pMatrix_Rotation cn_rot(cn_rot_q);
      cseg->nu = cn_rot.cv(2);
      cseg->nv = cn_rot.cv(1);

      pVect ctr_to_right = helix_seg_hlength * cseg->ctr_to_right_dir;

      // Compute location of ends of cylinder.
      cseg->pos_left = cseg->position - ctr_to_right;
      cseg->pos_right = cseg->position + ctr_to_right;

      cseg->force = opt_gravity ? gravity_force : vZero;
      cseg->torque = vZero;
    }

  /// Apply forces due to helix segment to the "right" (+x in local space).
  //
  for ( int i=0; i<phys_helix_segments-1; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];    // Us
      Wire_Segment* const rseg = &wire_segments[i+1];  // Our right neighbor.

      // Find distance between us and right neighbor at three points
      // on cylinder surface.  We hope that the compiler unrolls this
      // loop to avoid computing sin and cos every time.
      const int pieces = 3;
      const float delta_theta = 2 * M_PI / pieces;
      for ( int j=0; j<pieces; j++ )
        {
          const float theta = delta_theta * j;
          pCoor c_pt =
            cseg->pos_right + cseg->nu * cosf(theta) + cseg->nv * sinf(theta);
          pCoor r_pt =
            rseg->pos_left + rseg->u * cosf(theta) + rseg->v * sinf(theta);
          pNorm dist(c_pt,r_pt);
          const float force_mag = dist.magnitude * opt_spring_constant;
          pCoor mid_pt = 0.5 * ( c_pt + r_pt );
          helix_apply_force_at(cseg,mid_pt,dist,force_mag);
          helix_apply_force_at(rseg,mid_pt,dist,-force_mag);
        }
    }

  const float delta_t_mass_inv = delta_t * helix_seg_mass_inv;
  const float delta_t_ma_axis = delta_t / helix_seg_ma_axis;
  const float delta_t_ma_perp_axis = delta_t / helix_seg_ma_perp_axis;


  /// Quick and Dirty and Slow Interpenetration Routine
  //
  {
    // Rule out interpenetration between segments that are closer
    // together than MIN_IDX_DIST. In other words, assume that
    // segment 14 and segment 15 cannot interpenetrate each other
    // (but of course they are in contact in a normal way).
    //
    const int min_idx_dist = 0.999 + wire_radius / helix_seg_hlength;

    const float four_wire_radius_sq = 4 * wire_radius * wire_radius;

    // Use a brute force, O(n^2), search of all possible pairs of
    // segments.
    //
    for ( int i=1; i<phys_helix_segments; i++ )
      for ( int j=i+min_idx_dist; j<phys_helix_segments; j++ )
        {
          Wire_Segment* const aseg = &wire_segments[i];
          Wire_Segment* const bseg = &wire_segments[j];
          pNorm dist(aseg->position,bseg->position);

          // Use a bounding sphere to quickly rule out contact.
          //
          if ( dist.mag_sq > four_wire_radius_sq ) continue;

          // As a crude approximation, compute depth of
          // interpenetration using bounding sphere.  Better results
          // would be obtained with a cylinder/cylinder intersection
          // computation.
          //
          const float pen_depth = 2 * wire_radius - dist.magnitude;
          pVect sep_force = pen_depth * opt_spring_constant * dist;
          aseg->force -= sep_force;
          bseg->force += sep_force;
        }
  }

  /// Using force and torque, update velocity, omega, position, and orientation.
  //
  for ( int i=1; i<phys_helix_segments; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];
      cseg->velocity *= 0.9999;
      cseg->omega *= 0.9999;
      cseg->velocity += delta_t_mass_inv * cseg->force;
      if ( opt_end_fixed && i + 1 == phys_helix_segments )
        cseg->velocity = vZero;
      cseg->position += delta_t * cseg->velocity;
      const float torque_axial_mag =
        dot( cseg->torque, cseg->ctr_to_right_dir );
      pVect torque_axial = torque_axial_mag * cseg->ctr_to_right_dir;
      pVect do_axial = delta_t_ma_axis * torque_axial;
      pVect torque_other = cseg->torque - torque_axial;
      pVect do_other = delta_t_ma_perp_axis * torque_other;
      cseg->omega += do_axial + do_other;
      pNorm axis(cseg->omega);
      cseg->orientation =
        pQuat(axis,delta_t * axis.magnitude) * cseg->orientation;
    }
}


void
World::helix_apply_force_at
(Wire_Segment *s, pCoor pos, pVect dir, float magnitude)
{
  s->force += magnitude * dir;
  helix_spring_energy += fabs(magnitude);
  pVect arm(s->position,pos);
  pVect axis = cross( arm, dir );
  pVect amt = magnitude * axis;
  helix_spring_energy += amt.mag();
  s->torque += amt;
}

pVect
World::helix_get_vel_at(Wire_Segment *s, pCoor pos)
{
  pVect arm(s->position,pos);
  pVect vel_rot = cross( s->omega, arm );
  return vel_rot + s->velocity;
}

//
// Collect GPU and Kernel Info
//

void
World::cuda_init()
{
  cuda_constants_stale = true;
  cuda_time_step_count = 0;

  inter_block_size = 256; // Will be automatically updated.
  inter_nblocks = 1;  // Will be automatically updated.

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  if ( device_count == 0 )
    {
      fprintf(stderr,"No GPU found, exiting.\n");
      exit(1);
    }

  // Print information about the available GPUs.
  //
  gpu_info_print();

  // Choose GPU 0 because we don't have time to provide a way to let
  // the user choose.
  //
  int dev = gpu_choose_index();
  CE(cudaSetDevice(dev));
  printf("Using GPU %d\n",dev);

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&frame_start_ce));
  CE(cudaEventCreate(&frame_stop_ce));

  gpu_info.get_gpu_info(dev);
  cuda_setup(&gpu_info);

  // Print information about time_step routine.
  //
  printf("\nCUDA Routine Resource Usage:\n");

  for ( int i=0; i<gpu_info.num_kernels; i++ )
    {
      printf("For %s:\n", gpu_info.ki[i].name);
      printf("  %6zd shared, %zd const, %zd loc, %d regs; "
             "%d max threads per block.\n",
             gpu_info.ki[i].cfa.sharedSizeBytes,
             gpu_info.ki[i].cfa.constSizeBytes,
             gpu_info.ki[i].cfa.localSizeBytes,
             gpu_info.ki[i].cfa.numRegs,
             gpu_info.ki[i].cfa.maxThreadsPerBlock);
    }

}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const bool shift = ogl_helper.keyboard_shift;
  const float move_amt = shift ? 2.0 : 0.4;

  const float wire_radius_prev = wire_radius;
  const float helix_radius_prev = helix_radius;

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

  case 'a':
    opt_physics_method++;
    if ( opt_physics_method >= GP_ENUM_SIZE ) opt_physics_method = GP_cpu;
    if ( opt_physics_method > GP_cpu ) cuda_constants_stale = true;
    break;

  case 'b':
    opt_end_fixed = true; opt_move_item = MI_Ball;
    cuda_constants_stale = true;
    break;
  case 'B':
    opt_end_fixed = false;
    cuda_constants_stale = true;
    break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;

  case 'g': case 'G': opt_gravity = !opt_gravity;
    cuda_constants_stale = true;
    break;

  case 's': case 'S': opt_use_shared = !opt_use_shared;
    cuda_constants_stale = true;
    break;

  case 'p': case 'P':
    opt_pause = !opt_pause;
    if ( !opt_pause ) world_time = time_wall_fp();
    break;

  case 'y': opt_tryout1 = !opt_tryout1; break;
  case 'Y': opt_tryout2 = !opt_tryout2; break;


  case ' ':
    if ( shift ) opt_single_time_step = true; else opt_single_frame = true;
    opt_pause = true;
    break;

  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower();
    cuda_constants_stale = true;
    break;
  case '+':case '=': variable_control.adjust_higher();
    cuda_constants_stale = true;
    break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  if ( wire_radius_prev != wire_radius || helix_radius_prev != helix_radius )
    coords_stale = true;

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
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      case MI_Ball:
        cuda_constants_stale = true;
        if ( opt_end_fixed )
          helix_end_ws->position += adjustment;
        else
          helix_location += adjustment;
        break;
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

  // Specify default frame update rate.
  //
  // Default rate used if API won't allow updating on each
  // display device frame.
  //
  popengl_helper.rate_set(30);

  // Start
  //
  popengl_helper.display_cb_set(world.render_w,&world);
}
