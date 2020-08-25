/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 /// Simple Demo of Dynamic Simulation

/// Purpose
//
//   To show the structure of a program that performs a simple dynamic
//   simulation.

#if 0
/// Background

 /// Introduction to This File
 //
 // This program, demo-1-simple, simulates a ball bouncing on a
 // platform. It is intended to show how a simple physical simulation
 // can be coded and connected to code that can render the simulated
 // world. As the semester progresses we will use increasingly rich
 // code samples of this type. The first few will focus on how to
 // simulate physical systems, but later simulations will focus on how
 // to code graphics.
 //
 // This file contains the code performing the simulation, the
 // rendering is done by the code in file demo-1-simple-graphics.cc.
 //
 // The code in this file should be understood well enough so that at
 // the very least the code in World::init can be modified to change
 // the initial state of the ball (such as initially moving up or
 // sideways) and the code in World::time_step_cpu_v0 can be modified
 // to change the bounce characteristics, etc.


/// Physical Simulation

 ///  Role of Physical Simulation in this Class
 //
 // The subject of this class is GPU programming. To keep things
 // interesting the GPU programs will render a simulated world and
 // later GPU programs will simulate that world too. The physical
 // simulations are easy to code (including the code under proj-base)
 // and provide interesting things to render.
 //
 // In this first example we are simulating a ball on a platform, and
 // the code looks as simple as one might expect. But the code for the
 // more elaborate demos is not that much more complicated.

 ///  Physical Simulation Program Structure
 //
 // Physical simulation in principle is very simple: we start with some
 // state that represents the world at a some initial point in time (such
 // as the ball position and velocity at t=0) and an /evolution/ or
 // /time-step/ routine that reads the state and computes the state for
 // some time in the future (say, after 1 second). If our goal is
 // animation then we call our time step routine each time a new frame is
 // to be displayed, say, 60 times per second. After the time step routine
 // computes a new state a /render/ routine would update the frame buffer.
 //
 // In this file World::time_step_cpu_v0(delta_t) is the time-step routine
 // and the state is held in World::ball. Of course, time_step_cpu_v0
 // updates the simulated world by delta_t seconds. Routine World::init
 // initializes the ball, plus performs other setup.
 //
 // If we look at program excerpts then the simplicity is apparent:
 //
void World::init() // Simplified initialization routine.
{
  ball.position = pCoor( 13.7, 22, -15.4 );  // x=13.7, y=22, z=-15.4
  ball.velocity = pVect( 0, 0, 0 );          // Start motionless.
  gravity_accel = pVect( 0, -9.8, 0 );       // We all remember g, right?
}

void World::time_step_cpu_v0(double delta_t) // Simplified time-step.
{
  ball.position +=
    ball.velocity * delta_t + 0.5 * gravity_accel * delta_t * delta_t;
  ball.velocity += gravity_accel * delta_t;
}
 //
 // But this simplicity can get buried in other code handling routine
 // matters. Even in this file. For example, in the real World::init
 // routine vector variable gravity_accel is set using a scalar
 // variable opt_gravity_accel, which itself is connected to the user
 // interface so that the user can adjust gravitational acceleration.
 //
 // A key skill is being able to read and modify code despite this
 // necessary clutter.



 /// Overall Simulation Program Structure - Physical Simulation
 //
 //  System State -- Describes Our Simulated World
 //
 //    Here, ball and platform.
 //
 //    Ball Structure Information
 //      Holds: Position, Velocity.
 //
 //  
 //  Forces and Governing Equations -- Describe dynamics.
 //
 //    Gravity. Here, a constant force.
 //    Interaction with platform.  Bounce.
 //
 //
 //  Evolution Time Step -- Routine that updates state based on model.
 //
 //    Determine forces on each ball.
 //    Use forces to compute new velocity.
 //    Use velocity to compute new position.

 /// Graphics
 //
 //    OpenGL
 //      Between "us" and frame buffer: OpenGL
 //      We send triangles to OpenGL, which it renders on the frame buffer.
 //      We'll get into alot more detail in near-future lectures.

 //    Graphical Representation
 //      Objects usually approximated by triangles.
 //      Each object, say sphere, has a render routine.
 //      The render routine uses position computed by physics simulation ..
 //      .. to determine triangle locations. These are sent to OGL.


 /// Structure of Program
 //
 //    Initialization routine -- Sets up our world, etc.
 //    Time Step Routine -- Advances time in simulated world.
 //    Render Routine -- Send graphical representation of world to OpenGL.


 /// Program Execution
 //
 //    Program startup: main is called, just like any other C program.
 //    main performs initialization ..
 //    .. and tells window system to call one of our routines.
 

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
