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
#include "demo-1c-coord-graphics.cc"


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


  /// Create Card 1 -- Set corners individually.
  //
  card1 = new Card();   // Instantiate card.
  cards += card1;       // Put card in list of cards to render.

  // Set upper left from a constant coordinate (pos1).
  pCoor pos1( 12, 10, 21.4 );
  card1->upper_left = pos1;
  card1->upper_right = pos1;
  card1->upper_right.x += 5;
  card1->lower_left = card1->upper_left + pVect(0,-1,0);
  card1->lower_right = card1->upper_right + pVect(0,-1,0);

  /// Create Card 2 -- Position card 2 just to left of card1.
  //  Demonstrates vector addition to translate points.
  //
  card2 = new Card(card1);
  cards += card2;
  card2->upper_right = card1->upper_left; // Cards will touch.
  // Compute distance between respective corners.
  pVect card_offset = card2->upper_right - card1->upper_right;
  // Use distance to set other three corners with vector addition.
  card2->upper_left = card1->upper_left + card_offset;
  card2->lower_right = card1->lower_right + card_offset;
  card2->lower_left = card1->lower_left + card_offset;


  /// Create Card 3 -- Position further to left of card 2 and a little up.
  //
  pVect card_offset2 = card_offset * 1.1 + pVect(0,0.2,0);
  Card* const card3 = new Card();
  cards += card3;
  // Use vector addition to translate card2 coordinates.
  card3->upper_left  = card2->upper_left + card_offset2;
  card3->upper_right = card2->upper_right + card_offset2;
  card3->lower_right = card2->lower_right + card_offset2;
  card3->lower_left  = card2->lower_left + card_offset2;

  /// Create Card 4 
  //  Demonstrates use of matrix multiplication for translation.
  //
  Card* const card4 = new Card();
  cards += card4;

  // Construct a translation matrix based on vector card_offset2.
  pMatrix_Translate trans_offset3(card_offset2);

  // Use matrix multiplication to translate card3 coordinates.
  card4->upper_left  = trans_offset3 * card3->upper_left;
  card4->upper_right = trans_offset3 * card3->upper_right;
  card4->lower_right = trans_offset3 * card3->lower_right;
  card4->lower_left  = trans_offset3 * card3->lower_left;

  /// Create Card Live
  //  Demonstrates scaling and composition of transformations.
  //  This is just the initialization of card_live, see time step code
  //  fort he rest.
  //
  card_live = new Card();
  cards += card_live;
  pVect card_live_offset(6,1.3,0);
  pMatrix_Translate trans_c1_to_clive(card_live_offset);
  card_live->upper_left  = trans_c1_to_clive * card1->upper_left;
  card_live->upper_right = trans_c1_to_clive * card1->upper_right;
  card_live->lower_right = trans_c1_to_clive * card1->lower_right;
  card_live->lower_left  = trans_c1_to_clive * card1->lower_left;

  /// User interface for interactive scaling.
  //  Each key press will change size slightly.
  //
  pressed_key_c = pressed_key_C = false;


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
