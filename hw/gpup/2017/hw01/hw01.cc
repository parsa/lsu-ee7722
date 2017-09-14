/// LSU EE 4702-1 (Fall 2017), GPU Programming
//
 /// Homework 1
 //

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2017/hw01.pdf


/// Purpose
//
//   Demonstrate simulation of point masses connected by springs.


/// What Code Does

// Simulates balls connected by springs over a platform. Balls and
// springs can be initialized in different arrangements (called
// scenes). Currently scene 1 is a simple string of beads. The
// platform consists of tiles, some are purple-tinted mirrors (showing
// a reflection of the ball), the others show the course syllabus.



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
  Ball():velocity(pVect(0,0,0)),locked(false),persistant(false),
         color(color_lsu_spirit_gold),contact(false){};
  pCoor position;
  pVect velocity;

  float mass;
  float mass_min; // Mass below which simulation is unstable.
  float radius;

  bool locked;
  bool persistant;  // Don't delete it when resetting scenes.

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
typedef pVectorI<Ball> Balls;
typedef pVector<pCoor> pCoors;
typedef pVector<pVect> pVects;

#include "hw01-graphics.cc"


void
World::init()
{
  chain_length = 14;

  opt_height = 1;
  variable_control.insert_linear(opt_height,"Volcano height (opt_height)",0.04);

  opt_e = 0.3;
  variable_control.insert(opt_e,"Volcano exponent (opt_e)");

  opt_layers = 8;
  variable_control.insert(opt_layers,"Volcano num layers (opt_layers)",1,2);

  opt_time_step_duration = 0.0003;
  //  variable_control.insert(opt_time_step_duration,"Time Step Duration");

  distance_relaxed = 15.0 / chain_length;
  opt_spring_constant = 15000;
  variable_control.insert(opt_spring_constant,"Spring Constant");

  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  variable_control.insert(opt_gravity_accel,"Gravity");

  opt_air_resistance = 0.04;
  //  variable_control.insert(opt_air_resistance,"Air Resistance");

  world_time = 0;
  time_step_count = 0;
  last_frame_wall_time = time_wall_fp();
  frame_timer.work_unit_set("Steps / s");

  init_graphics();

  pCoor marker_pos(13.4,15.8,-9.2);
  balls += marker_red = make_marker(marker_pos,color_red);
  marker_pos.y += 2 * marker_red->radius;
  balls += marker_blue = make_marker(marker_pos,color_blue);
  marker_pos.y += 2 * marker_red->radius;
  balls += marker_khaki = make_marker(marker_pos,color_khaki);

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
  ball->persistant = true;
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
  for ( Ball *ball: balls ) ball->spring_constant_sum = 0;
  const double dtis = pow( opt_time_step_duration, 2 );
  for ( Link *link: links )
    {
      Ball* const b1 = link->ball1;
      Ball* const b2 = link->ball2;
      b1->spring_constant_sum += opt_spring_constant;
      b2->spring_constant_sum += opt_spring_constant;
    }
  for ( Ball *ball: balls )
    ball->mass_min = ball->spring_constant_sum * dtis;
}

void
World::render_p0()
{
  /// Use this code for minor experiments, or leave it unchanged.

  // Make sure that this scene set the thing_1 positions.
  if ( !thing_1_apex ) return;

  pCoor apex = thing_1_apex->position;
  pCoor base = thing_1_base->position;
  vector<pCoor> ring;
  for ( Ball *b: thing_1_ring ) ring.push_back(b->position);

  glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_gray);

  glBegin(GL_TRIANGLES);

  for ( pCoor circ: ring )
    {
      pNorm norm = cross(apex,circ,base);

      glColor3fv(color_red);

      glNormal3fv(norm);
      glVertex3fv(apex);
      if ( opt_tryout1 ) glColor3fv( color_lsu_spirit_gold );
      glVertex3fv(base);
      glVertex3fv(circ);

    }
  glEnd();
}

void
World::render_p1()
{
  /// Put Problem 1 solution in this routine.

  // Make sure that this scene set the thing_1 positions.
  if ( !thing_1_apex ) return;

  pCoor apex = thing_1_apex->position;
  pCoor base = thing_1_base->position;
  vector<pCoor> ring;
  for ( Ball *b: thing_1_ring ) ring.push_back(b->position);

  glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_gray);

  glBegin(GL_TRIANGLES);

  for ( int i=0; i<3; i++ )
    {
      pCoor circ = ring[i];

      pNorm norm = cross(apex,circ,base);

      // Compute the center of the triangle ..
      //
      pVect ab(apex,base);
      pVect ac(apex,circ);
      pCoor mid = apex + ( ab + ac ) / 3;

      // .. and drop a marker there.
      //
      switch ( i ) {
        case 0: marker_red->position = mid; break;
        case 1: marker_blue->position = mid; break;
        case 2: marker_khaki->position = mid; break;
      }

      /// Homework 1 Hint: Use markers to help debug your code.

      glColor3fv(color_red);

      glNormal3fv(norm);
      glVertex3fv(apex);
      glVertex3fv(base);
      glVertex3fv(circ);

    }

  glEnd();
}

void
World::render_p2()
{
  /// Put Problem 2 solution in this routine.

  // Make sure that this scene set the thing_1 positions.
  if ( !thing_1_apex ) return;

  pCoor apex = thing_1_apex->position;
  pCoor base = thing_1_base->position;
  vector<pCoor> ring;
  for ( Ball *b: thing_1_ring ) ring.push_back(b->position);

  glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_gray);


  glBegin(GL_TRIANGLES);

  for ( int i=0; i<3; i++ )
    {
      pCoor circ = ring[i];

      pNorm norm = cross(apex,circ,base);

      // Compute the center of the triangle ..
      //
      pVect ab(apex,base);
      pVect ac(apex,circ);
      pCoor mid = apex + ( ab + ac ) / 3;

      // .. and drop a marker there.
      //
      switch ( i ) {
        case 0: marker_red->position = mid; break;
        case 1: marker_blue->position = mid; break;
        case 2: marker_khaki->position = mid; break;
      }

      /// Homework 1 Hint: Use markers to help debug your code.

      glColor3fv(color_red);

      glNormal3fv(norm);
      glVertex3fv(apex);
      glVertex3fv(base);
      glVertex3fv(circ);

    }

  glEnd();
}


void
World::objects_erase()
{
  thing_1_apex = NULL;
  thing_1_ring.clear();
  thing_1_pseudo.clear();
  Balls save;
  for ( auto b: balls ) if ( b->persistant ) save += b; else delete b;
  balls = move(save);
  links.erase();
  chain_starts.clear();
}

///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

void
World::ball_setup_1()
{
  // Arrange and size balls to form a cable suspended between two fixed points.

  pCoor first_pos(7.2,7.8,-20.2);

  pVect head_to_tail(25,0,3.33333);
  const int len = 5;
  pVect delta_pos = head_to_tail / len;

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();

  Balls persist = move(balls);
  pCoor marker_pos = first_pos + head_to_tail + pVect(0,1,0);
  for ( Ball *marker : persist )
    { marker->position = marker_pos; marker_pos.y += 2 * marker_red->radius; }

  auto new_ball = [&](pCoor pos)
    {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = balls += new Ball;

      // Initialize position and other information.
      //
      ball->position = pos;
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
      return ball;
    };

  for ( int i=0; i<=len; i++ )
    {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = new_ball(first_pos + i * delta_pos);

      // If it's not the first ball link it to the previous ball.
      if ( i > 0 ) links += new Link( ball, balls[i-1] );
    }

  // The balls pointed to by head_ball and tail_ball can be manipulated
  // using the user interface (by pressing 'h' or 't', for example).
  // Set these variables.
  //
  head_ball = balls[0];
  tail_ball = balls[balls-1];

  const int obj_idx = max(1,len - 1 - len / 5);
  Ball* const b0 = balls[obj_idx];
  Ball* const b1 = balls[obj_idx+1];
  pCoor pc = b1->position - 0.2 * delta_pos;
  thing_1_apex = b0;
  thing_1_base = b1;
  thing_1_base->color = color_black;
  pVect ayraw(0,1,0);
  pNorm ax = delta_pos;
  pNorm az = cross(ax,ayraw);
  pNorm ay = cross(az,ax);
  const double rrad = 4;
  const int n = 3;
  Balls ring;
  for ( int i=0; i<n; i++ )
    {
      const double theta = i * 2 * M_PI / n;
      Ball* const ball =
        new_ball( pc + rrad * cos(theta) * ay + rrad * sin(theta) * az );
      ball->color = color_lime_green;
      ring += ball;
      links += new Link( b0, ball );
      links += new Link( b1, ball );
    }
  thing_1_ring = ring;
  for ( int i=0; i<n; i++ )
    links += new Link( ring[i], ring[(i+1)%n] );

  opt_head_lock = true;    // Head ball will be frozen in space.
  opt_tail_lock = true;    // Tail ball too.

  balls += persist;
}


void
World::ball_setup_2()
{
  // Arrange and size balls to form a pendulum.

  pCoor first_pos(5.1,17.8,-13.1);
  pNorm delta_dir = pVect(1,-1,0);
  pVect delta_pos = distance_relaxed * delta_dir;

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();
  Balls persist = move(balls);

  int i;
  for ( i=0; i<chain_length/2; i++ )
    {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = balls += new Ball;

      // Initialize position and other information.
      //
      ball->position = first_pos + i * delta_pos;

      // If it's not the first ball link it to the previous ball.
      if ( i > 0 ) links += new Link( ball, balls[i-1] );
    }

  int sides = 4;
  pNorm hx = delta_pos.x
    ? pVect(-delta_pos.y,delta_pos.x,0) : pVect(0, -delta_pos.z,delta_pos.y);
  pNorm hy = cross(delta_pos,hx);
  Ball* const l1 = balls.back();
  for ( int i=0; i<sides; i++ )
    {
      const double angle = i * 2 * M_PI / sides;
      Ball* const ball = balls += new Ball;
      chain_starts += ball;
      ball->position =
        l1->position + delta_pos
        + 2 * distance_relaxed * cos(angle) * hx
        + 2 * distance_relaxed * sin(angle) * hy;
      links += new Link( ball, l1 );
      if ( i > 0 )
        links += new Link( ball, chain_starts[i-1] );
      if ( i > 1 && i == sides - 1 )
        links += new Link( ball, chain_starts[0] );
      if ( sides > 3 && i > sides/2 )
        links += new Link( ball, chain_starts[i-sides/2] );
    }

  for ( int i=1; i<chain_length/2; i++ )
    for ( int j=0; j<sides; j++ )
      {
      // Construct a new ball and add it to the simulated objects list (balls).
      //
      Ball* const ball = balls += new Ball;

      // Initialize position and other information.
      //
      ball->position = chain_starts[j]->position + i * delta_pos;

      // If it's not the first ball link it to the previous ball.
      links += new Link( ball, balls[balls-sides-1] );
    }

  for ( Ball* ball : balls )
    {
      ball->locked = false;
      ball->velocity = pVect(0,0,0);
      ball->radius = 0.3;
      ball->mass = 4/3.0 * M_PI * pow(ball->radius,3);
      ball->contact = false;
    }

  // The balls pointed to by head_ball and tail_ball can be manipulated
  // using the user interface (by pressing 'h' or 't', for example).
  // Set these variables.
  //
  head_ball = balls[0];
  tail_ball = balls[balls-1];

  opt_head_lock = true;    // Head ball will be frozen in space.
  opt_tail_lock = false;   // Tail ball can move freely.

  balls += persist;

}


void
World::ball_setup_3()
{
}

void
World::ball_setup_4()
{
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

  for ( Ball *ball: balls )
    ball->force = ball->mass * gravity_accel;

  for ( Link *link: links )
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

  for ( Ball *ball: balls )
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
{ for ( Ball *ball: balls ) ball->translate(amt); }
void World::balls_push(pVect amt)
{ for ( Ball *ball: balls ) ball->push(amt); }
void World::balls_stop()
{ for ( Ball *ball: balls ) ball->stop(); }
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
