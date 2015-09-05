/// LSU EE 4702-1 (Fall 2015), GPU Programming
//
 /// Homework 1
 //
 /// Your Name:

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2015/hw01.pdf


/// Purpose
//
//   Demonstrate simulation of point masses connected by springs.


/// What Code Does

// Simulates balls connected by springs over a platform. Balls and
// springs can be initialized in different arrangements (called
// scenes). Currently scene 1 is a simple string of beads, and scenes
// 2, 3, and 4 are trusses. The platform consists of tiles, some are
// purple-tinted mirrors (showing a reflection of the ball), the
// others show the course syllabus.



///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //        Move object or push ball, depending on mode.
 //        With shift key pressed, motion is 5x faster.
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move head (first) ball. (Change position but not velocity.)
 //   'B': Push head ball. (Add velocity.)
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
 //  'w'    Twirl balls around axis formed by head and tail. (Prob 2 soln).
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
 //  '3'    Set up scene 3.
 //  'p'    Pause simulation. (Press again to resume.)
 //  ' '    (Space bar.) Advance simulation by 1/30 second.
 //  'S- '  (Shift-space bar.) Advance simulation by one time step.
 //  'h'    Freeze position of first (head) ball. (Press again to release.)
 //  't'    Freeze position of last (tail) ball. (Press again to release.)
 //  's'    Stop balls.
 //  'g'    Turn gravity on and off.
 //  'y'    Toggle value of opt_tryout1. Intended for experiments and debugging.
 //  'Y'    Toggle value of opt_tryout2. Intended for experiments and debugging.
 //  'F11'  Change size of green text (in upper left).
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
 //  VAR Spring Constant - Set spring constant.
 //  VAR Time Step Duration - Set physics time step.
 //  VAR Air Resistance - Set air resistance.
 //  VAR Light Intensity - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)


#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/glextfuncs.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include <gp/colors.h>

#include "util-containers.h"
#include "shapes.h"


///
/// Main Data Structures
///
//
// class World: All data about scene.


class World;


// Object Holding Ball State
//
class Ball {
public:
  Ball():velocity(pVect(0,0,0)),locked(false),
         color(color_lsu_spirit_gold),contact(false){};
  pCoor position;
  pVect velocity;

  float mass;
  float mass_min; // Mass below which simulation is unstable.
  float radius;

  bool locked;

  pVect force;
  pColor color;
  bool contact;                 // When true, ball rendered in gray.
  float spring_constant_sum;    // Used to compute minimum mass.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

class Link {
public:
  Link(Ball *b1, Ball *b2):ball1(b1),ball2(b2),
     distance_relaxed(pDistance(b1->position,b2->position)),
     color(color_lsu_spirit_purple){}
  Link(Ball *b1, Ball *b2, pColor colorp):ball1(b1),ball2(b2),
     distance_relaxed(pDistance(b1->position,b2->position)),
     color(colorp){}
  Ball* const ball1;
  Ball* const ball2;
  float distance_relaxed;
  pColor color;
};

// Declare containers and iterators for Balls and Links.
// (See util_container.h.)
//
typedef pVectorI<Link> Links;
typedef pVectorI_Iter<Link> LIter;
typedef pVectorI<Ball> Balls;
typedef pVectorI_Iter<Ball> BIter;

struct Truss_Info {

  // See make_truss for a description of what the members are fore.

  // Inputs
  PStack<pCoor> base_coors;  // Coordinates of first set of balls.
  pVect unit_length;
  int num_units;

  // Output
  Balls balls;
  Links links;
};

#include "hw01-graphics.cc"


void
World::init()
{
  chain_length = 14;

  opt_time_step_duration = 0.0003;
  variable_control.insert(opt_time_step_duration,"Time Step Duration");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 15000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.04;
  variable_control.insert(opt_air_resistance,"Air Resistance");

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  init_graphics();

  ball_setup_1();
  lock_update();
}

Ball*
World::make_marker(pCoor position, pColor color)
{
  Ball* const ball = new Ball;
  ball->position = position;
  ball->locked = true;
  ball->velocity = pVect(0,0,0);
  ball->radius = 0.2;
  ball->mass = 0;
  ball->contact = false;
  ball->color = color;
  return ball;
}

void
World::lock_update()
{
  // This routine called when options like opt_head_lock might have
  // changed.

  // Update locked status.
  //
  if ( head_ball ) head_ball->locked = opt_head_lock;
  if ( tail_ball ) tail_ball->locked = opt_tail_lock;

  // Re-compute minimum mass needed for stability.
  //
  for ( BIter ball(balls); ball; ) ball->spring_constant_sum = 0; 
  const double dtis = pow( opt_time_step_duration, 2 );
  for ( LIter link(links); link; )
    {
      Ball* const b1 = link->ball1;
      Ball* const b2 = link->ball2;
      b1->spring_constant_sum += opt_spring_constant;
      b2->spring_constant_sum += opt_spring_constant;
    }
  for ( BIter ball(balls); ball; )
    ball->mass_min = ball->spring_constant_sum * dtis;
}


///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

void
World::ball_setup_1()
{
  // Arrange and size balls to form a pendulum.

  pCoor first_pos(13.4,17.8,-9.2);
  pVect delta_pos = pVect(distance_relaxed,0,0);

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  balls.erase();
  links.erase();

  for ( int i=0; i<chain_length; i++ )
    {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = balls += new Ball;

      // Initialize position and other information.
      //
      ball->position = first_pos + i * delta_pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;

      // If it's not the first ball link it to the previous ball.
      if ( i > 0 ) links += new Link( ball, balls[i-1] );
    }

  // The balls pointed to by head_ball and tail_ball can be manipulated
  // using the user interface (by pressing 'h' or 't', for example).
  // Set these variables.
  //
  head_ball = balls[0];
  tail_ball = balls[balls-1];

  opt_head_lock = true;    // Head ball will be frozen in space.
  opt_tail_lock = false;   // Tail ball can move freely.
}


void
World::make_truss(Truss_Info *truss_info)
{
  /// Construct a truss based on members of truss_info.
  //

  //            <---- num_units (=9) ----------->
  //  j          
  //  0         O---O---O---O---O---O---O---O---O     ^
  //            |   |   |   |   |   |   |   |   |     |
  //  1         O---O---O---O---O---O---O---O---O   num_sides (=3)
  //            |   |   |   |   |   |   |   |   |     |
  //  2         O---O---O---O---O---O---O---O---O     v
  //            
  //      i ->  0   1   2   3   4   5   6   7   8          
  //
  //  Note: Not all links are shown in the diagram above.

  /// Truss_Info Inputs
  //
  //  truss_info->num_units
  //    The number of sections in the truss (see diagram above).
  //
  //  truss_info->base_coors
  //    A list containing num_sides coordinates, the coordinates of
  //    balls at i=0 (see diagram above). (num_sides is the number of
  //    elements in this list.)  These coordinates should all be
  //    in the same plane.
  //
  //  truss_info->unit_length
  //    A vector pointing from the ball at (i,j) to the ball at (i+1,j).
  //
  /// Truss_Info Outputs
  //
  //  truss_info->balls
  //    A list that should be filled with the balls making up the truss.
  //
  //  truss_info->links
  //    A list that should be filled with the links making up the truss.


  const int num_sides = truss_info->base_coors.occ();
  const int num_units = truss_info->num_units;

  // Lists to hold balls and links created for truss.
  //
  Balls& bprep = truss_info->balls;
  Links& lprep = truss_info->links;

  // Create balls for truss.
  //
  for ( int i=0; i<num_units; i++ )
    for ( pCoor bcoor; truss_info->base_coors.iterate(bcoor); )
      {
        Ball* const ball = bprep += new Ball;
        ball->position = bcoor + i * truss_info->unit_length;
        ball->locked = false;
        ball->velocity = pVect(0,0,0);
        ball->radius = 0.15;
        ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
        ball->contact = false;
      }

  // Create links.
  //
  for ( int i=0; i<num_units; i++ )
    for ( int j=0; j<num_sides; j++ )
      {
        const int idx = j + num_sides * i;

        // Retrieve the ball corresponding to (i,j).
        //
        Ball* const ball = bprep[idx];

        // Compute the index of the ball at (i, (j-1) mod num_sides ).
        //
        const int pn_idx = idx + ( j == 0 ? num_sides - 1 : -1 );

        // Insert link to neighbor ball with name i.
        //
        lprep += new Link( ball, bprep[pn_idx], color_gray );

        // Insert links to balls with same i that are not neighbors.
        //
        if ( j == i % num_sides )
          for ( int k = 2; k < num_sides-1; k++ )
            lprep += new Link
              ( ball, bprep[ idx + (k+j)%num_sides - j ], color_white );

        if ( i == 0 ) continue;

        // Insert link to ball at (i-1,j).
        //
        lprep +=
          new Link( ball, bprep[idx-num_sides], color_lsu_official_purple );

        // Insert link to ball at (i-1, j-1 mod num_sides ).
        //
        lprep += new Link( ball, bprep[pn_idx-num_sides], color_green );
      }
}


void
World::ball_setup_2()
{
  /// PROBLEM 1

  pCoor head_pos(13,18,-9);
  pCoor tail_pos(8,9,-9);
  pCoor surface_pos(7,13,-6);

  // Set this to false to see the links in color.
  bool gray_links = true;

#define SOLUTION
#ifdef SOLUTION

  /// PUT PROBLEM 1 solution HERE
  //
  //
  //   Modify, remove, or add to code below for solution.

  pCoor top_pos(13.4,17.8,-9.2);
  const float spacing = distance_relaxed;
  pVect delta_unit = pVect(spacing,0,0);
  pNorm loc_y = delta_unit;
  pNorm loc_x = pVect(0,0,1);
  pNorm loc_z = cross(loc_x,loc_y);

#else

  pCoor top_pos(13.4,17.8,-9.2);
  const float spacing = distance_relaxed;
  pVect delta_unit = pVect(spacing,0,0);
  pNorm loc_y = delta_unit;
  pNorm loc_x = pVect(0,0,1);
  pNorm loc_z = cross(loc_x,loc_y);

#endif

  // Erase the existing balls and links.
  //
  balls.erase(); links.erase();

  // See routine World::make_truss for a detailed description.
  Truss_Info truss_info;

  truss_info.num_units = chain_length;
  truss_info.unit_length = delta_unit;

  const int sides = 4;

  for ( int j=0; j<sides; j++ )
    {
      const double angle = double(j)/sides*2*M_PI;
      pCoor chain_first_pos =
        top_pos
        + spacing * cos(angle) * loc_x
        + spacing * sin(angle) * loc_z;

      truss_info.base_coors += chain_first_pos;
    }

  make_truss(&truss_info);

  // Insert links to balls at either end.
  //
  head_ball = balls += new Ball;
  head_ball->position = top_pos - delta_unit;
  for ( int j=0; j<sides; j++ )
    links +=
      new Link( head_ball, truss_info.balls[j], color_chocolate );

  tail_ball = balls += new Ball;
  tail_ball->position = top_pos + chain_length * delta_unit;

  const int bsize = truss_info.balls.size();

  for ( int j=0; j<sides; j++ )
    links +=
      new Link( tail_ball, truss_info.balls[bsize-sides+j], color_chocolate );

  // Initialize the new head and tail balls, which are the only balls
  // currently in list balls (as of this writing).
  //
  for ( BIter ball(balls); ball; )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.15;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  /// Note: At this point the simulation lists only contain head and tail.
  //  Here, insert the balls and links that make_truss created.
  //
  balls += truss_info.balls;
  links += truss_info.links;

  if ( gray_links )
    for ( LIter link(links); link; ) link->color = color_light_gray;

  balls += make_marker(head_pos,color_cyan);
  balls += make_marker(tail_pos,color_cyan);
  balls += make_marker(surface_pos,color_lime_green);

  opt_tail_lock = false;
  opt_head_lock = false;
}


void
World::balls_twirl()
{
  if ( !head_ball || !tail_ball ) return;

  /// PROBLEM 2 solution GOES IN THIS ROUTINE.

  for ( BIter ball(balls); ball; )
    {

      pVect umm(0,0,0); // This, of course, is a placeholder.

      ball->velocity += umm;

    }
}


void
World::ball_setup_3()
{
  /// DO NOT MODIFY THIS ROUTINE FOR HOMEWORK solution

  pCoor first_pos(13.4,17.8,-9.2);
  const float spacing = distance_relaxed;
  pVect delta_pos = pVect(spacing*0.05,-spacing,0);
  pNorm loc_y = delta_pos;
  pNorm loc_x = pVect(0,0,1);
  pNorm loc_z = cross(loc_y,loc_x);

  // Erase the existing balls and links.
  //
  balls.erase(); links.erase();

  Truss_Info truss_info;

  truss_info.num_units = chain_length;
  truss_info.unit_length = delta_pos;

  const int sides = 4;

  for ( int j=0; j<sides; j++ )
    {
      const double angle = double(j)/sides*2*M_PI;
      pCoor chain_first_pos =
        first_pos
        + 0.5 * spacing * cos(angle) * loc_x
        + 0.5 * spacing * sin(angle) * loc_z;

      truss_info.base_coors += chain_first_pos;
    }

  make_truss(&truss_info);

  // Insert links to balls at either end.
  //
  head_ball = balls += new Ball;
  head_ball->position = first_pos - delta_pos;
  for ( int j=0; j<sides; j++ )
    links += new Link( head_ball, truss_info.balls[j], color_chocolate );

  tail_ball = balls += new Ball;
  tail_ball->position = first_pos + chain_length * delta_pos;

  const int bsize = truss_info.balls.size();

  for ( int j=0; j<sides; j++ )
    links += new Link( tail_ball, truss_info.balls[bsize-sides+j],
                       color_chocolate );

  for ( BIter ball(balls); ball; )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.15;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  balls += truss_info.balls;
  links += truss_info.links;

  opt_tail_lock = false;
  opt_head_lock = false;
}

void
World::ball_setup_4()
{
  /// PROBLEM 3: Modify this routine.

  pCoor first_pos(13.4,17.8,-9.2);
  const float spacing = distance_relaxed;
  pVect delta_pos = pVect(spacing*0.05,-spacing,0);
  pNorm loc_y = delta_pos;
  pNorm loc_x = pVect(0,0,1);
  pNorm loc_z = cross(loc_y,loc_x);

  // Erase the existing balls and links.
  //
  balls.erase(); links.erase();

  Truss_Info truss_info;

  truss_info.num_units = chain_length;
  truss_info.unit_length = delta_pos;

  const int sides = 4;

  for ( int j=0; j<sides; j++ )
    {
      const double angle = double(j)/sides*2*M_PI;
      pCoor chain_first_pos =
        first_pos
        + 0.5 * spacing * cos(angle) * loc_x
        + 0.5 * spacing * sin(angle) * loc_z;

      truss_info.base_coors += chain_first_pos;
    }

  make_truss(&truss_info);

  // Insert links to balls at either end.
  //
  head_ball = balls += new Ball;
  head_ball->position = first_pos - delta_pos;
  for ( int j=0; j<sides; j++ )
    links += new Link( head_ball, truss_info.balls[j], color_chocolate );

  tail_ball = balls += new Ball;
  tail_ball->position = first_pos + chain_length * delta_pos;

  const int bsize = truss_info.balls.size();

  for ( int j=0; j<sides; j++ )
    links += new Link( tail_ball, truss_info.balls[bsize-sides+j],
                       color_chocolate );

  for ( BIter ball(balls); ball; )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.15;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  balls += truss_info.balls;
  links += truss_info.links;

  opt_tail_lock = false;
  opt_head_lock = false;
}


void
World::ball_setup_5()
{
}


 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu(double delta_t)
{
  time_step_count++;

  for ( BIter ball(balls); ball; )
    ball->force = ball->mass * gravity_accel;

  for ( LIter link(links); link; )
    {
      // Spring Force from Neighbor Balls
      //
      Ball* const ball1 = link->ball1;
      Ball* const ball2 = link->ball2;

      // Construct a normalized (Unit) Vector from ball to neighbor.
      //
      pNorm ball_to_neighbor(ball1->position,ball2->position);

      const float distance_between_balls = ball_to_neighbor.magnitude;

      // Compute the speed of ball towards neighbor_ball.
      //
      pVect delta_v = ball2->velocity - ball1->velocity;
      float delta_s = dot( delta_v, ball_to_neighbor );

      // Compute by how much the spring is stretched (positive value)
      // or compressed (negative value).
      //
      const float spring_stretch =
        distance_between_balls - link->distance_relaxed;

      // Determine whether spring is gaining energy (whether its length
      // is getting further from its relaxed length).
      //
      const bool gaining_e = ( delta_s > 0.0 ) == ( spring_stretch > 0 );

      // Use a smaller spring constant when spring is loosing energy,
      // a quick and dirty way of simulating energy loss due to spring
      // friction.
      //
      const float spring_constant =
        gaining_e ? opt_spring_constant : opt_spring_constant * 0.7;

      ball1->force += spring_constant * spring_stretch * ball_to_neighbor;
      ball2->force -= spring_constant * spring_stretch * ball_to_neighbor;
    }

  ///
  /// Update Position of Each Ball
  ///

  for ( BIter ball(balls); ball; )
    {
      if ( ball->locked )
        {
          ball->velocity = pVect(0,0,0);
          continue;
        }

      // Update Velocity
      //
      // This code assumes that force on ball is constant over time
      // step. This is clearly wrong when balls are moving with
      // respect to each other because the springs are changing
      // length. This inaccuracy will make the simulation unstable
      // when spring constant is large for the time step.
      //
      float mass = std::max(ball->mass, ball->mass_min );
      ball->velocity += ( ball->force / mass ) * delta_t;

      // Air Resistance
      //
      const double fs = pow(1+opt_air_resistance,-delta_t);
      ball->velocity *= fs;

      // Update Position
      //
      // Assume that velocity is constant.
      //
      ball->position += ball->velocity * delta_t;

      // Possible Collision with Platform
      //

      // Skip if collision impossible.
      //
      if ( !platform_collision_possible(ball->position) ) continue;
      if ( ball->position.y >= 0 ) continue;

      // Snap ball position to surface.
      //
      ball->position.y = 0;

      // Reflect y (vertical) component of velocity, with a reduction
      // due to energy lost in the collision.
      //
      if ( ball->velocity.y < 0 )
        ball->velocity.y = - 0.9 * ball->velocity.y;
    }
}

bool
World::platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.x >= platform_xmin && pos.x <= platform_xmax
    && pos.z >= platform_zmin && pos.z <= platform_zmax;
}

 /// External Modifications to State
//
//   These allow the user to play with state while simulation
//   running.

// Move the ball.
//
void Ball::translate(pVect amt) {position += amt;}

// Add velocity to the ball.
//
void Ball::push(pVect amt) {velocity += amt;}

// Set the velocity to zero.
//
void Ball::stop() {velocity = pVect(0,0,0); }

// Set the velocity and rotation (not yet supported) to zero.
//
void Ball::freeze() {velocity = pVect(0,0,0); }



void World::balls_translate(pVect amt,int b){head_ball->translate(amt);}
void World::balls_push(pVect amt,int b){head_ball->push(amt);}
void World::balls_translate(pVect amt)
{ for ( BIter ball(balls); ball; ) ball->translate(amt); }
void World::balls_push(pVect amt)
{ for ( BIter ball(balls); ball; ) ball->push(amt); }
void World::balls_stop()
{ for ( BIter ball(balls); ball; ) ball->stop(); }
void World::balls_freeze(){balls_stop();}


void
World::frame_callback()
{
  // This routine called whenever window needs to be updated.

  const double time_now = time_wall_fp();

  if ( !opt_pause || opt_single_frame || opt_single_time_step )
    {
      /// Advance simulation state.

      // Amount of time since the user saw the last frame.
      //
      const double wall_delta_t = time_now - last_frame_wall_time;

      // Compute amount by which to advance simulation state for this frame.
      //
      const double duration =
        opt_single_time_step ? opt_time_step_duration :
        opt_single_frame ? 1/30.0 :
        wall_delta_t;

      const double world_time_target = world_time + duration;

      while ( world_time < world_time_target )
        {
          time_step_cpu(opt_time_step_duration);
          world_time += opt_time_step_duration;
        }

      // Reset these, just in case they were set.
      //
      opt_single_frame = opt_single_time_step = false;
    }

  last_frame_wall_time = time_now;
  render();
}

int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);
}
