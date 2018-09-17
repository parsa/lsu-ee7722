/// LSU EE 4702-1 (Fall 2018), GPU Programming
//
 /// Vertex Arrays, Buffer Objects


/// Purpose
//
//   Demonstrate use of Vertex Arrays and Buffer Objects

#if 0
///
/// Background
///

 /// References
//
// :ogl45: OpenGL Specification Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf
//

 /// The Vertex Specification (Pulling) Related Issues
 //
 //  A scene to be rendered has many vertices ..
 //  .. and so the overhead of handling those vertices must be kept small.
 //
 //
 // :Def: Vertex Pulling
 //  The transfer of vertices into the rendering pipeline.


 //  -- Vertex Processing
 //  -- Vertex Specification: Telling OpenGL about the vertices.
 //  -- Moving the vertex from the CPU to the GPU.

 /// Vertex Processing
 //
 //  Each vertex handled by a routine called a /vertex shader/.
 //
 //  Would like to avoid redundancy when multiple primitives share
 //    a vertex.

 /// Vertex Specification
 //
 //  Goal is to minimize function-call and data movement overhead.
 //
 //  Handling is most efficient when vertex data in dense arrays.

 /// Vertex Staging
 //
 //  Goal is to minimize CPU -> GPU copying, since that's slow.


 /// Techniques
 //

 //  -- Shared-Vertex Primitives
 //  -- Client Arrays (VERTEX_ARRAY, etc.)
 //  -- Strided and indirect vertex arrays.
 //  -- Buffer Objects.


/// Data Bandwidth
//
//  PCie v4 x16:            30 GB/s
//  Pascal-generation GPU: 300 GB/s



/// Vertex Arrays
//
// :ogl45: Section 10.3, 10.4

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
 //  'm'    Change method used to specify vertices.
 //  'r'    Toggle vertex re-computation on and off.
 //  'Ctrl' '+'  or  'Ctrl' '=',  and  'Ctrl' '-'  or  'Ctrl' '_', 
 //         Increase and decrease green text size.
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

enum VTX_Spec_Method { VM_Individual, VM_Strip, VM_Array, VM_Buffer, VM_SIZE };
const char* const spec_method_str[] =
  {"INDIVIDUAL", "STRIP", "ARRAY", "BUFFER"};

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
  bool gpu_buffer_stale;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;

  vector<pCoor> sphere_coords;

  int opt_slices;
  pCoor sphere_location;
  float sphere_size;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;

  int opt_method;
  bool opt_recompute;

  bool opt_scene, opt_ambient, opt_specular, opt_diffuse, opt_emissive;
  float opt_shininess;

  int pf_vertices;
  int pf_triangles;
  int pf_fragments;
  int pf_gpu_cpu_bytes;
  int pf_mem_gpu_bytes;

};

void
World::init()
{
  frame_timer.work_unit_set("Steps / s");
  gpu_buffer = 0;
  gpu_buffer_stale = true;

  opt_method = 0;
  opt_recompute = true;

  eye_location = pCoor(2.6,0.5,9);
  eye_direction = pVect(0,0,-1);

  opt_light_intensity = 7.2;
  light_location = pCoor(7,4.0,-0.3);

  sphere_location = pCoor(0,0,-5);
  sphere_size = 5;
  opt_slices = 20;
  variable_control.insert(opt_slices,"Sphere Slices (level of detail)");

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

  const double time_now = time_wall_fp();
  const bool blink_visible __attribute__((unused)) = int64_t(time_now*3) & 1;
# define BLINK(txt,pad) ( blink_visible ? txt : pad )

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Compiled: %s\n",
#ifdef __OPTIMIZE__
     "WITH OPTIMIZATION"
#else
     BLINK("WITHOUT OPTIMIZATION","")
#endif
     );

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]  "
     "Light location: [%5.1f, %5.1f, %5.1f]  "
     "Sphere Location[%5.1f, %5.1f, %5.1f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z,
     light_location.x, light_location.y, light_location.z,
     sphere_location.x, sphere_location.y, sphere_location.z);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->get_val());


  ogl_helper.fbprintf
    ("Vertex Specification Method: %s ('m' to change),  Recompute Coords: %s ('r')\n",
     spec_method_str[opt_method], opt_recompute ? "YES" : "NO");

  ogl_helper.fbprintf
    ("Estimated triangles: %8s  Vertices: %8s  Data: %7.3f kiB/frame\n",
     commaize(pf_triangles).c_str(),
     commaize(pf_vertices).c_str(), pf_gpu_cpu_bytes / 1024.0);


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

  if ( sphere_coords.empty() )
    {
      /// Initialize array coords with sphere's coordinates.
      // 

      const double delta_eta = M_PI / opt_slices;

      for ( double eta = 0; eta < M_PI - 0.0001 - delta_eta; eta += delta_eta )
        {
          const double eta1 = eta + delta_eta;
          const float  y0 = cos(eta),        y1 = cos(eta1);
          const double slice_r0 = sin(eta),  slice_r1 = sin(eta1);
          const double delta_theta = delta_eta * slice_r1;

          // Add first two vertices of triangle strip.
          // Note that a vertex is added to list one coordinate at a time.
          //

          // Vertex 1
          //
          sphere_coords.push_back( pCoor( slice_r1, y1, 0 ) );

          // Vertex 2
          //
          sphere_coords.push_back( pCoor( slice_r0, y0, 0 ) );

          for ( double theta = 0; theta < 2 * M_PI; theta += delta_theta )
            {
              const double theta1 = theta + delta_theta;

              // Vertex 3  (Used for three triangles.)
              //
              sphere_coords.push_back
                ( pCoor( slice_r1 * cos(theta1), y1, slice_r1 * sin(theta1) ) );

              // Vertex 4  (Used for three triangles.)
              //

              sphere_coords.push_back
                ( pCoor( slice_r0 * cos(theta1), y0, slice_r0 * sin(theta1) ) );
            }

        }

    }

  ///
  /// Send Vertices to OpenGL in One of Several Ways
  ///

  // Note: The data in coords is for multiple triangle strips (one
  // for each eta). The code below assumes just one triangle strip,
  // and so rendering will not be 100% correct.

  // Size of vertex coordinate or normal.
  const int pf_bytes_per_vec3 = 3 * sizeof(float);
  const int coords_size = sphere_coords.size();

  switch ( opt_method ) {

  case VM_Individual:
    {
      /// Use Individual Triangles

      // Data sent one vertex at a time. This is the slowest option
      // because of the overhead needed to send data to the GPU and
      // toss it in the rendering pipeline.

      glBegin(GL_TRIANGLES);
      glColor3fv(lsu_spirit_gold);
      for ( int i=0; i<coords_size-2; i++ )
        {
          glNormal3fv( sphere_coords[i] );
          glVertex3fv( sphere_coords[i + 0] );
          glVertex3fv( sphere_coords[i + 1 + ( i & 1 ) ] );
          glVertex3fv( sphere_coords[i + 2 - ( i & 1 ) ] );
        }
      glEnd();

      // Performance factors to show in green text.
      //
      pf_vertices = coords_size * 3;
      pf_triangles = coords_size;
      pf_gpu_cpu_bytes =  // Excludes command overhead, which is large here.
          (   3 * pf_triangles * pf_bytes_per_vec3  // Vertices
            +     pf_triangles * pf_bytes_per_vec3  // Normals
              );

      break;
    }

  case VM_Strip:
    {
      /// Use Individual Vertices

      // Data sent one vertex at a time. This is the slowest option
      // because of the overhead needed to send data to the GPU and
      // toss it in the rendering pipeline.

      glBegin(GL_TRIANGLE_STRIP);
      glColor3fv(lsu_spirit_gold);
      for ( int i=0; i<coords_size; i++ )
        {
          glNormal3fv( sphere_coords[i] );
          glVertex3fv( sphere_coords[i] );
        }
      glEnd();

      // Performance factors to show in green text.
      //
      pf_vertices = coords_size;
      pf_triangles = coords_size;
      pf_gpu_cpu_bytes =  // Excludes command overhead, which is large here.
          (   pf_triangles * pf_bytes_per_vec3  // Vertices
            + pf_triangles * pf_bytes_per_vec3  // Normals
              );

      break;
    }

  case VM_Array:
    {
      /// Use Vertex Arrays

      // Provide OpenGL with one array of vertices and one array of
      // normals.  This avoids function-call and other overheads, and
      // allows for efficient means of transferring large amounts
      // of information.

      // With vertex arrays glBegin/glEnd is replaced by glDrawArrays...
      //  glVertex is replaced by glVertexPointer and glEnableClientState.


      /// Specify that vertices will come from an array.
      //
      glEnableClientState(GL_VERTEX_ARRAY);

      /// Specify pointer to the array of vertices.
      //
      glVertexPointer
          ( 3, GL_FLOAT, sizeof(sphere_coords[0]), sphere_coords.data());
      //    N  Type      Stride                    Pointer
      //
      // Args: N: 
      //         Number of dimensions.  Valid: 2-4.
      //       Type: 
      //         Data type. Other possibilities: GL_DOUBLE, GL_INT, ..
      //       Stride:
      //         Number of bytes between vertex i and i + 1.
      //         A value of 0 means set stride to N * sizeof(Type)
      //       Pointer:
      //         Address of first coordinate.

      // Ditto for normals.
      //
      glEnableClientState(GL_NORMAL_ARRAY);
      glNormalPointer( GL_FLOAT, sizeof(sphere_coords[0]),sphere_coords.data());
      //               Type      Stride                   Pointer
      //
      // Fewer arguments than glNormalPointer because normals always have
      // three dimensions.

      // Specify color without using an array.
      //
      // An array could have been used for colors too but that
      // is not needed here because all vertices are the same color.
      //
      glColor3fv(lsu_spirit_gold);

      /// Draw triangle strips using enabled arrays.
      //
      glDrawArrays(GL_TRIANGLE_STRIP, 0,         coords_size);
      //           Primitive          StartIdx   Count
      // Args:
      //
      //   Primitive:
      //     Type of primitive.
      //   StartIdx:
      //     Starting element index. A zero means the first element
      //     in the array specified using glVertexPointer, glNormalPointer, etc.
      //   Count:
      //     Number of vertices.

      // Turn off arrays.
      //
      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);

      // Performance factors to show in green text.
      //
      pf_vertices = coords_size;
      pf_triangles = coords_size;

      // Assuming that OpenGL does not recognize that normals and
      // vertices are sourced from the same address.
      //
      pf_gpu_cpu_bytes =  // Excludes command overhead, which is small here.
          (   pf_triangles * pf_bytes_per_vec3  // Vertices
            + pf_triangles * pf_bytes_per_vec3  // Normals
              );

      break;
    }

  case VM_Buffer:
    {
      /// Use Buffer Objects
      //
      // A buffer object is a chunk of storage managed by OpenGL.
      // The intent is to keep chunks of storage on GPU where they
      // can be re-used.

#ifdef XXX
      /// Steps:
      //
      ///  The steps shown below are samples, they are not executed here.

      //
      //  - Get a buffer object name.
      //    Just do this once.
      //
      glGenBuffers(n, &gpu_buffer);


      //  - Copy data from CPU into buffer object.
      //    Do this whenever data changes.
      //
      glBufferData
        (GL_ARRAY_BUFFER,   // Kind of buffer object.
         n_bytes ,          // Amount of data (bytes) to copy.
         data_ptr,          // Pointer to data to copy.
         GL_STATIC_DRAW);   // Hint about who, when, how accessed.

      //   - Use buffer object in place of a CPU (client) array.
      //     Do this each time a command, like glVertexPointer, reads
      //      array data.
      //
      glBindBuffer(GL_ARRAY_BUFFER, gpu_buffer);

      /// Note: The code above is an exampe, it doesn't execute. The real code
      /// appears below.

#endif

      // Performance factors to show in green text.
      //
      pf_vertices = coords_size;
      pf_triangles = coords_size;

      // Set up or update a buffer object to hold coordinates.
      //
      if ( gpu_buffer_stale )
        {
          // Generate buffer id (name), if necessary.
          //
          if ( !gpu_buffer ) glGenBuffers(1,&gpu_buffer);

          // Tell GL that subsequent array pointers refer to this buffer.
          //
          glBindBuffer(GL_ARRAY_BUFFER, gpu_buffer);

          // Copy data into buffer.
          //
          glBufferData
            (GL_ARRAY_BUFFER,           // Kind of buffer object.
             coords_size*sizeof(pCoor), // Amount of data (bytes) to copy.
             sphere_coords.data(),      // Pointer to data to copy.
             GL_STATIC_DRAW);           // Hint about who, when, how accessed.

          // Tell GL that subsequent array pointers refer to host storage.
          //
          glBindBuffer(GL_ARRAY_BUFFER, 0);

          // Indicate that we've updated the buffer.
          //
          gpu_buffer_stale = false;

          pf_gpu_cpu_bytes =  // Excludes command overhead, which is small here.
          (   pf_triangles * pf_bytes_per_vec3  // Vertices
            + 0                                 // Normals (uses vtx coord)
              );

        }
      else
        {
          pf_gpu_cpu_bytes = 0;
        }

      // Tell GL that subsequent array pointers refer to this buffer.
      //
      glBindBuffer(GL_ARRAY_BUFFER,gpu_buffer);

      // Specify array of vertices.
      //
      glVertexPointer( 3, GL_FLOAT, sizeof(pCoor), NULL);
      //               N  Type      Stride         Pointer
      //
      // Pointer indicates the starting point in the array buffer,
      // NULL (a zero) means start at the beginning.
      
      glEnableClientState(GL_VERTEX_ARRAY);

      // Ditto. Note that vertices and normals read from same buffer.
      //
      glNormalPointer(GL_FLOAT,sizeof(pCoor),NULL);
      glEnableClientState(GL_NORMAL_ARRAY);

      // Set vertex color the old-fashioned way. This color should
      // be sent to the GPU just once and used for all subsequent
      // vertices.
      //
      glColor3fv(lsu_spirit_gold);

      glDrawArrays(GL_TRIANGLE_STRIP,0,coords_size);

      // Tell GL that subsequent array pointers refer to host storage.
      //
      glBindBuffer(GL_ARRAY_BUFFER,0);
      // Don't forget to do this, since it affects glVertexPointer and
      // related calls.

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
      sphere_coords.clear();
      gpu_buffer_stale = true;
    }

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
  const float move_amt = 0.4;
  const int slices_prev = opt_slices;

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
  case 'm': opt_method++;
    if ( opt_method == VM_SIZE ) opt_method = 0;
    break;
  case 'M': if ( !opt_method ) opt_method = VM_SIZE;
    opt_method--;
    break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  if ( opt_slices != slices_prev )
    {
      sphere_coords.clear();
      gpu_buffer_stale = true;
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
# ifdef __OPTIMIZE__
  popengl_helper.ogl_debug_set(false);
# else
  popengl_helper.ogl_debug_set(true);
# endif

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
