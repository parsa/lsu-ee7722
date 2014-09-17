/// LSU EE 4702-1 (Fall 2014), GPU Programming
//
 /// Simple Demo of OpenGL

// $Id:$

/// Purpose
//
//   Demonstrate simple opengl.


/// What Code Does

// Shows a sphere and a triangle.

#if 0
/// Background
//

 /// References
//
// :ogl45: OpenGL Specification Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf

 /// Coordinate Spaces
//
//  :ogl45: Section 12.1 - Coordinate space descriptions.
//
//  :Def: Object Space
//        Coordinate space of user's choosing.
//        E.g., Flight Simulator: y is feet, x and z are nautical miles.
//              
//  :Def: Eye Space
//        User's eye at origin, monitor facing -z.
//
//  :Def: Clip Space
//        Visible space inside a cube with corners (-1,-1,-1) and (1,1,1)


 /// Transformation Matrices
//
//   :ogl45: Section 12.1.1
//
//   Some Important Transformations:
//
//     :Def: Model View
//           Transform from object to eye space.
//
//     :Def: Projection
//           Transform from eye to clip.

//   Setting Matrices
//
//  -- First, specify which matrix:
//
        glMatrixMode( matrix-name );
//
//       where matrix-name can be
//
       glMatrixMode( GL_MODELVIEW );
       glMatrixMode( GL_PROJECTION );
//
//      See Section 12.1.1 for the full list.

//  -- Second, modify the matrix using a variety of commands.
//     See Section 12.1.1 for the full list.
//
       // Load the entire matrix
       //
       glLoadMatrixf( my_matrix_a );
       //
       // Before: transform = some_matrix_x.
       // After:  transform = my_matrix_a.

       // Load an identity matrix.
       //
       glLoadIdentity();
       //
       // Before: transform = some_matrix_x.
       // After:  transform = Identity.

       // Multiply the current transform by a new matrix.
       //
       glMultMatrixf( my_matrix_b );
       //
       // Before: transform = my_matrix_a.
       // After: transform = my_matrix_a * my_matrix_b.

       // Multiply current transform by a right-hand rotation.
       //
       glRotatef( angle_deg, axis_x, axis_y, axis_z );

       // Multiply current transform by a translation.
       //
       glTranslatef( tran_x, tran_y, tran_z );

       // Multiply current transform by a translation.
       //
       glScalef( s_x, s_y, s_z );

       // Multiply current transform by a perspective (frustum) projection.
       //
       glFrustum( left, right, bottom, top, near, far );

//  -- Third, leave things the way they were.
//
//       Often a transformation change is temporary, and after you're
//       done you'd like to put things back the way they were.
//
//       In such cases use push and pop:
//
       // Make a copy of the current matrix and push it on the stack.
       //
       glPushMatrix();

       // Replace the current matrix with the top of stack, and pop stack.
       //
       glPopMatrix();


 /// Depth Test (z-Buffering)
//
//   :ogl45: Section 17.3.6
//



#endif


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //
 /// Eye Direction
 //   Home, End, Delete, Insert
 //   Turn the eye direction.
 //   Home should rotate eye direction up, End should rotate eye
 //   down, Delete should rotate eye left, Insert should rotate eye
 //   right.  The eye direction vector is displayed in the upper left.

 /// Simulation Options
 //  (Also see variables below.)
 //
 //  'p'    Pause simulation. (Press again to resume.)
 //  'F12'  Write screenshot to file.

 /// Variables
 //   Selected program variables can be modified using the keyboard.
 //   Use "Tab" to cycle through the variable to be modified, the
 //   name of the variable is displayed next to "VAR" on the bottom
 //   line of green text.

 //  'Tab' Cycle to next variable.
 //  '`'   Cycle to previous variable.
 //  '+'   Increase variable value.
 //  '-'   Decrease variable value.
 //
 //  VAR Light Intensity - The light intensity.


#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

// Include files provided for this course.
//
#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include "shapes.h"


class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void cb_keyboard();
  void modelview_update();

  // Class providing utilities, such as showing text.
  //
  pOpenGL_Helper& ogl_helper;

  // Class for easy keyboard control of variables.
  //
  pVariable_Control variable_control;

  // Class for showing frame timing.
  //
  pFrame_Timer frame_timer;

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  int slices; // Level of detail for sphere.
  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");

  eye_location = pCoor(1,0.5,3);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(6.6,4.0,0.5);

  sphere_location = pCoor(0,0,0);
  sphere_size = 1;

  slices = 20;
  variable_control.insert(slices,"Slices in Sphere");

  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(sphere_size,"Sphere Size");

  opt_move_item = MI_Eye;

  modelview_update();
}

void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}


void
World::render()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

  // Reset Frame Buffer
  //
  glClearColor(0,0,0,0);  // Set clear color to black.
  glClearDepth(1.0);      // Set clear distance to all-the-way-back.
  // Use current clear settings to rest frame buffer.
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  // Turn on Depth Test ( z-buffer test ).
  //
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);     // FB written if z value to write < current z.

  glShadeModel(GL_SMOOTH);

  /// Lighting Setup
  //
  //  Covered in detail in demo-6.
  //
  //  Here, just pay attention to light_location.

  
  glEnable(GL_LIGHTING);        // Turn on lighting.
  glEnable(GL_LIGHT0);          // Turn on light number one.

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);

  // Specify location of light number one.
  //
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);


  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());


  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  // Note: This code does not account for eye direction.
  glTranslatef(-eye_location.x,-eye_location.y,-eye_location.z);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);



  ///
  /// Paint Single Triangle.
  ///

  glColor3ub( 0x78, 0x8d, 0xf6); // Red, Green, Blue

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  /// Specify normal for triangle.
  //
  // Use cross product function (in coord.h) to find normal.
  //
  pNorm tri_norm = cross(pVect(0,5,-5),pVect(9,6,-0));
  glNormal3fv(tri_norm);  // Set current normal.
  // Note: pNorm, pVect, pCoor, and pColor objects can be used as
  // arguments to OpenGL functions with names ending in 3fv.

  // Specify vertices for a triangle.
  //
  glVertex3f( 0, 0, 0 );
  glVertex3f( 0,   5, -5 );
  glVertex3f( 9,   6, -9 );

  glEnd();


  ///
  /// Paint a Sphere
  ///


  // In sphere's coordinate space the sphere center is at the origin
  // and its radius is one. Therefore we need to adjust the modelview
  // matrix so that sphere is at the value of coordinate
  // sphere_location and its radius is sphere_size.
  //
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glTranslatef(sphere_location.x,sphere_location.y,sphere_location.z);
  glScalef(sphere_size,sphere_size,sphere_size);

  // Construct color objects using hex RGB codes. See coord.h.
  //
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);

  /// Start Sending Triangles
  //
  //  OpenGL state is now set up, start sending triangles!

  glBegin(GL_TRIANGLES);

  // Set current color.  This is carried with vertex.
  //
  glColor3fv(lsu_spirit_gold);

  const double delta_eta = M_PI / slices;

  // Outer (eta) Loop: Iterate over longitude (north-to-south).
  // Inner (theta) Loop: Iterate over latitude (east-to-west)

  for ( double eta0 = 0; eta0 < M_PI - 0.0001 - delta_eta; eta0 += delta_eta )
    {
      const double eta1 = eta0 + delta_eta;
      const float  y0 = cos(eta0),        y1 = cos(eta1);
      const double slice_r0 = sin(eta0),  slice_r1 = sin(eta1);
      const double delta_theta = delta_eta * slice_r1;

      for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
        {
          const double theta1 = theta + delta_theta;

          /// Triangle 1

          // Vertex 1
          glNormal3f( slice_r1 * cos(theta), y1, slice_r1 * sin(theta) );
          glVertex3f( slice_r1 * cos(theta), y1, slice_r1 * sin(theta) );

          // Vertex 2
          glNormal3f( slice_r0 * cos(theta), y0, slice_r0 * sin(theta) );
          glVertex3f( slice_r0 * cos(theta), y0, slice_r0 * sin(theta) );

          // Vertex 3      
          glNormal3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );
          glVertex3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );

          /// Triangle 2

          // Vertex 3      
          glNormal3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );
          glVertex3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );

          // Vertex 2
          glNormal3f( slice_r0 * cos(theta), y0, slice_r0 * sin(theta) );
          glVertex3f( slice_r0 * cos(theta), y0, slice_r0 * sin(theta) );

          // Vertex 4
          glNormal3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );
          glVertex3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );

        }
    }

  glEnd();

  /// Efficiency of Code Tesselation (Above)
  //
  //  The code is inefficient for the following reasons:
  //
  //  * Trigonometric functions are re-computed.  The compiler may
  //    realize that two nearby calls of sin(theta) will return the
  //    same value, but don't bet on it.  Even so, they at least need
  //    to be re-computed each frame. Instead the trig values (or better
  //    the coordinates) should be saved in an array and re-used, only
  //    to be recomputed if necessary, for example, if slices changes.
  //
  //  * There are vertices of six triangles at a single point (three
  //    along one slice). It would be more efficient to compute and
  //    emit a vertex once and share it. In demo-6 this is done using
  //    the triangle strip feature.
  //
  //  * Even if vertex and normal coordinates were pre-computed, there
  //    would still be substantial overhead in the individual function
  //    calls (glVertex3f, glNormal3f).  To avoid this the OpenGL
  //    vertex array feature is used.  This is done in demo-7.
  //
  //  * Even if vertices and normals are provided in arrays, they still
  //    need to be sent from CPU to GPU each frame, even if there
  //    is no change. To avoid this they can be stored on the GPU,
  //    this is done using the OpenGL buffer objects feature. The
  //    code in demo-7 uses buffer objects.
  //
  //  * Setting slices too low results in a sphere that looks like
  //    a polyhedron, but setting it too high wastes CPU time.  The
  //    appropriate value depends on the distance from the user.
  //    With a geometry shader the CPU code can generate a sphere
  //    with only a few slices, while the geometry shader code, which
  //    runs on the GPU, can replace big triangles with multiple smaller
  //    ones if the triangles are large in window space.  None of
  //    the demos do that yet.

  glPopMatrix();

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  glDisable(GL_LIGHTING);
  glDisable(GL_DEPTH_TEST);
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
  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
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
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      case MI_Ball: sphere_location += adjustment; break;
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

  // Specify default frame update rate.
  //
  // Default rate used if API won't allow updating on each
  // display device frame.
  //
  popengl_helper.rate_set(30);

  // Start
  //
  popengl_helper.display_cb_set(world.render_w,&world);
}
