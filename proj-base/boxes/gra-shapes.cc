/// LSU EE X70X GPU Prog / Microarch
//
 /// Graphical model of sphere and some other shapes.

#include "gra-shapes.h"

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
  tri_count = NULL;
  opt_render_flat = false;
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
  if ( opt_render_flat ) { render_flat(); return; }
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
  if ( tri_count ) *tri_count += points_bo.elements;
}

void
Sphere::render_flat()
{
  // Render using normal based on triangle normal, rather than sphere normal.
  // Used to emphasize tessellation.

  glColor3fv(color);
  glMatrixMode(GL_MODELVIEW);

  glPushMatrix();
  glTranslatef(center.x,center.y,center.z);
  glScalef(radius,radius,radius);
  if ( !default_orientation ) glMultTransposeMatrixf(rotation_matrix);

  glBegin(GL_TRIANGLES);
  for ( int i=0; i<points_bo.elements-2; i++ )
    {
      pCoor p1(points_bo[i]);
      pCoor p2(points_bo[i+1]);
      pCoor p3(points_bo[i+2]);
      pVect n(p3,p2,p1);
      glNormal3fv(n);
      glTexCoord2fv(&tex_coord_bo[i<<1]);   glVertex3fv(p1);
      glTexCoord2fv(&tex_coord_bo[(i+1)<<1]); glVertex3fv(p2);
      glTexCoord2fv(&tex_coord_bo[(i+2)<<1]); glVertex3fv(p3);
    }
  glEnd();

  glPopMatrix();
  if ( tri_count ) *tri_count += points_bo.elements;
}

void
Sphere::render_simple(float radiusp, pVect position)
{
  radius = radiusp;
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
  if ( tri_count ) *tri_count += points_bo.elements;
}

void
Sphere::shadow_volume_init(int pieces)
{
  const double delta_theta = 2 * M_PI / pieces;
  const float height = 100;
  PStack<pVect> coords;
  pVect norm1(1,0,0);
  pVect binorm1(0,1,0);
  pVect norm2(height,0,0);
  pVect binorm2(0,height,0);
  const pVect center1(0,0,1);
  const pVect center2(0,0,height);

  for ( int i=0; i<=pieces; i++ )
    {
      const double theta = i * delta_theta;
      const float co = cos(theta);
      const float si = sin(theta);
      pVect c1 = center1 + co * norm1 + si * binorm1;
      pVect c2 = center2 + co * norm2 + si * binorm2;
      coords += c1;
      coords += c2;
    }
  shadow_volume_points_bo.take(coords,GL_STATIC_DRAW);
  shadow_volume_points_bo.to_gpu();
}

void
Sphere::render_shadow_volume(float radiusp, pCoor center)
{
  radius = radiusp;
  const float radius_loose = radius * 1.001;
  pNorm l_to_c_dir(light_pos,center);
  const float limb_distance_sq = l_to_c_dir.mag_sq-radius_loose*radius_loose;
  const float limb_distance = sqrt(limb_distance_sq);
  const float center1_distance = limb_distance_sq / l_to_c_dir.magnitude;
  const float r1 = limb_distance * radius_loose/l_to_c_dir.magnitude;

  pMatrix scale1;
  scale1.set_identity();
  scale1.rc(0,0) = r1;
  scale1.rc(1,1) = r1;
  scale1.rc(2,2) = center1_distance;
  pMatrix_Rotation_Shortest rot(pVect(0,0,1),l_to_c_dir);
  pMatrix_Translate tr(light_pos);

  pMatrix transform = tr * rot * scale1;

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glMultTransposeMatrixf(transform);

  shadow_volume_points_bo.bind();
  glVertexPointer(3,GL_FLOAT,0,0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_QUAD_STRIP,0,shadow_volume_points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glPopMatrix();
}
