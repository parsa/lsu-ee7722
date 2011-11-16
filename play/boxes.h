/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for boxes.

// $Id:$

class pLine {
public:
  pLine(){};
  pLine(pCoor s, pVect d, float l):start(s),dir(d),len(l){};
  pLine(pCoor s, pCoor e):start(s)
  {
    pNorm dirn(s,e);
    dir = dirn;
    len = dirn.magnitude;
  }
  pCoor start;
  pVect dir;
  float len;
  pCoor get_end(){ return start + len * dir; }
};

class Box : public Phys {
public:
  Box(bool &cuda_stale, bool &rebuild, pCoor pt_000, pVect to_111p):
    Phys(PT_Box),cuda_stale(cuda_stale),rebuild(rebuild)
  {
    velocity = pVect(0,0,0);
    omega = pVect(0,0,0);
    orientation = pQuat(pVect(0,1,0),0);
    density = 0.01;
    set(pt_000,to_111p);
  }
  Box(Box *box_global, Box *box_ref):
    Phys(PT_Box),cuda_stale(box_global->cuda_stale),
    rebuild(box_global->rebuild)
  { set_local_partial(box_global,box_ref); }

  ~Box(){ rebuild = true; }

  void set(pCoor pt_000, pVect to_111p);

  float max_z_get(double delta_t);
  float min_z_get(double delta_t);

  int8_t get_edge_vtx_idx(int edge);
  pLine get_edge(int edge);
  pLine get_edgel(int edge);
  pCoor get_face_vtx(int face, int vtx);
  pCoor get_vtx(int vtx);
  pVect get_axis_norm(int axis){ return pVect(rot_inv.row_get(axis)); }
  pVect get_face_norm(int face){
    pVect norm_raw = get_axis_norm(face>>1);
    return face & 1 ? norm_raw : -norm_raw;
  }
  float get_axis_len(int axis) { return 2 * to_111.elt(axis); }
  pVect get_vel(pCoor point);
  pVect get_vel_prev(pCoor point);
  float get_moment_of_inertia_inv(pNorm axis);
  float get_moment_of_inertia_inv(pCoor pos, pNorm dir);

  bool contained(pCoor pt, float margin = 0);

  void geometry_update();
  void apply_force_dt(pCoor tact, pVect force);
  void apply_force_fric_dt(pCoor tact, pNorm dir, float force_magnitude);

  // Initialize this box based on global_box to match local space of ref_box.
  void set_local_partial(Box *global_box, Box *ref_box);

  bool& cuda_stale;
  bool& rebuild;

  // One half length, height, and width. Defines size.
  pVect to_111;
  // Note: Phys::position and Phys::orientation provide location.

  // The variables below are computed. See geometry_update.
  pCoor vertices[8];            // Vertices, computed.
  pVect normals[6];             // Normal of each face.
  float radius;                 // Radius of bounding sphere.
  pMatrix rot;                  // Orientation of box.
  pMatrix rot_inv;              // Normal of each axis (inv of orientation).

  pVect mi_vec;                 // Moment of inertia along each axis.
};


void
Box::set(pCoor pt_000, pVect to_111p)
{
  const float min_d = min(to_111p);
  ASSERTS( min_d > 0 );
  to_111 = 0.5 * to_111p;
  position = pt_000 + to_111;
  radius = to_111.mag();

  mass = read_only ? 1e10 : density * to_111p.x * to_111p.y * to_111p.z;
  mass_inv = read_only ? 0 : 1.0 / mass;

  pVect dsq = to_111p * to_111p;
  const float dsqs = sum(dsq);
  mi_vec.x = mass / 12 * ( dsqs - dsq.x );
  mi_vec.y = mass / 12 * ( dsqs - dsq.y );
  mi_vec.z = mass / 12 * ( dsqs - dsq.z );

  geometry_update();
}

pCoor
Box::get_face_vtx(int face, int vtxp)
{
  const int back = face & 1;
  const int axis = face >> 1;
  const int aval = back << axis;
  const int mask = 0x3 << axis;
  const bool flip = back ^ ( axis == 1 );
  const int vtx = vtxp ^ flip;
  return vertices[aval + ( vtx & mask ) + vtx];
}

pLine
Box::get_edge(int edge)
{
  const int axis = edge >> 2;
  const int8_t box_vtx = get_edge_vtx_idx(edge);
  return
    pLine(vertices[box_vtx], get_axis_norm(axis), get_axis_len(axis));
}

int8_t
Box::get_edge_vtx_idx(int edge)
{
  // Index: xyz (z is LSB).
  static const int8_t bi[12] =
    {
      0, 1, 2, 3,
      0, 1, 4, 5,
      0, 2, 4, 6
    };
#if 0
  const int axis = edge >> 2;
  const int mask = 0xc >> axis;
  const int face_vtx = edge & 3;
  const int box_vtx_check = ( face_vtx & mask ) + face_vtx;
  return box_vtx_check;
#else
  return bi[edge];
#endif

}

pLine
Box::get_edgel(int edge)
{
  const int axis = edge >> 2;
  const int8_t box_vtx = get_edge_vtx_idx(edge);
  return pLine
    ( to_111.sign_mask(box_vtx), get_axis_norm(axis), get_axis_len(axis) );
}

pCoor
Box::get_vtx(int vtx)
{
  const int face = vtx >> 2;
  const int fv = vtx & 0x3;
  return get_face_vtx(face,fv);
}

pVect
Box::get_vel(pCoor point)
{
  pVect cent_to_pt(position,point);
  pVect rot_vel = cross(omega,cent_to_pt);
  return rot_vel + velocity;
}

pVect
Box::get_vel_prev(pCoor point)
{
  pVect cent_to_pt(position,point);
  pVect rot_vel = cross(prev_omega,cent_to_pt);
  return rot_vel + prev_velocity;
}

float
Box::min_z_get(double lifetime_delta_t)
{
  const float m = fabs(velocity.x) + fabs(velocity.y) + fabs(velocity.z);
  float zmin = 1e10;
  for ( int v=0; v<8; v++ )
    {
      pCoor c = vertices[v];
      const float val = c.z + c.x;
      set_min(zmin,val);
    }
  return zmin - m * lifetime_delta_t;
}

float
Box::max_z_get(double lifetime_delta_t)
{
  const float m = fabs(velocity.x) + fabs(velocity.y) + fabs(velocity.z);
  float zmax = -1e10;
  for ( int v=0; v<8; v++ )
    {
      pCoor c = vertices[v];
      const float val = c.z + c.x;
      set_max(zmax,val);
    }
  return zmax + m * lifetime_delta_t;
}

bool
Box::contained(pCoor pos, float margin)
{
  pVect ctr_to_p(position,pos);
  pVect pos_local = fabs(rot_inv * ctr_to_p);
  pVect dists = to_111 - pos_local;
  const float min_dist = min(dists);
  return min_dist >= -margin;
}

void
Box::geometry_update()
{
  rot = pMatrix_Rotation(orientation);
  rot_inv.set_transpose3x3(rot);

  for ( int v=0; v<8; v++ )
    vertices[v] = position + rot * to_111.sign_mask(v);

  for ( int d=0; d<3; d++ )
    {
      // Optimize me.
      const int fidx = d << 1;
      const pVect vmask = pVect(1,1,1).mask(1<<d);
      const bool flip = dot(vmask,to_111.mask(1<<d)) < 0;
      pVect norm = rot * vmask;
      normals[fidx] = flip ? norm : -norm;
      normals[fidx+1] = flip ? -norm : norm;
    }
}

void
Box::set_local_partial(Box *gbox, Box *rbox)
{
  pVect rtog(rbox->position,gbox->position);
  position = rbox->rot_inv * rtog;
  to_111 = gbox->to_111;
  pMMultiply3x3(rot_inv,gbox->rot_inv,rbox->rot);
}

void
Box::apply_force_dt(pCoor tact, pVect force)
{
  if ( read_only ) return;
  velocity += mass_inv * force;
  pVect cent_to_tact(position,tact);
  pVect torque = cross(cent_to_tact,force);
  pNorm torqueN(torque);
  const float mi_inv = get_moment_of_inertia_inv(torqueN);
#if 0
  pVect check = rot * torque_local;
  pNorm check2 = check - torque;
  ASSERTS( check2.mag_sq < 0.0001 );
#endif
  omega += torque * mi_inv;
}


float
Box::get_moment_of_inertia_inv(pNorm axis)
{
  if ( read_only ) return 0;
  if ( axis.mag_sq < 1e-11 ) return 0;
  pVect tl = rot_inv * axis;
  pVect tls = tl * tl;
  const float mi = dot(tls,mi_vec);
  return 1.0 / mi;
}

float
Box::get_moment_of_inertia_inv(pCoor tact, pNorm dir)
{
  if ( read_only ) return 0;
  pVect cent_to_tact(position,tact);
  pNorm torque_axis = cross(cent_to_tact,dir);
  return get_moment_of_inertia_inv(torque_axis);
}

void
Box::apply_force_fric_dt(pCoor tact, pNorm force_dir, float force_mag_dt)
{
  if ( read_only ) return;
  apply_force_dt(tact,force_mag_dt*force_dir);
}

class Box_Manager {
public:
  Box_Manager(){ phys_list = NULL; cuda_stale = true;  rebuild = false; };
  void init(Phys_List *pl){ phys_list = pl; }
  void rebuild_maybe();
  void render(bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Box* new_box(pCoor pt_000, pVect to_111, pColor color);
  Box* iterate();
  int occ() { return boxes.occ(); }

private:
  World* w;
  PStack<Box*> boxes;
  Phys_List *phys_list;
  bool cuda_stale;
  bool rebuild; // Rebuild boxes list.
  Cone cone;
};


Box*
Box_Manager::new_box(pCoor pt_000, pVect to_111, pColor color)
{
  Box* const box = new Box(cuda_stale,rebuild,pt_000,to_111);
  boxes += box;
  box->color = color;
  box->idx = phys_list->occ();  phys_list->push(box);
  return box;
}

Box*
Box_Manager::iterate()
{
  Box** const tp = boxes.iterate();
  return tp ? *tp : NULL;
}

void
Box_Manager::rebuild_maybe()
{
  if ( !rebuild ) return;
  rebuild = false;
  boxes.reset();
  for ( Phys *p; phys_list->iterate(p); )
    if ( Box* const box = BOX(p) ) boxes += box;
}

void
Box_Manager::render(bool simple)
{
  rebuild_maybe();
  for ( PStackIterator<Box*> box(boxes); box; box++ )
    {
      if ( !simple )
        glColor3fv(box->color);

      for ( int f=0; f<6; f++ )
        {
          pCoor ll = box->get_face_vtx(f,0);
          pCoor lr = box->get_face_vtx(f,1);
          pCoor ul = box->get_face_vtx(f,2);
          pCoor ur = box->get_face_vtx(f,3);
          glBegin(GL_TRIANGLES);
          glNormal3fv(box->normals[f]);

          glVertex3fv(ul);
          glVertex3fv(ll);
          glVertex3fv(lr);
          glVertex3fv(lr);
          glVertex3fv(ur);
          glVertex3fv(ul);
          glEnd();
#if 0
          // Show normal vectors.
          pVect diag(ll,ur);
          pCoor ctr = ll + 0.5 * diag;
          glColor3fv(lsu_spirit_gold);
          cone.render(ctr,1,10*box->normals[f]);
#endif
        }
    }
}

void
Box_Manager::render_simple(){ render(true); }

void
Box_Manager::render_shadow_volume(pCoor light_pos)
{
  rebuild_maybe();
  const float height = 1000;
  for ( PStackIterator<Box*> box(boxes); box; box++ )
    {
      for ( int f=0; f<6; f++ )
        {
          pCoor ul = box->get_face_vtx(f,2);
          pVect l_to_ul_v(light_pos,ul);
          const bool facing_light =
            dot(box->normals[f],l_to_ul_v) >= 0;
          if ( facing_light ) continue;

          pCoor ll = box->get_face_vtx(f,0);
          pCoor lr = box->get_face_vtx(f,1);
          pCoor ur = box->get_face_vtx(f,3);

          pNorm l_to_ul(l_to_ul_v);

          pCoor ul_2 = light_pos + height * l_to_ul;
          pCoor ll_2 = light_pos + height * pNorm(light_pos,ll);
          pCoor lr_2 = light_pos + height * pNorm(light_pos,lr);
          pCoor ur_2 = light_pos + height * pNorm(light_pos,ur);

          glFrontFace(GL_CW);

          glBegin(GL_QUAD_STRIP);
          glVertex3fv(ll);
          glVertex3fv(ll_2);
          glVertex3fv(lr);
          glVertex3fv(lr_2);
          glVertex3fv(ur);
          glVertex3fv(ur_2);
          glVertex3fv(ul);
          glVertex3fv(ul_2);
          glVertex3fv(ll);
          glVertex3fv(ll_2);
          glEnd();
        }
    }
  glFrontFace(GL_CCW);
}

typedef enum { ST_Unset, ST_Intersect_Line, ST_Contained_Vertex, ST_Centroid
} Sect_Type;

// Class indicating information about a box-related intersection.
// Usually used to describe a line along intersecting faces.
//
class SectTT {
public:
  SectTT(){
    exists = false;
    t_start = -1e10; t_end = 1e10;
    type = ST_Unset;
    sect_case = 0;
  };
  bool exists; // If false, no intersection.
  Sect_Type type;
  pCoor start;
  pCoor end;
  pVect dir;
  float t_start, t_end;
  int sect_case;
};

class Isect_Edge {
public:
  Isect_Edge() {
    outside = false; lo_t = 0;  hi_t = 1e10;
    lo_face = hi_face = -1;
  }
  float lo_t, hi_t;
  char lo_face, hi_face;
  bool outside;
};

class Isect_Line {
public:
  Isect_Line(){ occ = false; }
  pVect pt;
  bool occ;
};

class Isect_Boxes;

class Isect_Face {
public:
  Isect_Face() { ref_pt_set = false; }
  void line_add
  (Isect_Boxes* const b, pCoor pt_lo, pCoor pt_hi, bool area, char color);
  pCoor face_ref_pt;
  bool ref_pt_set;
  pVect vol_to_face;
  float area_sum;
};

class Isect_Boxes {
public:
  Isect_Boxes(PStack<SectTT>* sl):sl(sl){
    ref_pt_set = false;
    volume_sum = 0;
    vec_sum = pVect(0,0,0);
    face_vector1 = face_vector2 = 0;
  };
  void line_add(int f1, int f2, pCoor p1, pCoor p2, char color);
  void intersect_point_add(int f1, int f2, bool first, pCoor pt);
  PStack<SectTT>* const sl;
  Isect_Face faces[12];
  Isect_Edge edges[24];
  Isect_Line l[6][6];
  int face_vector1, face_vector2;
  pCoor vol_ref_pt;
  bool ref_pt_set;
  pVect vec_sum;
  float volume_sum;
};

void
Isect_Boxes::line_add(int f1, int f2, pCoor p1, pCoor p2, char color)
{
  if ( !ref_pt_set )
    {
      ref_pt_set = true;
      vol_ref_pt = p1;
    }
  faces[f1].line_add(this,p1,p2,false,color);
  faces[f2].line_add(this,p1,p2,true,color);
}

void
Isect_Boxes::intersect_point_add(int f1p, int f2p, bool first, pCoor pt)
{
  const int f1 = first ? f1p : f2p;
  const int f2 = first ? f2p : f1p;
  Isect_Line* const il = &l[f1][f2];
  if ( il->occ ) line_add(f1,f2+6,il->pt,pt,0);
  il->pt = pt;
  il->occ = true;
}

void
Isect_Face::line_add
(Isect_Boxes* const b, pCoor p1, pCoor p2, bool area, char color)
{
#ifdef TUNE
  // Code much slower with this compiled in, even if branch is not taken.
  if ( b->sl )
    {
      SectTT sect;
      sect.exists = true;
      sect.start = p1;
      sect.end = p2;
      sect.dir = pVect(p1,p2);
      sect.type = ST_Intersect_Line;
      sect.sect_case = color;
      b->sl->push(sect);
    }
#endif
  if ( !ref_pt_set )
    {
      ref_pt_set = true;
      face_ref_pt = p1;
      vol_to_face = pVect(b->vol_ref_pt,face_ref_pt);
      area_sum = 0;
      return;
    }
  pVect ftop1(face_ref_pt,p1);
  pVect ftop2(face_ref_pt,p2);
  pVect cp = cross(ftop1,ftop2);
  const float volx6 = fabs(dot(vol_to_face,cp));
  pVect centroidx3 = ( p1 + p2 + face_ref_pt );
  b->volume_sum += volx6;
  b->vec_sum += volx6 * centroidx3;
  if ( !area ) return;
  const float areax2 = dot(cp,cp);
  area_sum += areax2;
}

int box_box_intersect_1
(Box *box1, Box *box2, Isect_Boxes *isb, bool first);
int box_box_intersect_1b(Box *box1, Box *box2, Isect_Boxes *isb);
void box_box_intersect_2
(Box *box1, Box *box2, bool first,
 PStack<SectTT>* sl, int color, Isect_Boxes *isb);

int tt_debug = 0;

SectTT
box_box_intersect(Box *box1, Box *box2, PStack<SectTT>* sl)
{
  tt_debug++;
  SectTT sect;
  Isect_Boxes isb(sl);
  const int box1i = box_box_intersect_1(box1,box2,&isb,true);
  if ( box1i < 0 ) return sect;
  if ( box1i ) box_box_intersect_2(box1,box2,true,sl,1,&isb);
  const int box2_faces =  __builtin_popcount(isb.face_vector2);
  const bool box2i =
    box2_faces != 1000 && box_box_intersect_1(box2,box1,&isb,false) > 0;
  if ( !box1i && !box2i ) return sect;
  if ( box2i ) box_box_intersect_2(box2,box1,false,sl,2,&isb);

  float vol_area_sum = 0;
  pVect dir(0,0,0);

  for ( int f=6; f<12; f++ )
    {
      if ( !isb.faces[f].ref_pt_set ) continue;
      pVect n2 = box2->get_face_norm(f-6);
      const float wt = isb.faces[f].area_sum;
      dir += wt * n2;
      vol_area_sum += wt;
    }

  isb.vec_sum += isb.volume_sum * isb.vol_ref_pt;

  if ( isb.volume_sum < 0.001 ) return sect;
  if ( vol_area_sum < 0.001 ) return sect;
  pCoor centroid = pVect(0,0,0) + (0.25/isb.volume_sum) * isb.vec_sum;
  pNorm dirN(dir);
  pVect dir_scaled = -(isb.volume_sum/vol_area_sum) * dir;
  sect.start = centroid;
  sect.dir = dir_scaled;
  sect.end = sect.start + sect.dir;
  sect.exists = true;
  sect.type = ST_Centroid;

#ifdef TUNE
  const float margin = 0.1;
  ASSERTS( box1->contained(centroid,margin) );
  ASSERTS( box2->contained(centroid,margin) );
#endif
  return sect;
}

void
box_box_intersect_2(Box *box1, Box *box2, bool first,
                    PStack<SectTT>* sl, int color, Isect_Boxes *isb)
{
  const int face_base = first ? 6 : 0;
  Isect_Edge* const edges = &isb->edges[ first ? 12 : 0 ];
  int& face_vector = first ? isb->face_vector2 : isb->face_vector1;
  for ( int edge2 = 0; edge2 < 12; edge2++ )
    {
      Isect_Edge* const ie2 = &edges[edge2];
      if ( ie2->outside ) continue;
      pLine line2 = box2->get_edge(edge2);

      pCoor pt_lo = line2.start + ie2->lo_t * line2.dir;
      pCoor pt_hi = line2.start + ie2->hi_t * line2.dir;

      const int axis2 = edge2 >> 2;
      const int face_x_axis = axis2 ? 0 : 2;
      const int face_y_axis = axis2 == 2 ? 2 : 4;
      const int face_x = face_x_axis + ( ( edge2 & 2 ) >> 1 );
      const int face_y = face_y_axis + ( edge2 & 1 );

      isb->line_add(face_base+face_x,face_base+face_y,pt_lo,pt_hi,color);

      if ( ie2->lo_face >= 0 )
        {
          face_vector |= 1 << ie2->lo_face;
          isb->intersect_point_add(ie2->lo_face,face_x,first,pt_lo);
          isb->intersect_point_add(ie2->lo_face,face_y,first,pt_lo);
        }

      if ( ie2->hi_face >= 0 )
        {
          face_vector |= 1 << ie2->hi_face;
          isb->intersect_point_add(ie2->hi_face,face_x,first,pt_hi);
          isb->intersect_point_add(ie2->hi_face,face_y,first,pt_hi);
        }

    }
}

int
box_box_intersect_1(Box *box1, Box *box2, Isect_Boxes *isb, bool first)
{
  int live_edge_count = 12;
  Isect_Edge* const edges = &isb->edges[ first ? 12 : 0 ];

  pVect to2(box2->position,box1->position);

  const float x1to2 = dot(to2,box1->get_axis_norm(0));
  const float y1to2 = dot(to2,box1->get_axis_norm(1));
  const float z1to2 = dot(to2,box1->get_axis_norm(2));
  int axes[3];
  bool flip[3];
  const bool xgy = fabs(x1to2) > fabs(y1to2);
  const bool ygx = !xgy;
  if ( fabs(z1to2) > fabs( xgy ? x1to2 : y1to2 ) )
    { axes[0] = 2;    axes[1] = ygx;  axes[2] = xgy; }
  else if ( fabs(z1to2) < fabs( xgy ? y1to2 : x1to2 ) )
    { axes[0] = ygx;  axes[1] = xgy;  axes[2] = 2; }
  else
    { axes[0] = ygx;  axes[1] = 2;    axes[2] = xgy; }
  flip[0] = x1to2 < 0;  flip[1] = y1to2 < 0;  flip[2] = z1to2 < 0;

#define OUTSIDE { \
  ie->outside = true; live_edge_count--; \
  if ( !live_edge_count ) return !front1r && !axis1r ? -1 : 0; }

  for ( int front1r = 0; front1r < 2; front1r++ )
    {
      for ( int axis1r=0; axis1r<3; axis1r++ )
        {
          const int axis1 = axes[axis1r];
          pVect a1 = box1->get_axis_norm(axis1);
          const bool front1 = flip[axis1] ^ front1r;
          const int face1 = ( axis1 << 1 ) + front1;
          pVect n1 = front1 ? a1 : -a1;
          const int idx1 = front1 << (2-axis1);
          pCoor p1 = box1->vertices[idx1];

          for ( int edge2 = 0; edge2 < 12; edge2++ )
            {
              Isect_Edge* const ie = &edges[edge2];
              if ( ie->outside ) continue;
              pLine line2 = box2->get_edge(edge2);
              pCoor p2 = line2.start;
              pVect u2 = line2.dir;
              pVect p1p2(p1,p2);
              const float u2dn1 = dot(u2,n1);
              const float p1p2dist = dot(p1p2,n1);
              const bool p2_outside = p1p2dist > 0;
              const float l = line2.len;
              if ( fabs(u2dn1) < 0.0001 ) {
                if ( p2_outside ) OUTSIDE;
                continue; }
              const bool e_inward = u2dn1 < 0;
              const float t = -p1p2dist / u2dn1;
              if ( p2_outside )
                {
                  if ( !e_inward ) { OUTSIDE;  continue; }
                  if ( t >= l ) { OUTSIDE;  continue; }
                  if ( t > ie->lo_t ) {
                    if ( t > ie->hi_t ) { OUTSIDE;  continue; }
                    ie->lo_face = face1;  ie->lo_t = t; }
                  continue;
                }
              if ( e_inward ) continue;
              if ( t > l ) { set_min(ie->hi_t,l);  continue; }
              if ( t < ie->hi_t ) {
                if ( t < ie->lo_t ) { OUTSIDE;  continue; }
                ie->hi_face = face1;  ie->hi_t = t; }
            }
        }
    }
# undef OUTSIDE
  return 1;
}


int
box_box_intersect_1b(Box *box1g, Box *box2, Isect_Boxes *is2)
{
  // Compute edge/face intersections by rotating box1 into box2's local
  // coordinate space. Not as fast, so not used.
  int live_edge_count = 12;
# define OUTSIDE { \
  ie->outside = true; live_edge_count--; if ( !live_edge_count ) return 0; }

  Box box1l(box1g,box2);

  for ( int face1=0; face1<6; face1++ )
    {
      const int axis1 = face1 >> 1;
      pVect n1 = box1l.get_face_norm(face1);
      pCoor p1 = box1l.position + box1l.to_111.elt(axis1) * n1;

      for ( int edge2 = 0; edge2 < 12; edge2++ )
        {
          Isect_Edge* const ie = &is2->edges[edge2];
          if ( ie->outside ) continue;
          const int axis2 = edge2 >> 2;
          const int8_t vtx2_idx = box2->get_edge_vtx_idx(edge2);

          pCoor p2 = box2->to_111.sign_mask(vtx2_idx);
          pVect p1p2(p1,p2);
          const float u2dn1 = n1.elt(axis2);
          const float p1p2dist = dot(p1p2,n1);
          const bool p2_outside = p1p2dist > 0;

          if ( fabs(u2dn1) < 0.0001 ) {
            if ( p2_outside ) OUTSIDE;
            continue; }

          const bool e_inward = u2dn1 < 0;
          const float l = 2 * box2->to_111.elt(axis2);
          const float t = -p1p2dist / u2dn1;
          if ( p2_outside )
            {
              if ( !e_inward ) { OUTSIDE;  continue; }
              if ( t >= l ) { OUTSIDE;  continue; }
              if ( t > ie->lo_t ) {
                if ( t > ie->hi_t ) { OUTSIDE;  continue; }
                ie->lo_face = face1;  ie->lo_t = t; }
              continue;
            }
          if ( e_inward ) continue;
          if ( t > l ) { set_min(ie->hi_t,l);  continue; }
          if ( t < ie->hi_t ) {
            if ( t < ie->lo_t ) { OUTSIDE;  continue; }
            ie->hi_face = face1;  ie->hi_t = t; }
        }
    }
# undef OUTSIDE
  return 1;
}

SectTT
box_box_interpenetrate(Box *box1, Box *box2, PStack<SectTT>* sl)
{
  SectTT troid;
  pNorm b1tob2(box1->position,box2->position);
  if ( b1tob2.magnitude >= box1->radius + box2->radius ) return troid;
  troid = box_box_intersect(box1,box2,sl);
  return troid;
}

SectTT
box_sphere_interpenetrate(Box *box, pCoor sphere_pos, float radius)
{
  SectTT sect;
  pVect btos(box->position,sphere_pos);
  const float dist_sq = ( box->radius + radius ) * ( box->radius + radius );
  if ( btos.mag_sq() >= dist_sq ) return sect;
  pVect btosl = box->rot_inv * btos;
  pVect btosla = fabs(btosl);
  pVect dist = btosla - box->to_111;
  const float max_dist = max(dist);
  if ( max_dist >= radius ) return sect;
  pVect tact(dist.x > 0 ? copysignf(box->to_111.x,btosl.x) : btosl.x,
             dist.y > 0 ? copysignf(box->to_111.y,btosl.y) : btosl.y,
             dist.z > 0 ? copysignf(box->to_111.z,btosl.z) : btosl.z);
  sect.start = box->position + box->rot * tact;
  pNorm dir(sect.start,sphere_pos);
  if ( dir.mag_sq > radius*radius ) return sect;
  const float pen = radius - dir.magnitude;
  sect.dir = pen * dir;
  sect.type = ST_Centroid;
  sect.exists = true;
  return sect;
}