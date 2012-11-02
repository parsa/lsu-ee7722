/// LSU EE X70X GPU Prog / Microarch -*- c++ -*-
//
 /// Class for Ball


#ifndef PHYS_OBJ_BALL_H
#define PHYS_OBJ_BALL_H

#include "boxes.h"
#include "phys.h"

// Class representing physical ball.
//
class Ball : public Phys {
public:
  Ball(World *w, float r = 0);
  Ball(Ball &b):Phys(b),w(b.w)
  {
#define C(m) m=b.m
    C(position);C(velocity);C(orientation);C(omega);
    C(prev_velocity);
#undef C
  }
  ~Ball();

  float max_z_get(double delta_t);
  float min_z_get(double delta_t);

  void set_radius(float r)
  {
    radius = r;
    constants_update();
  }

  void constants_update();

  World& w;
  float fdt_to_do;
  float mi_inv; // Inverse of moment of inertia.

  float short_xrad_sq, long_xrad_sq;

  float get_moment_of_inertia_inv(pNorm axis);
  pVect point_rot_vel(pNorm tact_dir);
  void apply_tan_force_dt(pNorm tact_dir, pNorm force_dir, double force_dt);
  void apply_tan_force_dt(pNorm tact_dir, pVect force_dt);
};


inline float
Ball::max_z_get(double lifetime_delta_t)
{
  const float m = fabs(velocity.x) + fabs(velocity.y) + fabs(velocity.z);
  const float max_z = position.z + position.x + m * lifetime_delta_t
    + 2 * radius;
  return max_z;
}

inline float
Ball::min_z_get(double lifetime_delta_t)
{
  const float m = fabs(velocity.x) + fabs(velocity.y) + fabs(velocity.z);
  const float z_min = position.z + position.x - m * lifetime_delta_t
    - 2 * radius ;
  return z_min;
}

inline pVect
Ball::point_rot_vel(pNorm direction)
{
  /// Return velocity of point on surface of ball.
  //
  return radius * cross( omega, direction );
}

inline float
Ball::get_moment_of_inertia_inv(pNorm axis)
{
  if ( read_only ) return 0;
  return mi_inv;
}

inline void
Ball::apply_tan_force_dt(pNorm tact_dir, pNorm force_dir, double force_dt)
{
  /// Change rotation rate due to force_dt at tact_dir in direction force_dir.
  //
  omega += cross(tact_dir, fdt_to_do * force_dt * force_dir);
}


inline void
Ball::apply_tan_force_dt(pNorm tact_dir, pVect force_dt)
{
  omega += cross(tact_dir, fdt_to_do * force_dt );
}

#endif
