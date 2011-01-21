/// LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
//
 /// CPU-Only Demo 1: One Triangle

 // $Id:$

 /// Purpose
//
//   Routine render_one_triangle demonstrates the most basic 3D
//   techniques: how to project a triangle specified in object space
//   onto a frame buffer.

 /// To compile and run:
//
//     make
//     demo-1-one-triangle

 /// More Information
//
//   File coord.h on coordinate and matrix objects and operations.


#include <stdio.h>
#include <strings.h>
#include <stdlib.h>

#include "frame_buffer.h"
#include "coord.h"

inline float
slope(pCoor& a, pCoor& b)
{
  return ( b.x - a.x ) / fabs( b.y - a.y );
}

void
render_one_triangle(pFrame_Buffer &frame_buffer)
{
  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

  ///
  /// Determined by Hardware
  ///

  const int win_width = frame_buffer.get_width();
  // const int win_height = frame_buffer.get_height(); // Uncomment if needed.

  // Address of start of frame buffer.
  //
  int32_t* const f_buffer = frame_buffer.get_buffer();

  ///
  /// Determined by Application
  ///

  // Coordinates of triangle to render, in object space.
  //
  // ( Just one triangle. )
  //
  pCoor c0(10,9,-3);
  pCoor c1(5,10,-3);
  pCoor c2(6,17,-6);

  ///
  /// Determined by Application
  ///

  // Location of viewer, transformation to eye coordinates.
  //
  // Transform object coordinates to eye space: viewer is at (0,0,0)
  // looking in -z direction with +y straight up and +x pointing to
  // right.

  pMatrix_Translate center_eye(-6,-10,0);



  // Perspective projection, transformation to clip coordinates.
  //
  // Transform eye coordinates to clip coordinates: each visible
  // coordinate in [-1,1].

  pMatrix_Frustum frustum(12,20,1,20);

  pCoor cx1 = frustum * center_eye * c0;


  // Transform to window coordinates.
  //
  // Transform device coordinates (homogenized clip coordinates) to
  // window coordinates: x in [0,win_width) and y in [0,win_height).

  pMatrix_Translate center_window(1,1,0);

  pCoor cx2 = center_window * frustum * center_eye * c0;

  pMatrix_Scale scale(win_width/2);

  pMatrix transform = scale * center_window * frustum * center_eye;

  pCoor cx3 = transform * c0;

  //
  // Apply transformation to transform triangle coordinates from
  // object space to clip space.
  //
  pCoor c0w = transform * c0;  c0w.homogenize();
  pCoor c1w = transform * c1;  c1w.homogenize();
  pCoor c2w = transform * c2;  c2w.homogenize();


  // For convenience and performance, convert y coordinates to integers.
  //
  const int c0y = (int)c0w.y;
  const int c1y = (int)c1w.y;
  const int c2y = (int)c2w.y;

  // Enforce y ordering: c0w.y < c1w.y < c2w.y
  //
  if ( c0y >= c1y || c1y >= c2y )
    {fprintf(stderr,"Ordering violation."); exit(1);}

  ///
  /// Rasterization
  ///

  float x_02 = c0w.x;   // Call this the left (side of triangle) position.
  float x_012 = c0w.x;  // Call this the right position.
  float dx_02 = slope(c0w,c2w);
  float dx_012 = slope(c0w,c1w);
  // Note: if direction -1 then what is called "left" is really right, etc.
  const int direction = dx_02 < dx_012 ? 1 : -1;

  // Position of first row in frame buffer to write.
  //
  int fb_line_idx = c0y * win_width;

  // Outer loop proceeds from bottom to top.
  //
  for ( int y = c0y;  y < c2y;  y++ )
    {
      // Inner loop proceeds from "left" to "right"
      //
      for ( int x = (int)x_02; x != (int)x_012; x += direction )
        {
          // Write a green pixel.
          f_buffer[fb_line_idx + x] = 0xff00;
        }

      // Change slope if point c1 reached.
      //
      if ( y == c1y ) dx_012 = slope(c1w,c2w);

      // Move down by one pixel.
      //
      fb_line_idx += win_width;  // Advance frame buffer pointer to next row.
      x_02 += dx_02;             // Advance "left" x position.
      x_012 += dx_012;           // Advance "right" x position.
    }
}

int
main(int argc, char **argv)
{
  // Instantiate frame buffer simulation object.
  //
  pFrame_Buffer frame_buffer(argc,argv);

  // Tell frame buffer simulator to call render_one_triangle.
  //
  frame_buffer.show(render_one_triangle);

  return 0;
}
