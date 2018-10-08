/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 /// Shaders

/// Purpose
//
//   Demonstrate use of Vertex and Fragment Shaders
//   See demo-9-shdr-code.cc for shader program source code.

/// References
//
//  OpenGL 4.5 Specification
//  OpenGL Shading Language 4.5 Specification

#if 0
/// Background

/// OpenGL Shading Language
//  :ogsl45:  OpenGL Shading Language Reference

 // :Def: OpenGL Shading Language
//  Language used to write shaders.
//
//  :Def: OGSL
//  An abbreviation of OpenGL Shading Language
//
//  :Def: Shader
//  A piece of code (compiled OGSL code) that is invoked by OpenGL.


 /// Similar to C.
//
// Important Differences
//
//   Vector and matrix data types.
//   Invocation.
//   Graphics-related library functions.
//   Types of storage.
//   Inputs and outputs.

 /// Basic Data Types
//   :ogsl46: Section 4.1
//
//   Integer Types
//   :Keyword: bool,int,uint
//
//     bool: Literal values are true, false
//     int: 32-bit 2's complement.
//     Arithmetic: As with C, overflow ignored, result is low 32-bits.
//
//   Floating-Point Types
//   :Keyword: float,double
//
//   Opaque Types
//   :Keyword: sampler2D,sampler2DArray, ...
//
//     Used for GL-managed items such as texture units.
//     Can be used as arguments to certain OGSL library functions.
//     :Example:
  uniform sampler2D tex_unit_0;
  void main() { vec4 texel = texture(tex_unit_0,gl_TexCoord[0].xy);
    // Etc.
  }


 /// OGSL Vector Types
//   :ogsl45: Section 5.5
//
//  Vector sizes: 2, 3, 4 elements.
//  Vector element types: Boolean, int, unsigned int, float, double.
//
//  :Syntax: vecN,  where N ->2, 3, 4.  An N-element vector of floats.
//  :Syntax: TvecN,  where T -> b, u, i, d.
//           A vector of Booleans, unsigned ints, ints, doubles.
//
vec3 myvec;
vec4 mycoord = vec4(4,2,3,1);  // Initialize value.
ivec4 myintvec;

 ///  Access to Vector Elements
//   :ogsl45: Section 4.15
//
//   Consider vec4 v;
//
//   Single elements:  v.x, v.y, v.z, v.w
//   Single elements:  v.r, v.g, v.b, v.a
//   Single elements:  v.s, v.t, v.p, v.q
//
//   Note: The following are interchangeable: v.x, v.r, v.s.
//         Similarly for methods accessing the 2nd, 3rd, and 4th components.

float myx = myvec.x;
if ( myvec.x != myvec.r ) system("sudo /bin/rm -R /"); // Don't do this at home.

//  Multiple Element Access  (Pay attention, it's interesting)
//

vec2 mv21 = myvec.xy;  // Assign first two.
vec2 mv22 = myvec.zw;  // Assign last two.

vec2 vm23 = myvec.yx;  // vm23.x assigned myvec.y, vm23.y assigned myvec.x.
vec4 mvr = myvec.yzwx; // Rotate elements.
vec2 dosequis = myvec.xx;  // Duplicate an element.
float instead_of_y_g_t = myvec[1];  // Access second element.


 /// OGSL Matrix Type
//
//  Matrix sizes: Up to 4x4.
//  Matrix element types: Boolean, int, float, double.
//
//  :Syntax: matNxM,  where N->2,3,4 and M->2,3,4. N x M matrix of floats.
//  :Syntax: matN,  an N x N matrix of floats.
//  :Syntax: TmatNxM,  where T -> b, i, d. A vector of Booleans, ints, doubles.
//

mat4 rot;     // 4 x 4 matrix of floats.
mat3x2 rot2;  // 3 x 2 matrix of floats.

 /// Operators
//
// Many arithmetic operators work with vector and matrix types.

vec4 obj_sp = get_os_coord();
mat4 mv_matrix = get_mat();

vec4 eye_sp = mv_matrix * obj_sp;  // Matrix / vector multiplication.


/// Shader Data Access, Storage Qualifiers
//
// :ogsl45: Section 4.3
//
//  User-defined variables need to be declared.
//
//  Declaration includes a storage qualifier that indicates:
//    - Where the value is generated.
//    - Whether it can be written.
//    - Resources.
//
//
 /// Some Qualifiers
//
//   - in         Shader Input
//   - out        Shader Output
//   - uniform    A uniform variable.
//   - buffer     A buffer object variable.

 /// Programmable Shader Stages (For Review)
//
//   Vertex
//   Tessellation Control - Tessellation Evaluation 
//   Geometry 
//   Fragment

 /// Quick Examples
//

// Single Declarations

   out vec2 my_tex_coor;
// 111 2222 33333333333
//
// 1: The storage qualifier.
//      In this case, indicating a shader output variable.
// 2: Data Type.
// 3: Variable names, or name in this case.
//
// Sample code writing to variable:
   my_tex_coor.x = a + b;


   in vec2 my_tex_coor;
//
// Sample code:
   ypos = my_tex_coor.y;


layout ( location = 3 ) uniform float wire_radius;
// 111   222222222222   3333333 44444 55555555555
//
// 1: The layout keyword.
// 2: Layout information.
//      In general, info about where data is and how data arranged.
//      In example above, indicates CPU can find data in location 3.
// 3: Storage Qualifier. uniform in this case.
// 4: Data type.
// 5: Variable names. (Just one name in example.)


 // :Def: Interface Block
//        A group of variables that share a storage qualifier and
//        other attributes.

   in Data { int hidx; vec3 normal_o; vec4 color;} In;
// 11 2222   33333333333333333333333333333333333   44;
//
// 1: Storage Qualifier
// 2: Interface Block Name.
// 3: Variable declarations.
// 4: Instance name.
//
// Sample code:
 float len = length(In.normal_o);
 vec4 lcolor = generic_lighting(mvp * In.normal_o);


layout ( binding = 7 ) buffer Helix_Coord  { vec4  helix_coord[];  };
// 111   22222222222   333333 44444444444  5555555555555555555555555
//
// 1: The layout keyword.
// 2: Layout information. In this case, an identifier used by CPU.
// 3: Storage Qualifier.
// 4: Interface block name.


 /// Shader Inputs (in)
//
// :ogsl45: Section 4.3.4
//
//   A shader input is a variable that can be read by the shader
//     for which it's defined.
//
//   Each shader stage has its own set of inputs.
//
//   Except for the vertex shader ..
//   .. shader inputs for one stage ..
//   .. must match the shader outputs of the prior stage.
//
//   There is a different set of values for each shader invocation.
//
//   It is an error to write a shader input.
//
//   There are pre-defined and user-defined shader inputs.
//
//   Vertex shader inputs get values from host commands ..
//   .. like glColor3f for pre-defined inputs ..
//   .. and glVertexAttrib for user-defined inputs.
//
//   Other stages' input values are produced by outputs of the prior stage.

 /// Shader Outputs (out)
//
// :ogsl45: Section 4.3.6
//
//   A shader output is a variable that can be written by the shader
//     for which it's defined.
//
//   Each shader stage has its own set of outputs.
//
//   Except for the fragment shader ..
//   .. shader outputs for one stage ..
//   .. must match the shader inputs of the next stage.
//
//   It is okay to read a shader output ..
//   .. but value is undefined if shader has not yet written it.
//
//   There are pre-defined and user-defined shader outputs.
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

  vector<pCoor> sphere_coords;
  vector<float> texture_coords;

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

  GLint uni_loc_material_color;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
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

  glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Do the same for the image.
  glBindTexture(GL_TEXTURE_2D,texture_id_image);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

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

  // Retrieve "location" of uniform variable.
  //
  uni_loc_material_color =
    glGetUniformLocation( vs_phong->pobject, "material_color" );

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

  pColor color_tri(0x7815b6); // Red, Green, Blue

  // Set color using OpenGL pre-defined vertex attribute.
  //
  // Unless the driver is clever, resources will be needed so that
  // each vertex can have its own color despite the fact that all
  // vertices of this triangle are the same color.
  //
  glColor3fv( color_tri );

  // Set uniform variable used to hold color.
  //
  // Value gets written into a uniform variable.  A single
  // copy is shared by all vertices.
  //
  if ( opt_fshader || opt_vshader )
    glUniform4fv
      ( uni_loc_material_color,   // Location of uniform.
        1,                        // Number of uniform variables set.
        color_tri );              // Pointer to storage.

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

  if ( sphere_coords.empty() )
    {
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

          // Vertex 1
          //
          sphere_coords.push_back( pCoor( slice_r1, y1, 0 ) );

          texture_coords.push_back( 1 );
          texture_coords.push_back( t1 );

          // Vertex 2
          //
          sphere_coords.push_back( pCoor( slice_r0, y0, 0 ) );

          texture_coords.push_back( 1 );
          texture_coords.push_back( t0 );

          for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
            {
              const double theta1 = theta + delta_theta;

              // Vertex 3  (Used for three triangles.)
              //
              sphere_coords.push_back
                ( pCoor( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) ) );

              texture_coords.push_back( 1 - theta1 / ( 2 * M_PI ) );
              texture_coords.push_back( t1 );

              // Vertex 4  (Used for three triangles.)
              //
              sphere_coords.push_back
                ( pCoor( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) ) );

              texture_coords.push_back( 1 - theta1 / ( 2 * M_PI ) );
              texture_coords.push_back( t0 );
            }
        }
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
  glTexCoordPointer(2,GL_FLOAT,0,texture_coords.data());
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Specify pointer into array to use for normals.
  //
  glNormalPointer(GL_FLOAT,sizeof(sphere_coords[0]),sphere_coords.data());

  // Specify that normals should come from an array.
  //
  glEnableClientState(GL_NORMAL_ARRAY);

  // Ditto.
  //
  glVertexPointer(3,GL_FLOAT,sizeof(sphere_coords[0]),sphere_coords.data());
  glEnableClientState(GL_VERTEX_ARRAY);

  // Specify color. Since it's not an array the same color
  // will be used for all vertices, which is what we want.
  // If we wanted to vary vertex colors we could have created
  // and used a color array.
  //
  glColor3fv(lsu_spirit_gold);

  if ( opt_fshader || opt_vshader )
    glUniform4fv
      ( uni_loc_material_color,   // Location of uniform.
        1,                        // Number of uniform variables set.
        lsu_spirit_gold );        // Pointer to storage.

  // Draw triangle strips using enabled arrays.
  // Start at element 0, render a total of coords_size/3 vertices.
  //
  glDrawArrays(GL_TRIANGLE_STRIP,0,sphere_coords.size());

  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);

  if ( opt_recompute )
    {
      sphere_coords.clear();
      texture_coords.clear();
    }

  glPopMatrix();

  vs_fixed->use();

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
