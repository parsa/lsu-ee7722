/// LSU EE 4702-1 (Fall 2011), GPU Programming
//
 /// Simple Demo of Dynamic Simulation

// $Id:$

/// Purpose
//
//   Demonstrate use of coordinate and vector classes, and basic transforms.


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

  // Note: pCoor is a coordinate, pVect is a vector.

  pCoor position;  // Ball Position.
  pVect velocity;  // Ball Velocity.

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
#include "demo-1d-objects-graphics.cc"


void
World::init()
{
  ///
  /// Physical Model Initialization
  ///

  // Set initial position to a visibly interesting point.
  //

  ball.position = pCoor( 12.1, 22, 11.4 );
  ball.velocity = pVect(0,0,0);

  // Time in our simulated world.
  //
  world_time = 0;

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


  // Create a circle of cards.

  new_card_circle
    ( pCoor(12.1,0,11.4),  // Bottom center location.
      15,                  // Scale factor (size)
      4,                   // Number of sides
      M_PI/5 );            // Rotation (start angle).


  // Create tower of circles of cards.

  Card* const sample = new_card_normal();
  const double scale_factor = 15;
  const int num_sides = 3;
  double card_height = sample->upper_left.y * scale_factor;
  for ( int i=0; i<20; i++ )
    {
      pCoor position(6.8, card_height * i, 21.8);
      new_card_circle( position,
                       scale_factor,
                       num_sides,
                       i * M_PI / 10);
    }
      

  /// User interface for interactive scaling.
  //  Each key press will change size slightly.
  //
  pressed_key_c = pressed_key_C = false;


  ///
  /// Graphical Model Initialization
  ///

  init_graphics();  // Our own code for initializing graphics model.
}

Card*
World::new_card_normal()
{
  // Create card using local coordinate system:
  //  Lower left at origin, bottom along positive x axis.
  //  Shown at actual size (if global space in meters).

  Card* const c = new Card();
  pVect lower_left_to_lower_right( 8 * .0254, 0, 0);
  pVect lower_left_to_upper_left( 0, 11 * .0254, 0);
  c->lower_left = pVect(0,0,0);
  c->lower_right = c->lower_left + lower_left_to_lower_right;
  c->upper_left = c->lower_left + lower_left_to_upper_left;
  c->upper_right = c->upper_left + lower_left_to_lower_right;

  return c;
}

void
World::new_card_circle
(pCoor center, double size, int num_sides, double angle_start)
{
  // Arrange cards to form a square.

  pVect circle_center(center);
  pMatrix_Translate circle_to_pos(circle_center);
  pMatrix_Scale circle_size(size);
  pMatrix position_circle = circle_to_pos * circle_size;

  double theta = 2 * M_PI / num_sides;
  double theta_2 = theta / 2;

  Card* const c_sample = new_card_normal();

  // Assuming that lower left on origin and card on positive x axis.
  //
  const double width = c_sample->lower_right.x;
  const double radius = width / ( 2 * sin( theta_2 ) );
  const float a = radius * cos( theta_2 );

  delete c_sample;

  // Center Card 0

  pMatrix_Translate center_card(pVect(-width/2,0,0));
  pMatrix_Translate card_to_circle(pVect(0,0,a));

  pMatrix_Rotation rotate_init(pVect(0,1,0),angle_start);
  pMatrix_Rotation rotate(pVect(0,1,0),theta);

  pMatrix position_side_i = rotate_init * card_to_circle * center_card;

  for ( int side = 0; side < num_sides; side++ )
    {
      pMatrix position_this_card = position_circle * position_side_i;

      Card* const c = new_card_normal();
      cards += c;

      c->color = pColor(0.9,0.9,0.9);

      c->lower_left = position_this_card * c->lower_left;
      c->lower_right = position_this_card * c->lower_right;
      c->upper_right = position_this_card * c->upper_right;
      c->upper_left = position_this_card * c->upper_left;

      position_side_i = rotate * position_side_i;

    }
  
}


///
/// Physical Simulation Code
///

 /// Advance Simulation State by delta_t Seconds
//
void
World::time_step_cpu_v0(double delta_t)
{
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

  /// Update Cards

  if ( pressed_key_c || pressed_key_C )
    {
      // This code executed when either c or C pressed.
      // Code should scale card_live.

      // Construct a scale matrix.
      //
      const float scale_factor = pressed_key_c ? 0.9 : 1.0 / 0.9; 
      pMatrix_Scale scale_card(scale_factor);

#if 0
      /// Incorrect Method
      //  Apply scale transformation without centering card at origin.
      //
      card_live->upper_left  = scale_card * card_live->upper_left;
      card_live->upper_right = scale_card * card_live->upper_right;
      card_live->lower_right = scale_card * card_live->lower_right;
      card_live->lower_left  = scale_card * card_live->lower_left;
#else
      /// Correct Method
      //  Move card to center, scale, then move back.

      // Construct a vector from upper_left to origin (center).
      // Note: vector constructor can take two coordinates.
      //
      pVect card_to_ctr(card_live->upper_left,pCoor(0,0,0));

      // Construct translation matrix to center.
      pMatrix_Translate trans_card_to_ctr(card_to_ctr);

      // Construct translation matrix from center.
      // Note use of negation operator on vector.
      pMatrix_Translate trans_card_to_pos(-card_to_ctr);


      /// Correct But Inefficient
      //  Transformation matrices are applied one at a time.
      //  Need to do 3 matrix multiplies per coordinate. How wasteful!!
      //
      card_live->upper_left  = trans_card_to_ctr * card_live->upper_left;
      card_live->upper_right = trans_card_to_ctr * card_live->upper_right;
      card_live->lower_right = trans_card_to_ctr * card_live->lower_right;
      card_live->lower_left  = trans_card_to_ctr * card_live->lower_left;

      card_live->upper_left  = scale_card * card_live->upper_left;
      card_live->upper_right = scale_card * card_live->upper_right;
      card_live->lower_right = scale_card * card_live->lower_right;
      card_live->lower_left  = scale_card * card_live->lower_left;

      card_live->upper_left  = trans_card_to_pos * card_live->upper_left;
      card_live->upper_right = trans_card_to_pos * card_live->upper_right;
      card_live->lower_right = trans_card_to_pos * card_live->lower_right;
      card_live->lower_left  = trans_card_to_pos * card_live->lower_left;

#if 0
      /// Correct and Efficient (Relatively).

      // Construct a single transformation matrix.
      //
      pMatrix full_scale_card =
        trans_card_to_pos * scale_card * trans_card_to_ctr;

      card_live->upper_left  = full_scale_card * card_live->upper_left;
      card_live->upper_right = full_scale_card * card_live->upper_right;
      card_live->lower_right = full_scale_card * card_live->lower_right;
      card_live->lower_left  = full_scale_card * card_live->lower_left;
#endif

#endif

      pressed_key_c = pressed_key_C = false;
    }


  /// Possible Collision with Platform

  // Position and velocity computation simplified: they do not account
  // for the exact time of collision. (In this particular case the
  // exact time of collision could have been easily found.)

  // Return quickly if collision impossible.
  //
  if ( !platform_collision_possible(ball.position) ) return;

  if ( ball.position.y < 0 )
    {
      const float yval = ball.position.y;

      // Snap ball position to surface.
      //
      ball.position.y = 0;

      if ( opt_time_step_alt )
        ball.velocity.y += sqrt( -2.0 * yval * opt_gravity_accel );

      // Reflect y (vertical) component of velocity, with a reduction
      // due to energy lost in the collision.
      //
      if ( ball.velocity.y < 0 )
        ball.velocity.y = - 0.9 * ball.velocity.y;
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

  if ( opt_pause || world_time == 0 )
    {
      /// Don't change simulation state.
      //
      world_time = time_now;
    }
  else
    {
      /// Advance simulation state by wall clock time.
      //
      const double delta_t = time_now - world_time;
      time_step_cpu_v0(delta_t);
      world_time += delta_t;
    }

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
