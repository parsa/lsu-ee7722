/// LSU EE X70X GPU Prog / Microarch
//
 /// Class and Related Code for Phys (Physical Objects)

#include "phys.h"

int phys_serial_next = 0;

Phys::Phys(Phys_Type phys_type):
  phys_type(phys_type),original(NULL)
{
  read_only = false;
  occluded = false;
  occlusion_query_active = false;
  occluded_run = 0;
  occlusion_countdown = 0;
  glGenQueries(1,&query_occlusion_id);
  contact_count = 0;
  collision = false;
  serial = phys_serial_next++;
  debug_pair_calls = 0;
}

Phys::Phys(Phys& phys)
  :phys_type(phys.phys_type),original(&phys)
{
#define C(m) m=phys.m
  C(read_only);
  C(serial);C(idx);
  C(proximity);
  C(contact_count); C(debug_pair_calls); C(collision);
  query_occlusion_id = 0;
#undef C
}

Phys::~Phys()
{
  if ( query_occlusion_id )
    glDeleteQueries(1,&query_occlusion_id);
}

 /// External Modifications to State
//
//   These allow the user to play with state while simulation
//   running.

// Move the ball.
//
void Phys::translate(pVect amt) {position += amt; geometry_update();}

// Add velocity to the ball.
//
void Phys::push(pVect amt) {velocity += amt; geometry_update();}

// Set the velocity to zero.
//
void Phys::stop()
{
  velocity = pVect(0,0,0);
}

void Phys::rotate(pVect axis, float angle)
{
  pQuat rotq(axis,angle);
  orientation = rotq * orientation;
  geometry_update();
}
