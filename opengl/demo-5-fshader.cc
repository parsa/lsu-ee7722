/// LSU EE 7700-1 (Spring 2009), Graphics Processors
//
 /// Fragment Shader / Phong Shading Demonstration

// $Id:$

 /// Purpose
//
//   Show the simple use of a fragment shader, to implement phong shading.

 /// More Information
//
//   OpenGL documentation.
//     http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf
//
//   OpenGL Shading Language
//     http://www.ece.lsu.edu/koppel/gp/refs/GLSLangSpec.Full.1.30.08.withchanges.pdf

 /// What Code Does

 // This program displays the undulating tube and lonely triangle from
 // previous examples, with the option of using a fragment shader for
 // the tube and triangle (f key). With the fragment shader off
 // primitives are colored using Gouraud shading, in which lighting
 // is computed only at the vertices of a primitive and then interpolated
 // for use in fragments.  The fragment shader implements Phong shading,
 // in which lighting is computed at each fragment.

 // The difference can be best seen by moving the light (arrow keys
 // and PageUp / PageDown) near the triangle, but away from any vertex.
 // With Phong shading there will be a bright spot near the light, with
 // Gouraud shading the brightest part of the triangle will be at the
 // vertex closest to the light.

 /// Fragment Shader OpenGL Code

 /// Initialization
 //  OpenGL 2.1 2.15

 //  As with a vertex shader, fragment shader code must be loaded,
 //  compiled, and linked.  This is done using the pShader class
 //  in shader.h.

 //  The code in Tube::init instantiates three such objects, vs_lighting
 //  which includes only a vertex shader implementing a simple lighting
 //  model, vs_phong which implements the Phong shader, and vs_fixed
 //  which is used to select OpenGL fixed functionality.

 //  The code in pShader::init loads the shader code from a file,
 //  demo-5-shader.cc, adds on a "main" routine, and then uses OpenGL
 //  functions to compile and link the shaders. The shaders are
 //  compiled into microcode for the GPU shaders, the linked microcode
 //  is likely copied to GPU memory to await its use.


 /// Use of Shader Code

 //  The fragment shader is turned on by the use member function of
 //  pShader, which itself calls glUseProgram. This loads the GPU
 //  micro code memories with the microcode. Subsequent vertices will
 //  be processed by the shader code. Calling glUseProgram with a zero
 //  argument switches back to fixed-function processing. This is most
 //  likely implemented by loading manufacturer-provided microcode in
 //  the micro code memories, to implement the fixed functionality as
 //  defined by OpenGL.


 /// Shader Code
 //
 //  OpenGL 2.1 2.15.4  Vertex Shader Functionality.
 //  OGSL 1.2 7         Built In Shader Variables

 //  The shader code is in demo-5-shader.cc, that code is used for
 //  both vs_lighting (which doesn't perform fragment shading) and
 //  vs_phong (which does fragment shading).

 //  The vertex shader is responsible for performing a set of
 //  calculations normally provided in fixed-functionality
 //  operation. This includes transforming coordinates and performing
 //  lighting calculations, see OpenGL 2.1 2.15.4 for a complete
 //  list. The vertex shader must perform all of the calculations (or
 //  else loose the functionality). For example, though the goal of
 //  vs_lighting was a lighting tweak it must still perform vertex
 //  transformations. Texture coordinate generation is not performed
 //  by vs_lighting and so texturing would not work (things are
 //  different in demo-6).

 ///  vs_lighting: Simple Lighting Model.
 //
 //  The entry point is vs_main_lighting, that calls vs_ff_vertex for
 //  vertex transformation and then generic_lighting for lighting.
 //  See OGSL 1.2 7 for a list of built-in variables available to
 //  shaders.

 ///  vs_phong: Phong Shading

 //  vs_phong installs both a vertex shader (vs_main_phong) and
 //  fragment shader (fs_main_phong), they work together.

 //  The vertex shader, vs_phong, performs the coordinate
 //  transformations to clip space, but also writes eye-space
 //  coordinates to a new varying, var_vertex_e. The surface normal is
 //  also written to a declared varying but the material color
 //  (unlighted) is written to predefined varyings: gl_BackColor and
 //  gl_FrontColor.

 //  The fragment shader, fs_main_phong, uses the interpolated
 //  eye-space vertex, normal, and color for a lighting
 //  computation. Notice that the same lighting routine,
 //  generic_lighting, is used by the fragment shader and the
 //  vs_lighting vertex shader. The difference is that the fragment
 //  shader is calling it at every fragment and so the surface normals
 //  and distances will be correct.

 //  Note that the generic_lighting routine performs a substantial
 //  amount of calculation, which is why Phong shading is not even
 //  an option in OpenGL.  For modern GPUs Phong shading is not a
 //  great burden.


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

#include "../include/util.h"
#include "../include/coord.h"
#include "../include/shader.h"


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

  pShader *vs_fixed;     // Fixed functionality.
  pShader *vs_lighting;  // Lighting tweak.
  pShader *vs_phong;     // Phong shading.

  pVect to_eye_vector;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  float opt_light_intensity;
  pCoor opt_light_location;

  double time_last_frame;
  double time_app; //  Time in simulated world in seconds. Starts at zero.

  pCoor* coor_buffer;
  pVect* norm_buffer;

  int num_coor_alloc;
  MTrig tarray;

  bool opt_pause;
  bool opt_fshader;
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
  opt_pattern_width =  30;    // Number of triangles along circumference.

  opt_light_intensity = 2;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );

  to_eye_vector.set(-1,-0.5,-3);

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_pattern_levels,"Pattern Levels");
  variable_control.insert(opt_pattern_width,"Pattern Width");
  variable_control.insert(to_eye_vector.x,"Viewer X");

  coor_buffer = NULL;
  norm_buffer = NULL;
  num_coor_alloc = 0;

  glEnable(GL_NORMALIZE);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  vs_fixed = new pShader();

  // Prepare a vertex shader implementing a simple lighting model.
  //
  vs_lighting = new pShader("demo-5-shader.cc","vs_main_lighting();");

  // Prepare a vertex shader and fragment shader, implementing a Phong shader.
  //
  vs_phong = new pShader
    ("demo-5-shader.cc","vs_main_phong();","fs_main_phong();");

  opt_pause = false;
  opt_fshader = false;
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
  /// Transformation Matrices Setup
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
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'f': case 'F': opt_fshader = !opt_fshader; break;
  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
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

  ogl_helper.fbprintf("FRAGMENT SHADER: %s  (f TO CHANGE)\n",
		      opt_fshader ? "on" : "off");
  if ( !vs_lighting->pobject )
    ogl_helper.fbprintf
      ("PROGRAMMABLE GPU API: %savailable.  GPU CODE: %s\n",
       ptr_glCreateShader ? "" : "not",
       vs_lighting->pobject ? "okay" : "problem");

  ogl_helper.fbprintf
    ("ANIMATION %s  (p TO TOGGLE)\n", opt_pause ? "paused" : "running");

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf
    ("VAR %s = %.3f  (tab, +/- TO ADJUST)\n",
     cvar->name,cvar->var[0]);

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  vs_fixed->use();
  insert_tetrahedron(opt_light_location,0.05);

  ///
  /// Insert a tessellated tube in the vertex array.
  ///

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

  const float ampl = 0.4;

  glColor3fv( color_gold );

  // If number of vertices has changed re-allocate our storage
  // (coor_buffer, norm_buffer) and MTrig object and also remember
  // that gpu's buffer needs to be updated.

  if ( num_coor_alloc != num_coor )
    {
      if ( coor_buffer ) { delete coor_buffer; delete norm_buffer; }
      coor_buffer = new pCoor[num_coor];
      norm_buffer = new pVect[num_coor];

      tarray.init( vertices_per_ring * 4 );
      num_coor_alloc = num_coor;
    }

  // Outer Loop: z axis (down axis of tube).
  //
  {
    pCoor* cptr = coor_buffer;
    pVect* nptr = norm_buffer;

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

	pCoor* const cptr_stop = cptr + vertices_per_ring;

	// Inner Loop: around circumference of tube.
	//
	while ( cptr < cptr_stop )
	  {
	    // This loop iterates for two trips around the ring,
	    // on the first trip first_round is true and triangles point
	    // away from the viewer, on the second round they point towards
	    // the viewer.

	    const bool first_round = theta < 2 * M_PI;
	    const float z1 = first_round ? next_z : last_z;
	    const float rz1 = first_round ? rnz : rlz;
	    const float cos_z1 = first_round ? cos_nz : cos_lz;

	    float cos_theta = tarray.cos(theta);  // Reassigned
	    float sin_theta = tarray.sin(theta);  // Reassigned

	    // First vertex of triangle.
	    //
	    *cptr++ = pCoor(x_shift + r * cos_theta, r * sin_theta, z);
	    *nptr++ = pVect(-cos_theta,-sin_theta,cos_z);

	    theta += delta_theta;
	    cos_theta = tarray.cos(theta);
	    sin_theta = tarray.sin(theta);

	    // Second vertex of triangle.
	    //
	    *cptr++ = pCoor(x_shift + rz1 * cos_theta, rz1 * sin_theta, z1);
	    *nptr++ = pVect(-cos_theta,-sin_theta,cos_z1);

	    theta += delta_theta;
	    cos_theta = tarray.cos(theta);
	    sin_theta = tarray.sin(theta);

	    // Third vertex of triangle.
	    //
	    *cptr++ = pCoor(x_shift + r * cos_theta, r * sin_theta, z);
	    *nptr++ = pVect(-cos_theta,-sin_theta,cos_z);

	  }
	z = next_z;
      }

  }

  //
  // Send CPU-Computed Vertices to GPU
  //

  if ( opt_fshader )
    vs_phong->use();
  else
    vs_lighting->use();

  glNormalPointer(GL_FLOAT,0,norm_buffer);
  glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);

  glDrawArrays(GL_TRIANGLES,0,num_coor);

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  num_bytes += sizeof(float) * 6 * num_coor;

  pError_Check();

  frame_timer.work_amt_set(num_bytes);

  // Insert additional triangle.
  //
  {
    pCoor v0( 1.5, 0, -3.2 );
    pCoor v1( 0, 5, -5 );
    pCoor v2( 9, 6, -9 );
    pVect normal(cross(v0,v1,v2));

    glColor3fv( color_purple );

    glBegin(GL_TRIANGLES);

    glNormal3fv(normal);  glVertex3fv(v0);
    glNormal3fv(normal);  glVertex3fv(v1);
    glNormal3fv(normal);  glVertex3fv(v2);

    glEnd();

  }

  vs_fixed->use();

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
