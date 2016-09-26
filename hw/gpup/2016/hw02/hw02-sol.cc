/// LSU EE 4702-1 (Fall 2016), GPU Programming
//
 /// Homework 2 -- SOLUTION
 //

 /// Instructions
 //
 //  Read the assignment: http://www.ece.lsu.edu/koppel/gpup/2016/hw02.pdf


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
typedef pVector<pCoor> pCoors;
typedef pVector<pVect> pVects;

#include "hw02-graphics.cc"


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

  pNorm dir_right = cross(pVect(0,-1,0),eye_direction);

  pCoor first_pos(13.4,15.8,-9.2);

  const float sample_size = 4;
  const float sample_thickness = sample_size / 10;
  pVect sample_x = sample_size * dir_right;
  pCoor sample_start = first_pos - 3.3 * 1.5 * sample_x;
  for ( int i=0; i<3; i++ )
    {
      sample_a[i] = sample_start + sample_x * i * 1.5;
      sample_b[i] = sample_a[i] - pVect(0,sample_size,0);
      sample_c[i] = sample_a[i] + sample_thickness * dir_right;
    }

  auto tr = [&](pCoor *co) { co[0] = co[-3] + pVect(0,-first_pos.y/2,0); };
  for ( int i=3; i<6; i++ ) { tr(sample_a+i);tr(sample_b+i);tr(sample_c+i);}

  ball_setup_2();
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

void
World::render_it_demo(pCoor a, pCoor b, pCoor c, int version)
{
  /// DO NOT put homework solution in this routine.
  //
  //  This routine can be modified for experimentation, but don't
  //  put solution here. The solution should go in to render_it.

  pNorm dir_z = cross(c,b,a);
  glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_gray);

  glBegin(GL_TRIANGLES);
  glColor3fv(color_red);
  glNormal3fv(dir_z);
  glVertex3fv(a);
  glVertex3fv(b);
  glVertex3fv(c);
  glEnd();

  if ( version == 0 ) return;

  // Add coordinates to a container (something based on a standard C
  // library vector) so they can be easily iterated over.
  pCoors coords;
  coords += a;
  coords += b;
  coords += c;

  // Create a second set of coordinates by translating first set.
  pCoors more_coords;
  for ( pCoor co: coords ) more_coords += co + pVect(0.5,0,0);

  // Take the original coordinates and rotate them, and
  // put these new coordinates in more_coords.
  //
  pMatrix_Rotation rot(dir_z, M_PI/10);  // Rotation transform around dir_z.
  pMatrix m = pMatrix_Translate(b) * rot * pMatrix_Translate(-b);
  if ( version == 2 )
    for ( pCoor co: coords ) more_coords += m * co;

  // Render the transformed coordinates.
  glBegin(GL_TRIANGLES);
  glColor3fv(color_cyan);
  glNormal3fv(dir_z);
  for ( pCoor co: more_coords ) glVertex3fv( co );
  glEnd();

}

void
World::render_it(pCoor a, pCoor b, pCoor c, int version)
{
  pNorm dir_z = cross(c,b,a);

  pNorm dir_dn(a,b);
  pNorm dir_rt(a,c);  // Right

  /// SOLUTION

  //
  /// Construct L shape.
  //
  float edge_len = dir_dn.magnitude;

  float width = dir_rt.magnitude;
  float hwidth = width / 2;

  // Naming scheme:
  //   l0: Point on left edge,
  //   l1: point a bit over to the right of l0,...
  //   r0, t0, b0: point on right, top, bottom edge respectively.
  //   
  pCoor p_l0t2 = a + width * dir_dn;
  pCoor p_l1t1 = a + hwidth * ( dir_rt + dir_dn );
  pCoor p_l2t0 = a + width * dir_rt;
  pCoor p_l2t2 = p_l2t0 + width * dir_dn;
  pCoor p_l2b2 = c + (edge_len - width ) * dir_dn;
  pCoor p_r2b0 = b + (edge_len - width ) * dir_rt;
  pCoor p_r2b2 = p_r2b0 - width * dir_dn;
  pCoor p_r1b1 = p_r2b0 + hwidth * ( dir_rt - dir_dn );
  pCoor p_r0b0 = b + edge_len * dir_rt;

  pCoors coords;
  coords += p_l2t0;
  coords += a;
  coords += p_l1t1;
  coords += p_l0t2;
  coords += p_l2t2;
  coords += b;
  coords += p_l2b2;
  coords += p_r2b0;
  coords += p_r2b2;
  coords += p_r1b1;

  glColorMaterial(GL_FRONT,GL_AMBIENT_AND_DIFFUSE);
  glMaterialfv(GL_BACK,GL_AMBIENT_AND_DIFFUSE,color_gray);

  // Find center of square to be formed using two L shapes.
  //
  pCoor p_ctr = a + 0.5 * pVect(a,p_r0b0);

  if ( version > 0 )
    {
      // Construct transformation matrix that will rotate L shape into
      // position.

      pMatrix m =
        pMatrix_Translate(p_ctr)
        * pMatrix_Rotation(dir_z,M_PI) * pMatrix_Translate(-p_ctr);

      // Use transformation to add rotated points on to list.
      //
      for ( pCoor co: pCoors(coords) ) coords +=  m * co;
    }

  if ( version < 2 )
    {
      // Render the L or the square.

      glBegin(GL_TRIANGLE_STRIP);
      glColor3fv(color_yellow);
      glNormal3fv(dir_z);
      for ( pCoor co: coords ) glVertex3fv( co );
      glEnd();
      return;
    }

  pCoor cube_ctr = p_ctr - 0.5 * edge_len * dir_z;

  // Rotate the square to form a cube.

  for ( int axis_num = 0; axis_num < 2; axis_num++ )
    {
      pVect axis = axis_num == 0 ? dir_dn : dir_rt;
      for ( int face = 0;  face < 4;  face++ )
        {
          if ( axis_num == 1 &&  ( ( face & 1 ) == 0 ) ) continue;
          const double angle = face * M_PI / 2;
          pMatrix_Rotation rot(axis,angle);
          pMatrix m =
            pMatrix_Translate(cube_ctr) * rot * pMatrix_Translate(-cube_ctr);

          glBegin(GL_TRIANGLE_STRIP);
          glColor3fv(color_yellow);

          // Use rot, not m, to rotate normal. (Vectors don't need to
          // be centered.)
          glNormal3fv(rot * dir_z);

          // Rotate coordinates.
          //
          for ( pCoor co: coords ) glVertex3fv( m * co );

          glEnd();
        }
    }
}


void
World::objects_erase()
{
  balls.erase();
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
  // Arrange and size balls to form a pendulum.

  pCoor first_pos(13.4,17.8,-9.2);
  pVect delta_pos = pVect(distance_relaxed,0,0);

  // Remove objects from the simulated objects lists, balls and links.
  // The delete operator is used on objects in the lists.
  //
  objects_erase();

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
