/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
 /// Fragment Shader for Textures Demo

// $Id:$

 /// Purpose
//
//   Demonstrate texturing techniques.

 /// More Information
//
//   OpenGL documentation.
//     http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf




/// Motivation:





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
#include "shader.h"


enum { PT_Invert = 1, PT_To_Alpha = 2 };

GLuint
pTexture_From_PNM
(char *name, int option = 0, int transp = 256 )
{
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;
  if ( option & PT_To_Alpha ) image.gray_to_alpha();
  if ( option & PT_Invert ) image.color_invert();
  GLuint texture_id;

  glGenTextures(1,&texture_id);
  glBindTexture(GL_TEXTURE_2D,texture_id);

  glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP,1);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  glTexImage2D(GL_TEXTURE_2D,
	       0, // Level (0 is base).
	       GL_RGBA,
	       image.width, image.height,
	       0, // Border
	       GL_RGBA,
	       GL_UNSIGNED_BYTE,
	       (void*)image.data);
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


#define ENUM_LABEL(c) { #c, c }
struct pEnum_Label { const char *label; int value; };
pEnum_Label texture_env_modes[] = {
  ENUM_LABEL(GL_MODULATE),
  { "Texturing Off", 0 },
  ENUM_LABEL(GL_REPLACE),
  ENUM_LABEL(GL_DECAL),   // Blend using alpha value of texture.
  {NULL,0}
};

pEnum_Label texture_min_filters[] = {
  ENUM_LABEL( GL_LINEAR_MIPMAP_LINEAR ),
  ENUM_LABEL( GL_NEAREST_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_LINEAR_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_NEAREST_MIPMAP_LINEAR ),
  {NULL,0}
};

pEnum_Label texture_mag_filters[] = {
  ENUM_LABEL( GL_LINEAR ),
  ENUM_LABEL( GL_NEAREST ),
  {NULL,0}
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

  pShader *vs_fixed;     // Fixed functionality.
  pShader *vs_lighting;  // Lighting tweak.
  pShader *vs_phong;     // Phong shading.

  GLuint sam_1;          // Sampler 1. (Texture access handle.)

  pVect to_eye_vector;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  float opt_light_intensity;
  pCoor opt_light_location;
  bool opt_pause;

  double time_last_frame;
  double time_app;

  pCoor* coor_buffer;
  pVect* norm_buffer;
  float* text_buffer;

  int num_coor_alloc;
  MTrig tarray;

  bool opt_gpu;

  int opt_texture_env_mode;
  int opt_texture_min_filter;
  int opt_texture_mag_filter;

  GLuint texture_id_syllabus;
  GLuint texture_id_image;

};

void
Tube::init()
{
  time_app = 0;
  time_last_frame = time_wall_fp();

  // Tell frame timer that work unit is "MB/s" and how should be scaled.
  //
  frame_timer.work_unit_set("MB/s",1e-6);

  r0 = 2;                 // Tube radius.
  x_shift = 0.4;          // Tube x offset.
  pattern_pitch_z = 0.25; // Triangle size (z axis).

  opt_pattern_levels = 50;    // Tube depth (z direction.)
  opt_pattern_width = 50;     // Triangle size (circumferential).

  opt_light_intensity = 2;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );

  to_eye_vector.set(-1,-0.5,-3);

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(to_eye_vector.z,"Viewer Z");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(to_eye_vector.x,"Viewer X");

  coor_buffer = NULL;
  norm_buffer = NULL;
  num_coor_alloc = 0;

  glEnable(GL_NORMALIZE);

  // Declared like a programmable shader, but used for fixed-functionality.
  vs_fixed = new pShader();
  vs_lighting = new pShader("demo-6-shader.cc","vs_main_lighting();");
  vs_phong = new pShader
    ("demo-6-shader.cc","vs_main_phong();","fs_main_phong();");
  sam_1 = vs_phong->uniform_location("sam_1");

  texture_id_syllabus = pTexture_From_PNM("gp.ppm",PT_Invert | PT_To_Alpha);
  texture_id_image = pTexture_From_PNM("gp.ppm");

  opt_texture_env_mode = 0;
  opt_texture_min_filter = 0;
  opt_texture_mag_filter = 0;

  opt_pause = false;
  opt_gpu = false;
}


void
Tube::render()
{
  frame_timer.frame_start();

  ///
  /// Reset Frame and Z Buffers
  ///

  glClearColor(0,0,0.0,0.5);
  glClearDepth(1.0);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  // Have frame timer provide timing information for top of image.
  //
  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());


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
  case 'f': case 'F': opt_gpu = !opt_gpu; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'm': opt_texture_env_mode++;
    if ( !texture_env_modes[opt_texture_env_mode].label )
      opt_texture_env_mode = 0;
    break;
  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: break;
  }

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

  ogl_helper.fbprintf("FRAGMENT SHADER: %s  (f to change)\n",
                      opt_gpu ? "On" : "Off");
  ogl_helper.fbprintf
    ("PROGRAMMABLE GPU API: %s  GPU CODE: %s\n",
     ptr_glCreateShader ? "yes" : "no",
     vs_lighting->pobject ? "okay" : "problem");

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.3f  (+/- to adjust)\n",
		      cvar->name,cvar->var[0]);
  ogl_helper.fbprintf("Texture Mode: %s  (m to change)\n",
		      texture_env_modes[opt_texture_env_mode].label);

  if ( opt_pause )
    ogl_helper.fbprintf("Animation PAUSED  (p to resume)");
  else
    ogl_helper.fbprintf("Animation RUNNING  (p to pause)");

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  vs_fixed->use();
  insert_tetrahedron(opt_light_location,0.05);

  //
  // Insert a tessellated tube in the vertex list.
  //

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold

  //
  // Compute Tube Specifications
  //

  const int pattern_width = 3 * int( opt_pattern_width * 0.33333333 );
  const int pattern_levels = int( opt_pattern_levels + 0.5 );

  // Number of vertices passed to OpenGL.
  const int vertices_per_ring = 3 * 2 * pattern_width;

  const int num_coor = pattern_levels * vertices_per_ring;

  const double cycles_per_second = 0.2;
  const double now = time_wall_fp();
  const double delta_t = now - time_last_frame;
  time_last_frame = now;
  if ( !opt_pause ) time_app += delta_t;
  const double phase_n = time_app * cycles_per_second;
  const double phase = phase_n * 2.0 * M_PI;

  const float wavelength_z = 2.8;
  const float radians_per_z = 2.0 * M_PI / wavelength_z;

  int num_bytes = 0;

  const float ampl = 0.2;

  glColor3fv( color_gold );

  // If number of vertices has changed re-allocate our storage
  // (coor_buffer, norm_buffer) and MTrig object and also remember
  // that gpu's buffer needs to be updated.

  if ( num_coor_alloc != num_coor )
    {
      if ( coor_buffer )
	{ delete coor_buffer; delete norm_buffer; delete text_buffer; }
      coor_buffer = new pCoor[num_coor];
      norm_buffer = new pVect[num_coor];
      text_buffer = new float[num_coor*2];

      tarray.init( vertices_per_ring * 4 );
      num_coor_alloc = num_coor;
    }

  // Outer Loop: z axis (down axis of tube).
  //
  if ( true )
    {
      pCoor* cptr = coor_buffer;
      pVect* nptr = norm_buffer;
      float* tptr = text_buffer;

      const float delta_theta = M_PI / pattern_width;

      for ( int i = 0; i < pattern_levels; i++ )
	{
	  const float next_z = z - pattern_pitch_z;
	  const float last_z = z + pattern_pitch_z;
	  float theta = i & 1 ? delta_theta : 0;
	  const float angle_z = phase + radians_per_z * z;
	  const float angle_nz = phase + radians_per_z * next_z;
	  const float angle_lz = phase + radians_per_z * last_z;
	  const float r = r0 * ( 1 + ampl * sin( angle_z ) );
	  const float rnz = r0 * ( 1 + ampl * sin( angle_nz ) );
	  const float rlz = r0 * ( 1 + ampl * sin( angle_lz ) );
	  const float cos_z = cos(angle_z);
	  const float cos_lz = cos(angle_lz);
	  const float cos_nz = cos(angle_nz);
	  const float z_scale = -0.125;
	  const float th_scale = -1.0 / ( 2 * M_PI );

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

	      *tptr++ = theta * th_scale; *tptr++ = z * z_scale;

	      theta += delta_theta;

	      cos_theta = tarray.cos(theta);
	      sin_theta = tarray.sin(theta);

	      pCoor v1(x_shift + rz1 * cos_theta, rz1 * sin_theta, z1);
	      pVect v1_normal(-cos_theta,-sin_theta,cos_z1);

	      *tptr++ = theta * th_scale; *tptr++ = z1 * z_scale;

	      theta += delta_theta;

	      cos_theta = tarray.cos(theta);
	      sin_theta = tarray.sin(theta);

	      pCoor v2(x_shift + r * cos_theta, r * sin_theta, z);
	      pVect v2_normal(-cos_theta,-sin_theta,cos_z);

	      *tptr++ = theta * th_scale; *tptr++ = z * z_scale;

	      *nptr++ = v0_normal; *nptr++ = v1_normal; *nptr++ = v2_normal;

	      *cptr++ = v0; *cptr++ = v1; *cptr++ = v2;

	    }
	  z = next_z;
	}
    }

  if ( opt_gpu )
    {
      vs_phong->use();
      glUniform1i(sam_1,0);
      pError_Check();
    }
  else
    vs_lighting->use();

  if ( opt_texture_env_mode )
    {
      glBindTexture(GL_TEXTURE_2D,texture_id_image);

      glTexParameterf
        (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

      glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

      glTexEnvi
        (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,
         texture_env_modes[opt_texture_env_mode].value);

      glEnable(GL_TEXTURE_2D);
    }

  glNormalPointer(GL_FLOAT,0,norm_buffer);
  glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
  glTexCoordPointer(2,GL_FLOAT,0,text_buffer);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDrawArrays(GL_TRIANGLES,0,num_coor);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  num_bytes += sizeof(float) * 6 * num_coor;

  frame_timer.work_amt_set(num_bytes);

  // Insert additional quadrilateral.
  //
  {
    // Position of vertices:
    //
    //       v3        v2
    //
    //       v0        v1
    //
    pCoor v0( -1, -1, -5 );
    pCoor v1(  5, -1, -3 );
    pCoor v2(  5,  6, -1 );
    pCoor v3( -1,  6, -3 );

    pVect normal(cross(v2,v1,v0));

    glColor3fv( color_purple );
    // Make primitive more sensitive to light.
    glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.2);
    glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.05);

    glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

    glBegin(GL_QUADS);

    // Note: Texture coordinate (0,0) is upper-left.
    //
    glTexCoord2f(0,1); glNormal3fv(normal);  glVertex3fv(v0);
    glTexCoord2f(1,1); glNormal3fv(normal);  glVertex3fv(v1);
    glTexCoord2f(1,0); glNormal3fv(normal);  glVertex3fv(v2);
    glTexCoord2f(0,0); glNormal3fv(normal);  glVertex3fv(v3);

    glEnd();

    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);

  }

  vs_lighting->use();

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
