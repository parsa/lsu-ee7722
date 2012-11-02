/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Class and Related Defintions for Phys (Physical Objects)

#ifndef PHYS_H
#define PHYS_H

#include "boxes.h"

// Cast a Phys to a more specialized compatible class, or NULL.
//
#define BALL(p) \
  ({Phys* const _p = p; _p->phys_type == PT_Ball ? (Ball*) _p : NULL;})
#define TILE(p) \
  ({Phys* const _p = p; _p->phys_type == PT_Tile ? (Tile*) _p : NULL;})
#define BOX(p) \
  ({Phys* const _p = p; _p->phys_type == PT_Box ? (Box*) _p : NULL;})


// Class describing a physical object.
//
class Phys {
public:
  Phys(Phys_Type phys_type);
  Phys(Phys& phys);
  virtual ~Phys();
  const Phys_Type phys_type;
  Phys* const original;         // Pointer to original if this is a copy.
  int idx;                      // Index into an array.
  int serial;                   // For debugging.
  bool read_only;               // If true, no need to update position, etc.

  // Re-compute constants such as radius_sq. Used after constants change.
  virtual void constants_update(){};
  // Re-compute vertex and normal positions. Used after orientation changes.
  virtual void geometry_update(){};

  // Routines below for axis sorting.
  virtual float max_z_get(double delta_t) { return 0; }
  virtual float min_z_get(double delta_t) { return 0; }

  virtual float get_moment_of_inertia_inv(pNorm axis){ return 0; }

  float density, mass, mass_inv;

  float radius, radius_sq, radius_inv; // Radius of bounding sphere.

  pCoor position; // Of centroid.
  pVect velocity;
  pQuat orientation;
  pVect omega;

  pVect prev_velocity;
  pVect prev_omega;

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
  void rotate(pVect axis, float angle);

  pColor color_event;           // Color based on a recent event.
  pColor color;                 // The ball's "real" color.

  GLuint query_occlusion_id;
  bool occlusion_query_active;
  bool occluded;
  int occluded_run;
  int occlusion_countdown;

  int contact_count;        // Number of other objects in contact with.
  bool collision;           // True if object collided with something.
  uint32_t debug_pair_calls;

  // Members needed for scheduling proximity pairs on CUDA. Values
  // assigned are temporary and usually change during scheduling. For
  // example, a ball can be in multiple CUDA passes so a value for
  // pass does not indicate that it's the only pass it can be in.
  //
  PStack<int> proximity;     // Nearby phys objects.
  int proximity_cnt;
  int prox_check;               // Used for correctness verification.
  int pass;
  int pass_todo;
  int rounds;
  bool placed;
  int block;
  int color_block; // Block number to use for coloring ball.
  int sm_idx;      // Index into CUDA shared memory array.
};


#endif
