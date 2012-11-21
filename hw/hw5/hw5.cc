/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

 /// Homework 5
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gpup/2012/hw05.pdf
 //
 /// Your Name:

 ///  Note: Requires OpenGL 4.3

///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
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
 //  's'    Switch between different shaders in forward direction.
 //  'S'    Switch between different shaders in reverse direction.
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
 //     Segs Per Helix Rev
 //     - The number of segments in one revolution of helix.
 //       A smaller number means fewer primitives.
 //
 //     Segs Per Wire Rev
 //     - The number of segments in 1 revolution around wire.
 //       A smaller number means fewer primitives.
 //
 //     Light Intensity
 //     - The light intensity.
 //



#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#define GL_GLEXT_LEGACY
#include <GL/gl.h>
#include <GL/glx.h>
#include <GL/glext.h>
#include <GL/glxext.h>

// NVIDIA has not yet updated their include files. :-(
#ifndef GL_ARB_shader_storage_buffer_object
#define GL_SHADER_STORAGE_BUFFER          0x90D2
#endif

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

#include <gp/cuda-util.h>

#include "hw5.cuh"

// Define storage buffer binding indices and attribute locations.
//
#define UNIF_IDX_BULDGE_LOC 0
#define UNIF_IDX_BULDGE_DIST_THRESH 1
#define UNIF_IDX_WIRE_RADIUS 2
#define ATTR_IDX_HELIX_INDICES 1
#define SB_COORD 1
#define SB_U 2
#define SB_V 3


enum Shader_Program
  { SP_Fixed, SP_Geo_Shade1, SP_Geo_Shade2, SP_ENUM_SIZE };
const char* const shader_program[] =
  { "SP_Fixed", "SP_Geo_Shade1", "SP_Geo_Shade2", "SP_ENUM_SIZE" };
enum GPU_Physics_Method { GP_cpu, GP_cuda, GP_ENUM_SIZE };
const char* const gpu_physics_method_str[] = { "CPU", "CUDA" };

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
  static void render_w(void *moi){ ((World*)moi)->render(); }
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
  float helix_radius;   // Radius of helix.
  float wire_radius;    // Radius of wire forming helix.
  int seg_per_helix_revolution;
  int seg_per_wire_revolution;

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

  int opt_shader;

  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_geo_shade;

  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  GLuint texture_id_syllabus;

  // Physics
  double world_time;
  float delta_t;
  bool opt_pause;

  PStack<Wire_Segment> wire_segments;

  pVect gravity_accel;
  pQuat helix_rn_trans;
  float helix_seg_hlength;
  float helix_seg_hlength_inv;
  float opt_spring_constant;
  float opt_helix_density;
  bool opt_gravity;
  bool opt_interpen;
  bool opt_test;
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
  int block_size_max;
  cudaDeviceProp cuda_prop;  // Properties of cuda device (GPU, cuda version).
  cudaFuncAttributes cfa_helix; // Properties of code to run on device.

  pCUDA_Memory<pVect> helix_position;
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
  //  variable_control.insert(seg_per_helix_revolution,"Seg Per Helix Rev");
  //  variable_control.insert(seg_per_wire_revolution,"Seg Per Wire Rev");

  buffer_objects_stale = true;
  helix_coords_bo = 0;
  wire_surface_indices_bo = 0;

  eye_location = pCoor(-1.8,6.9,23.4);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 1.5;
  light_location = pCoor(12.2,4.0,6.9);

  helix_location = pCoor(0,0,-5);
  helix_radius = 5;
  wire_radius = 0.6;
  variable_control.insert(wire_radius,"Wire Radius");

  //  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;

  texture_id_syllabus = pBuild_Texture_File("hw05.png",false,255);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  const char* const file = "hw5-shdr.cc";

  sp_geo_shade = new pShader
    (file,           // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "gs_main_helix();",
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  opt_shader = SP_Geo_Shade1;

  modelview_update();

  opt_physics_method = GP_cpu;

  opt_spring_constant = 900000;
  gravity_accel = pVect(0,-.98,0);
  opt_helix_density = 1;
  helix_u = helix_v = NULL;

  variable_control.insert(opt_spring_constant,"Spring Constant");

  delta_t = 1.0 / ( 30 * 200 );
  opt_pause = false;
  world_time = time_wall_fp();
  opt_gravity = true;
  opt_interpen = false;
  opt_test = false;

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
World::render()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

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

  const double time_now = time_wall_fp();
  const bool blink_visible = int64_t(time_now*3) & 1;
# define BLINK(txt,pad) ( blink_visible ? txt : pad )

  ogl_helper.fbprintf
    ("Physics: %s ('a')  Pause: %s ('p')  Gravity: %s ('g')  Interpenetration: %s ('i')  Debug: %d ('t')\n",
     opt_physics_method != GP_cuda
     ? BLINK(gpu_physics_method_str[opt_physics_method],"      ")
     : gpu_physics_method_str[opt_physics_method],
     opt_pause ? BLINK("ON","  ") : "OFF",
     opt_gravity ? "ON" : "OFF",
     opt_interpen ? "ON" : BLINK("OFF","   "),
     opt_test);

  ogl_helper.fbprintf("Spring Energy: %f\n", helix_spring_energy);

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

      // Number of times helix wraps around.
      const int revolutions_per_helix = 8;

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

      const double angle_seg = asinf(delta_y /( 2 * helix_seg_hlength ));
      helix_seg_hlength_inv = 1 / helix_seg_hlength;

      pQuat tilt_up_seg(pVect(0,0,1),angle_seg);
      pQuat tilt_up_inv(pVect(0,0,1),-angle_seg);

      pQuat rot(pVect(0,-1,0),delta_eta);
      helix_rn_trans = tilt_up_inv * rot * tilt_up_seg;
      const float wire_rad_sq = wire_radius * wire_radius;
      helix_seg_mass =
        opt_helix_density * M_PI * wire_rad_sq * 2 * helix_seg_hlength;
      helix_seg_mass_inv = 1 / helix_seg_mass;
      helix_seg_ma_axis = helix_seg_mass * wire_rad_sq / 2;
      helix_seg_ma_perp_axis = helix_seg_mass *
        ( 4 * helix_seg_hlength * helix_seg_hlength + 3 * wire_rad_sq ) / 12;

      for ( int i = 0; i < segments_per_helix; i++ )
        {
          const bool last_i_iteration = i + 1 == segments_per_helix;

          const double eta = i * delta_eta;
          pCoor p0( helix_radius * cos(eta),
                    i * delta_y,
                    helix_radius * sin(eta));

          Wire_Segment* const ws = wire_segments.pushi();
          ws->position = p0;
          ws->velocity = vZero;
          ws->omega = vZero;
          pQuat rot(pVect(0,-1,0),eta + M_PI / 2);
          ws->orientation = rot * tilt_up_seg;

          helix_coords += p0;

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
    }

  if ( cuda_constants_stale )
    {
      cuda_constants_stale = false;
      const int phys_helix_segments = wire_segments.occ();

      helix_position.realloc(phys_helix_segments);
      helix_position.ptrs_to_cuda("helix_position");
      helix_velocity.realloc(phys_helix_segments);
      helix_velocity.ptrs_to_cuda("helix_velocity");
      helix_omega.realloc(phys_helix_segments);
      helix_omega.ptrs_to_cuda("helix_omega");
      helix_orientation.realloc(phys_helix_segments);
      helix_orientation.ptrs_to_cuda("helix_orientation");

      for ( int i=0; i<phys_helix_segments; i++ )
        {
          Wire_Segment* const ws = &wire_segments[i];
          helix_position[i] = pVect(ws->position);
          helix_velocity[i] = ws->velocity;
          helix_orientation[i] = ws->orientation;
          helix_omega[i] = ws->omega;
        }
      helix_position.to_cuda();
      helix_velocity.to_cuda();
      helix_orientation.to_cuda();
      helix_omega.to_cuda();

      Helix_Info hi;
      const float delta_t_mass_inv = delta_t * helix_seg_mass_inv;
      const float delta_t_ma_axis = delta_t / helix_seg_ma_axis;
      const float delta_t_ma_perp_axis = delta_t / helix_seg_ma_perp_axis;

#define SET(m) hi.m = m;
      SET(opt_gravity);
      SET(opt_test);
      SET(opt_interpen);
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

  if ( !opt_pause )
    {
      const int phys_helix_segments = wire_segments.occ();
      const double time_now = time_wall_fp();
      const int block_size = 32;
      const int grid_size =
        ( phys_helix_segments + block_size - 1 ) / block_size;

      if ( opt_physics_method == GP_cuda )
        CE(cudaEventRecord(frame_start_ce,0));

      for ( int iter_count = 0;
            world_time < time_now && iter_count < 1000;
            iter_count++ )
        {
          if ( opt_physics_method == GP_cuda )
            {
              time_step_launch(grid_size,block_size);
            }
          else
            time_step_cpu();
          world_time += delta_t;
        }

      if ( opt_physics_method == GP_cuda )
        {
          CE(cudaEventRecord(frame_stop_ce,0));
          CE(cudaEventSynchronize(frame_stop_ce));
          float cuda_time = -1.1;
          CE(cudaEventElapsedTime(&cuda_time,frame_start_ce,frame_stop_ce));
          frame_timer.cuda_frame_time_set(cuda_time);

          helix_position.from_cuda();
          helix_velocity.from_cuda();
          helix_orientation.from_cuda();
          helix_omega.from_cuda();
          for ( int i=0; i<phys_helix_segments; i++ )
            {
              Wire_Segment* const ws = &wire_segments[i];
              ws->position = helix_position[i];
              ws->velocity = helix_velocity[i];
              ws->orientation = helix_orientation[i];
              ws->omega = helix_omega[i];
            }
        }

      for ( int i=0; i<phys_helix_segments; i++ )
        {
          Wire_Segment* const ws = &wire_segments[i];
          helix_coords[i] = ws->position;
          pMatrix_Rotation c_rot(ws->orientation);
          helix_u[i] = c_rot * pVect(0,0,1);
          helix_v[i] = c_rot * pVect(0,1,0);
        }
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


  switch ( opt_shader ){
  case SP_Fixed: break;
  case SP_Geo_Shade1: sp_geo_shade->use(); break;
  default: ASSERTS( false );
  }

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
  // If we wanted to vary vertex colors we could have created
  // and used a color array.
  //
  glColor3fv(lsu_spirit_gold);

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

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableVertexAttribArray(ATTR_IDX_HELIX_INDICES);

  glPopMatrix();

  sp_fixed->use();

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  glDisable(GL_LIGHTING);
  glDisable(GL_DEPTH_TEST);
  frame_timer.frame_end();

  glutSwapBuffers();
}

void
World::time_step_cpu()
{
  pVect vZero(0,0,0);
  pVect gravity_force = helix_seg_mass_inv * gravity_accel;
  helix_spring_energy = 0;

  const int phys_helix_segments = wire_segments.occ();

  for ( int i=0; i<phys_helix_segments; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];
      pMatrix_Rotation c_rot(cseg->orientation);

      cseg->u = c_rot * pVect(0,0,1);
      cseg->v = c_rot * pVect(0,1,0);
      cseg->ctr_to_right_dir = c_rot * pVect(1,0,0);
      pQuat cn_rot_q = cseg->orientation * helix_rn_trans;
      pMatrix_Rotation cn_rot(cn_rot_q);
      cseg->nu = cn_rot * pVect(0,0,1);
      cseg->nv = cn_rot * pVect(0,1,0);

      pVect ctr_to_right = helix_seg_hlength * cseg->ctr_to_right_dir;

      cseg->pos_left = cseg->position - ctr_to_right;
      cseg->pos_right = cseg->position + ctr_to_right;
      cseg->force = opt_gravity ? gravity_force : vZero;
      cseg->torque = vZero;
    }

  for ( int i=0; i<phys_helix_segments-1; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];
      Wire_Segment* const rseg = &wire_segments[i+1];

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
  if ( opt_interpen )
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

            // Use bounding sphere to quickly rule out contact.
            //
            if ( dist.mag_sq > four_wire_radius_sq ) continue;

            // As a crude approximation, compute depth of
            // interpenetration using bounding sphere.
            //
            const float pen_depth = 2 * wire_radius - dist.magnitude;
            pVect sep_force = pen_depth * opt_spring_constant * dist;
            aseg->force -= sep_force;
            bseg->force += sep_force;
          }
    }

  for ( int i=1; i<phys_helix_segments; i++ )
    {
      Wire_Segment* const cseg = &wire_segments[i];
      cseg->velocity *= 0.9999;
      cseg->omega *= 0.9999;
      cseg->velocity += delta_t_mass_inv * cseg->force;
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

void
World::cuda_init()
{
  cuda_constants_stale = true;

  // Get information about GPU and its ability to run CUDA.
  //
  int device_count;
  cudaGetDeviceCount(&device_count); // Get number of GPUs.
  ASSERTS( device_count );
  for ( int dev = 0; dev < device_count; dev ++ )
    {
      CE(cudaGetDeviceProperties(&cuda_prop,dev));
      CE(cudaGLSetGLDevice(dev));
      printf
        ("GPU %d: %s @ %.2f GHz WITH %d MiB GLOBAL MEM\n",
         dev, cuda_prop.name, cuda_prop.clockRate/1e6,
         int(cuda_prop.totalGlobalMem >> 20));

      printf
        ("GPU %d: CAP: %d.%d  MP: %2d  TH/WP: %3d  TH/BL: %4d\n",
         dev, cuda_prop.major, cuda_prop.minor,
         cuda_prop.multiProcessorCount,
         cuda_prop.warpSize,
         cuda_prop.maxThreadsPerBlock
         );

      printf
        ("GPU %d: SHARED: %5d  CONST: %5d  # REGS: %5d\n",
         dev,
         int(cuda_prop.sharedMemPerBlock), int(cuda_prop.totalConstMem),
         cuda_prop.regsPerBlock
         );
    }

  const int dev = 0;

  printf("Using GPU %d\n",dev);
  CE(cudaSetDevice(dev));

  // Prepare events used for timing.
  //
  CE(cudaEventCreate(&frame_start_ce));
  CE(cudaEventCreate(&frame_stop_ce));

  cuda_setup(&cfa_helix);

  block_size_max = cfa_helix.maxThreadsPerBlock;
  set_min(block_size_max,cuda_prop.maxThreadsPerBlock);

  printf("CUDA Routine Resource Usage:\n");
  printf(" pass_helix: %6zd shared, %zd const, %zd loc, %d regs; "
         "%d max thr\n",
         cfa_helix.sharedSizeBytes,
         cfa_helix.constSizeBytes,
         cfa_helix.localSizeBytes,
         cfa_helix.numRegs,
         cfa_helix.maxThreadsPerBlock);
}



void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const float move_amt = 0.4;

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
    if ( opt_physics_method > GP_cuda ) opt_physics_method = GP_cpu;
    if ( opt_physics_method == GP_cuda ) cuda_constants_stale = true;
    break;

  case 's':
    opt_shader++; if ( opt_shader == SP_ENUM_SIZE ) opt_shader = 1;
    break;
  case 'S':
    if ( opt_shader == 1 ) opt_shader = SP_ENUM_SIZE;
    opt_shader--;
    break;

  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;

  case 'g': case 'G': opt_gravity = !opt_gravity;
    cuda_constants_stale = true;
    break;

  case 'i': case 'I': opt_interpen = !opt_interpen;
    cuda_constants_stale = true;
    break;

  case 't': case 'T': opt_test = !opt_test; break;

  case 'p': case 'P':
    opt_pause = !opt_pause;
    if ( !opt_pause ) world_time = time_wall_fp();
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
      case MI_Ball: helix_location += adjustment; break;
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
