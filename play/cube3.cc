// ----------------------
// OpenGL cube demo.
//
// Written by Chris Halsall (chalsall@chalsall.com) for the
// O'Reilly Network on Linux.com (oreilly.linux.com).
// May 2000.
//
// Released into the Public Domain; do with it as you wish.
// We would like to hear about interesting uses.
//
// Coded to the groovy tunes of Yello: Pocket Universe.

#define PROGRAM_TITLE "C3, O'Reilly Net: OpenGL Demo -- C.Halsall"

#include <stdio.h>   // Always a good idea.
#include <stdlib.h>
#include <string.h>
#include <time.h>    // For our FPS stats.
#include <math.h>
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>   // OpenGL itself.
#include <GL/glext.h>
#include <GL/glu.h>  // GLU support library.
#include <GL/freeglut.h> // GLUT support library.

#include <deque>
#include <queue>
#include <list>

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
int Alpha_Add = 0;

int Curr_TexMode = 3;
char *TexModesStr[] = {"GL_DECAL","GL_MODULATE","GL_BLEND","GL_REPLACE"};
GLint TexModes[] = {GL_DECAL,GL_MODULATE,GL_BLEND,GL_REPLACE};

// Object and scene global variables.

// Cube position and rotation speed variables.
float X_Speed = 0.0f;
float Y_Speed = 0.5f;
float Z_Speed = 0.0f;
float Z_Off   =-5.0f;

// Settings for our light.  Try playing with these (or add more lights).
float Light_Ambient[]=  { 0.3f, 0.3f, 0.3f, 1.0f };
float Light_Diffuse[]=  { 1.2f, 1.2f, 1.2f, 1.0f };
float Light_Position[]= { 2, 2, 5.0f, 1.0f };

bool lite_textures = false;


// ------
// Frames per second (FPS) statistic variables and routine.

#define FRAME_RATE_SAMPLES 15
int FrameCount=0;
float FrameRate=0;

template<typename T> T min(T a, T b){ return a < b ? a : b; }
template<typename T> T max(T a, T b){ return a > b ? a : b; }

double time_fp()
{
  struct timespec now;
  clock_gettime(CLOCK_REALTIME,&now);
  return now.tv_sec + ((double)now.tv_nsec) * 1e-9;
}

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

void
pError_Check()
{
  int err = glGetError();
  if ( err == GL_NO_ERROR ) return;
  fprintf(stderr,"GL error %s\n",gluErrorString(err));
  exit(1);
}


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

class pMatrix4;
class pCoor;
class pVect;
inline pCoor mult_MC(pMatrix4& m, pCoor c);
void pSet_Mode();

class pCoor {
public:
  pCoor(){};
  pCoor(pVect v);
  pCoor(float x, float y):x(x),y(y),z(0),w(1){};
  pCoor(float x, float y, float z):x(x),y(y),z(z),w(1){};
  pCoor(float x, float y, float z, float w):x(x),y(y),z(z),w(w){};

  void set(pCoor c){ x = c.x; y = c.y; z = c.z; w = c.w; }

  void apply(pMatrix4& m){ set(mult_MC(m,*this)); }
  inline void add_vector(pVect v);
  inline void operator += (pVect v);
  inline pCoor operator + (pVect v);

  float x, y, z, w;
};


const float rpd = 2.0 * M_PI / 360.0;

class pMatrix4 {
public:
  float a[16];

  pMatrix4(){set_identity();}

  pMatrix4(pMatrix4& m1, pMatrix4& m2)
  {
    set_zero();
    for ( int row=0; row<4; row++ )
      for ( int col=0; col<4; col++ )
        for ( int i=0; i<4; i++ )
          rc(row,col) += m1.rc(row,i) * m2.rc(i,col);
  }
  void copy(pMatrix4& m){ memcpy(a,m.a,sizeof(a)); }

  void set_zero(){memset(a,0,sizeof(a));}

  void set_identity()
  {
    set_zero();
    for ( int i=0; i<4; i++ ) rc(i,i) = 1;
  };
  void set_rotation(pVect u, float theta);
  void set_translation(pVect pos);

  void set_scale(float factor)
  {
    set_zero();
    for ( int i=0; i<3; i++ ) rc(i,i) = factor;
    rc(3,3) = 1;
  }

  void apply_translation(pVect displ);

  void apply_scale(float factor)
  {
    pMatrix4 mt; mt.set_scale(factor);
    apply(mt);
  }

  void apply_rotation(pVect u, float theta);
  void local_rotation(pVect u, float theta);

  void apply(pMatrix4& m) {pMatrix4 mprod(m,*this); copy(mprod);}
  void local(pMatrix4& m) {pMatrix4 mprod(*this,m); copy(mprod);}

  float& rc(int row, int col) { return a[ ( row << 2 ) + col ]; }
  pCoor r(int row_num){
    float* const row = &a[row_num<<2];
    return pCoor(row[0],row[1],row[2],row[3]);
  }

};

float dot(pVect a, pVect b);
float dot(pCoor a, pCoor b)
{return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;}


pCoor mult_MC(pMatrix4& m, pCoor c)
{
  return pCoor(dot(m.r(0),c),dot(m.r(1),c),dot(m.r(2),c),dot(m.r(3),c));
}

class pVect {
public:
  pVect(){};
  pVect(pCoor c):x(c.x),y(c.y),z(c.z){};
  pVect(float x, float y, float z):x(x),y(y),z(z){};
  pVect(pCoor from, pCoor to)
  {
    x = to.x - from.x;
    y = to.y - from.y;
    z = to.z - from.z;
  }
  pVect(float s, pVect v):x(s*v.x),y(s*v.y),z(s*v.z){};

  void normalize()
  {
    pVect n = normal();
    x = n.x;
    y = n.y;
    z = n.z;
  };

  pVect normal()
  {
    const float m = mag();
    return pVect(x/m,y/m,z/m);
  }

  inline void operator += (pVect v){ x+=v.x; y+=v.y; z+=v.z; }
  inline pVect operator - (void){ return pVect(-x,-y,-z); }
  inline pVect operator - (pVect v){ return pVect(x-v.x,y-v.y,z-v.z); }
  float mag() { return sqrt( dot(*this,*this) ); }
  float x, y, z;
};

inline float dot(pVect a, pVect b){return a.x * b.x + a.y * b.y + a.z * b.z;}

inline void
pCoor::add_vector(pVect v)
{
  x += v.x;
  y += v.y;
  z += v.z;
}

inline void pCoor::operator += (pVect v) { add_vector(v); }
inline pCoor pCoor::operator + (pVect v)
{return pCoor(x + v.x, y + v.y, z + v.z);}
inline pCoor::pCoor(pVect v):x(v.x),y(v.y),z(v.z),w(1){}
inline pVect operator + (pVect v, pVect q)
{return pVect(v.x+q.x,v.y+q.y,v.z+q.z); }
inline pVect operator - (pCoor c1, pCoor c2){return pVect(c2,c1);}
inline pVect operator * (pVect v, float s){return pVect(s,v); }
inline pVect operator * (float s,pVect v){return pVect(s,v); }
inline pVect operator * (pVect v,pVect q)
{return pVect(v.x*q.x,v.y*q.y,v.z*q.z);}
inline pVect operator * (double s,pVect v){return pVect(s,v); }
inline pVect operator / (pVect v, float f){return pVect(v.x/f,v.y/f,v.z/f); }
inline pVect operator / (pVect v, double f){return pVect(v.x/f,v.y/f,v.z/f); }

void
pMatrix4::set_rotation(pVect u, float theta)
{
  set_zero();
  const float cos_theta = cos(theta*rpd);
  const float sin_theta = sin(theta*rpd);
  rc(0,0) = u.x * u.x + cos_theta * ( 1.0 - u.x * u.x );
  rc(0,1) = u.x * u.y * ( 1.0 - cos_theta ) - u.z * sin_theta;
  rc(0,2) = u.z * u.x * ( 1.0 - cos_theta ) + u.y * sin_theta;
  rc(1,0) = u.x * u.y * ( 1.0 - cos_theta ) + u.z * sin_theta;
  rc(1,1) = u.y * u.y + cos_theta * ( 1 - u.y * u.y );
  rc(1,2) = u.y * u.z * ( 1.0 - cos_theta ) - u.x * sin_theta;
  rc(2,0) = u.z * u.x * ( 1.0 - cos_theta ) - u.y * sin_theta;
  rc(2,1) = u.y * u.z * ( 1.0 - cos_theta ) + u.x * sin_theta;
  rc(2,2) = u.z * u.z + cos_theta * ( 1 - u.z * u.z );
  rc(3,3) = 1.0;
}

void
pMatrix4::set_translation(pVect pos)
{
  set_identity();
  rc(0,3) = pos.x;
  rc(1,3) = pos.y;
  rc(2,3) = pos.z;
  rc(3,3) = 1;
}
void
pMatrix4::apply_translation(pVect pos)
{
  pMatrix4 mt; mt.set_translation(pos);
  apply(mt);
}


void
pMatrix4::apply_rotation(pVect u, float theta)
{
    pMatrix4 mt; mt.set_rotation(u,theta);
    apply(mt);
}

void
pMatrix4::local_rotation(pVect u, float theta)
{
  pMatrix4 mt; mt.set_rotation(u,theta);
  local(mt);
}

float distance(pCoor a, pCoor b)
{
  pVect diff(a,b); return diff.mag();
}

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
    return mult_MC(m,vl(xyz));
  }
  pCoor v(pVect local) { return mult_MC(m,pCoor(local)); }

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

#if 0
class pCube2 {
public:
  pCube2():v000(0,0,0),x(1,0,0),y(0,1,0),z(0,0,1){}
  void set(pCoor v000p, float len)
  {
    v000 = v000p;
    x = pVect(len,0,0);
    y = pVect(0,len,0);
    z = pVect(0,0,len);
  }
  pCoor v(int xyz)
  {
    pCoor rv = v000;
    if ( xyz & 0100 ) rv += x;
    if ( xyz & 0010 ) rv += y;
    if ( xyz & 0001 ) rv += z;
    return rv;
  }
  pVect face_normal(int face, pCoor *c = NULL)
  {
    const bool dir = face & 1;
    const int axis = face >> 1;
    pCoor pt(dir,dir,dir);
    const float pm = dir ? 1.0 : -1.0;
    pVect v(axis == 0 ? pm : 0, axis == 1 ? pm : 0, axis == 2 ? pm : 0);
    pCoor outside = pt + v;
    pt.apply(m);
    outside.apply(m);
    if ( c ) *c = pt;
    return outside - pt;
  }

  pCoor v000;
  pVect x, y, z;
}
#endif

inline void pglNormal(pCoor from, pCoor to)
{
  pVect v(from,to);
  v.normalize();
  glNormal3f(v.x,v.y,v.z);
}

inline void pglVertex4f(pCoor c) {glVertex4f(c.x,c.y,c.z,c.w);}

inline void pglTexCoord2f(pCoor c){glTexCoord2f(c.x,c.y);}

struct pContact {
  pContact(int f, pVect loc, float speed, int t)
 :face(f),loc(loc),speed(speed),t(t){}
  int face;
  pVect loc;
  float speed;
  int t;
};

typedef std::deque<pContact> pContact_List;

class pCube_Face_Info {
public:
  pCube_Face_Info():inited(false){}
  int texid;
  pCoor v00, v01, v10, v11;
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

class pWorld {
public:
  pWorld():
    ball_position(0.0,0,0.0),
    ball_speed(0,0,0),
    accel(0,-.5,0)
  {
    step_last_time = time_fp();
    time_step_num = 0;
    step_duration = 1.0 / 300;
    step_duration_inv = 1.0 / step_duration;
    age_max = int ( 60 * step_duration_inv );
    age_max_inv = 1.0 / age_max;
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
  pContact_List contact[6];
  pCube_Face_Info cube_face_info[6];
  pCube_Face_Info cube_face_generic_info[6];
  double step_last_time;
  int age_max;
  double age_max_inv;
  double step_duration;
  int time_step_num;
  float step_duration_inv;
  pCube cube;
  pMatrix4 cube_spin;
  GLUquadricObj *ball;
  pCoor ball_position;
  pVect ball_speed;
  pVect accel;
};

void
pWorld::time_advance()
{
  const double now = time_fp();
  cube_spin_set(step_duration);
  while( step_last_time < now )
    {
      time_step();
      step_last_time += step_duration;
    }
  const int t_old = time_step_num - age_max;
  for ( int f=0; f<6; f++ )
    {
      pContact_List& c = contact[f];
      while ( c.size() && c.front().t < t_old ) c.erase(c.begin());
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

          pCoor contact_position_after = mult_MC(cube_spin,ball_position);
          pVect face_speed =
            ( contact_position_after - ball_position ) * delta_t_inv;
          pVect ball_speed_wrt_face = ball_speed - face_speed;
          const float ndots = dot(face0.normal,ball_speed_wrt_face);

          pVect local_pos = cube.localize(ball_position);
          if ( !contact[i].size()
               || distance(local_pos,contact[i].back().loc) > 0.002 )
            {
              //  pVect norm_speed
             //  (local_pos,cube.localize(ball_position+ball_speed_wrt_face));
              contact[i].push_back
                ( pContact(i,local_pos,ndots,time_step_num) );
            }

          pVect ball_speed_before = ball_speed;
          ball_speed_wrt_face =
            ball_speed_wrt_face - 1.75 * ndots * face0.normal;
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
      ball_position = ball_position1;
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

static void ourDoFPS(
)
{
   static double last=0;

   if (++FrameCount >= FRAME_RATE_SAMPLES) {
     double now = time_fp();
     double delta= now - last;
     last = now;
     FrameRate = FRAME_RATE_SAMPLES / delta;
     FrameCount = 0;
   }
}




void
circle_render(pContact_List::iterator ci, int face)
{
  static const double pi2 = M_PI + M_PI;
  static pSine_Series outer_series(0,pi2,20);
  const int face_axis = face >> 1;
  const double scale = max(0.05 * ci->speed, 0.01);
  pCoor impact = ci->loc;
  glBegin(GL_POLYGON);
  while ( pSine* const sin_cos = outer_series )
    {
      const float scos = sin_cos->cos;
      const float ssin = sin_cos->sin;
      pVect p = face_axis == 0 ? pVect(0,scos,ssin) :
        face_axis == 1 ? pVect(scos,0,ssin) : pVect(scos,ssin,0);
      pCoor c = impact + scale * p;
      pglVertex4f(c);
    }
  glEnd();
}

void
bump_render(pVect& plane, pContact_List::iterator ci, int face)
{
  pCube_Face_Info& fci = world.cube_face_info[face];
  const int face_axis = face >> 1;
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

  static pSine_Series outer_series(0,pi2,20);
  static pSine_Series radial_series(0,elev_end,10);

  glBegin(GL_QUADS);
  while ( pSine* const sin_cos = outer_series )
    {
      const float scos = sin_cos->cos;
      const float ssin = sin_cos->sin;
      pVect p = face_axis == 0 ? pVect(0,scos,ssin) :
        face_axis == 1 ? pVect(scos,0,ssin) : pVect(scos,ssin,0);
      pCoor c1 = impact + scale * p;

      if ( sin_cos->angle != 0 )
        {
          pVect radial0 = c0 - impact;
          pVect radial1 = c1 - impact;
          pCoor c00 = c0;
          pCoor c10 = c1;
          while ( pSine* const sc_rad = radial_series )
            {
              pVect hv = h * sc_rad->sin * plane;
              pVect radiette0 = sc_rad->cos * radial0;
              pVect radiette1 = sc_rad->cos * radial1;
              pCoor c01 = impact + radiette0 + hv;
              pCoor c11 = impact + radiette1 + hv;
              pVect cctr = pVect(c01,c00).normal();
              pVect norm = pVect(hv - dot(hv,cctr) * cctr).normal();
              glNormal3f(norm.x,norm.y,norm.z);
              pglTexCoord2f(fci.tmap(c00)); pglVertex4f(c00);
              pglTexCoord2f(fci.tmap(c01)); pglVertex4f(c01);
              pglTexCoord2f(fci.tmap(c11)); pglVertex4f(c11);
              pglTexCoord2f(fci.tmap(c10)); pglVertex4f(c10);
              c00 = c01;
              c10 = c11;
            }
        }
      c0 = c1;
    }
  glEnd();
}

void
bumps_render(int face)
{
  pCube& cube = world.cube;
  pContact_List& contact = world.contact[face];
  pCube_Face_Info& fci = world.cube_face_info[face];
  pVect plane = cube.face_local(face).normal;

  glStencilFunc(GL_ALWAYS,face,-1);
  glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
  glBindTexture(GL_TEXTURE_2D,fci.texid);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);

  for ( pContact_List::iterator ci = contact.begin();
        ci < contact.end();
        ci++ )
    {
      const double speed_scaled = 0.05 * ci->speed;

      if ( speed_scaled < .015 )
        {
          glDisable(GL_TEXTURE_2D);
          const float age =
            ( world.time_step_num - ci->t ) * world.age_max_inv;
          const float agem3 = (1-age)*(1-age)*(1-age);
          glColor4f(1,0,0,agem3);
          circle_render(ci,face);
        }
      else
        {
          glEnable(GL_TEXTURE_2D);
          bump_render(plane,ci,face);
        }
    }
  pSet_Mode();
}


struct pF { float order; int f; pF(float o,int f):order(o),f(f){} };
bool operator < (pF a, pF b) { return a.order < b.order; }

// ------
// Routine which actually does the drawing

void cbRenderScene(
  void
)
{
   char buf[80]; // For our strings.

   // Enables, disables or otherwise adjusts as
   // appropriate for our current settings.

   if (Texture_On)
      glEnable(GL_TEXTURE_2D);
   else
      glDisable(GL_TEXTURE_2D);

   if (Light_On)
      glEnable(GL_LIGHTING);
   else
      glDisable(GL_LIGHTING);

    if (Alpha_Add)
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


    pCube& cube = world.cube;
   // Rotate the calculated amount.
    world.time_advance();

   // Need to manipulate the ModelView matrix to move our model around.
   glMatrixMode(GL_MODELVIEW);

   // Reset to 0,0,0; no rotation, no scaling.
   glLoadIdentity();

   // Move the object back from the screen.
   glTranslatef(0.0f,0.0f,Z_Off);

   // Clear the color and depth buffers.
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

   std::priority_queue<pF> part_idx;
   pCoor eye_local = pCoor(0,0,0) + cube.localize(pCoor(0,0,-Z_Off));
   for ( int f=0; f<6; f++ )
     {
       pCoor ctr = cube.face_local(f).point;
       const float dist = distance(eye_local,ctr);
       part_idx.push(pF(dist,f));
     }

   glColor4f(1,1,1,1.0);
   glPushMatrix();
   glMultTransposeMatrixf(cube.m.a);
   glEnable(GL_STENCIL_TEST);

   while ( !part_idx.empty() )
     {
       pF fi = part_idx.top();  part_idx.pop();
       pContact_List& contact = world.contact[fi.f];
       pVect plane = cube.face_local(fi.f).normal;

       pCoor eye_local = pCoor(0,0,0) + cube.localize(pCoor(0,0,-Z_Off));
       pCoor face_ctr = cube.face_local(fi.f).point;
       pVect face_to_eye(face_ctr,eye_local);
       const bool front = dot(face_to_eye,plane) >= 0;

       if ( !front ) bumps_render(fi.f);

       glStencilFunc(GL_NEVER,fi.f,-1);
       glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);
       glDisable(GL_TEXTURE_2D);
       pError_Check();

       for ( pContact_List::iterator ci = contact.begin();
             ci < contact.end(); ci++ )
         circle_render(ci,fi.f);

       glEnable(GL_TEXTURE_2D);
       glStencilFunc(GL_NOTEQUAL,fi.f,-1);
       glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

       pCube_Face_Info& fci = world.cube_face_info[fi.f];
       pCube_Face_Info& fgi = world.cube_face_generic_info[fi.f];

       glBindTexture(GL_TEXTURE_2D,fci.texid);
       glColor4f(1,1,1,1);
       glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
       glNormal3f(plane.x,plane.y,plane.z);
       glBegin(GL_QUADS);
       pglTexCoord2f(fci.tmap(fgi.v00)); pglVertex4f(fgi.v00);
       pglTexCoord2f(fci.tmap(fgi.v01)); pglVertex4f(fgi.v01);
       pglTexCoord2f(fci.tmap(fgi.v11)); pglVertex4f(fgi.v11);
       pglTexCoord2f(fci.tmap(fgi.v10)); pglVertex4f(fgi.v10);
       glEnd();

       if ( front ) bumps_render(fi.f);

     }

      glDisable(GL_STENCIL_TEST);
         glDepthFunc(GL_LESS);
         glDisable(GL_TEXTURE_2D);
         glDisable(GL_BLEND);
         {
           glColor4f(0.9,0.0,0.0,1);
           glPushMatrix();
           pCoor ball_pos = cube.localize(world.ball_position);
           glTranslatef(ball_pos.x,ball_pos.y,ball_pos.z);
           gluSphere(world.ball,0.02,20,20);
           glPopMatrix();
         }
         if ( Blend_On )
           {
             glDisable(GL_ALPHA_TEST);
             glEnable(GL_BLEND);
             glDepthFunc(GL_ALWAYS);
           }
         glEnable(GL_TEXTURE_2D);

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

   sprintf(buf,"AAdd: %d", Alpha_Add);
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

   glColor4f(0.9,0.2,0.2,.75);
   sprintf(buf,"FPS: %.2f F: %2d", FrameRate, FrameCount);
   glRasterPos2i(6,0);
   glutBitmapString(GLUT_BITMAP_HELVETICA_12,buf);

   // Done with this special projection matrix.  Throw it away.
   glPopMatrix();

   // All done drawing.  Let's show it.
   glutSwapBuffers();

   // And collect our statistics.
   ourDoFPS();
}

void
cbTimer(int data)
{
  static double next_frame_time = 0;
  if ( next_frame_time == 0 ) next_frame_time = time_fp();
  glutPostRedisplay();
  const double now = time_fp();
  next_frame_time += 1.0/30.0;
  const double delta = next_frame_time - now;
  const int delta_ms = delta <= 0 ? 0 : int(delta * 1000);

  glutTimerFunc(delta_ms,cbTimer,0);
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
     Z_Off += 0.05f;
     break;

   case '-':
     Z_Off -= 0.05f;
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

  world.cube_face_info[0].init(0,texid_bldg,.05,.05,.95,.95);  // Backw
  world.cube_face_info[1].init(1,texid_syllabus,.05,.05,.95,.95);
  world.cube_face_info[2].init(2,texid_syllabus,.2,.2,.8,.8);
  world.cube_face_info[3].init(3,texid_syllabus,.05,.05,1.95,1.95);
  world.cube_face_info[4].init(4,texid_syllabus,.2,.2,.5,.5);
  world.cube_face_info[5].init(5,texid_pie,0,0,1,1);

  for ( int f=0; f<6; f++ )
    {
      pCube_Face_Info* const fi = &world.cube_face_generic_info[f];
      const float dir = f & 1 ? 1.0 : 0.0;
      const int axis = f >> 1;
      pVect n(axis == 0, axis == 1, axis == 2);
      pVect a(axis != 0, axis == 0, 0);
      pVect b = pVect(1,1,1) - n - a;
      pCoor c00 = pCoor(0,0,0) + dir * n;
      fi->v00 = c00;
      fi->v10 = c00 + a;
      fi->v11 = c00 + a + b;
      fi->v01 = c00 + b;
    }
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
    pBuild_Texture_File("/home/faculty/koppel/teach/gp08/gp.ppm",true,255);
  //  texid_pie = pBuild_Texture_File("/home/faculty/koppel/Web/pie2.pnm");
  texid_pie = pBuild_Texture_File("mesa-pandc.pnm",false,255);
  texid_bldg = pBuild_Texture_File
    ("/home/faculty/koppel/s/web/ECE folder/ECE/images/2007/ee_bdg_to_ur_ed.ppm");

   // Color to clear color buffer to.
   glClearColor(0.1f, 0.1f, 0.1f, 0.0f);

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
   glEnable (GL_LIGHT1);

   // A handy option -- have surface material mirror the color.
   glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
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

   // OK, OpenGL's ready to go.  Let's call our own init function.
   ourInit(Window_Width, Window_Height);

   pInit();

   glutTimerFunc(10,cbTimer,0);

   // Print out a bit of help dialog.
   printf("\n" PROGRAM_TITLE "\n\n\
Use arrow keys to rotate, 'R' to reverse, 'S' to stop.\n\
Page up/down will move cube away from/towards camera.\n\n\
Use first letter of shown display mode settings to alter.\n\n\
Q or [Esc] to quit; OpenGL window must have focus for input.\n");

   // Pass off control to OpenGL.
   // Above functions are called as appropriate.
   glutMainLoop();

   return 1;
}
