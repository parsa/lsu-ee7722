/// LSU EE X70X-X (Spring 2016), GPU X -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes

#ifndef SHAPES_H
#define SHAPES_H

class Sphere {
public:
  Sphere(){};
  void init(int slices);
  void shadow_volume_init(int slices);
  void bunch_invalidate()
  { world_time_last_update = world_time - 1; }
  void render_bunch_gather(double world_timep);
  void render_bunch_gather_sv();
  void render_bunch_render();
  void render_bunch_render_sv();
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

  bool bunch_rendering;
  GLuint sphere_rot_bo, sphere_sv_rot_bo, sphere_pos_rad_bo, sphere_color_bo;
  pMatrixs sphere_rots, sphere_sv_rots;
  pCoors sphere_pos_rads;
  pColors sphere_colors;

  double world_time;
  double world_time_last_update;

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

void
Sphere::init(int slicesp)
{
  // Compute vertex and texture coordinates of primitives tessellating
  // a unit-radius sphere. Place coordinates in buffer object using
  // pBuffer_Object objects. Also initialize other variables.
  
  bunch_rendering = false;
  sphere_sv_rot_bo = sphere_rot_bo = sphere_pos_rad_bo = sphere_color_bo = 0;
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
Sphere::render_bunch_gather(double world_timep)
{
  world_time = world_timep;
  bunch_rendering = true;
  if ( world_time_last_update == world_time ) return;
  if ( !sphere_color_bo )
    {
      glGenBuffers(1, &sphere_rot_bo);
      glGenBuffers(1, &sphere_pos_rad_bo);
      glGenBuffers(1, &sphere_color_bo);
    }
  sphere_rots.clear();
  sphere_pos_rads.clear();
  sphere_colors.clear();
}

void
Sphere::render_bunch_gather_sv()
{
  bunch_rendering = true;
  if ( !sphere_sv_rot_bo ) glGenBuffers(1, &sphere_sv_rot_bo );
  sphere_sv_rots.clear();
}

void
Sphere::render_bunch_render()
{
  const bool first_render = world_time_last_update != world_time;
  world_time_last_update = world_time;

# define TO_BO(name,num) \
  glBindBuffer(GL_ARRAY_BUFFER,name##_bo); \
  if ( first_render ) glBufferData \
    (GL_ARRAY_BUFFER, name##s.size_chars(), name##s.data(), GL_STREAM_DRAW); \
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,num,name##_bo);

  TO_BO(sphere_rot,1);
  TO_BO(sphere_pos_rad,2);
  TO_BO(sphere_color,3);
# undef TO_BO
  glBindBuffer(GL_ARRAY_BUFFER,0);

  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);
  points_bo.bind();
  glVertexPointer(3,GL_FLOAT,sizeof(points_bo[0]),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  tex_coord_bo.bind();
  glTexCoordPointer(2,GL_FLOAT,0,0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDrawArraysInstanced
    (GL_TRIANGLE_STRIP,0,points_bo.elements,sphere_pos_rads.size());
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisable(GL_CULL_FACE);
  glBindBuffer(GL_ARRAY_BUFFER,0);
}

void
Sphere::render()
{
  if ( opt_render_flat ) { render_flat(); return; }
  if ( tri_count ) *tri_count += points_bo.elements;

  if ( bunch_rendering )
    {
      if ( world_time == world_time_last_update ) return;
      if ( !default_orientation )
        sphere_rots += rotation_matrix;
      pCoor pos_rad(center);  pos_rad.w = radius;
      sphere_pos_rads += pos_rad;
      sphere_colors += color;
      return;
    }
  glColor3fv(color);
  glMatrixMode(GL_MODELVIEW);

  glPushMatrix();
  glTranslatef(center.x,center.y,center.z);
  glScalef(radius,radius,radius);
  if ( !default_orientation ) glMultTransposeMatrixf(rotation_matrix);

  glEnable(GL_CULL_FACE);
  glCullFace(GL_BACK);
  points_bo.bind();
  glVertexPointer(3,GL_FLOAT,sizeof(points_bo[0]),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormalPointer(GL_FLOAT,sizeof(points_bo[0]),0);
  glEnableClientState(GL_NORMAL_ARRAY);
  tex_coord_bo.bind();
  glTexCoordPointer(2,GL_FLOAT,0,0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDrawArrays(GL_TRIANGLE_STRIP,0,points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glPopMatrix();
  glDisable(GL_CULL_FACE);
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
  glVertexPointer(3,GL_FLOAT,sizeof(points_bo[0]),0);
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

  if ( bunch_rendering )
    {
      sphere_sv_rots += transform;
      return;
    }

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glMultTransposeMatrixf(transform);

  shadow_volume_points_bo.bind();
  glVertexPointer(3,GL_FLOAT,sizeof(shadow_volume_points_bo[0]),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_QUAD_STRIP,0,shadow_volume_points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glPopMatrix();
}

void
Sphere::render_bunch_render_sv()
{
# define TO_BO(name,num) \
  glBindBuffer(GL_ARRAY_BUFFER,name##_bo); \
  glBufferData \
    (GL_ARRAY_BUFFER, name##s.size_chars(), name##s.data(), GL_STREAM_DRAW); \
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER,num,name##_bo);

  TO_BO(sphere_sv_rot,1);
# undef TO_BO
  glBindBuffer(GL_ARRAY_BUFFER,0);

  glDisable(GL_CULL_FACE);

  shadow_volume_points_bo.bind();
  glVertexPointer(3,GL_FLOAT,sizeof(shadow_volume_points_bo[0]),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArraysInstanced
    (GL_QUAD_STRIP,0,shadow_volume_points_bo.elements, sphere_rots.size());

  glDisableClientState(GL_VERTEX_ARRAY);
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
