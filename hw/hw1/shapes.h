/// LSU EE 4702-1 (Fall 2009), GPU Programming -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes

// $Id:$

#ifndef SHAPES_H
#define SHAPES_H

class Sphere {
public:
  Sphere(){};
  void init(int slices);
  void render();
  void render(pVect position){ center = position; render(); }
  void render(pVect position, pVect axisp, double anglep)
  {
    center = position; axis = axisp;  angle = anglep;
    rotation_matrix_compute();
    render();
  }
  void rotation_matrix_compute();
  int slices;
  pBuffer_Object<pVect> points_bo;
  pBuffer_Object<float> tex_coord_bo;
  PStack<int> strip_starts;
  PStack<int> strip_sizes;
  pCoor center;
  pVect axis, axis_prepared;
  double angle, angle_prepared;
  pMatrix rotation_matrix;
  bool default_orientation;
};

void
Sphere::init(int slicesp)
{
  slices = slicesp;
  axis = pVect(0,1,0);
  angle = 0;
  default_orientation = true;
  const double two_pi = 2.0 * M_PI;
  const double delta_theta = two_pi / slices;
  const double epsilon = 0.001 * delta_theta;
  const double pi_me = M_PI - epsilon;
  const double two_pi_me = two_pi - epsilon;
  PStack<pVect> points;
  PStack<float> tex_coord;
  for ( double theta = 0; theta < two_pi_me; theta += delta_theta )
    {
      const int point_count = points.occ();
      strip_starts += point_count;
      const double theta1 = theta + delta_theta;
      const double cos_th0 = cos(theta);
      const double sin_th0 = sin(theta);
      const double cos_th1 = cos(theta1);
      const double sin_th1 = sin(theta1);
      const float tc_s0 = theta / two_pi;
      const float tc_s1 = theta1 / two_pi;
      points += pVect(0,1,0);
      tex_coord += 1-(tc_s0 + tc_s1) * 0.5;  tex_coord += 0;
      for ( double eta = delta_theta; eta < pi_me; eta += delta_theta )
        {
          const float y = cos(eta);
          const double slice_r = sin(eta);
          const float x0 = slice_r * cos_th0;
          const float z0 = slice_r * sin_th0;
          const float tc_t = eta / M_PI;
          points += pVect(slice_r * cos_th1, y, slice_r * sin_th1);
          tex_coord += 1-tc_s1;  tex_coord += tc_t;
          points += pVect(x0,y,z0);
          tex_coord += 1-tc_s0;  tex_coord += tc_t;
        }
      points += pVect(0,-1,0);
      tex_coord += 1-(tc_s0 + tc_s1) * 0.5;  tex_coord += 1;
      strip_sizes += points.occ() - point_count;
    }
  points_bo.take(points);
  points_bo.to_gpu();
  tex_coord_bo.take(tex_coord);
  tex_coord_bo.to_gpu();
}

void
Sphere::rotation_matrix_compute()
{
  pVect up(0,1,0);
  default_orientation = axis == up && angle == 0;
  if ( default_orientation ) return;
  if ( angle == angle_prepared && axis == axis_prepared ) return;
  pMatrix_Rotation orient_axis(up,axis);
  pMatrix_Rotation rotate(up,angle);
  rotation_matrix = orient_axis * rotate;
  angle_prepared = angle;  axis_prepared = axis;
}

void
Sphere::render()
{
  const pColor lsu_spirit_gold(0xf9b237);
  glColor3fv(lsu_spirit_gold);
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glTranslatef(center.x,center.y,center.z);
  glScalef(2,2,2);
  if ( !default_orientation ) glMultTransposeMatrixf(rotation_matrix);
  points_bo.bind();
  glVertexPointer(3,GL_FLOAT,0,0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormalPointer(GL_FLOAT,0,0);
  glEnableClientState(GL_NORMAL_ARRAY);
  tex_coord_bo.bind();
  glTexCoordPointer(2,GL_FLOAT,0,0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glMultiDrawArrays
    (GL_TRIANGLE_STRIP,
     strip_starts.get_storage(), strip_sizes.get_storage(), slices);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glPopMatrix();
}


class Cone {
public:
  Cone(){};
  void render(pCoor base, float radius, pVect to_apex)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_radius = 0.1;
    const double apex_height = 1;
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
