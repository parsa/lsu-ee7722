/// LSU EE 4702-1 (Fall 2012), GPU Programming
//

 /// Homework 3
 //
 // Assignment in: http://www.ece.lsu.edu/koppel/gpup/2012/hw03.pdf
 //
 /// Your Name:

 ///  Note: Requires OpenGL 4.3

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
 //  's'    Switch between different shaders in forward direction.
 //  'S'    Switch between different shaders in reverse direction.
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
 //  -- Documented Variables --
 //
 //     Door Angle
 //     - Angle of doors in surface of wire.
 //       Behavior when Problem 3 is correctly solved:
 //       When zero the surface is flat, when Pi/2 the doors point straight out.
 //
 //     Segs Per Helix Rev
 //     - The number of segments in one revolution of helix.
 //       A smaller number means fewer primitives.
 //
 //     Segs Per Wire Rev
 //     - The number of segments in 1 revolution around wire.
 //       A smaller number means fewer primitives.
 //
 //     Light Intensity
 //     - The light intensity.
 //



#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#define GL_GLEXT_LEGACY
#include <GL/gl.h>
#include <GL/glx.h>
#include <GL/glext.h>
#include <GL/glxext.h>

// NVIDIA has not yet updated their include files. :-(
#ifndef GL_ARB_shader_storage_buffer_object
#define GL_SHADER_STORAGE_BUFFER          0x90D2
#endif

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

// Define storage buffer binding indices and attribute locations.
//
#define UNIF_IDX_BULDGE_LOC 0
#define UNIF_IDX_BULDGE_DIST_THRESH 1
#define UNIF_IDX_WIRE_RADIUS 2
#define ATTR_IDX_HELIX_INDICES 1
#define SB_COORD 1


enum Shader_Program
  { SP_Fixed, SP_Geo_Shade1, SP_Geo_Shade2, SP_ENUM_SIZE };
const char* const shader_program[] =
  { "SP_Fixed", "SP_Geo_Shade1", "SP_Geo_Shade2", "SP_ENUM_SIZE" };

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

  float opt_door_angle;

  pCoor light_location;
  float opt_light_intensity;

  pCoor helix_location;
  float helix_radius;   // Radius of helix.
  float wire_radius;    // Radius of wire forming helix.
  int seg_per_helix_revolution;
  int seg_per_wire_revolution;

  bool coords_stale;
  bool buffer_objects_stale;

  PStack<int> helix_indices;
  GLuint helix_indices_bo;

  // Coordinates of helix. (Helix runs through center of wire.)
  //
  PStack<pCoor> helix_coords;
  GLuint helix_coords_bo;
  int helix_coords_size;

  PStack<int> wire_surface_indices;
  GLuint wire_surface_indices_bo;
  int wire_surface_indices_size;

  // Wire normals.
  //
  PStack<pVect> helix_normals;
  GLuint helix_normals_bo;

  int helix_indices_size;

  int opt_shader;

  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_geo_shade1;
  pShader *sp_geo_shade2;

  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  GLuint texture_id_syllabus;
};

void
World::init()
{
  coords_stale = true;

  opt_door_angle = 0.0;
  variable_control.insert_linear(opt_door_angle,"Door Angle",M_PI/40.0);

  seg_per_helix_revolution = 80;
  seg_per_wire_revolution = 20;
  variable_control.insert(seg_per_helix_revolution,"Seg Per Helix Rev");
  variable_control.insert(seg_per_wire_revolution,"Seg Per Wire Rev");

  buffer_objects_stale = true;
  helix_normals_bo = 0;
  helix_coords_bo = 0;
  wire_surface_indices_bo = 0;

  eye_location = pCoor(2.6,5.7,3.8);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 1.5;
  light_location = pCoor(12.2,4.0,6.9);

  helix_location = pCoor(0,0,-5);
  helix_radius = 5;
  wire_radius = 0.5;

  //  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;

  texture_id_syllabus = pBuild_Texture_File("hw03.png",false,255);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  const char* const file = "hw3-shdr.cc";

  sp_geo_shade1 = new pShader
    (file,           // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "gs_main_helix();",
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  sp_geo_shade2 = new pShader
    (file,  // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "gs_main_helix2();",
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  opt_shader = SP_Geo_Shade1;

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

  ogl_helper.fbprintf("Active Shader Program: %s  (s TO CHANGE)\n",
                      shader_program[opt_shader]);

  if ( !sp_geo_shade1->pobject )
    ogl_helper.fbprintf
      ("Programmable GPU API: %savailable.  GPU Code: %s\n",
       ptr_glCreateShader ? "" : "not",
       sp_geo_shade1->pobject ? "okay" : "problem");

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

  // Set lighting parameters for when shader is not used, as for the
  // big triangle.
  //
  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);

  pError_Check();

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Set parameter for texture unit.
  //
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  sp_fixed->use();

  ///
  /// Paint Single Triangle.
  ///

  pColor color_tri(0x7815b6); // Red, Green, Blue
  glColor3fv( color_tri );

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  // Specify vertices for a triangle.
  //

  pCoor p1( 9.5, -5, -1.2 );
  pCoor p2( 0,    5, -3 );
  pCoor p3( 9,    6, -7 );
  pNorm triangle_normal = cross(p3,p2,p1);

  // Specify normal and vertex using course-defined objects pCoor and
  // pNorm. OpenGL sees these as pointers to floats.

  glNormal3fv(triangle_normal);
  glTexCoord2f(0.95,1.0); glVertex3fv(p1);
  glTexCoord2f(0.00,0.1); glVertex3fv(p2);
  glTexCoord2f(0.90,0.0); glVertex3fv(p3);

  glEnd();

  glDisable(GL_TEXTURE_2D);


  ///
  /// Construct a Helix
  ///

  if ( coords_stale )
    {
      // Recompute helix coordinates, etc.

      coords_stale = false;
      buffer_objects_stale = true;

      // Reset existing storage.
      helix_coords.reset();
      helix_normals.reset();
      helix_indices.reset();
      wire_surface_indices.reset();

      // Number of times helix wraps around.
      const int revolutions_per_helix = 6;

      const int segments_per_helix =
        revolutions_per_helix * seg_per_helix_revolution;

      const double delta_eta = 2 * M_PI / seg_per_helix_revolution;
      const double delta_y = 4 * wire_radius / seg_per_helix_revolution;
      const double delta_theta = 2 * M_PI / seg_per_wire_revolution;

      int wire_surface_idx = 0;

      for ( int i = 0; i < segments_per_helix; i++ )
        {
          const bool last_i_iteration = i + 1 == segments_per_helix;

          const double eta = i * delta_eta;
          pCoor p0( helix_radius * cos(eta),
                    i * delta_y,
                    helix_radius * sin(eta));

          helix_coords += p0;

          pVect n0( -wire_radius * p0.x, 0, -wire_radius * p0.z);
          pNorm tangent( delta_eta * helix_radius * -sin(eta),
                         delta_y,
                         delta_eta * helix_radius * cos(eta) );
          pVect b = cross(n0,tangent);

          for ( int j = 0; j < seg_per_wire_revolution; j++ )
            {
              const int idx = wire_surface_idx++;
              const double theta = j * delta_theta;

              pVect norm0 = cos(theta) * n0 + sin(theta) * b;

              helix_normals += norm0.normal();
              helix_indices += i;  helix_indices += j;

              if ( last_i_iteration ) continue;

              // Insert indices for triangle with one vertex on eta.
              wire_surface_indices += idx; // This vertex.
              wire_surface_indices += idx + seg_per_wire_revolution;
            }
        }

      wire_surface_indices_size = wire_surface_indices.occ();
      helix_coords_size = helix_coords.occ();
      helix_indices_size = helix_indices.occ();
    }

  // If necessary, update data in buffer objects.
  if ( buffer_objects_stale )
    {
      buffer_objects_stale = false;

      // Generate buffer id (name), if necessary.
      //
      glGenBuffers(1,&helix_indices_bo);
      glGenBuffers(1,&helix_coords_bo);
      glGenBuffers(1,&helix_normals_bo);
      glGenBuffers(1,&wire_surface_indices_bo);

      glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*4*sizeof(helix_coords[0]),
         helix_coords.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         2 * helix_indices_size * sizeof(helix_indices[0]),
         helix_indices.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_indices_size*3*sizeof(helix_normals[0]),
         helix_normals.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, wire_surface_indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         wire_surface_indices_size*sizeof(wire_surface_indices[0]),
         wire_surface_indices.get_storage(),GL_STATIC_DRAW);

      // Tell GL that subsequent array pointers refer to host storage.
      //
      glBindBuffer(GL_ARRAY_BUFFER, 0);

      pError_Check();
    }

  switch ( opt_shader ){
  case SP_Fixed: break;
  case SP_Geo_Shade1: sp_geo_shade1->use(); break;
  case SP_Geo_Shade2: sp_geo_shade2->use(); break;
  default: ASSERTS( false );
  }

  ///
  /// Paint a Helix
  ///

  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_COORD,helix_coords_bo);

  glUniform1f(UNIF_IDX_WIRE_RADIUS,wire_radius);  GE();

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  glTranslatef(helix_location.x,helix_location.y,helix_location.z);
  glRotatef(60,0,1,0);

  // Specify color. Since it's not an array the same color
  // will be used for all vertices, which is what we want.
  // If we wanted to vary vertex colors we could have created
  // and used a color array.
  //
  glColor3fv(lsu_spirit_gold);

  // Specify buffer object to use for normals.
  //
  glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
  glNormalPointer(GL_FLOAT,0,0);
  glEnableClientState(GL_NORMAL_ARRAY);

  glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
  glEnableVertexAttribArray(ATTR_IDX_HELIX_INDICES);
  glVertexAttribIPointer
    (ATTR_IDX_HELIX_INDICES,
     2, // Two components (as in a 2-element vector).
     GL_INT,
     0, // Tightly packed.
     0);

  glBindBuffer(GL_ARRAY_BUFFER, 0); // Avoid surprises.

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, wire_surface_indices_bo);

  glDrawElements(GL_TRIANGLE_STRIP,wire_surface_indices_size,GL_UNSIGNED_INT,0);

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableVertexAttribArray(ATTR_IDX_HELIX_INDICES);

  glPopMatrix();

  sp_fixed->use();

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

  case 's':
    opt_shader++; if ( opt_shader == SP_ENUM_SIZE ) opt_shader = 1;
    break;
  case 'S':
    if ( opt_shader == 1 ) opt_shader = SP_ENUM_SIZE;
    opt_shader--;
    break;

  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;

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
