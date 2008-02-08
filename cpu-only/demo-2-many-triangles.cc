/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
 /// CPU-Only Demo 2: Many Triangles

// $Id:$

 /// Purpose
//
//   Demonstrate how to apply 3D techniques to a list of possibly
//   unrelated primitives (triangles).
//
//   The routine draws a grid of identical triangles pierced by
//   a unique one.
//

 /// To compile and run:
//
//     make
//     demo-2-many-triangles

 /// More Information
//
//   File coord.h on coordinate and matrix objects and operations.


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
  pVertex(float xp, float yp, float zp):pCoor(xp,yp,zp),color(0xff0000){};
  pVertex(float xp, float yp, float zp, uint32_t color):
    pCoor(xp,yp,zp),color(color){}
  pVertex():pCoor(){};
  int32_t color;
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
    DELTA(x);
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
    // Note: DELTA not used here. See next demo.
#undef DELTA
  }

  bool keep_going_y() { return yi <= yi_last; }
  bool keep_going_x() { return xi <= xi_last; }

  void advance_y() { advance_common();  x += d_x;  yi++; }
  void advance_x() { advance_common();  xi++; }

  // This will be used later.
  void advance_common()
  {
  }

  float x, d_x;
  int xi, xi_last, yi, yi_last;
};


void
render_many_triangles(pFrame_Buffer &frame_buffer)
{
  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

  ///
  /// Differences With Demo 1 (One Triangle)
  ///

  // Class pVertex is used in place of pCoor to hold coordinates. Vertex
  //  objects (pVertex instances) hold coordinates and other information
  //  associated with a vertex, including in this case, a color.

  // Instead of just one triangle, a grid of triangles is drawn.

  // Triangles are added to a list (vtx_list) and are thereafter
  //  handled uniformly.

  // Transformation and rasterization routines iterate over the vertex
  //  list.

  // The rasterization code now sorts groups of three vertices (rather
  //  than requiring them to be specified in y order).

  // Interpolation objects are used to find coordinates along the
  //  line connecting two vertices. They will later be used to
  //  interpolate not just x- and y- values, but z- values and
  //  color components.


  // Instantiate list of vertices.
  //
  pVertex_List vtx_list;

  //
  // Insert a grid of triangles in the vertex list.
  //

  const int pattern_levels = 30;  // Number of rows (in z direction.)
  const float pattern_width = 10;
  const float pattern_pitch_x = 1;
  const float pattern_half_pitch_x = pattern_pitch_x / 2;
  const float pattern_pitch_y = 0;
  const float pattern_pitch_z = 0.3;

  const int32_t color_red = 0xff0000;
  const int32_t color_green = 0xff00;

  float y = 0;
  float z = -1;
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_y = y + pattern_pitch_y;
      const float next_z = z - pattern_pitch_z;
      float x = 0;

      while ( x < pattern_width )
        {

          // Add a red triangle to list.
          //
          vtx_list.push_back( new pVertex( x, y, z, color_red ) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, next_y, next_z, color_red ) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, y, z, color_red ) );
        }

      y = next_y;
      z = next_z;
    }

  // Add another triangle, a green one that passes through grid.
  //
  vtx_list.push_back( new pVertex( 3, -3, -1, color_green  ) );
  vtx_list.push_back( new pVertex( 0, 5, -5, color_green  ) );
  vtx_list.push_back( new pVertex( 9, 6, -9, color_green ) );

  ///
  /// Rendering Pipeline Starts Here
  ///

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Specify Transformation

  pMatrix_Translate center_eye(-5,-6,-2);
  pMatrix_Frustrum frustrum(4,5,1,20);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix transform = scale * center_window * frustrum * center_eye;

  ///
  /// Transform Coordinates
  ///
  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;  // Get reference to current vertex
      v *= transform;
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

      const int32_t color = c0w.color;

      // Instantiate interpolation objects.
      //
      // Each object instantiated with two coordinates and a valid
      // range of y values.  The object will compute x and y along the
      // line connecting those coordinates, skipping y values < 0 or
      // >= win_width.
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
              f_buffer[ fb_idx ] = color;

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
}

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);
  frame_buffer.show(render_many_triangles);
  return 0;
}
