/// LSU EE 7700-2 (Sp 08), Graphics Processors
//
 /// Simple OpenGL

// $Id:$

 /// Purpose
//
//   Demonstrate vertex transfer overhead.

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


// Points. (The pedagogical kind.)

// Individually specifying vertices risks high overhead, ymmv.
//  Each vtx call could trigger communication with GPU.
//  Better to buffer large numbers of vertices.

// Buffering Methods
//  Common: Array of vertices.

//  Copy info from client memory for each draw.
//   + Save function call overhead.
//   + GL can better plan logistics.

//  Put "arrays" under GL control.


// From Client Memory
//  Indicate for each attribute..
//  Draw Array
//  Disconnect.

// Buffer Objects
//  Blocks of memory..
//  ..can be read and written by CPU..
//  ..or by GPU.
//  

// From GPU Memory
//  



#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include "util.h"
#include "coord.h"

// Add an unlighted tetrahedron to VTX_LIST at LOC of size SIZE.
//
void
insert_tetrahedron(pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
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

class MTrig {
public:
  MTrig(int size):size(size),storage(new float[size]),idx(0),full(false){}
  float sin(float theta){ return trig(theta,::sin); }
  float cos(float theta){ return trig(theta,::cos); }
private:
  float trig(float theta,double (*func)(double))
  {
    if ( !full ) { storage[idx] = func(theta);  full = idx == size - 1; }
    if ( idx == size ) idx = 0;
    return storage[idx++];
  }
  const int size;
  float* const storage;
  int idx;
  bool full;
};


void
render_tube(pFrame_Buffer &frame_buffer, void *data)
{
  frame_buffer.frame_timer.frame_start();
  glClearColor(0,0,0.0,0.5);
  glClearDepth(1.0);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  frame_buffer.fbprintf("%s\n",frame_buffer.frame_timer.frame_rate_text_get());

  // This routine will be called automatically each time the frame
  // buffer needs to be painted.

  const float r0 = 2;                  // Tube radius.
  const float x_shift = 0.4;          // Tube x offset.
  const int pattern_levels = 250;      // Tube depth (z direction.)
  const float pattern_width = 200;     // Triangle size (circumferential).
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

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-0.8,+0.8,-0.8/aspect,0.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();


  ///
  /// Light Location and Lighting Options
  ///

  static float opt_light_intensity = 2;
  static int opt_v_buffering = 0;
  static bool opt_recompute = true;
  static pCoor light_location(( r0 - 0.1 ), 0, -3 );

  // Adjust options based on user input.
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
  case 'r':case 'R': opt_recompute = !opt_recompute; break;
  case 'v': case 'V':
    opt_v_buffering++;
    if ( opt_v_buffering == 3 ) opt_v_buffering = 0;
    break;
  default: break;
  }

  static bool buffer_data_0 = false;

  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};
  const float light_dim[4] = {0.1,0.1,0.1,1};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_dim[0]);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
  glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  // User Messages 
  //
  frame_buffer.fbprintf("Arrows, page up/down move light.\n");
  frame_buffer.fbprintf("Vertex buffering: %d (v to change)\n",opt_v_buffering);

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(light_location,0.05);

  //
  // Insert a tessellated tube in the vertex list.
  //

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold

  const int vertices_per_ring = 3 * int(pattern_width) * 2;
  const int num_coor = pattern_levels * vertices_per_ring;

  static double time_app_start = -1;
  if ( time_app_start < 0 ) time_app_start = time_wall_fp();
  const double cycles_per_second = 0.2;
  const double phase_n =
    ( time_wall_fp() - time_app_start ) * cycles_per_second;
  const double phase = phase_n * 2.0 * M_PI;
  const double phase_01 = 1.0 - ( phase_n - floor(phase_n) );

  const float wavelength_z = 4.8;
  const float wavelength_rings = wavelength_z / pattern_pitch_z;
  const float radians_per_z = 2.0 * M_PI / wavelength_z;
  const int wavelength_v = int(wavelength_rings * vertices_per_ring + 0.5);

  const int phase_rings = int( phase_01 * wavelength_rings + 0.5 );

  const float phase_z = opt_recompute ? 0 : wavelength_z * phase_01;
  const int phase_v = opt_recompute ? 0 : phase_rings * vertices_per_ring;

  if ( phase_v > wavelength_v || phase_v < 0 ) pError_Exit();

  const int num_v = num_coor - wavelength_v;

  const float ampl = 0.4;

  glEnable(GL_NORMALIZE);
  
  glColor3fv( color_gold );

  static pCoor* coor_buffer = NULL;
  static pVect* norm_buffer = NULL;

  if ( !coor_buffer )
    {
      coor_buffer = new pCoor[num_coor];
      norm_buffer = new pVect[num_coor];
    }

  static MTrig tarray( int(pattern_width) * 2 * 2 * 6 );
  pCoor* cptr = coor_buffer;
  pVect* nptr = norm_buffer;
  static bool buffer_initialized = false;
  static GLuint gpu_coor_buffer = 0;
  static GLuint gpu_norm_buffer = 0;

  // Outer Loop: z axis (down axis of tube).
  //
  if ( opt_recompute || !buffer_data_0 )
    {
      const float phase_use = opt_recompute ? phase : 0;

      for ( int i = 0; i < pattern_levels; i++ )
        {
          const float next_z = z - pattern_pitch_z;
          const float last_z = z + pattern_pitch_z;
          const float delta_theta = M_PI / pattern_width;
          float theta = i & 1 ? delta_theta : 0;
          const float angle_z = phase_use + radians_per_z * z;
          const float angle_nz = phase_use + radians_per_z * next_z;
          const float angle_lz = phase_use + radians_per_z * last_z;
          const float r = r0 * ( 1 + ampl * sin( angle_z ) );
          const float rnz = r0 * ( 1 + ampl * sin( angle_nz ) );
          const float rlz = r0 * ( 1 + ampl * sin( angle_lz ) );
          const float cos_z = cos(angle_z);
          const float cos_lz = cos(angle_lz);
          const float cos_nz = cos(angle_nz);

          // Inner Loop: around circumference of tube.
          //
          while ( theta < 4 * M_PI )
            {
              const bool first_round = theta < 2 * M_PI;
              const float z1 = first_round ? next_z : last_z;
              const float rz1 = first_round ? rnz : rlz;
              const float cos_z1 = first_round ? cos_nz : cos_lz;

              float cos_theta = tarray.cos(theta);  // Reassigned
              float sin_theta = tarray.sin(theta);  // Reassigned

              pCoor v0(x_shift + r * cos_theta, r * sin_theta, z);
              pVect v0_normal(-cos_theta,-sin_theta,cos_z);

              theta += delta_theta;

              cos_theta = tarray.cos(theta);
              sin_theta = tarray.sin(theta);

              pCoor v1(x_shift + rz1 * cos_theta, rz1 * sin_theta, z1);
              pVect v1_normal(-cos_theta,-sin_theta,cos_z1);

              theta += delta_theta;

              cos_theta = tarray.cos(theta);
              sin_theta = tarray.sin(theta);

              pCoor v2(x_shift + r * cos_theta, r * sin_theta, z);
              pVect v2_normal(-cos_theta,-sin_theta,cos_z);

              *nptr++ = v0_normal;
              *nptr++ = v1_normal;
              *nptr++ = v2_normal;

              *cptr++ = v0;
              *cptr++ = v1;
              *cptr++ = v2;

#if 0
              glBegin(GL_TRIANGLES);

              glNormal3fv(v0_normal);  glVertex3fv(v0);
              glNormal3fv(v1_normal);  glVertex3fv(v1);
              glNormal3fv(v2_normal);  glVertex3fv(v2);

              glEnd();
#endif
            }
          z = next_z;
        }

      if ( !gpu_norm_buffer )
        {
          glGenBuffers(1,&gpu_norm_buffer);
          glGenBuffers(1,&gpu_coor_buffer);
        }


      if ( !opt_recompute || opt_v_buffering == 2 )
        {
          glBindBuffer(GL_ARRAY_BUFFER, gpu_norm_buffer);
          glBufferData(GL_ARRAY_BUFFER, num_coor * sizeof(pVect),
                       norm_buffer, GL_STATIC_DRAW);
          glBindBuffer(GL_ARRAY_BUFFER, gpu_coor_buffer);
          glBufferData(GL_ARRAY_BUFFER, num_coor * sizeof(pCoor),
                       coor_buffer, GL_STATIC_DRAW);
          glBindBuffer(GL_ARRAY_BUFFER, 0);
        }

      buffer_data_0 = !opt_recompute;
    }

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glTranslatef(0,0,phase_z);
  
  switch ( opt_v_buffering ) {
  case 0:
    {
      glBegin(GL_TRIANGLES);
      const int end_v = phase_v + num_v;
      for ( int i=phase_v; i<end_v; i++ )
        {
          glNormal3fv(norm_buffer[i]);
          glVertex3fv(coor_buffer[i]);
        }
      glEnd();
    }
    break;
  case 1:
    {
      glNormalPointer(GL_FLOAT,0,norm_buffer);
      glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
      glEnableClientState(GL_NORMAL_ARRAY);
      glEnableClientState(GL_VERTEX_ARRAY);
      glDrawArrays(GL_TRIANGLES,phase_v,num_v);
      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);
    }
    break;
  case 2:
    {
      glBindBuffer(GL_ARRAY_BUFFER,gpu_coor_buffer);
      glVertexPointer(3,GL_FLOAT,sizeof(pCoor),NULL);
      glBindBuffer(GL_ARRAY_BUFFER,gpu_norm_buffer);
      glNormalPointer(GL_FLOAT,0,NULL);
      glBindBuffer(GL_ARRAY_BUFFER,0);
      glEnableClientState(GL_NORMAL_ARRAY);
      glEnableClientState(GL_VERTEX_ARRAY);
      glDrawArrays(GL_TRIANGLES,phase_v,num_v);
      glDisableClientState(GL_NORMAL_ARRAY);
      glDisableClientState(GL_VERTEX_ARRAY);
    }
    break;
  }

  glPopMatrix();

  // Insert additional triangle.
  //
  {
    pCoor v0( 1.5, 0, -3.2 );
    pCoor v1( 0, 5, -5 );
    pCoor v2( 9, 6, -9 );
    pVect normal(cross(v0,v1,v2));

    glColor3fv( color_purple );

    glBegin(GL_TRIANGLES);

    glNormal3fv(normal);  glVertex3fv(v0);
    glNormal3fv(normal);  glVertex3fv(v1);
    glNormal3fv(normal);  glVertex3fv(v2);

    glEnd();

  }

  pError_Check();

  frame_buffer.frame_timer.frame_end();

  glutSwapBuffers();

}

int
main(int argc, char **argv)
{
  pFrame_Buffer popengl_info(argc,argv);

  popengl_info.rate_set(30);
  popengl_info.display_cb_set(render_tube,NULL);

  return 0;
}
