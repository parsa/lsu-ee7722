/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 /// Homework 1 -- SOLUTION
 //

 /// Instructions
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2020/hw01.pdf
 //
 //  Also, feel free to add members to structure HW01_Stuff.
 //
 //  Only this file will be collected.


/// Purpose
//
//   Demonstrate simulation of string modeled as point masses and springs


/// What Code Does

// Simulates a string of beads over a platform. The string is modeled
// as point masses connected by springs with a long relaxed
// length. The platform consists of tiles, some are purple-tinted
// mirrors (showing a reflection of the ball), the others show the
// course syllabus.


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
 //  '1'    Set up scene 1.
 //  '2'    Set up scene 2.
 //  'p'    Pause simulation. (Press again to resume.)
 //  ' '    (Space bar.) Advance simulation by 1/30 second.
 //  'S- '  (Shift-space bar.) Advance simulation by one time step.
 //  'h'    Freeze position of first (head) ball. (Press again to release.)
 //  't'    Freeze position of last (tail) ball. (Press again to release.)
 //  's'    Stop balls.
 //  'g'    Turn gravity on and off.
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
 //  VAR Air Resistance - Set air resistance.
 //  VAR Light Intensity - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)


#define GL_GLEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>

#include "shapes.h"


///
/// Main Data Structures
///
//
// class World: All data about scene.


class World;

struct HW01_Stuff {

  /// Homework 1 -- Feel free to add new members to this structure.
  // This is a member of world, named hw01. E.g., hw01.markers_show;

  HW01_Stuff():opt_rot_speed(10),markers_show(false){}

  float opt_rot_speed;


  // For debugging.
  bool markers_show;  // If true, show vectors and positions assigned below.
  pVect mark_vec_red, mark_vec_green, mark_vec_blue;
  pCoor mark_pos_white, mark_pos_red, mark_pos_green;

};

enum Object_Constraint
{
  OC_Free,
  OC_Locked,  // Position is never changed.
  OC_Ring_Animated,
  OC_Ring_Free
};


// Object Holding Ball State
//
class Ball {
public:
  pCoor position;
  pVect velocity;

  float mass;
  float radius;
  Object_Constraint constraint;

  /// SOLUTION -- 2020 Homework 1, Problem 1, Part b
  //
  float distance_relaxed;  // Spring from this ball to next ball in array.

  pVect force;
  bool contact;                 // Can be used for special effects.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

#include "hw01-graphics.cc"


void
World::init()
{
  srand48(4702);

  opt_tryout1 = opt_tryout2 = opt_tryout3 = false;

  chain_length = 21;
  balls.resize(chain_length);

  variable_control.insert(hw01.opt_rot_speed,"Rotation Speed");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 1000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.01;
  //  variable_control.insert(opt_air_resistance,"Air Resistance");

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  init_graphics();

  curr_setup = 1; ball_setup_1();
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//
void
World::ball_setup_1()
{
  ball_setup_hw01(1);
}
void
World::ball_setup_2()
{
  ball_setup_hw01(2);
}
void
World::ball_setup_3()
{
  ball_setup_hw01(3);
}


void
World::ball_setup_hw01(int option)
{
  /// Homework 1:  
  //  Most of the solution goes in this file.

  const bool opt_special_dist_relaxed = option > 1;
  const bool opt_spin = option > 2;

  // The position of the first ball is the same each time.
  //
  pCoor first_pos(12.5, chain_length * distance_relaxed, -13.7);

  // This randomly chosen unit vector points from first to last pos.
  //
  pNorm ax( -drand48(), -drand48()/3, -drand48()/7 );

  // Distance between first and last ball.
  //
  const float first_last_dist =
    ( 0.2 + drand48()*0.6 ) * distance_relaxed * ( chain_length - 1 );

  // Length of chain between first and last ball.
  //
  const float chain_distance = distance_relaxed * ( chain_length - 1 );

  // The position of the last ball.
  //
  pCoor last_pos = first_pos + first_last_dist * ax;

  // Compute a local z axis, az, that is parallel to the global x/z axis.
  //
  pNorm az = cross( ax, pVect(0,1,0) );

  // Compute a local y axis.
  //
  pVect ay = cross( az, ax );
  //
  // This is a tilted version of the global y axis.

  // Construct an ellipse defined as follows:
  //
  //  Imagine the chain were inflexible string and the ends
  //  were attached to first_pos and last_pos.
  //
  //  Stretch the string tight using an imaginary pencil tip. The
  //  ellipse is formed by the possible locations of the pencil top/
  //
  //  Note: the ellipse is in the plane with normal az.
  //
  // In geometric terminology:
  //
  //  The foci are at first_pos and last_pos.
  //  The distance between the foci is first_last_dist.
  //
  // Eccentricity of ellipse.
  //
  const float ec = first_last_dist / chain_distance;

  // Halfway point between the two balls. This will be the origin
  // of the local space in which the ellipse is drawn.
  //
  pCoor mid_pos = first_pos + 0.5 * first_last_dist * ax;

  // Compute handy values.
  //
  const float ays = ay.y * ay.y,  axs = ax.y * ax.y,  ecs = ec * ec;

  // Compute local x coordinate of point on ellipse that has the
  // minimum value of y in the global coordinate space. This assumes
  // that ax.y < 0;
  //
  const float lx_min =
    -chain_distance * 0.5 * ax.y / sqrt( axs + ays * ( 1 - ecs ) );

  // Compute local y coordinate of point on ellipse corresponding to lx_min.
  //
  const float ly_min =
    -sqrt( ( chain_distance * chain_distance / 4 - lx_min * lx_min )
           * ( 1 - ecs ) );

  // Compute coordinates of the point on the ellipse with the minimum local y.
  //
  pCoor nadir_pos = mid_pos + lx_min * ax + ly_min * ay;


  // Verify that distance from first, to nadir, to last is correct.
  pNorm dfn(first_pos,nadir_pos);
  pNorm dln(last_pos,nadir_pos);
  assert( fabs( dfn.magnitude + dln.magnitude - chain_distance ) < 0.0001 );

  // Set markers that will be displayed when the simulation is paused.
  // These may be useful for debugging. Feel free to change them.
  //
  hw01.markers_show = true;
  hw01.mark_vec_red = ax;     // Red needle points along ax.
  hw01.mark_vec_green = -ay;
  hw01.mark_vec_blue = az;
  hw01.mark_pos_white = first_pos;
  hw01.mark_pos_red = last_pos;
  hw01.mark_pos_green = nadir_pos;


  /// SOLUTION -- 2020 Homework 1, Problem 1, Part a
  //
  //  Compute index of last ball in the line starting at first_pos.
  //
  const int i_dir_change = 0.9999f + dfn.magnitude / distance_relaxed;

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      /// SOLUTION -- 2020 Homework 1, Problem 1, Part a
      //
      //  Compute ball position based either on position relative to
      //  first_pos or on position relative to last_pos.
      //
      ball->position = i < i_dir_change
        ? first_pos +                      i   * distance_relaxed * dfn
        : last_pos  + ( chain_length - 1 - i ) * distance_relaxed * dln;

      ball->velocity = pVect(0,0,0);
      ball->radius = 0.2;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->constraint = i > 0 && i < chain_length - 1 ? OC_Free : OC_Locked;
      ball->contact = false;

      /// SOLUTION -- 2020 Homework 1, Problem 1, Part b
      //
      //  Ball::distance_relaxed is the relaxed distance of the spring
      //  connecting ball i to ball i-1.
      //
      //  Set distance_relaxed to the distance between this and
      //  previous ball if opt_special_dist_relaxed and if the i-1
      //  ball is on the line from first_pos and this ball is on the
      //  line to last_pos.
      //
      ball->distance_relaxed =
        opt_special_dist_relaxed && i == i_dir_change
        ? pNorm(balls[i-1].position,ball->position).magnitude
        : distance_relaxed;
    }

  /// SOLUTION -- 2020 Homework 1, Problem 1, Part c
  //
  //  Compute the spin direction. (This will be the same as az AoTW.)
  //
  pNorm spin_dir = cross(first_pos,nadir_pos,last_pos);
  //
  if ( opt_spin )
    for ( auto& b: balls )
      {
        //  Set speed of each ball to 10 times distance between ball
        //  and nearest point on line through first_pos and last_pos.

        pVect to_b0(b.position, first_pos);

        // Compute distance from this ball to the closest point on
        // first_pos/last_pos line.
        //
        const float dist = dot( to_b0, ay );
        //
        // This only works when the ball is on the ax/ay plane.

        // Make velocity proportional to distance.
        //
        b.velocity = dist * 10 * spin_dir;
      }
}



void
World::ball_setup_4()
{
  /// Arrange and size balls to form a pendulum.

  // Desired position of first ball.
  //
  pCoor first_ball_pos(13.4,17.8,-9.2);

  // Desired distance between adjacent balls.
  //
  pVect ball_separation(distance_relaxed, 0, 0);  // Points in +x direction.

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];
      ball->position = first_ball_pos + i * ball_separation;

      ball->velocity = pVect(0,0,0);
      ball->radius = ( i == 0 ? 0.6 : 0.3 );
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
      ball->constraint = OC_Free;

      /// SOLUTION -- 2020 Homework 1, Problem 1, Part b
      //
      //  Need to initialize distance_relaxed wherever balls are inited.
      //
      ball->distance_relaxed = distance_relaxed;
    }

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

  //
  /// Compute total force acting on each ball
  //
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      ball->force = pVect(0,0,0);

      // Gravitational Force
      //
      ball->force += ball->mass * gravity_accel;

      // Spring Force from Neighbor Balls
      //
      for ( int direction: { -1, +1 } )
        {
          const int n_idx = i + direction;  // Compute neighbor index.

          // Skip this neighbor if neighbor doesn't exit.
          //
          if ( n_idx < 0 ) continue;
          if ( n_idx >= chain_length ) continue;

          Ball* const neighbor_ball = &balls[n_idx];

          // Construct a normalized (Unit) Vector from ball to neighbor.
          //
          pNorm ball_to_neighbor( ball->position, neighbor_ball->position );

          // Get distance between balls using pNorm member magnitude.
          //
          const float distance_between_balls = ball_to_neighbor.magnitude;

          /// SOLUTION -- 2020 Homework 1, Problem 1, Part b
          //
          //  Find index of the higher-numbered ball. It is the one with
          //  the distance_relaxed value to use.
          //
          const int idx_gt = max(i,n_idx);

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          /// SOLUTION -- 2020 Homework 1, Problem 1, Part b
          //
          //  Get the relaxed distance from the ball rather than using
          //  World::distance_relaxed.
          //
          const float spring_stretch =
            distance_between_balls
            - balls[idx_gt].distance_relaxed * fabs(direction);

          // Compute the speed of ball towards neighbor_ball.
          //
          pVect delta_v = neighbor_ball->velocity - ball->velocity;
          float delta_s = dot( delta_v, ball_to_neighbor );


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

          ball->force += spring_constant * spring_stretch * ball_to_neighbor;
        }
    }

  // Impact on velocity due to air resistance.
  const double fs = pow(1+opt_air_resistance,-delta_t);

  /// Update Velocity and Position of Each Ball
  //
  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[i];

      // Select appropriate velocity/position update based upon
      // ball's constraint.

      switch ( ball->constraint ) {

      case OC_Free:
        //
        // No constraints, use the force as computed above ..
        // .. and check for and resolve platform collision.

        // Update Velocity and Position
        //
        ball->velocity += ( ball->force / ball->mass ) * delta_t;
        ball->velocity *= fs;  // Air resistance.
        ball->position += ball->velocity * delta_t;

        // Possible Collision with Platform
        //
        // Skip if collision impossible.
        //
        if ( !platform_collision_possible(ball->position) ) break;
        if ( ball->position.y >= ball->radius ) break;

        // Reflect y (vertical) component of velocity, with a reduction
        // due to energy lost in the collision.
        //
        if ( ball->velocity.y < 0 ) ball->velocity.y = - 0.9 * ball->velocity.y;
        break;

      case OC_Locked:
        //
        // Ball does not move. Forces are ignored and position does not change.

        ball->velocity = pVect(0,0,0);
        break;

      default: assert( false );
      }
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



void World::balls_translate(pVect amt,int b){balls[b].translate(amt);}
void World::balls_push(pVect amt,int b){balls[b].push(amt);}
void World::balls_translate(pVect amt)
{ for(int i=0;i<chain_length;i++)balls[i].translate(amt);}
void World::balls_push(pVect amt)
{ for(int i=0;i<chain_length;i++)balls[i].push(amt);}
void World::balls_stop()
{
  for ( auto& b: balls ) b.stop();
}
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

      const double time_step_duration = 0.0001;

      // Compute amount by which to advance simulation state for this frame.
      //
      const double duration =
        opt_single_time_step ? time_step_duration :
        opt_single_frame ? 1/30.0 : 
        wall_delta_t;

      const double world_time_target = world_time + duration;

      while ( world_time < world_time_target )
        {
          time_step_cpu(time_step_duration);
          world_time += time_step_duration;
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

