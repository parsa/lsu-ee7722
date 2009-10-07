/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Lighting

// $Id:$

/// Purpose
//
//   Demonstrate Lighting



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
 //  '1'    Toggle ambient scene lighting on and off.
 //  '2'    Toggle emissive material color on and off.
 //  '3'    Toggle ambient material color on and off.
 //  '4'    Toggle diffuse material color on and off.
 //  '5'    Toggle specular material color on and off.
 //  'F11'  Change size of text.
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

  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  bool opt_scene, opt_ambient, opt_specular, opt_diffuse, opt_emissive;
  float opt_shininess;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");

  eye_location = pCoor(2.6,0.5,9);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 7.2;
  light_location = pCoor(7,4.0,-0.3);

  sphere_location = pCoor(0,0,-5);
  sphere_size = 5;

  opt_scene = false;
  opt_ambient = false;
  opt_diffuse = true;
  opt_specular = false;
  opt_emissive = false;
  opt_shininess = 1;

  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_shininess, "Shininess");

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

  // Clear frame buffer.
  //
  glClearColor(0,0,0,0);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glShadeModel(GL_SMOOTH);


  // Messages for top of frame.
  //
  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]  Light %c%c%c%c%c "
     "Sphere Location[%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z,
     opt_scene ? 'C' : '_',
     opt_emissive ? 'E' : '_',
     opt_ambient ? 'A' : '_',
     opt_diffuse ? 'D' : '_',
     opt_specular ? 'S' : '_',
     sphere_location.x, sphere_location.y, sphere_location.z
     );

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  glEnable(GL_LIGHTING);

  pColor white(1,1,1);
  pColor red(1,0,0);
  pColor gray(0x303030);
  pColor dark(0);
  pColor ambient_color(0x555555);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);

  ///
  /// Lighting Setup
  ///

  // Specify the ambient lighting that's not connected with any light,
  // called scene lighting.
  //
  if ( opt_scene )
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  else
    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, dark );

  // Turn on light 0 and set its position.
  //
  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  // Specify light colors for light 0.
  //
  if ( opt_diffuse )
    glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  else
    glLightfv(GL_LIGHT0, GL_DIFFUSE, dark);

  if ( opt_ambient )
    glLightfv(GL_LIGHT0, GL_AMBIENT, white * opt_light_intensity);
  else
    glLightfv(GL_LIGHT0, GL_AMBIENT, dark);

  if ( opt_specular )
    glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);
  else
    glLightfv(GL_LIGHT0, GL_SPECULAR, dark);

  // Specify how light fades with distance for light 0.
  //
  glLightf(GL_LIGHT0,GL_CONSTANT_ATTENUATION,0.3);
  glLightf(GL_LIGHT0,GL_LINEAR_ATTENUATION,1);
  glLightf(GL_LIGHT0,GL_QUADRATIC_ATTENUATION,0);

  pError_Check();

#if 0
  // Specify that calls to glColor will set both ambient and diffuse
  // material properties.
  //
  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
#endif

  // If 1, use back color and -normal if back side facing user.
  //
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);


  // Set shininess. Will use this for all subsequent primitives.
  //
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,opt_shininess);

  ///
  /// Paint Single Triangle.
  ///

  // Use glColor to set material properties.
  //
  glEnable(GL_COLOR_MATERIAL);
  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  // Specify vertices for a triangle.
  //
  glVertex3f( 1.5, 0, -3.2 );
  glVertex3f( 0,   5, -5 );
  glVertex3f( 9,   6, -9 );

  glEnd();


  ///
  /// Paint a Sphere
  ///

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glTranslatef(sphere_location.x,sphere_location.y,sphere_location.z);
  glScalef(sphere_size,sphere_size,sphere_size);

  glColor3ub( 0x80, 0x80, 0x80); // Red, Green, Blue

  // Don't use glColor to set material properties.
  //
  glDisable(GL_COLOR_MATERIAL);

  // Set back of triangles to purple.
  //
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE, lsu_spirit_purple);

  const int slices = 40;
  const double delta_eta = M_PI / slices;

  for ( double eta = 0; eta < M_PI - 0.0001 - delta_eta; eta += delta_eta )
    {
      const double eta1 = eta + delta_eta;
      const float  y0 = cos(eta),        y1 = cos(eta1);
      const double slice_r0 = sin(eta),  slice_r1 = sin(eta1);
      const double delta_theta = delta_eta * slice_r1;

      //
      // Set material properties.
      //

      // Emissive is set to dark because there is no emissive "light"
      // to turn off other than the material property.
      if ( opt_emissive )
        glMaterialfv(GL_FRONT,GL_EMISSION, lsu_spirit_gold);
      else
        glMaterialfv(GL_FRONT,GL_EMISSION, dark);

      glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE, lsu_spirit_gold);
      glMaterialfv(GL_FRONT,GL_SPECULAR, lsu_spirit_gold);

      glBegin(GL_TRIANGLE_STRIP);

      glNormal3f( slice_r1, y1, 0);
      glVertex3f( slice_r1, y1, 0);

      glNormal3f( slice_r0 , y0, 0);
      glVertex3f( slice_r0 , y0, 0);

      for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
        {
          const double theta1 = theta + delta_theta;

          glNormal3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );
          glVertex3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );

          glNormal3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );
          glVertex3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );
        }

      glEnd();

      if ( opt_emissive )
        glMaterialfv(GL_FRONT,GL_EMISSION, red);
      else
        glMaterialfv(GL_FRONT,GL_EMISSION, dark);

      glMaterialfv(GL_FRONT,GL_AMBIENT_AND_DIFFUSE, red);
      glMaterialfv(GL_FRONT,GL_SPECULAR, red);

      const float rad = 0.1 * 2 * M_PI / slices;

      for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
        {
          pVect norm( slice_r1 * cos(theta), y1, slice_r1 * sin(theta) );

          glBegin(GL_TRIANGLE_FAN);
          
          pCoor surf = norm;
          pCoor apex = 1.2 * norm;
          double delta_a = 2 * M_PI / 10;

          pVect va(-sin(theta),0,cos(theta));
          pNorm vb(cos(theta)*cos(eta),-sin(eta),sin(theta)*cos(eta));

          glVertex3fv(apex);

          for ( float a = 0; a < 2 * M_PI; a += delta_a )
            {
              pNorm sn = cos(a) * va + sin(a) * vb;
              pCoor pt = surf + rad * sn;

              glNormal3fv(sn);
              glVertex3fv(pt);
            }

          glEnd();
        }
    }

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
  case '1': opt_scene = !opt_scene; break;
  case '2': opt_emissive = !opt_emissive; break;
  case '3': opt_ambient = !opt_ambient; break;
  case '4': opt_diffuse = !opt_diffuse; break;
  case '5': opt_specular = !opt_specular; break;
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
