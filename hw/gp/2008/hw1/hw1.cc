/// LSU EE 7700-2 (Sp 08), Graphics Processors
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
//  This assignment is at SVN URI https://svn.ece.lsu.edu/svn/gp/hw/2008/hw1
//
//  The assignment instructions are in file hw1.cc. (This file.)

// For the solutions to the problems below edit this file, even if
// it makes more sense to edit others (namely, coord.h). If it seems
// that coord.h must be edited, contact me.

// The main code is in routine render_hw1.


/// Problem 0

// Fill in your name in the comment above. Then build and test the
// program. It should display a tube similar to
// demo-4-lighting. Promptly resolve any problems, feel free to ask
// for help from Dr. Koppelman or others, especially on issues of
// missing libraries, and other setup problems.


/// Problem 1

// The large triangle has a flaw: There is a line extending out of
// the right side of the bottom of the triangle.  

//  [ ] Fix the flaw.

// Note: The part of the code containing the flaw is the most
// time-critical in the rendering pipeline, which is why your attention
// is being focused there.


/// Problem 2

// Modify the code so that pressing "R" will rotate the tube by 15
// degrees in the y direction though the center of tube. Each R should
// rotate by another 15 degrees.

//  [ ] Modify to rotate by 15 degrees.



/// Problem 3

// Find a formula for render time in terms of vertices, pixels, and
// something related to triangles. The formula should be of the form:

//  t = t_tri n_tri + t_v n_v + t_p n_p,

// where n_tri is a count of something related to triangles, t_tri is
// the time per triangle (which you have determined), n_v is the
// number of vertices, and n_p is the number of pixels.

// Part of the problem is determining exactly what n_tri and n_p are. (There
// is only one reasonable interpretation of what n_v is.)

// The formula should work for the code in this file and should continue
// to work reasonably well if parameters such as pattern_levels change.

// Be sure to base this formula on the optimized version of the code.

//  [ ] Prepare a solution on paper (or pdf).

//  [ ] Show how well the solution works with the code with varying
//      values of pattern_width and pattern_levels.

//  [ ] Provide suggestions on where and how the rendering pipeline
//      code may be sped up.


#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#include "frame_buffer.h"
#include "coord.h"


 /// Vertex Object
//
// Holds coordinates plus color. In later examples will hold more
// information.
//
class pVertex : public pCoor {
public:
  pVertex(float xp, float yp, float zp):pCoor(xp,yp,zp){};
  pVertex(float xp, float yp, float zp, uint32_t color):
    pCoor(xp,yp,zp){set_color(color);};
  pVertex(pCoor c, pVect n, uint32_t color)
    :pCoor(c),normal(n){set_color(color);}
  pVertex():pCoor(){};
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
    const float y_range = v1.y - v0.y;
    yi_last = ymax < int(v1.y) ? ymax : int(v1.y);
    const float pre_y = float(ymin) - v0.y;
    const bool scissor = pre_y > 0.0;
    yi = scissor ? ymin : int(v0.y);
#define DELTA(item) \
    d_##item = (float(v1.item) - v0.item) / y_range;            \
    item = v0.item + ( scissor ? pre_y * d_##item : 0.0 );
    DELTA(red); DELTA(green); DELTA(blue); DELTA(x); DELTA(z);
#undef DELTA
  }

  pInterpolate(pInterpolate& v0, pInterpolate& v1, int xmin, int xmax)
  {
    pInterpolate& vmin = v0.x < v1.x ? v0 : v1;
    pInterpolate& vmax = v0.x < v1.x ? v1 : v0;
    const float x_range = vmax.x - vmin.x;
    xi_last = xmax < int(vmax.x) ? xmax : int(vmax.x);
    const float pre_x = float(xmin) - vmin.x;
    const bool scissor = pre_x > 0.0;
    xi = scissor ? xmin : int(vmin.x);
#define DELTA(item) \
    d_##item = (float(vmax.item) - vmin.item) / x_range;        \
    item = vmin.item + ( scissor ? pre_x * d_##item : 0.0 );
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
render_hw1(pFrame_Buffer &frame_buffer)
{
  // Instantiate list of vertices.
  //
  pVertex_List vtx_list;

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


  const float r = 2;                  // Tube radius.
  const float x_shift = 0.4;          // Tube x offset.
  const int pattern_levels = 50;      // Tube depth (z direction.)
  const float pattern_width = 20;     // Triangle size (circumferential).
  const float pattern_pitch_z = 0.25; // Triangle size (z axis).

  float z = -1;
  const uint32_t color_gold = 0xf9b237;    // LSU Spirit Gold
  const uint32_t color_purple = 0x580da6;  // LSU Spirit Purple
  const uint32_t color = color_gold;

  // Get current time, intended for measuring performance of code.
  // Time is in seconds since some arbitrary start time. (Today that
  // start time might be New Years Day 1970 UTC, tomorrow it could be
  // the time the program started running. So, it's only useful to take
  // the difference between two values.  See pattern_loop_end below.)
  //
  const double pattern_loop_start = time_wall_fp();

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

          // For improved performance the tri functions would be pre-computed.

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

  const double pattern_loop_end = time_wall_fp();
  frame_buffer.fbprintf("The pattern loop took %.3f ms.\n",
                        ( pattern_loop_end - pattern_loop_start ) * 1000 );

  // Insert additional triangle.
  //
  {
    pVertex* const v0 = new pVertex( -2.5, 0, -3.2, color_purple );
    pVertex* const v1 = new pVertex( 0, 5, -5, 0xff00 );
    pVertex* const v2 = new pVertex( 1.5, 0.01, -3.2, 0xff );
    v0->normal = v1->normal = v2->normal = cross(*v0,*v1,*v2);
    vtx_list.push_back( v0 );
    vtx_list.push_back( v1 );
    vtx_list.push_back( v2 );
  }

  ///
  /// Light Location and Lighting Options
  ///

  static bool opt_attenuation = true;
  static bool opt_v_to_light = true;
  static float opt_light_intensity = 2;
  static pCoor light_location(x_shift + ( r - 0.1 ), 0, -3 );

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

  // User Messages  (Magically inserted into frame buffer.)
  //
  frame_buffer.fbprintf
    ("Lighting: Distance - %s,  Angle - %s  ('d' or 'a' to change).\n",
     opt_attenuation ? "On" : "Off", opt_v_to_light ? "On" : "Off");
  frame_buffer.fbprintf("Arrows, page up/down move light.\n");

  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(vtx_list,light_location,0.05);

  ///
  /// Rendering Pipeline Starts Here
  ///

  // Indicate to frame buffer simulator that code above is part of
  // application and that code below is part of rendering pipeline.
  //

  frame_buffer.render_timing_start();

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Allocate and initialize a z buffer.
  // (Note: Allocation only need be performed when size changes.)
  //
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;

  pMatrix_Translate center_eye(-1,-0.5,-3);

  // Preserve aspect ratio when setting projection window height in frustrum.
  const float aspect = float(win_width) / win_height;
  pMatrix_Frustrum frustrum(1.6,1.6/aspect,1,5000);

  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);

  pMatrix transform_to_eye = center_eye;
  pMatrix transform_to_viewport = scale * center_window * frustrum;

  // Compute matrix needed to transform normals.
  //
  pMatrix normal_to_eye(transform_to_eye);
  normal_to_eye.transpose(); normal_to_eye.invert3x3();

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
        !opt_attenuation ? 1.0
        : ( 0.5 * opt_light_intensity / ( length*length )
            + opt_light_intensity / length );

      // Assume back side (-normal direction) is same color as front.
      //
      const float v_to_light_scale =
        dot_v_to_viewer < 0 ? -dot_v_to_light : dot_v_to_light;

      // Determine color adjustment.
      //
      const float scale = attenuation
        * ( !opt_v_to_light ? 1.0 : v_to_light_scale );

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

  /// Note: Code past this point should be identical to Demo 3.

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
}

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);
  frame_buffer.show(render_hw1);
  return 0;
}
