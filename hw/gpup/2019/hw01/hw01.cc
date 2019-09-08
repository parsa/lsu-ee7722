/// LSU EE 4702-1 (Fall 2019), GPU Programming
//
 /// Homework 1
 //

 /// Instructions
 //
 //  Read the assignment: https://www.ece.lsu.edu/koppel/gpup/2019/hw01.pdf
 //
 //  Most of the solution should be in routine time_step_cpu.
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
  // This is a member of world, named hw01. E.g., hw01.rail_inited.

  /// Homework 1 -- Feel free to add new members to this structure.

  // If false the ring location variables need to be updated.
  bool rail_inited;

  // Variables defining the location and size of ring.
  pCoor center;
  pNorm axis;
  float radius;

  // Variables derived from axis and radius.
  pVect x, y;  // In same plane as ring.

  // Variables defining ball's rotation rate and position on the ring.
  float omega;
  float theta;

  float opt_spin_omega;

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
  chain_length = 10;
  balls.resize(chain_length);

  opt_hw01_do_friction = false;
  opt_hw01_spin = false;

  hw01.opt_spin_omega = 0.2;

  hw01.omega = 1;
  variable_control.insert(hw01.omega,"Rotation rate.");
  variable_control.insert(hw01.opt_spin_omega,"Spin rate.");

  opt_hw01_fric_coefficient = 0.1;
  variable_control.insert(opt_hw01_fric_coefficient,"Friction Coefficient");

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
  /// Arrange balls vertically.

  // Desired position of bottom ball.
  //
  pCoor bottom_pos(12.5,2*distance_relaxed,-13.7);

  // Desired distance between adjacent balls.
  //
  pVect ball_separation(0, distance_relaxed, 0);  // Points up.

  for ( int i=0; i<chain_length; i++ )
    {
      Ball* const ball = &balls[chain_length-i-1];

      ball->position = bottom_pos + i * ball_separation;

      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->constraint = OC_Free;
      ball->contact = false;
    }

  hw01.rail_inited = false;
  balls[0].constraint = OC_Ring_Free;
}

void
World::ball_setup_2()
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
    }

  hw01.rail_inited = false;
  balls[0].constraint = OC_Ring_Free;
}

void
World::ball_setup_3()
{
  ball_setup_1();
}

void
World::ball_setup_4()
{
  ball_setup_2();
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
  /// Homework 1 Solution In This Routine

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
      for ( int direction: { -2, -1, +1, +2 } )
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

          // Compute by how much the spring is stretched (positive value)
          // or compressed (negative value).
          //
          const float spring_stretch =
            distance_between_balls - distance_relaxed * fabs(direction);

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

  // Compute location of ball on ring.
  auto pos_compute = [&](float theta)
    {
      return hw01.center +
        hw01.radius * ( cosf(theta) * hw01.x + sinf(theta) * hw01.y );
    };

  // Impact on velocity due to air resistance.
  const double fs = pow(1+opt_air_resistance,-delta_t);

  // Convenient head ball reference.
  Ball& hball = balls[0];

  /// Initialize Ring
  //
  //  Initialize at start and when ring is in a new position.
  //
  if ( !hw01.rail_inited && hball.constraint > OC_Locked )
    {
      hw01.rail_inited = true;
      hw01.theta = 0;
      const float size = 3;
      hw01.radius = curr_setup > 2 ? 4.5 : size + size * drand48();

      pNorm vdir(hball.velocity);

      if ( vdir.magnitude < 0.00001 )
        {
          // If ball is not moving, choose ring axis randomly.

          const float tilt_amt = 0.9;
          switch ( curr_setup ) {
          case 1: case 2:  // Random angle.
            hw01.axis = pNorm(tilt_amt*drand48(),1,tilt_amt*drand48());
            break;
          case 3: // Almost straight up.
            hw01.axis = pNorm(0.2,1,-0.2);
            break;
          case 4:
            hw01.axis =
              cross( balls[chain_length-1].position - balls[0].position,
                     pVect(0,1,0) );
            break;
          default:
            hw01.axis = pNorm(tilt_amt*drand48(),1,tilt_amt*drand48());
            break;
          }

          // Find an axis orthogonal to hw01.axis, use this for local x axis.
          //
          hw01.x =
            hw01.axis.z != 0 && hw01.x != 0
            ? pNorm(hw01.axis.z,0,-hw01.axis.x)
            : pNorm(1,0,0);

          // Use local x axis to find center position of ring.
          //
          hw01.center = hball.position - hw01.x * hw01.radius;

          // Compute local y axis
          //
          hw01.y = cross(hw01.axis,hw01.x);

          const float l = hw01.y.mag();
          assert( fabs(l-1) < 0.0001 );

          hw01.omega = hball.constraint == OC_Ring_Animated ? 1 : 0;
        }
      else
        {
          // If ball is moving, position ring so that velocity direction
          // is a tangent to the ring.

          // Set local y axis to direction of ball's velocity vector.
          //
          hw01.y = vdir;
          //
          // This way, the ring smoothly "catches" the ball.

          // Make local x axis orthogonal to the local and global y axes.
          //
          hw01.x = pNorm( cross( hw01.y, pVect(0,-1,0) ) );

          // Compute local z axis (the ring axis)
          //
          hw01.axis = cross(hw01.x,hw01.y);
          hw01.center = hball.position - hw01.radius * hw01.x;

          // Set omega so that speed of ring matches speed of ball.
          //
          hw01.omega = vdir.magnitude / hw01.radius;
        }

    }

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

      case OC_Ring_Animated:
        //
        // Ball attached to ring and rotates with it at fixed rate omega.
        {
          // Compute amount by which ring will rotate during this time step.
          //
          const double delta_theta = delta_t * hw01.omega;

          // Update velocity vector.
          //
          ball->velocity =
            hw01.omega * hw01.radius *
            ( -sinf(hw01.theta) * hw01.x + cosf(hw01.theta) * hw01.y );

          // Update the position angle and the position Cartesian coordinate.
          //
          hw01.theta += delta_theta;
          ball->position = pos_compute(hw01.theta);
        }
        break;

      case OC_Ring_Free:
        //
        // Ball can slide along ring freely.
        {
          /// Put Problem 1 solution here, mostly.

          // Quantity ball->force is the force on the ball due to its
          // neighbor and to gravity. Since the ball is constrained
          // to move in a circle (along the ring) 


          pVect center_to_ball =
            pVect(hw01.center,ball->position) / hw01.radius;
          //
          // Note: center_to_ball should be a unit vector.

          pVect dtan = cross(hw01.axis,center_to_ball);
          assert( dtan.mag_sq() < 1.0001 ); // Make sure it's a unit vector.

          // Compute force in direction of motion along ring.
          //
          const float force_tan = dot( ball->force, dtan );

          // Compute change in velocity and the corresponding change
          // in rotation rate.
          //
          const float delta_v = force_tan / ball->mass * delta_t;
          const float delta_omega = delta_v / hw01.radius;

          // Update the rotation rate, angle, linear velocity, and position.
          //
          hw01.omega += delta_omega;
          hw01.theta += hw01.omega * delta_t;
          ball->velocity = hw01.omega * hw01.radius * dtan;
          ball->position = pos_compute(hw01.theta);
        }
        break;

      default: assert( false );
      }
    }

  if ( opt_hw01_spin && hball.constraint >= OC_Ring_Animated )
    {
      /// Put Problem 2 solution mostly here.
      //
      //  But, feel free to declare new members in HW01_Stuff




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
  hw01.omega = 0;
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

