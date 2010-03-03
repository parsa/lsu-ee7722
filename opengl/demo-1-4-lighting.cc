/// LSU EE 7700-1 (Sp 2010), GPU Microarchitecture
//
 /// Simple OpenGL

// $Id:$

 /// Purpose
//
//   Demonstrate simple lighting techniques.

//   The routine draws a gold tube pierced by a triangle. There is a
//   bright light in the tube that can dimmed, brightened, and moved
//   around.

 /// To compile and run:
//
//     make
//

 /// More Information
//
//  

#include <stdio.h>
#include <strings.h>
#include <stdlib.h>

#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>


 /// Vertex Object
//
// Holds coordinates, color, and normal.
//

class pVertex : public pCoor {
public:
  pVertex(float xp, float yp, float zp):pCoor(xp,yp,zp){};
  pVertex(float xp, float yp, float zp, uint32_t color):
    pCoor(xp,yp,zp){set_color(color);};
  pVertex(pCoor c, pVect n, uint32_t color)
    :pCoor(c),normal(n){set_color(color);}
  pVertex():pCoor(){};
  pVertex(pVertex *v){ *this = *v; }
  void set_color(uint32_t colorp)
  {
    color = colorp;
    red = float( 0xff & ( color >> 16 ) );
    green = float( 0xff & ( color >> 8 ) );
    blue = float( 0xff & color );
  }
  float red, green, blue;
  uint32_t color;
  pVect normal;
};

 /// Vertex List
//
// Declare vertex list types so that many vertices can easily be
// operated on.
//
class pVertex_List : public PStack<pVertex> {
public:
  pVertex_List():PStack<pVertex>(){};
  int append_vertex(pCoor& c, pVect& n, uint32_t color)
  {
    new (pushi()) pVertex(c,n,color);
    return occ() - 1;
  }
  int append_vertex(float x, float y, float z, uint32_t color)
  {
    new (pushi()) pVertex(x,y,z,color);
    return occ() - 1;
  }
};



// Add an unlighted tetrahedron to VTX_LIST at LOC of size SIZE.
//
void
insert_tetrahedron(pVertex_List& vtx_list, pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
  const int32_t c1 = 0x1ffffff, c2 = 0x100ff00;
  pVect n;
# define TRI(va,vb,vc) \
  n = cross(va,vb,vc); \
  vtx_list.append_vertex(va,n,c1); \
  vtx_list.append_vertex(vb,n,c2); \
  vtx_list.append_vertex(vc,n,c2);
  TRI(v0,v1,v2); TRI(v0,v2,v3); TRI(v0,v3,v1);
# undef TRI
}


void
render_light(void *frame_buffer_ptr)
{
  pOpenGL_Helper& frame_buffer = *(pOpenGL_Helper*)frame_buffer_ptr;


  ///
  /// User and Light Locations
  ///

  static pCoor eye_location(1,0.5,3);
  static pVect eye_direction(0,0,-1);
  static pCoor light_location(1.4, 0, -2.5 );
  static bool opt_move_light = true;

  ///
  /// Light Location and Lighting Options
  ///

  static bool opt_attenuation = true;
  static bool opt_v_to_light = true;
  static bool opt_triangle_normal = false;
  static float opt_light_intensity = 2;


  ///
  /// Adjust options based on user input.
  ///

  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);

  switch ( frame_buffer.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -0.1; break;
  case FB_KEY_RIGHT: adjustment.x = 0.1; break;
  case FB_KEY_UP: adjustment.z = -0.1; break;
  case FB_KEY_DOWN: adjustment.z = 0.1; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -0.1; break;
  case FB_KEY_PAGE_UP: adjustment.y = 0.1; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case '-':case '_': opt_light_intensity *= 0.9; break;
  case '+':case '=': opt_light_intensity *= 1.1; break;
  case 'd': case 'D': opt_attenuation = !opt_attenuation; break;
  case 'a': case 'A': opt_v_to_light = !opt_v_to_light; break;
  case 'l': case 'L': opt_move_light = true; break;
  case 'n': case 'N': opt_triangle_normal = !opt_triangle_normal; break;
  case 'e': case 'E': opt_move_light = false; break;
  default: break;
  }

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(pVect(0,0,-1),eye_direction);
      user_rot_axis *= rotall;
      eye_direction *= pMatrix_Rotation(user_rot_axis, M_PI * 0.03);
    }

  pMatrix_Rotation rotall(eye_direction,pVect(0,0,-1));

  // Update eye_location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      adjustment *= rotall;
      if ( opt_move_light ) light_location += adjustment;
      else                  eye_location += adjustment;
    }

  //
  // User Messages  (Magically inserted into frame buffer.)
  //

  frame_buffer.fbprintf
    ("Lighting : distance - %s,  angle - %s,  normals - %s  "
     "('d', 'a', 'n', '+', '-' to change)\n",
     opt_attenuation ? "ON" : "OFF", opt_v_to_light ? "ON" : "OFF",
     opt_triangle_normal ? "TRIANGLE" : "VERTEX");

  frame_buffer.fbprintf
    ("Eye location: [%.1f, %.1f, %.1f]  "
     "(%suse arrow and page keys to move).\n",
     eye_location.x, eye_location.y, eye_location.z,
     opt_move_light ? "press 'e' then " : "" );

  frame_buffer.fbprintf
    ("Light location: [%.1f, %.1f, %.1f]  "
     "(%suse arrow and page keys to move).\n",
     light_location.x, light_location.y, light_location.z,
     opt_move_light ? "" : "press 'l' then ");

  frame_buffer.fbprintf
    ("Eye direction: [%.2f, %.2f, %.2f]  "
     "(use 'Home', 'End', 'Del', 'Insert' keys to turn).\n",
     eye_direction.x, eye_direction.y, eye_direction.z);

  // Instantiate list of vertices.
  //
  pVertex_List vtx_list;

  const uint32_t color_gold = 0xf9b237;    // LSU Spirit Gold
  const uint32_t color_purple = 0x580da6;  // LSU Spirit Purple

  // Insert big purple triangle into the vertex list.
  //
  {
    const int v0 = vtx_list.append_vertex( 1.5, 0, -3.2, color_purple );
    const int v1 = vtx_list.append_vertex( 0, 5, -5, color_purple );
    const int v2 = vtx_list.append_vertex( 9, 6, -9, color_purple );
    vtx_list[v0].normal = vtx_list[v1].normal = vtx_list[v2].normal
      = cross(vtx_list[v0],vtx_list[v1],vtx_list[v2]);
  }

  //
  // Insert a tessellated tube into the vertex list.
  //

  const float r = 2;                  // Tube radius.
  const float x_shift = 0.4;          // Tube x offset.
  const int pattern_levels = 50;      // Tube depth (z direction.)
  const float pattern_width = 20;     // Triangle size (circumferential).
  const float pattern_pitch_z = 0.25; // Triangle size (z axis).

  float z = -1;

  // Outer Loop: z axis (down axis of tube).
  //
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_z = z - pattern_pitch_z;
      const float last_z = z + pattern_pitch_z;
      const float delta_theta = M_PI / pattern_width;
      float theta = i & 1 ? delta_theta : 0;

      const uint32_t marker_color[] =
        {0xaa, 0xaa0000, 0x111111, 0xaa00,};
      // Port      Zenith    Nadir     Starboard
      // Left      Up        Down      Right
      // Red       Blue      Gray      Green
      float marker_target = i & 1 ? M_PI_2 - delta_theta - 0.00001 : 10000;
      int marker_idx = 0;

      // Inner Loop: around circumference of tube.
      //
      while ( theta < 4 * M_PI )
        {
          const float z1 = theta < 2 * M_PI ? next_z : last_z;
          uint32_t color = color_gold;

          if ( theta >= marker_target && marker_idx < 4 )
            {
              color = marker_color[marker_idx++];
              marker_target += M_PI_2;
            }

          const int v0 =
            vtx_list.append_vertex
            ( x_shift + r * cos(theta), r * sin(theta), z, color );
          if ( !opt_triangle_normal )
            vtx_list[v0].normal = pVect(-cos(theta),-sin(theta),0);

          theta += delta_theta;
          const int v1 =
            vtx_list.append_vertex
            ( x_shift + r * cos(theta), r * sin(theta), z1, color);
          if ( !opt_triangle_normal )
            vtx_list[v1].normal = pVect(-cos(theta),-sin(theta),0);

          theta += delta_theta;
          const int v2 =
            vtx_list.append_vertex
            ( x_shift + r * cos(theta), r * sin(theta), z, color );
          if ( !opt_triangle_normal )
            vtx_list[v2].normal = pVect(-cos(theta),-sin(theta),0);

          if ( opt_triangle_normal )
            vtx_list[v0].normal = vtx_list[v1].normal = vtx_list[v2].normal
              = cross(vtx_list[v0],vtx_list[v1],vtx_list[v2]);

        }
      z = next_z;
    }


  // Insert light position marker (green tetrahedron) into vertex list.
  //
  insert_tetrahedron(vtx_list,light_location,0.05);


  ///
  /// Rendering Pipeline Starts Here
  ///


  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();

#if 0
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Allocate and initialize a z buffer.
  // (Note: Allocation only needs be performed when size changes.)
  //
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;
#endif

  /// Replacement Code
  //
  //  Erase frame (color) and z buffer.
  //
  glClearColor(0,0,0,0.5);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );


  ///
  /// Compute Coordinate Transformations
  ///

  // Compute transformation from object space to eye space.
  //
  pMatrix_Translate ctr(-eye_location.x,-eye_location.y,-eye_location.z);
  pMatrix object_to_eye = rotall * ctr;

  // Compute transformation from eye space to window space.
  //
  const float aspect = float(win_width) / win_height;
  //  pMatrix_Frustum frustum(1.6,1.6/aspect,1,5000);
  pMatrix_Frustum frustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2);
  pMatrix eye_to_window = scale * center_window * frustum;

#if 0
  // Compute matrix needed to transform normals.
  //
  pMatrix normal_to_eye(object_to_eye);
  normal_to_eye.transpose(); normal_to_eye.invert3x3();
#endif
  
  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(object_to_eye);

  glMatrixMode(GL_PROJECTION);
  glLoadTransposeMatrixf(eye_to_window);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(-1,-0.5,-3);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Left, Right, Top, Bottom, Front, Back
  glFrustum(-0.8,+0.8,-0.8,0.8,1,5000);


  glViewport(0, 0, win_width, win_height);
  pError_Check();

  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_off[0]);

  if ( opt_v_to_light )
    {
      glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
      glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);
    }
  else
    {
      glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_off[0]);
      glLightfv(GL_LIGHT0, GL_AMBIENT, &light_intensity[0]);
    }

  if ( opt_attenuation )
    {
      glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
      glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);
    }
  else
    {
      glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 1);
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0);
      glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);
    }

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);


#if 1
  char* const v_list = (char*)vtx_list.get_storage();

  glNormalPointer(GL_FLOAT,0,v_list+32);
  glVertexPointer(3,GL_FLOAT,sizeof(pVertex),v_list);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_TRIANGLES,0,vtx_list.occ());
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
#endif


#if 0

  ///
  /// Transform Coordinates and Normals from Object Space to Eye Space
  ///
  while ( pVertex* const v = vtx_list.iterate() )
    {
      *v *= object_to_eye;
      v->normal *= normal_to_eye;
      v->normal.normalize();
      v->homogenize();
    }

  // Convert light location to eye space.
  //
  pCoor light_location_e = object_to_eye * light_location;


  ///
  /// Apply Lighting to Vertices
  ///
  while ( pVertex* const vptr = vtx_list.iterate() )
    {
      pVertex& v = *vptr;
      const bool vertex_no_lighting = v.color & 0x1000000;
      if ( vertex_no_lighting ) continue;

      // Compute vectors from vertex to light and to viewer.
      //
      pVect v_to_light(v,light_location_e);
      pVect v_to_viewer(v,pCoor(0,0,0));

      // Distance from vertex to light.
      //
      const float length = v_to_light.normalize();

      // Lighting coefficients and attenuation with distance.
      //
      const float k0 = 0.9;
      const float k1 = 0.0;
      const float k2 = 0.3;
      const float attenuation =
        !opt_attenuation ? 1.0
        : 1.0 / ( k0 + k1 * length + k2 * length * length );

      // Projections:
      //   1: vertex (normal) is facing light (or viewer).
      //   0: vertex (normal) is orthogonal (90 degrees) from light.
      //  -1: vertex (normal) is facing opposite direction of light.
      //
      const float dot_v_to_light = dot(v.normal,v_to_light);
      const float dot_v_to_viewer = dot(v.normal,v_to_viewer);

      // Assume back side (-normal direction) is same color as front.
      //
      const float v_to_light_scale =
        dot_v_to_viewer < 0 ? -dot_v_to_light : dot_v_to_light;

      // Combine effect of distance (attenuation) and surface normal
      // (v_to_light_scale).
      //
      const float scale = opt_light_intensity * attenuation
        * ( !opt_v_to_light ? 1.0 : v_to_light_scale );

      // Convert material property color to lighted color.
      //
      v.red *= scale;  v.green *= scale;  v.blue *= scale;
    }


  ///
  /// Transform Coordinates from Eye Space to Window Space
  ///
  while ( pVertex* const v = vtx_list.iterate() )
    {
      *v *= eye_to_window;
      v->homogenize_keep_w();
    }


  ///
  /// Rasterize Primitives
  ///
  while ( true )
    {
      pVertex* const u0 = vtx_list.iterate();
      if ( !u0 ) break;
      pVertex* const u1 = vtx_list.iterate();
      pVertex* const u2 = vtx_list.iterate();
      pSortVertices sort(u0,u1,u2); // Sort next 3 items in list.
      pVertex& c0w = sort;    // Coordinate with smallest y.
      pVertex& c1w = sort;
      pVertex& c2w = sort;    // Coordinate with largest y.

      // Reject primitive if at least one vertex behind eye.
      // (It would have been better to clip them earlier.)
      //
      if ( c0w.w <= 0 || c1w.w <= 0 || c2w.w <= 0 ) continue;

      // Instantiate interpolation objects.
      //
      // Each object instantiated with two vertices and a valid
      // range of y values.  The object will compute x and y along the
      // line connecting the vertices, skipping y values < 0 or
      // >= win_width.
      //
      // Interpolation objects also interpolate z and color components.
      //
      pInterpolate interp_02(c0w,c2w,0,win_height-1);
      pInterpolate interp_012(c0w,c1w,0,win_height-1);

      // Compute position (index) in frame buffer of first row to be written.
      //
      int fb_line_idx = interp_02.yi * win_width;

      // Outer Loop: Iterate from smallest y to largest y.
      //
      while ( interp_02.keep_going_y() )
        {

          // If point c1w reached then switch interp_012 to line
          // connecting c1w and c2w.
          //
          if ( ! interp_012.keep_going_y() )
            interp_012.set(c1w,c2w,0,win_height-1);

          // Instantiate x-axis interpolation object using the two
          // y-axis interpolation objects, interp_02 and interp_012.
          // The new object will compute points on the line connecting
          // the current position of interp_02 and interp_012.
          //
          pInterpolate interp_line(interp_02,interp_012,0,win_width-1);

          // Inner Loop: Iterate along x axis.
          //
          while ( interp_line.keep_going_x() )
            {
              const int fb_idx = fb_line_idx + interp_line.xi;

              // If z value to be written is smaller (in front of) z value
              // already there then go ahead and write frame buffer.
              //
              if ( interp_line.z < z_buffer[ fb_idx ] )
                {
                  f_buffer[ fb_idx ] = interp_line.color();
                  z_buffer[ fb_idx ] = interp_line.z;
                }

              // Tell interpolation object to advance in x direction.
              //
              interp_line.advance_x();
            }

          // Tell interpolation objects to advance in y direction.
          //
          interp_02.advance_y();  interp_012.advance_y();

          // Advance the frame buffer index.
          //
          fb_line_idx += win_width;
        }
    }

  // A paint routine is no place for a memory leak!
  // (And excessive dynamic memory allocation, but this is only a demo.)
  //
  free(z_buffer);
#endif

  pError_Check();

  glutSwapBuffers();

}

#if 0
void
render_light(void *frame_buffer_ptr)
{
  pOpenGL_Helper& frame_buffer = *(pOpenGL_Helper*)frame_buffer_ptr;

  glClearColor(0,0,0,0.5);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

  const float r = 2;                  // Tube radius.
  const float x_shift = 0.4;          // Tube x offset.
  const int pattern_levels = 50;      // Tube depth (z direction.)
  const float pattern_width = 20;     // Triangle size (circumferential).
  const float pattern_pitch_z = 0.25; // Triangle size (z axis).

  ///
  /// Transformation Matrix Setup
  ///

  glMatrixMode(GL_MODELVIEW);
  pMatrix_Translate transform_to_eye(-1,-0.5,-3);
  glLoadTransposeMatrixf(transform_to_eye);


  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const float aspect = float(win_width) / win_height;
  //  pMatrix_Frustrum frustrum(1.6,1.6/aspect,1,5000);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-0.8,+0.8,-0.8/aspect,0.8/aspect,1,5000);


  // pMatrix_Translate center_window(1,1,0);
  // pMatrix_Scale scale(win_width/2,win_height/2);
  // pMatrix transform_to_viewport = scale * center_window * frustrum;

  glViewport(0, 0, win_width, win_height);
  pError_Check();


  ///
  /// Light Location and Lighting Options
  ///

  static bool opt_attenuation = true;
  static bool opt_v_to_light = true;
  static float opt_light_intensity = 2;
  static pCoor light_location(( r - 0.1 ), 0, -3 );

  // Adjust lighting options based on user input.
  //
  switch ( frame_buffer.keyboard_key ) {
  case FB_KEY_LEFT: light_location.x -= 0.1; break;
  case FB_KEY_RIGHT: light_location.x += 0.1; break;
  case FB_KEY_UP: light_location.y += 0.1; break;
  case FB_KEY_DOWN: light_location.y -= 0.1; break;
  case FB_KEY_PAGE_DOWN: light_location.z += 0.2; break;
  case FB_KEY_PAGE_UP: light_location.z -= 0.2; break;
  case '-':case '_': opt_light_intensity *= 0.9; break;
  case '+':case '=': opt_light_intensity *= 1.1; break;
  case 'd': case 'D': opt_attenuation = !opt_attenuation; break;
  case 'a': case 'A': opt_v_to_light = !opt_v_to_light; break;
  default: break;
  }

  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_off[0]);

  if ( opt_v_to_light )
    {
      glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
      glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);
    }
  else
    {
      glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_off[0]);
      glLightfv(GL_LIGHT0, GL_AMBIENT, &light_intensity[0]);
    }

  if ( opt_attenuation )
    {
      glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
      glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);
    }
  else
    {
      glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 1);
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0);
      glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);
    }

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  // User Messages  (Magically inserted into frame buffer.)
  //
  frame_buffer.fbprintf
    ("Lighting: Distance - %s,  Angle - %s  ('d' or 'a' to change).\n",
     opt_attenuation ? "On" : "Off", opt_v_to_light ? "On" : "Off");
  frame_buffer.fbprintf("Arrows, page up/down move light.\n");


  /// Z Buffer Setup
  //
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);


  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(light_location,0.05);

  //
  // Insert a tessellated tube in the vertex list.
  //

  // User Option: Use triangle normal or vertex normal.
  //
  static bool opt_triangle_normal = false;
  if ( frame_buffer.keyboard_key == 'n' )
    opt_triangle_normal = !opt_triangle_normal;
  frame_buffer.fbprintf("Normals based on %s (use 'n' to change).\n",
                        opt_triangle_normal ? "triangle" : "vertex");


  float z = -1;
  //  const uint32_t color_gold = 0xf9b237;    // LSU Spirit Gold
  //  const uint32_t color_purple = 0x580da6;  // LSU Spirit Purple
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold

  glColor3fv( color_gold );

  // Outer Loop: z axis (down axis of tube).
  //
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_z = z - pattern_pitch_z;
      const float last_z = z + pattern_pitch_z;
      const float delta_theta = M_PI / pattern_width;
      float theta = i & 1 ? delta_theta : 0;

      // Inner Loop: around circumference of tube.
      //
      while ( theta < 4 * M_PI )
        {
	  const bool first_round = theta < 2 * M_PI;
	  const float z1 = first_round ? next_z : last_z;

	  // For improved performance the tri functions would be pre-computed.

	  //  pVertex v0(x_shift + r * cos(theta), r * sin(theta), z, color );
	  pCoor v0(x_shift + r * cos(theta), r * sin(theta), z);
	  pVect v0_normal;
	  if ( !opt_triangle_normal )
	    v0_normal = pVect(-cos(theta),-sin(theta),0);

	  theta += delta_theta;
	  pCoor v1(x_shift + r * cos(theta), r * sin(theta), z1);
	  pVect v1_normal;
	  if ( !opt_triangle_normal )
	    v1_normal = pVect(-cos(theta),-sin(theta),0);

	  theta += delta_theta;
	  pCoor v2(x_shift + r * cos(theta), r * sin(theta), z);
	  pVect v2_normal;
	  if ( !opt_triangle_normal )
	    v2_normal = pVect(-cos(theta),-sin(theta),0);

	  if ( opt_triangle_normal )
	    v0_normal = v1_normal = v2_normal =
	      first_round ? cross(v0,v1,v2) : cross(v2,v1,v0);

	  glBegin(GL_TRIANGLES);

	  //  vtx_list.push_back( v0 );

	  glNormal3fv(v0_normal);  glVertex3fv(v0);
	  glNormal3fv(v1_normal);  glVertex3fv(v1);
	  glNormal3fv(v2_normal);  glVertex3fv(v2);

	  glEnd();
        }
      z = next_z;
    }

  // Insert additional triangle.
  //
  {
    //  pVertex* const v0 = new pVertex( 1.5, 0, -3.2, color_purple );
    pCoor v0( 1.5, 0, -3.2 );
    pCoor v1( 0, 5, -5 );
    pCoor v2( 9, 6, -9 );
    //  v0.normal = v1.normal = v2.normal = cross(v0,v1,v2);
    pVect normal(cross(v0,v1,v2));

    glColor3fv( color_purple );

    glBegin(GL_TRIANGLES);

    //  vtx_list.push_back( v0 );

    glNormal3fv(normal);  glVertex3fv(v0);
    glNormal3fv(normal);  glVertex3fv(v1);
    glNormal3fv(normal);  glVertex3fv(v2);

    glEnd();

  }

  pError_Check();

  glutSwapBuffers();

  return;

  // Note: Code past this point performed operations that are now
  // performed by the OpenGL implementation, using CPU and GPU
  // resources.

#if 0
  ///
  /// Rendering Pipeline Starts Here
  ///

  // Indicate to frame buffer simulator that code above is part of
  // application and that code below is part of rendering pipeline.
  //
  frame_buffer.render_timing_start();

  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Allocate and initialize a z buffer.
  // (Note: Allocation only need be performed when size changes.)
  //
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;

  ///
  /// Transform Coordinates and Normals from Object Space to Eye Space
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      v *= transform_to_eye;
      v.normal *= normal_to_eye;
      v.normal.normalize();
      v.homogenize();
    }

  // Convert light location to object space.
  //
  pCoor light_location_e = transform_to_eye * light_location;

  ///
  /// Apply Lighting to Vertices
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      const bool opt_no_lighting = v.color & 0x1000000;
      if ( opt_no_lighting ) continue;

      // Compute vectors from vertex to light and to viewer.
      //
      pVect v_to_light(v,light_location_e);
      pVect v_to_viewer(v,pCoor(0,0,0));

      // Distance from vertex to light.
      //
      const float length = v_to_light.normalize();

      // Projections:
      //   1: vertex (normal) is facing light (or viewer).
      //   0: vertex (normal) is orthogonal (90 degrees) from light.
      //  -1: vertex (normal) is facing opposite direction of light.
      //
      const float dot_v_to_light = dot(v.normal,v_to_light);
      const float dot_v_to_viewer = dot(v.normal,v_to_viewer);

      // Dimming of light with distance.
      //
      // "Real" light dims with square of distance.
      //
      const float attenuation =
        !opt_attenuation ? 1.0 : 1.0 / ( 0.25 * length * length + length );

      // Assume back side (-normal direction) is same color as front.
      //
      const float v_to_light_scale =
        dot_v_to_viewer < 0 ? -dot_v_to_light : dot_v_to_light;

      // Determine color adjustment.
      //
      const float scale = opt_light_intensity * attenuation
        *( !opt_v_to_light ? 1.0 : v_to_light_scale );

      v.red *= scale;
      v.green *= scale;
      v.blue *= scale;
    }

  ///
  /// Transform Coordinates from Eye Space to Window Space
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;  // Get reference to current vertex
      v *= transform_to_viewport;
      v.homogenize();
    }

  ///
  /// Rasterize Primitives
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci += 3 )
    {
      pSortVertices sort(ci); // Sort next 3 items in list.
      pVertex& c0w = sort;    // Coordinate with smallest y.
      pVertex& c1w = sort;
      pVertex& c2w = sort;    // Coordinate with largest y.

      // Instantiate interpolation objects.
      //
      // Each object instantiated with two coordinates and a valid
      // range of y values.  The object will compute x and y along the
      // line connecting those coordinates, skipping y values < 0 or
      // >= win_width.
      //
      // Interpolation objects also interpolate z and color components.
      //
      pInterpolate interp_02(c0w,c2w,0,win_height-1);
      pInterpolate interp_012(c0w,c1w,0,win_height-1);

      // Compute position (index) in frame buffer of first row to be written.
      //
      int fb_line_idx = interp_02.yi * win_width;

      // Outer Loop: Iterate from smallest y to largest y.
      //
      while ( interp_02.keep_going_y() )
        {

	  // If point c1w reached then switch interp_012 to line
	  // connecting c1w and c2w.
	  //
	  if ( ! interp_012.keep_going_y() )
	    interp_012.set(c1w,c2w,0,win_height-1);

	  // Instantiate x-axis interpolation object using the two
	  // y-axis interpolation objects, interp_02 and interp_012.
	  // The new object will compute points on the line connecting
	  // the current position of interp_02 and interp_012.
	  //
	  pInterpolate interp_line(interp_02,interp_012,0,win_width-1);

	  // Inner Loop: Iterate along x axis.
	  //
	  while ( interp_line.keep_going_x() )
	    {
	      const int fb_idx = fb_line_idx + interp_line.xi;

	      // If z value to be written is smaller (in front of) z value
	      // already there then go ahead and write frame buffer.
	      //
	      if ( z_buffer[ fb_idx ] > interp_line.z )
                {
		  f_buffer[ fb_idx ] = interp_line.color();
		  z_buffer[ fb_idx ] = interp_line.z;
                }

	      // Tell interpolation object to advance in x direction.
	      //
	      interp_line.advance_x();
	    }

	  // Tell interpolation objects to advance in y direction.
	  //
	  interp_02.advance_y();  interp_012.advance_y();

	  // Advance the frame buffer index.
	  //
	  fb_line_idx += win_width;
        }
    }

  // A paint routine is no place for a memory leak!
  //
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    delete *ci;
  free(z_buffer);
#endif
}
#endif

int
main(int argc, char **argv)
{
  pOpenGL_Helper popengl_helper(argc,argv);
  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(render_light,&popengl_helper);
  return 0;
}
