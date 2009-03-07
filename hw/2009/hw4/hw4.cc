/// LSU EE 7700-1 (Sp 2009), Graphics Processors
//
/// Homework 4

 /// Due: Thursday,  12 March 2009
 //  E-mail this file (with solution).

 //  Note: Homework 5 will be due the following Monday.

 /// Name:

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
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/2009/hw4
//
//  The assignment instructions are in file hw4.cc. (This file.)

// For the solutions to the problems below edit this file, even if
// it makes more sense to edit others (namely, coord.h). If it seems
// that coord.h must be edited, contact me.

// The main code is in routine Tube::render().


/// Overview

 //  This file renders the undulating tube using glDrawElements,
 //  with coordinates, normals, and the index (element) array all on
 //  the CPU.  In problem 1 move the index array to the gpu, in
 //  problem 2 move coordinates, normals to the gpu as well.

///  Keyboard Commands
 //
 //  'v'  Switch location of vertex data used by glDrawElements.
 //       0:  Index, coordinates, and normals all on CPU.
 //       1:  [When problem 1 solved.] Index on GPU, coord & norm on CPU.
 //       2:  [When problem 2 solved.] Index, coord, & norm on GPU.
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


/// Problem 0

// Fill in your name in the comment near the top of this file, then
// build and run the program. It should display a tube similar to the
// one seen in class. Try out the keyboard commands described below
// and promptly resolve any problems, feel free to ask for help from
// Dr. Koppelman or others, especially on issues of missing libraries,
// and other setup problems.

 // [ ]  Name placed at top of this file.
 // [ ]  Code compiles and runs.
 // [ ]  Had fun moving through the tube.


/// Problem 1

 //  Modify the code below so that when opt_v_buffering == 1
 //  the glDrawElements command uses an element (index) array located on
 //  the gpu.  The index array should only be updated when necessary.

 //  [ ]  Have glDrawElements use a gpu-located element array.
 //  [ ]  Increment num_bytes by the amount of data that should be transferred.


/// Problem 2

 //  Modify the code below so that when opt_v_buffering == 2
 //  the the index array, normal array, and coordinate array
 //  used by glDrawElements command are all on the gpu.  The
 //  respective arrays should be moved to the gpu only when
 //  necessary. (For example, it is not necessary to move data
 //  to the gpu if it already has that data.)  Note that the
 //  cpu code reads the same array (vertex_info) twice, once for
 //  coordinates and once for normals.  It is okay to do the same
 //  for the gpu-located data.

 //  [ ]  Have glDrawElements use gpu-located element, coor, and normal arrays.
 //  [ ]  Increment num_bytes by the amount of data that should be transferred.


/// Problem 3

 //  Consider the difference between cpu-located information
 //  (opt_v_buffering == 0) and gpu-located information
 //  (opt_v_buffering==2). When answering the question below look at
 //  performance both in paused and unpaused mode, where performance
 //  includes GPU and CPU time and % utilization. Note that the
 //  transfer rate (MB/s) is something we estimate, while the GPU and
 //  CPU time and % utilization is something that is directly
 //  measured.

 //  Is the change in CPU usage more, less, or equal to what one might
 //  expect given the change in the transfer rate? Explain your
 //  answer.

 //  Is the change in GPU usage more, less, or equal to what one
 //  might expect from the change in transfer rate? Explain.


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

  float opt_light_intensity;
  int opt_v_buffering;
  pCoor opt_light_location;

  double time_app_start;

  Vertex_Info *vertex_info;
  int *index_array;

  int num_vtx_alloc;
  int num_indices;
  MTrig tarray;

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

  opt_pattern_levels = 100;    // Tube depth (z direction.)
  opt_pattern_width = 80;     // Triangle size (circumferential).

  opt_light_intensity = 2;
  opt_v_buffering = 0;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );
  opt_pause = false;

  eye_location.set(0,0,2.5);
  eye_direction.set(0,0,-1);
  modelview_update();

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_pattern_levels,"Pattern Levels");

  vertex_info = NULL;
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


  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,0);
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
    { "Client Data & Indices", "Client Data, GPU Indices",
      "GPU Data & Indices" };

  ogl_helper.fbprintf
    ("Vertex specification:  %s  (v to change)\n",
     v_buffering_str[opt_v_buffering]);
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

  //
  // Insert a tessellated tube in the vertex list.
  //

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold


  //
  // Get Tube Specifications
  //

  const float ampl = 0.2;
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
  // (coor_buffer, norm_buffer) and MTrig object and also remember
  // that gpu's buffer needs to be updated.

  if ( num_vtx_alloc != num_vtx )
    {
      if ( vertex_info )
        {
          delete vertex_info;
          delete index_array;  index_array = NULL;
        }
      vertex_info = new Vertex_Info[num_vtx];
      tarray.init( pattern_width * 2 * 2 );
      num_vtx_alloc = num_vtx;
    }

  // Outer Loop: z axis (down axis of tube).
  //
  if ( !opt_pause )
    {
      Vertex_Info *vip = vertex_info;
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

          for ( int j = 0; j < pattern_width; j++ )
            {
              const bool last = j == pattern_width - 1;
              *iptr++ = vtx_a;  *iptr++ = vtx_b;
              vtx_a++;  if ( last ) vtx_a -= pattern_width;
              *iptr++ = vtx_a;  *iptr++ = vtx_a;  *iptr++ = vtx_b;
              vtx_b++;  if ( last ) vtx_b -= pattern_width;
              *iptr++ = vtx_b;
            }
        }
      num_indices = iptr - index_array;

    }
  pError_Check();

  glColor3fv( color_gold );

  switch ( opt_v_buffering ) {
  case 0:
    glNormalPointer(GL_FLOAT,sizeof(Vertex_Info),&vertex_info[0].nor);
    glVertexPointer(3,GL_FLOAT,sizeof(Vertex_Info),&vertex_info[0].pos);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawElements(GL_TRIANGLES,num_indices,GL_UNSIGNED_INT,index_array);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_VERTEX_ARRAY);
    pError_Check();
    num_bytes += ( sizeof(float) * 6 + sizeof(int) ) * num_indices;
    break;

  case 1:
    // Problem 1 solution here (and other places).
    break;

  case 2:
    // Problem 2 solution here (and other places).
    break;

  default: pError_Msg("Unexpected case.");
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
