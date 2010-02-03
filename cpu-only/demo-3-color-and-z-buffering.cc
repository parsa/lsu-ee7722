/// LSU EE 7700-1 (Sp 2010), GPU Microarchitecture
//
 /// CPU-Only Demo 3: Color and Z Buffering

// $Id:$

 /// Purpose

//   Demonstrate color interpolation and Z buffering.

//   The routine draws a grid of triangles pierced by a triangle.
//   The angle of the grid can be interactively adjusted.

 /// To compile and run:
//
//     make
//     demo-3-lighting

 /// More Information
//
//   File coord.h on coordinate and matrix objects and operations.


#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#include <gp/misc.h>
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
};

 /// Vertex List
//
// Declare vertex list types so that many vertices can easily be
// operated on.
//
class pVertex_List : public PStack<pVertex> {
public:
  pVertex_List():PStack<pVertex>(){};
  void append_vertex(float x, float y, float z, uint32_t color)
  {
    new (pushi()) pVertex(x,y,z,color);
  }
};

 /// Vertex Sort
//
// Sort three vertices at vertex list iterator position.
//
class pSortVertices {
public:
pSortVertices(pVertex *u1, pVertex *u2, pVertex *u3)
{
    rv_idx = 0;
    v[0] = u1;  v[1] = u2;  v[2] = u3;
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
    return ( ( int(red) << 0 ) | ( int(green) << 8 ) | ( int(blue) << 16 ) );
  }
  float d_red, d_green, d_blue, d_x, d_z, red, green, blue, x, z;
  int xi, xi_last, yi, yi_last;
};


void
render_z_color(pFrame_Buffer &frame_buffer)
{
  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

  /// Differences with Demo 2
  //
  // pVertex splits colors into red, green, and blue components.
  // Interpolation objects interpolate colors and z values.
  // Interpolation objects also combine color components.
  // Rasterizer checks z value.
  // Rasterizer uses color provided by interpolation object.
  //
  // User input accepted to adjust tilt of triangles.

  // Instantiate list of vertices.
  //
  pVertex_List vtx_list;

  //
  // Insert a grid of triangles in the vertex list.
  //
  const int pattern_levels = 30;
  const float pattern_width = 10;
  const float pattern_pitch_x = 1;
  const float pattern_half_pitch_x = pattern_pitch_x / 2;
  static float pattern_pitch_y = 0;
  const float pattern_pitch_z = 0.25;

  // Adjust y pitch in response to user input.
  //
  switch ( frame_buffer.keyboard_key ){
  case FB_KEY_UP: pattern_pitch_y += 0.01; break;
  case FB_KEY_DOWN: pattern_pitch_y -= 0.01; break;
  default: break;
  }

  // Message for user. (Magically inserted into frame buffer.)
  //
  frame_buffer.fbprintf("Use arrow keys to tilt road.\n");

  float y = 0;
  float z = -1;
  int32_t color_red = 0xff0000;
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_y = y + pattern_pitch_y;
      const float next_z = z - pattern_pitch_z;
      float x = 0;
      while ( x < pattern_width )
        {
          // Add a multicolored triangle to list.
          //
          vtx_list.append_vertex( x, y, z, color_red );
          x += pattern_half_pitch_x;
          vtx_list.append_vertex( x, next_y, next_z, color_red );
          x += pattern_half_pitch_x;
          vtx_list.append_vertex( x, y, z, color_red );
        }
      y = next_y;
      z = next_z;
    }

  // Add another triangle, one that passes through grid.
  //
  vtx_list.append_vertex( 3, -3, -1, 0xff0000  );
  vtx_list.append_vertex( 0, 5, -5, 0xff00  );
  vtx_list.append_vertex( 9, 6, -9, 0xff );

  ///
  /// Rendering Pipeline Starts Here
  ///

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Allocate and initialize a z buffer.
  // (Note: Allocation only need be performed when size changes.)
  //
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;

  // Specify Transformation

  pMatrix_Translate center_eye(-5,-6,-2);
  pMatrix_Frustum frustum(4,5,1,20);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix transform = scale * center_window * frustum * center_eye;

  ///
  /// Transform Coordinates
  ///
  while ( pVertex* const v = vtx_list.iterate() )
    {
      *v *= transform;
      v->homogenize();
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
  free(z_buffer);
}

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);
  frame_buffer.show(render_z_color);
  return 0;
}
