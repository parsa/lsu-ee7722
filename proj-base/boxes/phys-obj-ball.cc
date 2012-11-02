/// LSU EE X70X GPU Prog / Microarch
//
 /// Class for Ball

#include "phys-obj-ball.h"
#include "world.h"

Ball::Ball(World* wp, float r):Phys(PT_Ball),w(*wp)
{
  w.cuda_at_balls_change();
  density = w.opt_ball_density;
  set_radius( r == 0 ? w.opt_ball_radius : r );

  color_event = pColor(0.5,0.5,0.5);
  color = pColor(0.5,0.5,0.5);
  position = pCoor(30,22,-15.4);
  velocity = pVect(drand48(),0,drand48());

  orientation.set(pVect(0,1,0),0);
  omega = pVect(0,0,0);
}

Ball::~Ball()
{
  if ( original ) return;
  ASSERTS( ! ( w.data_location & DL_ALL_CUDA ) );
  ASSERTS( w.pt_sched_is_idle() );
}

void
Ball::constants_update()
{
  radius_sq = radius * radius;
  mass = 4.0 / 3 * M_PI * radius_sq * radius * density;
  radius_inv = 1 / radius;
  mass_inv = read_only ? 0 : 1 / mass;
  short_xrad_sq = ( w.platform_xrad - radius ) * ( w.platform_xrad - radius );
  long_xrad_sq = ( w.platform_xrad + radius ) * ( w.platform_xrad + radius );
  mi_inv = 2.5 * mass_inv * radius_inv * radius_inv;
  // FYI, notice simplifications:
  //   const float mo_inertia = 0.4 * mass * radius_sq;
  //   fdt_to_do = radius / mo_inertia;
  fdt_to_do = radius_inv * 2.5 * mass_inv;
}
