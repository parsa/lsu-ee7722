/// LSU EE 7700-1 (Sp 2009), Graphics Processors
//
 /// Balloon Simulation, Under construction.

// $Id:$

 /// Purpose
//
//   Demonstrate use of gpu for physics.



#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>
#include <Magick++.h>

#include "../opengl/util.h"
#include "glextfuncs.h"
#include "../opengl/coord.h"
#include "../opengl/shader.h"
#include "../opengl/pstring.h"
#include "../opengl/misc.h"

template <typename T>
class pBuffer_Object {
public:
  pBuffer_Object(){ data = NULL; init(); }
  ~pBuffer_Object()
  {
    if ( data ) free(data);
    glDeleteBuffers(created,bids);
  }

private:
  void init()
  {
    btarget = GL_ARRAY_BUFFER;
    glGenBuffers(2, bids);
    current = 0;
    bid = bids[current];
    created = 0;
    pError_Check();
    usage_hint = GL_DYNAMIC_COPY;
  }

public:
  T* alloc(int elements_p, GLenum hint = GL_DYNAMIC_COPY)
  {
    usage_hint = hint;
    if ( data ) pError_Msg("Double allocation of pBuffer_Object.");
    elements = elements_p;
    chars = elements * sizeof(T);
    data = new T[elements];
    created = 1;
    alloc_gpu_buffer();
    glBindBuffer(btarget,0);
    return data;
  }

  void take(PStack<T>& stack, GLenum hint = GL_DYNAMIC_COPY,
            GLenum default_target = GL_ARRAY_BUFFER)
  {
    usage_hint = hint;
    btarget = default_target;
    if ( data ) pError_Msg("Double allocation of pBuffer_Object.");
    elements = stack.occ();
    chars = elements * sizeof(T);
    data = stack.take_storage();
    created = 1;
    alloc_gpu_buffer();
    glBindBuffer(btarget,0);
  }

  void prepare_two_buffers()
  {
    ASSERTS( created == 1 );
    created = 2; bid_swap(); alloc_gpu_buffer(); bid_swap();
  }

private:
  void alloc_gpu_buffer()
  {
    bind();
    glBufferData(btarget,chars,NULL,usage_hint);
    pError_Check();
  }

public:
  void to_gpu()
  {
    bind();
    glBufferData(btarget, chars, data, usage_hint);
    pError_Check();
  }

  void from_gpu()
  {
    bind();
    T* const from_data = (T*)glMapBuffer(GL_ARRAY_BUFFER,GL_READ_ONLY);
    pError_Check();
    memcpy(data,from_data,chars);
    glUnmapBuffer(btarget);
    glBindBuffer(btarget,0);
  }

  void bind(GLenum target){ glBindBuffer(target,bid); }
  void bind(){ glBindBuffer(btarget,bid); }

  GLuint bid_read() const { return bids[current]; }
  GLuint bid_write()
  {
    bid_swap(); alloc_gpu_buffer(); bid_swap();
    return bids[1-current];
  }
  GLuint bid_fresh()
  {
    alloc_gpu_buffer();
    return bid;
  }

  void bid_swap()
  {
    current = 1 - current;
    bid = bids[current];
  }

  T& operator [] (int idx) { return data[idx]; }

  GLuint bids[2];
  GLuint bid;
  GLenum usage_hint;
  GLenum btarget;
  int created, current;
  T *data;
  int elements, chars;
};

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

int
pBuild_Texture_File
(const char *name, bool invert = false, int transp = 256 )
{
  GLenum gluerr;
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;
  if ( invert ) image.color_invert();
  GLuint tid;
  glGenTextures(1,&tid);
  glBindTexture(GL_TEXTURE_2D,tid);
  if ( ( gluerr =
	 gluBuild2DMipmaps
	 (GL_TEXTURE_2D,
	  GL_RGBA,
	  //  GL_DEPTH_COMPONENT,
	  image.width, image.height,
          image.gl_fmt, image.gl_type,
          (void *)image.data))) {

      pStringF msg("GLULib%s\n",gluErrorString(gluerr));
      pError_Msg(msg.s);
   }

   return tid;
}


class World;

struct Balloon_Spring {
  float length_relaxed;
  int vtx_in; // Index in points array.
};

struct Balloon_Triangle {
  int pi, qi, ri;
  pColor color;
  float length_relaxed;
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
  pVect surface_normal;

  // Only used during initialization.
  int edge_in_count;
  int edge_in[6];
  double eta;
  double theta;
  int ring;
};

struct BV_GPU_Data_Tri {
  pCoor surface_normal;
  pCoor force;
  pCoor padding;
};

struct BV_GPU_Data_Vtx {
  pCoor surface_normal;
  pCoor vel;
  pCoor pos;
};

struct BV_GPU_Plan_C_Triangle_Data {
  float pi, qi, ri;
  float length_relaxed;
};

struct BV_GPU_Plan_C_Vertex_Data {
  float self_idx;
  float left_idx;
  int16_t neighbors[8];
};

class Balloon {
public:
  Balloon(World& w):world(w)
  {
  }
  ~Balloon(){ }
  void init(pCoor center, double radius);
  void update_for_config();
  void update_for_volume();
  void time_step_cpu(int steps);
  void time_step_cpu_once();
  void time_step_gpu(int steps);
  void gpu_data_to_cpu();
  void cpu_data_to_gpu();
  void translate(pVect amt);
  void push(pVect amt);
  pVect velocity_avg()
  {
    pVect vel_avg(0,0,0);
    for ( int i=0; i<point_count; i++ ) vel_avg += points[i].vel;
    vel_avg *= 1.0/point_count;
    return vel_avg;
  }
  void stop()
  {
    pVect avg_vel = velocity_avg();
    for ( int i=0; i<point_count; i++ ) points[i].vel -= avg_vel;
  }
  void freeze()
  {
    for ( int i=0; i<point_count; i++ ) points[i].vel = pVect(0,0,0);
  }

  World& world;

  GLuint texid_pse, texid_syl;

  PStack<Balloon_Vertex> points;
  PStack<Balloon_Triangle> triangles;
  pBuffer_Object<GLuint> point_indices;
  pBuffer_Object<float> tex_coords;
  int point_count;
  int tri_count;
  float radius;
  int tethered_idx;

  int cpu_iteration;

  float spring_constant;
  float damping_factor;
  float surface_mass;
  float gas_amount;
  float particle_mass;
  float air_particle_mass;
  float air_pressure_factor;

  float nom_volume; // nominal

  float volume;
  float area;
  float temperature;
  pCoor centroid;

  // Computed after each change to user-set physical quantity.
  //
  float temp_ratio;  // Temperature ratio.

  // Computed each time step
  //
  float gas_m_over_temp;  // Coefficient in pressure formula.
  float pressure;

  double e_spring, e_kinetic;
  double energy, e_zero;

  bool opt_gravity;
  bool opt_damping;
  float opt_gravity_accel;
  bool opt_surface_fix;
  bool length_relaxed_update;
  bool need_cpu_iteration;

  float point_mass;
  float point_mass_inv;
  float damping_factor_per_step;
  float damping_v;
  double oversample;
  double tightness;

  bool gpu_data_stale;
  bool cpu_data_stale;
  pBuffer_Object<BV_GPU_Data_Vtx> gpu_data_vtx;
  pBuffer_Object<BV_GPU_Data_Tri> gpu_data_tri;
  pBuffer_Object<BV_GPU_Plan_C_Vertex_Data> gpu_plan_c_vertex_data;
  pBuffer_Object<BV_GPU_Plan_C_Triangle_Data> gpu_plan_c_triangle_data;

  GLuint query_transform_feedback_id;
  GLuint gpu_data_vtx_tid;
  GLuint gpu_data_tri_tid;
  GLuint framebuffer_id, renderbuffer_id;
  pShader vs_plan_c;
  GLint sat_indices, sat_volume, sat_pos, sat_vel;
  GLint sun_constants_sc;
  GLint sun_constants_gas, sun_constants_dt, sun_platform;
  GLint svl_surface_normal, svl_force_or_v, svl_pos;
  GLint stx_data_vtx, stx_data_tri;

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

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  double delta_t;

  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;

  Balloon balloon;
  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Balloon, MI_Balloon_V, MI_COUNT } opt_move_item;
  bool opt_pause;
  bool opt_gpu;
  bool opt_surface_smooth;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_shadow;

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
  balloon.gpu_data_stale = true;
  balloon.cpu_data_stale = false;
  eye_location = pCoor(24.2,11.6,-38.7);
  eye_direction = pVect(-0.42,-0.09,0.9);
  opt_move_item = MI_Eye;
  opt_light_intensity = 100.2;
  opt_gpu = true;
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
  balloon.opt_surface_fix = true;
  balloon.damping_factor = 0.2;
  balloon.spring_constant = 21000.0;
  balloon.gas_amount = 0;
  balloon.surface_mass = 1000;
  balloon.e_zero = 0;
  balloon.opt_gravity_accel = 9.8;
  balloon.particle_mass = 0.01;
  balloon.air_particle_mass = 0.01;
  balloon.temperature = 300;
  opt_pause = false;
  variable_control.insert(balloon.gas_amount,"Gas Amount");
  variable_control.insert(balloon.opt_gravity_accel,"Gravity");
  variable_control.insert(balloon.temperature,"Temperature");
  variable_control.insert(balloon.damping_v,"Damping Factor");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(balloon.particle_mass,"Particle Mass");
  variable_control.insert(balloon.spring_constant,"Spring Constant");
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
  static const double two_pi = 2 * M_PI;
  const double equator_interpoint_radians = two_pi / equator_points;
  const double equator_interpoint = r * equator_interpoint_radians;
  const double epsilon = 0.00001;
  point_count = 0;

  Balloon_Vertex* const pole_south = points.pushi();
  pole_south->mass_inv = 1;
  pole_south->theta = 10;
  pole_south->pos = center + pVect(0,0,r);
  pole_south->vel = pVect(0,0,0);
  pole_south->ring = 0;
  pole_south->eta = 0;
  point_count++;

  const double first_circum = equator_interpoint * 6 + epsilon;
  const double first_eta = asin( first_circum / ( 2 * M_PI * r ) );
  const int rings =
    int(0.5 + ( M_PI - 2 * first_eta ) / equator_interpoint_radians);
  const double delta_eta = ( M_PI - 2 * first_eta - epsilon ) / max(1,rings);
  int ring_count = 0;
  PStack<int> rings_first_idx;
  rings_first_idx += 0;

  for ( double eta = first_eta; eta <= M_PI-first_eta; eta += delta_eta )
    {
      ring_count++;
      const double z = r * cos(eta);
      const double slice_r = r * sin(eta);
      const int slice_points = int( two_pi * slice_r / equator_interpoint );
      const double delta_theta = two_pi / slice_points;
      const int ring_first_idx = point_count;
      const int lower_ring_first_idx = rings_first_idx.peek();
      rings_first_idx += point_count;

      int lower_ring_idx = point_count - 1;
      if ( points[lower_ring_idx].theta < two_pi - delta_theta )
        lower_ring_idx = lower_ring_first_idx;
      const int lower_ring_first_connected = lower_ring_idx;
      double lower_ring_angle_adj =
        lower_ring_idx == lower_ring_first_idx ? 0 : -two_pi;
      const double theta_first = ring_count & 1 ? 0 : delta_theta * 0.5;

      int slice_idx = 0;
      for ( double theta = theta_first; theta < two_pi - 0.001;
            theta += delta_theta )
        {
          Balloon_Vertex* const point = points.pushi();
          point->mass_inv = 1;
          point->ring = ring_count;
          point->eta = eta;
          point->theta = theta;
          point->pos = center +
            pVect(slice_r * cos(theta), slice_r * sin(theta), z );
          point->vel = pVect(0,0,0);
          point->edge_out[point->edge_out_count++] =
            point_count - 1 + ( slice_idx ? 0 : slice_points );

          const double next_theta = theta + delta_theta;
          while ( true )
            {
              point->edge_out[point->edge_out_count++] = lower_ring_idx;
              const bool lr_last = lower_ring_idx + 1 == ring_first_idx;
              const int next_idx =
                lr_last ? lower_ring_first_idx : lower_ring_idx + 1;
              Balloon_Vertex* const n_lr_next = &points[next_idx];
              const double next_angle_adj =
                lower_ring_angle_adj + ( lr_last ? two_pi : 0 );
              const double lower_ring_angle = n_lr_next->theta + next_angle_adj;
              if ( lower_ring_angle > next_theta + 0.0001 ) break;
              if ( slice_idx > 1 &&
                   lower_ring_idx == lower_ring_first_connected ) break;
              lower_ring_idx = next_idx;
              lower_ring_angle_adj = next_angle_adj;
            }

          slice_idx++;  point_count++;
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

      if ( p->pos.y < min_y ) { tethered_idx = idx;  min_y = p->pos.y; }

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

      p->tex_coor.x = 1 - ( p->theta - tex_theta_min ) * theta_to_s;
      p->tex_coor.y = 1 - ( p->eta - tex_eta_min ) * eta_to_s;
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

  // texid_pse = pBuild_Texture_File("avatar2.png");
  texid_pse = pBuild_Texture_File("mult.png",false,255);
  tex_coords.take(gpu_tex_coords,GL_STATIC_DRAW);
  tex_coords.to_gpu();
  texid_syl = pBuild_Texture_File("gp.png",false,255);

  point_indices.take(p_indices,GL_STATIC_DRAW,GL_ELEMENT_ARRAY_BUFFER);
  point_indices.to_gpu();

  gpu_data_vtx.alloc(point_count,GL_DYNAMIC_COPY);
  gpu_data_vtx.prepare_two_buffers();
  gpu_data_tri.alloc(tri_count,GL_DYNAMIC_COPY);
  gpu_data_tri.prepare_two_buffers();
  gpu_plan_c_vertex_data.alloc(point_count,GL_STATIC_DRAW);
  gpu_plan_c_triangle_data.alloc(tri_count,GL_STATIC_DRAW);

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      BV_GPU_Plan_C_Vertex_Data* const vd = &gpu_plan_c_vertex_data[idx];
      vd->self_idx = float( 3 * idx );
      vd->left_idx = 0.5;
      int np = 0;
      for ( int ti = 0; p->triangles.iterate(ti); )
        {
          vd->neighbors[np++] = 3 * ti;
        }
      ASSERTS( np < 8 );
      while ( np < 8 ) vd->neighbors[np++] = 1;
    }

  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      BV_GPU_Plan_C_Triangle_Data* const td = &gpu_plan_c_triangle_data[idx];
      td->pi = float(tri->pi * 3);
      td->qi = float(tri->qi * 3);
      td->ri = float(tri->ri * 3);
      td->length_relaxed = tri->length_relaxed;
    }
}

void
Balloon::update_for_config()
{
  if ( !world.opt_gpu )
    {
      gpu_data_stale = true;
    }
  temp_ratio = temperature / 300;
  point_mass = surface_mass / point_count;
  point_mass_inv = 1.0 / point_mass;
  damping_factor_per_step = pow(damping_factor,world.delta_t);
  const double ell = pow(volume,1/3.);
  const double a = sqrt( 2.0 * ell * spring_constant * point_mass_inv  );
  oversample = M_PI / ( 2 * a * world.delta_t );
  tightness = a;
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
  gpu_data_stale = true;
}

void
Balloon::push(pVect amt)
{
  gpu_data_to_cpu();
  for ( int idx = 0;  idx < point_count; idx++ )
    points[idx].vel += amt;
  gpu_data_stale = true;
}

void
Balloon::update_for_volume()
{
  const float eff_volume = fabs( volume );
  const float volume_ratio = nom_volume / eff_volume;

  pressure = gas_amount * volume_ratio * temp_ratio;
  gas_m_over_temp = particle_mass / temp_ratio;
}

void
Balloon::time_step_cpu(int steps)
{
  for ( int i=0; i<steps; i++ ) time_step_cpu_once();
}

void
Balloon::time_step_cpu_once()
{
  const double friction_coefficient = 0.08;
  const double bounce_factor = 0.0;
  const double delta_t = world.delta_t;
  pVect gravity(0,-opt_gravity_accel,0);
  if ( !opt_gravity ) gravity = pVect(0,0,0);
  const bool first_iteration = cpu_iteration == 0;
  cpu_iteration++;

  float volume_x2 = 0;
  float area_x2 = 0;
  double kinetic_energy_total = 0;
  double spring_energy_factor_total = 0;
  pVect surface_error2(0,0,0);
  centroid = pCoor(0,0,0,0);

  for ( int idx = 0;  idx < point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      centroid += p->pos;
      kinetic_energy_total += p->vel.mag();
      p->force = pVect(0,0,0);
      p->force_spring = pVect(0,0,0);
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

      p->force += spring_force * p_to_c;
      q->force += spring_force * q_to_c;
      r->force += spring_force * r_to_c;

      const double spring_energy = eff_length;
      spring_energy_factor_total += spring_energy;
    }

  length_relaxed_update = false;

  volume = volume_x2 / 2.0;
  area = area_x2 / 2.0;

  if ( first_iteration )
    {
      double pf_sum = 0; // Pressure factor.
      for ( int i=0; i<point_count; i++ )
        {
          Balloon_Vertex* const p = &points[i];
          pNorm inward(p->surface_normal);
          const double pf_balance = dot(p->force,inward) / inward.magnitude;
          pf_sum += pf_balance;
        }
      gas_amount = 6 * pf_sum * volume / ( nom_volume * point_count );
    }

  update_for_volume();

  const float pressure_factor = 1.0/6 * pressure;

  if ( first_iteration )
    {
      air_pressure_factor = 0.5 * pressure_factor;
    }

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
      const float pressure =
        opt_gravity
        ? pressure_factor * exp( - gas_m_over_temp * p->pos.y )
        : pressure_factor;
      const float air_pressure =
        opt_gravity
        ? air_pressure_factor * exp( - air_particle_mass * p->pos.y )
        : air_pressure_factor;

      p->force_spring = p->force;

      p->force_pressure =
        ( air_pressure -pressure ) * p->surface_normal;

      p->force += p->force_pressure;

      pVect force_ng = p->force;
      pVect gforce = point_mass * p->mass * gravity;
      p->force += gforce;

      pVect delta_vng = point_mass_inv * p->mass_inv * delta_t * force_ng;
      pVect delta_vg = delta_t * gravity;
      pVect delta_v = delta_vng + delta_vg;

      //  pVect pos_verlet = p->pos - pos_prev + delta_t * delta_v;

      p->pos_prev = p->pos;
      p->pos += ( p->vel +  0.5 * delta_v ) * delta_t;
      p->vel += damping_v * delta_vng + delta_vg;

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
      if ( p->force.y >= 0 ) continue;
      const float friction_force = -p->force.y * friction_coefficient;
      const float delta_v = point_mass * friction_force * p->mass * delta_t;
      const pNorm xzvel(p->vel.x,0,p->vel.z);
      if ( xzvel.magnitude <= delta_v ) {
        p->vel.x = 0;  p->vel.z = 0;
      }
      else
        p->vel -= delta_v * xzvel;
    }

  if ( cpu_iteration == 240 )
    printf("E change = %.4f\n", energy / e_zero);

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

  static bool gpu_init = false;
  if ( !gpu_init )
    {
      gpu_init = true;
      glGenTextures(1,&gpu_data_tri_tid);
      glGenTextures(1,&gpu_data_vtx_tid);
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
      // p 640: Examples of rendering to two textures.
      // glCheckFramebufferStatus();

      glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0 );
      glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, 0 );
      pError_Check();

      // pixel buffer object?

      vs_plan_c.init("cube6-shader.cc","main_physics_plan_c();");
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
      vs_plan_c.print_active_varying();
      vs_plan_c.validate_once();
    }

  cpu_data_to_gpu();

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
    (sun_constants_sc,spring_constant,damping_v,nom_volume,temp_ratio);

  glUniform4f
    (sun_constants_gas,
     gas_amount, particle_mass,
     air_particle_mass, opt_gravity ? opt_gravity_accel : 0.0 );

  glUniform4f
    (sun_constants_dt,
     world.delta_t, air_pressure_factor, point_mass, point_mass_inv);

  glUniform4f
    (sun_platform,
     world.platform_xmin, world.platform_xmax,
     world.platform_zmin, world.platform_zmax);

  const GLint svl_p1[] = { svl_surface_normal, svl_force_or_v, svl_pos };
  glTransformFeedbackVaryingsNV
    (vs_plan_c.pobject, 3, &svl_p1[0], GL_INTERLEAVED_ATTRIBS_NV);
  pError_Check();

  BV_GPU_Data_Vtx before = gpu_data_vtx.data[0];

  if ( steps ) cpu_data_stale = true;

  pError_Check();

  glEnableClientState(GL_VERTEX_ARRAY);

  glActiveTexture(GL_TEXTURE0);  pError_Check();
  glBindTexture(GL_TEXTURE_BUFFER_EXT,gpu_data_vtx_tid);   pError_Check();

  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,gpu_data_tri_tid);  pError_Check();

  for ( int i=0; i<steps; i++ )
    {
      const bool skip_volume = i + 1 != steps && true && ( i & 0x3 );

      //
      // Pass 1, Triangles
      //

      glActiveTexture(GL_TEXTURE0);
      glTexBufferEXT // Attaches to the active buffer texture.
        (GL_TEXTURE_BUFFER_EXT, GL_RGBA32F_ARB, gpu_data_vtx.bid_read());

      glActiveTexture(GL_TEXTURE1);
      glBindTexture(GL_TEXTURE_BUFFER_EXT,0);

      gpu_plan_c_triangle_data.bind();
      glVertexPointer(4, GL_FLOAT, sizeof(gpu_plan_c_triangle_data[0]), 0);
      glBindBuffer(GL_ARRAY_BUFFER,0);

      glBindBufferBaseNV
        (GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0, gpu_data_tri.bid_fresh());
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
          gpu_data_tri.from_gpu();
          BV_GPU_Data_Tri after_sf = gpu_data_tri.data[0];
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
      glBindTexture(GL_TEXTURE_BUFFER_EXT,gpu_data_tri_tid);  pError_Check();
      glTexBufferEXT
        (GL_TEXTURE_BUFFER_EXT, GL_RGBA32F_ARB, gpu_data_tri.bid);
      pError_Check();

      gpu_plan_c_vertex_data.bind();
      const int vstride = sizeof(gpu_plan_c_vertex_data[0]);
      glVertexPointer(2, GL_FLOAT, vstride, 0);

      glVertexAttribIPointerEXT(sat_indices, 4, GL_INT, vstride, (void*)8);
      glEnableVertexAttribArray(sat_indices);

      const int dvstride = sizeof(BV_GPU_Data_Vtx);

      gpu_data_vtx.bind();
      glVertexAttribPointer(sat_vel, 4, GL_FLOAT, false, dvstride, (void*)16);
      glVertexAttribPointer(sat_pos, 4, GL_FLOAT, false, dvstride, (void*)32);
      glEnableVertexAttribArray(sat_pos);
      glEnableVertexAttribArray(sat_vel);

      glBindBuffer(GL_ARRAY_BUFFER,0);
      glBindBufferBaseNV
        (GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0, gpu_data_vtx.bid_write());
      pError_Check();

      TRY_XF_FEEDBACK( glDrawArrays(GL_POINTS,0,point_count), point_count);

      glDisableVertexAttribArray(sat_indices);
      glDisableVertexAttribArray(sat_pos);
      glDisableVertexAttribArray(sat_vel);

      gpu_data_vtx.bid_swap();
    }

  update_for_volume();
  if ( false )
    {
      BV_GPU_Data_Vtx after = gpu_data_vtx.data[0];
      pError_Msg("Check.");
    }

  world.vs_fixed.use();

  glDisableClientState(GL_VERTEX_ARRAY);

  glBindBuffer(GL_ARRAY_BUFFER,0);

  glClampColorARB(GL_CLAMP_VERTEX_COLOR_ARB,GL_TRUE);
  glDisable(GL_RASTERIZER_DISCARD_NV);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,0);
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_BUFFER_EXT,0);

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0 );

  pError_Check();

}

void
Balloon::gpu_data_to_cpu()
{
  if ( !cpu_data_stale ) return;
  cpu_data_stale = false;
  gpu_data_vtx.from_gpu();
  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      BV_GPU_Data_Vtx* const g = &gpu_data_vtx[idx];
      p->pos = g->pos;
      p->vel = g->vel;
      p->surface_normal = g->surface_normal;
    }
}

void
Balloon::cpu_data_to_gpu()
{
  if ( !gpu_data_stale ) return;

  gpu_data_stale = false;

  for ( int idx=0; idx<point_count; idx++ )
    {
      Balloon_Vertex* const p = &points[idx];
      BV_GPU_Data_Vtx* const g = &gpu_data_vtx[idx];
      g->pos = p->pos;
      g->vel = p->vel;
    }

  for ( int idx=0; idx<tri_count; idx++ )
    {
      Balloon_Triangle* const tri = &triangles[idx];
      BV_GPU_Plan_C_Triangle_Data* const td =
        &gpu_plan_c_triangle_data[idx];
      td->length_relaxed = tri->length_relaxed;
    }

  gpu_data_vtx.to_gpu();
  gpu_plan_c_vertex_data.to_gpu();
  gpu_plan_c_triangle_data.to_gpu();
  glBindBuffer(GL_ARRAY_BUFFER,0);
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

  if ( !opt_gpu ) balloon.gpu_data_to_cpu();

  if ( world_time == 0 ) world_time = time_wall_fp();

  if ( opt_pause )
    {
      world_time = time_wall_fp();
    }
  else
    {
      const double time_start = time_wall_fp();
      const double sim_time_needed = time_start - world_time;
      delta_t = 1.0 / ( 30 * ( opt_gpu ? 40 : 20 ) ) ;
      const int time_steps_needed = int( sim_time_needed / delta_t );
      const int time_steps = min(time_steps_needed,100);
      balloon.update_for_config();
      if ( opt_gpu && balloon.need_cpu_iteration ) balloon.time_step_cpu_once();
      if ( opt_gpu ) balloon.time_step_gpu(time_steps);
      else balloon.time_step_cpu(time_steps);
      frame_timer.work_amt_set(time_steps);
      world_time += delta_t * time_steps;
    }

  if ( balloon.centroid.y < -50 )
    {
      pVect rescue_vector = pCoor(0,12,-12) - balloon.centroid;
      balloon.translate(rescue_vector);
    }

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

  pColor white(0xffffff);
  pColor gray(0x303030);
  pColor dark(0);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, gray);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  glShadeModel(GL_SMOOTH);

  insert_tetrahedron(light_location,0.05);
  glEnable(GL_RESCALE_NORMAL);
  glEnable(GL_NORMALIZE);

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "(%suse arrow and page keys to move).\n",
     eye_location.x, eye_location.y, eye_location.z,
     opt_move_item == MI_Eye ? "press 'e' then " : "" );

  ogl_helper.fbprintf
    ("Eye direction: [%+.2f, %+.2f, %+.2f]  "
     "(use 'Home', 'End', 'Del', 'Insert' keys to turn).\n",
     eye_direction.x, eye_direction.y, eye_direction.z);

  pCoor cent = balloon.centroid;
  pCoor vel = balloon.velocity_avg();

  ogl_helper.fbprintf
    ("Centroid  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]  "
     "Gas Amt %.2f  Volume  %.2f  Pressure %.0f\n",
     cent.x,cent.y,cent.z,
     vel.x,vel.y,vel.z,
     balloon.gas_amount,
     balloon.volume / balloon.nom_volume,
     balloon.pressure
     );

  ogl_helper.fbprintf
    ("E %.3f, %6.0f = S %6.0f  +  K %6.0f   Oversample %3.1f  Tightness %3.1f "
     "Damping %d\n",
     balloon.energy / balloon.e_zero,
     balloon.energy, balloon.e_spring, balloon.e_kinetic,
     balloon.oversample, balloon.tightness,
     balloon.opt_damping
     );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (+/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  // Write framebuffer stencil with ball's shadow.
  //
  {
    glDisable(GL_LIGHTING);
    glEnable(GL_STENCIL_TEST);
    glStencilFunc(GL_NEVER,1,-1); // ref, mask
    glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);  // sfail, dfail, dpass
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadTransposeMatrixf(modelview_shadow);
    const int vstride = sizeof(Balloon_Vertex);
    if ( opt_gpu && !balloon.gpu_data_stale )
      {
        balloon.gpu_data_vtx.bind();
        glVertexPointer
          (3, GL_FLOAT, sizeof(balloon.gpu_data_vtx[0]),
           (void*)( 2 * sizeof(pCoor) ));
      }
    else
      glVertexPointer(4, GL_FLOAT, vstride, &balloon.points[0].pos);
    glEnableClientState(GL_VERTEX_ARRAY);
    balloon.point_indices.bind(GL_ELEMENT_ARRAY_BUFFER);
    glDrawElements
      (GL_TRIANGLES,balloon.point_indices.elements,GL_UNSIGNED_INT, NULL);
    glDisableClientState(GL_VERTEX_ARRAY);
    glPopMatrix();
    glEnable(GL_LIGHTING);
    glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
    glBindBuffer(GL_ARRAY_BUFFER,0);
  }

  // Setup texture for platform.
  //
  glActiveTexture(GL_TEXTURE0);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
                  GL_LINEAR_MIPMAP_LINEAR);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glBindTexture(GL_TEXTURE_2D,balloon.texid_syl);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  for ( int pass = 0;  pass < 2;  pass++ )
    {
      if ( pass == 0 )
        {
          // Prepare to write unshadowed parts of frame buffer.
          //
          glStencilFunc(GL_NOTEQUAL,1,-1); // ref, mask
        }
      else
        {
          // Prepare to write shadowed parts of frame buffer.
          //
          glStencilFunc(GL_EQUAL,1,-1); // ref, mask
          glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.3);
          glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 4.0);
        }

      glNormal3f(0,1,0);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,gray);

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

      // Write lighter-colored, textured tiles.
      //
      glColor3f(0.5,0.5,0.5);
      const int half_elements = platform_tile_coords.elements >> 3 << 2;
      glDrawArrays(GL_QUADS,0,half_elements+4);

      // Write darker-colored, untextured tiles.
      //
      glDisableClientState(GL_TEXTURE_COORD_ARRAY);
      glDisable(GL_TEXTURE_2D);
      glColor3f(0.4,0.4,0.4);
      glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
      glDisableClientState(GL_VERTEX_ARRAY);
      glBindBuffer(GL_ARRAY_BUFFER,0);
    }

  glDisable(GL_TEXTURE_2D);
  glDisable(GL_STENCIL_TEST);
  glEnable(GL_LIGHT0);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);

  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,10);

  if ( opt_surface_smooth )
    {
      const int vstride = sizeof(Balloon_Vertex);

      glActiveTexture(GL_TEXTURE0);
      glEnable(GL_TEXTURE_2D);
      glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
                      GL_LINEAR_MIPMAP_LINEAR);
      glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
      glBindTexture(GL_TEXTURE_2D,balloon.texid_pse);
      glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
      glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
      glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

      pColor color(0.9,0.9,0.9);
      glColor3fv(color);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,color);

      balloon.tex_coords.bind();
      glTexCoordPointer(2,GL_FLOAT,0,NULL);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);

      if ( opt_gpu && !balloon.gpu_data_stale )
        {
          balloon.gpu_data_vtx.bind();
          glVertexPointer
            (3, GL_FLOAT, sizeof(balloon.gpu_data_vtx[0]),
             (void*)( 2 * sizeof(pCoor) ));
          glNormalPointer
            (GL_FLOAT, sizeof(balloon.gpu_data_vtx[0]), NULL );
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
      balloon.gpu_data_to_cpu();
      glBegin(GL_TRIANGLES);

      for ( int idx = 0;  idx < balloon.tri_count; idx++ )
        {
          Balloon_Triangle* const tri = &balloon.triangles[idx];
          Balloon_Vertex* const p = &balloon.points[tri->pi];
          Balloon_Vertex* const q = &balloon.points[tri->qi];
          Balloon_Vertex* const r = &balloon.points[tri->ri];

          glColor3fv(tri->color);
          glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,tri->color);

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

  pError_Check();

#if 0
  for ( int idx = 0;  idx < balloon.points.occ(); idx++ )
    {
      Balloon_Vertex* const p = &balloon.points[idx];
      switch ( p->ring & 0x3 ) {
      case 0: glColor3f(1,.1,.1); break;
      case 1: glColor3f(0.1,1,0.1); break;
      case 2: glColor3f(0.1,0.1,1); break;
      case 3: glColor3f(0.1,1,1); break; // Cyan
      default: glColor3f(0.5,0.5,0.5); break;
      }

      tube_tapered(p->pos,0.06,-p->surface_normal);
    }
#endif

  pError_Check();

  glColor3f(0,1,0); // This sets the text color. Don't know why.

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

  balloon.gpu_data_stale = true;
  balloon.gpu_data_to_cpu();

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

  case 'a': opt_gpu = !opt_gpu; break;
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
  case 'x': balloon.opt_surface_fix = !balloon.opt_surface_fix; break;
  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key\n"); break;
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
