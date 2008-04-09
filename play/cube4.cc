// ----------------------

#define PROGRAM_TITLE "Cube 4"

#include <stdio.h>   // Always a good idea.
#include <stdlib.h>
#include <string.h>
#include <time.h>    // For our FPS stats.
#include <math.h>
#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES
#include <GL/gl.h>   // OpenGL itself.
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>  // GLU support library.
#include <GL/freeglut.h> // GLUT support library.

#undef use_cg

#ifdef use_cg
#include <Cg/cg.h>
#include <Cg/cgGL.h>
#endif

#include <deque>
#include <queue>
#include <list>
#include <string>

#include "util.h"
#include "coord.h"
#include "shader.h"

#undef TUNE
#define TUNE_AMT 20

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

inline void glutBitmapString(void *font, const char *str)
{ glutBitmapString(font,(unsigned char*)str);
}



pFrame_Timer frame_timer;

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
int Alpha_Add = 1;

int Curr_TexMode = 1;
char *TexModesStr[] = {"GL_DECAL","GL_MODULATE","GL_BLEND","GL_REPLACE"};
GLint TexModes[] = {GL_DECAL,GL_MODULATE,GL_BLEND,GL_REPLACE};

// Object and scene global variables.

// Cube position and rotation speed variables.
float X_Speed = 0.0f;
#ifdef TUNE
float Y_Speed = 0.0f;
#else
float Y_Speed = 0.5f;
#endif
float Z_Speed = 0.0f;
float Z_Off   =-5.0f;

// Settings for our light.  Try playing with these (or add more lights).
//  float Light_Ambient[]=  { 0.3f, 0.3f, 0.3f, 1.0f };
const float ambient_comp = 0.2;
const float diffuse_comp = 2.2;
float Light_Ambient[]=  { ambient_comp,ambient_comp, ambient_comp, 1.0f };
float Light_Diffuse[]=  { diffuse_comp, diffuse_comp, diffuse_comp, 1.0f };
float Light_Specular[]=  { 1.2f, 1.2f, 1.2f, 1.0f };
float Light_Position[]= { -2, 2, 0.0f, 1.0f };

bool lite_textures = false;

int vsal_lighting_mode; // Vertex Shader Attribute Location
int vsal_bump_info;
int vsal_pinnacle;
int vsal_circle_center;
int vsal_circle_a_vector;
int vsal_circle_b_vector;
int vsal_tex_center;
int vsal_tex_a_vector;
int vsal_tex_b_vector;

struct d4
{
  d4(double a, double b, double c, double d)
  {
    da[0]=a;da[1]=b;da[2]=c;da[3]=d;
  };
  operator double* () { return da; }
  double da[4];
};

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

#ifdef use_cg

static bool cg_inited = false;
static CGcontext cg_context;

void
pcg_error_check(const char *cg_prog, const char *msg)
{
  CGerror error;
  const char *string = cgGetLastErrorString(&error);
  if ( error == CG_NO_ERROR ) return;

  printf("cg_error: %s: %s: %s\n", cg_prog, msg, string);
  if ( error == CG_COMPILER_ERROR )
    printf("%s\n", cgGetLastListing(myCgContext));
  pError_Exit();
}

class pCg {
public:
  pCg(char *path, char *main_body){init(path,main_body);}
  void init(char *path, int profile_token, char *entry_point)
  {
    name = entry_point;
    init_cg();
    profile = cgGLGetLatestProfile(profile_token);
    cgGLSetOptimalOptions(profile);
    pcg_error_check(name,"cgGLSetOptimalOptions");
    vertex_program = cgCreateProgramFromFile
      ( cg_context, CG_SOURCE, path, profile, entry_point, NULL);
    pcg_error_check(name,"cgCreateProgramFromFile");
    cgGLLoadProgram(vertex_program);
    pcg_error_check(name,"cgGLLoadProgram");
  }
  void init_cg()
  {
    if ( cg_inited ) return;
    cg_context = cgCreateContext();
    pcg_error_check(name,"cgCreateContext");
    cgGLSetDebugMode( CG_FALSE );
    cgSetParameterSettingMode(cg_context, CG_DEFERRED_PARAMETER_SETTING);
  }

  CGprogram vertex_program;
  CGprofile profile;
  char *name;
};

pCg *cgp_lighting; // cg program
pCg *cgp_circle; // cg program
#endif

uint query_timer_id;

pShader *vs_lighting, *vs_circle, *vs_bump, *vs_fixed;

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
    return pCoor( pt.x * v00_11.x + v00.x, pt.y * v00_11.y + v00.y, 0);
  }
  void texgen_on()
  {
    glEnable(GL_TEXTURE_GEN_S);
    glEnable(GL_TEXTURE_GEN_T);
    glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_OBJECT_LINEAR);
    glTexGendv(GL_S,GL_OBJECT_PLANE, d4(v00_11.x, 0, 0, v00.x));
    glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_OBJECT_LINEAR);
    glTexGendv(GL_T,GL_OBJECT_PLANE, d4(0, v00_11.y, 0, v00.y));
  }
  void texgen_off()
  {
    glDisable(GL_TEXTURE_GEN_S);
    glDisable(GL_TEXTURE_GEN_T);
  }

  void init(int facep, int texidp, float x0, float y0, float x1, float y1)
  {
    face = facep;
    axis = face >> 1;
    dir = ( face & 1 ) != ( axis != 2 );
    inited = true;
    texid = texidp;
    v00 = pCoor(x0,y1);
    v11 = pCoor(x1,y0);
    v00_11 = v11 - v00;
    v01 = pCoor(x0,y0);
    v10 = pCoor(x1,y1);
  }

  pMatrix4 face_forward;
  pMatrix4 face_forwardi;
private:
  bool inited;
  int face;
  int axis;
  bool dir;
  pVect v00_11;
};

class pWorld {
public:
  pWorld():
    ball_position(0.0,0,0.0),
    ball_speed(0,0,0),
    //  accel(0,0,0)
    accel(0,-.9,0)
  {
    step_last_time = time_wall_fp();
#ifdef TUNE
    ball_size = 0.2;
#else
    ball_size = 0.04;
#endif
    time_step_num = 0;
    step_duration = 1.0 / 300;
    step_duration_inv = 1.0 / step_duration;
    const double age_max_s = 300;
    age_max = int ( age_max_s * step_duration_inv );
    age_max_inv = 1.0 / age_max;
    const double grow_time_s = 1.25;
    grow_age_fraction = grow_time_s / age_max_s;
    grow_age_fraction_factor = M_PI / ( 2.0 * grow_age_fraction );
  };
  void cube_spin_set(float t)
  {
    cube_spin.set_identity();
    cube_spin.apply_rotation(pCoor(1,0,0),X_Speed * t * 30 );
    cube_spin.apply_rotation(pCoor(0,1,0),Y_Speed * t * 30 );
    cube_spin.apply_rotation(pCoor(0,0,1),Z_Speed * t * 30 );
  }
  void time_step();
  void time_advance();
  pCoor world_to_face(int face, pCoor c)
  {
    pMatrix4& fwi = cube_face_generic_info[face].face_forwardi;
    return fwi * cube.localize(c);
  }
  pContact_List contact[6];
  pCube_Face_Info cube_face_info[6];
  pCube_Face_Info cube_face_generic_info[6];
  double step_last_time;
  int age_max;
  double age_max_inv;
  double grow_age_fraction;
  double grow_age_fraction_factor;
  double step_duration;
  int time_step_num;
  float step_duration_inv;
  pCube cube;
  pMatrix4 cube_spin;
  GLUquadricObj *ball;
  pCoor ball_position;
  pVect ball_speed;
  float ball_size;
  pVect accel;
};

void
pWorld::time_advance()
{
  const double now = time_wall_fp();
  cube_spin_set(step_duration);
  while ( step_last_time < now )
    {
      time_step();
      step_last_time += step_duration;
    }
  const int t_old = time_step_num - age_max;
  for ( int f=0; f<6; f++ )
    {
      pContact_List& c = contact[f];
      while ( c.size() && c.front().t < t_old ) c.erase(c.begin());
#ifdef TUNE
      pPlane plane = cube.face_local(f);
      while ( c.size() < TUNE_AMT )
        contact[f].push_back
          ( pContact(f,pCoor(0.5,0.5,0),3,pVect(0,0,1),time_step_num) );
#endif
    }
}

void
pWorld::time_step()
{
  const float delta_t = step_duration;
  const float delta_t_inv = step_duration_inv;

  pCube cube0 = cube;

  cube.m.apply(cube_spin);
  int iterations = 0;
  time_step_num++;

  while ( true )
    {
      int best_face = -1;
      pCoor ball_position1 = ball_position + delta_t * ball_speed;
      int inside_count = 0;
      iterations++;

      for ( int i=0; i<6; i++ )
        {
          pPlane face0 = cube0.face(i);
          pIntercept i0(face0, ball_position, ball_speed);
          const bool inside0 = i0.distance >= 0;
          if ( !inside0 ) continue;
          inside_count++;
          pPlane face1 = cube.face(i);
          pIntercept i1(face1, ball_position1, ball_speed);
          const bool inside1 = i1.distance >= 0;
          if ( inside1 ) continue;
          const float delta_d = i1.distance - i0.distance;
          const float ti = delta_t * i0.distance / delta_d;

          best_face = i;
          ball_position += ball_speed * ti;

          pCoor contact_position_after = cube_spin * ball_position;
          pVect face_speed =
            ( contact_position_after - ball_position ) * delta_t_inv;
          pVect ball_speed_wrt_face = ball_speed - face_speed;
          const float ndots = dot(face0.normal,ball_speed_wrt_face);
          pVect local_pos = world_to_face(i,ball_position);

          if ( !contact[i].size()
               || distance(local_pos,contact[i].back().loc) > 0.2 * ball_size )
            {
              //  pVect norm_speed
             //  (local_pos,cube.localize(ball_position+ball_speed_wrt_face));
              pCoor ball_pos_next = ball_position + ball_speed_wrt_face;
              pVect ball_speed_local(local_pos,world_to_face(i,ball_pos_next));
              contact[i].push_back
                ( pContact(i,local_pos,ndots,ball_speed_local,time_step_num) );
            }

          pVect ball_speed_before = ball_speed;
          ball_speed_wrt_face =
            ball_speed_wrt_face - 2.0 * ndots * face0.normal;
            //  ball_speed_wrt_face - 1.75 * ndots * face0.normal;
          ball_speed = ball_speed_wrt_face + face_speed;

          ball_position += ball_speed * -ti;

          if ( 0 )
            printf(" %2d  f %d, ti %.3f "
                   "(%+.2f,%+.2f,%+.2f) "
                   "%+.2f,%+.2f,%+.2f -> %+.2f,%+.2f,%+.2f \n",
                   time_step_num, i, ti,
                   face_speed.x, face_speed.y, face_speed.z,
                   ball_speed_before.x, ball_speed_before.y,
                   ball_speed_before.z,
                   ball_speed.x, ball_speed.y, ball_speed.z);

          break;
        }

      if ( best_face != -1 && iterations < 6 ) continue;
#ifndef TUNE
      ball_position = ball_position1;
#endif
      ball_speed += accel * delta_t;

      if ( inside_count == 6 ) break;

      for ( int i=0; i<6; i++ )
        {
          pPlane face1 = cube.face(i);
          pIntercept i1(face1, ball_position1, ball_speed);
          if ( i1.distance >= 0 ) continue;
          ball_position += face1.normal * i1.distance;
          if ( 0 )
            printf("Escape adjust: t %3d, face %d, amt %f\n",
                   time_step_num, i, i1.distance);

        }
      break;
    }

}


pWorld world;


void
circle_render_vs(pContact_List::iterator ci, int face)
{
  static const double pi2 = M_PI + M_PI;
  pCoor impact = ci->loc;
  const float radius = ci->render_bump ? world.ball_size * 2 : world.ball_size;
  const int slices = 20;
  const float delta_theta = pi2 / slices;
  const float stop = pi2 - 0.5 * delta_theta;
  // Center, radius, plane normal.
  // Center, a vector, b vector
  const bool just_turned_on = vs_circle->use();
  static int last_face = -1;

  if ( just_turned_on || last_face != face ) last_face = face;

  pError_Check();
  static float varray[slices*2];
  float *vp = varray;
  static GLuint gpu_vertex_buffer = 0;
  static int vertices_used = 0;

  if ( !vertices_used )
    {
      for ( float theta = 0; theta < stop; theta += delta_theta )
        {
          *vp++ = theta;
          *vp++ = vertices_used; // Really just padding.
          vertices_used++;
        }
      glGenBuffers(1,&gpu_vertex_buffer);
      glBindBuffer(GL_ARRAY_BUFFER,gpu_vertex_buffer);
      glBufferData(GL_ARRAY_BUFFER,vertices_used * sizeof(*varray) * 2,
                   varray,GL_STATIC_DRAW);
      glBindBuffer(GL_ARRAY_BUFFER,0);
      pError_Check();
    }

  glVertexAttrib3f(vsal_bump_info,impact.x,impact.y,radius);
  glBindBuffer(GL_ARRAY_BUFFER,gpu_vertex_buffer);
  glVertexPointer(2,GL_FLOAT,0,NULL);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glEnableClientState(GL_VERTEX_ARRAY);
  pError_Check();
  glDrawArrays(GL_POLYGON,0,slices);
  glDisableClientState(GL_VERTEX_ARRAY);
}

void
circle_render(pContact_List::iterator ci, int face)
{
  if ( Alpha_Add ) { circle_render_vs(ci,face); return; }

  static const double pi2 = M_PI + M_PI;
  const int slices = 20;
  static pSine_Series outer_series(0,pi2,slices);
  pCoor impact = ci->loc;
  const float radius = ci->render_bump ? world.ball_size * 2 : world.ball_size;

  static float varray[slices*4];
  float *vp = varray;

  while ( pSine* const sin_cos = outer_series )
    {
      const float scos = sin_cos->cos;
      const float ssin = sin_cos->sin;
      pVect p(scos,ssin,0);
      pCoor c = impact + radius * p;
      *vp++ = c.x; *vp++ = c.y; *vp++ = c.z; *vp++ = c.w;
    }

  glVertexPointer(4,GL_FLOAT,0,varray);
  glEnableClientState(GL_VERTEX_ARRAY);
  pError_Check();
  glDrawArrays(GL_POLYGON,0,slices);
  glDisableClientState(GL_VERTEX_ARRAY);
}


void
bump_render_vs(pPlane& plane, pContact_List::iterator ci, int face)
{
  const float age =
    ( world.time_step_num - ci->t ) * world.age_max_inv;
  //  glColor4f(1,1-age*.5,0,1.0-age);
  //  glColor4f(1,0.2 + age*.5,0.2,1);
  const double speed_scaled = 0.05 * ci->speed;
  const double scale = max( speed_scaled, 0.01);
  const float agem13 = (1-age)*(1-age)*(1-age);
  glColor4f(1, 0.1 + (1-agem13) * .9,
            0.1 + (1-agem13) * .9, 0.5 + (1-agem13) * 0.5 );
  pCoor impact = ci->loc;
  pVect pinnacle =
    ( age < world.grow_age_fraction
      ? sin( age * world.grow_age_fraction_factor ) : 1.0 )
    * agem13 * scale * ci->velocity;
  const float radius = world.ball_size * 2;

  vs_bump->use();

  static int vertices_used = 0;
  static GLuint gpu_vertex_buffer = 0;

  //  int max_vertices;
  //  glGetIntegerv(GL_MAX_ELEMENTS_VERTICES,&max_vertices);

  if ( !vertices_used )
    {
      const int cslices = 20;
      const int rslices = 30;
      const double pi2 = M_PI + M_PI;
      const float delta_theta = pi2 / cslices;
      const float delta_eta = M_PI / rslices;
      const float theta_stop = pi2 - delta_theta / 2;
      const float eta_stop = M_PI_2 - delta_eta / 2;

      const int vertices = cslices*rslices*4;
      static float varray[vertices*2];
      float *vp = varray;

      for ( float theta = 0; theta < theta_stop; theta += delta_theta )
        for ( float eta = -M_PI_2; eta < eta_stop; eta += delta_eta )
          for ( int corner = 0; corner < 4; corner++ )
            {
              const float t = theta + ( corner & 2 ? delta_theta : 0 );
              const float e = eta + ( corner==1 || corner==2 ? delta_eta : 0 );
              *vp++ = t;  *vp++ = e;
              vertices_used++;
            }
      glGenBuffers(1,&gpu_vertex_buffer);
      glBindBuffer(GL_ARRAY_BUFFER,gpu_vertex_buffer);
      glBufferData(GL_ARRAY_BUFFER,vertices_used * sizeof(*varray) * 2,
                   varray,GL_DYNAMIC_DRAW);
      glBindBuffer(GL_ARRAY_BUFFER,0);
      pError_Check();
    }

  glBindBuffer(GL_ARRAY_BUFFER,gpu_vertex_buffer);
  glVertexPointer(2,GL_FLOAT,0,NULL);
  glEnableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  pError_Check();
  glVertexAttrib2f(vsal_bump_info,impact.x,impact.y);
  glVertexAttrib4f(vsal_pinnacle,pinnacle.x,pinnacle.y,pinnacle.z,radius);
  glDrawArrays(GL_QUADS,0,vertices_used);
  glDisableClientState(GL_VERTEX_ARRAY);
  pError_Check();
}

void
bump_render(pPlane& plane, pContact_List::iterator ci, int face)
{
  if ( Alpha_Add ) { bump_render_vs(plane,ci,face); return; }

  vs_lighting->use();

  const float age =
    ( world.time_step_num - ci->t ) * world.age_max_inv;
  //  glColor4f(1,1-age*.5,0,1.0-age);
  //  glColor4f(1,0.2 + age*.5,0.2,1);
  const double speed_scaled = 0.05 * ci->speed;
  const double scale = max( speed_scaled, 0.01);
  static const double pi2 = M_PI + M_PI;
  const double elev_end = M_PI_2;
  const float agem13 = (1-age)*(1-age)*(1-age);
  const float h = scale * agem13;
  glColor4f(1, 0.1 + (1-agem13) * .9,
            0.1 + (1-agem13) * .9, 0.5 + (1-agem13) * 0.5 );
  pCoor impact = ci->loc;
  pCoor c0(0,0,0);

  const int cslices = 20;
  const int rslices = 30;
  static pSine_Series outer_series(0,pi2,cslices);
  static pSine_Series radial_series(-elev_end,elev_end,rslices);

#if 1

  const int vertices = cslices*rslices*4;
  static float varray[vertices*3];
  static float narray[vertices*3];
  float *vp = varray, *np = narray;
  int vertices_used = 0;

  while ( pSine* const sin_cos = outer_series )
    {
      const float scos = sin_cos->cos;
      const float ssin = sin_cos->sin;
      pVect p(scos,ssin,0);
      pCoor c1 = impact + 2 * world.ball_size * p;

      if ( sin_cos->angle != 0 )
        {
          pVect radial0 = ( c0 - impact ) * 0.5;
          pVect radial1 = ( c1 - impact ) * 0.5;
          pCoor c00 = c0;
          pCoor c10 = c1;
          //  pNorm normal(cross(c10,impact,c00));
          pVect normal(0,0,-1);
          (pSine*) radial_series;
          while ( pSine* const sc_rad = radial_series )
            {
              //  pVect hv = h * (1.0 + sc_rad->sin ) * plane;
              pVect hv = h * (1.0 + sc_rad->sin ) * ci->velocity;
              const float dr = sc_rad->sin < 0 ? 2 - sc_rad->cos : sc_rad->cos;
              pVect radiette0 = dr * radial0;
              pVect radiette1 = dr * radial1;
              pCoor c01 = impact + radiette0 + hv;
              pCoor c11 = impact + radiette1 + hv;
#define VERTEX(co) {pCoor& c=co; *vp++=c.x;*vp++=c.y;*vp++=c.z; }
#define NORMAL(co) { pVect& c=co; *np++=c.x;  *np++=c.y; *np++=c.z;}

              pVect vtheta = world.ball_size * dr * pVect(-ssin,scos,0);
              pVect veta = -fabs(sc_rad->sin)
                * radial0 + sc_rad->cos * h * ci->velocity;
              NORMAL(normal); VERTEX(c00);
              NORMAL(normal); VERTEX(c10);
              normal = pNorm(cross(vtheta,veta));
              NORMAL(normal); VERTEX(c11);
              NORMAL(normal); VERTEX(c01);
              vertices_used += 4;

              c00 = c01;
              c10 = c11;
#undef VERTEX
#undef NORMAL
            }
        }
      c0 = c1;
    }

  if ( true )
    {
      glVertexPointer(3,GL_FLOAT,0,varray);
      glEnableClientState(GL_VERTEX_ARRAY);
      glNormalPointer(GL_FLOAT,0,narray);
      glEnableClientState(GL_NORMAL_ARRAY);
      pError_Check();
      glDrawArrays(GL_QUADS,0,vertices_used);
      glDisableClientState(GL_VERTEX_ARRAY);
      glDisableClientState(GL_NORMAL_ARRAY);
      pError_Check();
    }
  else
    {
      float *np = &narray[0];
      float *vp = &varray[0];
      glBegin(GL_QUADS);
      for ( int i=0; i<vertices_used; i++ )
        {
          glNormal3fv(np); np += 3;
          glVertex3fv(vp); vp += 3;
        }
      glEnd();
    }
#else

  glBegin(GL_QUADS);
  while ( pSine* const sin_cos = outer_series )
    {
      const float scos = sin_cos->cos;
      const float ssin = sin_cos->sin;
      pVect p = face_axis == 0 ? pVect(0,scos,ssin) :
        face_axis == 1 ? pVect(scos,0,ssin) : pVect(scos,ssin,0);
      pCoor c1 = impact + 2 * world.ball_size * p;

      if ( sin_cos->angle != 0 )
        {
          pVect radial0 = ( c0 - impact ) * 0.5;
          pVect radial1 = ( c1 - impact ) * 0.5;
          pCoor c00 = c0;
          pCoor c10 = c1;
          pNorm normal(cross(c00,impact,c10));
          glNormal3fv(normal);
          while ( pSine* const sc_rad = radial_series )
            {
              //  pVect hv = h * (1.0 + sc_rad->sin ) * plane;
              pVect hv = h * (1.0 + sc_rad->sin ) * ci->velocity;
              const float dr = sc_rad->sin < 0 ? 2 - sc_rad->cos : sc_rad->cos;
              pVect radiette0 = dr * radial0;
              pVect radiette1 = dr * radial1;
              pCoor c01 = impact + radiette0 + hv;
              pCoor c11 = impact + radiette1 + hv;
              normal = pNorm(cross(c00,c01,c11));
              glTexCoord2fv(fci.tmap(c00)); glVertex3fv(c00);
              glTexCoord2fv(fci.tmap(c10)); glVertex3fv(c10);
              glNormal3fv(normal);
              glTexCoord2fv(fci.tmap(c11)); glVertex3fv(c11);
              glTexCoord2fv(fci.tmap(c01)); glVertex3fv(c01);
              c00 = c01;
              c10 = c11;
            }
        }
      c0 = c1;
    }
  glEnd();
#endif
}


void
bumps_render(int face)
{
  pCube& cube = world.cube;
  pContact_List& contact = world.contact[face];
  pPlane face_info = cube.face_local(face);

#if 0
  int plane_token = GL_CLIP_PLANE0;

  glEnable(plane_token); glClipPlane(plane_token++,d4(1.0,0.0,0.0,0.0));
  glEnable(plane_token); glClipPlane(plane_token++,d4(-1.0,0.0,0.0,1));
  glEnable(plane_token); glClipPlane(plane_token++,d4(0,1.0,0.0,0.0));
  glEnable(plane_token); glClipPlane(plane_token++,d4(0,-1.0,0.0,1.0));
#endif


  pError_Check();

  for ( pContact_List::iterator ci = contact.begin();
        ci < contact.end();
        ci++ )
    if( ci->render_bump )
      {
        bump_render(face_info,ci,face);
      }
    else
      {
        //  glDisable(GL_TEXTURE_2D);
        const float age =
          ( world.time_step_num - ci->t ) * world.age_max_inv;
        const float agem13 = (1-age)*(1-age)*(1-age);
        //  glColor4f(1,0,0,1-agem3);
        glColor4f(1, 0.1 + (1-agem13) * .9,
                  0.1 + (1-agem13) * .9, 0.5 + (1-agem13) * 0.5 );

        circle_render(ci,face);
      }
  pSet_Mode();
  glDisable(GL_CLIP_PLANE0);
  glDisable(GL_CLIP_PLANE1);
  glDisable(GL_CLIP_PLANE2);
  glDisable(GL_CLIP_PLANE3);
}


struct pF { float order; int f; pF(float o,int f):order(o),f(f){} };
bool operator < (pF a, pF b) { return a.order > b.order; }

// ------
// Routine which actually does the drawing

void cbRenderScene(
  void
)
{
   char buf[180]; // For our strings.

   world.time_advance();

   frame_timer.frame_start();

   // Enables, disables or otherwise adjusts as
   // appropriate for our current settings.

   if (Light_On)
      glEnable(GL_LIGHTING);
   else
      glDisable(GL_LIGHTING);

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


    pCube& cube = world.cube;
   // Rotate the calculated amount.

   // Need to manipulate the ModelView matrix to move our model around.
   glMatrixMode(GL_MODELVIEW);

   // Reset to 0,0,0; no rotation, no scaling.
   glLoadIdentity();

   glDisable(GL_LIGHTING);
   glPushMatrix();
   glTranslatef(Light_Position[0],Light_Position[1],Light_Position[2]);
   glColor4f(0,1,1,1);
   gluSphere(world.ball,0.1,20,20);
   glPopMatrix();
   glEnable(GL_LIGHTING);

   // Move the object back from the screen.
   glTranslatef(0.0f,0.0f,Z_Off);

   // Clear the color and depth buffers.
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

   glColor4f(1,1,1,1.0);
   glPushMatrix();
   glMultTransposeMatrixf(cube.m.a);

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

   if ( false )
     {
       vs_lighting->validate_once();
       vs_circle->validate_once();
     }

#ifdef use_cg
   cgGLBindProgram(cgp_lighting->profile);
   cgGLEnableProfile(cgp_lighting->profile);
#else
   vs_lighting->use();
#endif

   while ( !part_idx.empty() )
     {
       pF fi = part_idx.top();  part_idx.pop();
       pContact_List& contact = world.contact[fi.f];
       pCube_Face_Info& fgi = world.cube_face_generic_info[fi.f];
       pCube_Face_Info& fci = world.cube_face_info[fi.f];
       pVect plane = cube.face_local(fi.f).normal;
       const bool front = fi.order >= 0;

       if ( !ball_rendered && front )
         {
           vs_fixed->use();
           ball_rendered = true;
           glDisable(GL_TEXTURE_2D);
           glDepthFunc(GL_LESS);
           glDisable(GL_BLEND);
           glDisable(GL_STENCIL_TEST);
           glColor4f(0x58/255.0,0xd/255.0,0xa6/255.0,1);
           //  glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, Light_Specular);
           glPushMatrix();
           pCoor ball_pos = cube.localize(world.ball_position);
           glTranslatef(ball_pos.x,ball_pos.y,ball_pos.z);
           gluSphere(world.ball,world.ball_size,20,20);
           glPopMatrix();
           if ( Blend_On )
             {
               glDisable(GL_ALPHA_TEST);
               glEnable(GL_BLEND);
               glDepthFunc(GL_ALWAYS);
             }
         }

       glPushMatrix();
       glMultTransposeMatrixf(fgi.face_forward.a);

       for ( pContact_List::iterator ci = contact.begin();
             ci < contact.end(); ci++ )
         ci->render_bump = ci->speed >= .3;

       glNormal3f(0,0,1);
       glBindTexture(GL_TEXTURE_2D,fci.texid);
       pSet_Mode();

       fci.texgen_on();

       glEnable(GL_STENCIL_TEST);
       glStencilFunc(GL_ALWAYS,fi.f,-1);
       glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

       glEnable(GL_TEXTURE_2D);

       if ( !front ) bumps_render(fi.f);

       glStencilFunc(GL_NEVER,fi.f,-1);
       glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);

       glDisable(GL_TEXTURE_2D);

       pError_Check();
       for ( pContact_List::iterator ci = contact.begin();
             ci < contact.end(); ci++ )
         circle_render(ci,fi.f);

       glStencilFunc(GL_NOTEQUAL,fi.f,-1);
       glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

       glEnable(GL_TEXTURE_2D);

#ifdef use_cg
#else
       vs_lighting->use();
#endif

       glColor4f(1,1,1,1);
       glNormal3f(0,0,1);

       glBegin(GL_QUADS);
       glVertex2f(0,0);
       glVertex2f(0,1);
       glVertex2f(1,1);
       glVertex2f(1,0);
       glEnd();

       glStencilFunc(GL_ALWAYS,fi.f,-1);
       glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

       if ( front ) bumps_render(fi.f);

       glPopMatrix();

       if ( false )
         {
           glDisable(GL_STENCIL_TEST);
           glDisable(GL_TEXTURE_2D);

           //  glDisable(GL_BLEND);
           glDepthFunc(GL_LESS);
           glColor4f(0xf9/255.0,0xb2/255.0,0x37/255.0,1);
           glBegin(GL_LINE_LOOP);
           glVertex4fv(fgi.v00);
           glVertex4fv(fgi.v01);
           glVertex4fv(fgi.v11);
           glVertex4fv(fgi.v10);
           glEnd();
           glDepthFunc(GL_ALWAYS);
         }
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


#ifdef use_cg
   cgGLDisableProfile(cgp_lighting->profile);
#else
   vs_fixed->use();
#endif

   // We don't want depth-testing either.
   glDisable(GL_DEPTH_TEST);

   // But, for fun, let's make the text partially transparent too.
   glColor4f(0.6,1.0,0.6,.75);

   // Render our various display mode settings.
   sprintf(buf,"Mode: %s", TexModesStr[Curr_TexMode]);
   glRasterPos2i(2,2);
   glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"GPU Code: %d", Alpha_Add);
   glRasterPos2i(2,14); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"Blend: %d", Blend_On);
   glRasterPos2i(2,26); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   sprintf(buf,"Light: %d", Light_On);
   glRasterPos2i(2,38); glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

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
   glutBitmapString
     (GLUT_BITMAP_HELVETICA_12,frame_timer.frame_rate_text_get());

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

   case 116: case 84: // T - Texturing.
      Texture_On = Texture_On ? 0 : 1;
      break;

   case 97: case 65:  // A - Alpha-blending hack.
      Alpha_Add = Alpha_Add ? 0 : 1;
      break;

   case 102: case 70:  // F - Filtering.
      Filtering_On = Filtering_On ? 0 : 1;
      break;

   case 115: case 83: case 32:  // F (Space) - Freeze!
      Z_Speed=X_Speed=Y_Speed=0;
      break;

   case 114: case 82:  // R - Reverse.
      X_Speed=-X_Speed;
      Y_Speed=-Y_Speed;
      Z_Speed=-Z_Speed;
      break;

   case '+': case '=':
     Z_Off *= .95f;
     break;

   case '-':
     Z_Off *= 1.05f;
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
   switch (key) {
   case GLUT_KEY_PAGE_UP: // move the cube into the distance.
      Z_Speed += 0.01f;
      break;

   case GLUT_KEY_PAGE_DOWN: // move the cube closer.
      Z_Speed -= 0.01f;
      break;

   case GLUT_KEY_UP: // decrease x rotation speed;
      X_Speed -= 0.01f;
      break;

   case GLUT_KEY_DOWN: // increase x rotation speed;
      X_Speed += 0.01f;
      break;

   case GLUT_KEY_LEFT: // decrease y rotation speed;
      Y_Speed -= 0.01f;
      break;

   case GLUT_KEY_RIGHT: // increase y rotation speed;
      Y_Speed += 0.01f;
      break;

   case GLUT_KEY_F12: write_img(); break;

   default:
      printf ("SKP: No action for %d.\n", key);
      break;
    }
}

int
pBuild_Texture_File(char *name, bool invert = false, int transp = 256 )
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
pInit()
{
  world.cube.set(pCoor(-1,-1,-1),2);
  world.ball = gluNewQuadric();

  world.cube_face_info[3].init(3,texid_bldg,.05,.05,.95,.95);
  world.cube_face_info[1].init(1,texid_syllabus,.05,.05,.95,.95);
  world.cube_face_info[2].init(2,texid_syllabus,.2,.2,.8,.8);
  world.cube_face_info[0].init(0,texid_syllabus,.05,.05,1.95,1.95);
  world.cube_face_info[4].init(4,texid_syllabus,.05,.05,4.5,4.5);
  world.cube_face_info[5].init(5,texid_pie,0,0,1,1);

  for ( int f=0; f<6; f++ )
    {
      pCube_Face_Info* const fi = &world.cube_face_generic_info[f];
      const bool far = f & 1;
      const int axis = f >> 1;
      const bool flip = far ^ ( axis == 2 );
      const float dir = far ? 1.0 : 0.0;
      pVect n(axis == 0, axis == 1, axis == 2);
      pVect a_pos(axis != 0, 0, axis == 0);
      pVect b = pVect(1,1,1) - n - a_pos;
      pVect a = flip ? -a_pos : a_pos;

      pCoor c00 = pCoor(0,0,0) + dir * n;
      fi->v00 = c00;
      fi->v10 = ( c00 + a );
      fi->v11 = ( c00 + a + b );
      fi->v01 = ( c00 + b );

      pVect axb = cross(a,b);

      fi->cross_inside = dot(pVect(1,1,1),axb) < 0 == far;

      fi->face_forward.set_translation(pVect(0,0,far));
      pMatrix4 turn;
      turn.set_identity();
      turn.column_set(0,a);
      turn.column_set(1,b);
      turn.column_set(2,n);
      fi->face_forward.apply(turn);
      if ( flip ) fi->face_forward.apply_translation(a_pos);
      fi->face_forwardi = invert(fi->face_forward);
      pMatrix4 i(fi->face_forwardi,fi->face_forward);
      if ( f == 7 ) break;

    }

  glGenQueries(1,&query_timer_id);
  pError_Check();

#ifdef use_cg
  cgp_lighting = new pCG("cube4.cg","main_lighting");
  return;
#endif

  vs_fixed = new pShader();
  vs_lighting = new pShader("cube4_vshader.cc","vs_main_lighting();");
  vs_circle = new pShader("cube4_vshader.cc","vs_main_circle();");
  vs_bump = new pShader("cube4_vshader.cc","vs_main_bump();");
  vsal_bump_info = vs_bump->attribute_location("bump_info");
  vsal_pinnacle = vs_bump->attribute_location("pinnacle");

  vs_bump->print_active_attrib();

  PRINT_ATTRIBUTE(GL_MAX_VERTEX_ATTRIBS);
  PRINT_ATTRIBUTE(GL_MAX_VERTEX_UNIFORM_COMPONENTS);
  PRINT_ATTRIBUTE(GL_MAX_VARYING_COMPONENTS_EXT);
  PRINT_ATTRIBUTE(GL_MAX_VERTEX_VARYING_COMPONENTS_EXT);

  pError_Check();

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

  texid_syllabus =
    pBuild_Texture_File("gp.ppm",true,255);
  //  texid_pie = pBuild_Texture_File("/home/faculty/koppel/Web/pie2.pnm");
  texid_pie = pBuild_Texture_File("mesa-pandc.pnm",false,255);
  texid_bldg = pBuild_Texture_File("ee_bdg_to_ur_ed.ppm");
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
   lglext_ptr_init();

   // To see OpenGL drawing, take out the GLUT_DOUBLE request.
   glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL );
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

   PRINT_STRING(GL_VENDOR);
   PRINT_STRING(GL_RENDERER);
   PRINT_STRING(GL_VERSION);
   PRINT_STRING(GL_SHADING_LANGUAGE_VERSION);

   // OK, OpenGL's ready to go.  Let's call our own init function.
   ourInit(Window_Width, Window_Height);

   pInit();

# ifdef GLX_SGI_video_sync
   glutIdleFunc(cb_idle);
# else
   glutTimerFunc(10,cbTimer,0);
# endif

   // Pass off control to OpenGL.
   // Above functions are called as appropriate.
   glutMainLoop();

   return 1;
}
