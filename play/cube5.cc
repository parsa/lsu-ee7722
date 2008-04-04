// ----------------------

#define PROGRAM_TITLE "Cube 5"

#include <stdio.h>   // Always a good idea.
#include <stdlib.h>
#include <string.h>
#include <math.h>
#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES
#include <GL/gl.h>   // OpenGL itself.
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>  // GLU support library.
#include <GL/freeglut.h> // GLUT support library.

#include <deque>
#include <queue>
#include <list>
#include <string>

#include "util.h"
#include "glextfuncs.h"
#include "coord.h"
#include "shader.h"

void
write_img()
{
  const int width = glutGet(GLUT_WINDOW_WIDTH);
  const int height = glutGet(GLUT_WINDOW_HEIGHT);
  std::string pipe_name ( "pnmtopng > " __FILE__ ".png");
  FILE* const fp = popen(pipe_name.c_str(), "w");
  if ( !fp )
    {
      fprintf(stderr, "Could not open pipe for screenshot.\n");
      return;
    }
  fprintf(fp,"P6\n%d %d 255\n",width,height);
  glReadBuffer(GL_FRONT);
  const int size = width * height;
  char* const pbuffer = (char*) malloc(size * 3);
  glReadPixels(0,0,width,height,GL_RGB,GL_UNSIGNED_BYTE,pbuffer);
  for ( int y=height-1; y>=0; y-- )
    {
      char* row = &pbuffer[ y * width * 3 ];
      for ( int x=0; x<width; x++ )
        {
	  putc(row[0],fp); putc(row[1],fp); putc(row[2],fp);
	  row += 3;
        }
    }
  pclose(fp);
  free(pbuffer);
}

struct Variable_Control_Elt {
  float *var;
  char *name;
};

class Variable_Control {
public:
  Variable_Control()
  {
    size = 0;  storage = (Variable_Control_Elt*)malloc(0); current = NULL;
  }
  void insert(float &var, char *name)
  {
    size++;
    const int cidx = current - storage;
    storage = (Variable_Control_Elt*)realloc(storage,size*sizeof(*storage));
    Variable_Control_Elt* const elt = &storage[size-1];
    elt->var = &var;
    elt->name = strdup(name);
    current = &storage[ size == 1 ? 0 : cidx ];
  }
  void adjust_higher() {if ( current ) current->var[0] *= 1.05;}
  void adjust_lower() {if ( current ) current->var[0] *= 0.95;}
  void switch_var_right()
  {
    if ( !current ) return;
    current++;
    if ( current == &storage[size] ) current = storage;
  }
  int size;
  Variable_Control_Elt *storage, *current;
};


inline void glutBitmapString(void *font, const char *str)
{ glutBitmapString(font,(unsigned char*)str);
}

#define CUBE_MAX_T 1e30

// Some global variables.

// Window and texture IDs, window width and height.
GLuint Texture_ID;
int Window_ID;
int Window_Width = 300;
int Window_Height = 300;

GLuint texid_syllabus, texid_bldg;
GLuint texid_pie;

// Our display mode settings.
int Light_On = 1;
int Blend_On = 1;
int Texture_On = 1;
int Filtering_On = 1;
bool opt_gpu = true;

int Curr_TexMode = 3;
const char *TexModesStr[] = {"GL_DECAL","GL_MODULATE","GL_BLEND","GL_REPLACE"};
GLint TexModes[] = {GL_DECAL,GL_MODULATE,GL_BLEND,GL_REPLACE};

// Object and scene global variables.

// Cube position and rotation speed variables.
float X_Speed = 0.0f;
float Y_Speed = 0.0f;
float Z_Speed = 0.0f;
float Z_Off   =-5.0f;

// Settings for our light.  Try playing with these (or add more lights).
//  float Light_Ambient[]=  { 0.3f, 0.3f, 0.3f, 1.0f };
float Light_Off[] = {0,0,0,1.0};
float Light_Ambient[]=  { 0.8f, 0.8f, 0.8f, 1.0f };
float Light_Diffuse[]=  { .8f, .8f, .8f, 1.0f };
float Light_Specular[]=  { 1.2f, 1.2f, 1.2f, 1.0f };
float Light_Position[]= { -2, 2, 0.0f, 1.0f };

bool lite_textures = false;


pFrame_Timer frame_timer;

struct pSine {
  double angle, sin, cos;
};

class pSine_Series {
public:
  pSine_Series(double start, double end, int amt):
    storage( new pSine[amt] ), amt(amt)
  {
    const double delta = ( end - start ) / ( amt - 1 );
    const double stop = end + delta / 2;
    pSine *s = storage;
    for ( double a = start; a < stop; a += delta )
      {
        s->angle = a;
        s->sin = sin(a);
        s->cos = cos(a);
        s++;
      }
    iterator = 0;
  }

  inline operator pSine*()
  {
    if ( iterator == amt )
      {
        iterator = 0;
        return NULL;
      }
    return &storage[iterator++];
  }

private:
  pSine* const storage;
  const int amt;
  int iterator;
};

class P_Image_Read
{
public:
  P_Image_Read(const char *path, int transp):image_loaded(false),data(NULL)
  {
    FILE* const in = fopen(path,"r");
    if ( !in ) return;
    const int MAXLINE = 300;
    char line[MAXLINE];

    fgets(line,MAXLINE,in);
    if( !strcmp(line,"P6") ) {
      fprintf(stderr,"Unexpected first line.\n"); exit(1);
    }

    while( 1 ) {
      fgets(line,MAXLINE,in);
      if( feof(in) ) {
        fprintf(stderr,"Unexpected end of file.\n"); exit(1);
      }
      if( line[0] != '#' ) break;
    }

    sscanf(line,"%d %d",&width,&height);
    const int num = width * height;
    const int size = num * 4;
    data = (unsigned char*) malloc( size );
    unsigned char *dp = data;
    fread(dp,1,1,in);
    for ( int i = 0; i < num; i++ )
      {
        fread(dp,1,3,in);
        dp[3] = dp[0] & dp[1] & dp[2] == transp ? 0 : 255;
        dp += 4;
      }
    fclose(in);
    image_loaded = true;
  };
  ~P_Image_Read() {if ( data ) free(data);  data = NULL;}
  void color_invert()
  {
    const int num = width * height * 4;
    for ( int i = 0; i < num; i+=4 )
      {
        unsigned char* const dp = &data[i];
        const int sum = dp[0] + dp[1] + dp[2];
        dp[3] = (unsigned char)(255 - sum * 0.3333333);
        dp[0] = dp[1] = dp[2] = 255;
        //  dp[3] = sum < 700 ? 255 : 0;
        //  dp[0] = -dp[0]; dp[1] = -dp[1]; dp[2] = -dp[2];
      }
  }
  bool image_loaded;
  int width, height, maxval;
  unsigned char *data;
private:
};

void pSet_Mode();

class pPlane {
public:
  pPlane(pCoor point, pVect normal):point(point),normal(normal){}
  float distance(pCoor point2) const { return dot(point - point2, normal); }
  const pCoor point;
  const pVect normal;
};

class pIntercept {
public:
  pIntercept(pPlane plane, pCoor start, pVect speed):
    distance(plane.distance(start)),
    ndots(dot(plane.normal,speed)),
    time(ndots == 0 ? CUBE_MAX_T : distance / ndots),
    point( start + time * speed){}
  const float distance;
  const float ndots;
  const float time;
  pCoor point;
};


pShader *vs_lighting, *vs_physics, *vs_faces, *vs_fixed;

GLint sun_ball_size; // Vector including size and size^2
GLint sun_damping_factor;
GLint sun_delta_t;
GLint sun_gp_mass_inv;
GLint sun_gravity_force;
GLint sun_gs_constant;

GLint sal_step_last_time;

GLint sal_position;
GLint sal_position_left, sal_position_right;
GLint sal_position_above, sal_position_below;
GLint sal_velocity_left, sal_velocity_right;
GLint sal_velocity_above, sal_velocity_below;
GLint sal_velocity;
GLint sal_force;
GLint sal_extra;  // Add more variables without thinking of names.

GLint sal_ball_position;
GLint sal_ball_speed;

GLint svl_velocity;
GLint svl_force;
GLint svl_extra;
GLint svl_position;

GLint sal_ftime_th;
GLint sal_fstep_last_time;
GLint sal_fin_extra;
GLint sal_fposition_left, sal_fposition_right;
GLint sal_fposition_above, sal_fposition_below;


class pCube {
public:
  pCube(){m.set_identity();};
  void set(pCoor v000, float len)
  {
    m.apply_scale(len);
    m.apply_translation(v000);
  }
  pCoor vl(int xyz)
  {
    return pCoor( xyz >> 6, ( xyz >> 3 ) & 1, xyz & 1 );
  }
  pCoor v(int xyz)
  {
    //  pCoor vec( xyz >> 6, ( xyz >> 3 ) & 1, xyz & 1 );
    return m * vl(xyz);
  }
  pCoor v(pVect local) { return m * pCoor(local); }

  pPlane face(int face_num)
  {
    const bool dir = face_num & 1;
    const int axis = face_num >> 1;
    pCoor pt(dir,dir,dir);
    const float pm = dir ? 1.0 : -1.0;
    pVect v(axis == 0 ? pm : 0, axis == 1 ? pm : 0, axis == 2 ? pm : 0);
    pCoor outside = pt + v;
    pt.apply(m);
    outside.apply(m);
    pVect normal = outside - pt;
    normal.normalize();
    return pPlane(pt,normal);
  }

  pPlane face_local(int face_num)
  {
    const bool dir = face_num & 1;
    const int axis = face_num >> 1;
    const float pm = dir ? 1.0 : -1.0;
    pVect v(axis == 0 ? pm : 0, axis == 1 ? pm : 0, axis == 2 ? pm : 0);
    pCoor pt = pCoor(0.5,0.5,0.5) + 0.5 * v;
    return pPlane(pt,v);
  }

  pVect localize(pCoor p)
  {
    pPlane face_yz = face(0);
    pPlane face_xz = face(2);
    pPlane face_xy = face(4);
    const float len_inv = 1.0f / distance(v(0),v(1));
    return pVect( face_yz.distance(p) * len_inv,
		  face_xz.distance(p) * len_inv,
		  face_xy.distance(p) * len_inv);
  }

  pMatrix4 m;
};


struct pContact {
  pContact(int f, pVect loc, float speed, pVect velocity, int t)
    :face(f),loc(loc),speed(speed),velocity(velocity),t(t){}
  int face;
  pVect loc;
  float speed;
  pVect velocity;
  int t;
  bool render_bump;
};

typedef std::deque<pContact> pContact_List;

class pCube_Face_Info {
public:
  pCube_Face_Info():inited(false){}
  int texid;
  pCoor v00, v01, v10, v11;
  bool cross_inside;
  pCoor tmap(pCoor pt)
  {
    pVect f = axis == 0 ? pCoor(pt.z,pt.y) :
      axis == 1 ? pCoor(pt.x,pt.z) : pCoor(pt.x,pt.y);
    return pCoor(v00.x + v00_11.x * f.x, v00.y + v00_11.y * f.y);
  }
  void init(int face, int texidp, float x0, float y0, float x1, float y1)
  {
    axis = face >> 1;
    dir = ( face & 1 ) != ( axis != 2 );
    inited = true;
    texid = texidp;
    const float xa = dir ? x0 : x1;
    const float xb = dir ? x1 : x0;
    v00 = pCoor(xa,y1);
    v11 = pCoor(xb,y0);
    v00_11 = v11 - v00;
    v01 = pCoor(xa,y0);
    v10 = pCoor(xb,y1);
  }
private:
  bool inited;
  int axis;
  bool dir;
  pVect v00_11;
};

class pGrid_Point {
public:
  pCoor position;
  pVect velocity;
  pVect force;
  float contact_time;
  float cross_direction;
  float boundary;
};

class pGrid {
public:

  pGrid(int size, int &idxp,
        pGrid_Point* set_1, pGrid_Point* set_2, pVect* texture_ap)
    :size(size), idx(idxp),
     texture_a(&texture_ap[idx]), state_cur(0)
  {
    const int n_elem = size * size;
    grids[0] = &set_1[idx];
    grids[1] = &set_2[idx];
    idxp += n_elem;
  }

  void state_swap() { state_cur = 1 - state_cur; }
  int point_idx(int x, int y) const { return y*size+x; }
  pGrid_Point* grid_cur() const { return grids[state_cur]; }
  pGrid_Point* grid_nxt() const { return grids[1-state_cur]; }
  pGrid_Point& point_cur(int x, int y) const
  { return grids[state_cur][point_idx(x,y)];}
  pGrid_Point& point_nxt(int x, int y) const
  { return grids[1-state_cur][point_idx(x,y)];}
  pVect& texture(int x, int y) const { return texture_a[point_idx(x,y)]; }
  pGrid_Point& neighbor(int x, int y, int n)
  {
    static int move[][2] =
      {{-1,0},{0,-1},{1,0},{0,1}, {-1,-1},{-1,1},{1,-1},{1,1}};
    return grids[state_cur][point_idx(x+move[n][0],y+move[n][1])];
  }
  const int size;
  const int idx;
  pVect* const texture_a;
  pGrid_Point* grids[2];
  int state_cur;
};

class pBall {
public:
  pCoor position;
  pVect speed;
  pVect color;
};

class pWorld {
public:
  pWorld():
    ball_position(0.0,0,0.0),
    ball_speed(0,0,0),
    //  accel(0,0,0)
    accel(0,-1.7,0)
  {
    pause = false;
    xfcount = 0;
    start_time = time_wall_fp();
    step_last_time = 0;
    opt_frame_time_steps_max = 100;
    ball_size = 0.2;
    time_step_num = 0;
    step_duration = 1.0 / 1200;
    grid_size = 60;
    step_duration_inv = 1.0 / step_duration;
    age_max = int ( 60 * step_duration_inv );
    age_max_inv = 1.0 / age_max;
    data_in_grid = true;
    variable_control.insert(ball_size,"Ball Size");
  };

  void init();
  void cube_spin_set(float t)
  {
    cube_spin.set_identity();
    cube_spin.apply_rotation(pCoor(1,0,0),X_Speed * t * 30 );
    cube_spin.apply_rotation(pCoor(0,1,0),Y_Speed * t * 30 );
    cube_spin.apply_rotation(pCoor(0,0,1),Z_Speed * t * 30 );
  }
  void time_advance();
  bool time_advance_vars();
  void gpu_shader_init();
  void gpu_shader_try();
  void time_advance_cpu();
  void time_step_cpu();
  void time_advance_gpu();

  Variable_Control variable_control;

  bool pause;
  pContact_List contact[6];
  pCube_Face_Info cube_face_info[6];
  pCube_Face_Info cube_face_generic_info[6];
  double start_time;  // App start time.
  float frame_start_time;
  float step_last_time;
  int age_max;
  double age_max_inv;
  double step_duration;
  int time_step_num;
  int frame_time_step_count;
  int opt_frame_time_steps_max;
  float step_duration_inv;
  pCube cube;
  pMatrix4 cube_spin;
  GLUquadricObj *ball;
  float damping_factor_coefficient;
  pCoor ball_position;
  pVect ball_speed;
  float ball_size;
  //  pBall balls[2];
  pVect accel;
  unsigned int xfcount;

  int grid_size;
  int grid_limit;
  double gp_mass;
  float gs_constant;
  float ball_mass;

  pGrid *grids[6];
  pCoor *color_buffer;
  pVect *normal_buffer;
  int *index_buffer;
  int index_buffer_size;
  GLuint index_buffer_id;

  GLuint query_transform_feedback_id;
  GLuint framebuffer_id;
  GLuint renderbuffer_id;

  bool data_in_grid;
  GLuint position_buffer_cur;
  GLuint position_buffer_nxt;
  void position_buffer_swap()
  {
    const GLuint bp = position_buffer_cur;
    position_buffer_cur = position_buffer_nxt;
    position_buffer_nxt = bp;
  }

  void transfer_grid_to_buffer()
  {
    if ( !data_in_grid ) return;

    char* const grid = (char*)grids[0]->grid_cur();

    glBindBuffer(GL_ARRAY_BUFFER, position_buffer_cur);
    glBufferData
      (GL_ARRAY_BUFFER, grid_cube_storage_chars, grid - grid_row_stride,
       GL_DYNAMIC_COPY);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    data_in_grid = false;
  }

  void transfer_buffer_to_grid()
  {
    if ( data_in_grid ) return;

    char* const grid = (char*)grids[0]->grid_cur();

    glBindBuffer(GL_ARRAY_BUFFER,position_buffer_cur);
    char* const mapped = (char*) glMapBuffer(GL_ARRAY_BUFFER, GL_READ_ONLY);
    pError_Check();
    memcpy(grid, mapped+grid_row_stride, grid_cube_data_chars);
    glUnmapBuffer(GL_ARRAY_BUFFER);
    glBindBuffer(GL_ARRAY_BUFFER,0);
    pError_Check();

    data_in_grid = true;
  }

  GLvoid* grid_offset(const void *start, int xoffset = 0, int yoffset = 0)
  {
    char* const base =
      ((char*)&grids[0]->point_cur(-xoffset,-yoffset)) - grid_row_stride;
    return (GLvoid*)(((char*)start) - base);
  }

  GLuint texture_buffer_id;
  int grid_point_stride;
  int grid_row_stride;
  int grid_face_data_chars;
  int grid_cube_data_chars;
  int grid_cube_storage_chars; // Includes 1-row margins before and after.

};

int debug_time_step_num_at_frame_start = 0;

void
pWorld::time_advance()
{
  if ( !opt_gpu ) transfer_buffer_to_grid();

  frame_start_time = time_wall_fp() - start_time;

  if ( pause )
    {
      step_last_time = frame_start_time;
      return;
    }
  debug_time_step_num_at_frame_start = time_step_num;
  frame_time_step_count = 0;
  cube_spin_set(step_duration);

  if ( opt_gpu ) time_advance_gpu(); else time_advance_cpu();

  const int t_old = time_step_num - age_max;
  for ( int f=0; f<6; f++ )
    {
      pContact_List& c = contact[f];
      while ( c.size() && c.front().t < t_old ) c.erase(c.begin());
    }
}

bool
pWorld::time_advance_vars()
{
  if ( step_last_time >= frame_start_time
       || frame_time_step_count > opt_frame_time_steps_max ) return false;
  step_last_time += step_duration;
  frame_time_step_count++;
  time_step_num++;
  return true;
}

void
pWorld::time_advance_cpu()
{
  while ( time_advance_vars() ) time_step_cpu();
}

void
pError_Check_Distance(pCoor& a, pCoor& b)
{
  const float threshold = 0.0001;
  pVect diff(a,b);
  const float distance_sq = dot(diff,diff);
  if ( distance_sq < threshold ) return;
  pError_Exit();
}


void
grid_edge_init
(pGrid *g, int ga, int gb, pCoor& v, pVect delta_v)
{
  pGrid_Point& gp_cur = g->point_cur(ga,gb);
  pGrid_Point& gp_nxt = g->point_nxt(ga,gb);
  gp_cur.force = gp_nxt.force = pVect(v);
  gp_cur.boundary = gp_nxt.boundary = 1.0;
  v += delta_v;
}

void
grid_edge_update
(pGrid& g, int ga, int gb, pCoor& v, pVect delta_v, float delta_t_inv)
{
  pGrid_Point& gp_cur = g.point_cur(ga,gb);
  pGrid_Point& gp_nxt = g.point_nxt(ga,gb);
  if ( opt_gpu ) pError_Check_Distance(gp_nxt.position,v);
  gp_nxt.position = v;
  gp_nxt.velocity = ( v - gp_cur.position ) * delta_t_inv;
  v += delta_v;
}

void
pWorld::gpu_shader_init()
{
  static bool did_that = false;
  if ( did_that ) return;
  did_that = true;
  pError_Check();

  glGenFramebuffersEXT(1,&framebuffer_id);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framebuffer_id);
  glGenRenderbuffersEXT(1, &renderbuffer_id);
  glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, renderbuffer_id);
  glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_FLOAT_RGBA_NV, 2, 2);
  glFramebufferRenderbufferEXT
    (GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_RENDERBUFFER_EXT,
     renderbuffer_id);
  pError_Check();

  glGenQueries(1,&query_transform_feedback_id);

  glGenBuffers(1, &position_buffer_cur);
  glGenBuffers(1, &position_buffer_nxt);

  //  gpu_shader_try(); return;

  pGrid& g = *grids[0];
  pGrid_Point* const grid = g.grid_cur();
  grid_point_stride = sizeof(grid[0]);
  grid_row_stride = g.size * grid_point_stride;
  grid_face_data_chars = g.size * grid_row_stride;
  grid_cube_data_chars = 6 * grid_face_data_chars;
  grid_cube_storage_chars = grid_cube_data_chars + 2 * grid_row_stride;

  glBindBuffer(GL_ARRAY_BUFFER, position_buffer_nxt);
  glBufferData(GL_ARRAY_BUFFER, grid_cube_storage_chars, NULL, GL_DYNAMIC_COPY);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
}

void
pWorld::gpu_shader_try()
{
  const int element_size = sizeof(float) * 4;
  const int position_buffer_size_used = element_size * grid_limit;
  const int position_buffer_size = position_buffer_size_used + element_size;
  glBindBuffer(GL_ARRAY_BUFFER, position_buffer_cur);

  float* const pb_mapped = (float*) alloca( position_buffer_size );
  float *pb = pb_mapped;
  for ( int i=-1; i<grid_limit; i++ )
    {
      *pb++ = i;
      *pb++ = -10;
      *pb++ = 100;
      *pb++ = -30;
    }
  glBufferData
    (GL_ARRAY_BUFFER, position_buffer_size, pb_mapped, GL_DYNAMIC_COPY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  pError_Check();

  glBindBuffer(GL_ARRAY_BUFFER, position_buffer_nxt);
  glBufferData(GL_ARRAY_BUFFER, position_buffer_size, NULL, GL_DYNAMIC_COPY);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

#if 0
  GLuint neighbor_buffer;
  glGenBuffers(1, &neighbor_buffer);
  glBindBuffer(GL_ARRAY_BUFFER, neighbor_buffer);
  glBufferData(GL_ARRAY_BUFFER, position_buffer_size, pb_mapped,
	       GL_DYNAMIC_COPY);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
#endif

  pError_Check();

  //  int var_locations[] = { svl_position, svl_velocity };
  const GLint var_locations[] = { svl_position };
  const int var_count = sizeof(var_locations) / sizeof(var_locations[0]);

  glTransformFeedbackVaryingsNV
    (vs_physics->pobject, var_count, &var_locations[0], GL_SEPARATE_ATTRIBS_NV);
  pError_Check();

  vs_physics->use();
  glEnable(GL_RASTERIZER_DISCARD_NV);
  GLuint pos_in = position_buffer_cur;
  GLuint pos_out = position_buffer_nxt;

  for ( int i=0; i<5; i++ )
    {
      pos_in = i & 1 ? position_buffer_cur : position_buffer_nxt;
      pos_out = !(i & 1) ? position_buffer_cur : position_buffer_nxt;

      glBindBufferBaseNV(GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0, pos_out);
      pError_Check();

      glBeginTransformFeedbackNV(GL_POINTS);

      glBindBuffer(GL_ARRAY_BUFFER,pos_in);
      glVertexPointer(4,GL_FLOAT,0,(void*)element_size);
      glEnableClientState(GL_VERTEX_ARRAY);
      pError_Check();

      //  glBindBuffer(GL_ARRAY_BUFFER,neighbor_buffer);
      glVertexAttribPointer
        (sal_position_left, 4, GL_FLOAT, false, 0, NULL);
      glEnableVertexAttribArray(sal_position_left);
      glBindBuffer(GL_ARRAY_BUFFER,0);
      pError_Check();

      glDrawArrays(GL_POINTS,0,grid_limit);
      pError_Check();
      glEndTransformFeedbackNV();

      pError_Check();

    }

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableVertexAttribArray(sal_position_left);
  glDisable(GL_RASTERIZER_DISCARD_NV);

  pError_Check();

  glFinish();

  glBindBuffer(GL_ARRAY_BUFFER,pos_out);
#if 0
  float* const mapped = (float*) glMapBuffer(GL_ARRAY_BUFFER,GL_READ_ONLY);
  pError_Check();
  glUnmapBuffer(GL_ARRAY_BUFFER);
#endif
  glBindBuffer(GL_ARRAY_BUFFER,0);
  pError_Check();
  vs_lighting->use();
}

#define ATTR1(attr,dname,ox,oy)                                           \
  glVertexAttribPointer                                                       \
    (sal_##attr##dname, 3, GL_FLOAT, false,                                   \
     grid_point_stride, grid_offset(&grid[0].attr,ox,oy));                    \
  glEnableVertexAttribArray(sal_##attr##dname);

#define ATTR_ABOVE(attr) ATTR1(attr,_above,0,-1)
#define ATTR_BELOW(attr) ATTR1(attr,_below,0,1)
#define ATTR_LEFT(attr) ATTR1(attr,_left,-1,0)
#define ATTR_RIGHT(attr) ATTR1(attr,_right,1,0)

#define ATTR(attr) \
  ATTR_ABOVE(attr); ATTR_BELOW(attr); ATTR_LEFT(attr); ATTR_RIGHT(attr);

#define ATTR_D(attr)                                    \
  glDisableVertexAttribArray(sal_##attr##_left);        \
  glDisableVertexAttribArray(sal_##attr##_right);       \
  glDisableVertexAttribArray(sal_##attr##_above);       \
  glDisableVertexAttribArray(sal_##attr##_below);


void
pWorld::time_advance_gpu()
{
  gpu_shader_init();

  //  const float delta_t = step_duration * ( 0.7 + 0.6 * drand48() );
  const float delta_t = step_duration;
  const float h_delta_t = delta_t / 2.0;
  const float h_delta_t_sq = delta_t * delta_t / 2.0;
  const float sixth_delta_t_sq = delta_t * delta_t / 6.0;
  const float delta_t_inv = 1.0 / delta_t;
  pCube cube0 = cube;
  pVect gp_gravity_force = gp_mass * accel;
  const float damping_factor =
    damping_factor_coefficient * gp_mass * delta_t_inv * 0.125;
  const float gp_mass_inv = 1.0 / gp_mass;
#if 0
  const float grid_pitch = 1.0 / grid_limit;
  const float contact_distance_thr = max(grid_pitch,ball_size);
#endif
  const float ball_size_sq = ball_size * ball_size;

  static int iteration = 0;

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

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  vs_physics->use();
  glUniform2f(sun_ball_size,ball_size,ball_size_sq);
  glUniform1f(sun_delta_t,delta_t);
  glUniform3fv(sun_gravity_force,1,gp_gravity_force);
  glUniform1f(sun_gs_constant,gs_constant);
  glUniform1f(sun_damping_factor,damping_factor);
  glUniform1f(sun_gp_mass_inv,gp_mass_inv);
  pError_Check();

  pGrid& g0 = *grids[0];
  pGrid_Point* const grid = g0.grid_cur();

  const int num_points = g0.size * g0.size * 6;

  const GLint var_locations[] =
    { svl_position, svl_velocity, svl_force, svl_extra };
  const int var_count = sizeof(var_locations) / sizeof(var_locations[0]);

  glTransformFeedbackVaryingsNV
    (vs_physics->pobject, var_count, &var_locations[0],
     GL_INTERLEAVED_ATTRIBS_NV);
  pError_Check();

  transfer_grid_to_buffer();

  while ( time_advance_vars() )
    {
      iteration++;

      glClear(GL_COLOR_BUFFER_BIT);

      glVertexAttrib1f(sal_step_last_time,step_last_time);
      glVertexAttrib3fv(sal_ball_position,ball_position);
      glVertexAttrib3fv(sal_ball_speed,ball_speed);

      cube.m.apply(cube_spin);
      glLoadTransposeMatrixf(cube.m.a);

      glBindBufferOffsetNV
        (GL_TRANSFORM_FEEDBACK_BUFFER_NV, 0,
         position_buffer_nxt, grid_row_stride);

      glBindBuffer(GL_ARRAY_BUFFER,position_buffer_cur);
      glVertexPointer
        (4, GL_FLOAT, grid_point_stride, grid_offset(&grid[0].position));
      glEnableClientState(GL_VERTEX_ARRAY);

      glVertexAttribPointer
        (sal_velocity, 3, GL_FLOAT, false, grid_point_stride,
         grid_offset(&grid[0].velocity));
      glEnableVertexAttribArray(sal_velocity);

      glVertexAttribPointer
        (sal_force, 3, GL_FLOAT, false, grid_point_stride,
         grid_offset(&grid[0].force));
      glEnableVertexAttribArray(sal_force);

      glVertexAttribPointer
        (sal_extra, 3, GL_FLOAT, false, grid_point_stride,
         grid_offset(&grid[0].contact_time));
      glEnableVertexAttribArray(sal_extra);

      ATTR(position);  ATTR(velocity);
      pError_Check();

      int feedback_tries = 0;

      while ( true )
        {
          feedback_tries++;
          glBeginTransformFeedbackNV(GL_POINTS);
          pError_Check();
          glBeginQuery
            (GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV,
             query_transform_feedback_id );
          //  GL_PRIMITIVES_GENERATED_NV

          glDrawArrays(GL_POINTS,0,num_points);
          pError_Check();
          glEndTransformFeedbackNV();
          glEndQuery(GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN_NV);

          int done_points = -1;
          glGetQueryObjectiv
            (query_transform_feedback_id,GL_QUERY_RESULT,&done_points);
          pError_Check();
          if ( num_points == done_points )
            {
              if ( feedback_tries > 1 )
                printf("Feedback got correct number after %d tries.\n",
                       feedback_tries);
              break;
            }
          if ( feedback_tries > 10 ) pError_Exit();
          if ( 0 ) printf("Difference: %d - %d = %d\n",
                          done_points, num_points, done_points-num_points);
        }

      glBindBuffer(GL_ARRAY_BUFFER,0);

      glReadBuffer(GL_COLOR_ATTACHMENT0_EXT);
      pCoor pb[4];
      glReadPixels(0,0,2,2,GL_RGBA,GL_FLOAT,&pb[0]);
      pError_Check();
      pVect ball_impact_v_sum(pb[0]);

      ball_speed += delta_t * accel + ball_impact_v_sum * gp_mass / ball_mass;
      ball_position = ball_position + ball_speed * delta_t;

      if ( ball_position.y < -3 )
        {
          ball_position = pCoor(0,0,0);
          ball_speed = pVect(0,0,0);
        }

      position_buffer_swap();
    }

  //  transfer_buffer_to_grid();

#if 0
  pGrid_Point* const grid_nxt = g0.grid_cur();
  glBindBuffer(GL_ARRAY_BUFFER,position_buffer_nxt);
  pGrid_Point* const mapped_nxt =
    (pGrid_Point*) glMapBuffer(GL_ARRAY_BUFFER,GL_READ_ONLY);
  pError_Check();
  memcpy(((char*)&grid_nxt[0]),((char*)mapped_nxt)+grid_row_stride,
	 grid_cube_data_chars);
  glUnmapBuffer(GL_ARRAY_BUFFER);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  pError_Check();
#endif

  glDisableClientState(GL_VERTEX_ARRAY);

  ATTR_D(position);  ATTR_D(velocity);
  glDisableVertexAttribArray(sal_velocity);
  glDisableVertexAttribArray(sal_extra);
  pError_Check();

  glPopMatrix();

  if ( false )
  for ( int f=0; f<6; f++ )
    {
      pGrid& g = *grids[f];

      if ( false )
      for ( int ga=1; ga<grid_limit; ga++ )
        for ( int gb=1; gb<grid_limit; gb++ )
	  {
	    pGrid_Point& gp = g.point_cur(ga,gb);
	    pGrid_Point& gp_nxt = g.point_nxt(ga,gb);
	    pGrid_Point gp_nxt_gpu = gp_nxt;
	    pVect dist_sum = pVect(0,0,0);
	    pVect delta_v_sum = pVect(0,0,0);
	    for ( int n=0; n<4; n++ )
	      {
                pGrid_Point& np = g.neighbor(ga,gb,n);
                pVect dist = np.position - gp.position;
                dist_sum += dist;
                delta_v_sum += np.velocity;
	      }
	    pVect force_now =
	      gp_gravity_force + dist_sum * gs_constant
	      + damping_factor * ( delta_v_sum - 4.0 * gp.velocity );
	    pVect delta_f = ( force_now - gp.force );
	    gp_nxt.velocity = gp.velocity +
	      gp_mass_inv * ( delta_t * force_now - h_delta_t * delta_f );
	    const float vsq = dot(gp_nxt.velocity,gp_nxt.velocity);
	    if ( fabs(vsq) > 1e10 )
	      {
                printf("Out of control at t = %.3f\n",
		       time_wall_fp() - start_time);
                pError_Exit();
	      }
	    pVect displacement =
	      gp_nxt.velocity * delta_t
	      + gp_mass_inv
	      * ( h_delta_t_sq * force_now + sixth_delta_t_sq * delta_f );
	    gp_nxt.force = force_now;
	    gp_nxt.position = gp.position + displacement;
	    pError_Check_Distance(gp_nxt.position,gp_nxt_gpu.position);
	    if ( delta_t == -1 ) return;
	  }

      pPlane face = cube.face(f);
      pCube_Face_Info* const fi = &cube_face_generic_info[f];
      pCoor v00 = cube.m * fi->v00;
      pCoor v01 = cube.m * fi->v01;
      pCoor v10 = cube.m * fi->v10;
      pVect length_a = v10 - v00;
      pVect length_b = v01 - v00;
      pVect delta_a = length_a / grid_limit;
      pVect delta_b = length_b / grid_limit;

      pCoor vtop = v00;
      pCoor vbot = v01;
      pCoor vleft = v00;
      pCoor vright = v10;
      if ( false )
      for ( int gi=0; gi<=grid_limit; gi++ )
        {
	  grid_edge_update(g,gi,0,vtop,delta_a,delta_t_inv);
	  grid_edge_update(g,gi,grid_limit,vbot,delta_a,delta_t_inv);
	  grid_edge_update(g,0,gi,vleft,delta_b,delta_t_inv);
	  grid_edge_update(g,grid_limit,gi,vright,delta_b,delta_t_inv);
        }
      g.state_swap();
    }

  pError_Check();
  glClampColorARB(GL_CLAMP_VERTEX_COLOR_ARB,GL_TRUE);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0 );
}


void
pWorld::time_step_cpu()
{
  //  const float delta_t = step_duration * ( 0.7 + 0.6 * drand48() );
  const float delta_t = step_duration;
  const float h_delta_t = delta_t / 2.0;
  const float h_delta_t_sq = delta_t * delta_t / 2.0;
  const float sixth_delta_t_sq = delta_t * delta_t / 6.0;
  const float delta_t_inv = 1.0 / delta_t;
  pCube cube0 = cube;
  cube.m.apply(cube_spin);
  pVect gp_gravity_force = gp_mass * accel;
  const float damping_factor = 
    damping_factor_coefficient * gp_mass * delta_t_inv * 0.125;
  const float gp_mass_inv = 1.0 / gp_mass;
#if 0
  const float grid_pitch = 1.0 / grid_limit;
  const float contact_distance_thr = max(grid_pitch,ball_size);
#endif

  static int iteration =0;
  iteration++;

  for ( int f=0; f<6; f++ )
    {
      pGrid& g = *grids[f];

      for ( int ga=1; ga<grid_limit; ga++ )
        for ( int gb=1; gb<grid_limit; gb++ )
	  {
	    pGrid_Point& gp = g.point_cur(ga,gb);
	    pGrid_Point& gp_nxt = g.point_nxt(ga,gb);
	    pVect dist_sum = pVect(0,0,0);
	    pVect delta_v_sum = pVect(0,0,0);
	    for ( int n=0; n<4; n++ )
	      {
                pGrid_Point& np = g.neighbor(ga,gb,n);
                pVect dist = np.position - gp.position;
                dist_sum += dist;
                delta_v_sum += np.velocity;
	      }
	    pVect force_now =
	      gp_gravity_force + dist_sum * gs_constant
	      + damping_factor * ( delta_v_sum - 4.0 * gp.velocity );
	    pVect delta_f = ( force_now - gp.force );
	    gp_nxt.velocity = gp.velocity +
	      gp_mass_inv * ( delta_t * force_now - h_delta_t * delta_f );
	    const float vsq = dot(gp_nxt.velocity,gp_nxt.velocity);
	    if ( fabs(vsq) > 1e10 )
	      {
                printf("Out of control at t = %.3f\n",
		       time_wall_fp() - start_time);
                pError_Exit();
	      }
	    pVect displacement =
	      gp_nxt.velocity * delta_t
	      + gp_mass_inv
	      * ( h_delta_t_sq * force_now + sixth_delta_t_sq * delta_f );
	    gp_nxt.force = force_now;
	    gp_nxt.position = gp.position + displacement;
	  }

      pPlane face = cube.face(f);
      pCube_Face_Info* const fi = &cube_face_generic_info[f];
      pCoor v00 = cube.m * fi->v00;
      pCoor v01 = cube.m * fi->v01;
      pCoor v10 = cube.m * fi->v10;
      pVect length_a = v10 - v00;
      pVect length_b = v01 - v00;
      pVect delta_a = length_a / grid_limit;
      pVect delta_b = length_b / grid_limit;

      pCoor vtop = v00;
      pCoor vbot = v01;
      pCoor vleft = v00;
      pCoor vright = v10;
      for ( int gi=0; gi<=grid_limit; gi++ )
        {
	  grid_edge_update(g,gi,0,vtop,delta_a,delta_t_inv);
	  grid_edge_update(g,gi,grid_limit,vbot,delta_a,delta_t_inv);
	  grid_edge_update(g,0,gi,vleft,delta_b,delta_t_inv);
	  grid_edge_update(g,grid_limit,gi,vright,delta_b,delta_t_inv);
        }
      g.state_swap();
    }

  pVect ball_impact_v_sum(0,0,0);

  const int edge[6][4] =
    {{0,1,1,1}, {0,1,1,1},
     {1,1,1,1}, {0,0,1,1},
     {0,0,0,0}, {0,0,0,0} };
  const float ball_size_sq = ball_size * ball_size;

  for ( int f=0; f<6; f++ )
    {
      pGrid& g = *grids[f];
      pCube_Face_Info* const fi = &cube_face_generic_info[f];
      const int idx_a_start = edge[f][0];
      const int idx_a_stop = grid_limit - edge[f][1];
      const int idx_b_start = edge[f][2];
      const int idx_b_stop = grid_limit - edge[f][3];

      for ( int ga=idx_a_start; ga<=idx_a_stop; ga++ )
        for ( int gb=idx_b_start; gb<=idx_b_stop; gb++ )
	  {
	    pGrid_Point& gp = g.point_cur(ga,gb);
	    pVect gp_to_ball(ball_position,gp.position);
	    const float dist_sq = dot(gp_to_ball,gp_to_ball);
	    //  if ( dir.magnitude > contact_distance_thr ) continue;
	    if ( dist_sq > ball_size_sq ) continue;
	    pNorm gp_to_ball_n(gp_to_ball);

	    pVect plane_vect(0,0,0);

	    pCoor* const gp_l = ga > 0 ? &g.point_cur(ga-1,gb).position : NULL;
	    pCoor* const gp_r =
	      ga < grid_limit ? &g.point_cur(ga+1,gb).position : NULL;
	    pCoor* const gp_b = gb > 0 ? &g.point_cur(ga,gb-1).position : NULL;
	    pCoor* const gp_t =
	      gb < grid_limit ? &g.point_cur(ga,gb+1).position : NULL;

	    if ( gp_r && gp_t ) plane_vect += cross(*gp_r,gp.position,*gp_t);
	    if ( gp_t && gp_l ) plane_vect += cross(*gp_t,gp.position,*gp_l);
	    if ( gp_l && gp_b ) plane_vect += cross(*gp_l,gp.position,*gp_b);
	    if ( gp_b && gp_r ) plane_vect += cross(*gp_b,gp.position,*gp_r);

	    const bool boundary = ga == 0 || gb == 0
	      || ga == grid_limit || gb == grid_limit;

	    if ( !fi->cross_inside ) plane_vect.flip();

	    pNorm plane_norm(plane_vect);
	    //  const float closest = dot(gp_to_ball, plane_norm);

	    pVect gp_v_wrt_ball(gp.velocity,ball_speed);

	    // Quick and dirty
	    if ( !boundary )
	      gp.position = ball_position + gp_to_ball_n * ball_size;
	    const float s_to_ball = -dot(plane_norm,gp_v_wrt_ball);

	    //  gp.position += plane_norm * (closest - ball_size);
	    gp.contact_time = step_last_time;
	    pVect v_to_ball = s_to_ball * plane_norm;
	    ball_impact_v_sum += v_to_ball;
	    gp.velocity += -1.5 * v_to_ball;
	    //  gp.velocity = ball_speed;
	  }
    }

  ball_speed += delta_t * accel + ball_impact_v_sum * gp_mass / ball_mass;
  ball_position = ball_position + ball_speed * delta_t;

  if ( ball_position.y < -3 )
    {
      ball_position = pCoor(0,0,0);
      ball_speed = pVect(0,0,0);
    }
}

pWorld world;

struct pF { float order; int f; pF(float o,int f):order(o),f(f){} };
bool operator < (pF a, pF b) { return a.order > b.order; }

// ------
// Routine which actually does the drawing

void cbRenderScene(
  void
)
{
   char buf[80]; // For our strings.

   frame_timer.frame_start();

    pCube& cube = world.cube;
   // Rotate the calculated amount.
    pError_Check();
    world.time_advance();
    pError_Check();

   // Enables, disables or otherwise adjusts as
   // appropriate for our current settings.

   pError_Check();

   if (Texture_On)
      glEnable(GL_TEXTURE_2D);
   else
      glDisable(GL_TEXTURE_2D);

   if (Light_On)
      glEnable(GL_LIGHTING);
   else
      glDisable(GL_LIGHTING);

    if (true)
       glBlendFunc(GL_SRC_ALPHA,GL_ONE);
    else
       glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_ALPHA_TEST);

    // If we're blending, we don't want z-buffering.
    if (Blend_On)
      {
        glDepthFunc(GL_ALWAYS);
        //  glDisable(GL_ALPHA_TEST);
        glEnable(GL_BLEND);
      }
    else
      {
        glDepthFunc(GL_LESS);
        glDisable(GL_BLEND);
      }

    if (Filtering_On) {
       glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
					   GL_LINEAR_MIPMAP_LINEAR);
       glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    } else {
       glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
					   GL_NEAREST_MIPMAP_NEAREST);
       glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
    }

    if ( false )
      {
        glEnable(GL_FOG);
        glFogi(GL_FOG_MODE,GL_LINEAR);
        glFogi(GL_FOG_COORDINATE_SOURCE,GL_FRAGMENT_DEPTH);
        glFogf(GL_FOG_START,-4);
        glFogf(GL_FOG_END,-6);
      }


   // Need to manipulate the ModelView matrix to move our model around.
   glMatrixMode(GL_MODELVIEW);

   // Reset to 0,0,0; no rotation, no scaling.
   glLoadIdentity();

   // Move the object back from the screen.
   glTranslatef(0.0f,0.0f,Z_Off);

   // Clear the color and depth buffers.
   glClearColor(0,0,0.1,0.5);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

   glColor4f(1,1,1,1.0);
   glPushMatrix();
   glMultTransposeMatrixf(cube.m.a);
   const float contact_mark_duration = 10;
   const float contact_mark_mult = 1.0 / contact_mark_duration;
   const float time_th = world.step_last_time - contact_mark_duration;

   std::priority_queue<pF> part_idx;
   pCoor eye = pCoor(0,0,-Z_Off);
   for ( int f=0; f<6; f++ )
     {
       pPlane face = cube.face(f);
       pCoor ctr = face.point;
       pVect face_to_eye(ctr,eye);
       const float frontness = dot(face_to_eye,face.normal);
       part_idx.push(pF(frontness,f));
     }

   bool ball_rendered = false;
   pError_Check();
   int faces = 0;

   while ( !part_idx.empty() )
     {
       faces++;
       //  if ( faces == 1 ) break;
       pF fi = part_idx.top();  part_idx.pop();
       pVect plane = cube.face_local(fi.f).normal;
       const bool front = fi.order >= 0;
       pError_Check();

       if ( !ball_rendered && front )
	 {
	   vs_fixed->use();
	   ball_rendered = true;
	   glDepthFunc(GL_LESS);
	   glDisable(GL_BLEND);
	   glDisable(GL_STENCIL_TEST);
	   glDisable(GL_TEXTURE_2D);
	   glColor4f(0x58/255.0,0xd/255.0,0xa6/255.0,1);
           float light[4];
           for ( int i=0; i<3; i++ )
             light[i] = Light_Ambient[i] + Light_Diffuse[i];
           light[3] = 1;
           glLightfv(GL_LIGHT1, GL_AMBIENT,  Light_Off);
           glLightfv(GL_LIGHT1, GL_DIFFUSE, light);
	   //  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, Light_Specular);
	   glPushMatrix();
	   pCoor ball_pos = cube.localize(world.ball_position);
	   glTranslatef(ball_pos.x,ball_pos.y,ball_pos.z);
	   gluSphere(world.ball,world.ball_size*0.5,20,20);
	   glPopMatrix();
	   if ( Blend_On )
	     {
	       glDisable(GL_ALPHA_TEST);
	       glEnable(GL_BLEND);
	       glDepthFunc(GL_ALWAYS);
	     }
           glLightfv(GL_LIGHT1, GL_AMBIENT,  Light_Ambient);
           glLightfv(GL_LIGHT1, GL_DIFFUSE,  Light_Diffuse);
	   pError_Check();
	 }

       pCube_Face_Info& fci = world.cube_face_info[fi.f];
       pCube_Face_Info& fgi = world.cube_face_generic_info[fi.f];

       glBindTexture(GL_TEXTURE_2D,fci.texid);
       glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
       glEnable(GL_TEXTURE_2D);

       if ( opt_gpu ) vs_faces->use(); else vs_lighting->use();

       pGrid& g = *world.grids[fi.f];
       pGrid_Point& gp_first = g.point_cur(0,0);

       glPopMatrix();
       pError_Check();
       const int grid_point_stride = world.grid_point_stride;

       if ( !opt_gpu )
       for ( int ga=0; ga<=world.grid_limit; ga++ )
	 for ( int gb=0; gb<=world.grid_limit; gb++ )
	   {
	     const int idx = g.point_idx(ga,gb);
	     pGrid_Point& gp_00 = g.point_cur(ga,gb);

	     if ( gp_00.contact_time > time_th )
	       {
		 const float gb =
		   ( world.step_last_time - gp_00.contact_time )
		   * contact_mark_mult;
                 world.color_buffer[idx].set(1,gb,gb,0.9);
	       }
	     else
	       world.color_buffer[idx].set(1,1,1,1);

	     if ( ga == world.grid_limit || gb == world.grid_limit ) continue;

	     const int idx_10 = g.point_idx(ga+1,gb);
	     pGrid_Point& gp_10 = g.point_cur(ga+1,gb);
	     pGrid_Point& gp_01 = g.point_cur(ga,gb+1);
	     pGrid_Point& gp_11 = g.point_cur(ga+1,gb+1);

	     pNorm ll(cross(gp_00.position,gp_01.position,gp_11.position));
             pNorm ur(cross(gp_11.position,gp_10.position,gp_00.position));
	     if ( fgi.cross_inside ) {ll.flip();  ur.flip();}
	     if ( ga == 0 || gb == 0 )
	       world.normal_buffer[idx] = ll;
	     else
	       world.normal_buffer[idx] += ll;
	     world.normal_buffer[idx_10] = ur;
	   }

       if ( opt_gpu )
         {
           glBindBuffer(GL_ARRAY_BUFFER, world.position_buffer_cur);
           glVertexPointer
             (4, GL_FLOAT, grid_point_stride,
              world.grid_offset(&gp_first.position));
           pError_Check();
           glVertexAttribPointer
             (sal_fposition_left, 4, GL_FLOAT, false, grid_point_stride,
              world.grid_offset(&gp_first.position,-1,0));
           pError_Check();
           glVertexAttribPointer
             (sal_fposition_right, 4, GL_FLOAT, false, grid_point_stride,
              world.grid_offset(&gp_first.position,1,0));
           glVertexAttribPointer
             (sal_fposition_above, 4, GL_FLOAT, false, grid_point_stride,
              world.grid_offset(&gp_first.position,0,-1));
           glVertexAttribPointer
             (sal_fposition_below, 4, GL_FLOAT, false, grid_point_stride,
              world.grid_offset(&gp_first.position,0,1));
           glVertexAttribPointer
             (sal_fin_extra, 3, GL_FLOAT, false, grid_point_stride,
              world.grid_offset(&gp_first.contact_time));
           pError_Check();
           glEnableVertexAttribArray(sal_fposition_left);
           glEnableVertexAttribArray(sal_fposition_right);
           glEnableVertexAttribArray(sal_fposition_above);
           glEnableVertexAttribArray(sal_fposition_below);
           glEnableVertexAttribArray(sal_fin_extra);
           glBindBuffer(GL_ARRAY_BUFFER, 0);
           glVertexAttrib1f(sal_ftime_th,time_th);
           pError_Check();
         }
       else
         {
           glVertexPointer(4, GL_FLOAT, grid_point_stride, &gp_first.position);
         }

       glEnableClientState(GL_VERTEX_ARRAY);

       glBindBuffer(GL_ARRAY_BUFFER, world.texture_buffer_id);
       glTexCoordPointer
         (2, GL_FLOAT, sizeof(g.texture_a[0]),
          ((GLvoid*)(sizeof(g.texture_a[0]) * g.idx)));
       glEnableClientState(GL_TEXTURE_COORD_ARRAY);
       glBindBuffer(GL_ARRAY_BUFFER, 0);

       if ( !opt_gpu )
         {
           glNormalPointer(GL_FLOAT, sizeof(pVect), world.normal_buffer);
           glEnableClientState(GL_NORMAL_ARRAY);
           glColorPointer(4, GL_FLOAT, sizeof(pCoor), world.color_buffer);
           glEnableClientState(GL_COLOR_ARRAY);
         }

       glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, world.index_buffer_id);
       glDrawElements
	 (GL_TRIANGLES,world.index_buffer_size,GL_UNSIGNED_INT,NULL);
       glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

       glDisableClientState(GL_VERTEX_ARRAY);
       glDisableClientState(GL_TEXTURE_COORD_ARRAY);
       glDisableClientState(GL_NORMAL_ARRAY);
       glDisableClientState(GL_COLOR_ARRAY);

       if ( opt_gpu )
         {
           glDisableVertexAttribArray(sal_fposition_left);
           glDisableVertexAttribArray(sal_fposition_right);
           glDisableVertexAttribArray(sal_fposition_above);
           glDisableVertexAttribArray(sal_fposition_below);
           glDisableVertexAttribArray(sal_fin_extra);
         }

       pError_Check();

       glPushMatrix();
       glMultTransposeMatrixf(cube.m.a);
     }

   vs_fixed->use();

   glPopMatrix();

   // Move back to the origin (for the text, below).
   glLoadIdentity();

   // We need to change the projection matrix for the text rendering.
   glMatrixMode(GL_PROJECTION);

   // But we like our current view too; so we save it here.
   glPushMatrix();

   // Now we set up a new projection for the text.
   glLoadIdentity();
   glOrtho(0,Window_Width,0,Window_Height,-1.0,1.0);

   // Lit or textured text looks awful.
   glDisable(GL_TEXTURE_2D);
   glDisable(GL_LIGHTING);

   // We don't want depth-testing either.
   glDisable(GL_DEPTH_TEST);

   // But, for fun, let's make the text partially transparent too.
   glColor4f(0.6,1.0,0.6,.75);

   // Render our various display mode settings.
   sprintf(buf,"Mode: %s", TexModesStr[Curr_TexMode]);
   glRasterPos2i(2,2);
   glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"GPU Physics: %d", opt_gpu);
   glRasterPos2i(2,14); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"Blend: %d", Blend_On);
   glRasterPos2i(2,26); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   Variable_Control_Elt* const cvar = world.variable_control.current;
   if ( cvar )
     {
       sprintf(buf,"VAR %s = %.3f", cvar->name, cvar->var[0]);
       glRasterPos2i(2,38); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);
     }

   sprintf(buf,"Tex: %d", Texture_On);
   glRasterPos2i(2,50); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"Filt: %d", Filtering_On);
   glRasterPos2i(2,62); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);


   // Now we want to render the calulated FPS at the top.

   // To ease, simply translate up.  Note we're working in screen
   // pixels in this projection.

   glTranslatef(6.0f,Window_Height - 14,0.0f);

   // Make sure we can read the FPS section by first placing a
   // dark, mostly opaque backdrop rectangle.
   glColor4f(0.2,0.2,0.2,0.75);

   glBegin(GL_QUADS);
   glVertex3f(  0.0f, -2.0f, 0.0f);
   glVertex3f(  0.0f, 12.0f, 0.0f);
   glVertex3f(140.0f, 12.0f, 0.0f);
   glVertex3f(140.0f, -2.0f, 0.0f);
   glEnd();

   frame_timer.frame_end();

   glColor4f(0.9,0.2,0.2,.75);
   glRasterPos2i(6,0);
   glutBitmapString(GLUT_BITMAP_HELVETICA_12,frame_timer.frame_rate_text_get());

   // Done with this special projection matrix.  Throw it away.
   glPopMatrix();

   // All done drawing.  Let's show it.
   glutSwapBuffers();
}

void
cbTimer(int data)
{
  static double next_frame_time = 0;
  if ( next_frame_time == 0 ) next_frame_time = time_wall_fp();
  glutPostRedisplay();
  const double now = time_wall_fp();
  next_frame_time += 1.0/30.0;
  const double delta = next_frame_time - now;
  const int delta_ms = delta <= 0 ? 0 : int(delta * 1000);

  glutTimerFunc(delta_ms,cbTimer,0);
}

void
use_timer()
{
  glutIdleFunc(NULL);
  glutTimerFunc(10,cbTimer,0);
  printf("Switching from idle callback to timer callback.\n");
}

void
cb_idle()
{
  if ( !ptr_glXGetVideoSyncSGI ) { use_timer(); return; }
# ifdef GLX_SGI_video_sync
  unsigned int count;
  ptr_glXGetVideoSyncSGI(&count);
  //  const int div = 1 << 5;
  //  int rem = ( world.xfcount + 1 ) & (div-1);
  unsigned int count_after;
  if ( ptr_glXWaitVideoSyncSGI(1,0,&count_after) )
    {
      use_timer();
      return;
    }
  glutPostRedisplay();
# endif
}

void
pSet_Mode()
{
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,TexModes[Curr_TexMode]);
}

// ------
// Callback function called when a normal key is pressed.

void cbKeyPressed(
   unsigned char key,
   int x, int y
)
{
   switch (key) {
      case 113: case 81: case 27: // Q (Escape) - We're outta here.
      glutDestroyWindow(Window_ID);
      exit(1);
      break; // exit doesn't return, but anyway...

   case 130: case 98: // B - Blending.
      Blend_On = Blend_On ? 0 : 1;
      break;

   case 108: case 76:  // L - Lighting
      Light_On = Light_On ? 0 : 1;
      break;

   case 109: case 77:  // M - Mode of Blending
      if ( ++ Curr_TexMode > 3 )
	 Curr_TexMode=0;
      pSet_Mode();
      break;

   case 'P': case 'p':
     world.pause = !world.pause;
     break;

   case 'S': case 's':
     world.ball_speed = pVect(0,0,0);
     break;

   case 116: case 84: // T - Texturing.
      Texture_On = Texture_On ? 0 : 1;
      break;

   case 97: case 65:  // A: Use gpu.
     opt_gpu = !opt_gpu;
     break;

   case 102: case 70:  // F - Filtering.
      Filtering_On = Filtering_On ? 0 : 1;
      break;

   case 32:  // F (Space) - Freeze!
      Z_Speed=X_Speed=Y_Speed=0;
      break;

   case 114: case 82:  // R - Reverse.
      X_Speed=-X_Speed;
      Y_Speed=-Y_Speed;
      Z_Speed=-Z_Speed;
      break;

   case 9: // Tab
     world.variable_control.switch_var_right();
     break;

   case '+': case '=':
     //  Z_Off *= .95f;
     world.variable_control.adjust_higher();
     break;

   case '-':
     world.variable_control.adjust_lower();
     //  Z_Off *= 1.05f;
     break;

   default:
      printf ("KP: No action for %d.\n", key);
      break;
    }
}


// ------
// Callback Function called when a special key is pressed.

void cbSpecialKeyPressed(
   int key,
   int x,
   int y
)
{
  const float min_speed = 0.01;
#define FASTER(axis) axis += min_speed;
#define SLOWER(axis) axis -= min_speed;
   switch (key) {
   case GLUT_KEY_PAGE_UP: FASTER(Z_Speed); break;
   case GLUT_KEY_PAGE_DOWN: SLOWER(Z_Speed); break;
   case GLUT_KEY_UP: FASTER(X_Speed); break;
   case GLUT_KEY_DOWN: SLOWER(X_Speed); break;
   case GLUT_KEY_RIGHT: FASTER(Y_Speed); break;
   case GLUT_KEY_LEFT: SLOWER(Y_Speed); break;
   case GLUT_KEY_F12: write_img(); break;
   default:
      printf ("SKP: No action for %d.\n", key);
      break;
    }
}

int
pBuild_Texture_File
(const char *name, bool invert = false, int transp = 256 )
{
  GLenum gluerr;
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;
  if ( invert ) image.color_invert();
  glGenTextures(1,&Texture_ID);
  glBindTexture(GL_TEXTURE_2D,Texture_ID);
  if ( ( gluerr =
	 gluBuild2DMipmaps
	 (GL_TEXTURE_2D,
	  GL_RGBA,
	  //  GL_DEPTH_COMPONENT,
	  image.width, image.height,
	  GL_RGBA, GL_UNSIGNED_BYTE, (void *)image.data))) {

      fprintf(stderr,"GLULib%s\n",gluErrorString(gluerr));
      exit(-1);
   }

   // Some pretty standard settings for wrapping and filtering.
   glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
   glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

   return Texture_ID;
}



// ------
// Function to build a simple full-color texture with alpha channel,
// and then create mipmaps.  This could instead load textures from
// graphics files from disk, or render textures based on external
// input.

void ourBuildTextures(
   void
)
{
   GLenum gluerr;
   GLubyte tex[128][128][4];
   int x,y,t;
   int hole_size = 3300; // ~ == 57.45 ^ 2.

   // Generate a texture index, then bind it for future operations.
   glGenTextures(1,&Texture_ID);
   glBindTexture(GL_TEXTURE_2D,Texture_ID);
   texid_pie = texid_syllabus = texid_bldg = Texture_ID;

   // Iterate across the texture array.

   for(y=0;y<128;y++) {
      for(x=0;x<128;x++) {

	 // A simple repeating squares pattern.
	 // Dark blue on white.

	 if ( ( (x+4)%32 < 8 ) && ( (y+4)%32 < 8)) {
	    tex[x][y][0]=tex[x][y][1]=0; tex[x][y][2]=120;
	 } else {
	    tex[x][y][0]=tex[x][y][1]=tex[x][y][2]=240;
	 }

		 // Make a round dot in the texture's alpha-channel.

		 // Calculate distance to center (squared).
	 t = (x-64)*(x-64) + (y-64)*(y-64) ;

	 if ( t < hole_size) // Don't take square root; compare squared.
	    tex[x][y][3]=255; // The dot itself is opaque.
	 else if (t < hole_size + 100)
	    tex[x][y][3]=128; // Give our dot an anti-aliased edge.
	 else
	    tex[x][y][3]=0;   // Outside of the dot, it's transparent.

      }
   }

   // The GLU library helps us build MipMaps for our texture.

   if ((gluerr=gluBuild2DMipmaps(GL_TEXTURE_2D, 4, 128, 128, GL_RGBA,
		 GL_UNSIGNED_BYTE, (void *)tex))) {

      fprintf(stderr,"GLULib%s\n",gluErrorString(gluerr));
      exit(-1);
   }

   // Some pretty standard settings for wrapping and filtering.
   glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
   glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

   // We start with GL_DECAL mode.
   glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
}


// ------
// Callback routine executed whenever our window is resized.  Lets us
// request the newly appropriate perspective projection matrix for
// our needs.  Try removing the gluPerspective() call to see what happens.

void cbResizeScene(
   int Width,
   int Height
)
{
   // Let's not core dump, no matter what.
   if (Height == 0)
      Height = 1;

   glViewport(0, 0, Width, Height);

   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   // gluPerspective: Field of view in y, aspect ratio, near, far.
   gluPerspective(45.0f,(GLfloat)Width/(GLfloat)Height,0.1f,100.0f);
   // Also: gluLookAt.

   glMatrixMode(GL_MODELVIEW);

   Window_Width  = Width;
   Window_Height = Height;
}

void
pWorld::init()
{
  cube.set(pCoor(-1,-1,-1),2);
  ball = gluNewQuadric();

  frame_timer.work_unit_set(&time_step_num,"Time Step Rate");

  cube_face_info[3].init(3,texid_bldg,.05,.05,.95,.95);
  cube_face_info[1].init(1,texid_pie,.05,.05,.95,.95);
  cube_face_info[2].init(2,texid_syllabus,.2,.2,.8,.8);
  cube_face_info[0].init(0,texid_syllabus,.05,.05,1.95,1.95);
  cube_face_info[4].init(4,texid_syllabus,.05,.05,4.5,4.5);
  cube_face_info[5].init(5,texid_syllabus,.05,.05,.95,.95);
  //  cube_face_info[5].init(5,texid_pie,0,0,1,1);

  grid_limit = grid_size + 1;

  const double face_mass = 15;
  gp_mass = face_mass / ( grid_size * grid_size );
  //  const double gs_constant_base = 200000;
  const double gs_constant_base = 6451;
  //  gs_constant = gs_constant_base / ( grid_limit * (grid_limit + 1) );
  gs_constant = gs_constant_base / grid_limit;
  variable_control.insert(gs_constant,"Spring Constant");
  damping_factor_coefficient = 1;
  variable_control.insert(damping_factor_coefficient,"Damping Factor");

  ball_mass = face_mass * 0.5;
  variable_control.insert(ball_mass,"Ball Mass");
  variable_control.insert(Z_Off,"Z Position");

  for ( int f=0; f<6; f++ )
    {
      pCube_Face_Info* const fi = &cube_face_generic_info[f];
      const float dir = f & 1 ? 1.0 : 0.0;
      const int axis = f >> 1;
      pVect n(axis == 0, axis == 1, axis == 2);
      pVect a(axis != 0, axis == 0, 0);
      pVect b = pVect(1,1,1) - n - a;
      pCoor c00 = pCoor(0,0,0) + dir * n;
      fi->v00 = c00;
      fi->v10 = ( c00 + a );
      fi->v11 = ( c00 + a + b );
      fi->v01 = ( c00 + b );
      pVect axb = cross(a,b);
      fi->cross_inside = dot(pVect(1,1,1),axb) < 0 == bool(f & 1);
    }

  const int grid_elts_per_row = grid_limit + 1;
  const int grid_elts_per_face = grid_elts_per_row * grid_elts_per_row;
  const int grid_elts_per_cube = 6 * grid_elts_per_face + 2 * grid_elts_per_row;
  pGrid_Point* set_1 = new pGrid_Point[grid_elts_per_cube];
  pGrid_Point* set_2 = new pGrid_Point[grid_elts_per_cube];
  pVect* const texture_a = new pVect[grid_elts_per_cube];

  set_1 += grid_elts_per_row;
  set_2 += grid_elts_per_row;
  int idx = 0;

  for ( int f=0; f<6; f++ )
    {
      pPlane face = cube.face(f);
      pCube_Face_Info* const fgi = &cube_face_generic_info[f];
      pCube_Face_Info* const fi = &cube_face_info[f];
      pCoor v00 = cube.m * fgi->v00;
      pCoor v01 = cube.m * fgi->v01;
      pCoor v10 = cube.m * fgi->v10;
      pVect length_a = v10 - v00;
      pVect length_b = v01 - v00;
      pVect delta_a = length_a / grid_limit;
      pVect delta_b = length_b / grid_limit;
      pCoor va = v00;

      pGrid* const g = grids[f] =
        new pGrid(grid_limit+1, idx, set_1, set_2, texture_a);

      for ( int ga=0; ga<=grid_limit; ga++ )
        {
	  pCoor v = va;
	  for ( int gb=0; gb<=grid_limit; gb++ )
	    {
	      pGrid_Point& gp = g->point_cur(ga,gb);
	      pGrid_Point& gp_nxt = g->point_nxt(ga,gb);
	      gp.position = v;
	      gp.velocity = pVect(0,0,0);
	      gp.force = gp_mass * accel;
	      gp_nxt.cross_direction = gp.cross_direction =
                fgi->cross_inside ? 1 : -1;
	      gp_nxt.contact_time = gp.contact_time = -1000;
              gp_nxt.boundary = gp.boundary = 0; // Maybe changed in edge init.
	      pCoor vlocal = cube.localize(v);
	      pVect& gt = g->texture(ga,gb);
	      gt = fi->tmap(vlocal);
	      v += delta_b;
	    }
	  va += delta_a;
        }

      pCoor vl00 = fgi->v00;
      pCoor vl01 = fgi->v01;
      pCoor vl10 = fgi->v10;
      pVect llength_a = vl10 - vl00;
      pVect llength_b = vl01 - vl00;
      pVect ldelta_a = llength_a / grid_limit;
      pVect ldelta_b = llength_b / grid_limit;
      pCoor vtop = vl00;
      pCoor vbot = vl01;
      pCoor vleft = vl00;
      pCoor vright = vl10;

      for ( int gi=0; gi<=grid_limit; gi++ )
        {
	  grid_edge_init(g,gi,0,vtop,ldelta_a);
	  grid_edge_init(g,gi,grid_limit,vbot,ldelta_a);
	  grid_edge_init(g,0,gi,vleft,ldelta_b);
	  grid_edge_init(g,grid_limit,gi,vright,ldelta_b);
        }

    }

  color_buffer = new pCoor[ grid_elts_per_face ];
  normal_buffer = new pVect[ grid_elts_per_face ];
  index_buffer_size = grid_limit * grid_limit * 6;
  index_buffer = new int[ index_buffer_size ];

  {
    pGrid& g = *grids[0];
    int *ib = index_buffer;

    for ( int ga=0; ga<grid_limit; ga++ )
      for ( int gb=0; gb<grid_limit; gb++ )
        {
	  *ib++ = g.point_idx(ga,gb);
	  *ib++ = g.point_idx(ga,gb+1);
	  *ib++ = g.point_idx(ga+1,gb+1);

	  *ib++ = g.point_idx(ga+1,gb+1);
	  *ib++ = g.point_idx(ga+1,gb);
	  *ib++ = g.point_idx(ga,gb);
        }

    glGenBuffers(1, &index_buffer_id);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,index_buffer_id);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, index_buffer_size * sizeof(*ib),
                 index_buffer, GL_STATIC_DRAW);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
  }

  glGenBuffers(1, &texture_buffer_id );
  glBindBuffer(GL_ARRAY_BUFFER, texture_buffer_id);
  glBufferData(GL_ARRAY_BUFFER, idx * sizeof(texture_a[0]),
               texture_a, GL_STATIC_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, 0);

  pError_Check();

  vs_fixed = new pShader();
  //  vs_lighting = new pShader();

  vs_lighting = new pShader("cube5_shader.cc","vs_main_lighting();");
  vs_physics = new pShader("cube5_shader.cc","main_physics();");
  vs_faces = new pShader("cube5_shader.cc","main_faces();");

  sal_velocity = vs_physics->attribute_location("in_velocity");
  svl_velocity = vs_physics->varying_location("out_velocity");

  sal_force = vs_physics->attribute_location("in_force");
  svl_force = vs_physics->varying_location("out_force");

  sal_extra = vs_physics->attribute_location("in_extra");
  svl_extra = vs_physics->varying_location("out_extra");

  sal_position_left = vs_physics->attribute_location("position_left");
  sal_position_right = vs_physics->attribute_location("position_right");
  sal_position_above = vs_physics->attribute_location("position_above");
  sal_position_below = vs_physics->attribute_location("position_below");

  sal_velocity_left = vs_physics->attribute_location("velocity_left");
  sal_velocity_right = vs_physics->attribute_location("velocity_right");
  sal_velocity_above = vs_physics->attribute_location("velocity_above");
  sal_velocity_below = vs_physics->attribute_location("velocity_below");

  sal_step_last_time = vs_physics->attribute_location("step_last_time");
  sal_ball_position = vs_physics->attribute_location("ball_position");
  sal_ball_speed = vs_physics->attribute_location("ball_speed");

  svl_position = vs_physics->varying_location("out_position");

  sun_ball_size = vs_physics->uniform_location("ball_size");
  sun_gravity_force = vs_physics->uniform_location("gravity_force");
  sun_gs_constant = vs_physics->uniform_location("gs_constant");
  sun_gp_mass_inv = vs_physics->uniform_location("gp_mass_inv");
  sun_delta_t = vs_physics->uniform_location("delta_t");
  sun_damping_factor = vs_physics->uniform_location("damping_factor");

  vs_physics->print_active_varying();

  sal_ftime_th = vs_faces->attribute_location("time_th");

  sal_fstep_last_time = vs_faces->attribute_location("step_last_time");
  sal_fin_extra = vs_faces->attribute_location("in_extra");

  sal_fposition_left = vs_faces->attribute_location("position_left");
  sal_fposition_right = vs_faces->attribute_location("position_right");
  sal_fposition_above = vs_faces->attribute_location("position_above");
  sal_fposition_below = vs_faces->attribute_location("position_below");


  //  vs_bump->print_active_attrib();

  //  glActiveVaryingNV(prog,name);

  PRINT_ATTRIBUTE(GL_MAX_VERTEX_ATTRIBS);
  PRINT_ATTRIBUTE(GL_MAX_VERTEX_UNIFORM_COMPONENTS);
#ifdef GL_NV_transform_feedback
  PRINT_ATTRIBUTE(GL_MAX_VARYING_COMPONENTS_EXT);
  PRINT_ATTRIBUTE(GL_MAX_VERTEX_VARYING_COMPONENTS_EXT);
#endif
}


// ------
// Does everything needed before losing control to the main
// OpenGL event loop.

void ourInit(
  int Width,
  int Height
)
{
  if ( lite_textures )
    {
      ourBuildTextures();
      return;
    }

#if 1
  texid_syllabus =
    pBuild_Texture_File("gp.ppm",true,255);
  //  texid_pie = pBuild_Texture_File("/home/faculty/koppel/Web/pie2.pnm");
  texid_pie = pBuild_Texture_File("mesa-pandc.pnm",false,255);
  texid_bldg = pBuild_Texture_File("ee_bdg_to_ur_ed.ppm");
#else
  texid_syllabus = texid_pie = texid_bldg =
    pBuild_Texture_File("/home/faculty/koppel/Web/pie2.pnm");
#endif
   // Color to clear color buffer to.
   glClearColor(0.1f, 0.1f, 0.1f, 0.0f);
   glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

   // Depth to clear depth buffer to; type of test.
   glClearDepth(1.0);
   glClearStencil(7);
   glDepthFunc(GL_LESS);
   glAlphaFunc(GL_GREATER,0.1);

   // Enables Smooth Color Shading; try GL_FLAT for (lack of) fun.
   glShadeModel(GL_SMOOTH);

   // Load up the correct perspective matrix; using a callback directly.
   cbResizeScene(Width,Height);

   // Set up a light, turn it on.
   glLightfv(GL_LIGHT1, GL_POSITION, Light_Position);
   glLightfv(GL_LIGHT1, GL_AMBIENT,  Light_Ambient);
   glLightfv(GL_LIGHT1, GL_DIFFUSE,  Light_Diffuse);
   //  glLightfv(GL_LIGHT1, GL_SPECULAR,  Light_Specular);
   glEnable (GL_LIGHT1);

   // A handy option -- have surface material mirror the color.
   glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

   //  glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS,  0.9);

   glEnable(GL_COLOR_MATERIAL);
   glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,0);

   pSet_Mode();
}

// ------
// The main() function.  Inits OpenGL.  Calls our own init function,
// then passes control onto OpenGL.

int main(
  int argc,
  char **argv
)
{
   glutInit(&argc, argv);
   pError_Check();
   lglext_ptr_init();

   // To see OpenGL drawing, take out the GLUT_DOUBLE request.
   glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL );
   //  glutInitDisplayMode(GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL );
   glutInitWindowSize(Window_Width, Window_Height);

   // Open a window
   Window_ID = glutCreateWindow( PROGRAM_TITLE );

   // Register the callback function to do the drawing.
   glutDisplayFunc(&cbRenderScene);

   // It's a good idea to know when our window's resized.
   glutReshapeFunc(&cbResizeScene);

   // And let's get some keyboard input.
   glutKeyboardFunc(&cbKeyPressed);
   glutSpecialFunc(&cbSpecialKeyPressed);

   pError_Check();

   PRINT_STRING(GL_VENDOR);
   PRINT_STRING(GL_RENDERER);
   PRINT_STRING(GL_VERSION);
   PRINT_STRING(GL_SHADING_LANGUAGE_VERSION);

   PRINT_ATTRIBUTE(GL_MAX_DRAW_BUFFERS);
#ifdef GL_NV_transform_feedback
   PRINT_ATTRIBUTE(GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS_NV);
   PRINT_ATTRIBUTE(GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS_NV);
   //  PRINT_ATTRIBUTE(GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS_NV);
#endif

   // OK, OpenGL's ready to go.  Let's call our own init function.
   ourInit(Window_Width, Window_Height);

   pError_Check();

   world.init();

   pError_Check();

# ifdef GLX_SGI_video_sync
   glutIdleFunc(cb_idle);
# else
   glutTimerFunc(10,cbTimer,0);
# endif

   // Print out a bit of help dialog.
   printf("\n" PROGRAM_TITLE "\n\n\
Use arrow keys to rotate, 'R' to reverse, 'S' to stop.\n\
Page up/down will move cube away from/towards camera.\n\n\
Use first letter of shown display mode settings to alter.\n\n\
Q or [Esc] to quit; OpenGL window must have focus for input.\n");

   // Pass off control to OpenGL.
   // Above functions are called as appropriate.
   pError_Check();
   glutMainLoop();

   return 1;
}
