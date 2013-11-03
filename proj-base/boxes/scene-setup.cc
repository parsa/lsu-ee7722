/// LSU EE X70X GPU Prog / Microarch
//
 /// Initialize different scenes (add balls, boxes, tiles to scene).

#include "boxes.h"
#include "world.h"
#include "phys-obj-ball.h"
#include "phys-obj-box.h"
#include "phys-obj-tile.h"

void
World::setup_staircase()
{
  //  Use tiles to construct a staircase.
  //
  all_remove();
  const int step_count = 10;
  const float x2 = platform_xmax - 0.1 * platform_xrad;
  const float x1 = platform_xmid + 0.1 * platform_xrad;
  const float step_size = ( x2 - x1 ) / step_count;
  const pVect step_hor(step_size,0,0);
  const pVect step_ver(0,step_size,0);
  const pVect step_wid(0,0,20);
  const pCoor step_start(x1,-0.9*platform_xrad,platform_zmax-30);
  pColor step_color(0.5,0.5,0.5);
  for ( int i=0; i<step_count; i++ )
    {
      const pCoor step_ll = step_start + i * ( step_hor + step_ver );
      tile_manager->new_tile(step_ll,step_hor,step_wid,step_color);
      tile_manager->new_tile(step_ll+step_hor,step_ver,step_wid,step_color);
    }

  Ball* const b = new Ball(this);
  b->position = step_start + 0.5 * step_wid + pVect(0,5,0);
  b->velocity = pVect(0,0,0);
  physs += b;
  variables_update();
}

void
World::setup_debug()
{
  // Setup scene needed to debug something.

  all_remove();

  pCoor b1(-7.92045593,  -38.3105736,  46.7977409);
  pQuat q1( -0.516331136,  0.065878585,  -0.848956704,
            -0.0912945643);
  pVect d1( 3.79823494,  0.800000012,  0.884832799);

  pCoor b2(-4.63814354,  -37.6203384,  47.0100594);
  pVect d2(2,2,2);
  pQuat q2( -0.0276855193,  -0.240952447,  -0.0504386313, 0.96882993);

  Box* const bx1 = box_manager->new_box_ctr(b1,2*d1,color_green_yellow);
  bx1->orientation = q1;
  bx1->geometry_update();
  Box* const bx2 = box_manager->new_box_ctr(b2,2*d2,color_snow);
  bx2->orientation = q2;
  bx2->geometry_update();
  return;

  pCoor corner(-1,-0.9*platform_xrad,platform_zmax-14);
  Box* const b = box_manager->new_box(corner,pVect(2,4,8),color_green_yellow);
  b->read_only = false;
  const float r_short = platform_xrad - opt_ball_radius;

  //  box_manager->new_box(corner+pVect(1,3,1),pVect(2,4,8),color_snow);
  box_manager->new_box(corner+pVect(1,0.01,0.01),pVect(2,4,8),color_snow);
  return;

  if ( true )
    {
      const double sa = asin( opt_ball_radius / r_short );
      const double ca = 1.5 * M_PI;
      const double a[] = { ca - sa, ca + sa, ca };
      const double r[] =
        { r_short, r_short,
          r_short - sqrt(3) * opt_ball_radius
        };
      for ( int i=0; i<3; i++ )
        {
          Ball* const b = new Ball(this);
          b->position = pCoor( r[i] * cos(a[i]), r[i] * sin(a[i]), 45);
          b->velocity = pVect(0,0,0);
          physs += b;
        }
    }
}

void
World::setup_brick_wall(float max_y)
{
  // Remove all existing objects from scene.
  //
  all_remove();

  // If true, bottom bricks don't move.
  const bool glued = true;

  float block_width = 4;
  const float block_depth = block_width * 16.375 / 12.675; // Moving boxes.
  pVect block_diag(block_depth,block_width,block_width);
  pCoor block_base
    (-block_diag.x*0.5,
     -sqrt(platform_xrad * platform_xrad
           - 0.25 * block_diag.x * block_diag.x),
     platform_zmax - 80);
  const float z_start = block_base.z;
  const float pitch_factor = 1.5;
  const float pitch = block_diag.z * pitch_factor;
  pVect block_diag_long
    (block_diag.x,block_width, block_width*((pitch_factor*0.5)));

  for ( int layer = 0; block_base.y < max_y;
        layer++, block_base.y += block_diag.y )
    {
      block_base.z = z_start;

      // Place odd shaped green block at wall start.
      //
      if ( layer & 1 )
        {
          Box* const b = box_manager->new_box
            (block_base, block_diag_long, color_yellow_green);
          if ( glued && layer == 0 ) b->set_read_only();
          block_base.z += block_diag_long.z;
        }

      // Place regular bricks.
      //
      while ( block_base.z < platform_zmax - pitch + 0.1 )
        {
          Box* const b = box_manager->new_box
            (block_base, block_diag, color_maroon);
          if ( glued && layer == 0 ) b->set_read_only();
          for ( int i=0; i<6; i++ )
            b->set_face_texture(i,texid_mural);
          block_base.z += pitch;
        }

      // Place odd shaped green block at wall start.
      //
      if ( ( layer & 1 ) )
        {
          block_base.z -= (pitch_factor-1)*block_diag.z;
          Box* const b = box_manager->new_box
            (block_base, block_diag_long, color_yellow_green);
          if ( glued && layer == 0 ) b->set_read_only();
          block_base.z += block_diag_long.z;
        }
    }
}

void
World::setup_tower(float base, int layers, bool balls)
{
  // Remove all existing objects from scene.
  //
  all_remove();

  const bool glued = false;
  float block_width = base;
  pCoor block_base
    (0,
     opt_platform_curved
     ? -sqrt(platform_xrad * platform_xrad
             - 0.25 * block_width * block_width)
     : platform_y,
     drip_location.z);

  for ( int i=0; i<layers; i++ )
    {
      pVect block_diag
        (block_width,balls ? block_width * 0.05 : block_width,block_width);

      // Add a new block to scene.
      //
      Box* const b = box_manager->new_box
        (block_base + pVect(-block_diag.x*0.5,0,-block_diag.z*0.5),
         block_diag,color_khaki);

      for ( int j=0; i<6; i++ )
        b->set_face_texture(j,texid_mural);

      // Rotate it.
      //
      const float angle = i * 0.1 *M_PI;
      b->rotate(pVect(0,1,0),angle);

      // Maybe fix it in place if its the bottom block.
      //
      if ( glued && i == 0 ) b->set_read_only();

      // Increment the tower y position.
      //
      block_base += pVect(0,block_diag.y,0);

      // Maybe put of circle of balls between tower blocks.
      //
      const float ball_radius = 1.5;
      const float maj_rad = 0.4 * block_width - ball_radius;
      const float delta_theta = 2 * M_PI / 8;
      pCoor center(b->position.x,block_base.y+ball_radius,b->position.z);
      if ( balls )
        {
          for ( float theta = 0.01; theta < 2 * M_PI; theta += delta_theta )
            {
              const float bangle = angle + theta;
              Ball* const b = new Ball(this);
              b->position =
                center + maj_rad * pVect(cosf(bangle),0,sinf(bangle));
              b->radius = ball_radius;
              b->velocity = pVect(0,0,0);
              b->omega = pVect(0,0,0);
              // Add ball to list of simulated objects. This does not
              // have to be done for tiles and boxes.
              physs += b;
            }
          block_base.y += 2 * ball_radius;
        }

      // Taper the blocks if they aren't too small.
      //
      if ( !balls && block_width > 1.5 ) block_width *= 0.90;
    }
}

void
World::setup_house_of_cards()
{
  all_remove();

  const float base_depth = 0.8 * platform_xrad;
  const float base_height = 2;
  const float surface_y = 
    opt_platform_curved ? -base_depth + base_height : platform_y;
  if ( opt_platform_curved )
    {
      const float platform_wh = sqrtf(SQ(platform_xrad)-SQ(base_depth));
      pCoor base_pos(-platform_wh,-base_depth,0);
      Box* const base = box_manager->new_box
        (base_pos,pVect(2*platform_wh,base_height,platform_zmax),
         pColor(0.5,0.5,0.5));
      base->set_read_only();
    }
  pVect card_diag(10,5,0.1);

  drip_location.x = 0;
  pCoor center(0,surface_y,drip_location.z-opt_ball_radius);
  const double tilt_angle = 1.01 * atan2(card_diag.z,card_diag.y);
  const double delta_theta = 2 * M_PI / 4;
  const double tilt_offset = card_diag.z * cos(tilt_angle);
  const double inner_r = 0.25 * card_diag.x;
  pVect radvec(inner_r - tilt_offset - 0.5 * card_diag.x,
               0.5 * card_diag.y + card_diag.z * sin(tilt_angle),
               -inner_r);
  const float card_yz = sqrt(SQ(card_diag.y)+SQ(card_diag.z));

  pVect h(0,0,0);
  for ( int layer=0; layer<5; layer++ )
    {
      for ( int i=0; i<4; i++ )
        {
          const double theta = i * delta_theta + layer * 0.1;
          pMatrix_Rotation rot(pVect(0,1,0),theta);
          pCoor card_ctr = center + rot * radvec;
          Box* const card = box_manager->new_box_ctr
            (card_ctr+h,card_diag,i&1?color_yellow_green:color_salmon);
          card->rotate(pVect(1,0,0),tilt_angle);
          card->rotate(pVect(0,1,0),theta);
        }

      pCoor c1_pos(center + pVect(0,card_yz+0.45*card_diag.z,-0.5*card_diag.y));
      Box* const card_c1 = box_manager->new_box_ctr
        (c1_pos+h, card_diag, color_salmon);
      card_c1->rotate(pVect(1,0,0),0.5*M_PI);
      Box* const card_c2 = box_manager->new_box_ctr
        (c1_pos+h+pVect(0,0, 1.01 * card_diag.y),
         card_diag, color_yellow_green);
      card_c2->rotate(pVect(1,0,0),0.5*M_PI);
      center.y += card_yz + card_diag.z;
    }
}

void
World::benchmark_setup(int tiers)
{
  // Set up an arrangement of balls intended for performance measurement.

  cuda_at_balls_change();

  for ( Phys *phys; phys_live_iterate(phys); )
    { physs.iterate_yank(); delete phys; }

  const bool opt_multisize = false;

  // Note that number of balls determined by ball size.
  opt_ball_radius = opt_multisize ? 2.5 : 1.08;

  const float delta_x = opt_ball_radius * 2.1;
  const float delta_z = opt_ball_radius * 3 * 4;
  const float hdeltaz = delta_z / 2;
  const float hdeltax = delta_x / 2;
  const float delta_y = 2.1 * opt_ball_radius;
  const float ymax = delta_y * tiers - 0.001;

  const int balls_per_sheet = 30.0 * tiers * 2 * platform_xrad / delta_x;


  opt_drop_boxes = opt_drip = false;
  opt_spray_on = false;
  opt_verify = false;
  opt_mirror = false;
  opt_shadows = false;
#if 0
  const float platform_zwid = platform_zmax - platform_zmin;
  int ball_amt = 30000;
  while ( ball_amt > 0 )
    {
      const float z = platform_xmin + platform_zwid * drand48();
      const float x = platform_xmin + 2.0 * drand48() * platform_xrad;
      const float y = 2 * opt_ball_radius + drand48() * ymax;
      const pCoor pos(x,y,z);
      const double rad_min = 0.6;
      const float rad = max(rad_min,opt_ball_radius * pow(drand48(),1));
      if ( !sphere_empty(pos,rad) ) continue;
      ball_amt--;
      Ball* const b = new Ball(this);
      b->set_radius(rad);
      b->velocity = pVect(0,0,0);
      b->position = pos;
      physs += b;
    }
  return;
#endif

  //  const int balls_per_sheet = 30.0 * tiers * 2 * platform_xrad / delta_x;;

  opt_drop_boxes = opt_drip = false;
  opt_spray_on = false;
  opt_verify = false;
  opt_mirror = false;
  //  opt_shadows = false;
  //  opt_friction_coeff = 2.0;
  //  opt_friction_coeff = 0.01;
  opt_ball_density = 0.07;

  if ( opt_multisize )
    {
      for ( float z = platform_zmin + hdeltaz; z < platform_zmax; z+= delta_z )
        {
          for ( int i=0; i<balls_per_sheet; i++ )
            {
              const float x = platform_xmin + 2.0 * drand48() * platform_xrad;
              const float y = 2 * opt_ball_radius + drand48() * ymax;
              const pCoor pos(x,y,z);
              const double rad_min = 0.6;
              const float rad = max(rad_min,opt_ball_radius * pow(drand48(),1));
              if ( !sphere_empty(pos,rad) ) continue;
              Ball* const b = new Ball(this);
              b->set_radius(rad);
              b->velocity = pVect(0,0,0);
              b->position = pos;
              physs += b;
            }
        }
    }
  else
    {
      for ( float z = platform_zmin + hdeltaz; z < platform_zmax; z+= delta_z )
        for ( float x = platform_xmin + hdeltax;
              x < platform_xmax; x += delta_x )
          for ( float y = 0; y < ymax; y+= delta_y )
            {
              Ball* const b = new Ball(this);
              b->velocity.z = 0;
              b->position = pCoor(x,y,z);
              physs += b;
            }
    }
  variables_update();
  opt_elasticity = 0.1 / 16;
  opt_ball_density = 0.9;
  opt_ball_radius = 3.0;
}
