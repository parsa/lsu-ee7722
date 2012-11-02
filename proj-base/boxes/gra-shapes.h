/// LSU EE X70X-X (Fall 2012), GPU X -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes

// $Id:$

#ifndef GRA_SHAPES_H
#define GRA_SHAPES_H

#include "boxes.h"

class Sphere {
public:
  Sphere(){};
  void init(int slices);
  void shadow_volume_init(int slices);
  void render();
  void render(float radiusp, pVect position)
  { radius = radiusp;  center = position; render(); }
  void render_flat();
  void render_simple(float radius, pVect position);
  void render(float radiusp, pVect position, pVect axisp, double anglep)
  {
    radius = radius; center = position; axis = axisp;  angle = anglep;
    rotation_matrix_compute();
    render();
  }
  void render(float radiusp, pVect position, pMatrix orientation)
  {
    radius = radiusp;
    center = position;  rotation_matrix = orientation;  axis = pVect(0,0,0);
    default_orientation = false;
    render();
  }

  void render_shadow_volume(float radius, pCoor position);
  void rotation_matrix_compute();
  int slices;
  pBuffer_Object<pVect> points_bo;
  pBuffer_Object<float> tex_coord_bo;
  pBuffer_Object<pVect> shadow_volume_points_bo;

  pCoor light_pos;
  pCoor center;
  pVect axis, axis_prepared;
  double angle, angle_prepared;
  float radius;
  pColor color;
  pMatrix rotation_matrix;
  bool default_orientation;
  bool opt_render_flat;
  int* tri_count; // Cumulative count of triangles rendered.
};

class Cone {
public:
  Cone(){};
  void render(pCoor base, float radius, pVect to_apex, float apex_radius_frac=0.1)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_height = 1;
    const double apex_radius = apex_radius_frac;
    const double alpha = atan2(apex_height,base_radius-apex_radius);
    const double vec_z = sin(alpha);
    const float to_height = to_apex.mag();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pVect rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);
    glTranslatef(base.x,base.y,base.z);
    glRotatef(rot_angle * 180.0 / M_PI,rn.x,rn.y,rn.z);
    glScalef(radius,radius,to_height);
    glBegin(GL_QUAD_STRIP);
    for ( int i=0; i<=sides; i++ )
      {
        const double theta = delta_theta * i;
        const double cos_t = cos(theta);
        const double sin_t = sin(theta);
        glNormal3f( cos_t, sin_t, vec_z );
        glVertex3f( apex_radius * cos_t, apex_radius * sin_t, apex_height);
        glVertex3f( base_radius * cos_t, base_radius * sin_t, 0);
      }
    glEnd();
    glPopMatrix();
  }
};

// Display a tetrahedron, used to indicate light position.
//
inline void
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

#endif
