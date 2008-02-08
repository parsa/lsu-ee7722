/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
 /// Combined demos. Used for development.

// $Id:$

 /// Purpose
//
//   Used for development and classroom demonstrations.


#include <stdio.h>
#include <strings.h>
#include <math.h>
#include <stdlib.h>

#include "frame_buffer.h"
#include "coord.h"

#include <deque>

inline float 
slope(pCoor& a, pCoor& b)
{
  return ( b.x - a.x ) / fabs( b.y - a.y );
}

void
render_one_triangle(pFrame_Buffer &frame_buffer)
{
  ///
  /// Determined by Hardware
  ///

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
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

  pMatrix_Frustrum frustrum(12,20,1,20);

  // Transform to window coordinates.
  //
  // Transform device coordinates (homogenized clip coordinates) to
  // window coordinates: x in [x_left,x_right] and y in [y_bottom,y_top].

  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2);


  pMatrix transform = scale * center_window * frustrum * center_eye;

  pCoor c0w = transform * c0;  // 4 m + 3 a
  c0w.homogenize(); // 3 d
  pCoor c1w = transform * c1;  c1w.homogenize();  // 4 m + 3 a + 3 d
  pCoor c2w = transform * c2;  c2w.homogenize();  // 4 m + 3 a + 3 d

  // Assume following y ordering: c0w.y < c1w.y < c2w.y

  const int c0y = (int)c0w.y;
  const int c1y = (int)c1w.y;
  const int c2y = (int)c2w.y;
  if ( c0y >= c1y || c1y >= c2y )
    {
      fprintf(stderr,"Ordering violation.");
      exit(1);
    }

  float dx_02 = slope(c0w,c2w); // 2a + 1d
  float dx_012 = slope(c0w,c1w);  // First 01 then 12.
  const int direction = dx_02 < dx_012 ? 1 : -1;

  int fb_line_idx = c0y * win_width;
  float x_02 = c0w.x;
  float x_012 = c0w.x;

  for ( int y = c0y;  y < c2y;  y++ )
    {
      for ( int x = (int)x_02; x != (int)x_012; x += direction )
        f_buffer[fb_line_idx + x] = 0xff00ff00;
      if ( y == c1y ) dx_012 = slope(c1w,c2w);
      fb_line_idx += win_width;
      x_02 += dx_02;
      x_012 += dx_012;
    }
}


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
  bool use_lighting;
  pVect normal;
};

typedef std::deque<pVertex*> pVertex_List;
typedef pVertex_List::iterator pVertex_Iterator;

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


void
render_triangles(pFrame_Buffer &frame_buffer)
{
  pVertex_List vtx_list;
  const int pattern_levels = 30;
  const float pattern_width = 10;
  const float pattern_pitch_x = 1;
  const float pattern_half_pitch_x = pattern_pitch_x / 2;
  const float pattern_pitch_y = 0;
  const float pattern_pitch_z = 0.3;

  float y = 0;
  float z = -1;
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_y = y + pattern_pitch_y;
      const float next_z = z - pattern_pitch_z;
      float x = 0;
      while ( x < pattern_width )
        {
          vtx_list.push_back( new pVertex( x, y, z ) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, next_y, next_z) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, y, z ) );
        }
      y = next_y;
      z = next_z;
    }

  vtx_list.push_back( new pVertex( 3, -3, -1  ) );
  vtx_list.push_back( new pVertex( 0, 5, -5  ) );
  vtx_list.push_back( new pVertex( 9, 6, -9 ) );

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  int32_t* const f_buffer = frame_buffer.get_buffer();

  // Specify Transformation

  pMatrix_Translate center_eye(-5,-6,-2);
  pMatrix_Frustrum frustrum(4,5,1,20);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix transform = scale * center_window * frustrum * center_eye;

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      (**ci) *= transform;
      (**ci).homogenize();
    }

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci += 3 )
    {
      pSortVertices sort(ci);
      pVertex& c0w = sort;
      pVertex& c1w = sort;
      pVertex& c2w = sort;

      pInterpolate interp_02(c0w,c2w,0,win_height-1);
      pInterpolate interp_012(c0w,c1w,0,win_height-1);

      int fb_line_idx = interp_02.yi * win_width;

      while ( interp_02.keep_going_y() )
        {
          if ( ! interp_012.keep_going_y() )
            interp_012.set(c1w,c2w,0,win_height-1);

          pInterpolate interp_line(interp_02,interp_012,0,win_width-1);

          while ( interp_line.keep_going_x() )
            {
              const int fb_idx = fb_line_idx + interp_line.xi;
              f_buffer[ fb_idx ] = 0xff00;
              interp_line.advance_x();
            }

          interp_02.advance_y();  interp_012.advance_y();

          fb_line_idx += win_width;
        }
    }
}

void
render_z_color(pFrame_Buffer &frame_buffer)
{
  pVertex_List vtx_list;
  const int pattern_levels = 30;
  const float pattern_width = 10;
  const float pattern_pitch_x = 1;
  const float pattern_half_pitch_x = pattern_pitch_x / 2;
  const float pattern_pitch_y = 0;
  const float pattern_pitch_z = 0.25;

  float y = 0;
  float z = -1;
  int32_t color = 0xf9b237; // LSU Spirit Gold
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_y = y + pattern_pitch_y;
      const float next_z = z - pattern_pitch_z;
      float x = 0;
      while ( x < pattern_width )
        {
          vtx_list.push_back( new pVertex( x, y, z, color ) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, next_y, next_z, color) );
          x += pattern_half_pitch_x;
          vtx_list.push_back( new pVertex( x, y, z, color ) );
        }
      y = next_y;
      z = next_z;
    }

  vtx_list.push_back( new pVertex( 3, -3, -1, 0xff0000 ) );
  vtx_list.push_back( new pVertex( 0, 5, -5, 0xff00 ) );
  vtx_list.push_back( new pVertex( 9, 6, -9, 0xff ) );

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;

  // Specify Transformation

  pMatrix_Translate center_eye(-5,-6,-2);
  pMatrix_Frustrum frustrum(4,5,1,20);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix transform = scale * center_window * frustrum * center_eye;

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      (**ci) *= transform;
      (**ci).homogenize();
    }

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci += 3 )
    {
      pSortVertices sort(ci);
      pVertex& c0w = sort;
      pVertex& c1w = sort;
      pVertex& c2w = sort;

      pInterpolate interp_02(c0w,c2w,0,win_height-1);
      pInterpolate interp_012(c0w,c1w,0,win_height-1);

      int fb_line_idx = interp_02.yi * win_width;

      while ( interp_02.keep_going_y() )
        {
          if ( ! interp_012.keep_going_y() )
            interp_012.set(c1w,c2w,0,win_height-1);

          pInterpolate interp_line(interp_02,interp_012,0,win_width-1);

          while ( interp_line.keep_going_x() )
            {
              const int fb_idx = fb_line_idx + interp_line.xi;

              if ( z_buffer[ fb_idx ] > interp_line.z )
                {
                  f_buffer[ fb_idx ] = interp_line.color();
                  z_buffer[ fb_idx ] = interp_line.z;
                }

              interp_line.advance_x();
            }

          interp_02.advance_y();  interp_012.advance_y();

          fb_line_idx += win_width;
        }
    }
  free(z_buffer);
}

void
insert_tetrahedron(pVertex_List& vtx_list, pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y+size,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
  const int c = 0x100ff00;
  pVect n = cross(v0,v1,v2);
  vtx_list.push_back( new pVertex(v0,n,c) );
  vtx_list.push_back( new pVertex(v1,n,c) );
  vtx_list.push_back( new pVertex(v2,n,c) );
  n = cross(v0,v2,v3);
  vtx_list.push_back( new pVertex(v0,n,c) );
  vtx_list.push_back( new pVertex(v2,n,c) );
  vtx_list.push_back( new pVertex(v3,n,c) );
  n = cross(v0,v3,v1);
  vtx_list.push_back( new pVertex(v0,n,c) );
  vtx_list.push_back( new pVertex(v3,n,c) );
  vtx_list.push_back( new pVertex(v1,n,c) );
  n = cross(v1,v3,v2);
  vtx_list.push_back( new pVertex(v1,n,c) );
  vtx_list.push_back( new pVertex(v3,n,c) );
  vtx_list.push_back( new pVertex(v2,n,c) );
}


void
render_light(pFrame_Buffer &frame_buffer)
{
  pVertex_List vtx_list;

  const int pattern_levels = 50;
  const float pattern_width = 20;
  const float pattern_pitch_z = 0.25;
  const float r = 2;
  const float x_shift = 0.4;

  static bool opt_attenuation = true;
  static bool opt_v_to_light = true;
  static float opt_light_x = x_shift + ( r - 0.1 );
  static float opt_light_y = 0;
  static float opt_light_z = -3;
  static float opt_light_intensity = 2;

  switch ( frame_buffer.keyboard_key ) {
  case FB_KEY_LEFT: opt_light_x -= 0.1; break;
  case FB_KEY_RIGHT: opt_light_x += 0.1; break;
  case FB_KEY_UP: opt_light_y += 0.1; break;
  case FB_KEY_DOWN: opt_light_y -= 0.1; break;
  case FB_KEY_PAGE_DOWN: opt_light_z += 0.2; break;
  case FB_KEY_PAGE_UP: opt_light_z -= 0.2; break;
  case '-':case '_': opt_light_intensity *= 0.9; break;
  case '+':case '=': opt_light_intensity *= 1.1; break;
  case 'd': case 'D': opt_attenuation = !opt_attenuation; break;
  case 'a': case 'A': opt_v_to_light = !opt_v_to_light; break;
  default: break;
  }

  frame_buffer.fbprintf
    ("Lighting: Distance - %s,  Angle - %s  ('d' or 'a' to change).\n",
     opt_attenuation ? "On" : "Off", opt_v_to_light ? "On" : "Off");

  pCoor light_location(opt_light_x,opt_light_y,opt_light_z);
  insert_tetrahedron(vtx_list,light_location,0.05);

  static bool triangle_normal = false;
  if ( frame_buffer.keyboard_key == 'n' )
    triangle_normal = !triangle_normal;
  frame_buffer.fbprintf("Normals based on %s (use 'n' to change).\n",
                        triangle_normal ? "triangle" : "vertex");
  frame_buffer.fbprintf("Arrows, page up/down move light.\n");

  float z = -1;
  const uint32_t color_gold = 0xf9b237; // LSU Spirit Gold
  const uint32_t color_purple = 0x580da6;  // LSU Spirit Purple
  const uint32_t color = color_gold;
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_z = z - pattern_pitch_z;
      const float last_z = z + pattern_pitch_z;
      const float delta_theta = M_PI / pattern_width;
      float theta = i & 1 ? delta_theta : 0;

      while ( theta < 4 * M_PI )
        {
          const float z1 = theta < 2 * M_PI ? next_z : last_z;
          pVertex* const v0 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z, color );
          v0->normal = pVect(-cos(theta),-sin(theta),0);
          theta += delta_theta;
          pVertex* const v1 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z1, color);
          v1->normal = pVect(-cos(theta),-sin(theta),0);
          theta += delta_theta;
          pVertex* const v2 =
            new pVertex( x_shift + r * cos(theta), r * sin(theta), z, color );
          if ( triangle_normal )
            {
              pVect norm = cross(*v0,*v1,*v2);
              v0->normal = norm; v1->normal = norm; v2->normal = norm;
            }
          else
            {
              v2->normal = pVect(-cos(theta),-sin(theta),0);
            }
          vtx_list.push_back( v0 );
          vtx_list.push_back( v1 );
          vtx_list.push_back( v2 );
        }
      z = next_z;
    }

  {
    pVertex* const v0 = new pVertex( 1.5, 0, -3.2, color_purple );
    pVertex* const v1 = new pVertex( 0, 5, -5, 0xff00 );
    pVertex* const v2 = new pVertex( 9, 6, -9, 0xff );
    pVect norm = cross(*v0,*v1,*v2);
    v0->normal = norm; v1->normal = norm; v2->normal = norm;
    vtx_list.push_back( v0 );
    vtx_list.push_back( v1 );
    vtx_list.push_back( v2 );
  }

  frame_buffer.render_timing_start();

  const int win_width = frame_buffer.get_width();
  const int win_height = frame_buffer.get_height();
  const int fb_size = win_width * win_height;
  int32_t* const f_buffer = frame_buffer.get_buffer();
  float* const z_buffer = (float*) malloc( fb_size * sizeof(*z_buffer) );
  for ( int i=0; i<fb_size; i++ ) z_buffer[i] = 1;

  const float aspect = float(win_width) / win_height;
  pMatrix_Translate center_eye(-1,-0.5,-3);
  pMatrix_Frustrum frustrum(1.6,1.6/aspect,1,5000);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2,win_height/2);
  pMatrix transform_to_eye = center_eye;
  pMatrix transform_to_viewport = scale * center_window * frustrum;
  pMatrix normal_to_eye(transform_to_eye);
  normal_to_eye.transpose(); normal_to_eye.invert3x3();

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      v *= transform_to_eye;
      v.normal *= normal_to_eye;
      v.normal.normalize();
      v.homogenize();
    }

  light_location *= transform_to_eye;

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      pVertex& v = **ci;
      const bool opt_no_lighting = v.color & 0x1000000;
      if ( opt_no_lighting ) continue;
      pVect v_to_light(v,light_location);
      pVect v_to_viewer(v,pCoor(0,0,0));
      const float length = v_to_light.normalize();
      const float dot_v_to_light = dot(v.normal,v_to_light);
      const float dot_v_to_viewer = dot(v.normal,v_to_viewer);
      const float attenuation =
        !opt_attenuation ? 1.0
        : ( 0.5 * opt_light_intensity / ( length*length )
            + opt_light_intensity / length );
      const float v_to_light_scale =
        dot_v_to_viewer < 0 ? -dot_v_to_light : dot_v_to_light;
      const float scale = attenuation
        * ( !opt_v_to_light ? 1.0 : v_to_light_scale );
      v.red *= scale;
      v.green *= scale;
      v.blue *= scale;
    }

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    {
      (**ci) *= transform_to_viewport;
      (**ci).homogenize();
    }

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci += 3 )
    {
      pSortVertices sort(ci);
      pVertex& c0w = sort;
      pVertex& c1w = sort;
      pVertex& c2w = sort;

      pInterpolate interp_02(c0w,c2w,0,win_height-1);
      pInterpolate interp_012(c0w,c1w,0,win_height-1);

      int fb_line_idx = interp_02.yi * win_width;

      while ( interp_02.keep_going_y() )
        {
          if ( ! interp_012.keep_going_y() )
            interp_012.set(c1w,c2w,0,win_height-1);

          pInterpolate interp_line(interp_02,interp_012,0,win_width-1);

          while ( interp_line.keep_going_x() )
            {
              const int fb_idx = fb_line_idx + interp_line.xi;

              if ( z_buffer[ fb_idx ] > interp_line.z )
                {
                  f_buffer[ fb_idx ] = interp_line.color();
                  z_buffer[ fb_idx ] = interp_line.z;
                }

              interp_line.advance_x();
            }

          interp_02.advance_y();  interp_012.advance_y();

          fb_line_idx += win_width;
        }
    }

  for ( pVertex_Iterator ci = vtx_list.begin(); ci < vtx_list.end(); ci++ )
    delete *ci;
  free(z_buffer);
}

void
everything3(pFrame_Buffer &frame_buffer)
{
  // Create Triangles

  pVertex_List vertex_list;
  const int pattern_levels = 30;
  const float pattern_width = 10;
  const float pattern_pitch_x = 1;
  const float pattern_half_pitch_x = pattern_pitch_x / 2;
  const float pattern_pitch_y = 0;
  const float pattern_pitch_z = 0.3;

  const int32_t color_white = 0xffffff00;
  vertex_list.push_back( new pVertex( 15,-5,0.1,color_white ) );
  vertex_list.push_back( new pVertex( 0,5,5,color_white ) );
  vertex_list.push_back( new pVertex( 30,5,9,color_white ) );

  float y = 0;
  float z = -1;
  int32_t color = 0xff000000;
  for ( int i = 0; i < pattern_levels; i++ )
    {
      const float next_y = y + pattern_pitch_y;
      const float next_z = z - pattern_pitch_z;
      float x = 0;
      while ( x < pattern_width )
        {
          vertex_list.push_back( new pVertex( x, y, z, color ) );
          x += pattern_half_pitch_x;
          vertex_list.push_back( new pVertex( x, next_y, next_z, color) );
          x += pattern_half_pitch_x;
          vertex_list.push_back( new pVertex( x, y, z, color ) );
        }
      y = next_y;
      z = next_z;
    }

  // Specify Transformation

  const int win_width = frame_buffer.get_width();
  //  const int win_height = frame_buffer.get_height();
  int32_t* const fb_memory_start = frame_buffer.get_buffer();

  pMatrix_Translate center_eye(-6,-10,0);
  pMatrix_Frustrum frustrum(12,20,1,20);
  pMatrix_Translate center_window(1,1,0);
  pMatrix_Scale scale(win_width/2);
  pMatrix transform = scale * center_window * frustrum * center_eye;

  for ( pVertex_List::iterator ci = vertex_list.begin();
        ci < vertex_list.end();
        ci++ )
    {
      (**ci) *= transform;
      (**ci).homogenize();
    }

  for ( pVertex_List::iterator ci = vertex_list.begin();
        ci < vertex_list.end(); ci += 3 )
    {
      pSortVertices sort(ci);
      pVertex& c0w = sort;
      pVertex& c1w = sort;
      pVertex& c2w = sort;

      const int c0y = (int)c0w.y;
      const int c1y = (int)c1w.y;
      const int c2y = (int)c2w.y;

      float dx_012 = slope(c0w,c1w);
      const float dx_02 = slope(c0w,c2w);
      const int direction = dx_02 < dx_012 ? 1 : -1;

      int32_t *fb_line_start = fb_memory_start + c0y * win_width;

      float x_02 = c0w.x;
      float x_012 = c0w.x;

      for ( int y = c0y;  y < c2y;  y++ )
        {
          if ( y == c1y ) { dx_012 = slope(c1w,c2w);  x_012 = c1w.x; }
          for ( int x = (int)x_02; x != (int)x_012; x += direction )
            fb_line_start[x] = 0xff00ff00;
          fb_line_start += win_width;
          x_02 += dx_02;
          x_012 += dx_012;
        }
    }
}

int
main(int argc, char **argv)
{
  pFrame_Buffer frame_buffer(argc,argv);
  //  frame_buffer.show(render_z_color);
  frame_buffer.show(render_light);
  return 0;
}
