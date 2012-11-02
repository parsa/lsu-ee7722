/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Quick and dirty code for ball / rectangle physics.

// $Id:$

#ifndef PHYS_OBJ_TILE_H
#define PHYS_OBJ_TILE_H

#include "boxes.h"
#include "phys.h"

inline pVect vec_pos(pVect v)
{ return pVect(max(v.x,0.0f),max(v.y,0.0f),max(v.z,0.0f)); }
inline pVect vec_neg(pVect v)
{ return pVect(min(v.x,0.0f),min(v.y,0.0f),min(v.z,0.0f)); }

struct Bounding_Box {
  Bounding_Box(){ initialized = false; }
  Bounding_Box operator = (Bounding_Box b)
  {
    initialized = true;
    ll = b.ll;  ur = b.ur;
    return *this;
  }
  Bounding_Box operator += (Bounding_Box b)
  {
    if ( !initialized ) return operator = (b);
    set_min(ll.x,b.ll.x); set_min(ll.y,b.ll.y); set_min(ll.z,b.ll.z);
    set_max(ur.x,b.ur.x); set_max(ur.y,b.ur.y); set_max(ur.z,b.ur.z);
    return *this;
  }
  bool initialized;
  pCoor ll, ur;
};

class Tile : public Phys {
public:
  Tile(bool &cuda_stale, pCoor ll, pVect up, pVect rt)
    :Phys(PT_Tile),cuda_stale(cuda_stale),marker(NULL)
  {
    read_only = true;
    set(ll,up,rt);
  }
  ~Tile(){ }

  void set(pCoor ll, pVect up, pVect rt)
  {
    pt_ll = ll;
    vec_up = up;
    vec_rt = rt;
    normal.set(cross(rt,up));
    norm_up.set(up);
    norm_rt.set(vec_rt);
    height = norm_up.magnitude;
    set_common();
  }

  void set_common()
  {
    width = norm_rt.magnitude;
    pt_ul = pt_ll + vec_up;
    pt_lr = pt_ll + vec_rt;
    cuda_stale = true;
    bb.ll = pt_ll + vec_neg(vec_up) + vec_neg(vec_rt);
    bb.ur = pt_ll + vec_pos(vec_up) + vec_pos(vec_rt);
  }

  float max_z_get(double delta_t){ return bb.ur.z + bb.ur.x; }
  float min_z_get(double delta_t){ return bb.ll.z + bb.ll.x; }

  Bounding_Box bounding_box_get(){return bb;}

  bool& cuda_stale;
  void *marker;
  pCoor pt_ll; // A corner called lower-left but it doesn't have to be.
  pCoor pt_ul, pt_lr;
  pVect vec_up;
  pVect vec_rt;
  pNorm normal, norm_rt, norm_up;
  pColor color;
  float width, height;
  Bounding_Box bb;
  Ball *ball_tested;
};

class Tile_Manager {
public:
  Tile_Manager(Phys_List *pl):phys_list(pl){}
  void render(bool simple = false);
  void render_simple();
  void render_shadow_volume(pCoor light_pos);
  Tile* new_tile(pCoor ll, pVect up, pVect rt, pColor color);
  Tile* new_tile(pCoor ll, pVect up, pVect rt);
  void rebuild();
  Tile* iterate();
  int occ() { return tiles.occ(); }

private:
  Phys_List* const phys_list;
  PStack<Tile*> tiles;
  bool cuda_stale;
};

bool
tile_sphere_intersect
(Tile *tile, pCoor position, float radius,
 pCoor& tact_pos, pNorm& tact_dir, bool dont_compute_tact = false);

bool tile_sphere_intersect (Tile *tile, pCoor position, float radius);

#endif
