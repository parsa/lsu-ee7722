/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 /// Homework 2
 //
 //  Note: this file based on demo-5-more-ogl.cc

 /// Simple Demo of OpenGL

/// Purpose
//
//   Demonstrate simple opengl.


/// What Code Does

// Shows a sphere and a triangle.



///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   's': Move construction markers. (Show eta, theta)
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

#include <GL/gl.h>
#include <GL/freeglut.h>

// Include files provided for this course.
//
#include <gp/util.h>
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

  // Class providing utilities, such as showing text.
  //
  pOpenGL_Helper& ogl_helper;

  // Class for easy keyboard control of variables.
  //
  pVariable_Control variable_control;

  // Class for showing frame timing.
  //
  pFrame_Timer frame_timer;

  bool opt_tryout1, opt_tryout2;

  bool opt_show_lines; // Set normal to triangle normal.

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Slice, MI_COUNT } opt_move_item;

  int slices; // Level of detail for sphere.
  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  /// Homework 2

  bool opt_show;
  float show_delta_eta_seen, show_delta_theta_seen;
  int opt_change_theta, opt_change_eta;
  float opt_show_theta, opt_show_eta;

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

  opt_show_lines = false;

  opt_show = true;
  opt_change_eta = 0;
  opt_change_theta = 0;
  opt_show_theta = 0.8;
  show_delta_theta_seen = -1;
  opt_show_eta = 1.73;
  show_delta_eta_seen = -1;

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

  /// Reset Frame Buffer
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


  /// Frame Buffer Informational Messages
  //
  //  Print messages using utility functions provided for this course.
  //

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z);

  ogl_helper.fbprintf
    ("HW02: Show slice: %3s ('c' to toggle)  "
     "Show eta: %5.3f,  theta: %5.3f (%sarrows to change)\n",
     opt_show ? "ON " : "OFF",
     opt_show_eta, opt_show_theta,
     opt_move_item != MI_Slice ? "'s' then " : "");

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());


  // -------------------------------------------------------------------------
  ///
  /// Specification of Transformation Matrices
  ///

  /// Setup Modelview Transformation:  Object Space -> Eye Space
  //
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  // Note: This code does not account for eye direction.
  glTranslatef(-eye_location.x,-eye_location.y,-eye_location.z);

  /// Setup Projection Transformation:  Eye Space -> Clip Space
  //
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  /// Viewport Transformation
  //
  //  This is not set explicitly under ordinary circumstances.
  //  The transformation is automatically set based on the window size.

  //
  // -------------------------------------------------------------------------


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

  // Construct color objects using hex RGB codes. See coord.h and colors.h.
  //
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);
  const pColor color_red(0xaa0000);

  /// Start Sending Triangles
  //
  //  OpenGL state is now set up, start sending triangles!

  glBegin(opt_show_lines ? GL_LINE_STRIP : GL_TRIANGLES);


  const float delta_eta = M_PI / slices;
  const int slice_max = slices - 2;

  if ( opt_change_eta || delta_eta != show_delta_eta_seen )
    {
      const int prev_slice = opt_show_eta / delta_eta + 0.5;
      const int targ_slice = prev_slice + opt_change_eta;
      const int slice =
        targ_slice < 0 ? slice_max : targ_slice > slice_max ? 0 : targ_slice;
      opt_show_eta = slice * delta_eta;
      opt_change_eta = 0;
      show_delta_eta_seen = delta_eta;
    }

  // Outer (slice,eta)  Loop: Iterate over longitude (north-to-south).
  // Inner (segs,theta) Loop: Iterate over latitude (east-to-west)

  for ( int slice = 0; slice < slices - 1; slice++ )
    {
      const float eta0 = slice * delta_eta;
      const float eta1 = eta0 + delta_eta;
      const float y0 = cosf(eta0),        y1 = cosf(eta1);
      const float slice_r0 = sinf(eta0),  slice_r1 = sinf(eta1);
      const int segs = max(3, int( 2 * slices * max(slice_r0,slice_r1) ) );
      const float delta_theta = 2 * M_PI / segs;
      const bool show_eta = eta0 == opt_show_eta;
      pColor slice_color = show_eta ? lsu_spirit_purple : lsu_spirit_gold;

      if ( show_eta &&
           ( opt_change_theta || delta_theta != show_delta_theta_seen ) )
        {
          const int prev_slice = opt_show_theta / delta_theta + 0.5;
          const int seg = ( segs + prev_slice + opt_change_theta ) % segs;
          opt_show_theta = seg * delta_theta;
          opt_change_theta = 0;
          show_delta_theta_seen = delta_theta;
        }

      for ( int seg = 0; seg < segs; seg++ )
        {
          const float theta0 = seg * delta_theta;
          const float theta1 = theta0 + delta_theta;

          const bool show_theta = show_eta && theta0 == opt_show_theta;
          glColor3fv( show_theta ? color_red : slice_color );

          /// Triangle 1

          // Vertex 1
          glNormal3f( slice_r1 * cosf(theta0), y1, slice_r1 * sinf(theta0) );
          glVertex3f( slice_r1 * cosf(theta0), y1, slice_r1 * sinf(theta0) );

          // Vertex 2
          glNormal3f( slice_r0 * cosf(theta0), y0, slice_r0 * sinf(theta0) );
          glVertex3f( slice_r0 * cosf(theta0), y0, slice_r0 * sinf(theta0) );

          // Vertex 3      
          glNormal3f( slice_r1 * cosf(theta1), y1, slice_r1 * sinf(theta1) );
          glVertex3f( slice_r1 * cosf(theta1), y1, slice_r1 * sinf(theta1) );

          /// Triangle 2

          // Vertex 3      
          glNormal3f( slice_r1 * cosf(theta1), y1, slice_r1 * sinf(theta1) );
          glVertex3f( slice_r1 * cosf(theta1), y1, slice_r1 * sinf(theta1) );

          // Vertex 2
          glNormal3f( slice_r0 * cosf(theta0), y0, slice_r0 * sinf(theta0) );
          glVertex3f( slice_r0 * cosf(theta0), y0, slice_r0 * sinf(theta0) );

          // Vertex 4
          glNormal3f( slice_r0 * cosf(theta1), y0, slice_r0 * sinf(theta1) );
          glVertex3f( slice_r0 * cosf(theta1), y0, slice_r0 * sinf(theta1) );

        }
    }

  glEnd();

  glPopMatrix();

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  frame_timer.frame_end();
  ogl_helper.user_text_reprint();
  glutSwapBuffers();
}



void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const bool kb_mod_s = ogl_helper.keyboard_shift;
  const bool kb_mod_c = ogl_helper.keyboard_control;
  const float move_amt = kb_mod_s ? 2.0 : kb_mod_c ? 0.08 : 0.4;

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
  case 'c': case 'C': opt_show = !opt_show; break;
  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 's': case 'S': opt_move_item = MI_Slice; break;
  case 'n': opt_show_lines = !opt_show_lines; break;
  case 'y': opt_tryout1 = !opt_tryout1; break;
  case 'Y': opt_tryout2 = !opt_tryout2; break;
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
    }

  // Update eye_location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      pVect radjustment = rotall * adjustment;

      switch ( opt_move_item ){
      case MI_Light: light_location += radjustment; break;
      case MI_Eye: eye_location += radjustment; break;
      case MI_Ball: sphere_location += radjustment; break;
      case MI_Slice:
        if ( adjustment.x )
          opt_change_theta = adjustment.x < 0 ? -1 : 1;
        else if ( const float adj = -adjustment.y + adjustment.z )
          opt_change_eta = adj < 0 ? -1 : 1;
        break;
      default: assert( false );
      }
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
