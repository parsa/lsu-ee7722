/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Class for Boxes

// $Id:$

#ifndef PHYS_OBJ_BOX_H
#define PHYS_OBJ_BOX_H

#include "boxes.h"
#include "phys.h"

class pLine;

class Box : public Phys {
public:
  Box(bool &cuda_stale, bool &rebuild, pCoor pt_000, pVect to_111p):
    Phys(PT_Box),cuda_stale(cuda_stale),rebuild(rebuild)
  {
    velocity = pVect(0,0,0);
    omega = pVect(0,0,0);
    orientation = pQuat(pVect(0,1,0),0);
    density = 0.01;
    bzero(texid_faces,sizeof(texid_faces));
    set(pt_000,to_111p);
  }
  Box(Box *box_global, Box *box_ref):
    Phys(PT_Box),cuda_stale(box_global->cuda_stale),
    rebuild(box_global->rebuild)
  { set_local_partial(box_global,box_ref); }

  ~Box(){ rebuild = true; }

  void set(pCoor pt_000, pVect to_111p);
  void set_face_texture(int face, GLuint texid);
  bool set_read_only(bool val = true)
  {
    if ( val == read_only ) return val;
    read_only = val;  constants_update();
    return !val;
  }
  void set_density(float densityp)
  { density = densityp; constants_update(); }

  void constants_update();

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
  pMatrix rot;                  // Orientation of box.
  pMatrix rot_inv;              // Normal of each axis (inv of orientation).

  pVect mi_vec;                 // Moment of inertia along each axis.

  GLuint texid_faces[6];
};


class Box_Manager {
public:
  Box_Manager(World *wp, Phys_List *pl)
  { phys_list = NULL; cuda_stale = true;  rebuild = false; init(wp,pl); };
  Box_Manager(){ phys_list = NULL; cuda_stale = true;  rebuild = false; };
  void init(World *wp, Phys_List *pl){ w = wp; phys_list = pl; }
  void rebuild_maybe();
  void render(bool color_events, bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Box* new_box(pCoor pt_000, pVect to_111, pColor color);
  Box* new_box_ctr(pCoor center, pVect to_111, pColor color);
  Box* iterate();
  int occ() { return boxes.occ(); }
  void phys_insert(Phys *p);

private:
  World* w;
  PStack<Box*> boxes;
  Phys_List *phys_list;
  bool cuda_stale;
  bool rebuild; // Rebuild boxes list.
};

SectTT
box_box_intersect(Box *box1, Box *box2, PStack<SectTT>* sl);

SectTT
box_box_interpenetrate(Box *box1, Box *box2, PStack<SectTT>* sl);

SectTT
box_sphere_interpenetrate(Box *box, pCoor sphere_pos, float radius);


#endif
