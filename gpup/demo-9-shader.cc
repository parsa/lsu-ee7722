/// LSU EE 4702-1 (Fall 2012), GPU Programming
//
 /// Shaders

// $Id:$

/// Purpose
//
//   Demonstrate use of Vertex and Fragment Shaders
//   See demo-9-shdr-code.cc for shader program source code.

/// References
//
//  OpenGL 4.3 Specification

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
 //  'v'    Toggle "lighting" shader program (vertex shader) on and off.
 //  'f'    Toggle "Phong" shader program (vertex and fragment shader).
 //  'm'    Change method used to specify vertices.
 //  'r'    Toggle vertex re-computation on and off.
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
  GLuint gpu_buffer;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  float *coords;
  float *tcoords;
  int coords_size;

  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  GLuint texture_id_syllabus;
  GLuint texture_id_image;

  int opt_method;
  bool opt_recompute;

  bool opt_fshader;
  bool opt_vshader;
  pShader *vs_fixed;     // Fixed functionality.
  pShader *vs_lighting;  // Lighting tweak.
  pShader *vs_phong;     // Phong shading.

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  coords = NULL;
  tcoords = NULL;
  gpu_buffer = 0;

  opt_method = 0;
  opt_recompute = false;

  eye_location = pCoor(2.6,0.5,9);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 7.2;
  light_location = pCoor(7,4.0,-0.3);

  sphere_location = pCoor(0,0,-5);
  sphere_size = 5;


  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Light;

  texture_id_syllabus = pBuild_Texture_File("gpup.png",false,255);
  texture_id_image = pBuild_Texture_File("mult.png", false,255);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  vs_fixed = new pShader();

  // Prepare a vertex shader implementing a simple lighting model.
  //
  vs_lighting = new pShader
    ("demo-9-shdr-code.cc",  // File holding shader program.
     "vs_main_lighting();"   // Name of vertex shader main routine.
     );

  // Prepare a vertex shader and fragment shader, implementing a Phong shader.
  //
  vs_phong = new pShader
    ("demo-9-shdr-code.cc",   // File holding shader program.
     "vs_main_phong();",      // Name of vertex shader main routine.
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  vs_phong->print_active_attrib();
  vs_phong->print_active_uniform();
  vs_phong->print_active_varying();

  opt_fshader = false;
  opt_vshader = false;

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

  glClearColor(0,0,0,0);
  glClearDepth(1.0);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

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
    ("Light location: [%5.1f, %5.1f, %5.1f]  "
     "Sphere Location[%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z,
     sphere_location.x, sphere_location.y, sphere_location.z
     );

  ogl_helper.fbprintf("Vertex Shader: %s  Fragment Shader: %s  (f TO CHANGE)\n",
                      opt_fshader || opt_vshader ? "on" : "off",
                      opt_fshader ? "on" : "off");

  if ( !vs_lighting->pobject )
    ogl_helper.fbprintf
      ("Programmable GPU API: %savailable.  GPU Code: %s\n",
       ptr_glCreateShader ? "" : "not",
       vs_lighting->pobject ? "okay" : "problem");


  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glEnable(GL_NORMALIZE);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  pColor white(1,1,1);
  pColor red(1,0,0);
  pColor gray(0x303030);
  pColor dark(0);
  pColor ambient_color(0x555555);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);

  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, white * opt_light_intensity);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);

  pError_Check();

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  // Set texture unit for commands such as gl_BindTexture, gl_TexEnv.
  //
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Set parameter for texture unit.
  //
  glTexEnvi
    (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  // If 1, use back color and -normal if back side facing user.
  //
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);

  if ( opt_vshader && !opt_fshader )
    {
      // Install the "lighting" vertex shader into the vertex stage of
      // the rendering pipeline. The other stages, including fragment
      // stage, do not have shader programs installed so they realize
      // fixed functionality.
      //
      vs_lighting->use();
      //
      // Note that vs_lighting is an instance of pShader, a class
      // written for use with this course. See ../include/shader.h.
    }
  else if ( opt_fshader )
    {
      // Install the "phong" vertex/fragment shaders in the respective
      // stages.
      //
      vs_phong->use();
    }
  else
    {
      // Set all programmable units to use fixed functionality.
      //
      vs_fixed->use();
    }

  ///
  /// Paint Single Triangle.
  ///

  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  // Specify vertices for a triangle.
  //

  pCoor p1( 9.5, -5, -1.2 );
  pCoor p2( 0,    5, -3 );
  pCoor p3( 9,    6, -7 );
  pNorm triangle_normal = cross(p1,p2,p3);

  // Specify normal and vertex using course-defined objects pCoor and
  // pNorm. OpenGL sees these as pointers to floats.

  glNormal3fv(triangle_normal);
  glTexCoord2f(0.95,1.0); glVertex3fv(p1);
  glTexCoord2f(0.00,0.1); glVertex3fv(p2);
  glTexCoord2f(0.90,0.0); glVertex3fv(p3);

  glEnd();


  ///
  /// Construct a Sphere
  ///

  if ( coords == NULL )
    {
      // Declare a self-resizing stack for storing coordinates.
      //
      PStack<float> sphere_coords;
      PStack<float> texture_coords;

      const int slices = 40;
      const double delta_eta = M_PI / slices;

      for ( double eta = 0; eta < M_PI - 0.0001 - delta_eta; eta += delta_eta )
        {
          const double eta1 = eta + delta_eta;
          const float  y0 = cos(eta),        y1 = cos(eta1);
          const double slice_r0 = sin(eta),  slice_r1 = sin(eta1);
          const double delta_theta = delta_eta * slice_r1;

          const float t0 = eta / M_PI;
          const float t1 = eta1 / M_PI;

          texture_coords += 1;
          texture_coords += t1;

          sphere_coords += slice_r1;
          sphere_coords += y1;
          sphere_coords += 0;

          texture_coords += 1;
          texture_coords += t0;

          sphere_coords += slice_r0;
          sphere_coords += y0;
          sphere_coords += 0;

          for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
            {
              const double theta1 = theta + delta_theta;

              texture_coords += 1 - theta1 / ( 2 * M_PI );
              texture_coords += t1;

              sphere_coords += slice_r1 * cos(theta1);
              sphere_coords += y1;
              sphere_coords += slice_r1 * sin(theta1);

              texture_coords += 1 - theta1 / ( 2 * M_PI );
              texture_coords += t0;

              sphere_coords += slice_r0 * cos(theta1);
              sphere_coords += y0;
              sphere_coords += slice_r0 * sin(theta1);
            }
        }

      coords_size = sphere_coords.occ();
      coords = sphere_coords.take_storage();
      tcoords = texture_coords.take_storage();
    }


  ///
  /// Paint a Sphere
  ///

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glTranslatef(sphere_location.x,sphere_location.y,sphere_location.z);
  glScalef(sphere_size,sphere_size,sphere_size);
  glRotatef(60,0,1,0);

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_image);

  // Specify pointer into array to use for texture coordinates.
  //
  glTexCoordPointer(2,GL_FLOAT,0,tcoords);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Specify pointer into array to use for normals.
  //
  glNormalPointer(GL_FLOAT,0,coords);

  // Specify that normals should come from an array.
  //
  glEnableClientState(GL_NORMAL_ARRAY);

  // Ditto.
  //
  glVertexPointer(3,GL_FLOAT,3*sizeof(float),coords);
  glEnableClientState(GL_VERTEX_ARRAY);

  // Specify color. Since it's not an array the same color
  // will be used for all vertices, which is what we want.
  // If we wanted to vary vertex colors we could have created
  // and used a color array.
  //
  glColor3fv(lsu_spirit_gold);

  // Draw triangle strips using enabled arrays.
  // Start at element 0, render a total of coords_size/3 vertices.
  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,coords_size/3);

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);

  if ( opt_recompute )
    {
      free( coords );  coords = NULL;
    }

  glPopMatrix();

  vs_fixed->use();

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

  case 'v': case 'V': opt_vshader = !opt_vshader; break;
  case 'f': case 'F': opt_fshader = !opt_fshader; break;

  case 's': case 'S': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'r': case 'R': opt_recompute = !opt_recompute; break;

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
