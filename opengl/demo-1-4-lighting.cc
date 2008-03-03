/// LSU EE 7700-2 (Sp 08), Graphics Processors
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
//   File coord.h on coordinate and matrix objects and operations.


#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#include "frame_buffer.h"
#include "coord.h"

#if 0
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
    red = float( 0xff & ( color >> 16 ) ) / 255;
    green = float( 0xff & ( color >> 8 ) ) / 255;
    blue = float( 0xff & color ) / 255;
  }
  float red, green, blue;
  uint32_t color;
  pVect normal;
};
#endif

// Add an unlighted tetrahedron to VTX_LIST at LOC of size SIZE.
//
void
insert_tetrahedron(pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
  //  const int32_t c1 = 0x1ffffff, c2 = 0x100ff00;
  static pColor c1(0xffffff);
  static pColor c2(0xff00);

  glDisable(GL_LIGHTING);

#define TRI(va,vb,vc)                                                         \
  {                                                                           \
    pVect n = cross(va,vb,vc);                                                \
    glNormal3fv(n);                                                           \
    glColor3fv(c1);  glVertex3fv(va);                                         \
    glColor3fv(c2);  glVertex3fv(vb);                                         \
    glVertex3fv(vc);                                                          \
  }

  glBegin(GL_TRIANGLES);
  TRI(v0,v1,v2); TRI(v0,v2,v3); TRI(v0,v3,v1);
  glEnd();

# undef TRI

  glEnable(GL_LIGHTING);
}


void
render_light(pFrame_Buffer &frame_buffer)
{
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
    pCoor v0( 1.5, 0, -3.2 );
    pCoor v1( 0, 5, -5 );
    pCoor v2( 9, 6, -9 );
    //  v0.normal = v1.normal = v2.normal = cross(v0,v1,v2);
    pVect normal(cross(v0,v1,v2));

    glColor3fv( color_purple );

    glBegin(GL_TRIANGLES);

    glNormal3fv(normal);  glVertex3fv(v0);
    glNormal3fv(normal);  glVertex3fv(v1);
    glNormal3fv(normal);  glVertex3fv(v2);

    glEnd();

  }

  pError_Check();

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

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);
  frame_buffer.show(render_light);
  return 0;
}
