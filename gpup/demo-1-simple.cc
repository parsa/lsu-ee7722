/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Simple Demo of Dynamic Simulation

/// Purpose
//
//   To show the structure of a program that performs a simple dynamic
//   simulation.

#if 0
/// Background

/// Important Parts of Program
//

 /// Program Start
//
int  main(int argc, char** argv);
//   Starts when the program starts.
//
//   - Initializes graphics system using library calls.
//   - Initialized our simulated world using our routine, init.
//   - Registers our event handler, frame_callback (see below).
//   - Starts the event loop.


 /// Frame Update
//
void World::frame_callback()
//   Called each time screen needs to be updated.
//
//   - Advances time in simulated word to match current time ..
//     .. by calling time_step_cpu_v0 (see below).
//
//   - Updates the frame buffer ..
//     .. by calling our render routine, which uses OpenGL calls.


 /// Time Step Routine
//
void World::time_step_cpu_v0(double delta_t)
//
//   - Advances the state of our simulated world by delta_t seconds.


#endif

/// What Code Does

// Simulates a ball bouncing over a platform. The platform consists of
// tiles, some are purple-tinted mirrors (showing a reflection of the
// ball), the others show the course syllabus. The ball can be
// manipulated by the user.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move ball. (Change position but not velocity.)
 //   'B': Push ball. (Add velocity.)
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
 //  's'    Stop ball.
 //  'S'    Freeze ball. (Set velocity of all vertices to zero.)
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
 //  VAR Light Intensity - The light intensity.
 //  VAR Gravity - Gravitational acceleration. (Turn on/off using 'g'.)


// Include handy classes for coordinates (pCoor), vectors (pVect), etc.
//
#include <gp/coord.h>


// Object Holding Ball State
//
class Ball {
public:

  /// Ball Position and Velocity
  //
  pCoor position;
  pVect velocity;
  //
  // Note: pCoor is a coordinate, pVect is a vector.

  // Member functions to manipulate state of ball.
  //
  void push(pVect amt);
  void translate(pVect amt);
  void stop();
};


//
// Include file containing graphical code for ball, something to be
// skipped in this simple example.
//
#include "demo-1-simple-graphics.cc"


void
World::init()
{
  ///
  /// Physical Model Initialization
  ///

  // Set initial position to a visibly interesting point.
  //

  ball.position = pCoor( 13.7, 22, -15.4 );  // x=13.7, y=22, z=-15.4
  ball.velocity = pVect(0,0,0);

  // Time in our simulated world.
  //
  world_time = 0;
  last_frame_wall_time = time_wall_fp();

  //
  // Set acceleration vector based on scalar.
  //

  // A user-adjustable scalar.
  //
  opt_gravity_accel = 9.8;

  // The vector needed for calculations.
  //
  gravity_accel = pVect( 0, -opt_gravity_accel, 0 );

  // Make gravity adjustable using user interface.
  //
  variable_control.insert(opt_gravity_accel,"Gravity");

  // User interface control for turning gravity on and off.
  //
  opt_gravity = true;       // If false, gravity doesn't act on ball.

  // Position of platform that the ball bounces on.
  //
  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;

  ///
  /// Graphical Model Initialization
  ///

  init_graphics();  // Our own code for initializing graphics model.
}


///
/// Physical Simulation Code
///

 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu_v0(double delta_t)
{
  time_step_count++;

  /// Update Position and Velocity of Ball
  //
  //  Advance physical state by delta_t seconds.

  // New ball position, accounting for current speed and acceleration,
  // and assuming no collision.
  //
  ball.position +=
    ball.velocity * delta_t + 0.5 * gravity_accel * delta_t * delta_t;

  // New velocity, assuming no collision.
  //
  ball.velocity += gravity_accel * delta_t;


  /// Possible Collision with Platform

  // Position and velocity computation simplified: they do not account
  // for the exact time of collision. (In this particular case the
  // exact time of collision could have been easily found.)

  if ( ball.position.y < 0 )
    {
      // Reflect y (vertical) component of velocity, with a reduction
      // due to energy lost in the collision.
      //
      if ( ball.velocity.y < 0 )
        ball.velocity.y = - 0.9 * ball.velocity.y;

      // Don't "Fix" position by snapping it to zero, that would
      // add energy to the system.
      //   ball.position.y = 0;  // Bad.
    }
}

 /// External Modifications to State
//
//   These allow the user to play with state while simulation
//   running.

// Move the ball.
//
void Ball::translate(pVect amt) { position += amt; }

// Add velocity to the ball.
//
void Ball::push(pVect amt) { velocity += amt; }

// Set the velocity to zero.
//
void Ball::stop() { velocity = pVect(0,0,0); }


void
World::frame_callback()
{
  // This routine called whenever window needs to be updated.

  const double time_now = time_wall_fp();

  if ( !opt_pause || opt_single_frame || opt_single_time_step )
    {
      /// Advance simulation state by wall clock time.
      //
      const double delta_t = time_now - last_frame_wall_time;
      time_step_cpu_v0(delta_t);
      world_time += delta_t;
    }

  last_frame_wall_time = time_now;

  // Emit graphical representation of the just-updated physical state.
  //
  render();  // Code in demo-1-simple-graphics.cc
}


int
main(int argv, char **argc)
{
  // A class that initializes graphics and provides handy
  // functionality; we'll call it the helper. Something written for
  // this class.
  //
  pOpenGL_Helper popengl_helper(argv,argc);

  // Instantiate our bouncing-ball world.
  // This calls World::init().
  //
  World world(popengl_helper);

  // Tell our helper to call our frame code 30 times per second, when
  // the time comes.
  //
  popengl_helper.rate_set(30);

  // Tell our helper code that we are done setting up and that
  // whenever we need to paint a frame to call world.frame_callback_w.
  // (It will be called 30 times per second.)
  //
  popengl_helper.display_cb_set(world.frame_callback_w,&world);

  // This point will only be reached when the program exits normally.

}
