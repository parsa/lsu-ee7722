/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
 /// Simple OpenGL

// $Id:$

 /// Purpose
//
//   Demonstrate vertex transfer overhead.

//   The routine draws an undulating gold tube pierced by a
//   triangle. The methods used to specify the vertices can be varied,
//   as can the length of the tube. There is a bright light in the
//   tube that can dimmed, brightened, and moved around.

 /// To compile and run:
//
//     make
//     demo-2-transfer

 /// More Information
//
//   OpenGL documentation.
//     http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf




/// Motivation:

//   Scenes can contain a very large number of primitives and these
//   can contribute to frame time in two ways:

//     Latency: Setup time for one item.
//       GL API facilitates avoiding latency.
//       To avoid: process /arrays/ of items. Latency suffered once.

//     CPU/GPU Bandwidth: Amount of data per unit time.
//       To avoid: Minimize amount of data.
//       To avoid: Pre-store unchanging items on CPU. (Buffer objects.)
//       To avoid: Use GPU for computation. (Later demo program.)


/// Latency Contributors

 ///  Client Side

//    Validating Arguments
//      GL minimizes this by not requiring validation on high-volume calls.

//    Packaging data.
//      Write vertex argument to buffer area of client memory..
//      ..along with command and other info.

//    Initiating transfer.
//      Signal GPU to read data.

 ///  GPU Side

//    Parsing commands.
//    Pipeline setup.
//      Change any modified state (lighting, transform, etc.)


/// GL Arrays

// Refers to arrays of particular objects.
//   Such as: GL_NORMAL_ARRAY, GL_VERTEX_ARRAY.

//  "Load" array type with data.
//  Indicate that array will be used.
//  Emit vertices.



// Buffering Methods
//  Common: Array of vertices.

//  Copy info from client memory for each draw.
//   + Save function call overhead.
//   + GL can better plan logistics.

//  Put "arrays" under GL control.


// From Client Memory
//  Indicate for each attribute..
//  Draw Array
//  Disconnect.

// Buffer Objects
//  Blocks of memory..
//  ..can be read and written by CPU..
//  ..or by GPU.
//  

// From GPU Memory
//  



#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include "util.h"
#include "coord.h"
#include "image.h"


GLuint
pTexture_From_PNM(char *name, bool invert = false, int transp = 256 )
{
  GLenum gluerr;
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;
  if ( invert ) image.color_invert();
  GLuint texture_id;
  glGenTextures(1,&texture_id);
  glBindTexture(GL_TEXTURE_2D,texture_id);
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
   pError_Check();

   return texture_id;
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


// Class for re-using sine and cosine values.
//
class MTrig {
public:
  MTrig():size(0),storage(NULL){}
  void init(int sizep){
    size = sizep;
    if ( storage ) delete storage;
    storage = new float[size];
    idx = 0;
    full = false;
  }
  float sin(float theta){ return trig(theta,::sin); }
  float cos(float theta){ return trig(theta,::cos); }
private:
  float trig(float theta,double (*func)(double))
  {
    if ( !full ) { storage[idx] = func(theta);  full = idx == size - 1; }
    if ( idx == size ) idx = 0;
    return storage[idx++];
  }
  int size;
  float* storage;
  int idx;
  bool full;
};


//
 /// Tube Object
//

class Tube {
public:
  Tube(pOpenGL_Helper &fb):ogl_helper(fb){ init(); }
  static void render_w(void *moi){ ((Tube*)moi)->render(); }
  void init();
  void render();
private:
  pOpenGL_Helper &ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;

  pVect to_eye_vector;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  float opt_light_intensity;
  int opt_t_mode;
  bool opt_recompute;
  pCoor opt_light_location;

  bool buffer_data_0;

  double time_app_start;

  pCoor* coor_buffer;
  pVect* norm_buffer;

  int num_coor_alloc;
  MTrig tarray;

  GLuint gpu_coor_buffer;
  GLuint gpu_norm_buffer;

  GLuint texture_id_syllabus;

};

void
Tube::init()
{
  time_app_start = time_wall_fp();

  // Tell frame timer that work unit is "MB/s" and how should be scaled.
  //
  frame_timer.work_unit_set("MB/s",1e-6);

  r0 = 2;                 // Tube radius.
  x_shift = 0.4;          // Tube x offset.
  pattern_pitch_z = 0.25; // Triangle size (z axis).

  opt_pattern_levels = 50;    // Tube depth (z direction.)
  opt_pattern_width = 50;     // Triangle size (circumferential).

  opt_light_intensity = 2;
  opt_t_mode = 0;
  opt_recompute = true;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );

  to_eye_vector.set(-1,-0.5,-3);

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_pattern_levels,"Pattern Levels");
  variable_control.insert(to_eye_vector.x,"Viewer X");

  buffer_data_0 = false;
  coor_buffer = NULL;
  norm_buffer = NULL;
  num_coor_alloc = 0;

  // Get names (just names) for GL-managed buffers.
  //
  glGenBuffers(1,&gpu_norm_buffer);
  glGenBuffers(1,&gpu_coor_buffer);

  texture_id_syllabus = pTexture_From_PNM("gp.ppm",true,255);

}


void
Tube::render()
{
  frame_timer.frame_start();

  glClearColor(0,0,0.0,0.5);
  glClearDepth(1.0);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  // Have frame timer provide timing information for top of image.
  //
  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());


  ///
  /// Transformation Matrix Setup
  ///

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(to_eye_vector.x,to_eye_vector.y,to_eye_vector.z);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-0.8,+0.8,-0.8/aspect,0.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();


  ///
  /// Light Location and Lighting Options
  ///

  // Adjust options based on user input.
  //
  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: opt_light_location.x -= 0.1; break;
  case FB_KEY_RIGHT: opt_light_location.x += 0.1; break;
  case FB_KEY_UP: opt_light_location.y += 0.1; break;
  case FB_KEY_DOWN: opt_light_location.y -= 0.1; break;
  case FB_KEY_PAGE_DOWN: opt_light_location.z += 0.2; break;
  case FB_KEY_PAGE_UP: opt_light_location.z -= 0.2; break;
  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  case 'r':case 'R': break;
  case 'v': case 'V':
    opt_t_mode++;
    if ( opt_t_mode == 3 ) opt_t_mode = 0;
    break;
  default: break;
  }

  glLightfv(GL_LIGHT0, GL_POSITION, opt_light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};
  const float light_dim[4] = {0.1,0.1,0.1,1};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_dim[0]);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
  glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  const char* const t_mode_str[] =
    { "Individual", "Client Array", "Buffer Object" };

  ogl_helper.fbprintf
    ("Vertex specification:  %s  (v to change)\n",
     t_mode_str[opt_t_mode]);
  ogl_helper.fbprintf("Tube recomputation: %d\n", opt_recompute);
  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.3f\n",cvar->name,cvar->var[0]);

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(opt_light_location,0.05);

  //
  // Insert a tessellated tube in the vertex list.
  //

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold


  //
  // Get Tube Specifications
  //

  const int pattern_width = 3 * int( opt_pattern_width * 0.33333333 );
  const int pattern_levels = int( opt_pattern_levels + 0.5 );

  const int vertices_per_ring = 3 * pattern_width * 2;
  const int num_coor = pattern_levels * vertices_per_ring;

  const double cycles_per_second = 0.2;
  const double phase_n =
    ( time_wall_fp() - time_app_start ) * cycles_per_second;
  const double phase = phase_n * 2.0 * M_PI;
  const double phase_01 = 1.0 - ( phase_n - floor(phase_n) );

  const float wavelength_z = 4.8;
  const float wavelength_rings = wavelength_z / pattern_pitch_z;
  const float radians_per_z = 2.0 * M_PI / wavelength_z;
  const int wavelength_v = int(wavelength_rings * vertices_per_ring + 0.5);

  const int phase_rings = int( phase_01 * wavelength_rings + 0.5 );

  const float phase_z = opt_recompute ? 0 : wavelength_z * phase_01;
  const int phase_v = opt_recompute ? 0 : phase_rings * vertices_per_ring;

  if ( phase_v > wavelength_v || phase_v < 0 ) pError_Exit();

  const int num_v = num_coor - wavelength_v;
  int num_bytes = 0;

  const float ampl = 0.4;

  glEnable(GL_NORMALIZE);
  
  glColor3fv( color_gold );


  // If number of vertices has changed re-allocate our storage
  // (coor_buffer, norm_buffer) and MTrig object and also remember
  // that gpu's buffer needs to be updated.

  if ( num_coor_alloc != num_coor )
    {
      if ( coor_buffer ) { delete coor_buffer; delete norm_buffer; }
      coor_buffer = new pCoor[num_coor];
      norm_buffer = new pVect[num_coor];
      tarray.init( pattern_width * 2 * 2 * 6 );
      num_coor_alloc = num_coor;
    }

  pCoor* cptr = coor_buffer;
  pVect* nptr = norm_buffer;

  // Outer Loop: z axis (down axis of tube).
  //
  if ( true )
    {
      const float phase_use = opt_recompute ? phase : 0;
      const float delta_theta = M_PI / pattern_width;

      for ( int i = 0; i < pattern_levels; i++ )
        {
          const float next_z = z - pattern_pitch_z;
          const float last_z = z + pattern_pitch_z;
          float theta = i & 1 ? delta_theta : 0;
          const float angle_z = phase_use + radians_per_z * z;
          const float angle_nz = phase_use + radians_per_z * next_z;
          const float angle_lz = phase_use + radians_per_z * last_z;
          const float r = r0 * ( 1 + ampl * sin( angle_z ) );
          const float rnz = r0 * ( 1 + ampl * sin( angle_nz ) );
          const float rlz = r0 * ( 1 + ampl * sin( angle_lz ) );
          const float cos_z = cos(angle_z);
          const float cos_lz = cos(angle_lz);
          const float cos_nz = cos(angle_nz);

          // Inner Loop: around circumference of tube.
          //
          while ( theta < 4 * M_PI - delta_theta )
            {
              const bool first_round = theta < 2 * M_PI;
              const float z1 = first_round ? next_z : last_z;
              const float rz1 = first_round ? rnz : rlz;
              const float cos_z1 = first_round ? cos_nz : cos_lz;

              float cos_theta = tarray.cos(theta);  // Reassigned
              float sin_theta = tarray.sin(theta);  // Reassigned

              pCoor v0(x_shift + r * cos_theta, r * sin_theta, z);
              pVect v0_normal(-cos_theta,-sin_theta,cos_z);

              theta += delta_theta;

              cos_theta = tarray.cos(theta);
              sin_theta = tarray.sin(theta);

              pCoor v1(x_shift + rz1 * cos_theta, rz1 * sin_theta, z1);
              pVect v1_normal(-cos_theta,-sin_theta,cos_z1);

              theta += delta_theta;

              cos_theta = tarray.cos(theta);
              sin_theta = tarray.sin(theta);

              pCoor v2(x_shift + r * cos_theta, r * sin_theta, z);
              pVect v2_normal(-cos_theta,-sin_theta,cos_z);

              *nptr++ = v0_normal;
              *nptr++ = v1_normal;
              *nptr++ = v2_normal;

              *cptr++ = v0;
              *cptr++ = v1;
              *cptr++ = v2;

#if 0
              glBegin(GL_TRIANGLES);

              glNormal3fv(v0_normal);  glVertex3fv(v0);
              glNormal3fv(v1_normal);  glVertex3fv(v1);
              glNormal3fv(v2_normal);  glVertex3fv(v2);

              glEnd();
#endif
            }
          z = next_z;
        }

    }

    // As a group, data in client memory.
    // Requires transfer from CPU (client) to GPU.
  {
    glNormalPointer(GL_FLOAT,0,norm_buffer);
    glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLES,phase_v,num_v);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    num_bytes += sizeof(float) * 6 * num_v;
  }

  frame_timer.work_amt_set(num_bytes);

  // Insert additional triangle.
  //
  {
    pCoor v0( 1.5, 0, -3.2 );
    pCoor v1( 0, 5, -5 );
    pCoor v2( 9, 6, -9 );
    pVect normal(cross(v0,v1,v2));

    glColor3fv( color_purple );
    glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
    glTexParameterf
      (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);
    glEnable(GL_TEXTURE_2D);

    glBegin(GL_TRIANGLES);

    glTexCoord2f(0.1,0);
    glNormal3fv(normal);  glVertex3fv(v0);
    glTexCoord2f(0.0,0.8);
    glNormal3fv(normal);  glVertex3fv(v1);
    glTexCoord2f(1.0,0.1);
    glNormal3fv(normal);  glVertex3fv(v2);

    glEnd();

    glDisable(GL_TEXTURE_2D);

  }

  glColor3f(0,1,0); // This sets the text color. Don't know why.

  pError_Check();

  frame_timer.frame_end();

  glutSwapBuffers();

}

int
main(int argc, char **argv)
{
  pOpenGL_Helper popengl_helper(argc,argv);
  Tube tube(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(tube.render_w,&tube);
  

  return 0;
}
