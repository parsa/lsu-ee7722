/// LSU EE 7700-1 (Sp 2009), Graphics Processors
//
/// Homework 1

 /// Name:

// $Id:$

/// Instructions

// Follow the class account setup instructions linked to the
// class procedures page, http://www.ece.lsu.edu/koppel/gp/proc.html

// For instructions on how to check out edit, compile, and debug, see
// the "Programming Homework Work Flow" entry on the procedures page,
// http://www.ece.lsu.edu/koppel/gp/proc.html.
//
// For those instructions you need to know that:
//
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/2009/hw1
//
//  The assignment instructions are in file hw1.cc. (This file.)

// For the solutions to the problems below edit this file, even if
// it makes more sense to edit others (namely, coord.h). If it seems
// that coord.h must be edited, contact me.

// The main code is in routine render_light.
// The routine sample_code provides examples of the geometry objects.


/// Problem 0

// Fill in your name in the comment near the top of this file, then
// build and run the program. It should display a tube similar to
// demo-4-lighting. Try out the keyboard commands described below and
// promptly resolve any problems, feel free to ask for help from
// Dr. Koppelman or others, especially on issues of missing libraries,
// and other setup problems.

// [ ]  Name placed at top of this file.
// [ ]  Code compiles and runs.
// [ ]  Had fun moving that green thing.


/// Keyboard Commands

 /// Eye and Light Location
//   Arrows, Page Up, Page Down
//   Move either the light or, after Problem 1 solved, the eye.
//   After pressing 'l' the keys move the light, after pressing 'e'
//   they move the eye (viewer location). The eye and light location
//   coordinates are displayed in the upper left. The eye
//   location coordinates show what *should* be displayed,
//   until Problem 1 is solved that is not what is actually
//   displayed (except for the initial view).

 /// Eye Direction
//   Home, End, Delete, Insert
//   Turn the eye direction (after Problem 1 solved).
//   Home should rotate eye direction up, End should rotate eye
//   down, Delete should rotate eye left, Insert should rotate eye
//   right.  The eye direction vector is displayed in the upper left,
//   until Problem 1 is solved the vector won't match the image.

 /// Lighting Options
//   d, a, n, +, -
//   d: Toggle use of distance in computing vertex lighting.
//   a: Toggle use of normal in computing vertex lighting.
//   n: Switch between using triangle normal and tube normal.
//   +,-: Change intensity of light.

 /// Screenshot
//   F12
//   Pressing F12 will write a png image. The file name base will
//   match the executable name, for example, "hw1.png".


/// Problem 1

// Modify the program, in particular the procedure render_light, so
// that the eye location and direction are properly applied. For
// example, pressing 'e' then 'Page Up' should move the viewer towards
// the displayed tube and the up arrow should move the viewer above
// the tube.

// Routine render_light has a pCoor object named eye_location that
// contains the desired eye location, it is updated when the user
// presses eye movement keys. There is also eye_direction which
// contains the desired eye direction. Modify the code in render_light
// so that the displayed image is based on eye_location and
// eye_direction.

// [ ]  Eye location keys move viewer.
// [ ]  Eye direction keys rotate viewer direction (scene rotates around eye).
// [ ]  The code should modify the transformations, not inserted vertices.
// [ ]  Modifications should be at appropriate place in rendering pipeline.


/// Problem 2

// Modify the code so that the eye location arrow keys change the
// location relative to the viewer. That is, pressing 'Page Up' will
// move the viewer straight ahead, even if the eye direction is no
// longer [0,0,-1]. (Without this modification 'Page Up' will always
// move the viewer in the -z direction, regardless of eye direction.)

// [ ]  Eye location keys move viewer relative to eye direction.



#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#include "frame_buffer.h"
#include "coord.h"


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



void
sample_code()
{
  // This routine contains examples of how to use the geometric
  // classes such as coordinate, vertex, and matrix.  It is not
  // supposed to do anything useful.

  // For more details on these classes read the code in coord.h.


  /// Coordinate Construction
  //
  pCoor c1(11,22,33);  // w is 1 by default.
  pCoor c2(1,2,3,0.5); // w is 0.5
  pCoor c2b(&c2);   // Copy of c2.
  pCoor c3(5,1,8);
  printf("x component of c1 is %.1f\n",c1.x);

  /// Vertex Construction
  //
  // A vertex is a coordinate that can hold a color and normal.
  // Operations on coordinates also work on vertices.
  //
  pVertex v1(11,22,33);   // Vertex at same coordinates as c1.
  pVertex v2(2,4,6);      // Vertex at same coordinates as c2.
  pVertex v3(5,1,8,0xff); // Fourth arg is color, not w.

  /// Vector Construction
  //
  pVect vec(1,2,3);       // Construct using x, y, and z components.
  pVect vec_12(c1,c2);    // Const. using two coords, result is c2 - c1.
  pVect vec_21(c2,c1);
  pVect vec_23(v2,v3);    // Const. using two vertices, result is v3 - v2.
  pVect vec_xa(vec_21,vec_23);  // Cross product: (c1-c2) x (c3-c2).
  pVect vec_xb(c1,c2,c3);       // Cross product: (c1-c2) x (c3-c2).

  /// Matrix Construction
  //
  pMatrix m1; m1.a[0][0] = 1; m1.a[0][1] = 0;   // Set each element by hand.
  pMatrix_Translate trans1(1,2,3);    // Translate +1 x, +2 y, +3 z.
  pMatrix_Rotation rot1(vec, 1.2);    // Rotate around axis VEC by 1.2 radians.
  pMatrix_Rotation rot2(vec_12, vec_23);  // Rotate vec_12 to vec_23.

  /// Coordinate and Vector Operators
  //
  pVect vec_12b = c2 - c1;   // Subtraction of coords yields vector.
  pVect vec_12c = v2 - v1;   // Coordinate operators work on vertices too.
  pCoor c2c = c1 + vec_12b;  // Coord + vec yields a coordinate.
  pVect vscaled = 5 * vec_12b;  // Multiply each element.

  /// Matrix Multiplication Operator
  //
  pCoor cx1 = trans1 * c1;   // Use trans1 (above) to transform c1.
  pCoor cx2 = trans1 * rot1 * rot2 * c1;  // Three matrices and a coord.
  pMatrix m = trans1 * rot1 * rot2;
  pCoor vx3 = m * c1;

  /// Coordinate Member Functions
  //
  cx1.homogenize();         // Divide all elements by w
  cx1.homogenize_keep_w();  // Divide x, y, and z by w. (Be careful.)

  /// Vector Member Functions
  //
  float length_12b = vec_12b.magnitude();  // Length of vector.
  float length_12c = vec_12c.normalize();  // Return length, then normalize.

  /// Matrix Member Functions.
  //
  pMatrix m2;  // Member functions set matrix to indicated transformation.
  m2.set_zero(); m2.set_identity(); m2.set_scale(0.5); m2.set_translate(1,2,3);
  m2.set_frustum(1,2,3,4);
  m2.transpose();
  m2.invert3x3();  // Note: Only inverts 3x3 submatrix.

  /// Miscellaneous Functions
  //
  float d1223a = dot(vec_21,vec_23);    // Dot product of vectors.
  float d1223b = dot(c1,c2,c3);         // Dot product (c1-c2) x (c3-c2).
  pVect c1223a = cross(vec_21,vec_23);  // Cross product of vectors.
  pVect c1223b = cross(c1,c2,c3);       // Cross product (c1-c2) x (c3-c2).

  float a1223a = pangle(vec_21,vec_23); // Angle between vectors, in [0,pi].
  float a1223b = pangle(c1,c2,c3);      // Angle between c1 c2 c3, in [0,pi].

  pMatrix minv = invert3x3(m);   // Invert 3x3 submatrix.

  if ( length_12b + length_12c + d1223a + d1223b + a1223a + a1223b == 1111 )
    printf("Pacify compiler.\n");

}


 /// Vertex List
//
// Declare vertex list types so that many vertices can easily be
// operated on.
//
typedef std::deque<pVertex*> pVertex_List;
typedef pVertex_List::iterator pVertex_Iterator;

 /// Vertex Sort
//
// Sort three vertices at vertex list iterator position.
//
class pSortVertices {
public:
  pSortVertices(pVertex_Iterator& ci)
  {
    rv_idx = 0;
    for ( int i=0; i<3; i++ ) v[i] = ci[i];
    swap(0,1); swap(0,2); swap(1,2);
  }
  operator pVertex& () { return *v[rv_idx++]; }
private:
  void swap(int a, int b)
  {
    if ( v[a]->y <= v[b]->y ) return;
    pVertex* const t = v[a];  v[a] = v[b];  v[b] = t;
  }
  pVertex* v[3];
  int rv_idx;
};

int clampi(float valp, int min, int max)
{
  const int val = (int) valp;
  if ( val < min ) return min;
  if ( val > max ) return max;
  return val;
}

 /// Interpolation Object
//
// Return x and y values on line connecting two points. Skips
// out-of-range values.
//
// Can be instantiated to advance in +x direction or +y direction.
//
class pInterpolate {
public:

  pInterpolate(pVertex& v0, pVertex& v1, int ymin, int ymax)
  { set(v0, v1, ymin, ymax); }

  void set(pVertex& v0, pVertex& v1, int ymin, int ymax)
  {
    const float y_range_inv = 1.0 / ( v1.y - v0.y );
    yi_last = ymax < int(v1.y) ? ymax : int(v1.y);
    const float pre_y = float(ymin) - v0.y;
    const bool scissor = pre_y > 0.0;
    yi = scissor ? ymin : int(v0.y);
    const float y_range_part_inv = 1.0 / ( v1.y - yi );
#define DELTA(item) \
    const float dtrue_##item = (v1.item - v0.item) * y_range_inv; \
    item = v0.item + ( scissor ? pre_y * dtrue_##item : 0.0 ); \
    d_##item = (v1.item - item) * y_range_part_inv;
    DELTA(red); DELTA(green); DELTA(blue); DELTA(x); DELTA(z);
#undef DELTA
  }

  pInterpolate(pInterpolate& v0, pInterpolate& v1, int xmin, int xmax)
  {
    pInterpolate& vmin = v0.x < v1.x ? v0 : v1;
    pInterpolate& vmax = v0.x < v1.x ? v1 : v0;
    const float x_range_inv = 1.0 / ( vmax.x - vmin.x );
    xi_last = xmax < int(vmax.x) ? xmax : int(vmax.x);
    const float pre_x = float(xmin) - vmin.x;
    const bool scissor = pre_x > 0.0;
    xi = scissor ? xmin : int(vmin.x);
    const float x_range_part_inv = 1.0 / ( vmax.x - xi );
#define DELTA(item) \
    const float dtrue_##item = (vmax.item - vmin.item) * x_range_inv; \
    item = vmin.item + ( scissor ? pre_x * dtrue_##item : 0.0 ); \
    d_##item = (vmax.item - item) * x_range_part_inv;
    DELTA(red); DELTA(green); DELTA(blue); DELTA(z);
#undef DELTA
  }

  bool keep_going_y() { return yi <= yi_last; }
  bool keep_going_x() { return xi <= xi_last; }

  void advance_y() { advance_common();  x += d_x;  yi++; }
  void advance_x() { advance_common();  xi++; }

  void advance_common()
  {
    red += d_red;  green += d_green;  blue += d_blue;  z += d_z;
  }

  uint32_t color()
  {
    return ( ( clampi(red,0,255) << 0 )
             | ( clampi(green,0,255) << 8 )
             | ( clampi(blue,0,255) << 16 ) );
  }
  float d_red, d_green, d_blue, d_x, d_z, red, green, blue, x, z;
  int xi, xi_last, yi, yi_last;
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
  vtx_list.push_back( new pVertex(va,n,c1) ); \
  vtx_list.push_back( new pVertex(vb,n,c2) ); \
  vtx_list.push_back( new pVertex(vc,n,c2) );
  TRI(v0,v1,v2); TRI(v0,v2,v3); TRI(v0,v3,v1);
# undef TRI
}


void
render_light(pFrame_Buffer &frame_buffer)
{
  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

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
  static bool opt_split_triangles = false;  // Part of homework 2.


  ///
  /// Adjust options based on user input.
  ///

  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);

  switch ( frame_buffer.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -0.1; break;
  case FB_KEY_RIGHT: adjustment.x = 0.1; break;
  case FB_KEY_UP: adjustment.y = 0.1; break;
  case FB_KEY_DOWN: adjustment.y = -0.1; break;
  case FB_KEY_PAGE_DOWN: adjustment.z = 0.1; break;
  case FB_KEY_PAGE_UP: adjustment.z = -0.1; break;
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
  case 's': case 'S': opt_split_triangles = !opt_split_triangles; break;
  default: break;
  }

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
      eye_direction *= pMatrix_Rotation(user_rot_axis, M_PI * 0.03);

  // Update eye_location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
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

  frame_buffer.fbprintf
    ("Split triangles %s ('s' to change).\n",
     opt_split_triangles ? "ON" : "OFF");

  // Instantiate list of vertices.
  //
  pVertex_List vtx_list;

  const uint32_t color_gold = 0xf9b237;    // LSU Spirit Gold
  const uint32_t color_purple = 0x580da6;  // LSU Spirit Purple

  // Insert big purple triangle into the vertex list.
  //
  {
    pVertex* const v0 = new pVertex( 1.5, 0, -3.2, color_purple );
    pVertex* const v1 = new pVertex( 0, 5, -5, color_purple );
    pVertex* const v2 = new pVertex( 9, 6, -9, color_purple );
    v0->normal = v1->normal = v2->normal = cross(*v0,*v1,*v2);
    vtx_list.push_back( v0 );
    vtx_list.push_back( v1 );
    vtx_list.push_back( v2 );
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
  const uint32_t color = color_gold;

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
          const float z1 = theta < 2 * M_PI ? next_z : last_z;

          pVertex* const v0 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z, color );
          if ( !opt_triangle_normal )
            v0->normal = pVect(-cos(theta),-sin(theta),0);

          theta += delta_theta;
          pVertex* const v1 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z1, color);
          if ( !opt_triangle_normal )
            v1->normal = pVect(-cos(theta),-sin(theta),0);

          theta += delta_theta;
          pVertex* const v2 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z, color );
          if ( !opt_triangle_normal )
            v2->normal = pVect(-cos(theta),-sin(theta),0);

          if ( opt_triangle_normal )
            v0->normal = v1->normal = v2->normal = cross(*v0,*v1,*v2);

          vtx_list.push_back( v0 );
          vtx_list.push_back( v1 );
          vtx_list.push_back( v2 );
        }
      z = next_z;
    }


  // Insert light position marker (green tetrahedron) into vertex list.
  //
  insert_tetrahedron(vtx_list,light_location,0.05);


  ///
  /// Rendering Pipeline Starts Here
  ///

  // Indicate to frame buffer simulator that for purposes of showing
  // timing, code above is part of application (included in frame time
  // but not render time) and that code below is part of rendering
  // pipeline.
  //
  frame_buffer.render_timing_start();

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Allocate and initialize a z buffer.
  // (Note: Allocation only needs be performed when size changes.)
  //
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;


  ///
  /// Compute Coordinate Transformations
  ///

  // Compute transformation from object space to eye space.
  //
  pMatrix_Translate center_eye(-1,-0.5,-3);
  pMatrix object_to_eye = center_eye;

  // Compute transformation from eye space to window space.
  //
  const float aspect = float(win_width) / win_height;
  pMatrix_Frustum frustum(1.6,1.6/aspect,1,5000);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix eye_to_window = scale * center_window * frustum;

  // Compute matrix needed to transform normals.
  //
  pMatrix normal_to_eye(object_to_eye);
  normal_to_eye.transpose(); normal_to_eye.invert3x3();

  ///
  /// Transform Coordinates and Normals from Object Space to Eye Space
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      v *= object_to_eye;
      v.normal *= normal_to_eye;
      v.normal.normalize();
      v.homogenize();
    }

  // Convert light location to eye space.
  //
  pCoor light_location_e = object_to_eye * light_location;


  ///
  /// Apply Lighting to Vertices
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
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
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      v *= eye_to_window;
      v.homogenize_keep_w();
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
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    delete *ci;
  free(z_buffer);
}

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);

  // Frame buffer object will call render_light routine, where
  // most of our work is done, whenever the window needs to be updated,
  // including after keyboard key presses.
  //
  frame_buffer.show(render_light);
  return 0;
}
