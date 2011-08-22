/// LSU EE 4702-1 (Fall 2011), GPU Programming
//
 /// Balloon Simulation

// $Id:$

/// Purpose
//
//   Demonstrate use of gpu for physics.


/// What Code Does

// The code in this file simulates a /balloon/: an elastic /surface/
// that encloses a /gas/. Outside the balloon is /air/, and there
// is a /platform/ for the balloon to bounce on.  Many physical
// parameters can be varied affecting the balloon bouncyness and
// buoyancy.

// By default the balloon simulation (physics) is performed on the GPU
// using CUDA using a one-pass algorithm, but the user can switch
// between a second CUDA algorithm, using the OpenGL API for physics,
// or having the CPU do the physics.

// The platform consists of tiles, some are purple-tinted mirrors
// (showing a reflection of the balloon), the others show the course
// syllabus.  The balloon can cast a shadow on the tiles.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Balloon) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push balloon, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move balloon. (Change position but not velocity.)
 //   'B': Push balloon. (Add velocity.)
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
 //  's'    Stop balloon (but not vibration).
 //  'S'    Freeze balloon. (Set velocity of all vertices to zero.)
 //  'a'    Cycle between different physics algorithms and processors (GPU/CPU).
 //  'A'    Switch between CPU and GPU physics.
 //  'g'    Turn gravity on and off.
 //  'n'    Switch between textured and striped balloon surface.
 //  'F12'  Write screenshot to file balloon.png.

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
 //  VAR Gas Amount - Amount of gas in balloon.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)
 //  VAR Air Resistance - Viscosity of air.
 //  VAR Gas Particle Mass - Initially matches air mass.
 //  VAR Spring Constant - Warning: watch Oversample as this is increased.
 //  VAR Repulsion Constant - Determines stiffness of surface.
 //  VAR Surface Mass -  Warning: watch Oversample as this is reduced.


/// Bugs and Incomplete Features

// Code is only sparsely commented.

// Some code in this file should be moved to other files. 

// The reflection and shadow are incorrect when the balloon
// is below the platform.

// At high spring constant values the simulation leaks momentum.

// The repulsion used to model stiffness should be augmented or replaced
// with forces based on angle (not just distance).


/// To Do

// Detect and prevent interpenetration.

// Use something like Verlet integration to update position.

// Provide presets of physical parameters, for example, to simulate a
// hot-air balloon, a partially deflated basketball, etc.



#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>
#include <Magick++.h>

#include <cuda_runtime.h>
#include <cuda_gl_interop.h>

#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/cuda-util.h>
#include <gp/gl-buffer.h>

#include "balloon.cuh"

 ///
 /// Ad-Hoc Class for Reading Images
 ///

using namespace Magick;

class P_Image_Read
{
public:
  P_Image_Read(const char *path, int transp):
    image(path),image_loaded(false),data(NULL)
  {
    width = image.columns();
    height = image.rows();
    size = width * height;
    if ( !width || !height ) return;
    if ( transp == 255 )
      image.transparent(Color("White"));
    pp = image.getPixels(0,0,width,height);
    for ( int i = 0; i < size; i++ ) pp[i].opacity = MaxRGB - pp[i].opacity;
    gl_fmt = GL_BGRA;
    gl_type = sizeof(PixelPacket) == 8 ? GL_UNSIGNED_SHORT : GL_UNSIGNED_BYTE;
    data = (unsigned char*) pp;
    image_loaded = true;
  };
  void color_invert()
  {
    for ( int i = 0; i < size; i++ )
      {
        PixelPacket& p = pp[i];
        const int sum = p.red + p.blue + p.green;
        p.opacity = (typeof p.opacity)( MaxRGB - sum * 0.3333333 );
        p.red = p.blue = p.green = MaxRGB;
      }
  }
  Image image;
  PixelPacket *pp;
  bool image_loaded;
  int width, height, maxval, size;
  unsigned char *data;
  int gl_fmt;
  int gl_type;
private:
};


 ///
 /// Create and initialize texture object using image file.
 ///

GLuint
pBuild_Texture_File
(const char *name, bool invert = false, int transp = 256, GLuint tid = 0)
{
  // Read image from file.
  //
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;

  // Invert colors. (E.g., to show text as white on black.)
  //
  if ( invert ) image.color_invert();

  if ( tid == 0 )
    glGenTextures(1,&tid);
  ASSERTS( tid != 0 );
  glBindTexture(GL_TEXTURE_2D,tid);
  glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, 1);

  // Load data into the texture object.
  //
  glTexImage2D
    (GL_TEXTURE_2D,
     0,                // Level of Detail (0 is base).
     GL_RGBA,          // Internal format to be used for texture.
     image.width, image.height,
     0,                // Border
     image.gl_fmt,     // GL_BGRA: Format of data read by this call.
     image.gl_type,    // GL_UNSIGNED_BYTE: Size of component.
     (void*)image.data);
  pError_Check();

  return tid;
}


///
/// Main Data Structures
///
//
// class World: All data about scene.
// class Balloon: Data about a balloon.
//
// See also balloon.cuh


class World;

struct Balloon_Triangle {
  int pi, qi, ri;
  int pi_opp, qi_opp, ri_opp;
  bool pi_less, qi_less, ri_less;
  pColor color;
  pVect normal;
  float length_relaxed;
  int block_number; // Used for preparing cuda data.
  bool a_vtx(int v) const { return v == pi || v == qi || v == ri; }
  int third_vtx(int v1, int v2) const
  { return ( v1 == pi && v2 == qi || v2 == pi && v1 == qi ? ri :
             v1 == pi && v2 == ri || v2 == pi && v1 == ri ? qi :
             v1 == qi && v2 == ri || v2 == qi && v1 == ri ? pi : -1 ); }
};

struct Balloon_Rep_Pair {
  // Repulsion pairs.
  int pi, qi;
};

struct Balloon_Vertex {
  Balloon_Vertex(){ edge_out_count = edge_in_count = 0; }

  // Constant Data (from time step to time step)

  float mass_inv;
  float mass;
  int edge_out[7];
  int edge_out_count;
  PStack<int> triangles;
  pCoor tex_coor;

  // Data changed each time step.

  pCoor pos;
  pVect vel;

  // Maybe generated and used in same time step.

  pCoor pos_prev;
  pVect force;
  pVect force_spring;
  pVect force_pressure;
  pVect force_rep; // Repulsion.
  pVect surface_normal;

  // Only used during initialization.
  int edge_in_count;
  int edge_in[6];
  double eta;
  double theta, delta_theta;
  int ring;
  int edge_long_next; // Longitude next.
};

// Structural Data for OpenGL Physics, One per Triangle
//
struct GLP_Tri_Strc {
  float pi, qi, ri;             // Index of triangle's vertices.
  float length_relaxed;
  int pi_opp, qi_opp, ri_opp;
};  // 7 * 4 = 28 bytes

// Structural Data for OpenGL Physics, One per Vertex
//
struct GLP_Vtx_Strc {
  int self_idx_encoded;
  int tri_idx_base;  // Tri idx of neighbor i is tri_idx_base + neighbors[i];
  uint16_t neighbors[VTX_TRI_DEG_MAX]; // Index of vertex's triangles.
};


// GPU-Computed Balloon Data for Triangles
//
struct GLP_Tri_Data {
  pCoor surface_normal; // Magnitude is area of incident triangles.
  pCoor force_p;
  pCoor force_q;
  pCoor force_r;
};

// See also balloon.cuh.


// GPU-Computed Balloon Data for Vertices
//
struct GLP_Vtx_Data {
  pCoor surface_normal; // Magnitude is area of incident triangles.
  pCoor vel;
  pCoor pos;
  pCoor padding;
};

// See also balloon.cuh.


enum Data_Location { DL_CPU = 0x1, DL_GLP = 0x2, DL_CUDA = 0x4 };
enum GPU_Physics_Method
  { GP_cpu, GP_glp, GP_cuda_1_pass, GP_cuda_2_pass, GP_ENUM_SIZE };
const char* const gpu_physics_method_str[] =
  { "CPU", "OpenGL 2 Pass", "CUDA 1 Pass", "CUDA 2 Pass" };


class Balloon {
public:
  Balloon(World& w):world(w)
  {
    cuda_initialized = false;
    glp_initialized = false;
  }
  ~Balloon(){ }
  void init(pCoor center, double radius);

  // Called each time user changes a configuration variable, such as gravity.
  void update_for_config();

  void init_glp();

  void init_cuda();
  void cuda_data_partition();

  // Advance (time-step) simulated time.
  //
  void time_step_cpu(int steps);
  void time_step_cpu_once();
  void time_step_gpu(int steps);  // Call appropriate time_step routine.
  void time_step_glp(int steps);   // Use OpenGL API for physics.
  void time_step_cuda(int steps); // Use CUDA API for physics.

  void gpu_data_to_cpu();
  void glp_data_to_cpu();
  void cuda_data_to_cpu();
  void cpu_data_to_glp();
  bool cpu_data_to_cuda();  // Return true if data transferred.

  // User Interaction
  //
  void translate(pVect amt); // Instantly move balloon.
  void push(pVect amt);      // Instantly add velocity.
  void stop()                //  Stop motion but not other motion.
  {
    pVect avg_vel = velocity_avg();
    for ( int i=0; i<point_count; i++ ) points[i].vel -= avg_vel;
  }
  void freeze()             //  Stop all motion.
  {
    for ( int i=0; i<point_count; i++ ) points[i].vel = pVect(0,0,0);
  }

  pCoor centroid_compute()
  {
    pCoor point_sum(0,0,0);
    for ( int i=0; i<point_count; i++ ) point_sum += points[i].pos;
    point_sum.homogenize();
    centroid = point_sum;
    return centroid;
  }
  float pressure_air(float msl)
  {
    return opt_gravity ? exp( - 0.2 * air_particle_mass * msl ) : 1.0;
  }
  float pressure_gas(float msl, float factorp = 0)
  {
    const float factor = factorp ? factorp : gas_pressure_factor;
    return opt_gravity ? factor * exp( - gas_m_over_temp * msl ) : factor;
  }
  void pressure_compute()
  {
    const float exp_air = pressure_air(centroid.y);
    const float exp_gas = pressure_gas(centroid.y,1);
    const float eff_volume = fabs( volume );
    gas_pressure_factor = pressure_factor_coeff / eff_volume;
    pressure = gas_pressure_factor * exp_gas / exp_air;
    density_air =
      ( pressure_air(centroid.y - 0.5) - pressure_air(centroid.y + 0.5) )
      / opt_gravity_accel;
    density_gas =
      ( pressure_gas(centroid.y - 0.5) - pressure_gas(centroid.y + 0.5) )
      / opt_gravity_accel;
  }
  pVect velocity_avg()
  {
    pVect vel_avg(0,0,0);
    for ( int i=0; i<point_count; i++ ) vel_avg += points[i].vel;
    vel_avg *= 1.0/point_count;
    return vel_avg;
  }

  World& world;

  // Structural Data
  //
  float radius;                 // Initial radius.
  float nom_volume; // Volume based on initial radius

  // Balloon Structure
  //
  PStack<Balloon_Vertex> points;
  PStack<Balloon_Triangle> triangles;
  PStack<Balloon_Rep_Pair> rep_pairs;
  pBuffer_Object<GLuint> point_indices;
  pBuffer_Object<float> tex_coords;
  int point_count;
  int tri_count;
  int rep_pair_count;
  int tethered_idx;


  // Unchanging (or user set) Physical Constants
  //
  float spring_constant;
  float rep_constant;
  float air_resistance;
  float surface_mass;
  float gas_amount;
  float gas_particle_mass;
  float air_particle_mass;
  float temperature;
  float opt_gravity_accel;
  float damping_v;              // CPU and gpu. Higher is less damping.
  float damping_factor;         // CPU only code.

  // User-Set Options (in addition to physical constants above).
  //
  bool opt_gravity;             // If false, no gravity.
  bool opt_damping;             // Only used in cpu code. See also damping_v
  bool opt_cpu_interleave;  // When gpu physics on do 1 cpu time step / frame.

  // Computed after each change to user-set physical quantity.
  //
  float temp_ratio;  // Temperature ratio.
  float gas_mass_per_vertex;
  float pressure_factor_coeff;
  float gas_pressure_factor;
  double oversample;       // Harmonic (approx) divided by time step delta t.
  double tightness;
  float damping_factor_per_step;
  float point_mass;
  float point_mass_inv;

  // Computed each time step.
  //
  float volume;
  float area;
  pVect weight;
  pCoor centroid;
  float gas_m_over_temp;  // Coefficient in pressure formula.
  float pressure;
  float density_air, density_gas;

  // Computed but not yet correct.
  //
  double e_spring, e_kinetic;
  double energy, e_zero;

  GLuint texid_pse, texid_syl;

  int cpu_iteration;
  bool need_cpu_iteration;
  bool length_relaxed_update;

  int data_location;
  GLuint data_bid;
  int data_stride;

  bool glp_initialized;
  pBuffer_Object<GLP_Vtx_Data> glp_vtx_data;
  pBuffer_Object<GLP_Tri_Data> glp_tri_data;
  pBuffer_Object<GLP_Vtx_Strc> glp_vtx_strc;
  pBuffer_Object<GLP_Tri_Strc> glp_tri_strc;

  GLuint query_transform_feedback_id;
  GLuint glp_vtx_data_tid;
  GLuint glp_tri_data_tid;
  GLuint framebuffer_id, renderbuffer_id;
  pShader vs_plan_c;
  GLint sat_indices, sat_volume, sat_pos, sat_vel;
  GLint sun_constants_sc;
  GLint sun_constants_gas, sun_constants_dt, sun_platform;
  GLint svl_surface_normal, svl_force_or_v, svl_pos, svl_force_r;
  GLint stx_data_vtx, stx_data_tri;

  // CUDA Stuff
  //
  bool cuda_initialized;
  bool cuda_constants_stale;
  pCUDA_Memory_X<CUDA_Tri_Strc,CUDA_Tri_Strc_X> cuda_tri_strc;
  pCUDA_Memory_X<CUDA_Tri_Work_Strc,CUDA_Tri_Work_Strc_X> cuda_tri_work_strc;
  pCUDA_Memory<CUDA_Tri_Data> cuda_tri_data;
  pCUDA_Memory_X<CUDA_Vtx_Strc,CUDA_Vtx_Strc_X> cuda_vtx_strc;
  pCUDA_Memory_X<CUDA_Vtx_Data,CUDA_Vtx_Data_X> cuda_vtx_data;
  pCUDA_Memory<float> cuda_tower_volumes;
  pCUDA_Memory<float3> cuda_centroid_parts;
  int tri_work_per_vtx;
  int tri_work_per_vtx_lg;
  dim3 Dg_tri, Db_tri, Dg_vtx, Db_vtx;
};

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb),balloon(*this){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void cb_keyboard();
  void modelview_update();
  void shadow_update();
  void shadow_transform_create(pMatrix& m, pCoor light);

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  cudaEvent_t frame_start_ce, frame_stop_ce;
  double world_time;
  double delta_t;               // Duration of time step.

  // Tiled platform for balloon.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;

  Balloon balloon;
  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Balloon, MI_Balloon_V, MI_COUNT } opt_move_item;
  bool opt_pause;
  int opt_physics_method;
  int opt_physics_method_last;
  bool opt_surface_smooth;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_shadow;
  pMatrix transform_mirror;

  pShader vs_fixed;
};

void
World::init()
{
  const double radius = 5;
  pCoor center(13.7,12,-15.4);
  frame_timer.work_unit_set("Steps / s");
  world_time = 0;
  delta_t = 1.0 / ( 32 * 30 );
  balloon.data_location = DL_CPU;
  balloon.data_bid = 0;
  eye_location = pCoor(24.2,11.6,-38.7);
  eye_direction = pVect(-0.42,-0.09,0.9);
  opt_move_item = MI_Eye;
  opt_light_intensity = 100.2;
  opt_physics_method = GP_cuda_1_pass;
  opt_surface_smooth = true;
  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  light_location = pCoor(platform_xmax,platform_xmax,platform_zmin);
  balloon.need_cpu_iteration = true;
  balloon.length_relaxed_update = true;
  balloon.damping_v = 0.1;
  balloon.cpu_iteration = 0;
  balloon.opt_gravity = true;
  balloon.opt_damping = false;
  balloon.opt_cpu_interleave = false;
  balloon.damping_factor = 0.2;
  balloon.spring_constant = 40.0;
  balloon.rep_constant = 0.01;
  balloon.air_resistance = 0.001;
  balloon.gas_amount = 0;
  balloon.surface_mass = 1;
  balloon.e_zero = 0;
  balloon.opt_gravity_accel = 9.8;
  balloon.gas_particle_mass = 0.01;
  balloon.air_particle_mass = 0.01;
  balloon.temperature = 300;
  opt_pause = false;
  variable_control.insert(balloon.gas_amount,"Gas Amount");
  variable_control.insert(balloon.opt_gravity_accel,"Gravity");
  //  variable_control.insert(balloon.temperature,"Temperature");
  //  variable_control.insert(balloon.damping_v,"Damping Factor");
  variable_control.insert(balloon.air_resistance,"Air Resistance");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(balloon.gas_particle_mass,"Gas Particle Mass");
  variable_control.insert(balloon.spring_constant,"Spring Constant");
  variable_control.insert(balloon.rep_constant,"Repulsion Constant");
  variable_control.insert(balloon.surface_mass,"Surface Mass");
  balloon.init(center,radius);

  modelview_update();

  const float tile_count = 19;
  const float ep = 1.00001;
  const float xdelta = ( platform_xmax - platform_xmin ) / tile_count * ep;
  const float zdelta = ( platform_zmax - platform_zmin ) / tile_count * ep;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<float> p_tex_coords;
  bool even = true;

  for ( float x = platform_xmin; x < platform_xmax; x += xdelta )
    for ( float z = platform_zmin; z < platform_zmax; z += zdelta )
      {
        PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
        p_tex_coords += trmax; p_tex_coords += tsmax;
        t_coords += pVect(x,-0.01,z);
        p_tex_coords += trmax; p_tex_coords += tsmin;
        t_coords += pVect(x,-0.01,z+zdelta);
        p_tex_coords += trmin; p_tex_coords += tsmin;
        t_coords += pVect(x+xdelta,-0.01,z+zdelta);
        p_tex_coords += trmin; p_tex_coords += tsmax;
        t_coords += pVect(x+xdelta,-0.01,z);
        even = !even;
      }

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;

  platform_tile_coords.take(p_tile_coords);
  platform_tile_coords.to_gpu();
  platform_tex_coords.take(p_tex_coords);
  platform_tex_coords.to_gpu();
}


void
Balloon::init(pCoor center, double r)
{
  radius = r;
  nom_volume = 4.0/3.0 * M_PI * r * r *r;
  const int equator_points = 60;
  const int slice_points_min = 6;
  const double two_pi = 2 * M_PI;
  const double half_pi = 0.5 * M_PI;
  const double equator_interpoint_radians = two_pi / equator_points;
  const double equator_interpoint = r * equator_interpoint_radians;
  const double epsilon = 0.00000001;
  point_count = 0;

  Balloon_Vertex* const pole_south = points.pushi();
  pole_south->mass_inv = 1;
  pole_south->theta = pole_south->delta_theta = 10;
  pole_south->pos = center + pVect(0,0,r);
  pole_south->vel = pVect(0,0,0);
  pole_south->ring = 0;
  pole_south->eta = 0;
  point_count++;

  const double first_eta =
    asin( double(slice_points_min) / equator_points );
  const int rings =
    int(0.5 + ( M_PI - 2 * first_eta ) / equator_interpoint_radians);
  const double delta_eta = ( M_PI - 2 * first_eta ) / max(1,rings);
  int ring_count = 0;
  PStack<int> rings_first_idx;
  rings_first_idx += 0;

  PStack<double> etas;
  PStack<int> slice_points_hemi;

  int slice_points_next = slice_points_min;
  for ( double eta = first_eta; eta <= half_pi; eta += delta_eta )
    {
      const double slice_r = r * sin(eta);
      const int slice_points_even =
        int( 0.5 + two_pi * slice_r / equator_interpoint );
      const int slice_points_use = min(slice_points_even,slice_points_next);
      slice_points_hemi += slice_points_use;
      slice_points_next = 2 * slice_points_use;
    }
  PStack<int> slice_points_all;
  for ( int sp=0; slice_points_hemi.iterate(sp); ) slice_points_all += sp;
  slice_points_hemi.pop();
  while ( slice_points_hemi.occ() ) slice_points_all += slice_points_hemi.pop();

  for ( int slice_points=0; slice_points_all.iterate(slice_points); )
    {
      const int ring_count = 1 + slice_points_all.iterate_get_idx();
      const double eta = first_eta + ring_count * delta_eta;
      const double z = r * cos(eta);
      const double slice_r = r * sin(eta);
      const int ring_first_idx = point_count;
      const int lr_first_idx = rings_first_idx.peek();
      const int lr_last_idx = point_count - 1;
      ASSERTS( ring_count != 1 || slice_points == slice_points_min );
      ASSERTS( ring_count != rings + 1 || slice_points == slice_points_min );

      rings_first_idx += point_count;

      double thetas[slice_points+1];
      const double delta_theta = two_pi / slice_points;
      thetas[0] = ring_count & 1 ? 0 : delta_theta * 0.5;
      for ( int i=1; i<=slice_points; i++ )
        thetas[i] = thetas[i-1] + delta_theta;

      int lr_idx = // Lower ring index
        points[lr_first_idx].theta < thetas[0] + epsilon
        ? lr_first_idx : lr_last_idx;

      double lr_theta =
        points[lr_idx].theta + ( lr_idx == lr_first_idx ? 0 : -two_pi );
        
      const int lr_first_connected = lr_idx;
      bool past_first_connected = false;

      for ( int slice_idx = 0; slice_idx < slice_points; slice_idx++ )
        {
          const double theta = thetas[slice_idx];
          const bool first_slice = slice_idx == 0;
          const bool last_slice = slice_idx == slice_points - 1;
          Balloon_Vertex* const point = points.pushi();
          point->mass_inv = 1;
          point->ring = ring_count;
          point->eta = eta;
          point->theta = theta;
          point->delta_theta = thetas[slice_idx+1] - theta;
          point->pos = center +
            pVect(slice_r * cos(theta), slice_r * sin(theta), z );
          point->vel = pVect(0,0,0);
          point->edge_long_next = last_slice ? ring_first_idx : point_count + 1;
          point->edge_out[point->edge_out_count++] =
            point_count - 1 + ( first_slice ? slice_points : 0 );

          const double mid_theta = 0.5 * ( theta + thetas[slice_idx+1] );
          while ( true )
            {
              point->edge_out[point->edge_out_count++] = lr_idx;
              if ( lr_theta > 7 ) break;  // Special case for pole.
              if ( past_first_connected && lr_idx == lr_first_connected ) break;
              Balloon_Vertex* const lr_p = &points[lr_idx];
              const double lr_theta_next = lr_theta + lr_p->delta_theta;
              if ( !last_slice
                   && lr_theta >= theta && lr_theta_next > mid_theta  ) break;
              lr_idx = lr_p->edge_long_next;
              lr_theta = lr_theta_next;
              past_first_connected = true;
            }
          point_count++;
        }
    }

  {
    Balloon_Vertex* const pole_north = points.pushi();
    pole_north->mass_inv = 1;
    pole_north->theta = 10;
    pole_north->pos = center + pVect(0,0,-r);
    pole_north->vel = pVect(0,0,0);
    pole_north->ring = ++ring_count;
    pole_north->eta = M_PI;
    const int lower_ring_first_idx = rings_first_idx.peek();
    for ( int lower_ring_idx = lower_ring_first_idx;
          lower_ring_idx != point_count; lower_ring_idx++ )
      pole_north->edge_out[pole_north->edge_out_count++] = lower_ring_idx;
    pole_north->edge_out[pole_north->edge_out_count++] = lower_ring_first_idx;
    point_count++;
  }

  tethered_idx = 0;
  float min_y = pole_south->pos.y;
  for ( int idx = 0;  idx < point_count;  idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      ASSERTS( p->mass_inv > 0 );
      p->mass = 1.0 / p->mass_inv;

      if ( p->pos.y > min_y ) { tethered_idx = idx;  min_y = p->pos.y; }

      for ( int j = 0;  j < p->edge_out_count;  j++ )
        {
          const int qi = p->edge_out[j];
          Balloon_Vertex* const q = &points[qi];
          q->edge_in[q->edge_in_count++] = idx;
        }
    }

  PStack<GLuint> p_indices;
  const double tex_eta_min = 0.25 * M_PI;
  const double tex_eta_max = 0.75 * M_PI;
  const double tex_theta_min = 0;
  const double tex_theta_max = two_pi;
  const double eta_to_s = 1.0 / ( tex_eta_max - tex_eta_min );
  const double theta_to_s = 1.0 / ( tex_theta_max - tex_theta_min );

  PStack<float> gpu_tex_coords;

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      pColor color;

      p->tex_coor.x = ( p->theta - tex_theta_min ) * theta_to_s;
      p->tex_coor.y = ( p->eta - tex_eta_min ) * eta_to_s;
      gpu_tex_coords += p->tex_coor.x;
      gpu_tex_coords += p->tex_coor.y;

      switch ( p->ring & 0x3 ) {
      case 0: color = pColor(0.9,.1,.1); break;
      case 1: color = pColor(0.1,0.9,0.1); break;
      case 2: color = pColor(0.1,0.1,0.9); break;
      case 3: color = pColor(0.1,0.9,0.9); break;
      default: color = pColor(0.5,0.5,0.5); break;
      }

      const bool within_ring_first = !idx || p->ring != points[idx-1].ring;
      const bool within_ring_last =
        idx + 1 == point_count || p->ring != points[idx+1].ring;

      for ( int e = 0;  e < p->edge_out_count - 1;  e++ )
        {
          const int qi = p->edge_out[e];
          Balloon_Vertex* const q = &points[qi];
          const int ri = p->edge_out[e+1];
          Balloon_Vertex* const r = &points[ri];
          for ( int qe=0; qe < q->edge_out_count-1; qe++ )
            { ASSERTS( q->edge_out[qe] != ri ); }
          for ( int re=0; re < r->edge_out_count-1; re++ )
            { ASSERTS( r->edge_out[re] != idx ); }
          const int tri_idx = triangles.occ();
          Balloon_Triangle* const tri = triangles.pushi();
          tri->pi = idx;  tri->qi = qi;  tri->ri = ri;
          tri->color =
            within_ring_first && e == 0 ? pColor(0.9,0.9,0.9) :
            within_ring_last && e == p->edge_out_count -2
            ? pColor(0.1,0.1,0.1) : color;
          p->triangles += tri_idx;
          p_indices += idx;
          p_indices += qi;
          p_indices += ri;
        }
    }
  tri_count = triangles.occ();
  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      points[tri->qi].triangles += idx;
      points[tri->ri].triangles += idx;
    }

  for ( int i=0; i<tri_count; i++ )
    {
      Balloon_Triangle* const tri = &triangles[i];
      const int pi = tri->pi;
      const int qi = tri->qi;
      const int ri = tri->ri;
      int opp_p = -1, opp_q = -1, opp_r = -1;
      for ( int j=0; j<tri_count; j++ )
        {
          if ( i == j ) continue;
          Balloon_Triangle* const tri2 = &triangles[j];
          if ( opp_r < 0 ) opp_r = tri2->third_vtx(pi,qi);
          if ( opp_p < 0 ) opp_p = tri2->third_vtx(ri,qi);
          if ( opp_q < 0 ) opp_q = tri2->third_vtx(ri,pi);
        }
      ASSERTS( opp_p != -1 && opp_q != -1 && opp_r != -1 );

#define OP_SET(v)                                                             \
      tri->v##i_opp = opp_##v;                                                \
      tri->v##i_less = v##i < opp_##v;                                        \
      if ( tri->v##i_less )                                                   \
        {                                                                     \
          Balloon_Rep_Pair* const rp = rep_pairs.pushi();                     \
          rp->pi = v##i;  rp->qi = opp_##v;                                   \
        }

      OP_SET(p); OP_SET(q); OP_SET(r);
    }

  rep_pair_count = rep_pairs.occ();

  texid_pse = pBuild_Texture_File("shot-emacs.png",false,255);
  tex_coords.take(gpu_tex_coords,GL_STATIC_DRAW);
  tex_coords.to_gpu();
  if ( 1 )
    texid_syl = pBuild_Texture_File("gpup.png",false,255);
  else
    texid_syl = pBuild_Texture_File
      ("/home/faculty/koppel/teach/gpup11/gpup.dvi",false,255);

  point_indices.take(p_indices,GL_STATIC_DRAW,GL_ELEMENT_ARRAY_BUFFER);
  point_indices.to_gpu();

  glp_vtx_data.alloc(point_count,GL_DYNAMIC_COPY);
  glp_vtx_data.prepare_two_buffers();
  glp_tri_data.alloc(tri_count,GL_DYNAMIC_COPY);
  glp_tri_data.prepare_two_buffers();
  glp_vtx_strc.alloc(point_count,GL_STATIC_DRAW);
  glp_tri_strc.alloc(tri_count,GL_STATIC_DRAW);

  cuda_tri_strc.alloc(tri_count);
  cuda_tri_strc.disable_aos = false;
  cuda_vtx_strc.alloc(point_count);
  cuda_vtx_strc.disable_aos = false;

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      GLP_Vtx_Strc* const vd = &glp_vtx_strc[idx];
      CUDA_Vtx_Strc* const vc = &cuda_vtx_strc[idx];
      vd->self_idx_encoded = -idx-2;
      int np = 0;

      int ti_min = tri_count;
      for ( int ti = 0; p->triangles.iterate(ti); ) ti_min = min(ti_min,ti);
      ti_min--;
      vd->tri_idx_base = vc->tri_idx_base = ti_min;

      for ( int ti = 0; p->triangles.iterate(ti); )
        {
          Balloon_Triangle* const tri = &triangles[ti];
          const int pos = tri->pi == idx ? 0 : tri->qi == idx ? 1 : 2;
          const int pos_packed = 4 * ( ti - ti_min ) + pos;
          ASSERTS( pos_packed );
          vd->neighbors[np] = pos_packed;
          ASSERTS( vd->neighbors[np] == pos_packed );
          np++;
        }
      ASSERTS( np < VTX_TRI_DEG_MAX );
      while ( np < VTX_TRI_DEG_MAX ) vd->neighbors[np++] = 0;
      typeof vc->n0* const vcn = &vc->n0;
      for ( int i=0; i<VTX_TRI_DEG_MAX; i++ ) vcn[i] = vd->neighbors[i];
    }

  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      GLP_Tri_Strc* const td = &glp_tri_strc[idx];
      CUDA_Tri_Strc* const tc = &cuda_tri_strc[idx];
#     define CPY_IDX(I) \
       td->I = (typeof td->I)(tri->I);  tc->I = (typeof tc->I)(tri->I);
      CPY_IDX(pi);     CPY_IDX(qi);     CPY_IDX(ri);
      CPY_IDX(pi_opp); CPY_IDX(qi_opp); CPY_IDX(ri_opp);
      CPY_IDX(length_relaxed);
#     undef CPY_IDX
    }

  printf("For %d equator points: %d vertices (points) and %d triangles.\n",
         equator_points, point_count, tri_count);
}

void
Balloon::update_for_config()
{
  temp_ratio = temperature / 300;
  point_mass = surface_mass / point_count;
  point_mass_inv = 1.0 / point_mass;
  damping_factor_per_step = pow(damping_factor,world.delta_t);
  const double ell = pow(volume,1/3.);
  const double a = sqrt( 2.0 * ell * spring_constant * point_mass_inv  );
  oversample = M_PI / ( 2 * a * world.delta_t );
  tightness = a;
  gas_m_over_temp = 0.2 * gas_particle_mass / temp_ratio;
  pressure_factor_coeff = gas_amount * temp_ratio;
  const double mass_gas =
    ( pressure_gas(centroid.y - 0.5, pressure_factor_coeff)
      - pressure_gas(centroid.y + 0.5, pressure_factor_coeff) )
    / opt_gravity_accel;
  gas_mass_per_vertex = mass_gas / point_count;
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
#if 0
  const bool light_at_infinity = light_location.w == 0;
  if ( light_at_infinity )
    {
      frustum.rc(0,0) = frustum.rc(1,1) = frustum.rc(3,3) = 1;
    }
  else
#endif
    {
      frustum.rc(0,0) = frustum.rc(1,1) = light_location.y;
      frustum.rc(3,2) = -1;
    }
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
Balloon::translate(pVect amt)
{
  gpu_data_to_cpu();
  for ( int idx = 0;  idx < point_count; idx++ )
    points[idx].pos += amt;
  data_location = DL_CPU;
  data_bid = 0;
}

void
Balloon::push(pVect amt)
{
  gpu_data_to_cpu();
  for ( int idx = 0;  idx < point_count; idx++ )
    points[idx].vel += amt;
  data_location = DL_CPU;
  data_bid = 0;
}

void
Balloon::time_step_cpu(int steps)
{
  for ( int i=0; i<steps; i++ ) time_step_cpu_once();
}

void
Balloon::time_step_cpu_once()
{
  const double friction_coefficient = 0.04;
  const double bounce_factor = 0.0;
  const double delta_t = world.delta_t;
  pVect gravity(0,-opt_gravity_accel,0);
  if ( !opt_gravity ) gravity = pVect(0,0,0);
  const bool first_iteration = cpu_iteration == 0;
  cpu_iteration++;
  need_cpu_iteration = false;

  double volume_x2 = 0;
  double area_x2 = 0;
  double kinetic_energy_total = 0;
  double spring_energy_factor_total = 0;
  pVect surface_error2(0,0,0);
  centroid = pCoor(0,0,0,0);
  weight = pVect(0,0,0);

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      centroid += p->pos;
      kinetic_energy_total += p->vel.mag();
      p->force_spring = pVect(0,0,0);
      p->force_rep = pVect(0,0,0);
      p->surface_normal = pVect(0,0,0);
    }
  centroid.homogenize();

  for ( int i = 0;  i < tri_count;  i++ )
    {
      Balloon_Triangle* const tri = &triangles[i];
      Balloon_Vertex* const p = &points[tri->pi];
      Balloon_Vertex* const q = &points[tri->qi];
      Balloon_Vertex* const r = &points[tri->ri];

      pCoor center = 1./3 * ( p->pos + q->pos + r->pos );
      pVect pqr_cross(q->pos,p->pos,r->pos);

      p->surface_normal += pqr_cross;
      q->surface_normal += pqr_cross;
      r->surface_normal += pqr_cross;
      surface_error2 += pqr_cross;

      const float tower_volume_x2 = -pqr_cross.y * center.y;
      volume_x2 += tower_volume_x2;

      const float triangle_area_x2 = pqr_cross.mag();
      area_x2 += triangle_area_x2;

      pVect p_to_c(p->pos,center);
      pVect q_to_c(q->pos,center);
      pVect r_to_c(r->pos,center);

      const float perimeter = p_to_c.mag() + q_to_c.mag() + r_to_c.mag();

      if ( length_relaxed_update )
        {
          tri->length_relaxed =
            first_iteration ? perimeter * 0.5 : perimeter;
        }

      const float eff_length = max(0.0f, perimeter - tri->length_relaxed );
      const float spring_force = eff_length * spring_constant;

      p->force_spring += spring_force * p_to_c;
      q->force_spring += spring_force * q_to_c;
      r->force_spring += spring_force * r_to_c;

      const double spring_energy = eff_length;
      spring_energy_factor_total += spring_energy;
    }

  for ( int i=0; i<rep_pair_count; i++ )
    {
      Balloon_Rep_Pair* const rp = &rep_pairs[i];
      Balloon_Vertex* const p = &points[rp->pi];
      Balloon_Vertex* const q = &points[rp->qi];
      pNorm p_to_q(p->pos,q->pos);
      const double dist_sq_inv = rep_constant / max(0.001,p_to_q.mag_sq);
      pVect rep_force(dist_sq_inv * p_to_q);
      p->force_rep -= rep_force;
      q->force_rep += rep_force;
    }

  length_relaxed_update = false;
  volume = volume_x2 / 2.0;
  area = area_x2 / 2.0;

  if ( first_iteration )
    {
      const float exp_air = pressure_air(centroid.y);
      const float exp_gas = pressure_gas(centroid.y,1);

      double pf_sum = 0; // Pressure factor.
      double area_sum_x6 = 0;
      for ( int i=0; i<point_count; i++ )
        {
          Balloon_Vertex* const p = &points[i];
          pNorm inward(p->surface_normal);
          const double pf_balance = dot(p->force_spring+p->force_rep,inward);
          pf_sum += pf_balance;
          area_sum_x6 += inward.magnitude;
        }

      const double area_sum = area_sum_x6 / 6;

      gas_amount =
        ( pf_sum / area_sum + exp_air ) * volume / ( temp_ratio * exp_gas );

      update_for_config(); // Recompute pressure_factor_coeff.
    }

  pressure_compute();

  const double spring_energy =
    12 * pow(point_mass,-0.5) * spring_energy_factor_total;
  const double kinetic_energy =
    point_mass * kinetic_energy_total;
  e_spring = spring_energy;
  e_kinetic = kinetic_energy;
  energy = e_spring + e_kinetic;

  pVect surface_error(0,0,0);
  for ( int i=0; i<point_count; i++ )
    {
      Balloon_Vertex* const p = &points[i];
      surface_error += p->surface_normal;
    }

  for ( int i=0; i<point_count; i++ )
    {
      Balloon_Vertex* const p = &points[i];
      const float gas_pressure = pressure_gas(p->pos.y);
      const float air_pressure = pressure_air(p->pos.y);

      p->surface_normal *= 1./6;

      p->force_pressure =
        ( air_pressure - gas_pressure ) * p->surface_normal;

      p->force = pVect(0,0,0);

      pNorm vel_norm(-p->vel);
      const double facing_area = max(0.0,dot(vel_norm,p->surface_normal));
      pVect force_ar = - air_resistance * facing_area * p->vel;

      pVect gforce = point_mass * p->mass * gravity;
      p->force += gforce;

      weight += p->force;
      p->force += force_ar;

      pVect force_ns = p->force; // Force non-spring.

      pVect force_s = p->force_spring + p->force_rep + p->force_pressure;

      p->force += force_s;

      const float mass_wgas_inv_dt =
        delta_t / ( point_mass * p->mass + gas_mass_per_vertex );

      pVect delta_vns = mass_wgas_inv_dt * force_ns;
      pVect delta_vs = mass_wgas_inv_dt * force_s;
      pVect delta_v = delta_vns + delta_vs;

      //  pVect pos_verlet = p->pos - pos_prev + delta_t * delta_v;

      p->pos_prev = p->pos;
      p->pos += ( p->vel +  0.5 * delta_v ) * delta_t;
      p->vel += damping_v * delta_vs + delta_vns;

    }

  if ( opt_damping )
    {
      pVect vel_avg = velocity_avg();

      for ( int i=0; i<point_count; i++ )
        {
          Balloon_Vertex* const p = &points[i];
          pVect local_vel = p->vel - vel_avg;
          p->vel = damping_factor_per_step * local_vel;
        }
      pVect vel_avg2 = velocity_avg();
      pVect vel_fix = vel_avg - vel_avg2;
      for ( int i=0; i<point_count; i++ ) points[i].vel += vel_fix;
    }

  if ( first_iteration ) e_zero = energy;

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      if ( p->pos.x < world.platform_xmin
           || p->pos.x > world.platform_xmax
           || p->pos.z < world.platform_zmin
           || p->pos.z > world.platform_zmax ) continue;
      if ( p->pos.y > 0 ) continue;
      if ( p->pos_prev.y < 0 ) continue;
      p->pos.y = 0;
      p->vel.y = - bounce_factor * p->vel.y;
      const float gas_pressure = pressure_gas(p->pos.y);
      pVect gforce = point_mass * p->mass * gravity;
      const float f_y =
        gforce.y + p->force_spring.y - gas_pressure * p->surface_normal.y;
      if ( f_y >= 0 ) continue;
      const float friction_force = -f_y * friction_coefficient;
      const float delta_v = friction_force * delta_t / ( point_mass*p->mass );
      const pNorm xzvel(p->vel.x,0,p->vel.z);
      if ( xzvel.magnitude <= delta_v ) {
        p->vel.x = 0;  p->vel.z = 0;
      }
      else
        p->vel -= delta_v * xzvel;
    }
}


#define TRY_XF_FEEDBACK(routine,vertex_count)                                 \
  for ( int feedback_tries = 0; ; feedback_tries++ )                          \
    {                                                                         \
      bool check = false;                                                     \
      glBeginTransformFeedbackNV(GL_POINTS); pError_Check();                  \
      if ( check )                                                            \
        glBeginQuery                                                          \
          (GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV,                       \
           query_transform_feedback_id );                                     \
      routine;                                                                \
      glEndTransformFeedbackNV();  pError_Check();                            \
      if ( !check ) break;                                                    \
      glEndQuery(GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV);                \
      int done_points = -1;                                                   \
      glGetQueryObjectiv                                                      \
        (query_transform_feedback_id,GL_QUERY_RESULT,&done_points);           \
      pError_Check();                                                         \
      if ( vertex_count == done_points ) break;                               \
      printf("Warning, xf only got %d points, trying again.\n",done_points);  \
      if ( feedback_tries > 10 ) pError_Exit();                               \
    }

void
Balloon::time_step_gpu(int steps)
{
  if ( world.opt_physics_method == GP_glp ) time_step_glp(steps);
  else                                      time_step_cuda(steps);
}

void
Balloon::init_glp()
{
  glp_initialized = true;

  glGenTextures(1,&glp_tri_data_tid);
  glGenTextures(1,&glp_vtx_data_tid);
  pError_Check();
  glGenQueries(1,&query_transform_feedback_id);
  pError_Check();

  glGenFramebuffersEXT(1,&framebuffer_id);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framebuffer_id);
  glGenRenderbuffersEXT(1, &renderbuffer_id);
  glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, renderbuffer_id);

  // GL_MAX_RENDERBUFFER_SIZE_EXT  Maximum size of either dimension.
  glRenderbufferStorageEXT  // p 610
    (GL_RENDERBUFFER_EXT, GL_FLOAT_RGBA_NV, 2, 2);
  glFramebufferRenderbufferEXT
    (GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER_EXT,
     renderbuffer_id);

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0 );
  glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, 0 );
  pError_Check();

  vs_plan_c.init("balloon-shader.cc","main_physics_plan_c();");
  stx_data_vtx = vs_plan_c.uniform_location("tex_data_vtx");
  stx_data_tri = vs_plan_c.uniform_location("tex_data_tri");
  sun_constants_sc = vs_plan_c.uniform_location("constants_sc");
  sun_constants_gas = vs_plan_c.uniform_location("constants_gas");
  sun_constants_dt = vs_plan_c.uniform_location("constants_dt");
  sun_platform = vs_plan_c.uniform_location("platform");
  sat_volume = vs_plan_c.attribute_location("volume");
  sat_indices = vs_plan_c.attribute_location("in_indices");
  sat_pos = vs_plan_c.attribute_location("in_pos");
  sat_vel = vs_plan_c.attribute_location("in_vel");
  svl_surface_normal = vs_plan_c.varying_location("out_surface_normal");
  svl_force_or_v = vs_plan_c.varying_location("out_force_or_v");
  svl_pos = vs_plan_c.varying_location("out_pos");
  svl_force_r = vs_plan_c.varying_location("out_force_r");
  vs_plan_c.print_active_varying();
  vs_plan_c.validate_once();
}

void
Balloon::time_step_glp(int steps)
{
  if ( !glp_initialized ) init_glp();

  cpu_data_to_glp();

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framebuffer_id);

  glDisable(GL_DEPTH_TEST);
  glDisable(GL_STENCIL_TEST);
  glDisable(GL_TEXTURE_2D);
  glDisable(GL_ALPHA_TEST);
  glEnable(GL_BLEND);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_ONE,GL_ONE);
  glClampColorARB(GL_CLAMP_VERTEX_COLOR_ARB,GL_FALSE);
  pError_Check();
  glClearColor( 0.0, 0.0, 0.0, 0.0 );

  pError_Check();

  vs_plan_c.use();

  glUniform1i(stx_data_vtx,0);
  glUniform1i(stx_data_tri,1);

  glUniform4f
    (sun_constants_sc,spring_constant,damping_v,
     pressure_factor_coeff,
     gas_m_over_temp);

  glUniform4f
    (sun_constants_gas,
     air_resistance, gas_mass_per_vertex,
     air_particle_mass, opt_gravity ? opt_gravity_accel : 0.0 );

  glUniform4f
    (sun_constants_dt,
     world.delta_t, rep_constant, point_mass, point_mass_inv);

  glUniform4f
    (sun_platform,
     world.platform_xmin, world.platform_xmax,
     world.platform_zmin, world.platform_zmax);

  const GLint svl_p1[] =
    { svl_surface_normal, svl_force_or_v, svl_pos, svl_force_r };
  glTransformFeedbackVaryingsNV
    (vs_plan_c.pobject, 4, &svl_p1[0], GL_INTERLEAVED_ATTRIBS_NV);
  pError_Check();

  GLP_Vtx_Data before = glp_vtx_data.data[0];

  if ( steps ) data_location = DL_GLP;

  pError_Check();

  glEnableClientState(GL_VERTEX_ARRAY);

  glActiveTexture(GL_TEXTURE0);  pError_Check();
  glBindTexture(GL_TEXTURE_BUFFER_EXT,glp_vtx_data_tid);   pError_Check();

  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,glp_tri_data_tid);  pError_Check();

  glEnableVertexAttribArray(sat_indices);

  for ( int i=0; i<steps; i++ )
    {
      const bool skip_volume = i + 1 != steps && true && ( i & 0x3 );

      //
      // Pass 1, Triangles
      //

      glActiveTexture(GL_TEXTURE0);
      glTexBufferEXT // Attaches to the active buffer texture.
        (GL_TEXTURE_BUFFER_EXT, GL_RGBA32F_ARB, glp_vtx_data.bid_read());

      glActiveTexture(GL_TEXTURE1);
      glBindTexture(GL_TEXTURE_BUFFER_EXT,0);

      const int tstride = sizeof(glp_tri_strc[0]);

      glp_tri_strc.bind();
      glVertexAttribIPointerEXT(sat_indices, 4, GL_INT, tstride, (void*)16);

      glVertexPointer(4, GL_FLOAT, sizeof(glp_tri_strc[0]), 0);
      glBindBuffer(GL_ARRAY_BUFFER,0);

      glBindBufferBaseNV
        (GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0, glp_tri_data.bid_fresh());
      pError_Check();

      if ( skip_volume )
        {
          glEnable(GL_RASTERIZER_DISCARD_NV);
        }
      else
        {
          glDisable(GL_RASTERIZER_DISCARD_NV);
          glClear(GL_COLOR_BUFFER_BIT);
        }
      TRY_XF_FEEDBACK( glDrawArrays(GL_POINTS,0,tri_count), tri_count);

      if ( !skip_volume )
        {
          glReadBuffer(GL_COLOR_ATTACHMENT0_EXT); pError_Check();
          pCoor pb[4];
          glReadPixels(0,0,2,2,GL_RGBA,GL_FLOAT,&pb[0]);
          pError_Check();
          centroid = (1.0/tri_count)*pb[0];
          volume = 0.5 * pb[0].w;
        }

      if ( false )
        {
          glp_tri_data.from_gpu();
          GLP_Tri_Data after_sf = glp_tri_data.data[0];
          pError_Msg("Check.");
        }

      //
      // Pass 2, Vertices
      //

      glEnable(GL_RASTERIZER_DISCARD_NV);
      glVertexAttrib1f(sat_volume,volume); pError_Check();

      glActiveTexture(GL_TEXTURE0);
      glBindTexture(GL_TEXTURE_BUFFER_EXT,0);

      glActiveTexture(GL_TEXTURE1);
      glBindTexture(GL_TEXTURE_BUFFER_EXT,glp_tri_data_tid);  pError_Check();
      glTexBufferEXT
        (GL_TEXTURE_BUFFER_EXT, GL_RGBA32F_ARB, glp_tri_data.bid);
      pError_Check();

      glp_vtx_strc.bind();
      const int vstride = sizeof(glp_vtx_strc[0]);
      glVertexPointer(2, GL_INT, vstride, 0);

      glVertexAttribIPointerEXT(sat_indices, 4, GL_INT, vstride, (void*)8);

      const int dvstride = sizeof(GLP_Vtx_Data);

      glp_vtx_data.bind();
      glVertexAttribPointer(sat_vel, 4, GL_FLOAT, false, dvstride, (void*)16);
      glVertexAttribPointer(sat_pos, 4, GL_FLOAT, false, dvstride, (void*)32);
      glEnableVertexAttribArray(sat_pos);
      glEnableVertexAttribArray(sat_vel);

      glBindBuffer(GL_ARRAY_BUFFER,0);
      glBindBufferBaseNV
        (GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0, glp_vtx_data.bid_write());
      pError_Check();

      TRY_XF_FEEDBACK( glDrawArrays(GL_POINTS,0,point_count), point_count);

      glDisableVertexAttribArray(sat_pos);
      glDisableVertexAttribArray(sat_vel);

      glp_vtx_data.bid_swap();
    }

  if ( steps && false )
    {
      glp_vtx_data.from_gpu();
      GLP_Vtx_Data after = glp_vtx_data.data[0];
      pError_Msg("Check.");
    }

  world.vs_fixed.use();

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableVertexAttribArray(sat_indices);

  glBindBuffer(GL_ARRAY_BUFFER,0);

  glClampColorARB(GL_CLAMP_VERTEX_COLOR_ARB,GL_TRUE);
  glDisable(GL_RASTERIZER_DISCARD_NV);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,0);
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,0);

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0 );

  data_bid = glp_vtx_data.bid_read();
  data_stride = sizeof(glp_vtx_data[0]);
  pressure_compute();

  pError_Check();
}

void
Balloon::cuda_data_partition()
{
  const int block_lg = CUDA_VTX_BLOCK_LG;
  const int block_size = 1 << block_lg;
  const int block_mask = block_size - 1;
  const int block_count = int(0.9999 + double(point_count) / block_size);
  for ( int i=0; i<tri_count; i++ ) triangles[i].block_number = -1;
  PStack<CUDA_Tri_Work_Strc> tri_work;
  PStack<int> work_sizes;
  int work_max = 0;
  for ( int i=0; i<block_count; i++ )
    {
      const int start = i * block_size;
      const int stop = start + block_size;
      int uniq_tris = 0;
      for ( int vi=start; vi<stop; vi++ )
        {
          Balloon_Vertex* const p = &points[vi];
          for ( int ti = 0; p->triangles.iterate(ti); )
            {
              Balloon_Triangle* const tri = &triangles[ti];
              if ( tri->block_number == i ) continue;
              tri->block_number = i;
              uniq_tris++;
              CUDA_Tri_Work_Strc* const tw = tri_work.pushi();
              tw->pi = int(tri->pi); tw->qi = int(tri->qi);
              tw->ri = int(tri->ri);
              tw->vi_opp0 = tw->vi_opp1 = tw->vi_opp2 = -1;
              tw->length_relaxed = float(ti);
            }
        }
      work_sizes += uniq_tris;
      work_max = max(work_max,uniq_tris);
    }

  printf("Cuda 1-pass exact iter per thread: %.1f\n",
         double(work_max)/block_size);

  tri_work_per_vtx_lg = int(0.998 + log2(double(work_max)/block_size));
  tri_work_per_vtx = 1 << tri_work_per_vtx_lg;
  ASSERTS( tri_work_per_vtx_lg <= 3 );
  const int work_per_block = tri_work_per_vtx * block_size;
  const int work_count = work_per_block * block_count;
  const int work_per_vtx_mask = tri_work_per_vtx - 1;

  CMX_SETUP3(cuda_tri_work_strc,a,pi);
  CMX_SETUP3(cuda_tri_work_strc,b,vi_opp0);
  CMX_SETUP3(cuda_tri_work_strc,length_relaxed,length_relaxed);
  CMX_SETUP3(cuda_tri_work_strc,c,pull_tid_0);

  cuda_tri_work_strc.alloc( work_count );
  cuda_tri_work_strc.disable_aos = false;
  int wi = 0;
  CUDA_Tri_Work_Strc tw_pad; memset(&tw_pad,-1,sizeof(tw_pad));
  int waste = 0;
  for ( int blk = 0; blk < block_count; blk++ )
    {
      const int amt = work_sizes[blk];
      CUDA_Tri_Work_Strc* const tw_blk =
        &cuda_tri_work_strc[blk * work_per_block];
      for ( int i=0; i<work_per_block; i++ )
        {
          const int idx =
            ( i & work_per_vtx_mask ) << block_lg | i >> tri_work_per_vtx_lg;
          tw_blk[idx] = i < amt ? tri_work[wi++] : tw_pad;
        }
      int pad = work_per_block - amt;
      waste += pad;
    }
  for ( int i=0; i<work_count; i++ ) cuda_tri_work_strc[i].pull_i = 0;
  int max_pull = 0;
  const int pull_limit = 4;
  for ( int i=0; i<work_count; i++ )
    {
      CUDA_Tri_Work_Strc* const tw = &cuda_tri_work_strc[i];
      if ( tw->pi == -1 ) continue;
      const int ti = int(tw->length_relaxed);
      Balloon_Triangle* const tri = &triangles[ti];
      typeof tri->pi_opp* const t_optr = &tri->pi_opp;
      const int blk = i / tri_work_per_vtx >> block_lg;
      const int tid = i & block_mask;
      const int round_base = i & ~block_mask;
      typeof tw->pi* const w_vptr = &tw->pi;
      for ( int v=0; v<3; v++ )
        {
          const int vi = w_vptr[v];
          const int vi_blk = vi >> block_lg;
          if ( vi_blk != blk ) continue;
          const int vi_tri = round_base + ( vi & block_mask );
          CUDA_Tri_Work_Strc* const tv = &cuda_tri_work_strc[vi_tri];
          typeof tv->vi_opp0* const w_optr = &tv->vi_opp0;
          typeof tv->pull_tid_0* const w_pptr = &tv->pull_tid_0;
          ASSERTS( tv->pull_i < pull_limit );
          w_optr[tv->pull_i] = t_optr[v];
          w_pptr[tv->pull_i] = tid;
          tv->pull_i++;
          if ( tv->pull_i > max_pull ) max_pull = tv->pull_i;
        }
    }
  for ( int i=0; i<work_count; i++ )
    {
      CUDA_Tri_Work_Strc* const tw = &cuda_tri_work_strc[i];
      tw->pull_i <<= 1;
      if ( tw->pi == -1 ) continue;
      const int ti = int(tw->length_relaxed);
      Balloon_Triangle* const tri = &triangles[ti];
      if ( tri->block_number != block_count )
        {
          tw->pull_i |= 1;
          tri->block_number = block_count;
        }
      tw->length_relaxed = tri->length_relaxed;
    }
}

void
Balloon::init_cuda()
{
  cuda_initialized = true;
  cuda_constants_stale = true;
  int device_count;
  cudaGetDeviceCount(&device_count);
  ASSERTS( device_count );
  const int dev = 0;
  cudaDeviceProp prop;
  CE(cudaGetDeviceProperties(&prop,dev));
  CE(cudaGLSetGLDevice(dev));
  printf
    ("GPU: %s @ %.2f GHz WITH %zd MiB GLOBAL MEM\n",
     prop.name, prop.clockRate/1e6, prop.totalGlobalMem >> 20);
  printf
    ("CAP: %d.%d  NUM MP: %d  TH/BL: %d  SHARED: %zd  CONST: %zd  "
     "# REGS: %d\n",
     prop.major, prop.minor,
     prop.multiProcessorCount, prop.maxThreadsPerBlock,
     prop.sharedMemPerBlock, prop.totalConstMem,
     prop.regsPerBlock
     );

  CE(cudaEventCreate(&world.frame_start_ce));
  CE(cudaEventCreate(&world.frame_stop_ce));

  CMX_SETUP3(cuda_vtx_strc,a,n0);
  CMX_SETUP3(cuda_vtx_strc,b,n4);
  CMX_SETUP3(cuda_vtx_strc,tri_idx_base,tri_idx_base);
  cuda_vtx_strc.use_aos = false;
  cuda_vtx_strc.ptrs_to_cuda_soa("vtx_strc_x");
  cuda_vtx_strc.to_cuda();

  CMX_SETUP3(cuda_tri_strc,a,pi);
  CMX_SETUP3(cuda_tri_strc,b,qi_opp);
  CMX_SETUP3(cuda_tri_strc,length_relaxed,length_relaxed);
  cuda_tri_strc.use_aos = false;
  cuda_tri_strc.ptrs_to_cuda_soa("tri_strc_x");
  cuda_tri_strc.to_cuda();

  cuda_tri_data.alloc(tri_count);
  cuda_tri_data.ptrs_to_cuda("tri_data");

  CMX_SETUP3(cuda_vtx_data,pos,pos);
  CMX_SETUP3(cuda_vtx_data,surface_normal,surface_normal);
  CMX_SETUP3(cuda_vtx_data,vel,vel);
  cuda_vtx_data.use_aos = false;
  cuda_vtx_data.disable_aos = false;
  cuda_vtx_data.alloc_locked(point_count);
  cuda_vtx_data.ptrs_to_cuda_soa("vtx_data_x0","vtx_data_x1");

  const int min_blk_size = min(CUDA_TRI_BLOCK_SIZE,CUDA_VTX_BLOCK_SIZE);
  const double max_block_count = ceil(double(tri_count)/min_blk_size);
  const int iter = int(ceil( max_block_count / min_blk_size ));
  const int tower_size = CUDA_VTX_BLOCK_SIZE * iter;

  cuda_tower_volumes.alloc(tower_size);
  cuda_tower_volumes.ptrs_to_cuda_array("tower_volumes");

  cuda_centroid_parts.alloc(tower_size);
  cuda_centroid_parts.ptrs_to_cuda("centroid_parts");

  cuda_data_partition();
  cuda_tri_work_strc.ptrs_to_cuda("tri_work_strc_x");
  cuda_tri_work_strc.ptrs_to_cuda_aos("tri_work_strc");
  cuda_tri_work_strc.to_cuda();
  TO_DEV(tri_work_per_vtx);
  TO_DEV(tri_work_per_vtx_lg);

  Dg_tri.x = int(ceil(double(tri_count)/CUDA_TRI_BLOCK_SIZE));
  Dg_tri.y = Dg_tri.z = 1;
  Db_tri.x = CUDA_TRI_BLOCK_SIZE;
  Db_tri.y = Db_tri.z = 1;

  Dg_vtx.x = int(ceil(double(point_count)/CUDA_VTX_BLOCK_SIZE));
  Dg_vtx.y = Dg_vtx.z = 1;
  Db_vtx.x = CUDA_VTX_BLOCK_SIZE;
  Db_vtx.y = Db_vtx.z = 1;

  for ( int i=0; i<2; i++ )
    {
      dim3 Dg = i==0 ? Dg_tri : Dg_vtx;
      dim3 Db = i==0 ? Db_tri : Db_vtx;
      const char* const pass = i==0 ? "Triangle" : "Vertex";

      const double warp_per_block = double(Db.x) / 32;
      const double block_per_mp = double(Dg.x) / prop.multiProcessorCount;
      const double warp_per_mp = ceil(warp_per_block) * block_per_mp;
      printf("\n%s pass block size %d thds, %d warps.\n",
             pass, Db.x, Db.x >> 5);
      printf("Grid size %d blks,  %.1f blks / MP,  %.1f warps / MP.\n",
             Dg.x,
             block_per_mp, warp_per_mp );
      const double warp_util = double(min(32u,Db.x))/32;
      const int data_dist = 2;
      const int latency_fp_warps = 24 / 4;
      const int latency_mem_warps = 400 / 4;

      // Assume no switch between blocks to hide fp latency.
      //
      const double lat_coverage_fp =
        min( warp_per_block * data_dist / latency_fp_warps, 1.0 );

      // Assume gpu does switch between blocks to hide mem latency.
      //
      const double lat_coverage_mem =
        min( warp_per_mp * data_dist / latency_mem_warps, 1.0 );

      printf("Approx CP util fp  %.3f * %.3f = %.3f (%.3f) for avg dist %d\n",
             warp_util, lat_coverage_fp,
             warp_util * lat_coverage_fp,
             warp_util * lat_coverage_fp * prop.multiProcessorCount,
             data_dist);

      printf("Approx CP util mem %.3f * %.3f = %.3f (%.3f) for avg dist %d\n",
             warp_util, lat_coverage_mem,
             warp_util * lat_coverage_mem,
             warp_util * lat_coverage_mem * prop.multiProcessorCount,
             data_dist);
    }
}


void
Balloon::time_step_cuda(int steps)
{
  static int cuda_iteration = 0;
  cuda_iteration++;

  if ( !cuda_initialized ) init_cuda();

  CE(cudaEventRecord(world.frame_start_ce,0));
  cpu_data_to_cuda();

  if ( cuda_constants_stale )
    {
      cuda_constants_stale = false;
      TO_DEV_DS(volume_cpu,volume);  // For debugging, not used by gpu.
      TO_DEV(tri_count);
      TO_DEV(point_count);
      TO_DEV(tethered_idx);

      TO_DEV(spring_constant);
      TO_DEV(damping_v);
      TO_DEV(pressure_factor_coeff);
      TO_DEV(gas_m_over_temp);

      TO_DEV(air_resistance);
      TO_DEV(gas_mass_per_vertex);
      TO_DEV(air_particle_mass);
      float gravity_mag = opt_gravity ? opt_gravity_accel : 0;
      TO_DEV(gravity_mag);
      TO_DEV(opt_gravity);

      TO_DEV_OM_F(world,delta_t);
      TO_DEV(rep_constant);
      TO_DEV(point_mass);
      TO_DEV(point_mass_inv);

      TO_DEV_OM(world,platform_xmin);
      TO_DEV_OM(world,platform_xmax);
      TO_DEV_OM(world,platform_zmin);
      TO_DEV_OM(world,platform_zmax);
      cuda_tower_volumes.set_primary();
    }

  const CUDA_Vtx_Data vtest = cuda_vtx_data[42];
  const int pos_array_chars =
    point_count * sizeof(cuda_vtx_data.sample_soa.pos[0]);

  if ( steps ) data_location = DL_CUDA;
  const bool two_pass = world.opt_physics_method == GP_cuda_2_pass;

  for ( int i=0; i<steps; i++ )
    {
      CUDA_Vtx_Data* const vtx_data_in_d = cuda_vtx_data.get_dev_addr_read();
      const int read_side = cuda_vtx_data.current;
      const int write_side = 1 - read_side;

      if ( two_pass )
        {
          pass_triangles_launch
            (Dg_tri, Db_tri, write_side,
             &cuda_vtx_data.shadow_soa[read_side],
             vtx_data_in_d, pos_array_chars);

          pass_vertices_launch
            (Dg_vtx, Db_vtx, write_side,
             cuda_tri_data.get_dev_addr(), cuda_tri_data.chars);
        }
      else
        {
          pass_unified_launch
            (Dg_vtx, Db_vtx, write_side,
             &cuda_vtx_data.shadow_soa[read_side], pos_array_chars);

          cuda_tower_volumes.swap();
        }

      cuda_vtx_data.swap();
    }

  if ( false )
    {
      // Due to a CUDA bug this is slower than just copying through host.
      cuda_vtx_data.cuda_to_gl();
      //  cuda_centroid_parts.from_cuda();
      data_bid = cuda_vtx_data.bid;
      data_stride = sizeof(cuda_vtx_data[0]);
    }
  else
    {
      cuda_data_to_cpu();
    }

  {
    cuda_tower_volumes.from_cuda();
    const int blocks = two_pass ? Dg_tri.x : Dg_vtx.x;
    volume = 0;
    for ( int i=0; i<blocks; i++ ) volume += cuda_tower_volumes[i];
  }

  CE(cudaEventRecord(world.frame_stop_ce,0));
  CE(cudaEventSynchronize(world.frame_stop_ce));
  float cuda_time = -1.1;
  CE(cudaEventElapsedTime(&cuda_time,world.frame_start_ce,world.frame_stop_ce));
  world.frame_timer.cuda_frame_time_set(cuda_time);

  CUDA_Vtx_Data vtest_aftera = cuda_vtx_data[42];

  if ( !opt_cpu_interleave )
    {
      centroid_compute();
      pressure_compute();
    }

#undef TO_DEV
#undef TO_DEV_OM
}

void
Balloon::gpu_data_to_cpu()
{
  if ( world.opt_physics_method == GP_glp ) glp_data_to_cpu();
  else                                      cuda_data_to_cpu();
}

void
Balloon::glp_data_to_cpu()
{
  if ( data_location & DL_CPU ) return;
  data_location |= DL_CPU;
  glp_vtx_data.from_gpu();
  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      GLP_Vtx_Data* const g = &glp_vtx_data[idx];
      p->pos = g->pos;
      p->vel = g->vel;
      p->surface_normal = g->surface_normal;
    }
}

void
Balloon::cuda_data_to_cpu()
{
  if ( data_location & DL_CPU ) return;
  data_location |= DL_CPU;
  cuda_vtx_data.from_cuda();
  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      vec_sets(p->pos,cuda_vtx_data.soa.pos[idx]);
      vec_sets4(p->vel,cuda_vtx_data.soa.vel[idx]);
      vec_sets4(p->surface_normal,cuda_vtx_data.soa.surface_normal[idx]);
    }
}

void
Balloon::cpu_data_to_glp()
{
  if ( data_location & DL_GLP ) return;
  data_location |= DL_GLP;

  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      GLP_Vtx_Data* const g = &glp_vtx_data[idx];
      g->pos = p->pos;
      g->vel = p->vel;
      g->surface_normal = p->surface_normal;
    }

  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      GLP_Tri_Strc* const td = &glp_tri_strc[idx];
      td->length_relaxed = tri->length_relaxed;
    }

  glp_vtx_data.to_gpu();
  glp_vtx_strc.to_gpu();
  glp_tri_strc.to_gpu();
  glBindBuffer(GL_ARRAY_BUFFER,0);
}

bool
Balloon::cpu_data_to_cuda()
{
  if ( data_location & DL_CUDA ) return false;
  data_location |= DL_CUDA;

  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      CUDA_Vtx_Data* const g = &cuda_vtx_data[idx];
      vec_set(g->pos,p->pos);
      vec_set(g->vel,p->vel);
    }

  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      CUDA_Tri_Strc* const tc = &cuda_tri_strc[idx];
      tc->length_relaxed = tri->length_relaxed;
    }

  for ( int idx=1; idx<cuda_tower_volumes.elements; idx++ )
    cuda_tower_volumes[idx] = 0;
  cuda_tower_volumes[0] = volume;
  cuda_tower_volumes.set_primary();
  cuda_tower_volumes.to_cuda();
  cuda_tower_volumes.swap();
  cuda_tower_volumes.to_cuda();
  cuda_tower_volumes.set_primary();

  cuda_tri_strc.to_cuda();  // OPT: Only send if dirty.
  cuda_vtx_data.to_cuda();
  cuda_vtx_strc.to_cuda();  // OPT: Only send if dirty.
  return true;
}


// Display a tetrahedron, used to indicate light position.
//
void
insert_tetrahedron(pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
  static pColor c1(0xffffff);
  static pColor c2(0xff00);

  glDisable(GL_LIGHTING);

#define TRI(va,vb,vc)                                                         \
  {                                                                           \
    pVect n = cross(va,vb,vc);                                                \
    glNormal3fv(n);                                                           \
    glColor3fv(c1);  glVertex3fv(va);                                         \
    glColor3fv(c2);  glVertex3fv(vb);                                         \
    glVertex3fv(vc);                                                          \
  }

  glBegin(GL_TRIANGLES);
  TRI(v0,v1,v2); TRI(v0,v2,v3); TRI(v0,v3,v1);
  glEnd();

# undef TRI

  glEnable(GL_LIGHTING);
}

void
tube_tapered(pCoor base, float radius, pVect to_apex)
{
  const int sides = 10;
  const double delta_theta = 2 * M_PI / sides;
  const double base_radius = 1;
  const double apex_radius = 0.1;
  const double apex_height = 1;
  const double alpha = atan2(apex_height,base_radius-apex_radius);
  const double vec_z = sin(alpha);
  const float to_height = to_apex.mag();
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  pVect from_apex(0,0,1);
  pVect rn(from_apex,to_apex);
  const float rot_angle = pangle(from_apex,to_apex);
  glTranslatef(base.x,base.y,base.z);
  glRotatef(rot_angle * 180.0 / M_PI,rn.x,rn.y,rn.z);
  glScalef(radius,radius,to_height);
  glBegin(GL_QUAD_STRIP);
  for ( int i=0; i<=sides; i++ )
    {
      const double theta = delta_theta * i;
      const double cos_t = cos(theta);
      const double sin_t = sin(theta);
      glNormal3f( cos_t, sin_t, vec_z );
      glVertex3f( apex_radius * cos_t, apex_radius * sin_t, apex_height);
      glVertex3f( base_radius * cos_t, base_radius * sin_t, 0);
    }
  glEnd();
  glPopMatrix();
}


void
World::render()
{
  cb_keyboard();
  frame_timer.frame_start();

  if ( opt_physics_method == GP_cpu ) balloon.gpu_data_to_cpu();

  if ( world_time == 0 ) world_time = time_wall_fp();

  if ( opt_pause )
    {
      world_time = time_wall_fp();
    }
  else
    {
      const double time_start = time_wall_fp();

      // If we are recording a video base world time on video frame
      // rate rather than wall clock time.
      //
      if ( ogl_helper.animation_record )
        world_time = time_start - ogl_helper.frame_period;

      // Advance simulated time.
      //
      const double sim_time_needed = time_start - world_time;
      delta_t = 1.0 / ( 30 * ( opt_physics_method ? 40 : 20 ) ) ;
      const int time_steps_needed = int( sim_time_needed / delta_t );
      const int time_steps = min(time_steps_needed,100);
      balloon.update_for_config();
      if ( opt_physics_method &&
           ( balloon.need_cpu_iteration || balloon.opt_cpu_interleave ) )
        balloon.time_step_cpu_once();
      if ( opt_physics_method ) balloon.time_step_gpu(time_steps);
      else balloon.time_step_cpu(time_steps);
      frame_timer.work_amt_set(time_steps);
      world_time += delta_t * time_steps;
    }

  // Rescue balloon if it is sinking into the abyss.
  //
  if ( balloon.centroid.y < -50 )
    {
      pVect rescue_vector = pCoor(0,12,-12) - balloon.centroid;
      balloon.translate(rescue_vector);
    }

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
    ("Physics Computation: %s ('a' to change) "
     "  + %d cpu timestep / frame ('x' to change)\n",
     gpu_physics_method_str[opt_physics_method],
     balloon.opt_cpu_interleave);

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  pCoor cent = balloon.centroid;
  pCoor vel = balloon.velocity_avg();

  ogl_helper.fbprintf
    ("Centroid  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]  "
     "Gas Amt %.2f  Volume  %.2f  Pressure %.2f\n",
     cent.x,cent.y,cent.z,
     vel.x,vel.y,vel.z,
     balloon.gas_amount,
     balloon.volume / balloon.nom_volume,
     balloon.pressure
     );

  ogl_helper.fbprintf
    ("Weight (Surf+Gas-Displ Air=W) (%6.2f + %6.2f - %6.2f = %6.2f)\n",
     balloon.opt_gravity_accel * balloon.surface_mass,
     balloon.opt_gravity_accel * balloon.volume * balloon.density_gas,
     balloon.opt_gravity_accel * balloon.volume * balloon.density_air,
     balloon.opt_gravity_accel * balloon.surface_mass
     + balloon.opt_gravity_accel * balloon.volume * balloon.density_gas
     - balloon.opt_gravity_accel * balloon.volume * balloon.density_air
     );

  ogl_helper.fbprintf("Oversample %3.1f\n", balloon.oversample);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  const int half_elements = platform_tile_coords.elements >> 3 << 2;
  const int vstride = sizeof(Balloon_Vertex);

  if ( opt_surface_smooth )
    {
      //
      // Render balloon reflection.  (Will be blended with dark tiles.)
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

      // Prepare to write only stenciled locations.
      //
      glStencilFunc(GL_EQUAL,2,2);
      glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

      // Use a transform that reflects objects to other size of platform.
      //
      glMatrixMode(GL_PROJECTION);
      glPushMatrix();
      glMultTransposeMatrixf(transform_mirror);

      // Reflected front face should still be treated as the front face.
      //
      glFrontFace(GL_CW);

      glColor3fv(color_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,scolor_ball);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);

      glBindTexture(GL_TEXTURE_2D,balloon.texid_pse);

      balloon.tex_coords.bind();
      glTexCoordPointer(2,GL_FLOAT,0,NULL);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);

      if ( balloon.data_bid )
        {
          glBindBuffer(GL_ARRAY_BUFFER,balloon.data_bid);
          glVertexPointer
            (3, GL_FLOAT, balloon.data_stride, (void*)( 2 * sizeof(pCoor) ));
          glNormalPointer(GL_FLOAT, balloon.data_stride, NULL );
        }
      else
        {
          glBindBuffer(GL_ARRAY_BUFFER,0);
          glVertexPointer(4, GL_FLOAT, vstride, &balloon.points[0].pos);
          glNormalPointer(GL_FLOAT, vstride, &balloon.points[0].surface_normal);
        }

      glEnableClientState(GL_VERTEX_ARRAY);
      glEnableClientState(GL_NORMAL_ARRAY);

      balloon.point_indices.bind(GL_ELEMENT_ARRAY_BUFFER);

      glDrawElements
        (GL_TRIANGLES,balloon.point_indices.elements,GL_UNSIGNED_INT, NULL);

      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);
      glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      glBindBuffer(GL_ARRAY_BUFFER,0);

      glFrontFace(GL_CCW);
      glPopMatrix();
      glDisable(GL_STENCIL_TEST);
    }

  {
    //
    // Write framebuffer stencil with balloon's shadow.
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

    if ( balloon.data_bid )
      {
        glBindBuffer(GL_ARRAY_BUFFER,balloon.data_bid);
        glVertexPointer
          (3, GL_FLOAT, balloon.data_stride, (void*)( 2 * sizeof(pCoor) ));
      }
    else
      glVertexPointer(4, GL_FLOAT, vstride, &balloon.points[0].pos);
    glEnableClientState(GL_VERTEX_ARRAY);
    balloon.point_indices.bind(GL_ELEMENT_ARRAY_BUFFER);
    glDrawElements
      (GL_TRIANGLES,balloon.point_indices.elements,GL_UNSIGNED_INT, NULL);
    glDisableClientState(GL_VERTEX_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER,0);

    glEnable(GL_LIGHTING);
    glDisable(GL_STENCIL_TEST);
    glPopMatrix();
  }

  // Setup texture for platform.
  //
  glBindTexture(GL_TEXTURE_2D,balloon.texid_syl);

  // Blend dark tiles with existing balloon reflection.
  //
  glEnable(GL_STENCIL_TEST);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_CONSTANT_ALPHA,GL_ONE_MINUS_CONSTANT_ALPHA); // src, dst
  glBlendColor(0,0,0,0.5);

  glDepthFunc(GL_ALWAYS);
  glNormal3f(0,1,0);

  if ( opt_surface_smooth )
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

      if ( opt_surface_smooth ) glEnable(GL_TEXTURE_2D);

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
  glBindBuffer(GL_ARRAY_BUFFER,0);

  glDepthFunc(GL_LESS);
  glDisable(GL_TEXTURE_2D);
  glDisable(GL_STENCIL_TEST);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glMaterialf(GL_BACK,GL_SHININESS,shininess_ball);

  //
  // Render Balloon
  //
  if ( opt_surface_smooth )
    {
      // With Textures

      const int vstride = sizeof(Balloon_Vertex);

      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D,balloon.texid_pse);

      glColor3fv(color_ball);
      glMaterialfv(GL_BACK,GL_SPECULAR,scolor_ball);
      glColorMaterial(GL_BACK,GL_AMBIENT_AND_DIFFUSE);
      pColor color_red(0.9,0.2,0.2);
      glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE,color_red);
      glMaterialfv(GL_FRONT,GL_SPECULAR,dark);

      balloon.tex_coords.bind();
      glTexCoordPointer(2,GL_FLOAT,0,NULL);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);

      if ( balloon.data_bid )
        {
          glBindBuffer(GL_ARRAY_BUFFER,balloon.data_bid);
          glVertexPointer
            (3, GL_FLOAT, balloon.data_stride, (void*)( 2 * sizeof(pCoor) ));
          glNormalPointer(GL_FLOAT, balloon.data_stride, NULL );
        }
      else
        {
          glBindBuffer(GL_ARRAY_BUFFER,0);
          glVertexPointer(4, GL_FLOAT, vstride, &balloon.points[0].pos);
          glNormalPointer(GL_FLOAT, vstride, &balloon.points[0].surface_normal);
        }

      glEnableClientState(GL_VERTEX_ARRAY);
      glEnableClientState(GL_NORMAL_ARRAY);
      balloon.point_indices.bind(GL_ELEMENT_ARRAY_BUFFER);

      glDrawElements
        (GL_TRIANGLES,balloon.point_indices.elements,GL_UNSIGNED_INT, NULL);

      glDisableClientState(GL_VERTEX_ARRAY);
      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      glDisable(GL_TEXTURE_2D);
      glBindBuffer(GL_ARRAY_BUFFER,0);
    }
  else
    {
      // With Colored Stripes

      balloon.gpu_data_to_cpu();
      glMaterialfv(GL_BACK,GL_SPECULAR,scolor_ball);
      glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
      glBegin(GL_TRIANGLES);

      for ( int idx = 0;  idx < balloon.tri_count; idx++ )
        {
          Balloon_Triangle* const tri = &balloon.triangles[idx];
          Balloon_Vertex* const p = &balloon.points[tri->pi];
          Balloon_Vertex* const q = &balloon.points[tri->qi];
          Balloon_Vertex* const r = &balloon.points[tri->ri];

          glColor3fv( tri->color * color_ball );

          const bool true_normal = false;
          if ( !true_normal )
            {
              pVect norm(q->pos,p->pos,r->pos);
              norm.normalize();
              glNormal3fv(norm);
            }

          if ( true_normal ) glNormal3fv(p->surface_normal);
          glVertex4fv(p->pos);
          if ( true_normal ) glNormal3fv(q->surface_normal);
          glVertex4fv(q->pos);
          if ( true_normal ) glNormal3fv(r->surface_normal);
          glVertex4fv(r->pos);

        }
      glEnd();

    }

  insert_tetrahedron(light_location,0.05);

  pError_Check();

  glColor3f(0,1,0); // This sets the text color. Don't know why.

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

  balloon.gpu_data_to_cpu();
  balloon.data_location = DL_CPU;
  balloon.data_bid = 0;
  balloon.cuda_constants_stale = true;

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_F8:
    break;
    ogl_helper.write_img("syl_img.eps");
    system("cd /home/faculty/koppel/teach/gpup11; tex gpup.tex; dvips gpup.dvi; pstopng -w2000 gpup.ps");
    pBuild_Texture_File
      ("/home/faculty/koppel/teach/gpup11/gpup.png",
       false,255, balloon.texid_syl);
    break;

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
  case 'A':
    if ( opt_physics_method )
      { opt_physics_method_last = opt_physics_method;
        opt_physics_method = GP_cpu; }
    else
      { opt_physics_method = opt_physics_method_last; }
    break;
  case 'a':
    opt_physics_method++;
    if ( opt_physics_method == GP_ENUM_SIZE ) opt_physics_method = 0;
    break;
  case 'b': opt_move_item = MI_Balloon; break;
  case 'B': opt_move_item = MI_Balloon_V; break;
  case 'd': case 'D': balloon.opt_damping = !balloon.opt_damping; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': balloon.opt_gravity = !balloon.opt_gravity; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_surface_smooth = !opt_surface_smooth; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'r': case 'R': balloon.length_relaxed_update = true; break;
  case 's': balloon.stop(); break;
  case 'S': balloon.freeze(); break;
  case 'x': balloon.opt_cpu_interleave = !balloon.opt_cpu_interleave; break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

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
      //  pMatrix_Rotation rotall(eye_direction,pVect(0,0,-1));
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Balloon: balloon.translate(adjustment); break;
      case MI_Balloon_V: balloon.push(adjustment); break;
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
