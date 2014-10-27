/// LSU EE 4702-1 (Fall 2014), GPU Programming
//

 /// More Shaders

/// Purpose
//
//   Demonstrate use of Geometry Shaders
//   Demonstrates use of buffer storage objects.
//   See demo-10-shdr-simple.cc and demo-10-geo-code.cc for shader
//     program source code.

 ///  Note: Requires OpenGL 4.3

/// References
//
// :ogl45: OpenGL Specification Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf
//
// :sl45:  The OpenGL Shading Language - Language Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf

#if 0
/// Background

 /// New Material in Demo 10
 //

 /// glDrawElements
//   :ogl45: Section 10.4
//
//   Like glDrawArray, except that an index array is used.


 /// Vertex Attribute Arrays
 //
 //  :ogl45: Section 10.2.1
//
//   User-defined attributes.


 /// Accessing Buffer Objects in Shader Programs
 //
 //  :ogl45: Section 6.1.1
 //  :sl45:  Section 4.3.7

//   Within shader code, buffer objects accessed using same syntax
//   as arrays in the language C.
//
     vertex_o.xyz = helix_coord[hidx].xyz + radius * gl_Normal;


//   The declaration of buffer objects in shader code is much different
//   than C.
//
     layout ( binding = 1 ) buffer Helix_Coord  { vec4  helix_coord[];  };

//   One also has to tell the host code which shader variable to bind
//   to which buffer object.
//
     glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_COORD,helix_coords_bo);


 /// Interpolation Qualifiers
 //
 //  :sl45: Section 4.5
 //
 //  Used on fragment shader inputs and vertex or geometry shader outputs.
 //
 //  They specify how variables written by vertex or geometry shader ..
 //  .. should be interpolated to obtain values at input to fragment shader.
 //
 //  Options:
 //
 //    smooth:
 //       Linearly interpolate based on object-space coordinates.
 //       The default, produces best looking results.
 //
 //    noperspective:
 //       Linearly interpolate based on window-space coordinates.
 //       Won't look as good, but computationally less demanding.
 //
 //    flat:
 //       Don't interpolate, instead use value of provoking (last)
 //       vertex.
 //
 //  For an example, see demo-10-shdr-simple.cc.


 /// Geometry Shader Coding
//
//   Shader Input
//     Usually triangles.
//     DOES NOT have to match input primitive to current vertex shader.
//
//     Input is a single primitive, declared as an array. Array size
//     is number of elements in the primitive.

layout ( triangles ) in;

in Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  int hidx;
} In[3];


//   Shader Output
//     Usually triangles or triangle strips.
//     DOES NOT have to match input primitive to current vertex shader.
//
//     Output is a single vertex, declared of course as scalars.

layout ( triangle_strip, max_vertices = 4 ) out;


out Data
{
  vec3 var_normal_e;
  vec4 var_vertex_e;
  int hidx;
};




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
 //  VAR Light Intensity - The light intensity.
 //      Helix Segs Per Rev - The number of segments in one revolution of helix.
 //         A smaller number means fewer primitives.
 //      Wire Segs Per Rev - The number of segments in 1 revolution around wire.
 //         A smaller number means fewer primitives.


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
  { SP_Fixed, SP_Phong, SP_Vtx_Animation, SP_Geo_Shade,
    SP_Geo_Animation, SP_ENUM_SIZE };
const char* const shader_program[] =
  { "SP_Fixed", "SP_Phong", "SP_Vtx_Animation", "SP_Geo_Shade",
    "SP_Geo_Animation", "SP_ENUM_SIZE" };

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

  pCoor helix_location;
  float helix_radius;   // Radius of helix.
  float wire_radius;    // Radius of wire forming helix.
  int seg_per_helix_revolution;
  int seg_per_wire_revolution;

  float opt_bulge_dist_thresh;

  bool coords_stale;
  bool buffer_objects_stale;

  PStack<int> helix_indices;
  GLuint helix_indices_bo;

  // Coordinates of helix. (Helix runs through center of wire.)
  //
  PStack<pCoor> helix_coords;
  GLuint helix_coords_bo;
  int helix_coords_size;

  // Coordinates of surface of wire.
  //
  PStack<pVect> surface_coords;
  GLuint surface_coords_bo;

  PStack<int> wire_surface_indices;
  GLuint wire_surface_indices_bo;
  int wire_surface_indices_size;

  // Wire normals.
  //
  PStack<pVect> helix_normals;
  GLuint helix_normals_bo;

  int surface_coords_size;

  int opt_shader;

  pShader *sp_fixed;          // Fixed functionality.
  pShader *sp_phong;          // Phong shading.
  pShader *sp_vtx_animation;  // Compute animation using vertex shader.
  pShader *sp_geo_shade;      // Geometry shader to color adjacent triangles.
  pShader *sp_geo_animation;  // Geometry shader to help with animation.

  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  bool opt_sim_paused;
  double last_evolve_time;
  double sim_time;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  GLuint texture_id_syllabus;
};

void
World::init()
{
  opt_sim_paused = false;
  sim_time = 0;
  last_evolve_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  coords_stale = true;

  seg_per_helix_revolution = 40;
  seg_per_wire_revolution = 20;
  opt_bulge_dist_thresh = 2;
  variable_control.insert(seg_per_helix_revolution,"Helix Seg Per Rev");
  variable_control.insert(seg_per_wire_revolution,"Wire Seg Per Rev");
  variable_control.insert(opt_bulge_dist_thresh,"Buldge Distance");

  buffer_objects_stale = true;
  helix_normals_bo = 0;
  helix_coords_bo = 0;
  surface_coords_bo = 0;
  wire_surface_indices_bo = 0;

  eye_location = pCoor(2.6,5.7,15);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 1.5;
  light_location = pCoor(7,4.0,-0.3);

  helix_location = pCoor(0,0,-5);
  helix_radius = 5;
  wire_radius = 0.5;

  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;

  texture_id_syllabus = pBuild_Texture_File("gpup.png",false,255);

  // Declared like a programmable shader, but used for fixed-functionality.
  //
  sp_fixed = new pShader();

  sp_phong = new pShader
    ("demo-10-shdr-simple.cc",// File holding shader program.
     "vs_main_basic(); ",     // Name of vertex shader main routine.
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  sp_vtx_animation = new pShader
    ("demo-10-shdr-simple.cc",  // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  sp_geo_shade = new pShader
    ("demo-10-shdr-simple.cc", // File holding shader program.
     "vs_main_helix();",       // Name of vertex shader main routine.
     "gs_main_helix();",       // Name of geometry shader main routine.
     "fs_main_phong();"        // Name of fragment shader main routine.
     );

  sp_geo_animation = new pShader
    ("demo-10-shdr-geo.cc",   // File holding shader program.
     "vs_main_helix();",      // Name of vertex shader main routine.
     "gs_main_helix();",      // Name of geometry shader main routine.
     "fs_main_phong();"       // Name of fragment shader main routine.
     );

  if ( false )
    {
      printf("** Shader Variables **\n");

      sp_geo_animation->print_active_attrib();
      sp_geo_animation->print_active_uniform();
      sp_geo_animation->print_active_varying();
    }

  opt_shader = SP_Fixed;

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

  if ( !sp_phong->pobject )
    ogl_helper.fbprintf
      ("Programmable GPU API: %savailable.  GPU Code: %s\n",
       ptr_glCreateShader ? "" : "not",
       sp_phong->pobject ? "okay" : "problem");

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

  // Normalize normals after transformation to eye space.
  //
  glEnable(GL_NORMALIZE);

  // Set parameters that apply to a texture (texture_id_syllabus).
  //
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR );
  glTexParameteri
    (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );

  // Set parameter for texture unit.
  //
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  const bool shader_requested = opt_shader != SP_Fixed;

  if ( shader_requested )
    {
      // Install the "phong" shader for the triangle.
      // A different shader program will be used for the helix.
      //
      sp_phong->use();
    }
  else
    {
      // Set all programmable units to use fixed functionality.
      //
      sp_fixed->use();
    }

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
      surface_coords.reset();
      wire_surface_indices.reset();

      // Number of times helix wraps around.
      const int revolutions_per_helix = 6;

      const int segments_per_helix =
        revolutions_per_helix * seg_per_helix_revolution;

      const double delta_eta = 2 * M_PI / seg_per_helix_revolution;
      const double delta_y = 4 * wire_radius / seg_per_helix_revolution;
      const double delta_theta = 2 * M_PI / seg_per_wire_revolution;

      for ( int i = 0; i < segments_per_helix; i++ )
        {
          const bool last_i_iteration = i + 1 == segments_per_helix;
          const double eta = i * delta_eta;
          const float cos_eta = cosf(eta);
          const float sin_eta = sinf(eta);

          pCoor p0( helix_radius * cos_eta,
                    i * delta_y,
                    helix_radius * sin_eta);

          helix_coords += p0;

          pVect n0( -wire_radius * cos_eta, 0, -wire_radius * sin_eta);
          pNorm tangent( delta_eta * helix_radius * -sin_eta,
                         delta_y,
                         delta_eta * helix_radius * cos_eta );
          pVect b = cross(n0,tangent);

          for ( int j = 0; j < seg_per_wire_revolution; j++ )
            {
              const int idx = surface_coords.occ();
              const double theta = j * delta_theta;

              pVect norm0 = cos(theta) * n0 + sin(theta) * b;

              helix_normals += norm0.normal();
              helix_indices += i;

              // Compute surface coordinate. This computation can also
              // be done by the vertex shader, when that feature is
              // turned on the two lines below are not needed.
              //
              pCoor s0 = p0 + norm0;
              surface_coords += s0;

              if ( last_i_iteration ) continue;

              // Insert indices for triangle with one vertex on eta.
              wire_surface_indices += idx; // This vertex.
              wire_surface_indices += idx + seg_per_wire_revolution;
            }
        }

      wire_surface_indices_size = wire_surface_indices.occ();
      helix_coords_size = helix_coords.occ();
      surface_coords_size = surface_coords.occ();
    }

  // If necessary, update data in buffer objects.
  if ( buffer_objects_stale )
    {
      buffer_objects_stale = false;

      // Generate buffer id (name), if necessary.
      //
      if ( !surface_coords_bo )
        {
          glGenBuffers(1,&helix_indices_bo);
          glGenBuffers(1,&helix_coords_bo);
          glGenBuffers(1,&surface_coords_bo);
          glGenBuffers(1,&helix_normals_bo);
          glGenBuffers(1,&wire_surface_indices_bo);
        }

      // Tell GL that subsequent array pointers refer to this buffer.
      //
      glBindBuffer(GL_ARRAY_BUFFER, surface_coords_bo);

      // Copy data into buffer.
      //
      glBufferData
        (GL_ARRAY_BUFFER,               // Kind of buffer object.
         // Amount of data (bytes) to copy.
         surface_coords_size*3*sizeof(surface_coords[0]),
         surface_coords.get_storage(),  // Pointer to data to copy.
         GL_STATIC_DRAW);               // Hint about who, when, how accessed.

      glBindBuffer(GL_ARRAY_BUFFER, helix_coords_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         helix_coords_size*4*sizeof(helix_coords[0]),
         helix_coords.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         surface_coords_size*sizeof(helix_indices[0]),
         helix_indices.get_storage(), GL_STATIC_DRAW);

      glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
      glBufferData
        (GL_ARRAY_BUFFER,
         surface_coords_size*3*sizeof(helix_normals[0]),
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

  /// Switch to selected set of shader programs.
  //
  switch ( opt_shader ){

  case SP_Fixed: case SP_Phong: 
    // The current shader is the one we want, don't change it.
    break;

  case SP_Vtx_Animation: 
    sp_vtx_animation->use(); break;

  case SP_Geo_Shade: 
    sp_geo_shade->use(); break;

  case SP_Geo_Animation: 
    sp_geo_animation->use(); break;

  default: ASSERTS( false );
  }

  ///
  /// Paint a Helix
  ///

  if ( !opt_sim_paused )
    {
      const double now = time_wall_fp();
      sim_time += now - last_evolve_time;
      last_evolve_time = now;
    }

  const float bulge_pos = fmodf( sim_time * 5.0f, helix_coords_size);

  if ( shader_requested )
    {
      glBindBufferBase(GL_SHADER_STORAGE_BUFFER,SB_COORD,helix_coords_bo);

      glUniform1f(UNIF_IDX_BULDGE_LOC,         bulge_pos);              GE();
      glUniform1f(UNIF_IDX_BULDGE_DIST_THRESH, opt_bulge_dist_thresh);  GE();
      glUniform1f(UNIF_IDX_WIRE_RADIUS,        wire_radius);            GE();
    }

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();

  glTranslatef(helix_location.x,helix_location.y,helix_location.z);
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
  if ( opt_shader <= SP_Phong )
    {
      glBindBuffer(GL_ARRAY_BUFFER, surface_coords_bo);
      glVertexPointer(3,GL_FLOAT,3*sizeof(float),0);
      glEnableClientState(GL_VERTEX_ARRAY);
    }

  // Specify buffer object to use for normals.
  //
  glBindBuffer(GL_ARRAY_BUFFER, helix_normals_bo);
  glNormalPointer(GL_FLOAT,0,0);
  glEnableClientState(GL_NORMAL_ARRAY);

  if ( opt_shader >= SP_Vtx_Animation )
    {
      glBindBuffer(GL_ARRAY_BUFFER, helix_indices_bo);
      glEnableVertexAttribArray(ATTR_IDX_HELIX_INDICES);
      glVertexAttribIPointer
        (ATTR_IDX_HELIX_INDICES,
         1, // One component. (Would be 3 for a 3-element vector).
         GL_INT,
         0, // Tightly packed.
         0);
    }

  glBindBuffer(GL_ARRAY_BUFFER, 0); // Avoid surprises.

  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, wire_surface_indices_bo);

  pError_Check();
  glDrawElements(GL_TRIANGLE_STRIP,wire_surface_indices_size,GL_UNSIGNED_INT,0);
  pError_Check();

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
  const bool shift = ogl_helper.keyboard_shift;
  const float move_amt = shift ? 2.0 : 0.4;

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
    opt_shader++; if ( opt_shader == SP_ENUM_SIZE ) opt_shader = 0;
    break;
  case 'S':
    if ( opt_shader == 0 ) opt_shader = SP_ENUM_SIZE;
    opt_shader--;
    break;

  case 'b': case 'B': opt_move_item = MI_Ball; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;

  case 'p': case 'P':
    if ( opt_sim_paused ) last_evolve_time = time_wall_fp();
    opt_sim_paused = !opt_sim_paused;
    break;
  case ' ': opt_sim_paused = true; sim_time += 0.1; break;

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
