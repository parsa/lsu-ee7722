/// LSU EE 7700-1 (Sp 2009), Graphics Processors
//
/// Homework 5  SOLUTION


// $Id:$  <- This is not your student ID, don't change this line!

/// Instructions

// If necessary, follow the class account setup instructions linked to
// the class procedures page,
// http://www.ece.lsu.edu/koppel/gp/proc.html

// For instructions on how to check out edit, compile, and debug, see
// the "Programming Homework Work Flow" entry on the procedures page,
// http://www.ece.lsu.edu/koppel/gp/proc.html.
//
// For those instructions you need to know that:
//
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/2009/hw5
//
//  The assignment instructions are in file hw4.cc. (This file.)

// The OpenGL spec, needed for this assignment, is at
//   http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf
//   The relevant sections are 2.7, 2.8, and 2.9. (Vertex specification,
//   vertex arrays, and buffer objects.)

// For the solutions to the problems below edit this file, even if
// it makes more sense to edit others (namely, coord.h). If it seems
// that coord.h must be edited, contact me.

// The main code is in routine Tube::render().


/// Overview

 //  The code in this file renders the undulating tube. In this
 //  assignment add a visual indicator of surface normals, we will
 //  call them arrows. The goal of this assignment is to determine the
 //  overhead of switching transformation matrices in the GPU, the
 //  transformation matrices will be used to rotate and translate an
 //  arrow into position.  Arrows can also be rendered the "old-fashioned"
 //  way, by computing each arrow's vertex coordinates on the CPU.

///  Keyboard Commands
 //
 //  'v'  Switch method of specifying arrow vertices:
 //       (Implementing these options is part of the assignment.)
 //       0:  Use glMultiDrawArrays. (One call for all arrows.)
 //       1:  Use glDrawArrays within a loop.
 //       2:  Within a loop change transform and send same arrow.
 //
 //  'b'  Toggle between using client arrays and buffer objects for arrows.
 //       Implemented as part of this assignment.
 //
 //  'p'  Pause tube. When paused vertex information is not re-computed
 //       every frame.

 /// Variables
 //   Selected program variables can be modified using the keyboard.
 //   Use "Tab" to cycle through the variable to be modified, the
 //   name of the variable is displayed next to "VAR" on the bottom
 //   line of green text.
 //   Use '+' (or '=') and '-' (or '_') to change the variable.
 //   (Search for 'variable_control.insert' to find examples of how to
 //   add your own variables.)
 //
 //  VAR Light Intensity - The light intensity.
 //  VAR Pattern Levels - The number of rings of triangles (along the z axis).
 //  VAR Arrow Detail - Amount of detail shown in arrow.

 //
 /// Eye and Light Location
 //   Arrows, Page Up, Page Down
 //   Move either the light or the eye.
 //   After pressing 'l' the keys move the light, after pressing 'e'
 //   they move the eye (viewer location). The eye and light location
 //   coordinates are displayed in the upper left.
 //
 /// Eye Direction
 //   Home, End, Delete, Insert
 //   Turn the eye direction.
 //   Home should rotate eye direction up, End should rotate eye
 //   down, Delete should rotate eye left, Insert should rotate eye
 //   right.  The eye direction vector is displayed in the upper left.



/// Problem 1

 // Modify the code below so that a pyramid (which will be called an
 // arrow) is displayed at each tube vertex, with the base at the
 // vertex and the apex pointing in the direction of the vertex normal
 // (or in the opposite direction it that's more visually
 // appealing).

 // [ ] The arrows should be rendered using GL_TRIANGLE_FAN.
 // [ ] The number of sides should be about opt_arrow_detail.
 // [ ] Make sure num_bytes is updated properly.
 // [ ] Use the MTrig class to re-use trigonometric function values.


/// Problem 2

 // In this problem modify the code so that the arrow is drawn in
 // different ways, depending on the value of opt_v_buffering and
 // opt_buffer_objects. For opt_v_buffering = 0, use a single call to
 // glMultiDrawArrays to send the arrow vertices; for opt_v_buffering
 // = 1 call glDrawArrays inside a loop, once for each tube
 // vertex. For opt_v_buffering = 2 use a transformation matrix to
 // position an arrow. That is, construct an arrow in some standard
 // location and orientation. Then send the same arrow over and over,
 // each time changing the MODELVIEW transformation so that the arrow
 // is correctly positioned.

 // [ ] If opt_v_buffering = 0, use glMultiDrawArrays (one call).
 // [ ] If opt_v_buffering = 1, use glDrawArrays (in a loop).
 // [ ] If opt_v_buffering = 2, change the transformation in a loop.

 // [ ] If opt_buffer_objects is true the arrow data should be in a buffer obj.
 // [ ] If opt_buffer_objects is false the arrow data should be send from cpu.

 // [ ] Do not re-compute data if opt_pause is true.
 // [ ] Store transformation matrices in an array and re-use when possible.
 // [ ] Do not re-compute or resend data when it is not necessary.

 // [ ] Make sure that num_bytes is updated correctly.


/// Problem 3

 /// Answer the following questions:

 // Under which circumstances does it make sense to use transformations
 // to move objects?

 // Provide an estimate for the overhead of changing transformations
 // and for the rate at which the GPU can render arrow primitives.

 /// To answer these questions:

 // - Run optimized versions of this code. (hw5, not hw5-debug).
 // - Vary Arrow Detail
 // - Consider performance with different opt_v_buffering options.
 // - Consider performance when paused and with and without buffer objects.
 // - Look at GPU time and CPU time.


 /// SOLUTION

 // Using transformation matrices has these potential benefits:

 // Reduce the amount of computation performed by the CPU. The host CPU
 // only needs to compute the transformation matrix, the GPU can then
 // apply it to each vertex in the arrow. The benefit depends on the GPU
 // speed and the number of vertices in the arrow.

 // Reduce the amount of data sent from the GPU to CPU. This benefit is
 // realized when buffer objects are used to hold an arrow, since only one
 // arrow needs to be sent. (If the arrow was sent from client memory
 // instead of a buffer object then it would have to be re-sent for every
 // tube normal, even though the same sets of vertex coordinates would be
 // sent for each tube normal.) This benefit is proportional to the number
 // of tube normals.

 // Reduce the size of the vertex arrays operated on. Even if client
 // memory is used for the arrow, the same arrow would be repeatedly
 // sent. The first time the arrow is sent it might need to be flushed
 // from the host CPU's cache, whereas without transformation matrices,
 // many arrows would have to be flushed from the host CPU cache.

 // Using transformation matrices can potentially slow execution because
 // of the time needed to compute the matrix, the time needed to transfer
 // the matrix, and the time needed for the GPU to install the matrix. If
 // the transformation matrix is computed by constructing and multiplying
 // a rotation and translation matrix then the amount of calculation will
 // be much larger than computing the position of each arrow vertex. The
 // size of the matrix, 16 floats, is about a quarter the size of 1
 // 10-sided arrow (about 66 floats), a significant fraction.

 // The data below show the results of running the program at two arrow
 // details: 10 (the default) and 96. The GPU times appearing below
 // include some CPU time (a problem discovered too late). At arrow detail
 // 10 with or without a buffer object the code runs slower when using a
 // transformation matrix. At arrow detail 96 things run a bit faster in
 // each configuration when using transformation matrices. The largest
 // benefit occurs when the arrow is not paused and buffer objects are in
 // use because of the reduction in data transfer. If the animation isn't
 // paused or if client arrays are used then transformation matrices don't
 // reduce the amount of data transfer.  The reduction seen in those
 // cases may have to do with repeatedly accessing the same arrow.

 // Data collected running this solution on a GeForce 8800 GT

 // P: Paused, R: Running
 // MDA: Use glMultiDrawArrays, DA, gl DrawArrays, T change transform.
 // BO: Buffer Object, CA Client array.

 // Note: GPU timing includes some cpu time.

 // Arrow detail: 96.4

 // GPU / CPU: P / MDA / CA:  15.9 / 3.91  131.5  ( 30 f/s)
 // GPU / CPU: P /  DA / CA:  16.0 / 4.09  131.5  ( 30 f/s)
 // GPU / CPU: P /  T  / CA:  14.8 / 4.0   269.6  ( 60 f/s)

 // GPU / CPU: P / MDA / BO:  15.9 / 0.74   7.6
 // GPU / CPU: P /  DA / BO:  16.0 / 0.88   7.6
 // GPU / CPU: P /  T  / BO:  15.0 / 2.42  21.6 ( 60 f/s)

 // GPU / CPU: R / MDA / CA:  18.0 /  7.2  132  ( 30 f/s)
 // GPU / CPU: R /  DA / CA:  18.0 /  7.3  132  ( 30 f/s)
 // GPU / CPU: R /  T  / CA:  16.2 /  6.3  135  ( 30 f/s)

 // GPU / CPU: R / MDA / BO:  22.0 /  6.8  152  ( 30 f/s)
 // GPU / CPU: R /  DA / BO:  22.4 /  6.9  152  ( 30 f/s)
 // GPU / CPU: R /  T  / BO:  17.6 /  4.91  11  ( 30 f/s)

 // Arrow detail: 10.0

 // GPU / CPU: P / MDA / CA:   1.8 /  1.1   52
 // GPU / CPU: P /  DA / CA:   1.8 /  1.1   52  ( 60 f/s)
 // GPU / CPU: P /  T  / CA:   2.2 /  2.5   58  ( 60 f/s)

 // GPU / CPU: R / MDA / CA:   2.4 /  1.6   51  ( 60 f/s)
 // GPU / CPU: R /  DA / CA:   2.4 /  1.6   51  ( 60 f/s)
 // GPU / CPU: R /  T  / CA:   4.8 /  5.0   57  ( 60 f/s)

 // GPU / CPU: R / MDA / BO:   2.4 /  1.5   58  ( 60 f/s)
 // GPU / CPU: R /  DA / BO:   2.6 /  1.6   58  ( 60 f/s)
 // GPU / CPU: R /  T  / BO:   4.7 /  4.9   21  ( 60 f/s)


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
    //  return func(theta);
    if ( !full ) { storage[idx] = func(theta);  full = idx == size - 1; }
    if ( idx == size ) idx = 0;
    return storage[idx++];
  }
  int size;
  float* storage;
  int idx;
  bool full;
};


struct Vertex_Info {
  pCoor pos;
  pVect nor;
};

 ///
 /// Tube Class
 ///

class Tube {
public:
  Tube(pOpenGL_Helper &fb):ogl_helper(fb){ init(); }
  static void render_w(void *moi){ ((Tube*)moi)->render(); }
  void init();
  void modelview_update();
  void render();
private:
  pOpenGL_Helper &ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  bool opt_move_light;
  bool opt_pause;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  int opt_v_buffering;
  bool opt_buffer_objects;      // If true use buffer objects for arrow.
  float opt_arrow_detail;  // It's a float so it can work with variable_control.

  // Some items that might be needed for solution.
  //
  Vertex_Info *arrow_info;
  pMatrix *arrow_transforms;
  GLuint arrow_info_buffer;

  // SOLUTION
  //
  int arrow_detail_alloc;
  int *arrow_count, *arrow_first;
  int arrow_vtx_count;
  int arrow_vtx;
  int arrow_info_v_opt;
  bool arrow_info_stale;
  bool arrow_buffer_stale;
  Vertex_Info tube_0;

  float opt_light_intensity;
  pCoor opt_light_location;

  double time_app_start;

  Vertex_Info *tube_info;
  int *index_array;

  int num_vtx_alloc;
  int num_indices;
  MTrig tarray;
  MTrig tarray_arrow;  // Might be needed for solution.

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

  opt_pattern_levels = 30;    // Tube depth (z direction.)
  opt_pattern_width = 60;     // Triangle size (circumferential).

  // Amount of Detail in Arrow (Showing Normal Direction)
  //
  // The solution can have a different initial value.
  //
  opt_arrow_detail = 10;

  // SOLUTION
  //
  arrow_detail_alloc = 0;  // Size of pre-computed arrow. (0 means none)
  arrow_info = NULL;
  arrow_info_stale = true;
  arrow_buffer_stale = true;
  glGenBuffers(1,&arrow_info_buffer);
  tube_0.pos = pCoor(0,0,0);
  tube_0.nor = pCoor(0,1,0);

  opt_light_intensity = 8;
  opt_v_buffering = 0;
  opt_buffer_objects = false;
  opt_light_location.set(1.3,0.1,-1.4);
  opt_pause = false;

  eye_location.set(0,0,2.5);
  eye_direction.set(0,0,-1);
  modelview_update();

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_arrow_detail,"Arrow Detail");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_pattern_width,"Vertices per Ring");

  tube_info = NULL;

  index_array = 0;
  num_vtx_alloc = 0;
  num_indices = 0;

}

void
Tube::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}

void
Tube::render()
{
  frame_timer.frame_start();
  const int arrow_detail = int(opt_arrow_detail);  // Cast to integer.

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
  glLoadTransposeMatrixf(modelview);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-0.8,+0.8,-0.8/aspect,0.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();


  ///
  /// Adjust options based on user input.
  ///

  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -0.1; break;
  case FB_KEY_RIGHT: adjustment.x = 0.1; break;
  case FB_KEY_UP: adjustment.z = -0.1; break;
  case FB_KEY_DOWN: adjustment.z = 0.1; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -0.1; break;
  case FB_KEY_PAGE_UP: adjustment.y = 0.1; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case 'b': case 'B': opt_buffer_objects = !opt_buffer_objects; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'l': case 'L': opt_move_light = true; break;
  case 'e': case 'E': opt_move_light = false; break;
  case 'v': case 'V':
    opt_v_buffering++;
    if ( opt_v_buffering == 3 ) opt_v_buffering = 0;
    break;

  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;

  default: break;
  }

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(pVect(0,0,-1),eye_direction);
      user_rot_axis *= rotall;
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
      if ( opt_move_light ) opt_light_location += adjustment;
      else                  eye_location += adjustment;
      modelview_update();
    }

  //
  // User Messages  (Magically inserted into frame buffer.)
  //

  ogl_helper.fbprintf
    ("Eye location: [%.1f, %.1f, %.1f]  "
     "(%suse arrow and page keys to move).\n",
     eye_location.x, eye_location.y, eye_location.z,
     opt_move_light ? "press 'e' then " : "" );

  ogl_helper.fbprintf
    ("Light location: [%.1f, %.1f, %.1f]  "
     "(%suse arrow and page keys to move).\n",
     opt_light_location.x, opt_light_location.y, opt_light_location.z,
     opt_move_light ? "" : "press 'l' then ");

  ogl_helper.fbprintf
    ("Eye direction: [%.2f, %.2f, %.2f]  "
     "(use 'Home', 'End', 'Del', 'Insert' keys to turn).\n",
     eye_direction.x, eye_direction.y, eye_direction.z);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glLightfv(GL_LIGHT0, GL_POSITION, opt_light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};
  const float light_dim[4] = {0.1,0.1,0.1,1};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_dim[0]);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
  glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  const char* const v_buffering_str[] =
    { "Send transformed arrows using glMultiDrawArrays",
      "Send transformed arrows using glDrawArrays",
      "Send same arrow, change transforms" };

  ogl_helper.fbprintf
    ("Vertex specification:  %s  (v to change)\n",
     v_buffering_str[opt_v_buffering]);
  ogl_helper.fbprintf
    ("Arrow data provided from %s\n",
     opt_buffer_objects ? "buffer objects" : "client arrays");
  if ( opt_pause )
    ogl_helper.fbprintf("** PAUSED ** (Press 'p' to unpause.)\n");
  else
    ogl_helper.fbprintf("Press 'p' to pause.\n");
  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.3f\n",cvar->name,cvar->var[0]);

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(opt_light_location,0.05);

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold

  //
  // Get Tube Specifications
  //

  const float ampl = 0.1;
  const int pattern_width = 3 * int( opt_pattern_width * 0.33333333 );
  const int pattern_levels = int( opt_pattern_levels + 0.5 );
  const int num_vtx = pattern_levels * pattern_width;

  const double cycles_per_second = 0.2;
  const double phase_n =
    ( time_wall_fp() - time_app_start ) * cycles_per_second;
  const double phase = phase_n * 2.0 * M_PI;
  const float wavelength_z = 4.8;
  const float radians_per_z = 2.0 * M_PI / wavelength_z;

  int num_bytes = 0;

  glEnable(GL_NORMALIZE);
  glEnable(GL_RESCALE_NORMAL);

  // If number of vertices has changed re-allocate our storage
  // (coor_buffer, norm_buffer) and MTrig object.
  //
  if ( num_vtx_alloc != num_vtx )
    {
      if ( tube_info )
        {
          delete tube_info;
          delete index_array;  index_array = NULL;
        }
      tube_info = new Vertex_Info[num_vtx];
      tarray.init( pattern_width * 2 * 2 );
      num_vtx_alloc = num_vtx;
    }

  // Outer Loop: z axis (down axis of tube).
  //
  if ( !opt_pause )
    {
      Vertex_Info *vip = tube_info;
      const float ep = 1.00001;
      const float two_pi = 2 * M_PI;
      const float delta_theta = ep * two_pi / pattern_width;
      const float delta_theta_half = 0.5 * delta_theta;

      for ( int i = 0; i < pattern_levels; i++ )
        {
          const float angle_z = phase + radians_per_z * z;
          const float cos_z = cos(angle_z);
          const float theta_0 = i & 1 ? delta_theta_half : 0;
          const float r = r0 * ( 1 + ampl * sin( angle_z ) );

          for ( float theta = theta_0;  theta < two_pi;
                theta += delta_theta )
            {
              const float cos_theta = tarray.cos(theta);
              const float sin_theta = tarray.sin(theta);

              Vertex_Info* const vi = vip++;

              vi->pos = pCoor(x_shift + r * cos_theta, r * sin_theta, z);
              vi->nor = pVect(-cos_theta,-sin_theta,cos_z);
            }

          z -= pattern_pitch_z;
        }
    }

  if ( !index_array )
    {
      index_array = new int[num_vtx*6];
      int *iptr = index_array;
      for ( int i = 0; i < pattern_levels - 1; i++ )
        {
          int vtx_a = pattern_width * ( i & 1 ? i + 1 : i );
          int vtx_b = pattern_width * ( i & 1 ? i : i + 1 );
          int *irevptr = iptr;

          for ( int j = 0; j < pattern_width; j++ )
            {
              const bool last = j == pattern_width - 1;
              *iptr++ = vtx_a;  *iptr++ = vtx_b;
              vtx_a++;  if ( last ) vtx_a -= pattern_width;
              *iptr++ = vtx_a;
              *iptr++ = vtx_a;  *iptr++ = vtx_b;
              vtx_b++;  if ( last ) vtx_b -= pattern_width;
              *iptr++ = vtx_b;
            }
          if ( i & 1 ) continue;

          // Flip these triangles so all have normals in same direction.
          //
          while ( irevptr < iptr )
            {
              const int t = irevptr[0];
              irevptr[0] = irevptr[2];  irevptr[2] = t;
              irevptr += 3;
            }
        }
      num_indices = iptr - index_array;
    }
  pError_Check();

  // Render Tube
  //
  glColor3fv( color_gold );
  glNormalPointer(GL_FLOAT,sizeof(Vertex_Info),&tube_info[0].nor);
  glVertexPointer(3,GL_FLOAT,sizeof(Vertex_Info),&tube_info[0].pos);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawElements(GL_TRIANGLES,num_indices,GL_UNSIGNED_INT,index_array);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  pError_Check();
  num_bytes += ( sizeof(float) * 6 ) * num_indices;


  /// SOLUTION BELOW
  //
  const bool per_arrow_transform = opt_v_buffering == 2;
  const double two_pi = 2 * M_PI;
  const int sides = 3 + arrow_detail;
  const float length = 0.5 * r0;
  const float base_radius = 0.1 * r0 / two_pi;
  const double delta_theta = 0.99999 * two_pi / sides;
  glColor3fv(color_purple);

  // Allocate or Re-allocate Arrow Storage, if necessary.
  //
  if ( arrow_detail != arrow_detail_alloc || arrow_vtx != num_vtx )
    {
      tarray_arrow.init( 2 * ( sides + 1 ) );
      arrow_detail_alloc = arrow_detail;
      if ( arrow_info )
        {
          free(arrow_info); free(arrow_count); free(arrow_first);
          free(arrow_transforms);
        }
      arrow_vtx_count = num_vtx * ( sides + 2 );
      arrow_info = new Vertex_Info[ arrow_vtx_count ];
      arrow_first = new int[num_vtx];
      arrow_count = new int[num_vtx];
      arrow_transforms = new pMatrix[num_vtx];
      arrow_info_stale = true;
      arrow_vtx = num_vtx;
    }

  // Update array of arrows, if necessary.
  //
  if ( !opt_pause
       || arrow_info_stale
       || arrow_buffer_stale && opt_buffer_objects
       || arrow_info_v_opt != opt_v_buffering )
    {
      Vertex_Info *aiptr = arrow_info;
      arrow_info_stale = false;
      arrow_info_v_opt = opt_v_buffering;
      const int n_vtx = per_arrow_transform ? 1 : num_vtx;
      for ( int i=0; i<n_vtx; i++ )
        {
          Vertex_Info* const vi =
            per_arrow_transform ? &tube_0 : &tube_info[i];
          pCoor base = vi->pos;
          pCoor pointy_part = base + length * vi->nor;
          pVect rad(vi->nor,pVect(0,0,1));
          pVect rad2(vi->nor,rad);
          rad.normalize(); rad *= base_radius;
          rad2.normalize(); rad2 *= base_radius;
          arrow_count[i] = sides + 2;
          arrow_first[i] = aiptr - arrow_info;
          aiptr->nor = vi->nor;
          aiptr->pos = pointy_part;
          aiptr++;
          for ( double theta = 0; theta <= two_pi; theta += delta_theta )
            {
              const float cos_theta = tarray_arrow.cos(theta);
              const float sin_theta = tarray_arrow.sin(theta);
              pVect cone_normal = cos_theta * rad + sin_theta * rad2;
              pCoor c = base + cone_normal;
              aiptr->nor = cone_normal;  // Needs a z-axis component.
              aiptr->pos = c;
              aiptr++;
            }
        }

      if ( per_arrow_transform )
        for ( int i=0; i<num_vtx; i++ )
          {
            Vertex_Info* const vi = &tube_info[i];
            pMatrix_Rotation r(pVect(0,1,0),vi->nor);
            pMatrix_Translate t(vi->pos);
            arrow_transforms[i] = modelview * t * r;
          }

      if ( opt_buffer_objects )
        {
          const int amt = n_vtx * ( sides + 2 ) * sizeof(Vertex_Info);
          glBindBuffer(GL_ARRAY_BUFFER, arrow_info_buffer);
          glBufferData(GL_ARRAY_BUFFER, amt, arrow_info, GL_STATIC_DRAW);
          glBindBuffer(GL_ARRAY_BUFFER, 0);
          num_bytes += amt;
        }
      arrow_buffer_stale = !opt_buffer_objects;
    }

  Vertex_Info* const ai_ptr = opt_buffer_objects ? NULL : arrow_info;

  if ( opt_buffer_objects )
    glBindBuffer(GL_ARRAY_BUFFER, arrow_info_buffer);

  glNormalPointer(GL_FLOAT,sizeof(Vertex_Info),&ai_ptr[0].nor);
  glVertexPointer(3,GL_FLOAT,sizeof(Vertex_Info),&ai_ptr[0].pos);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);

  // arrow_first (arrow array index) and arrow_count (number of vertices).
  //
  num_bytes += ( sizeof(int) * 2 ) * num_vtx;

  // Vertex and normal data.
  //
  if ( !opt_buffer_objects )
    num_bytes += ( sizeof(float) * 6 ) * arrow_vtx_count;

  switch ( opt_v_buffering ) {
  case 0:
    glMultiDrawArrays(GL_TRIANGLE_FAN,arrow_first,arrow_count,num_vtx);
    break;

  case 1:
    glMatrixMode(GL_MODELVIEW);
    for ( int i=0; i<num_vtx; i++ )
      glDrawArrays(GL_TRIANGLE_FAN,arrow_first[i],arrow_count[i]);
    break;

  case 2:
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    for ( int i=0; i<num_vtx; i++ )
      {
        glLoadTransposeMatrixf(arrow_transforms[i]);
        glDrawArrays(GL_TRIANGLE_FAN,arrow_first[0],arrow_count[0]);
      }
    glPopMatrix();
    num_bytes += ( sizeof(float) * 16 ) * num_vtx;
    break;

  default: pError_Msg("Unexpected case.");
  }

  glBindBuffer(GL_ARRAY_BUFFER, 0);

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  pError_Check();
  //
  /// SOLUTION ABOVE

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
