/// LSU EE X70X-X (Fall 2015), GPU X -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes

// $Id:$

#ifndef SHAPES_H
#define SHAPES_H

class Sphere {
public:
  Sphere(){ opt_texture = true; };
  void init(int slices);
  void shadow_volume_init(int slices);
  void render();
  void render(pVect position){ center = position; render(); }
  void render(pVect position, pVect axisp, double anglep)
   {
     center = position; axis = axisp;  angle = anglep;
     rotation_matrix_compute();
     render();
   }
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
  bool opt_texture;
  int* tri_count; // Cumulative count of triangles rendered. 
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
  if ( opt_texture )
    {
      glTexCoordPointer(2,GL_FLOAT,0,0);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
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


class Cone {
public:
  Cone(){ apex_radius = 0.1; dont_set_color = true; };
  void render_shadow_volume(pCoor base, float radius, pVect to_apex)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_height = 1;
    const float to_height = to_apex.mag();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pNorm rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);

    pMatrix_Translate trans_transl(base);
    pMatrix_Rotation trans_rot(rn,rot_angle);
    pMatrix_Scale trans_scale(radius); trans_scale.rc(2,2) = to_height;
    pMatrix xform = trans_transl * trans_rot * trans_scale;

    glMultTransposeMatrixf(xform.a);

    pMatrix inv = invert(xform);
    pCoor light_local = inv * light_pos;

    pCoor ptop(0,0,apex_height);
    pCoor pbottom(0,0,0);
    pCoor p00, p01;
    const float height = 1000;

    for ( int i=0; i<=sides; i++ )
      {
        const double theta = delta_theta * i;
        const double cos_t = cos(theta);
        const double sin_t = sin(theta);
        pCoor p10( apex_radius * cos_t, apex_radius * sin_t, apex_height);
        pCoor p11( base_radius * cos_t, base_radius * sin_t, 0);
        if ( i )
          {
            pNorm l_to_00(light_local,p00);
            pCoor p00_2 = p00 + height * l_to_00;
            pCoor p01_2 = p01 + height * pNorm(light_local,p01);
            pCoor p10_2 = p10 + height * pNorm(light_local,p10);
            pCoor p11_2 = p11 + height * pNorm(light_local,p11);
            pVect quad_normal = cross(p00,p01,p11);
            const bool facing_light = dot(quad_normal,l_to_00) > 0;
            glFrontFace(facing_light ? GL_CCW : GL_CW );

            glBegin(GL_QUAD_STRIP);
            glVertex3fv(p00);
            glVertex3fv(p00_2);
            glVertex3fv(p01);
            glVertex3fv(p01_2);
            glVertex3fv(p11);
            glVertex3fv(p11_2);
            glVertex3fv(p10);
            glVertex3fv(p10_2);
            glVertex3fv(p00);
            glVertex3fv(p00_2);
            glEnd();
          }
        p00 = p10;
        p01 = p11;
      }

    glPopMatrix();
    glFrontFace(GL_CCW);
  }
  void render(pCoor base, float radius, pVect to_apex)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_height = 1;
    const double alpha = atan2(apex_height,base_radius-apex_radius);
    const double vec_z = sin(alpha);
    const float to_height = to_apex.mag();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pNorm rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);
    pMatrix_Translate trans_transl(base);
    pMatrix_Rotation trans_rot(rn,rot_angle);
    pMatrix_Scale trans_scale(radius); trans_scale.rc(2,2) = to_height;
    pMatrix xform = trans_transl * trans_rot * trans_scale;

    glMultTransposeMatrixf(xform.a);

    if ( !dont_set_color ) glColor3fv(color);
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

  void set_color(const pColor &c) { color = c;  dont_set_color = false; }

  bool dont_set_color;
  pColor color;
  pCoor light_pos;
  double apex_radius;
};

class Cylinder {
public:
  Cylinder(){ dont_set_color = true; inited = false; };

  void init()
  {
    PStack<pVect> points;
    PStack<pVect> normals;
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;

    for ( int i=0; i<=sides; i++ )
      {
        const double theta = delta_theta * i;
        const double cos_t = cos(theta);
        const double sin_t = sin(theta);
        normals += pVect( cos_t, sin_t, 0 );
        normals += pVect( cos_t, sin_t, 0 );
        points += pVect( cos_t, sin_t, 1 );
        points += pVect( cos_t, sin_t, 0 );
      }
    points_bo.take(points,GL_STATIC_DRAW);
    points_bo.to_gpu();
    normals_bo.take(points,GL_STATIC_DRAW);
    normals_bo.to_gpu();
    inited = true;
  }

  void render_shadow_volume_exact(pCoor base, float radius, pVect to_apex)
  {
    const int sides = 10;
    const double delta_theta = 2 * M_PI / sides;
    const double base_radius = 1;
    const double apex_height = 1;
    const float to_height = to_apex.mag();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pNorm rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);

    pMatrix_Translate trans_transl(base);
    pMatrix_Rotation trans_rot(rn,rot_angle);
    pMatrix_Scale trans_scale(radius); trans_scale.rc(2,2) = to_height;
    pMatrix xform = trans_transl * trans_rot * trans_scale;

    glMultTransposeMatrixf(xform.a);

    pMatrix inv = invert(xform);
    pCoor light_local = inv * light_pos;

    pCoor ptop(0,0,apex_height);
    pCoor pbottom(0,0,0);
    pCoor p00, p01;
    const float height = 1000;

    for ( int i=0; i<=sides; i++ )
      {
        const double theta = delta_theta * i;
        const double cos_t = cos(theta);
        const double sin_t = sin(theta);
        pCoor p10( apex_radius * cos_t, apex_radius * sin_t, apex_height);
        pCoor p11( base_radius * cos_t, base_radius * sin_t, 0);
        if ( i )
          {
            pNorm l_to_00(light_local,p00);
            pCoor p00_2 = p00 + height * l_to_00;
            pCoor p01_2 = p01 + height * pNorm(light_local,p01);
            pCoor p10_2 = p10 + height * pNorm(light_local,p10);
            pCoor p11_2 = p11 + height * pNorm(light_local,p11);
            pVect quad_normal = cross(p00,p01,p11);
            const bool facing_light = dot(quad_normal,l_to_00) > 0;
            glFrontFace(facing_light ? GL_CCW : GL_CW );

            glBegin(GL_QUAD_STRIP);
            glVertex3fv(p00);
            glVertex3fv(p00_2);
            glVertex3fv(p01);
            glVertex3fv(p01_2);
            glVertex3fv(p11);
            glVertex3fv(p11_2);
            glVertex3fv(p10);
            glVertex3fv(p10_2);
            glVertex3fv(p00);
            glVertex3fv(p00_2);
            glEnd();
          }
        p00 = p10;
        p01 = p11;
      }

    glPopMatrix();
    glFrontFace(GL_CCW);
  }

  void render_shadow_volume(pCoor base, float radius, pVect to_apex)
  {
    pNorm l_to_base(light_pos,base);
    pNorm u(l_to_base,to_apex);

    const float l_to_base_len = l_to_base.magnitude;
    if ( l_to_base_len <= radius ) return;

    const float r_limb =
      sqrtf( 1.0f - radius * radius / ( l_to_base_len * l_to_base_len ) )
      * radius;

    pCoor cor_nn = base - u * r_limb;
    pCoor cor_pn = base + u * r_limb;
    pCoor cor_np = cor_nn + to_apex;
    pCoor cor_pp = cor_pn + to_apex;

    pVect l_to_nn(light_pos,cor_nn);
    pVect l_to_np(light_pos,cor_np);
    pVect l_to_pn(light_pos,cor_pn);
    pVect l_to_pp(light_pos,cor_pp);

    glBegin(GL_QUAD_STRIP);

    glVertex3fv(cor_nn); glVertex3fv(cor_nn + 1000 * l_to_nn );
    glVertex3fv(cor_np); glVertex3fv(cor_np + 1000 * l_to_np );
    glVertex3fv(cor_pp); glVertex3fv(cor_pp + 1000 * l_to_pp );
    glVertex3fv(cor_pn); glVertex3fv(cor_pn + 1000 * l_to_pn );
    glVertex3fv(cor_nn); glVertex3fv(cor_nn + 1000 * l_to_nn );

    glEnd();
  }

  void render(pCoor base, float radius, pVect to_apex)
  {
    const float to_height = to_apex.mag();
    if ( !inited ) init();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pVect from_apex(0,0,1);
    pNorm rn(from_apex,to_apex);
    const float rot_angle = pangle(from_apex,to_apex);
    pMatrix_Translate trans_transl(base);
    pMatrix_Rotation trans_rot(rn,rot_angle);
    pMatrix_Scale trans_scale(radius); trans_scale.rc(2,2) = to_height;
    pMatrix xform = trans_transl * trans_rot * trans_scale;

    glMultTransposeMatrixf(xform.a);

    if ( !dont_set_color ) glColor3fv(color);

    points_bo.bind();
    glVertexPointer(3,GL_FLOAT,0,0);
    glEnableClientState(GL_VERTEX_ARRAY);
    normals_bo.bind();
    glNormalPointer(GL_FLOAT,0,0);
    glEnableClientState(GL_NORMAL_ARRAY);

    glDrawArrays(GL_QUAD_STRIP,0,points_bo.elements);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);

    glPopMatrix();
  }

  pBuffer_Object<pVect> points_bo;
  pBuffer_Object<pVect> normals_bo;
  bool inited;
  void set_color(const pColor &c) { color = c;  dont_set_color = false; }

  bool dont_set_color;
  pColor color;
  pCoor light_pos;
  double apex_radius;
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
