/// LSU EE 4702-1 (Fall 2012), GPU Programming
//
 /// Project Base Code: Balls and Boxes on a Curved Platform

// $Id:$

/// Purpose
//
//   Main file for simulation of balls and boxes.


/// What Code Does

//  Simulates balls and boxes bouncing on a half-cylinder platform.
//    Scenes with a brick wall, tower, and staircase can be set up.

//  Features

//    Ball and box friction and angular momentum modeled.

//    Physics computed by CPU or by GPU/CUDA (user selectable).
//      Demonstrates use of CUDA for GPU physics, also use of
//      CPU multi-threading (currently only in conjunction with CUDA).

//    Objects cast shadows on platform:
//      Demonstrates use of stencils and shadow volumes.

//    Object reflections visible on mirrored tiles.
//      Demonstrates stencils, blending, vertex, and geometry shaders.
//      Vertex shader computes reflection locations (> 1 per vertex).
//      Geometry shader emits triangles for all reflection points.
//      Later, tile image is blended over reflected image of balls.

//    Occlusion queries used to limit number of balls rendered.

//    Two-color specular lighting used for balls.




///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move object. (Change position but not velocity.)
 //   'D': Move object drip location.
 //   'B': Push object. (Add velocity.)
 //
 /// Eye Direction
 //   Home, End, Delete, Insert
 //   Turn the eye direction.
 //   Home should rotate eye direction up, End should rotate eye
 //   down, Delete should rotate eye left, Insert should rotate eye
 //   right.  The eye direction vector is displayed in the upper left.

 /// Simulation Options
 //  (Also see variables below.)
 //
 //  'p'    Pause simulation. (Press again to resume.)
 //  'a'    Switch physics method (CPU to GPU/CUDA).

 //  'd'    Toggle dripping of objects.
 //  'j'    Toggle between dripping boxes and balls.
 //  'x'    Toggle shower of balls.
 //  'X'    Release one pair of balls.

 //  't'    Run 5-tier-of-balls benchmark.
 //  'T'    Run 1-tier-of-balls benchmark.
 //  '1'    Set up brick wall scene. (Also '1')
 //  '2'    Set up tower scene.
 //  '3'    Set up stacked plates scene.
 //  '4'    Set up staircase scene.
 //  'R'    Remove all but one ball.

 //  'm'    Toggle reflections on mirror tiles.
 //  'w'    Toggle shadows.
 //  'W'    Toggle visibility of shadow volumes.
 //  'n'    Toggle visibility of platform normals.

 //  'o'    Toggle visibility of box/box intersections. (Compile with -D TUNE).
 //  'q'    Toggle visibility of boxes.

 //  's'    Stop objects linear motion.
 //  'S'    Stop objects rotational motion.

 //  'c'    Use colors to show number of reflected points, and other info.
 //  'M'    Switch between different shortcuts in computing reflections.

 //  'g'    Turn gravity on and off.
 //  'F10'  Write video to file.
 //  'F12'  Write screenshot to file.

 /// Variables
 //   Selected program variables can be modified using the keyboard.
 //   Use "Tab" to cycle through the variable to be modified, the
 //   name of the variable is displayed next to "VAR" on the bottom
 //   line of green text.

 //  'Tab' Cycle to next variable.
 //  '`'   Cycle to previous variable.
 //  '+'   Increase variable value.
 //  '-'   Decrease variable value.
 //
 //  VAR Light Intensity 
 //              - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)
 //  VAR Ball Mass
 //  VAR Ball Radius
 //  VAR Elasticity 
 //              - Softness of balls. (Inverse of spring constant
 //                used to compute repulsion forces when balls touch.)
 //  VAR Sliding Friction 
 //              - Dynamic friction coefficient. Used for ball/ball
 //                and ball/platform contact.  The standard friction model
 //                is used, frictional force is proportional to force
 //                between two sliding surfaces.
 //  VAR Rolling Friction
 //              - Rolling friction coefficient. Used both for
 //                ball/ball and ball/platform rolling. Frictional
 //                model is ad-hoc, with force proportional to ball
 //                rotation with respect to contact point and ball
 //                deformation.
 //  VAR Bounce Energy Loss
 //              - Amount of energy lost in contact.
 //  VAR Block Size
 //              - Size of CUDA thread block, used both for the
 //                platform and pairs passes.
 //  VAR Color by Block in Pass
 //              - If opt_color_events is on, use block number
 //                in PASS to determine color of ball.


#include <math.h>

#define MAIN_FILE
#include "boxes.h"
#include "gra-shapes.h"
#include "k-main.cuh"
#include "phys.h"
#include "phys-obj-ball.h"
#include "phys-obj-tile.h"
#include "phys-obj-box.h"
#include "world.h"
#include "cuda-sched.h"
#include "gra-alhazan.h"


void
World::init()
{
  //  const int64_t seed = time(NULL);
  const int64_t seed = 1281563624;
  printf("Seeding srand48 with %ld\n",seed);
  srand48(seed);
  opt_cuda_prox = false;

  /// Initialize scheduler thread, used for computing CUDA schedule.
  //
  pt_init();

  tile_manager = new Tile_Manager(&physs);
  box_manager = new Box_Manager(this,&physs);

  data_location = DL_ALL_CPU;
  cuda_initialized = false;
  cuda_schedule_stale = 1;
  opt_physics_method = GP_cuda;
  opt_block_size = 128;
  prox_test_per_ball_prev = 0;

  frame_timer.work_unit_set("Steps / s");
  last_frame_time = world_time = 0;
  opt_gravity_accel = 20;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  opt_normals_visible = false;
  opt_outline_intersection = false;
  opt_shadows = true;
  opt_shadow_volumes = false;
  opt_mirror = true;
  opt_mirror_method = 0;
  opt_spray_on = false;
  opt_color_events = false;
  opt_debug = false;
  opt_debug2 = false;
  opt_block_color_pass = 0;

  mirror_tint = color_lsu_spirit_purple * 0.5;

  // Instantiate shaders used for reflections.
  //
  // Creating reflections uses both a vertex shader and a geometry
  // shader, see code in balls-shdr.cc for details.
  //
  vs_reflect =
    new pShader
    ("shdr.cc","vs_main_reflect();", "gs_main_reflect();", NULL);
  if ( vs_reflect->okay() )
    {
      sun_platform_xrad = vs_reflect->uniform_location("platform_xrad");
      sun_platform_xmid = vs_reflect->uniform_location("platform_xmid");
      sun_eye_location = vs_reflect->uniform_location("eye_location");
      sun_eye_to_world = vs_reflect->uniform_location("eye_to_world");
      sun_world_to_clip = vs_reflect->uniform_location("world_to_clip");
      sun_opt_mirror_method = vs_reflect->uniform_location("opt_mirror_method");
      sun_opt_color_events = vs_reflect->uniform_location("opt_color_events");
    }

  vs_plain = new pShader("shdr.cc","vs_main_plain();");
  if ( vs_plain->okay() )
    {
      sun_vs_options = vs_plain->uniform_location("vs_options");
    }

  vs_xfrom_only = new pShader("shdr.cc","vs_main_xform_only();");

  // Instantiate a non-shader shader object, which will be used to
  // tell OpenGL to used fixed functionality for all programmable
  // stages, rather than using one of our shaders.
  //
  vs_fixed = new pShader();

  eye_location = pCoor(17.9,-14,117.2);
  eye_direction = pVect(-0.15,-0.06,-0.96);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -80; platform_zmax = 80;

  // Platform and Ball Textures
  //
  texid_plat = pBuild_Texture_File("gpup.png", false, 255);
  texid_ball = pBuild_Texture_File("mult.png", false, -1);
  texid_mural = pBuild_Texture_File("bt-mural.jpeg", false, -1); 

  // Limits of texture coordinates for platform tiles.
  //
  trmax = 0.05;
  trmin = 0.7;
  tsmax = 0;
  tsmin = 0.4;

  opt_light_intensity = 100.2;
  light_location = pCoor(25.6,25.8,-14.3);

  opt_ball_radius = 2;
  opt_ball_density = 0.0074603942589580438;
  opt_friction_coeff = 0.1;
  opt_friction_roll = 0.1;
  opt_bounce_loss = 0.75;
  opt_bounce_loss_box = 0.9;
  opt_elasticity = 1.0 / 64;
  opt_drop_boxes = opt_drip = false;
  drip_cnt = spray_cnt = 0;
  drip_run = 7;
  spray_run = 8;
  dball = NULL;
  opt_verify = true;
  opt_verify = false;
  opt_time_step_factor = 18;

  variable_control.insert(schedule_lifetime_steps,"Sched Life",1,1);

  variable_control.insert_power_of_2(opt_block_size,"Block Size");
  variable_control.insert(opt_block_color_pass,"Color by Block in Pass");
  variable_control.insert(opt_ball_density,"Ball Density");
  variable_control.insert(opt_elasticity,"Elasticity");
  variable_control.insert(opt_friction_coeff,"Sliding Friction");
  variable_control.insert(opt_friction_roll,"Rolling Friction");
  variable_control.insert(opt_bounce_loss,"Bounce Energy Loss");
  variable_control.insert(opt_gravity_accel,"Gravity");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_ball_radius,"Ball Radius");
  variable_control.insert(opt_time_step_factor,"Time Step Factor",1,1);

  opt_move_item = MI_Eye;
  opt_pause = false;

  pball = new Ball(this); 
  pball->prev_velocity = pVect(0,0,0);
  pball->set_radius(1);

  drip_location = pCoor(30,20,60);

  ball_countdown = 0.1;
  sphere.init(40);
  sphere.tri_count = &tri_count;
  sphere_lite.init(4);
  sphere_lite.tri_count = &tri_count;

  // Initialize spheres with varying levels of detail (lod).
  // For performance reasons, sphere with lowest lod that provides
  // acceptable results is used.

  sphere_lod_max = 40;
  sphere_lod_min = 8;
  sphere_count = 16;
  sphere_delta_lod = ( sphere_lod_max - sphere_lod_min ) / (sphere_count-1);
  spheres = new Sphere[sphere_count];

  for ( int i=0; i<sphere_count; i++ )
    {
      const int lod = sphere_lod_min + int( i * sphere_delta_lod + 0.5 );
      spheres[i].init(lod);
      spheres[i].tri_count = &tri_count;
    }

  opt_fixed_lod = -1;
  variable_control.insert(opt_fixed_lod,"Fixed LOD",1,-1,sphere_count-1);

  variables_update();
  platform_update();
  modelview_update();

  if (false)
    {
      // Place barriers at either end of platform.
      //
      pCoor far_corner(-platform_xrad,-platform_xrad,platform_zmin);
      pVect forward(0,0,platform_zmax-platform_zmin);
      pVect across(2 * platform_xrad,0,0);
      pVect up(0, 0.5 * platform_xrad,0);
      tile_manager->new_tile(far_corner,across,up);
      tile_manager->new_tile(far_corner+forward,across,up);
    }

  /// Initialize Ball Positions
  //
  //  Code below places balls in one of several ways.
  //  Some of the ball arrangements are intended for debugging.

  if ( opt_spray_on )
    {
      physs += new Ball(this);
      return;
    }
  //  setup_tower(20,10,true); return;

  setup_brick_wall(); return;
  opt_physics_method = GP_cuda;
  setup_debug(); return;

  const float r_short = platform_xrad - opt_ball_radius;

  if ( false )
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

  if (false){
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(0,-r_short,40);
      b->velocity = pVect(0,0,0);
      physs += b;
    }
    {
      Ball* const b = new Ball(this);
      b->position = pCoor(r_short*cos(1.75*M_PI),r_short*sin(1.75*M_PI),40);
      b->velocity = pVect(0,0,0);
      physs += b;
    }
  }

  if ( false )
    {
      // Ramp.
      pCoor ramp_pos(-10,-55,platform_zmax-30);
      Box* const ramp = 
        box_manager->new_box(ramp_pos,pVect(1,40,20),color_powder_blue);
      ramp->rotate(pVect(0,0,1),0.45*M_PI);
      ramp->read_only = true;
    }
}

void
World::variables_update()
{
  // Updated pre-computed constants.
  //
  // This routine is called after user changes something.
  delta_t = 1.0 / ( 60 * opt_time_step_factor );
  delta_th = 0.5 * delta_t;
  cuda_constants_stale = true;  // Force cuda variables to be updated too.
  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;
  gravity_accel_dt = delta_t * gravity_accel;
  elasticity_inv_dt = 100 * delta_t / opt_elasticity;
  if ( opt_bounce_loss > 1 ) opt_bounce_loss = 1;
}

#include "gra-platform.h"


void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
  modelview_inv = invert(modelview);
}



///
/// Physical Simulation Code
///

 /// Initialize Simulation
//


bool
World::phys_live_iterate(Phys*& phys)
{
  while ( physs.iterate(phys) ) if ( !phys->read_only ) return true;
  return false;
}
bool
World::balls_iterate(Ball*& ball)
{
  for ( Phys *p; physs.iterate(p); ) if ( ( ball = BALL(p) ) ) return true;
  return false;
}
bool
World::boxes_iterate(Box*& box)
{
  for ( Phys *p; physs.iterate(p); ) if ( ( box = BOX(p) ) ) return true;
  return false;
}

Ball*
World::ball_first()
{
  for ( Phys_Iterator phys(physs); phys; phys++ )
    if ( Ball* const ball = BALL(phys) ) return ball;
  return NULL;
}

Phys*
World::phys_last()
{
  for ( int i = physs.occ() - 1; i>=0; i-- )
    if ( !physs[i]->read_only ) return physs[i];
  return NULL;
}

bool
World::platform_collision_possible(Ball *ball, float ts_mov_max)
{
  const pCoor pos = ball->position;
  const float r = ball->radius;

  return pos.y <= r + ts_mov_max
    && pos.x - ts_mov_max >= platform_xmin - r
    && pos.x + ts_mov_max <= platform_xmax + r
    && pos.z - ts_mov_max >= platform_zmin - r
    && pos.z + ts_mov_max <= platform_zmax + r;
}

void World::phys_check()
{
  for ( Phys_Iterator phys(physs); phys; phys++ )
    {
      Phys* const p = phys;
      if ( p->phys_type == PT_Tile ) continue;
      ASSERTS( VEC_REDUCE_AND(p->position,isfinite) );
      ASSERTS( VEC_REDUCE_AND(p->velocity,isfinite) );
    }
}

void World::all_remove()
{
  cuda_at_balls_change();
  while ( physs.occ() )
    {
      Phys* const phys = physs.pop();
      delete phys;
    }
  tile_manager->rebuild();
}

// Remove all but one ball.
//
void World::balls_remove()
{
  cuda_at_balls_change();
  PStack<Phys*> survivors;
  bool ball_found = false;
  while ( physs.occ() )
    {
      Phys* const phys = physs.pop();
      const bool is_ball = phys->phys_type == PT_Ball;
      if ( !ball_found || !is_ball )
        {
          survivors += phys;
          ball_found = ball_found || is_ball;
        }
      else
        {
          delete phys;
        }
    }
  while ( survivors.occ() ) physs += survivors;
}

void World::phys_stop()
{
  cuda_data_to_cpu(DL_ALL);
  data_location = DL_ALL_CPU;
  for ( Phys *phys; phys_live_iterate(phys); ) phys->stop();
}
void World::phys_rot_stop()
{
  cuda_data_to_cpu(DL_ALL);
  data_location = DL_ALL_CPU;
  for ( Phys *phys; phys_live_iterate(phys); )
    phys->omega = pVect(0,0,0);
}

const int colors_mask = 0xf;
const pColor* const colors[colors_mask+1] =
  { &color_lsu_spirit_gold, &color_lsu_spirit_purple, &color_green, &color_blue,
    &color_red, &color_cyan, &color_light_gray, &color_dark_gray,
    &color_orange, &color_spring_green, &color_dark_violet, &color_salmon,
    &color_burlywood, &color_cornsilk, &color_sky_blue, &color_deep_pink };


void
World::balls_add(float contact_y_max)
{
  ball_countdown -= delta_t;
  const double rad_min = 0.4;

  /// If dripping is on, release a new ball if last one hit something.
  //
  if ( opt_drip && ( !dball || dball->collision ) )
    {
      if ( !sphere_empty(drip_location,opt_ball_radius) ) return;
      const float rad = 4*max(rad_min,opt_ball_radius * pow(drand48(),2));

      if ( opt_drop_boxes )
        {
          const float wid = 4*max(rad_min,opt_ball_radius * pow(drand48(),2));
          const float ht = 4*max(rad_min,opt_ball_radius * pow(drand48(),2));
          pCoor pos = drip_location + pVect(0,rad,-0.5*ht);
          pColor color = *colors[ ( drip_cnt >> drip_run ) & colors_mask ];
          pVect size(rad,wid,ht);
          dball = box_manager->new_box(pos,size,color);
        }
      else
        {
          Ball* const b = new Ball(this);
          b->position = drip_location;
          b->set_radius(rad/2);
          dball = b;
          physs += dball;
        }

      dball->color = *colors[ ( drip_cnt >> drip_run ) & colors_mask ];
      dball->velocity = pVect(0,0,0);
      drip_cnt++;
      ball_countdown = 0.5;
    }

  /// If spray is on, release a new ball if it's time.
  //
  if ( opt_spray_on && ball_countdown <= 0 || physs.occ() == 0 )
    {
      const double min_radius = 0.8;
      const double max_rad = 2 * opt_ball_radius;
      const double dr = max_rad - min_radius;
      const double radius = min_radius + dr * pow(drand48(),3);
      const double r = 10;
      const double delta_theta = 0.001 + asin(radius/r);
      static double th = 0;
      th += delta_theta;
      pCoor position
        ( platform_xmax - r - 2 * opt_ball_radius + (r+max_rad) * cos(th),
          20.0 + 3 * max_rad,
          (r+max_rad) * sin(th) );

      th += delta_theta;

      if ( !sphere_empty(position,radius) ) return;

      pColor color = *colors[ ( spray_cnt>>spray_run ) & colors_mask ];

      if ( opt_drop_boxes )
        {
          const float wid = max(3*min_radius,3*radius * drand48());
          const float ht = max(3*min_radius,3*radius * drand48());
          pVect size(3*radius,wid,ht);
          box_manager->new_box(position,size,color);
        }
      else
        {
          Ball* const b = new Ball(this);
          b->position = position;
          b->set_radius(radius);
          b->color = color;
          physs += b;
        }

      spray_cnt++;
      ball_countdown = 0.1;
    }
}

bool
World::sphere_empty(pCoor center, float radius)
{
  // Determine if volume of space is ball-free within radius of center.
  //
  for ( Phys_Iterator phys(physs); phys; phys++ )
    if ( Ball* const ball = BALL(phys) )
      {
        const double radii = radius + ball->radius;
        pNorm dist(ball->position,center);
        if ( dist.mag_sq <= radii * radii ) return false;
      }
  return true;
}

void
World::time_step_cpu()
{
  const float deep = -100;

  if ( data_location & DL_ALL_CUDA )
    {
      pt_sched_waitfor();
      cuda_data_to_cpu(DL_ALL);
      data_location = DL_ALL_CPU;
    }

  /// Remove balls that have fallen away from the platform.
  //
  for ( Phys *phys; phys_live_iterate(phys); )
    if ( phys->position.y < deep ) { physs.iterate_yank(); delete phys; }

  for ( Phys *phys; phys_live_iterate(phys); )
    {
      phys->contact_count = 0;
      phys->collision = false;
      phys->prev_omega = phys->omega;
      phys->prev_velocity = phys->velocity;
    }

  /// Apply gravitational force.
  //
  for ( Phys *p; phys_live_iterate(p); ) p->velocity += gravity_accel_dt;

  /// Sort balls in z in preparation for finding balls that touch.
  //
  phys_zsort.reset();
  for ( Phys *phys; physs.iterate(phys); )
    phys_zsort.insert(phys->max_z_get(0),phys);
  phys_zsort.sort();

  sects.reset();

  PStack<Tact_Box_Box> cpairs;

  /// Apply forces for objects that are touching.
  //
  for ( int idx9 = 1; idx9 < phys_zsort.occ(); idx9++ )
    {
      Phys* const prop9 = phys_zsort[idx9];
      const float z_min = prop9->min_z_get(0);
      Ball* const ball9 = BALL(prop9);
      Box* const box9 = BOX(prop9);

      for ( int idx8 = idx9 - 1;
            idx8 >= 0 && phys_zsort.get_key(idx8) >= z_min;
            idx8-- )
        {
          Phys* const prop8 = phys_zsort[idx8];

          if ( prop8->read_only && prop9->read_only ) continue;

          Ball* const ball8 = BALL(prop8);
          Box*  const box8 = BOX(prop8);

          if ( box8 && box9 )
            {
              SectTT sect = 
                box_box_interpenetrate
                (box8, box9, opt_outline_intersection ? &sects : NULL );
              if ( !sect.exists ) continue;
              Tact_Box_Box* const cpair = cpairs.pushi();
              cpair->box1 = box8; cpair->box2 = box9;
              cpair->sect = sect;
              if ( opt_outline_intersection ) sects += cpair->sect;
              penetration_boxes_resolve_force(cpair);
              continue;
            }

          if ( ( box8 || box9 ) && ( ball8 || ball9 ) )
            {
              Box* const box = ball8 ? BOX(prop9) : BOX(prop8);
              Ball* const ball = ball8 ? ball8 : ball9;
              penetration_box_ball_resolve(box,ball);
              continue;
            }

          if ( ball8 && ball9 )
            {
              penetration_balls_resolve(ball8,ball9);
              continue;
            }
          if ( !ball8 && !ball9 ) continue;
          Tile* const tile = ball8 ? TILE(prop9) : TILE(prop8);
          Ball* const ball = ball8 ? ball8 : ball9;
          pCoor tact_pos;
          pNorm tact_dir;
          if ( !tile_sphere_intersect
               (tile,ball->position,ball->radius,tact_pos,tact_dir) ) continue;
          pball->position = tact_pos + pball->radius * tact_dir;
          pball->omega = pVect(0,0,0);
          pball->velocity = pVect(0,0,0);
          pVect vbefore = ball->velocity;
          penetration_balls_resolve(ball,pball,false);
          pVect delta_mo = ball->mass * ( ball->velocity - vbefore );
        }
    }

  /// Apply force for platform contact to boxes.
  //
  for ( Box *box; boxes_iterate(box); )
    {
      if ( box->position.y - box->radius >= 0 ) continue;
      if ( box->position.z + box->radius <= platform_zmin ) continue;
      if ( box->position.z - box->radius >= platform_zmax ) continue;
      pCoor axis(platform_xmid,0,box->position.z);
      pVect btoa(box->position,axis);
      if ( btoa.mag_sq() < SQ(platform_xrad-box->radius) ) continue;
      int inside = 0;
      PStack<int> ou;
      float pen_dists[8];
      PStack<SectTT> psects;
      float min_pd = 0;  // For vertices between ends.
      float max_pd = 0;

      // Find vertices that are under the platform.
      //
      for ( int v=0; v<8; v++ )
        {
          const int v_bit = 1 << v;
          pCoor pos = box->vertices[v];
          if ( pos.y > 0 ) { pen_dists[v] = 0; continue; }
          pCoor axis(platform_xmid,0,pos.z);
          pNorm tact_dir(axis,pos);
          const float pen_dist = tact_dir.magnitude - platform_xrad;
          pen_dists[v] = pen_dist;
          if ( pos.z < platform_zmin || pos.z > platform_zmax )
            {
              if ( pen_dist > 0 ) ou += v; 
              continue;
            }
          set_min(min_pd,pen_dist);
          set_max(max_pd,pen_dist);
          if ( pen_dist > 1 ) continue;
          inside |= v_bit;
          if ( pen_dist <= 0 ) continue;
          SectTT* const sect = psects.pushi();
          sect->start = pos;
          sect->dir = tact_dir;
          sect->t_start = pen_dist;
        }

      const bool object_inside = max_pd < -min_pd;
      if ( !object_inside ) continue;

      // Examine vertices that are off the edge of the platform (in the
      // z direction), to see if an adjoining edge intersects the platform
      // edge.
      //
      while ( int* const v_ptr = ou.iterate() )
        {
          const int v = *v_ptr;
          // Outside Vertex (beyond z_max or z_min).
          //
          pCoor pos = box->vertices[v];
          const float pen_dist_out = pen_dists[v];
          const float v_z = pos.z;
          const float ref_z =
            v_z >= platform_zmax ? platform_zmax : platform_zmin;
          const float outside_z_len = fabs(v_z - ref_z);

          // Look for adjoining vertices that are over the platform.
          //
          for ( int axis = 0; axis < 3; axis++ )
            {
              const int vn = v ^ ( 1 << axis );
              const int vn_bit = 1 << vn;
              if ( ! ( inside & vn_bit ) ) continue;
              const float pen_len = pen_dists[vn] - pen_dist_out;
              // Inside Vertex
              pCoor pos_in = box->vertices[vn];

              // Compute the contact point at penetration distance.
              //
              const float z_len = fabs(v_z - pos_in.z);
              if ( z_len < 0.0001 ) continue;
              const float scale = outside_z_len / z_len;
              pVect to_inside(pos,pos_in);
              pCoor tact = pos + scale * to_inside;
              const float pen_tact = pen_dist_out + scale * pen_len;
              if ( pen_tact <= 0 ) continue;
              SectTT* const sect = psects.pushi();
              sect->start = tact;
              sect->t_start = pen_tact;
              pNorm dir = cross(to_inside,pVect(-tact.y,tact.x,0));
              sect->dir = pen_len >= 0 ? pNorm(tact.x,tact.y,0) : dir;
            }
        }

      while ( SectTT* const sect = psects.iterate() )
        {
          pCoor pos = sect->start;
          pVect tact_dir = sect->dir;
          pNorm ctopos(box->position,pos);
          pVect vel = box->get_vel(pos);
          const float pen_dist = sect->t_start;
          const float rad_vel = dot(vel,tact_dir);
          const double loss_factor = 1 - opt_bounce_loss;
          const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
          const float max_fdt_in = rad_vel * box->mass;
          const float appr_force_dt = rad_vel > 0
            ? min(max_fdt_in,force_dt_no_loss) : force_dt_no_loss * loss_factor;
          box->apply_force_dt(pos, - appr_force_dt * tact_dir );
        }

      while ( SectTT* const sect = psects.iterate() )
        {
          pCoor pos = sect->start;
          pVect tact_dir = sect->dir;
          const float pen_dist = sect->t_start;
          const float force_dt_no_loss = elasticity_inv_dt * pen_dist;
          pVect vel2 = box->get_vel(pos);
          const float rad_vel2 = dot(vel2,tact_dir);
          pNorm tan_vel = vel2 - rad_vel2 * tact_dir;
          const float mi_inv = box->get_moment_of_inertia_inv(pos,tan_vel);
          const float fdt_limit = 
            tan_vel.magnitude / ( box->mass_inv + mi_inv );
          const float fric_force_dt_no_loss =
            force_dt_no_loss * opt_friction_coeff;
          const float fric_force_dt = min(fdt_limit, fric_force_dt_no_loss);
          box->apply_force_fric_dt(pos, tan_vel, -fric_force_dt);
          box->contact_count++;
        }
    }

  /// Apply force for platform contact.
  //
  for ( Ball *ball; balls_iterate(ball); )
    {
      const pCoor pos(ball->position);
      if ( !platform_collision_possible(ball) ) continue;
      pCoor axis(platform_xmid,0,pos.z);

      // Test for different ways ball can touch platform. If contact
      // is found find position of an artificial platform ball (pball)
      // that touches the real ball at the same place and angle as
      // the platform. This pball will be used for the ball-ball penetration
      // routine, penetration_balls_resolve.

      if ( pos.y > 0 )
        {
          // Possible contact with upper edge of platform.
          //
          pCoor tact
            (pos.x > platform_xmid ? platform_xmax : platform_xmin, 0, pos.z);
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= ball->radius_sq ) continue;
          pball->position = tact + pball->radius * tact_dir;
        }
      else if ( pos.z > platform_zmax || pos.z < platform_zmin )
        {
          // Possible contact with side (curved) edges of platform.
          //
          pNorm ball_dir(axis,pos);
          if ( ball_dir.mag_sq <= ball->short_xrad_sq ) continue;
          const float zedge =
            pos.z > platform_zmax ? platform_zmax : platform_zmin;
          pCoor axis_edge(platform_xmid,0,zedge);
          pCoor tact = axis_edge + platform_xrad * ball_dir;
          pNorm tact_dir(pos,tact);
          if ( tact_dir.mag_sq >= ball->radius_sq ) continue;
          pball->position = tact + pball->radius * tact_dir;
        }
      else
        {
          // Possible contact with surface of platform.
          //
          pNorm tact_dir(axis,pos);
          if ( tact_dir.mag_sq <= ball->short_xrad_sq
               || tact_dir.mag_sq >= ball->long_xrad_sq ) continue;

          pball->position = axis +
            ( platform_xrad
              + ( tact_dir.magnitude < platform_xrad
                  ? pball->radius : -pball->radius ) )
            * tact_dir;
        }

      // Finish initializing platform ball, and call routine to
      // resolve penetration.
      //
      pball->omega = pVect(0,0,0);
      pball->velocity = pVect(0,0,0);
      penetration_balls_resolve(ball,pball,false);
    }

  PSList<Tact_Box_Box*> cpairr;
  while ( Tact_Box_Box* const cpair = cpairs.iterate() )
    cpairr.insert(cpair->box1->position.y,cpair);
  while ( Tact_Box_Box* const cpair = cpairr.iterate() )
    {
      penetration_boxes_resolve_fric(cpair);
    }

  /// Based on updated velocity, update physical object positions.
  //
  for ( Phys *phys; phys_live_iterate(phys); )
    phys->position += delta_t * ( phys->velocity );
    //  phys->position += delta_th * ( phys->prev_velocity + phys->velocity );

  float contact_y_max = -platform_xrad;

  /// Update orientation of balls. (Also find highest ball that hit something.)
  //
  for ( Phys *phys; phys_live_iterate(phys); )
    {
      if ( phys->read_only ) continue;
      pNorm axis(phys->omega);

      // Update phys orientation if it is spinning fast enough.
      //
      if ( axis.mag_sq > 0.000001 )
        phys->orientation =
          pQuat(axis,delta_t * axis.magnitude) * phys->orientation;

      phys->geometry_update();

      if ( phys->contact_count )
        phys->collision = true;

      // Find position of highest phys that has hit something.
      //
      if ( phys->collision && phys->position.y > contact_y_max )
        contact_y_max = phys->position.y;
    }

  balls_add(contact_y_max);
}

void
World::time_step_cuda(int iter, int iters_per_frame)
{
  /// Advance physical state by one time step using CUDA for computation.

  const bool just_before_render = iter + 1 == iters_per_frame;

  cuda_init();
  const int ball_cnt = physs.occ();

  const int plat_block_size_1pmp =
    max(32,int(ceil(double(ball_cnt) / cuda_prop.multiProcessorCount)));
  const int plat_block_size =
    min(plat_block_size_1pmp, cfa_platform.maxThreadsPerBlock);

  // Set configuration for platform pass.
  //
  dim_grid.x = int(ceil(double(ball_cnt)/plat_block_size));
  dim_grid.y = dim_grid.z = 1;
  dim_block.x = plat_block_size;
  dim_block.y = dim_block.z = 1;

  // If necessary, command scheduler thread to start working on a schedule.
  // We rather do this at the end of the routine because if we do it
  // here we are forced to wait.
  //
  if ( !pt_sched_data_pending && cuda_schedule_stale > 0 )
    pt_sched_start();

  bool fresh = false;

  // If a freshly computed schedule is waiting, send it to CUDA.
  //
  if ( pt_sched_data_pending )
    {
      pt_sched_waitfor();
      { PStack<Pass>* const x = passes_curr;
        passes_curr = passes_next; passes_next = x; }
      if ( opt_color_events )
        for ( Ball *b; balls_iterate(b); )
          b->color_event =
            b->color_block >= 0 ? *colors[b->color_block & colors_mask] : dark;
      block_balls_needed.ptrs_to_cuda("block_balls_needed");
      block_balls_needed.to_cuda();
      cuda_tacts_schedule.ptrs_to_cuda("tacts_schedule");
      cuda_tacts_schedule.to_cuda();
      xx_pairs.ptrs_to_cuda("xx_pairs");
      xx_pairs.to_cuda();
      xx_sects_dir.ptrs_to_cuda("xx_sects_dir");
      xx_sects_debug.ptrs_to_cuda("xx_sects_debug");
      xx_sects_center.ptrs_to_cuda("xx_sects_center");
      pt_sched_data_pending = false;
      cuda_schedule_stale = -schedule_lifetime_steps;
      fresh = true;
    }

  cuda_schedule_stale++;

  // Make copy of ball structures for debugging.
  //  Ball ball_a = *ball_first();

  if ( passes_curr->occ() ) block_count_prev = passes_curr[0][0].dim_grid.x;

  // Start timer. (Used for code tuning.)
  //
  CE(cudaEventRecord(frame_start_ce,0));

  cpu_data_to_cuda();
  data_location = DL_ALL_CUDA;

  CE(cudaEventRecord(xx_pairs_start_ce,0));

  if ( xx_pairs_count )
    {
      dim3 db_xx_pairs, dg_xx_pairs;
      const int xx_blk_lg = 8;
      db_xx_pairs.x = 1 << xx_blk_lg;
      const int thds_per_bb_lg = 4;
      dg_xx_pairs.x =
        ( xx_pairs_count >> ( xx_blk_lg - thds_per_bb_lg ) )
        + ( ( xx_pairs_count & 0xff ) > 0 );
      db_xx_pairs.y = db_xx_pairs.z = dg_xx_pairs.y = dg_xx_pairs.z = 1;

      pass_xx_intersect_launch(dg_xx_pairs, db_xx_pairs, xx_pairs_count);
      CE(cudaGetLastError());

#ifdef XX_DEBUG
      // For debugging

      if ( fresh )
        {
          xx_sects_center.from_cuda();
          xx_sects_dir.from_cuda();
          xx_sects_debug.from_cuda();

          for ( int i=0; i<xx_pairs_count; i++ )
            {
              SectTT sect = xx_pairs_debug[i];
              const int idx = xx_pairs[i].z;
              Box* const box1 = BOX(physs[xx_pairs[i].x]);
              Box* const box2 = BOX(physs[xx_pairs[i].y]);
              const float cpu_vol = sect.exists ? sect.t_start : 0.0f;
              const float4 db = xx_sects_debug[idx];
              const float gpu_vol =
                xx_sects_dir[idx].w ? xx_sects_center[idx].w : 0;
              const float gpu_area = db.w;
              const float cpu_area = sect.exists ? sect.t_end : 0;
              const float delta_vol = fabs(cpu_vol-gpu_vol);
              const float delta_area = fabs(gpu_area - cpu_area);
              SectTT sect2 = box_box_intersect(box1,box2,NULL);
              ASSERTS( db.y > 0 || db.z == 0 );
              ASSERTS( delta_vol < 0.1 );
              // ASSERTS( !sect.exists || cpu_vol < 0.1 || delta_area < 1.0 );
            }
        }
#endif
    }

  CE(cudaEventRecord(pairs_start_ce,0));

  // Launch the contact pair kernel for as many passes as needed.
  //
  while ( Pass* const p = passes_curr->iterate() )
    pass_pairs_launch
      (p->dim_grid,p->dim_block,
       p->prefetch_offset,p->schedule_offset,p->round_cnt,
       p->balls_per_thread_max,p->balls_per_block_max,FT_NonFriction);

  while ( Pass* const p = passes_curr->iterate() )
    pass_pairs_launch
      (p->dim_grid,p->dim_block,
       p->prefetch_offset,p->schedule_offset,p->round_cnt,
       p->balls_per_thread_max,p->balls_per_block_max,FT_Friction);

  CE(cudaGetLastError());
  CE(cudaEventRecord(pairs_stop_ce,0));

  // Launch the platform kernel.
  //
  pass_platform_launch(dim_grid,dim_block,physs.occ());

  CE(cudaEventRecord(platform_stop_ce,0));

  // If data is needed to render a frame, copy from CUDA to CPU.
  //
  if ( just_before_render )
    cuda_data_to_cpu(DL_ALL);

  // Stop timer.
  CE(cudaEventRecord(frame_stop_ce,0));
  if ( opt_debug || just_before_render )
    {
      CE(cudaEventSynchronize(frame_stop_ce));
      float cuda_time = -1.1;
      CE(cudaEventElapsedTime(&cuda_time,frame_start_ce,frame_stop_ce));
      frame_timer.cuda_frame_time_set(cuda_time);
      CE(cudaEventElapsedTime(&cuda_time,xx_pairs_start_ce,pairs_start_ce));
      xx_pairs_cumulative += cuda_time;
      CE(cudaEventElapsedTime(&cuda_time,pairs_start_ce,pairs_stop_ce));
      pairs_cumulative += cuda_time; 
      CE(cudaEventElapsedTime(&cuda_time,pairs_stop_ce,platform_stop_ce));
      platform_cumulative += cuda_time;
      pairs_cumulative_count++;
      pError_Check();
    }
  // Copy an "after" ball, for hand debugging.
  //  Ball ball_b = *ball_first();

  // Sanity Check: Make sure CUDA ran penetration_balls_resolve enough times.
  //
  if ( data_location & DL_OT_CPU )
    for ( Phys *phys; physs.iterate(phys); )
      {
        Ball* const ball = BALL(phys);
        Box* const box = BOX(phys);
        Tile* const tile = TILE(phys);
        ASSERTS( ball || tile || box );
        // Number of other props to check for collision with.
        const int px = phys->proximity.occ();

        // Number of times CUDA code checked for a collision.
        const int ca = phys->debug_pair_calls >> 16;
        ASSERTS( phys->read_only || px == ca ); // Fatal error if not equal.
      }

  // Update counter used for shower spray.
  //
  ball_countdown -= delta_t;

  if ( ! ( data_location & DL_CV_CPU ) ) return;

  if ( !just_before_render ) return;

  float contact_y_max = -platform_xrad;

  for ( Phys *phys; phys_live_iterate(phys); )
    if ( phys->collision ) set_max(contact_y_max,phys->position.y);

  balls_add(contact_y_max);

  const float deep = -100;
  for ( Phys *phys; phys_live_iterate(phys); )
    if ( phys->position.y < deep )
      {
        cuda_at_balls_change();
        physs.iterate_yank(); delete phys;
      }

  if ( just_before_render && cuda_schedule_stale + iters_per_frame - 1 > 0 )
    {
      pt_sched_start();
    }
}

// Return a sphere with a detail level appropriate for the ball's distance
// from the viewer's eye.
//
Sphere*
World::sphere_get(Ball *ball)
{
  if ( opt_fixed_lod >= 0 ) return &spheres[opt_fixed_lod];
  const float dist =
    ball->radius_inv * ( distance(ball->position,eye_location) - 1 );
  const int lod_raw =
    int( 0.99 + sphere_lod_factor / dist - sphere_lod_offset );
  const int lod = max(min(lod_raw,sphere_count-1),0);
  return &spheres[lod];
}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const float move_amt = 0.4;

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -move_amt; break;
  case FB_KEY_RIGHT: adjustment.x = move_amt; break;
  case FB_KEY_PAGE_UP: adjustment.y = move_amt; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -move_amt; break;
  case FB_KEY_DOWN: adjustment.z = move_amt; break;
  case FB_KEY_UP: adjustment.z = -move_amt; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case FB_KEY_F4: opt_cuda_prox = !opt_cuda_prox; break;
  case FB_KEY_F8:
    {
      opt_elasticity = 10;
      opt_friction_roll = 300;
      opt_friction_coeff = 0.0001;
      break;
    }
  case '0': setup_debug(); break;
  case '1': setup_brick_wall(-5); break;
  case '!': setup_brick_wall(20); break;
  case '2': setup_tower(8,40,false); break;
  case '3': setup_tower(20,10,true); break;
  case '4': setup_staircase(); break;
  case '5': setup_house_of_cards(); break;
  case 'a':
    if ( opt_physics_method == GP_cuda ) cuda_at_balls_change();
    opt_physics_method++;
    if ( opt_physics_method > GP_cuda ) opt_physics_method = GP_cpu;
    break;
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'c': case 'C': opt_color_events = !opt_color_events; break;
  case 'd': opt_drip = !opt_drip; if(!opt_drip)dball=NULL; break;
  case 'D': opt_move_item = MI_Drip; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'i': opt_info = true; break;
  case 'j': opt_drop_boxes = !opt_drop_boxes; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'm': opt_mirror = !opt_mirror; break;
  case 'M': opt_mirror_method++;
    if ( opt_mirror_method == 4 ) opt_mirror_method = 0;
    break;
  case 'n': case 'N': opt_normals_visible = !opt_normals_visible; break;
  case 'o': opt_outline_intersection = !opt_outline_intersection; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'q': opt_debug = !opt_debug; break;
  case 'Q': opt_debug2 = !opt_debug2; break;
  case 'R': balls_remove(); break;
  case 's': phys_stop(); break;
  case 'S': phys_rot_stop(); break;
  case 'T': benchmark_setup(1); break;
  case 't': benchmark_setup(15); break;
  case 'v': opt_verify = !opt_verify; break;
  case 'w': opt_shadows = !opt_shadows; break;
  case 'W': opt_shadow_volumes = !opt_shadow_volumes; break;
  case 'x': opt_spray_on = !opt_spray_on; break;
  case 'X':
    {
      Ball* const b1 = new Ball(this);
      b1->position = pCoor(30,22,20);
      b1->velocity = pVect(0,0,0);
      b1->color = color_lsu_spirit_purple;
      physs += b1;
      Ball* const b2 = new Ball(this);
      b2->position = b1->position;
      b2->position.z += 4 * opt_ball_radius;
      b2->velocity = pVect(0,0,0);
      b2->color = color_lsu_spirit_gold;
      physs += b2;
    }
    break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  variables_update();

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(eye_direction,pVect(0,0,-1));
      user_rot_axis *= invert(rotall);
      eye_direction *= pMatrix_Rotation(user_rot_axis, M_PI * 0.03);
      modelview_update();
    }

  // Update object location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      if ( opt_move_item == MI_Eye )
        adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Ball: case MI_Ball_V:
        cuda_data_to_cpu(DL_ALL);  data_location = DL_ALL_CPU;
        break;  
      default: break;
      }

      switch ( opt_move_item ){
      case MI_Ball: phys_last()->translate(adjustment); break;
      case MI_Ball_V: phys_last()->push(adjustment); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      case MI_Drip: drip_location += adjustment; break;
      default: break;
      }
      modelview_update();
    }
}


int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.render_w,&world);
}
