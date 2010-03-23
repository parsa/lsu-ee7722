/// LSU EE X70X-X (Spring 2010), GPU X -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes

// $Id:$

#ifndef SHAPES_H
#define SHAPES_H

class Sphere {
public:
  Sphere(){};
  void init(int slices);
  void shadow_volume_init(int slices);
  void render();
  void render(pVect position){ center = position; render(); }
  void render_simple(pVect position);
  void render(pVect position, pVect axisp, double anglep)
  {
    center = position; axis = axisp;  angle = anglep;
    rotation_matrix_compute();
    render();
  }
  void render(pVect position, pMatrix orientation)
  {
    center = position;  rotation_matrix = orientation;  axis = pVect(0,0,0);
    default_orientation = false;
    render();
  }

  void render_shadow_volume(pCoor position);
  void render_shadow_volume2(pCoor position);
  void rotation_matrix_compute();
  int slices;
  pBuffer_Object<pVect> points_bo;
  pBuffer_Object<float> tex_coord_bo;
  pCoor light_pos;
  pCoor center;
  pVect axis, axis_prepared;
  double angle, angle_prepared;
  float radius;
  pColor color;
  pMatrix rotation_matrix;
  bool default_orientation;
};

void
Sphere::init(int slicesp)
{
  // Compute vertex and texture coordinates of primitives tessellating
  // a unit-radius sphere. Place coordinates in buffer object using
  // pBuffer_Object objects. Also initialize other variables.
  
  slices = slicesp;             // Amount of detail.
  axis = pVect(0,1,0);
  angle = 0;
  radius = 2;
  default_orientation = true;
  color = pColor(0xf9b237); // LSU Spirit Gold
  const double two_pi = 2.0 * M_PI;
  const double delta_theta = two_pi / slices;
  const double delta_eta = M_PI / ( slices >> 1 );
  const double epsilon = 0.001 * delta_theta;
  const double pi_me = M_PI - epsilon;  // pi minus epsilon.
  const double two_pi_me = two_pi - epsilon;
  PStack<pVect> points;
  PStack<float> tex_coord;
  bool up = true;
  points += pVect(0,1,0);
  tex_coord += 1-(delta_theta/two_pi) * 0.5;  tex_coord += 0;
  for ( double theta = 0; theta < two_pi_me; theta += delta_theta )
    {
      const double theta1 = theta + delta_theta;
      const double cos_th0 = cos(theta);
      const double sin_th0 = sin(theta);
      const double cos_th1 = cos(theta1);
      const double sin_th1 = sin(theta1);
      const float tc_s0 = theta / two_pi;
      const float tc_s1 = theta1 / two_pi;
      for ( double eta_r = delta_eta; eta_r < pi_me; eta_r += delta_eta )
        {
          const double eta = up ? M_PI - eta_r : eta_r;
          const float y = cos(eta);
          const double slice_r = sin(eta);
          const float x0 = slice_r * cos_th0;
          const float z0 = slice_r * sin_th0;
          const float tc_t = eta / M_PI;
          points += pVect(x0,y,z0);
          tex_coord += 1-tc_s0;  tex_coord += tc_t;
          points += pVect(slice_r * cos_th1, y, slice_r * sin_th1);
          tex_coord += 1-tc_s1;  tex_coord += tc_t;
        }
      points += pVect(0,up ? 1 : -1,0);
      tex_coord += 1-(tc_s0 + tc_s1) * 0.5;  tex_coord += up ? 0 : 1;
      up = !up;
    }
  points_bo.take(points,GL_STATIC_DRAW);
  points_bo.to_gpu();
  tex_coord_bo.take(tex_coord,GL_STATIC_DRAW);
  tex_coord_bo.to_gpu();
  shadow_volume_init(slicesp);
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
  glColor3fv(color);
  glMatrixMode(GL_MODELVIEW);

  glPushMatrix();
  glTranslatef(center.x,center.y,center.z);
  glScalef(radius,radius,radius);
  if ( !default_orientation ) glMultTransposeMatrixf(rotation_matrix);

  points_bo.bind();
  glVertexPointer(3,GL_FLOAT,0,0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormalPointer(GL_FLOAT,0,0);
  glEnableClientState(GL_NORMAL_ARRAY);
  tex_coord_bo.bind();
  glTexCoordPointer(2,GL_FLOAT,0,0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDrawArrays(GL_TRIANGLE_STRIP,0,points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glPopMatrix();
}

void
Sphere::render_simple(pVect position)
{
  glMatrixMode(GL_MODELVIEW);

  glPushMatrix();
  glTranslatef(position.x,position.y,position.z);
  glScalef(radius,radius,radius);

  points_bo.bind();
  glVertexPointer(3,GL_FLOAT,0,0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_TRIANGLE_STRIP,0,points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glPopMatrix();
}

void
Sphere::shadow_volume_init(int pieces)
{
  // Put solution to Spring 2010 Homework 2 here.
}

void
Sphere::render_shadow_volume2(pCoor center)
{
  // Put solution to Spring 2010 Homework 2 here.
}

void
Sphere::render_shadow_volume(pCoor center)
{
  // Compute shadow volume of sphere, and render it.

  const int pieces = slices;   // Number of faces needed for the shadow volume.
  const double delta_theta = 2 * M_PI / pieces;
  pVect l_to_c(light_pos,center);
  const float l_to_c_mag_sq = dot(l_to_c,l_to_c);
  const float l_to_c_mag = sqrt(l_to_c_mag_sq);

  // Note: a limb is the outline of a sphere visible from some position,
  // in this case the light position. (It is not the same as the
  // circumference unless the position is at infinite distance.)

  const float limb_distance_sq = l_to_c_mag_sq-radius*radius;
  const float limb_distance = sqrt(limb_distance_sq);

  // The shadow volume is enclosed by two disks. Disk 1 cuts the
  // sphere, and its circumference is the limb. Disk 2 is at a
  // distance height (some large number) from the light. Variable
  // names ending in 1 refer to disk 1, those ending in 2 refer to
  // disk 2.

  const float height = 1000;
  const float center1_distance = limb_distance_sq / l_to_c_mag;
  pVect center1 = light_pos + center1_distance / l_to_c_mag * l_to_c;
  const float r1 = limb_distance * radius/l_to_c_mag;

  // Find two orthogonal vectors (norm and binorm) in disk 1's plane,
  // and set them up for computing disk 1 coordinates.
  //
  pVect plus_a = l_to_c.y == 0 && l_to_c.z == 0 ? pVect(0,1,0) : pVect(1,0,0);
  pNorm norm1 = cross(l_to_c,plus_a);
  pNorm binorm1 = cross(norm1,l_to_c);
  pVect norms1 = r1 * norm1;
  pVect binorms1 = r1 * binorm1;

  // Compute center and orthogonal vectors for disk 1.
  //
  const float ratio = height / limb_distance;
  pCoor center2 = light_pos + ratio * l_to_c;
  const float r2 = r1 * ratio;
  pVect norms2 = r2 * norm1;
  pVect binorms2 = r2 * binorm1;

  // Send primitives to OpenGL
  //
  glBegin(GL_QUAD_STRIP);
  for ( int i=0; i<=pieces; i++ )
    {
      const double theta = i * delta_theta;
      const float co = cos(theta);
      const float si = sin(theta);
      pCoor c1 = center1 + co * norms1 + si * binorms1;
      pCoor c2 = center2 + co * norms2 + si * binorms2;
      glVertex3fv(c2);
      glVertex3fv(c1);
    }
  glEnd();
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
