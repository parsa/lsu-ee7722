/// LSU EE 4702-1 (Fall 2011), GPU Programming
//
 /// Vertex Arrays, Buffer Objects

// $Id:$

/// Purpose
//
//   Demonstrate use of Vertex Arrays and Buffer Objects

/// References
//
//  OpenGL 3.0 Specification Section 2.8 and 2.9 (Vertex Arrays, Buffer Obj)

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

enum VTX_Spec_Method { VM_Individual, VM_Array, VM_Buffer, VM_SIZE };
const char* const spec_method_str[] = {"Individual", "Array", "Buffer"};

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
  int coords_size;

  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  int opt_method;
  bool opt_recompute;

  bool opt_scene, opt_ambient, opt_specular, opt_diffuse, opt_emissive;
  float opt_shininess;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  coords = NULL;
  gpu_buffer = 0;

  opt_method = 0;
  opt_recompute = true;

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
  //  variable_control.insert(sphere_size,"Sphere Size");

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
                      cvar->name,cvar->get_val());


  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]  "
     "Sphere Location[%5.1f, %5.1f, %5.1f]\n",
     opt_method,
     light_location.x, light_location.y, light_location.z,
     sphere_location.x, sphere_location.y, sphere_location.z
     );

  ogl_helper.fbprintf
    ("Vertex Specification Method: %s,  Recompute Coords: %s\n",
     spec_method_str[opt_method], opt_recompute ? "Yes" : "No");

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

  //  glLightfv(GL_LIGHT0, GL_AMBIENT, white * opt_light_intensity);

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

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  /// Specify normal for triangle.
  //
  // Use cross product function (in coord.h) to find normal.
  //
  pNorm tri_norm = cross(pCoor(1.5,0,-3.2),pCoor(0,5,-5),pCoor(9,6,-9));
  glNormal3fv(tri_norm);  // Set current normal.
  // Note: pNorm, pVect, pCoor, and pColor objects can be used as
  // arguments to OpenGL functions with names ending in 3fv.

  /// Specify vertices for a triangle.
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

  glDisable(GL_COLOR_MATERIAL);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE, lsu_spirit_purple);
  glEnable(GL_COLOR_MATERIAL);

  if ( coords == NULL )
    {
      /// Initialize array coords with sphere's coordinates.
      // 

      // Declare a self-resizing stack for collecting coordinates.
      // See code in include/misc.h.
      //
      PStack<float> sphere_coords;

      const int slices = 40;
      const double delta_eta = M_PI / slices;

      for ( double eta = 0; eta < M_PI - 0.0001 - delta_eta; eta += delta_eta )
        {
          const double eta1 = eta + delta_eta;
          const float  y0 = cos(eta),        y1 = cos(eta1);
          const double slice_r0 = sin(eta),  slice_r1 = sin(eta1);
          const double delta_theta = delta_eta * slice_r1;

#if 0
          /// Note: This code is not compiled.
          //  This was the code used to send vertices to GL in earlier demos,
          //  it's not needed now.

          glBegin(GL_TRIANGLE_STRIP);
          glColor3fv(lsu_spirit_gold);

          glNormal3f( slice_r1, y1, 0);
          glVertex3f( slice_r1, y1, 0);

          glNormal3f( slice_r0 , y0, 0);
          glVertex3f( slice_r0 , y0, 0);
#endif

          // Add vertex coordinates to array.
          /// Note "+=" means append to array.
          //
          sphere_coords += slice_r1;
          sphere_coords += y1;
          sphere_coords += 0;

          sphere_coords += slice_r0;
          sphere_coords += y0;
          sphere_coords += 0;

          for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
            {
              const double theta1 = theta + delta_theta;

              sphere_coords += slice_r1 * cos(theta1);
              sphere_coords += y1;
              sphere_coords += slice_r1 * sin(theta1);

              sphere_coords += slice_r0 * cos(theta1);
              sphere_coords += y0;
              sphere_coords += slice_r0 * sin(theta1);

#if 0
          // This was the code used to send vertices to GL in earlier demos.
          //

              glNormal3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );
              glVertex3f( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) );

              glNormal3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );
              glVertex3f( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) );
#endif

            }

        }

        // Retrieve array size and pointer to array data.
        //
        coords_size = sphere_coords.occ();
        coords = sphere_coords.take_storage();
     }

  ///
  /// Send Vertices to OpenGL in One of Several Ways
  ///

  switch ( opt_method ) {

  case VM_Individual:
    {
      /// Use Individual Vertices

      // Data sent one vertex at a time. This is the slowest option
      // because of the overhead needed to send data to the GPU and
      // toss it in the rendering pipeline.

      glBegin(GL_TRIANGLE_STRIP);
      glColor3fv(lsu_spirit_gold);
      for ( int i=0; i<coords_size; i+=3 )
        {
          glNormal3f(coords[i],coords[i+1],coords[i+2]);
          glVertex3f(coords[i],coords[i+1],coords[i+2]);
        }
      glEnd();
      break;
    }

  case VM_Array:
    {
      /// Use Vertex Arrays

      // Data managed as arrays, but arrays are sent to GPU every
      // frame even though data doesn't change.

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
      break;
    }

  case VM_Buffer:
    {
      /// Use Buffer Objects
      //
      // Data managed as an array, and sent to GPU just once.

      // On first visit, set up a buffer object to hold coordinates.
      //
      if ( gpu_buffer == 0 )
        {
          // Generate buffer id (name).
          //
          glGenBuffers(1,&gpu_buffer);

          // Tell GL that subsequent array pointers refer to this buffer.
          //
          glBindBuffer(GL_ARRAY_BUFFER, gpu_buffer);

          // Copy data into buffer.
          //
          glBufferData
            (GL_ARRAY_BUFFER,
             coords_size*sizeof(float),
             coords,
             GL_STATIC_DRAW);

          // Tell GL that subsequent array pointers refer to host storage.
          //
          glBindBuffer(GL_ARRAY_BUFFER, 0);
        }

      // Tell GL that subsequent array pointers refer to this buffer.
      //
      glBindBuffer(GL_ARRAY_BUFFER,gpu_buffer);

      // Specify array of vertices.
      // The array pointer, NULL, is an offset (of zero) into gpu_buffer.
      //
      glVertexPointer(3,GL_FLOAT,3*sizeof(float),NULL);
      glEnableClientState(GL_VERTEX_ARRAY);

      // Ditto. Note that vertices and normals read from same buffer.
      //
      glNormalPointer(GL_FLOAT,0,NULL);
      glEnableClientState(GL_NORMAL_ARRAY);

      // Set vertex color the old-fashioned way. This color should
      // be sent to the GPU just once and used for all subsequent
      // vertices.
      //
      glColor3fv(lsu_spirit_gold);

      glDrawArrays(GL_TRIANGLE_STRIP,0,coords_size/3);

      // Tell GL that subsequent array pointers refer to host storage.
      //
      glBindBuffer(GL_ARRAY_BUFFER,0);

      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);
    }
    break;

  default:
    // Raise a fatal error if we reach this point.
    ASSERTS( false );
  }

  if ( opt_recompute )
    {
      free( coords );  coords = NULL;
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
  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'r': case 'R': opt_recompute = !opt_recompute; break;
  case 'm': case 'M': opt_method++;
    if ( opt_method == VM_SIZE ) opt_method = 0;
    break;
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
