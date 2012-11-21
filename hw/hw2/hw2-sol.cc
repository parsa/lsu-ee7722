/// LSU EE 4702-1 (Fall 2012), GPU Programming
//
 /// Homework 2 Solution

// $Id:$

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
 //  'i'    Toggle between use of triangle strips and individual triangles.
 //  'm'    Toggle between using glDrawArrays and glDrawElements
 //           glDrawArrays reads vertex arrays sequentially.
 //           glDrawElements uses a second index array to read vertex arrays.
 //  'd'    Toggle forced sending of data to GPU on and off.
 //           When on unnecessary CPU to GPU transfer is performed.
 //  'r'    Toggle forced vertex re-computation on and off.
 //           When on unnecessary computation and transfer is performed.
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
 //      Big Circle - The number of segments in one revolution of helix.
 //         A smaller number means fewer primitives.
 //      Small Circle - The number of segments in one revolution around wire.
 //         A smaller number means fewer primitives.


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

  int seg_per_big_circle;
  int seg_per_small_circle;

  bool coords_stale;
  bool buffer_objects_stale;
  GLuint helix_coords_bo;

  GLuint helix_normals_bo; // SOLUTION
  GLuint indices_bo; // SOLUTION

  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  float *helix_coords;
  float *helix_normals;
  int *indices;
  int indices_size;
  int helix_coords_size;

  pCoor helix_location;
  float helix_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  bool opt_use_strips;
  bool opt_use_elements;
  bool opt_recompute;
  bool opt_resend;

  GLuint texture_id_syllabus;
};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  helix_coords = NULL;

  coords_stale = true;

  seg_per_big_circle = 40;
  seg_per_small_circle = 20;
  variable_control.insert(seg_per_big_circle,"Big Circle");
  variable_control.insert(seg_per_small_circle,"Small Circle");

  buffer_objects_stale = true;
  helix_coords_bo = 0;
  helix_normals_bo = indices_bo = 0; // SOLUTION

  opt_use_strips = true;
  opt_use_elements = true;
  opt_recompute = false;
  opt_resend = false;

  eye_location = pCoor(2.6,5.7,15);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 7.2;
  light_location = pCoor(7,4.0,-0.3);

  helix_location = pCoor(0,0,-5);
  helix_size = 5;

  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;

  texture_id_syllabus = pBuild_Texture_File("gpup.pdf",false,255);

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
     "Helix Location[%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z,
     helix_location.x, helix_location.y, helix_location.z
     );

  ogl_helper.fbprintf("Use %s (i)  Use %s (m)\n",
                      opt_use_strips ?
                      "TRIANGLE STRIPS" : "INDIVIDUAL TRIANGLES",
                      opt_use_elements ? "glDrawElements" : "glDrawArrays"
                      );
  ogl_helper.fbprintf("Always Send %s (d)  Always Compute %s (r)\n",
                      opt_resend ? "YES" : "NO",
                      opt_recompute ? "YES" : "NO"
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

  const pColor white(1,1,1);
  const pColor red(1,0,0);
  const pColor blue(0,0,1);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);

  glEnable(GL_LIGHT0);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);

  pError_Check();

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  // If 1, use back color and -normal if back side facing user.
  //
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);

  ///
  /// Paint Single Triangle.
  ///

  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameterf
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  glTexParameterf
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Set parameter for texture unit.
  //
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE),

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
  /// Construct a Helix
  ///

  // If requested force re-computation of coordinates, whether needed or not.
  if ( opt_recompute ) coords_stale = true;

  // If requested force re-sending of buffer objects to GPU, whether
  // needed or not.
  if ( opt_resend ) buffer_objects_stale = true;

  if ( coords_stale )
    {
      // Recompute helix coordinates, etc.

      coords_stale = false;
      buffer_objects_stale = true;

      // If necessary, free existing storage.
      if ( helix_coords )
        {
          free( helix_coords );   helix_coords = NULL;
          free( indices );        indices = NULL;
          free( helix_normals );  helix_normals = NULL;  // SOLUTION
        }

      // Declare self-resizing stacks used while preparing coords, etc.
      //
      PStack<pVect> prep_coords;
      PStack<pVect> prep_normals;
      PStack<int> prep_indices;

      // Number of times helix wraps around.
      const int revolutions_per_helix = 6;

      const int segments_per_helix = revolutions_per_helix * seg_per_big_circle;

      // Radius of "wire". (Radius of helix is 1.)
      const double small_r = 0.1;
      const double small_r_inv = 1/small_r;

      const double delta_eta = 2 * M_PI / seg_per_big_circle;
      const double delta_y = 4 * small_r / seg_per_big_circle;
      const double delta_theta = 2 * M_PI / seg_per_small_circle;

      // Point on helix. (Actually center of wire that forms helix.)
      pCoor p(1,0,0);

      // Vector pointing up. Used to compute point on wire surface.
      pVect b(0,small_r,0);

      /// SOLUTION

      for ( int i = 0; i < segments_per_helix; i++ )
        {
          const double eta = i * delta_eta;
          const bool last_i_iteration = i + 1 == segments_per_helix;
          pCoor p0 = p;
          pCoor c0(0,p0.y,0);
          p.y += delta_y;  p.x = cos(eta);  p.z = sin(eta);
          pCoor p1 = p;
          pCoor c1(0,p1.y,0);

          pVect n0 = small_r * pVect(p0,c0);
          pVect n1 = small_r * pVect(p1,c1);

          for ( int j = 0; j < seg_per_small_circle; j++ )
            {
              const int idx = prep_coords.occ();
              const double theta = j * delta_theta;
              const bool last_j_iteration = j == seg_per_small_circle - 1;

              pVect p0s0 = cos(theta) * n0 + sin(theta) * b;
              // Note: Dividing out by small_r from student Zhang.
              pVect norm0 = small_r_inv * p0s0;
              prep_normals += norm0;

              pCoor s0 = p0 + p0s0;
              prep_coords += s0;

              if ( last_i_iteration ) continue;

              if ( opt_use_strips )
                {
                  prep_indices += idx; // This vertex.
                  prep_indices += idx + seg_per_small_circle;
                }
              else
                {
                  prep_indices += idx; // This vertex.
                  prep_indices += idx + seg_per_small_circle;
                  prep_indices += idx + seg_per_small_circle + 1;

                  prep_indices += idx; // This vertex.
                  prep_indices += idx + seg_per_small_circle + 1;
                  prep_indices += idx + 1;
                }
            }
        }

      indices_size = prep_indices.occ();
      indices = prep_indices.take_storage();

      if ( opt_use_elements )
        {
          helix_coords_size = prep_coords.occ() * 3;
          helix_coords = (float*) prep_coords.take_storage();
          helix_normals = (float*) prep_normals.take_storage();
        }
      else
        {
          PStack<pVect> prep_coords2;
          PStack<pVect> prep_norms2;
          for ( int i=0; i<indices_size; i++ )
            {
              prep_coords2 += prep_coords[prep_indices[i]];
              prep_norms2 += prep_normals[prep_indices[i]];
            }
          helix_coords_size = prep_coords2.occ() * 3;
          helix_coords = (float*) prep_coords2.take_storage();
          helix_normals = (float*) prep_norms2.take_storage();
        }

    }

  // If necessary, update data in buffer objects.
  if ( buffer_objects_stale )
    {
      buffer_objects_stale = false;

      // Generate buffer id (name), if necessary.
      //
      if ( !helix_coords_bo )
        {
          glGenBuffers(1,&helix_coords_bo);
          glGenBuffers(1,&helix_normals_bo); // SOLUTION
          glGenBuffers(1,&indices_bo); // SOLUTION
        }

      // Tell GL that subsequent array pointers refer to this buffer.
      //
      glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);

      // Copy data into buffer.
      //
      glBufferData
        (GL_ARRAY_BUFFER,               // Kind of buffer object.
         // Amount of data (bytes) to copy.
         helix_coords_size*sizeof(helix_coords[0]),
         helix_coords,                  // Pointer to data to copy.
         GL_STATIC_DRAW);               // Hint about who, when, how accessed.

      /// SOLUTION BELOW
      glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*sizeof(helix_normals[0]), helix_normals, 
         GL_STATIC_DRAW);
      /// SOLUTION ABOVE


      glBindBuffer(GL_ARRAY_BUFFER, indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         indices_size*sizeof(indices[0]), indices, GL_STATIC_DRAW);

      // Tell GL that subsequent array pointers refer to host storage.
      //
      glBindBuffer(GL_ARRAY_BUFFER, 0);
    }


  ///
  /// Paint a Helix
  ///

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  glTranslatef(helix_location.x,helix_location.y,helix_location.z);
  glScalef(helix_size,helix_size,helix_size);
  glRotatef(60,0,1,0);

  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE, lsu_spirit_purple);
  glEnable(GL_COLOR_MATERIAL);

  // Specify color. Since it's not an array the same color
  // will be used for all vertices, which is what we want.
  // If we wanted to vary vertex colors we could have created
  // and used a color array.
  //
  glColor3fv(lsu_spirit_gold);

  // Specify buffer object to use for vertices.
  //
  glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);
  glVertexPointer(3,GL_FLOAT,3*sizeof(float),0);
  glEnableClientState(GL_VERTEX_ARRAY);


  // Specify buffer object to use for normals.   // SOLUTION
  //
  glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
  glNormalPointer(GL_FLOAT,0,0);
  glEnableClientState(GL_NORMAL_ARRAY);
  /// SOLUTION ABOVE

  glBindBuffer(GL_ARRAY_BUFFER, 0); // Avoid surprises.

  const GLuint primitives = opt_use_strips ? GL_TRIANGLE_STRIP : GL_TRIANGLES;

  if ( !opt_use_elements )
    {
      glDrawArrays(primitives,0,helix_coords_size/3);
    }
  else
    {
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indices_bo);
      glDrawElements(primitives,indices_size,GL_UNSIGNED_INT,0);
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    }

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);

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

  case 'i': opt_use_strips = !opt_use_strips; coords_stale = true; break;
  case 'm': opt_use_elements = !opt_use_elements; coords_stale = true; break;

  case 's': case 'S': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;

  case 'd': case 'D': opt_resend = !opt_resend; break;
  case 'r': case 'R': opt_recompute = !opt_recompute; break;

  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower();  coords_stale=true; break;
  case '+':case '=': variable_control.adjust_higher(); coords_stale=true; break;
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
      case MI_Ball: helix_location += adjustment; break;
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
