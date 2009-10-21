/// LSU EE 4702-1 (Fall 2009), GPU Programming
///
/// Homework 2 SOLUTION


/// Solution Overview

 /// Seam Geometry

// Seam shape is approximately rectangular, see the illustration below
// in which the T's show the tiles, and the S's are the seams.

// There are two sets of seams, axial seams, which are straight and
// are parallel to the z axis, and the circumferential seams, which
// are semi-circular. For axial seams the z axis is normal to the
// screen (passes through it), for circumferential seams the z axis
// goes from left to right (or right to left).

// Each seam is divided into five surfaces, three that are planar,
// S1, S2, and S4; and two that are lines, S3 and S6.

//               S2
//   S3 ----\    |         /--- S6 (the corner)
//           SSSSSSSSSSSSSS                     _
//           S            S                     |
//    S1 ->  S            S  <- S4           height
//           S            S                     |
//   TTTTTTTTT            TTTTTTTTT  <- tile    _
//           |<- width -->|

// The seam shape is determined by two parameters, opt_seam_height
// and opt_seam_width.

// Seam coordinates are computed in routine platform_update. Two sets
// of coordinates are computed, one for rendering and one for
// collision detection. The coordinates for rendering are kept in
// object platform_seam_coords and object platform_seam_norms, the
// coordinates for collision detection are kept in array seam_info.

 /// Seam Rendering

// Seams are rendered using quads (four-vertex primitives) by the code
// in routine World::render.

// Both circumferential and axial seams are rendered in sections
// matching the tile size. Rendering in sections was necessary for the
// circumferential seams because they are curved. Each axial seam
// could have been rendered with just three long quads, but was
// rendered using multiple quads for better lighting
// appearance. (Lighting calculations are only performed on primitive
// vertices, which would be far apart in axial seams rendered with
// just three quads.)


 /// Collision Detection and Resolution

// The following are the steps for collision detection and
// resolution.  See the routine time_step_cpu_ball for details.

//  o  Determine closest axial and circumferential seam.

//  o  Determine where ball is relative to each seam (left, right, or above).

//  o  Based on relative position determine which surface can
//     be in contact (S1, S2, S3, S4, or S6 ).

//  o  Find closest point on surface to ball.

//  o  If point is further than ball radius, no collision.

//  o  Adjust velocity to account for bounce.

//  o  Move ball to surface.



// The ball can hit each seam in one of five ways, corresponding
// to the surfaces shown in the illustration above. There are two
// kinds of collision, to a plane or to an edge (line).




/// Problem 1
//
 /// Show seams graphically.

// Show graphically the seam between tiles that was just in the
// physical model of Homework 1. The graphical representation should
// make it easy to see when the ball hits a seam. It would also be
// nice if it looked like some kind of seam, say grout or some kind of
// separator.

// [ ] Pre-compute an array of coordinates for the seam in platform_update.
// [ ] Choose colors and other styling appropriate for the seam.
// [ ] Code should be clean and fast.


/// Problem 2
//
 /// Improve Homework 1 Physics

// Re-solve homework 1 so that the ball bounces as it hits the
// seam and does so in a realistic manor.

// [ ] Don't compute the distance from the ball to axis more than once.
// [ ] Reflect velocity of ball based on point of impact.


/// Problem 3
//
 /// Show some indication of ball impact on seam.

// Change the appearance of the seam to indicate location ball impact.
// The change in appearance should be at the correct location
// and should be interesting to look at.

// [ ] Change in appearance with impact.

 /// Optional

// [ ] Base change in appearance on speed and angle of ball impact.
// [ ] Have change fade with time.




/// What Code Does

// Simulates balls bouncing over a curved platform. The platform
// consists of tiles and the shape is a half cylinder.


///  Keyboard Commands
 //
 /// Object (Eye, Light, Ball) Location or Push
 //   Arrows, Page Up, Page Down
 //   Will move object or push ball, depending on mode:
 //   'e': Move eye.
 //   'l': Move light.
 //   'b': Move a ball. (Change position but not velocity.)
 //   'B': Push a ball. (Add velocity.)
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
 //  'x'    Release another ball. (Try holding it in.)
 //  'n'    Toggle visibility of platform normals.
 //  's'    Stop balls.
 //  'g'    Turn gravity on and off.
 //  'F11'  Change size of text.
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
 //  VAR Ball Radius


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
#include "shapes.h"



///
/// Main Data Structures
///
//
// class World: All data about scene.


class World;



/// SOLUTION -- Seam Geometry Data Structures
//

// Seam shape is approximately rectangular.

// Structure describing surface of seam. Each seam has five useful
// surfaces: three planes and two lines (where two planes meet).
//
struct Seam_Surface {

  // If true, surface is a plane, otherwise it's a line.
  bool plane;

  // A point on the surface.
  pCoor point;                    

  // For planes, the surface normal.
  // For lines, a vector in the direction of the line.
  pVect norm;                    

};

// Structure describing a seam.
//
struct Seam {
  Seam_Surface surface[8];
};


// Structure describing place where ball collides with seam.
//
struct Collision_Marker {
  pCoor center;                 // Location that ball strikes.
  pVect bounce_dv;              // Change in velocity with collision.
  float r;                      // Radius of collision marker.
  double t;                     // Time of collision.
};


// Object Holding Ball State
//
class Ball {
public:
  Ball();
  pCoor position;
  pVect velocity;

  bool contact;                 // If true, in contact with platform.
  int row_num, col_num;         // Refers to tile.

  pVect axis;                   // Direction of ball's axis.
  double angle;                 // Angle around axis.

  void push(pVect amt);
  void translate(pVect amt);
  void stop();
  void freeze();
};

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  static void render_w(void *moi){ ((World*)moi)->render(); }
  void render();
  void cb_keyboard();
  void modelview_update();

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  float opt_gravity_accel;      // Value chosen by user.
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  bool opt_gravity;

  float opt_ball_radius;

  // Tiled platform for ball.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_xmid, platform_xrad, platform_xrad_inv;
  float delta_theta_inv, tile_size_inv;
  float platform_pi_xwidth_inv;
  pBuffer_Object<pVect> platform_tile_norms;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  pBuffer_Object<pVect> platform_seam_coords;
  pBuffer_Object<pVect> platform_seam_norms;
  GLuint texid_syl;
  GLuint texid_emacs;
  bool opt_normals_visible;
  void platform_update();
  bool platform_collision_possible(pCoor pos);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix modelview_shadow;

  double ball_countdown;

  void ball_init();
  void balls_render();
  void balls_stop();
  void time_step_cpu(double);
  void time_step_cpu_ball(double delta_t, Ball* ball);

  PStack<Ball*> balls;
  Sphere sphere;
  Cone cone;                    // Used to show platform normals.

  Seam *seam_info;
  PQueue<Collision_Marker> collision_markers;
  double marker_lifetime;
  float marker_lifetime_inv;
  int row_cnt;
  float opt_seam_height;
  float opt_seam_width;
  float opt_energy_loss;
  float bounce_factor;
};

void
World::init()
{
  seam_info = NULL;
  frame_timer.work_unit_set("Steps / s");
  world_time = 0;
  opt_gravity_accel = 9.8;
  opt_gravity = true;
  gravity_accel = pVect(0,-opt_gravity_accel,0);
  opt_normals_visible = false;

  eye_location = pCoor(17.9,-2,117.2);
  eye_direction = pVect(-0.15,-0.06,-0.96);

  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  texid_syl = pBuild_Texture_File("gpup.png",false,255);
  texid_emacs = pBuild_Texture_File("mult.png", false,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(28.2,-2.8,-14.3);

  opt_ball_radius = 2;

  // This was added in solution to make the ball less lively.
  // It wasn't necessary for the solution.
  opt_energy_loss = 0.5;
  bounce_factor = 2 - opt_energy_loss;

  /// SOLUTION - Initialize variables.
  //
  opt_seam_height = 1.5;
  opt_seam_width = 0.2;

  // Number of seconds that collision marker visible.
  marker_lifetime = 10;
  marker_lifetime_inv = 1/marker_lifetime;

  variable_control.insert(opt_seam_height,"Seam Height");
  variable_control.insert(opt_seam_width,"Seam Width");
  variable_control.insert(opt_gravity_accel,"Gravity");
  variable_control.insert(opt_light_intensity,"Light Intensity");
  variable_control.insert(opt_ball_radius,"Ball Radius");
  variable_control.insert(opt_energy_loss,"Energy Loss");

  opt_move_item = MI_Eye;
  opt_pause = false;

  ball_countdown = 1e10;
  balls += new Ball();
  sphere.init(40);   // Argument indicates amount of detail.
  sphere.radius = opt_ball_radius;

  platform_update();
  modelview_update();

}

void
World::platform_update()
{
  const float tile_count = 19;
  const float ep = 1.00001;
  const float platform_delta_x = platform_xmax - platform_xmin;
  const float zdelta = ( platform_zmax - platform_zmin ) / tile_count * ep;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<pVect> p_tile_norms;
  PStack<pVect> p1_tile_norms;
  PStack<float> p_tex_coords;
  bool even = true;
  platform_pi_xwidth_inv = M_PI / platform_delta_x;

  const double delta_theta = M_PI / tile_count;
  delta_theta_inv = 1.0 / delta_theta;
  tile_size_inv = 1 / zdelta;
  platform_xmid = 0.5 * ( platform_xmax + platform_xmin );
  platform_xrad = 0.5 * platform_delta_x;
  platform_xrad_inv = 1 / platform_xrad;

  row_cnt = int(tile_count);
  const float platform_srad = platform_xrad - opt_seam_height;
  const double seam_delta_theta = 0.5 * opt_seam_width / platform_srad;
  pVect z_depth(0,0,platform_zmax-platform_zmin);

  /// SOLUTION
  //
  // Seam coordinates and normals.
  //
  PStack<pVect> s_coords;
  PStack<pVect> s_norms;
  //
  // Information about seam surfaces.
  //
  seam_info = new Seam[ row_cnt * ( row_cnt + 1 ) ];

  for ( int i = 0; i < tile_count; i++ )
    {
      const double theta0 = i * delta_theta;
      const double theta1 = theta0 + delta_theta;
      const float x0 = platform_xmid - platform_xrad * cos(theta0);
      const float x1 = platform_xmid - platform_xrad * cos(theta1);
      const float y0 = -0.01 - platform_xrad * sin(theta0);
      const float y1 = -0.01 - platform_xrad * sin(theta1);
      pVect norm0( cos(theta0), sin(theta0), 0);
      pVect norm1( cos(theta1), sin(theta1), 0);


      /// SOLUTION - Find Seam Coordinates
      //
      const double s_th_a = theta0 - seam_delta_theta;
      const double s_th_b = theta0 + seam_delta_theta;

      const float x0s = platform_xmid - platform_srad * cos(theta0);
      const float x1s = platform_xmid - platform_srad * cos(theta1);
      const float y0s = -0.01 - platform_srad * sin(theta0);
      const float y1s = -0.01 - platform_srad * sin(theta1);

      pCoor p0(platform_xmid - platform_xrad * cos(s_th_a),
               -0.01 - platform_xrad * sin(s_th_a),
               platform_zmin);
      pCoor p1(platform_xmid - platform_srad * cos(s_th_a),
               -0.01 - platform_srad * sin(s_th_a),
               platform_zmin);
      pCoor p2(platform_xmid - platform_srad * cos(s_th_b),
               -0.01 - platform_srad * sin(s_th_b),
               platform_zmin);
      pCoor p3(platform_xmid - platform_xrad * cos(s_th_b),
               -0.01 - platform_xrad * sin(s_th_b),
               platform_zmin);

      pNorm snorm1 = cross(p0,p1,p0 + z_depth);
      pVect snorm2 = norm0;
      pNorm snorm4 = cross(p2,p3,p2 + z_depth);

#define SQ(P,Q,N)                                                             \
      s_coords += P + z_i;  s_coords += P + z_ni;                             \
      s_coords += Q + z_ni; s_coords += Q + z_i;                              \
      s_norms += N;  s_norms += N;  s_norms += N;  s_norms += N;

      for ( float z = platform_zmin; z < platform_zmax; z += zdelta )
        {
          pVect z_i(0,0,z-platform_zmin);
          pVect z_ni(0,0,z+zdelta-platform_zmin);
          SQ(p0,p1,snorm1); SQ(p1,p2,snorm2); SQ(p2,p3,snorm4);
        }

#undef SQ

      // Store information about seam surfaces.

      Seam_Surface* const su = seam_info[i].surface;

      su[1].point = p1;
      su[1].norm = snorm1;
      su[1].plane = true;

      su[2].point = p1;
      su[2].norm = snorm2;
      su[2].plane = true;

      su[3].point = p1;
      su[3].norm = pVect(0,0,1);
      su[3].plane = false;

      su[4].point = p2;
      su[4].norm = snorm4;
      su[4].plane = true;

      su[6].point = p2;
      su[6].norm = pVect(0,0,1);
      su[6].plane = false;


      for ( int row = 0;  row < row_cnt;  row++ )
        {
          const float z = platform_zmin + row * zdelta;
          PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
          PStack<pVect>& t_norms = even ? p_tile_norms : p1_tile_norms;
          p_tex_coords += trmax; p_tex_coords += tsmax;
          t_coords += pVect(x0,y0,z);
          t_norms += norm0;  t_norms += norm0;
          p_tex_coords += trmax; p_tex_coords += tsmin;
          t_coords += pVect(x0,y0,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmin;
          t_coords += pVect(x1,y1,z+zdelta);
          t_norms += norm1;  t_norms += norm1;
          p_tex_coords += trmin; p_tex_coords += tsmax;
          t_coords += pVect(x1,y1,z);
          even = !even;


          /// SOLUTION

          // Find seam coordinates.

          const float z_a = z - opt_seam_width * 0.5;
          const float z_b = z + opt_seam_width * 0.5;

          pCoor p0(x0,y0,z_a);
          pCoor p1(x0s,y0s,z_a);
          pCoor p2(x0s,y0s,z_b);
          pCoor p3(x0,y0,z_b);

          pCoor p4(x1,y1,z_a);
          pCoor p5(x1s,y1s,z_a);
          pCoor p6(x1s,y1s,z_b);
          pCoor p7(x1,y1,z_b);

          pVect snorm1 = pVect(0,0,-1);
          pVect snorm2 = pVect(0,0,1);

#define SQ(a,b,c,d,N1,N2)                                               \
          s_coords+=a; s_coords+=b; s_coords+=c; s_coords+=d;           \
          s_norms += N1;  s_norms += N1;  s_norms += N2;  s_norms += N2;

          SQ(p0,p1,p5,p4,snorm1,snorm1);
          SQ(p1,p2,p6,p5,norm0,norm1);
          SQ(p2,p3,p7,p6,snorm2,snorm2);
#undef SQ

          const int s_idx = ( row + 1 ) * row_cnt + i;
          Seam_Surface* const su = seam_info[s_idx].surface;
          su[1].point = p1;
          su[1].norm = snorm1;
          su[1].plane = true;

          su[2].point = p1;
          su[2].norm = 0.5 * (norm0 + norm1);
          su[2].plane = true;

          su[3].point = p1;
          su[3].norm = pVect(-sin(theta0),cos(theta0),0);
          su[3].plane = false;

          su[4].point = p2;
          su[4].norm = snorm2;
          su[4].plane = true;

          su[6].point = p2;
          su[6].norm = pVect(-sin(theta0),cos(theta0),0);
          su[6].plane = false;
        }
    }

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;
  while ( pVect* const v = p1_tile_norms.iterate() ) p_tile_norms += *v;

  platform_tile_norms.re_take(p_tile_norms);
  platform_tile_norms.to_gpu();
  platform_tile_coords.re_take(p_tile_coords);
  platform_tile_coords.to_gpu();
  platform_tex_coords.re_take(p_tex_coords);
  platform_tex_coords.to_gpu();

  /// SOLUTION
  //
  // Copy seam coordinates and normals to buffer object and send
  // to gpu.
  //
  platform_seam_coords.re_take(s_coords);
  platform_seam_coords.to_gpu();
  platform_seam_norms.re_take(s_norms);
  platform_seam_norms.to_gpu();
}

void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}


///
/// Physical Simulation Code
///

 /// Initialize Simulation
//

Ball::Ball()
{
  position = pCoor(30,22,-15.4);
  velocity = pVect(random()/(0.0+RAND_MAX),0,random()/(0.0+RAND_MAX));
  axis = pNorm(0,1,0);
  angle = 0;
}


bool
World::platform_collision_possible(pCoor pos)
{
  // Assuming no motion in x or z axes.
  //
  return pos.y < opt_ball_radius
    && pos.x >= platform_xmin && pos.x <= platform_xmax
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
void World::balls_stop()
{
  for ( Ball *ball; balls.iterate(ball); ) ball->stop();
}

void
World::time_step_cpu(double delta_t)
{
  const float deep = -100;

  // Iterate over balls.
  //
  for ( Ball *ball; balls.iterate(ball); )
    {
      // Simulate ball.
      //
      time_step_cpu_ball(delta_t,ball);

      // Remove ball if it has fallen too far.
      //
      if ( ball->position.y < deep ) { balls.iterate_yank(); delete ball; }

    }

  // Possibly add more balls to simulation.
  //
  ball_countdown -= delta_t;
  if ( ball_countdown <= 0 || balls.occ() == 0 )
    {
      balls += new Ball();
      ball_countdown = 1e10;
    }


  /// SOLUTION
  //
  // Remove old markers.
  //
  const double visible_time = world_time - marker_lifetime;
  while ( collision_markers.occ() && collision_markers.head().t < visible_time )
    collision_markers.dequeue();
}

void
World::time_step_cpu_ball(double delta_t, Ball* ball)
{
  // Compute new ball position, accounting for current speed and
  // acceleration, and assuming no collision.
  //
  ball->position +=
    ball->velocity * delta_t + 0.5 * gravity_accel * delta_t * delta_t;

  // Compute new velocity, assuming no collision.
  //
  ball->velocity += gravity_accel * delta_t;

  // Return quickly if collision impossible.
  //
  if ( !platform_collision_possible(ball->position) ) return;

  /// SOLUTION

  pNorm axis_normal(ball->position.x - platform_xmid, ball->position.y, 0);
  const float axis_dist = axis_normal.magnitude;
  const float platform_dist = platform_xrad - opt_ball_radius - axis_dist;


  // Find row and column of tiles.
  //
  const int row_num_raw =
    int( ( ball->position.z - platform_zmin ) * tile_size_inv + 0.5);
  const int row_num = max(0,min(row_cnt-1,row_num_raw));
  const double theta =
    acos( - ( ball->position.x - platform_xmid ) / axis_dist );
  const int col_num_raw = int( 0.5 + theta * delta_theta_inv );
  const int col_num = max(0,min(row_cnt-1,col_num_raw));

  // Find array index for closest circumferential seam.
  //
  const int circ_idx = ( row_num + 1 ) * row_cnt + col_num;

  for ( int dir=0; dir<2; dir++ )
    {
      const bool circ_seam = dir == 1;
      const int seam_num = circ_seam ? circ_idx : col_num;
      int idx = 0;

      // Examine the three flat surfaces, S1, S2, S4, and for each
      // determine which side ball is on.  Use this to determine
      // which surface can have collision.
      //
      for ( int p=0; p<3; p++ )
        {
          const int face = 1 << p;
          Seam_Surface* const si = &seam_info[seam_num].surface[face];
          const float dist =
            -dot( pVect(ball->position,si->point), si->norm );
          if ( dist >= 0 ) idx |= face;
        }

      Seam_Surface* const si = &seam_info[seam_num].surface[idx];

      pVect b_to_pt(ball->position,si->point);

      const float some_dist = -dot(b_to_pt,si->norm);

      pCoor tact;
      float dist;
      pVect tact_to_b;
      if ( si->plane )
        {
          tact = ball->position - some_dist * si->norm;
          tact_to_b = si->norm;
          dist = some_dist;
        }
      else
        {
          tact = si->point + some_dist * si->norm;
          tact_to_b = pVect(tact,ball->position);
          dist = tact_to_b.normalize();
        }

      if ( dist > opt_ball_radius ) continue;
      const float v_to_tact = -dot(ball->velocity,tact_to_b);
      if ( v_to_tact <= 0 ) continue;
      const float pen_dist = opt_ball_radius - dist;
      pCoor ball_contact_pos = ball->position + pen_dist * tact_to_b;
      pVect bounce_delta_v = bounce_factor * v_to_tact * tact_to_b;
      ball->velocity += bounce_delta_v;
      ball->position = ball_contact_pos;

      // Insert a marker describing collision.
      //
      Collision_Marker* const marker = collision_markers.enqueuei();
      marker->center = tact;
      marker->bounce_dv = 0.2 * bounce_delta_v;
      marker->r = 0.5;
      marker->t = world_time;
    }

  ball->contact = platform_dist < 0.5;

  // Return if ball is not in contact with platform.
  //
  if ( !ball->contact ) return;

  // Snap ball to surface.
  //
  const float z = ball->position.z;
  ball->position = ( platform_xrad - opt_ball_radius ) * axis_normal;
  ball->position.x += platform_xmid;
  ball->position.z = z;

  pVect platform_norm = -axis_normal;
  const float speed_to_surface = dot(platform_norm,ball->velocity);

  if ( speed_to_surface >= 0 ) return;

  ball->velocity -= bounce_factor * speed_to_surface * platform_norm;
  return;

#if 0
  /// SOLUTION ABOVE,  ORIGINAL CODE BELOW

  // Compute y coordinate of platform under ball.
  //
  // Note that this is not really the closest point on the platform to the ball.
  //
  const float cos_th = ( platform_xmid - ball->position.x ) * platform_xrad_inv;
  const float sin_th =  sqrt(1.0 - cos_th * cos_th );
  const float platform_y = -platform_xrad * sin_th;

  const bool contact_prev = ball->contact;
  const bool true_contact = ball->position.y <= platform_y + 0.01;
  ball->contact = ball->position.y <= platform_y + 0.5;
  if ( !ball->contact ) return;

  ball->position.y = max(ball->position.y,platform_y);
  pVect platform_norm( cos_th, sin_th, 0);

  const int row_num_prev = ball->row_num;
  const int col_num_prev = ball->col_num;
  const int row_num = int(ball->position.z * tile_size_inv);
  const int col_num = int(acos(cos_th) * delta_theta_inv);
  ball->col_num = col_num;
  ball->row_num = row_num;
  if ( contact_prev &&
       ( row_num_prev != row_num || col_num_prev != col_num ) )
    {
      // Ball has rolled from one tile to another.
    }

  if ( !true_contact ) return;

  const float speed_to_surface = dot(platform_norm,ball->velocity);

  ball->velocity -= 1.9 * speed_to_surface * platform_norm;
#endif
}

void
World::balls_render()
{
  for ( Ball *ball; balls.iterate(ball); )
    sphere.render(ball->position,ball->axis,ball->angle);
}

void
World::render()
{
  // This routine called whenever window needs to be updated.

  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

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
      const double delta_t = min(1./20,time_now - world_time);
      time_step_cpu(delta_t);
      world_time += delta_t;
    }

  /// Emit a Graphical Representation of Simulation State
  //
  
  // Understanding of the code below not required for introductory
  // lectures.

  const pColor white(0xffffff);
  const pColor gray(0x303030);
  const pColor lsu_business_purple(0x7f5ca2);
  const pColor lsu_spirit_purple(0x580da6);
  const pColor lsu_spirit_gold(0xf9b237);
  const pColor lsu_official_purple(0x2f0462);
  const pColor dark(0);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(modelview);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Frustum: left, right, bottom, top, near, far
  glFrustum(-.8,.8,-.8/aspect,.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();

  glClearColor(0,0,0,0.5);
  glClearDepth(1.0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.3);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x999999);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

  pColor color_ball(0x666666);
  pColor scolor_ball(0x111111);
  const float shininess_ball = 5;

  // Common to all textures.
  //
  glActiveTexture(GL_TEXTURE0);
  glEnable(GL_TEXTURE_2D);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,
                  GL_LINEAR_MIPMAP_LINEAR);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  glEnable(GL_RESCALE_NORMAL);
  glEnable(GL_NORMALIZE);

  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ogl_helper.fbprintf
    ("Eye location: [%5.1f, %5.1f, %5.1f]  "
     "Eye direction: [%+.2f, %+.2f, %+.2f]\n",
     eye_location.x, eye_location.y, eye_location.z,
     eye_direction.x, eye_direction.y, eye_direction.z);

  ogl_helper.fbprintf
    ("Light location: [%5.1f, %5.1f, %5.1f]\n",
     light_location.x, light_location.y, light_location.z);

  Ball& ball = *balls[0];
  ogl_helper.fbprintf
    ("Ball Pos  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]\n",
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  // Setup texture for platform.
  //
  glBindTexture(GL_TEXTURE_2D,texid_syl);

  // Blend dark tiles with existing ball reflection.
  //
  glEnable(GL_STENCIL_TEST);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_CONSTANT_ALPHA,GL_ONE_MINUS_CONSTANT_ALPHA); // src, dst
  glBlendColor(0,0,0,0.5);

  glDepthFunc(GL_ALWAYS);

  glEnable(GL_TEXTURE_2D);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  platform_tile_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  platform_tile_norms.bind();
  glNormalPointer
    (GL_FLOAT,sizeof(platform_tile_norms.data[0]), 0);
  glEnableClientState(GL_NORMAL_ARRAY);

  for ( int pass = 0;  pass < 2;  pass++ )
    {
      if ( pass == 0 )
        {
          // Prepare to write unshadowed parts of frame buffer.
          //
          glStencilFunc(GL_NOTEQUAL,1,1);
        }
      else
        {
          // Prepare to write shadowed parts of frame buffer.
          //
          glStencilFunc(GL_EQUAL,1,1);
          glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 6.0);
        }

      glEnable(GL_TEXTURE_2D);

      // Write lighter-colored, textured tiles.
      //
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,gray);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
      glColor3f(0.35,0.35,0.35);
      glDrawArrays(GL_QUADS,0,half_elements+4);

      // Write darker-colored, untextured, mirror tiles.
      //
      glEnable(GL_BLEND);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,white);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,20);
      glDisable(GL_TEXTURE_2D);
      glColor3fv(lsu_spirit_purple);
      glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
      glDisable(GL_BLEND);
    }

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glDisable(GL_STENCIL_TEST);
  glDepthFunc(GL_LESS);


  /// SOLUTION - Render Seams
  //
  platform_seam_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_seam_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  platform_seam_norms.bind();
  glNormalPointer
    (GL_FLOAT,sizeof(platform_seam_norms.data[0]), 0);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glEnableClientState(GL_NORMAL_ARRAY);
  glColor3f(0.9,0.9,0.9);
  glDrawArrays(GL_QUADS,0,platform_seam_coords.elements);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);

  // Render Ball
  //
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glMaterialf(GL_BACK,GL_SHININESS,shininess_ball);
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid_emacs);

  balls_render();

  /// SOLUTION - Render Collision Locations
  //
  glDisable(GL_TEXTURE_2D);
  glColor4fv(lsu_spirit_purple);
  for ( Collision_Marker c; collision_markers.iterate(c); )
    cone.render(c.center,c.r,c.bounce_dv);

  if ( opt_normals_visible )
    {
      glColor3fv(lsu_spirit_gold);
      for ( int i=0; i<platform_tile_coords.elements; i++ )
        cone.render(platform_tile_coords[i],0.2,5 * platform_tile_norms[i]);
    }

  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  glDisable(GL_LIGHTING);
  glDisable(GL_BLEND);
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_STENCIL_TEST);
  frame_timer.frame_end();

  glutSwapBuffers();
}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const float move_amt = 0.4;
  const float prev_seam_width = opt_seam_width;
  const float prev_seam_height = opt_seam_height;

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -move_amt; break;
  case FB_KEY_RIGHT: adjustment.x = move_amt; break;
  case FB_KEY_PAGE_UP: adjustment.y = move_amt; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -move_amt; break;
  case FB_KEY_DOWN: adjustment.z = move_amt; break;
  case FB_KEY_UP: adjustment.z = -move_amt; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case 'b': opt_move_item = MI_Ball; break;
  case 'B': opt_move_item = MI_Ball_V; break;
  case 'e': case 'E': opt_move_item = MI_Eye; break;
  case 'g': case 'G': opt_gravity = !opt_gravity; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_normals_visible = !opt_normals_visible; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 's': balls_stop(); break;
  case 'x': case 'X': balls += new Ball(); break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;
  sphere.radius = opt_ball_radius;
  opt_energy_loss = max(0.0f,min(1.0f,opt_energy_loss));
  bounce_factor = 2 - opt_energy_loss;

  /// SOLUTION - Recompute platform if seam parameters change.
  //
  if ( opt_seam_height != prev_seam_height
       || opt_seam_width != prev_seam_width ) platform_update();

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(eye_direction,pVect(0,0,-1));
      user_rot_axis *= invert(rotall);
      eye_direction *= pMatrix_Rotation(user_rot_axis, M_PI * 0.03);
      modelview_update();
    }

  // Update eye_location based on keyboard command.
  //
  if ( adjustment.x || adjustment.y || adjustment.z )
    {
      const double angle =
        fabs(eye_direction.y) > 0.99
        ? 0 : atan2(eye_direction.x,-eye_direction.z);
      pMatrix_Rotation rotall(pVect(0,1,0),-angle);
      adjustment *= rotall;

      switch ( opt_move_item ){
      case MI_Ball: balls.peek()->translate(adjustment); break;
      case MI_Ball_V: balls.peek()->push(adjustment); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      default: break;
      }
      modelview_update();
    }
}



int
main(int argv, char **argc)
{
  pOpenGL_Helper popengl_helper(argv,argc);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.render_w,&world);
}

