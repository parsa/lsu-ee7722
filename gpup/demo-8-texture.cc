/// LSU EE 4702-1 (Fall 2012), GPU Programming
//
 /// Textures, Blending, and the Alpha Test

// $Id:$

/// Purpose
//
//   Demonstrate use of Textures

/// References
//
//  OpenGL 3.0 Specification 

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


 ///
 ///  Create and Initialize a Texture Object from a File
 ///
enum { PT_Invert = 1, PT_To_Alpha = 2 };

#define ENUM_LABEL(c) { #c, c }
struct pEnum_Label { const char *label; int value; };
pEnum_Label texture_env_modes[] = {
  { "Texturing Off", 0 },
  ENUM_LABEL(GL_REPLACE),
  ENUM_LABEL(GL_MODULATE),
  ENUM_LABEL(GL_DECAL),   // Blend using alpha value of texture.
  ENUM_LABEL(GL_BLEND),   // Blend using separate alpha.
  ENUM_LABEL(GL_ADD),     // Sum of colors, product of alphas.
  ENUM_LABEL(GL_COMBINE), // Use separate combine function.
  {NULL,0}
};

pEnum_Label texture_min_filters[] = {
  ENUM_LABEL( GL_NEAREST_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_LINEAR_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_NEAREST_MIPMAP_LINEAR ),
  ENUM_LABEL( GL_LINEAR_MIPMAP_LINEAR ),
  {NULL,0}
};

pEnum_Label texture_mag_filters[] = {
  ENUM_LABEL( GL_NEAREST ),
  ENUM_LABEL( GL_LINEAR ),
  {NULL,0}
};


GLuint
pTexture_From_Image
(char *file_name, int option = 0, int transp = 256 )
{
  P_Image_Read image(file_name,transp);
  if ( !image.image_loaded ) return 0;
  if ( option & PT_To_Alpha ) image.gray_to_alpha();
  if ( option & PT_Invert ) image.color_invert();
  GLuint texture_id;

  // Generate a texture id (name). (This doesn't create a texture object.)
  //
  glGenTextures(1,&texture_id);

  // Create a texture object for texture_id (since one doesn't yet exist).
  //
  glBindTexture(GL_TEXTURE_2D,texture_id);

  // Set some parameters for our new texture object.
  //
  glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP,1);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  // Load data into the texture object.
  //
  glTexImage2D
    (GL_TEXTURE_2D,
     0,                // Level of Detail (0 is base).
     GL_RGBA,          // Internal format to be used for texture.
     image.width, image.height,
     0,                // Border
     image.gl_fmt,     // GL_BGRA: Format of data read by this call.
     image.gl_type,    // GL_UNSIGNED_BYTE: Size of component.
     (void*)image.data);
  pError_Check();

  return texture_id;
}



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

  int opt_method;
  bool opt_recompute;

  GLuint texture_id_syllabus;
  GLuint texture_id_image;

  bool opt_blend;
  bool opt_alpha;
  int opt_texture_env_mode;
  int opt_texture_min_filter;
  int opt_texture_mag_filter;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  coords = NULL;
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

  opt_move_item = MI_Eye;

  opt_texture_env_mode = 0;
  opt_texture_min_filter = 0;
  opt_texture_mag_filter = 0;
  opt_blend = false;
  opt_alpha = false;

  texture_id_syllabus = pBuild_Texture_File("gpup.png",false,255);
  texture_id_image = pBuild_Texture_File("mult.png", false,255);

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
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  glShadeModel(GL_SMOOTH);


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
     opt_method,
     light_location.x, light_location.y, light_location.z,
     sphere_location.x, sphere_location.y, sphere_location.z
     );

  ogl_helper.fbprintf("Texture Mode: %s  (m to change)\n",
		      texture_env_modes[opt_texture_env_mode].label);
  ogl_helper.fbprintf("Min Filter: %s  (i to change)\n",
		      texture_min_filters[opt_texture_min_filter].label);
  ogl_helper.fbprintf("Mag Filter: %s  (a to change)\n",
		      texture_mag_filters[opt_texture_mag_filter].label);
  ogl_helper.fbprintf("Blending %s  Alpha Test %s\n",
                      opt_blend ? "ON" : "OFF",
                      opt_alpha ? "ON" : "OFF"
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

  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);

  if ( opt_blend )
    {
      glEnable(GL_BLEND);
    }
  else
    {
      glDisable(GL_BLEND);
    }

  if ( opt_alpha )
    {
      glEnable(GL_ALPHA_TEST);
    }
  else
    {
      glDisable(GL_ALPHA_TEST);
    }

  glAlphaFunc(GL_GREATER,0.1);
  glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

  pError_Check();

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  // If 1, use back color and -normal if back side facing user.
  //
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);


  ///
  /// Paint Single Triangle.
  ///

  glEnable(GL_COLOR_MATERIAL);
  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameterf
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameterf
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

  // Set parameter for texture unit.
  //
  glTexEnvi
    (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,
     texture_env_modes[opt_texture_env_mode].value);

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  // Specify vertices for a triangle.
  //

  const float dz = 2;

  glNormal3f(0,1,0);
  glTexCoord2f(0.95,1.0);  glVertex3f( 9.5, -5, dz + -3.2 );
  glTexCoord2f(0.00,0.1);  glVertex3f( 0,   5, dz + -5 );
  glTexCoord2f(0.90,0.0);  glVertex3f( 9,   6, dz + -9 );

  glEnd();

  glDisable(GL_TEXTURE_2D);


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

  glColor3ub( 0x80, 0x80, 0x80); // Red, Green, Blue

  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE, lsu_spirit_purple);
  glEnable(GL_COLOR_MATERIAL);

  if ( opt_texture_env_mode )
    {
      // Make the Image texture the current 2D texture.
      //
      glBindTexture(GL_TEXTURE_2D,texture_id_image);

      // Set parameters in texture object (texture_id_image).
      //
      glTexParameterf
        (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
         texture_min_filters[opt_texture_min_filter].value);

      glTexParameterf
        (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
         texture_mag_filters[opt_texture_mag_filter].value);

      // Set parameter for texture unit.
      //
      glTexEnvi
        (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,
         texture_env_modes[opt_texture_env_mode].value);

      glEnable(GL_TEXTURE_2D);
    }

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

  glDisable(GL_TEXTURE_2D);

  if ( opt_recompute )
    {
      free( coords );  coords = NULL;
      free( tcoords );  tcoords = NULL;
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

  case 'b': case 'B': opt_blend = !opt_blend; break;
  case 'p': case 'P': opt_alpha = !opt_alpha; break;
  case 'm': opt_texture_env_mode++;
    if ( !texture_env_modes[opt_texture_env_mode].label )
      opt_texture_env_mode = 0;
    break;
  case 'i': opt_texture_min_filter++;
    if ( !texture_min_filters[opt_texture_min_filter].label )
      opt_texture_min_filter = 0;
    break;
  case 'a': opt_texture_mag_filter++;
    if ( !texture_mag_filters[opt_texture_mag_filter].label )
      opt_texture_mag_filter = 0;
    break;

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
