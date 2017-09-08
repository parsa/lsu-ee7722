/// LSU EE 4702-1 (Fall 2017), GPU Programming
//

 /// Demonstration of transforms.
 //

/// Purpose
//
//   Demonstrate use of basic transforms.


/// What Code Does

// Simulates a ball bouncing over a platform. The platform consists of
// tiles, some are purple-tinted mirrors (showing a reflection of the
// ball), the others show the course syllabus. The ball can be
// manipulated by the user.
// Scene also shows syllabi arranged to from a box and a tower of prisms.


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
 //  VAR Viscosity - Viscosity of air. Modifies opt_air_viscosity.


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



// Return a new prism.
Group* new_prism(int num_sides, int texid);

// Return a new tower.
Group* new_tower(int num_sides, int num_layers, int texid);

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

  // For Homework 1: Air Viscosity
  //
  opt_air_viscosity = 0.1;  // Note: 0 means no air resistance.
  variable_control.insert(opt_air_viscosity,"Air Viscosity");

  // Position of platform that the ball bounces on.
  //
  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;


  ///
  /// Graphical Model Initialization
  ///

  init_graphics();  // Our own code for initializing graphics model.


  /// Instantiate A Prism of Cards
  //
  Group* const prism = new_prism(4,texid_syl);
  groups += prism;              // Add to list of objects to displayed.
  // Below: Use transforms to position prism.
  pMatrix_Translate prism_move(pVect(12.1,0,11.4));
  pMatrix_Rotation prism_rot(pVect(0,1,0),M_PI/5);
  pMatrix_Scale prism_scale(15);
  prism->transform = prism_move * prism_rot * prism_scale;

  /// Instantiate and Position A Tower of Prisms of Cards
  //
  Group* const tower = new_tower(5,15,texid_syl);
  groups += tower;              // Add to list of objects to display.
  // Specify transform. The code below is in a more compact form
  // than the code setting prism->transform, above.
  tower->transform = pMatrix_Translate(pVect(6.8,0,21.8)) * pMatrix_Scale(10);

  texid_a = pBuild_Texture_File("mult.png", false,-1);
  texid_b = pBuild_Texture_File("mult.png", false,-1);
  texid_c = pBuild_Texture_File("mult.png", false,-1);


}


Group*
new_prism(int num_sides, int texid)
{
  // Arrange cards to form a prism.

  Group* const prism = new Group();

  const double card_width = 8.5 * 0.0254;  // Convert 8.5 inches to meters.
  const double card_height = 11 * 0.0254;  // Convert 11 inches to meters.

  const double theta = 2 * M_PI / num_sides;
  const double theta_2 = theta / 2;

  const double radius = card_width / ( 2 * sin( theta_2 ) );
  const float a = radius * cos( theta_2 );

  // Note that the lower left of the card is at the origin and lower
  // edge on positive x-axis.
  //
  pMatrix_Translate center_card(pVect(-card_width/2,0,0));
  pMatrix_Translate card_to_circle(pVect(0,0,a));
  pMatrix_Rotation rotate(pVect(0,1,0),theta);

  pMatrix position_side_i = card_to_circle * center_card;

  for ( int side = 0; side < num_sides; side++ )
    {
      Card2* const c = new Card2(card_width,card_height);

      c->texid = texid;      // Specify texture used to decorate card.
      c->color = pColor(0.9,0.9,0.9);

      // Specify transform from card's coordinate system to prism's system.
      //
      c->transform = position_side_i;

      prism->contents.push_back( c );  // Add card to prism's contents.

      position_side_i = rotate * position_side_i;
    }
  return prism;
}

Group*
new_tower
(int num_sides, int layers, int texid)
{
  // Arrange prisms for form a tower.

  Group* const tower = new Group();
  const double card_height = 11 * 0.0254;
  for ( int i=0; i<layers; i++ )
    {
      Group* const p = new_prism(num_sides, texid);
      tower->contents.push_back( p );
      p->transform =
        pMatrix_Translate(0,card_height*i,0)
        * pMatrix_Rotation(pVect(0,1,0),i*M_PI/10);
    }
  return tower;
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
