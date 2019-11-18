/// LSU EE X70X-X (Fall 2019), GPU X -*- c++ -*-
//
 /// Quick-and-Dirty Routines for Drawing some OpenGL Shapes


#ifndef SHAPES_H
#define SHAPES_H

#include <cmath>

enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };

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
    radius = radiusp; center = position; axis = axisp;  angle = anglep;
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
  glVertexPointer(3,GL_FLOAT,sizeof(pVect),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormalPointer(GL_FLOAT,sizeof(pVect),0);
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
  glVertexPointer(3,GL_FLOAT,sizeof(pVect),0);
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
  vector<pVect> coords;
  pVect ax(1,0,0);
  pVect ay(0,1,0);
  pVect bx(height,0,0);
  pVect by(0,height,0);
  const pVect acenter(0,0,1);
  const pVect bcenter(0,0,height);

  for ( int i=0; i<=pieces; i++ )
    {
      const double theta = i * delta_theta;
      const float co = cos(theta);
      const float si = sin(theta);
      coords.emplace_back( acenter + co * ax + si * ay );
      coords.emplace_back( bcenter + co * bx + si * by );
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

  pNorm ax = l_to_c_dir.x == 0 ? pVect(0,-l_to_c_dir.z,l_to_c_dir.y)
    : pVect(-l_to_c_dir.y,l_to_c_dir.x,0);
  pVect vx = r1 * ax;
  pVect vy = cross(vx,l_to_c_dir);
  pMatrix transform; transform.set_identity();
  transform.set_col(0,vx);
  transform.set_col(1,vy);
  transform.set_col(2,center1_distance * l_to_c_dir);
  transform.set_col(3,light_pos);

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glMultTransposeMatrixf(transform);

  shadow_volume_points_bo.bind();
  glVertexPointer(3,GL_FLOAT,sizeof(pVect),0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_QUAD_STRIP,0,shadow_volume_points_bo.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glPopMatrix();
}


class Cone {
public:
  Cone()
  {
    apex_radius = 0.1;
    dont_set_color = true;
    render_sides = 10;
    ends_hidden = false;
  };

  void render_shadow_volume
  (pCoor base, float radius, pVect to_apex)
  {
    const float sv_len = 1000;
    const int sides = ends_hidden ? 1 : render_sides;

    pNorm az(-to_apex);
    pNorm ax = az.x > az.y ? pVect(-az.z, 0, az.x) : pVect(0, -az.z, az.y);
    pVect ay = cross(az,ax);

    pCoor ctr[2] = { base, base + to_apex };
    pVect base_to_l(ctr[0],light_pos), apex_to_l(ctr[1],light_pos);

    pNorm lx = dot(base_to_l,ax) * ax + dot(base_to_l,ay) * ay;
    pNorm ly = cross(az,lx);

    float r[2] = { radius, float(apex_radius)*radius };
    bool lit[2] = { dot(base_to_l,to_apex) < 0, dot(apex_to_l,to_apex) > 0 };
    pVect vlxa[2], vlya[2];
    int sidesa[2][2];
    float eta[2], delta_thetaa[2][2];

    for ( int h=0; h<2; h++ )
      {
        vlxa[h] = r[h] * lx;  vlya[h] = r[h] * ly;
        eta[h] = r[h] >= lx.magnitude ? 0 : acosf( r[h]/lx.magnitude );
        sidesa[h][0] = eta[h] ? max(1, int(sides * eta[h] / M_PI + 0.5) ) : 0;
        sidesa[h][1] = max( 1, sides - sidesa[h][0] );
        delta_thetaa[h][0] = -2 * eta[h] / sidesa[h][0];
        delta_thetaa[h][1] = 2 * ( M_PI - eta[h] ) / sidesa[h][1];
      }

    vector<pCoor> coors; coors.reserve( 4 * ( sides + 2 ) );
    vector<bool> surfaces = { true };
    if ( !ends_hidden ) surfaces.push_back( false );

    for ( bool outer: surfaces )
      {
        const int idx_st = coors.size();
        for ( int h: { 0, 1 } )
          {
            const bool far = lit[h] == outer;
            const float delta_theta = ( h ? -1 : 1 ) * delta_thetaa[h][far];
            if ( delta_theta == 0 ) continue;
            const float eta_0 = h ? -eta[1] : eta[0];
            for ( int i=0; i<=sidesa[h][far]; i++ )
              {
                const float theta = eta_0 + i * delta_theta;
                pCoor p = ctr[h] + vlxa[h]*cosf(theta) + vlya[h]*sinf(theta);
                coors.push_back(p);
                coors.emplace_back( p + sv_len * pNorm(light_pos,p) );
              }
          }
        coors.push_back(coors[idx_st]);
        coors.push_back(coors[idx_st+1]);
      }

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glVertexPointer(4,GL_FLOAT,sizeof(coors[0]),coors.data());
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLE_STRIP,0,coors.size());
    glDisableClientState(GL_VERTEX_ARRAY);
  }

  void render(pCoor base, float radius, pVect to_apex)
  {
    const int sides = render_sides;
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

  int render_sides;
  bool ends_hidden; // If so, don't waste time on shadow volume for ends.
  bool dont_set_color;
  pColor color;
  pCoor light_pos;
  double apex_radius;
};

class Cylinder {
public:
  Cylinder(int sidesp = 10):sides(sidesp)
  { dont_set_color = true; inited = false; };

  void init()
  {
    PStack<pVect> points;
    PStack<pVect> normals;
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
    normals_bo.take(normals,GL_STATIC_DRAW);
    normals_bo.to_gpu();
    inited = true;
  }

  void render_shadow_volume_exact(pCoor base, float radius, pVect to_apex)
  {
    const float sv_len = 1000;

    pNorm az(-to_apex);
    pNorm ax = az.x > az.y ? pVect(-az.z, 0, az.x) : pVect(0, -az.z, az.y);
    pVect ay = cross(az,ax);

    pVect base_to_l(base,light_pos);
    pCoor apex = base + to_apex;
    pVect apex_to_l(apex,light_pos);

    pNorm lx = dot(base_to_l,ax) * ax + dot(base_to_l,ay) * ay;
    pNorm ly = cross(az,lx);
    pVect vlx = radius * lx,  vly = radius * ly;

    const float eta = radius >= lx.magnitude ? 0 : acosf( radius/lx.magnitude );

    const int sides_near = sides * eta / M_PI + 0.5;
    const int sidesa[2] = { sides_near, sides - sides_near };
    const float delta_thetaa[2] =
      { -2 * eta / sidesa[0], 2 * ( 3.141592653f - eta ) / sidesa[1] };
    const bool lit[2] =
      { dot(base_to_l,to_apex) < 0, dot(apex_to_l,to_apex) > 0 };

    pCoor ctr[2] = { base, apex };
    const float etaa[2] = { eta, -eta };

    vector<pCoor> coors; coors.reserve( 4 * ( sides + 2 ) );

    for ( bool outer: { true, false } )
      {
        const int idx_st = coors.size();
        for ( int h: { 0, 1 } )
          {
            const bool far = lit[h] == outer;
            const float delta_theta = ( h ? -1 : 1 ) * delta_thetaa[far];
            if ( delta_theta == 0 ) continue;
            for ( int i=0; i<=sidesa[far]; i++ )
              {
                const float theta = etaa[h] + i * delta_theta;
                pCoor p = ctr[h] + vlx * cosf(theta) + vly * sinf(theta);
                coors.push_back(p);
                coors.emplace_back( p + sv_len * pNorm(light_pos,p) );
              }
          }
        coors.push_back(coors[idx_st]);
        coors.push_back(coors[idx_st+1]);
      }

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glVertexPointer(4,GL_FLOAT,sizeof(coors[0]),coors.data());
    glEnableClientState(GL_VERTEX_ARRAY);
    glDrawArrays(GL_TRIANGLE_STRIP,0,coors.size());
    glDisableClientState(GL_VERTEX_ARRAY);
  }

  void render(Render_Option ro, pCoor base, float radius, pVect to_apex)
    {
      switch ( ro ) {
      case RO_Normally: render(base,radius,to_apex); break;
      case RO_Shadow_Volumes:
        render_shadow_volume_exact(base,radius,to_apex); break;
      default: assert( false );
      }
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
    if ( !inited ) init();

    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();

    pNorm van =
      to_apex.x == 0
      ? pVect(0,-to_apex.z,to_apex.y) : pVect(-to_apex.y, to_apex.x, 0);
    pNorm vbn = cross(to_apex,van);
    pMatrix trans_rot; trans_rot.set_identity();
    trans_rot.set_col(0,radius*van);
    trans_rot.set_col(1,radius*vbn);
    trans_rot.set_col(2,to_apex);
    trans_rot.set_col(3,base);

    glMultTransposeMatrixf(trans_rot.a);

    if ( !dont_set_color ) glColor3fv(color);

    points_bo.bind();
    glVertexPointer(3,GL_FLOAT,0,0);
    glEnableClientState(GL_VERTEX_ARRAY);
    normals_bo.bind();
    glNormalPointer(GL_FLOAT,0,0);
    glEnableClientState(GL_NORMAL_ARRAY);

    glDrawArrays(GL_TRIANGLE_STRIP,0,points_bo.elements);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);

    glPopMatrix();
  }

  pBuffer_Object<pVect> points_bo;
  pBuffer_Object<pVect> normals_bo;
  bool inited;
  int sides;
  void set_color(const pColor &c) { color = c;  dont_set_color = false; }

  bool dont_set_color;
  pColor color;
  pCoor light_pos;
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
