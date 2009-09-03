/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
/// Homework 5

 /// Name:

// $Id:$

/// Instructions

// If necessary, follow the class account setup instructions linked
// to the class procedures page,
// http://www.ece.lsu.edu/koppel/gp/proc.html

// For instructions on how to check out edit, compile, and debug, see
// the "Programming Homework Work Flow" entry on the procedures page,
// http://www.ece.lsu.edu/koppel/gp/proc.html.
//
// For those instructions you need to know that:
//
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/2008/hw5
//
//  The assignment instructions are in file hw5.cc. (This file.)

// For the solutions to the problems below edit this file and
// hw5_shader.cc, even if it makes more sense to edit others.

 /// References:

// OpenGL:
// http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf

// OpenGL Shading Language:
// http://www.ece.lsu.edu/koppel/gp/refs/GLSLangSpec.Full.1.20.8.pdf

// This code uses a pShader class for initializing and using
// programmable shaders. This class can be used for your own shaders,
// or you can use the OpenGL calls directly. See shader.h for the
// pShader class (to figure out how to use it) and for examples look
// at the code in cube4.cc, search for vs_bump. (Cube 4 is in
// https://svn.ece.lsu.edu/svn/gp/play/)



/// Problem 0

// Fill in your name in the comment above.

// To fully complete this assignment one needs a GPU with a programmable
// shader and the necessary build environment support. At the present
// time the ECE lab computers provide the build environment (so that you
// can compile your code) but the GPUs are not programmable and so there
// is no way to test your code there. If no suitable computers can be
// located do your best with the assignment, making sure it compiles.

// To see if a computer is suitable build the assignment (no need to make
// changes) and run it. On the window there should be a line that starts:
// "PROGRAMMABLE GPU API:". If there is a "yes" after API and "okay"
// after GPU CODE then the system is suitable.


/// Problem 1

// The code in this file displays an undulating tube, similar to the
// one used in Homework 3. For each frame the code needs to compute
// the position of each vertex, a time-consuming task. Re-write the
// code so that it uses the GPU (running a vertex shader) to compute
// vertex positions. The goal is to reduce both the computation load
// on the CPU and the per-frame data transfer between the CPU and GPU.

// The code is already set up with a user-interface to switch between CPU
// and GPU computation (by pressing "a"), make sure it continues to work.

// The code is already written so that the CPU code can switch vertex
// buffering methods: sending data one vertex at a time or by using a
// client array. The user interface also supports switching the GPU
// code vertex buffering methods between vertex-at-a-time, a client
// array, or a buffer object. Write your code so this works as
// expected.

// The code already uses a programmable shader for lighting, that shader
// code is in hw5_shader.cc. Add your shader code to that file. Note that
// your added code should just be used for the tube. The lonely triangle
// will continue to use "vs_lighting" and the light location marker (the
// tetrahedron) will continue to use fixed functionality.

// Some User Interface Commands
//
//  v:  Vertex Buffering
//      Change the way vertices are passed to OpenGL.
//      See uses of opt_v_buffering_cpu, opt_v_buffering_gpu
//      Note: The "Buffer Object" (2) setting won't work on some GPUs.
//
// a:   GPU/CPU toggle.
//      Toggles the use of the GPU for computing vertex positions.
//      Initially turning this on will make the tube disappear,
//      but in the completed assignment it should work correctly.


 /// Solution Checklist

 // [ ] Use GPU code to compute vertex locations.
 // [ ] Honor the UI settings for vertex buffering (opt_v_buffering_gpu).
 // [ ] CPU time and CPU/GPU bandwidth should be moderately reduced when
 //     not using buffer objects.
 // [ ] CPU time and CPU/GPU bandwidth should be greatly reduced when using
 //     buffer objects.
 // [ ] Do not be concerned about minimizing GPU computation (for this problem).


 /// Solution Hints

 //  The code in the inner loop is simpler than it looks. The same
 //  shader routine should handle the three different vertices that
 //  the inner loop body writes without any if statements.

 //  Think about what data should be passed to the shader routine per
 //  vertex, and what data should be passed per frame.  If possible,
 //  make the per-vertex data identical from frame to frame so that
 //  it can be kept in a buffer object.

 //  To ease in slowly, make a copy of vs_main_lighting and try
 //  passing vs_ff_vertex or vs_lighting slightly changed parameters.
 //  This will verify that the code is indeed running on the GPU.



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
#include "shader.h"


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

  pVect to_eye_vector;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  float opt_light_intensity;
  int opt_v_buffering_cpu;
  int opt_v_buffering_gpu;
  pCoor opt_light_location;

  double time_app_start;

  pCoor* coor_buffer;
  pVect* norm_buffer;

  int num_coor_alloc;
  MTrig tarray;

  bool opt_gpu;
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
  opt_pattern_width = 200;    // Number of triangles along circumference.

  opt_light_intensity = 2;
  opt_v_buffering_cpu = 0;
  opt_v_buffering_gpu = 0;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );

  to_eye_vector.set(-1,-0.5,-3);

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_pattern_levels,"Pattern Levels");
  variable_control.insert(to_eye_vector.x,"Viewer X");

  coor_buffer = NULL;
  norm_buffer = NULL;
  num_coor_alloc = 0;

  glEnable(GL_NORMALIZE);

  // Declared like a programmable shader, but used for fixed-functionality.
  vs_fixed = new pShader();
  vs_lighting = new pShader("hw5_shader.cc","vs_main_lighting();");

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
  case 'a': case 'A': opt_gpu = !opt_gpu; break;
  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  case 'v': case 'V':
    if ( opt_gpu )
      {
	opt_v_buffering_gpu++;
	if ( opt_v_buffering_gpu == 3 ) opt_v_buffering_gpu = 0;
      }
    else
      {
	opt_v_buffering_cpu++;
	if ( opt_v_buffering_cpu == 2 ) opt_v_buffering_cpu = 0;
      }
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

  const char* const v_buffering_str[] =
    { "individual", "client array", "buffer object" };

  ogl_helper.fbprintf
    ("VERTEX BUFFERING:  CPU %s  GPU %s  (v TO CHANGE)\n",
     v_buffering_str[opt_v_buffering_cpu],
     v_buffering_str[opt_v_buffering_gpu]);
  ogl_helper.fbprintf
    ("GPU TUBE COMPUTATION: %s  (A TO CHANGE)\n", opt_gpu ? "gpu" : "cpu");
  ogl_helper.fbprintf
    ("PROGRAMMABLE GPU API: %s  GPU CODE: %s\n",
     ptr_glCreateShader ? "yes" : "no",
     vs_lighting->pobject ? "okay" : "problem");

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.3f\n",cvar->name,cvar->var[0]);

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
  const double phase_n =
    ( time_wall_fp() - time_app_start ) * cycles_per_second;
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
  if ( !opt_gpu )
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

  if ( opt_gpu )
    {

      //
      // Specify Vertices to GL in one of Three Ways
      //

      switch ( opt_v_buffering_gpu ) {

      case 0:
	// Individual Vertex Specification (Buffering)
	//
	{

	}
	break;

      case 1:
	// Client Array Vertex Buffering
	//
	// Vertices given to OpenGL as a single array each
	// time this code reached.
	{

	}
	break;

      case 2:
	{
	  // Buffer Object Vertex Buffering
	  //
	  // Vertices given to OpenGL earlier (using a buffer object, see
	  // glBufferData above). Hopefully the vertices are now on the
	  // GPU. Code below merely refers to that data.
	  //

	}
	break;
      }

    }
  else
    {
      //
      // Send CPU-Computed Vertices to GPU
      //

      vs_lighting->use();

      switch ( opt_v_buffering_cpu ) {

      case 0:
	// Individual Vertex Specification (Buffering)
	//
	{
	  glBegin(GL_TRIANGLES);
	  for ( int i=0; i<num_coor; i++ )
	    {
	      glNormal3fv(norm_buffer[i]);
	      glVertex3fv(coor_buffer[i]);
	      num_bytes += sizeof(float) * 6;
	    }
	  glEnd();
	}
	break;

      case 1:
	// Client Array Vertex Buffering
	//
	// Vertices given to OpenGL as a single array each
	// time this code reached.
	{
	  glNormalPointer(GL_FLOAT,0,norm_buffer);
	  glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
	  glEnableClientState(GL_NORMAL_ARRAY);
	  glEnableClientState(GL_VERTEX_ARRAY);

	  glDrawArrays(GL_TRIANGLES,0,num_coor);

	  glDisableClientState(GL_NORMAL_ARRAY);
	  glDisableClientState(GL_VERTEX_ARRAY);
	  num_bytes += sizeof(float) * 6 * num_coor;
	}
	break;

      case 2:  // It should be impossible to select this option.
	// Buffer Object Vertex Buffering
	//
	// Vertices given to OpenGL earlier (using a buffer object, see
	// glBufferData above). Hopefully the vertices are now on the
	// GPU.

	// This option not implemented because vertex positions change
	// from frame to frame and so there would be little advantage
	// in using a buffer object since the buffer object data
	// would have to be sent over every frame.

	break;
      }
    }

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
