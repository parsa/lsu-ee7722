/// LSU EE X70X GPU Prog / Microarch
//
 /// Code for resolving contact between objects.

#include "boxes.h"
#include "world.h"
#include "phys-obj-ball.h"
#include "phys-obj-box.h"
#include "phys-obj-tile.h"

bool
World::penetration_balls_resolve(Ball *ball1, Ball *ball2, bool b2_real)
{
  /// Update velocity and angular momentum for a pair of balls in contact.

  const pNorm dist(ball1->position,ball2->position);

  // Return if balls aren't touching.  Note avoidance of square root.
  //
  if ( dist.mag_sq >= 3 * (ball1->radius_sq+ball2->radius_sq) ) return false;

  const double radii_sum = ball1->radius + ball2->radius;

  if ( dist.magnitude >= radii_sum ) return false;

  // Update counters used for optimization and to decide when to
  // release new balls (collision_count).
  //
  ball1->contact_count++;
  if ( b2_real ) ball2->contact_count++;

  // Compute relative (approach) velocity.
  //
  pVect prev_appr_vel = ball1->prev_velocity - ball2->prev_velocity;
  const double prev_approach_speed = dot( prev_appr_vel, dist );

  const double loss_factor = 1 - opt_bounce_loss;

  // Compute change in speed based on how close balls touching, ignoring
  // energy loss.
  //
  const double appr_force_dt_no_loss =
    ( radii_sum - dist.magnitude ) * elasticity_inv_dt;

  // Change in speed accounting for energy loss. Only applied when
  // balls separating.
  //
  const double appr_force_dt =
    prev_approach_speed > 0
    ? appr_force_dt_no_loss : loss_factor * appr_force_dt_no_loss;

  const double appr_deltas_1 = appr_force_dt * ball1->mass_inv;

  /// Update Linear Velocity
  //
  ball1->velocity -= appr_deltas_1 * dist;
  if ( b2_real ) ball2->velocity += appr_force_dt * ball2->mass_inv * dist;

  // Find speed on surface of balls at point of contact.
  //
  pVect tact1_rot_vel = ball1->point_rot_vel(dist);
  pVect tact2_rot_vel = ball2->point_rot_vel(-dist);

  // Find relative velocity of surfaces at point of contact
  // in the plane formed by their surfaces.
  //
  pVect tan_vel = prev_appr_vel - prev_approach_speed * dist;
  pNorm tact_vel_dir = tact1_rot_vel - tact2_rot_vel + tan_vel;

  // Find change in velocity due to friction.
  //
  const double fric_force_dt_potential =
    appr_force_dt_no_loss * opt_friction_coeff;

  const double mass_inv_sum =
    b2_real ? ball1->mass_inv + ball2->mass_inv : ball1->mass_inv;

  const double force_dt_limit =
    tact_vel_dir.magnitude / ( 3.5 * mass_inv_sum );

  // If true, surfaces are not sliding or will stop sliding after
  // frictional forces applied. (If a ball surface isn't sliding
  // against another surface than it must be rolling.)
  //
  const bool will_roll = force_dt_limit <= fric_force_dt_potential;

  const double sliding_fric_force_dt =
    will_roll ? force_dt_limit : fric_force_dt_potential;

  const double dv_tolerance = 0.000001;

  const double sliding_fric_dv_1 = sliding_fric_force_dt * ball1->mass_inv;

  if ( sliding_fric_dv_1 > dv_tolerance )
    {
      // Apply tangential force (resulting in angular momentum change) and
      // linear force (resulting in velocity change).
      //
      ball1->apply_tan_force_dt(dist,tact_vel_dir,-sliding_fric_force_dt);
      ball1->velocity -= sliding_fric_dv_1 * tact_vel_dir;
    }

  const double sliding_fric_dv_2 = sliding_fric_force_dt * ball2->mass_inv;

  if ( b2_real && sliding_fric_dv_2 > dv_tolerance )
    {
      // Apply frictional forces for ball 2.
      //
      ball2->apply_tan_force_dt(-dist,tact_vel_dir,sliding_fric_force_dt);
      ball2->velocity += sliding_fric_dv_2 * tact_vel_dir;;
    }

  // Check for correctness.
  //
  if ( false && opt_verify && b2_real && will_roll )
    {
      // Check only works if current velocity used for friction calc.
      //
      pVect appr_vel2 = ball1->velocity - ball2->velocity;
      const double approach_speed2 = dot( appr_vel2, dist );

      pVect tact1_rot_vel2 = ball1->point_rot_vel(dist);
      pVect tact2_rot_vel2 = ball2->point_rot_vel(-dist);

      pVect tan_vel2 = appr_vel2 - approach_speed2 * dist;
      pNorm tan_vel_dir2 = tact1_rot_vel2 - tact2_rot_vel2 + tan_vel2;
      ASSERTS( tan_vel_dir2.magnitude <= 0.0001 + 100 * dv_tolerance );
      ball1->color_event = ball2->color_event = pColor(1,1,1);
    }

  {
    /// Torque
    //
    //
    // Account for forces of surfaces twisting against each
    // other. (For example, if one ball is spinning on top of
    // another.)
    //
    const double appr_omega = dot(ball2->omega,dist) - dot(ball1->omega,dist);
    const double fdt_to_do_sum =
      b2_real ? ball1->fdt_to_do + ball2->fdt_to_do : ball1->fdt_to_do;
    const double fdt_limit = fabs(appr_omega) / fdt_to_do_sum;
    const bool rev = appr_omega < 0;
    const double fdt_raw = min(fdt_limit,fric_force_dt_potential);
    const pVect fdt_v = ( rev ? -fdt_raw : fdt_raw ) * dist;
    ball1->omega += ball1->fdt_to_do * fdt_v;
    if ( b2_real ) ball2->omega -= ball2->fdt_to_do * fdt_v;
  }

  // This code turned off since multiple-radius ball modification.
  //
  if(0){
    /// Rolling Friction
    //
    // The rolling friction model used here is ad-hoc.

    pVect tan_b12_vel = b2_real ? 0.5 * tan_vel : pVect(0,0,0);
    const double torque_limit_sort_of = appr_force_dt_no_loss
      * sqrt( radii_sum - dist.mag_sq / radii_sum );
      //  * sqrt( ball1->radius - 0.25 * dist.mag_sq * r_inv );

    pVect tact1_rot_vel = ball1->point_rot_vel(dist);
    pVect tact1_roll_vel = tact1_rot_vel + tan_b12_vel;
    pNorm tact1_roll_vel_dir = tact1_roll_vel;
    pVect lost_vel(0,0,0);

    const float rfric_loss_dv_1 =
      torque_limit_sort_of * 2.5 * ball1->mass_inv *
      ( tact1_roll_vel_dir.magnitude * opt_friction_roll /
        ( 1 + tact1_roll_vel_dir.magnitude * opt_friction_roll ) );

    pVect lost_vel1 =
      min(tact1_roll_vel_dir.magnitude, rfric_loss_dv_1) * tact1_roll_vel_dir;

    lost_vel = -lost_vel1;

    if ( b2_real )
      {
        pVect tact2_rot_vel = ball2->point_rot_vel(-dist);
        pVect tact2_roll_vel = tact2_rot_vel - tan_b12_vel;
        pNorm tact2_roll_vel_dir = tact2_roll_vel;
        const float rfric_loss_dv_2 =
          torque_limit_sort_of * 2.5 * ball2->mass_inv *
          ( tact2_roll_vel_dir.magnitude * opt_friction_roll /
            ( 1 + tact2_roll_vel_dir.magnitude * opt_friction_roll ) );
        pVect lost_vel2 =
          min(tact2_roll_vel_dir.magnitude, rfric_loss_dv_2 )
          * tact2_roll_vel_dir;

        lost_vel += lost_vel2;
      }

    ball1->apply_tan_force_dt(dist,0.4 * ball1->mass * lost_vel);
    if ( b2_real ) ball2->apply_tan_force_dt(dist, 0.4*ball2->mass * lost_vel);

    if ( false && opt_verify )
      {
        pVect ch_tact1_rot_vel = ball1->point_rot_vel(dist);
        pVect ch_tact1_roll_vel = ch_tact1_rot_vel + tan_b12_vel;
        const double magloss = tact1_roll_vel.mag() - ch_tact1_roll_vel.mag();
        ASSERTS( magloss >= -10.0 );
      }
  }

  return true;
}

bool
World::penetration_boxes_resolve_force(Tact_Box_Box *cpair)
{
  Box* const box1 = cpair->box1;
  Box* const box2 = cpair->box2;
  SectTT sect = cpair->sect;

  const float pen_dist = 0.1 * sect.end.x;

  pVect sep_normal = sect.dir;
  pCoor pos = sect.start;

  box1->contact_count++;
  box2->contact_count++;

  pVect vel1 = box1->get_vel(pos);
  pVect vel2 = box2->get_vel(pos);
  pVect velto1 = vel2 - vel1;

  const float sep_vel = dot(velto1,sep_normal);

  const double loss_factor = 1 - opt_bounce_loss_box;
  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const bool separating = sep_vel >= 0;
  const float appr_force_dt = separating
    ? force_dt_no_loss * loss_factor : force_dt_no_loss;

  if ( opt_outline_intersection )
    {
      SectTT& s_cent = sects.peek();
      s_cent.sect_case = separating ? 1 : 2;
    }

  pVect sep_force = appr_force_dt * sep_normal;

  box1->apply_force_dt(pos, -sep_force );
  box2->apply_force_dt(pos, sep_force );
  return true;
}

bool
World::penetration_boxes_resolve_fric(Tact_Box_Box *cpair)
{
  Box* const box1 = cpair->box1;
  Box* const box2 = cpair->box2;
  SectTT sect = cpair->sect;

  const float pen_dist = 0.1 * sect.end.x;

  pVect sep_normal = sect.dir;
  pCoor pos = sect.start;

  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const float fric_force_dt_potential =
    force_dt_no_loss * opt_friction_coeff;

  /// Torque
  //
  //
  // Account for forces of surfaces twisting against each
  // other. (For example, if one box is spinning on top of
  // another.)
  //
  const float appr_omega =
    dot(box2->omega,sep_normal) - dot(box1->omega,sep_normal);
  if ( fabs(appr_omega) > 0.00001 )
    {
    const float mi1_inv = box1->get_moment_of_inertia_inv(sep_normal);
    const float mi2_inv = box2->get_moment_of_inertia_inv(sep_normal);
    const float fdt_limit = fabs(appr_omega) / ( mi1_inv + mi2_inv );
    const bool rev = appr_omega < 0;
    const float fdt_raw = min(fdt_limit,fric_force_dt_potential);
    const pVect fdt_v = ( rev ? -fdt_raw : fdt_raw ) * sep_normal;
    if ( !box1->read_only ) box1->omega += mi1_inv * fdt_v;
    if ( !box2->read_only ) box2->omega -= mi2_inv * fdt_v;
    const float appr_omega_after =
      dot(box2->omega,sep_normal) - dot(box1->omega,sep_normal);
    ASSERTS( fabs(appr_omega_after) <= fabs(appr_omega) );
  }


  pVect vel1b = box1->get_vel(pos);
  pVect vel2b = box2->get_vel(pos);

  pVect velto1b = vel2b - vel1b;

  const float sep_velb = dot(velto1b,sep_normal);
  pNorm tan_vel = velto1b - sep_velb * sep_normal;

  const float fdt_limit =
    0.5 *
    tan_vel.magnitude /
    ( box1->mass_inv + box2->mass_inv
      + box1->get_moment_of_inertia_inv(pos,tan_vel)
      + box2->get_moment_of_inertia_inv(pos,tan_vel) );

  const float fric_force_dt = min(fdt_limit,fric_force_dt_potential);

  box1->apply_force_fric_dt(pos, tan_vel, fric_force_dt);
  box2->apply_force_fric_dt(pos, -tan_vel, fric_force_dt);

  return true;
}

bool
World::penetration_box_ball_resolve(Box *box, Ball *ball)
{
  SectTT sect = box_sphere_interpenetrate(box,ball->position,ball->radius);
  if ( !sect.exists ) return false;

  box->contact_count++;
  ball->contact_count++;

  if ( opt_outline_intersection ) sects += sect;

  pVect sep_normal = sect.dir;
  pCoor pos = sect.start;

  const float pen_dist = 0.1 * sect.end.x;

  pVect vel1 = box->get_vel_prev(pos);
  pVect vel2 = ball->prev_velocity;
  pVect velto1 = vel2 - vel1;

  const float sep_vel = dot(velto1,sep_normal);

  const double loss_factor = 1 - opt_bounce_loss_box;
  const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
  const bool separating = sep_vel >= 0;
  const float appr_force_dt = separating
    ? force_dt_no_loss * loss_factor : force_dt_no_loss;

  if ( opt_outline_intersection )
    {
      SectTT& s_cent = sects.peek();
      s_cent.sect_case = separating ? 1 : 2;
    }

  pVect sep_force = appr_force_dt * sep_normal;

  box->apply_force_dt(pos, -sep_force );
  ball->velocity += ball->mass_inv * sep_force;

  pVect vel1b = box->get_vel(pos);
  pVect vel2b = ball->point_rot_vel(-sep_normal) + ball->velocity;

  pVect velto1b = vel2b - vel1b;

  const float sep_velb = dot(velto1b,sep_normal);
  pNorm tan_vel = velto1b - sep_velb * sep_normal;
  const float fric_force_dt_potential =
    force_dt_no_loss * opt_friction_coeff;
  const float fdt_limit =
    tan_vel.magnitude /
    (
     ( box->read_only ? 0
       : box->mass_inv + box->get_moment_of_inertia_inv(pos,tan_vel) )
     + ( ball->read_only ? 0 : ball->mass_inv + ball->mi_inv ));

  const float fric_force_dt = min(fdt_limit,fric_force_dt_potential);

  box->apply_force_fric_dt(pos, tan_vel, fric_force_dt);
  ball->velocity -= fric_force_dt * ball->mass_inv * tan_vel;
  ball->apply_tan_force_dt(sep_normal,tan_vel,fric_force_dt);

  /// Torque
  //
  //
  // Account for forces of surfaces twisting against each
  // other. (For example, if one box is spinning on top of
  // another.)
  //
  const float appr_omega =
    dot(box->omega,sep_normal) - dot(ball->omega,sep_normal);
  if ( fabs(appr_omega) > 0.00001 )
    {
    const float mi1_inv = box->get_moment_of_inertia_inv(sep_normal);
    const float mi2_inv = ball->get_moment_of_inertia_inv(sep_normal);
    const float fdt_limit = fabs(appr_omega) / ( mi1_inv + mi2_inv );
    const bool rev = appr_omega < 0;
    const float fdt_raw = min(fdt_limit,fric_force_dt);
    const pVect fdt_v = ( rev ? fdt_raw : -fdt_raw ) * sep_normal;
    if ( !box->read_only ) box->omega += mi1_inv * fdt_v;
    if ( !ball->read_only ) ball->omega -= mi2_inv * fdt_v;
    const float appr_omega_after =
      dot(box->omega,sep_normal) - dot(ball->omega,sep_normal);
    ASSERTS( fabs(appr_omega_after) <= fabs(appr_omega) );
  }

  return true;
}
