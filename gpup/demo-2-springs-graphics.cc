/// LSU EE 4702-1 (Fall 2012), GPU Programming
//
 /// Simple Demo of Dynamic Simulation, Graphics Code

 // This file includes graphics code needed by the main file. The code
 // in this file does not need to be understood early in the semester.

// $Id:$


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
#include <gp/shader.h>
#include <gp/pstring.h>
#include <gp/misc.h>
#include <gp/gl-buffer.h>
#include <gp/texture-util.h>
#include "shapes.h"

enum Render_Option { RO_Normally, RO_Simple, RO_Shadow_Volumes };

class Render_FCtx {
public:
  Render_FCtx(pCoor light, pCoor eye)
    :light_location(light),eye_location(eye),viewer_sv_count(0){}
  pCoor light_location;
  pCoor eye_location;
  int viewer_sv_count;
};

class Render_Ctx {
public:
  Render_Ctx(Render_FCtx& fc):fc(&fc){};
  Render_Ctx(Render_Ctx *rc, pMatrix transform_local)
    :fc(rc->fc), transform(rc->transform * transform_local){};
  Render_FCtx* const fc;
  const pMatrix transform;
};

// Don't do this at home.
static int gr_object_debug_id = 1000; // Reserve lower values for user.

class Gr_Object {
public:
  Gr_Object() { debug_id = gr_object_debug_id++; }
  pMatrix transform;
  int debug_id;

  virtual void render() {};
  virtual void render_shadow_volume(Render_Ctx *re) {};
};

class Group : public Gr_Object {
public:
  Group():Gr_Object(){};
  PStack<Gr_Object*> contents;
  void render()
  {
    glPushMatrix();
    glMultTransposeMatrixf(transform);
    for ( Gr_Object *obj = NULL; contents.iterate(obj); ) obj->render();
    glPopMatrix();
  }
  void render_shadow_volume(Render_Ctx *rc)
  {
    Render_Ctx rd(rc,transform);
    for ( Gr_Object *obj = NULL; contents.iterate(obj); ) obj->render_shadow_volume(&rd);
  }
};

class Card2 : public Gr_Object {
public:
  Card2(float width = 1, float height = 1) {
    color = pColor(0.5,0.8,0.1);
    pVect lower_left_to_lower_right( width, 0, 0);
    pVect lower_left_to_upper_left( 0, height, 0);
    lower_left = pVect(0,0,0);
    lower_right = lower_left + lower_left_to_lower_right;
    upper_left = lower_left + lower_left_to_upper_left;
    upper_right = upper_left + lower_left_to_lower_right;
    normal = pVect(0,0,1);
    texid = -1;
  };

  pCoor upper_left;
  pCoor upper_right;
  pCoor lower_left;
  pCoor lower_right;

  pColor color;
  pVect normal;
  int texid;
  bool eye_in;

  void render()
  {
    if ( texid >= 0 )
      {
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D,texid);
      }
    else
      glDisable(GL_TEXTURE_2D);

    glPushMatrix();
    glMultTransposeMatrixf(transform);

    glBegin(GL_TRIANGLES);
    glColor3fv(color);
    // Use red as card color if card blocks light to eye (in shadow vol).
    //  if ( eye_in ) glColor3f(1,0,0);
    glNormal3fv(normal);
    glTexCoord2f(0,0);
    glVertex3fv(upper_left);
    glTexCoord2f(0,1);
    glVertex3fv(lower_left);
    glTexCoord2f(1,1);
    glVertex3fv(lower_right);
    glVertex3fv(lower_right);
    glTexCoord2f(1,0);
    glVertex3fv(upper_right);
    glTexCoord2f(0,0);
    glVertex3fv(upper_left);
    glEnd();

    glPopMatrix();
  }

  void render_shadow_volume(Render_Ctx *rc)
  {
    // Note: This code is quick and dirty and inefficient.
    // There are many ways to streamline calculations and provide caching.
    //
    Render_Ctx rd(rc,transform);

    const float height = 1000;
    const pCoor light_pos = rc->fc->light_location;

    pCoor ll = rd.transform * lower_left;
    pCoor lr = rd.transform * lower_right;
    pCoor ul = rd.transform * upper_left;
    pCoor ur = rd.transform * upper_right;
    pCoor lower_left_pn = lower_left + normal;
    pCoor llpn = rd.transform * lower_left_pn;
    pVect n(ll,llpn);

    pNorm l_to_ll(light_pos,ll);
    pNorm l_to_lr(light_pos,lr);
    pNorm l_to_ul(light_pos,ul);
    pNorm l_to_ur(light_pos,ur);
    pCoor ul_2 = light_pos + height * l_to_ul;
    pCoor ll_2 = light_pos + height * l_to_ll;
    pCoor lr_2 = light_pos + height * l_to_lr;
    pCoor ur_2 = light_pos + height * l_to_ur;
    const bool facing_light = dot(n,l_to_ul) < 0;

    if ( facing_light ) glFrontFace(GL_CW);
    else                glFrontFace(GL_CCW);

    glBegin(GL_QUAD_STRIP);
    glVertex3fv(ll);
    glVertex3fv(ll_2);
    glVertex3fv(lr);
    glVertex3fv(lr_2);
    glVertex3fv(ur);
    glVertex3fv(ur_2);
    glVertex3fv(ul);
    glVertex3fv(ul_2);
    glVertex3fv(ll);
    glVertex3fv(ll_2);
    glEnd();

    glFrontFace(GL_CCW);
  
    //
    // Determine whether eye is within shadow volume.
    //

    eye_in = false;

    pVect l_to_e(light_pos,rc->fc->eye_location);
    const float l_to_e_dot_n = dot(l_to_e,n);
    if ( fabs(l_to_e_dot_n) < 1e-8 ) return;
    const float dist = l_to_ll.magnitude * dot(l_to_ll,n) / l_to_e_dot_n;
    if ( dist <= 0 || dist >= 1.0 ) return;
    pCoor le_intercept = light_pos + dist * l_to_e;
    const float l_to_ll_dot_n = dot(l_to_ll,n);
    const float l_to_ul_dot_n = dot(l_to_ul,n);
    const float l_to_lr_dot_n = dot(l_to_lr,n);
    if ( l_to_ll_dot_n && l_to_ul_dot_n && l_to_lr_dot_n )
      {
        const float dist_ll = l_to_e_dot_n / dot(l_to_ll,n);
        pCoor ll_3 = light_pos + dist_ll * l_to_ll;
        const float dist_ul = l_to_e_dot_n / dot(l_to_ul,n);
        pCoor ul_3 = light_pos + dist_ul * l_to_ul;
        const float dist_lr = l_to_e_dot_n / dot(l_to_lr,n);
        pCoor lr_3 = light_pos + dist_lr * l_to_lr;
        pVect ll_3_to_e(ll_3,rc->fc->eye_location);
        pNorm ll_3_to_lr_3(ll_3,lr_3);
        const float x_dist = dot(ll_3_to_e,ll_3_to_lr_3);
        if ( x_dist < 0 || x_dist > ll_3_to_lr_3.magnitude ) return;
        pNorm ll_3_to_ul_3(ll_3,ul_3);
        const float y_dist = dot(ll_3_to_e,ll_3_to_ul_3);
        if ( y_dist < 0 || y_dist > ll_3_to_ul_3.magnitude ) return;
      }

    rc->fc->viewer_sv_count++;
    eye_in = true;
    return;
    // Show marker where light-to-eye vector intercepts card.
    glColor3f(0,0,1);
    glEnable(GL_LIGHTING);
    glDisable(GL_STENCIL_TEST);
    glColorMask(true,true,true,true);
    Cone cone;
    cone.render(le_intercept,0.2,l_to_e);
    glDisable(GL_LIGHTING);
    glColorMask(false,false,false,false);
    glEnable(GL_STENCIL_TEST);
  }
};

const pColor white(0xffffff);
const pColor gray(0x303030);
const pColor lsu_business_purple(0x7f5ca2);
const pColor lsu_spirit_purple(0x580da6);
const pColor lsu_spirit_gold(0xf9b237);
const pColor lsu_official_purple(0x2f0462);
const pColor dark(0);

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){init();}
  void init();
  void init_graphics();
  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();
  void render();
  void render_objects(Render_Option render_option);
  void cb_keyboard();
  void modelview_update();

  pOpenGL_Helper& ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;
  double world_time;
  float opt_gravity_accel;      // Value chosen by user.
  pVect gravity_accel;          // Set to zero when opt_gravity is false;
  bool opt_gravity;
  bool opt_head_lock;
  bool opt_time_step_alt;

  // Tiled platform for ball.
  //
  float platform_xmin, platform_xmax, platform_zmin, platform_zmax;
  float platform_pi_xwidth_inv;
  pBuffer_Object<pVect> platform_tile_coords;
  pBuffer_Object<float> platform_tex_coords;
  pVect platform_normal;
  GLuint texid_syl;
  GLuint texid_emacs;
  bool opt_platform_texture;
  void platform_update();
  bool platform_collision_possible(pCoor pos);

  pCoor light_location;
  float opt_light_intensity;
  enum { MI_Eye, MI_Light, MI_Ball, MI_Ball_V, MI_COUNT } opt_move_item;
  bool opt_pause;
  int viewer_shadow_volume;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  pMatrix transform_mirror;

  void ball_init();
  void time_step_cpu(double);
  void balls_stop();
  void balls_freeze();
  void balls_translate(pVect amt, int idx);
  void balls_translate(pVect amt);
  void balls_push(pVect amt, int idx);
  void balls_push(pVect amt);

  float opt_spring_constant;
  float distance_relaxed;
  int chain_length;
  Ball *balls;
  Sphere sphere;
};


void
World::init_graphics()
{
  ///
  /// Graphical Model Initialization
  ///

  opt_platform_texture = true;
  opt_head_lock = false;

  eye_location = pCoor(24.2,11.6,-38.7);
  eye_direction = pVect(-0.42,-0.09,0.9);


  platform_xmin = -40; platform_xmax = 40;
  platform_zmin = -40; platform_zmax = 40;
  texid_syl = pBuild_Texture_File("gpup.png",false,255);
  texid_emacs = pBuild_Texture_File("mult.png", false,-1);

  opt_light_intensity = 100.2;
  light_location = pCoor(platform_xmax,platform_xmax,platform_zmin);


  variable_control.insert(opt_light_intensity,"Light Intensity");

  opt_move_item = MI_Eye;
  opt_pause = false;

  sphere.init(40);

  platform_update();
  modelview_update();
}


void
World::platform_update()
{
  const float tile_count = 19;
  const float ep = 1.00001;
  const float delta_x = ( platform_xmax - platform_xmin ) / tile_count * ep; 
  const float zdelta = ( platform_zmax - platform_zmin ) / tile_count * ep;

  const float trmin = 0.05;
  const float trmax = 0.7;
  const float tsmin = 0;
  const float tsmax = 0.4;

  platform_normal = pVect(0,1,0);

  PStack<pVect> p_tile_coords;
  PStack<pVect> p1_tile_coords;
  PStack<float> p_tex_coords;
  bool even = true;

  for ( int i = 0; i < tile_count; i++ )
    {
      const float x0 = platform_xmin + i * delta_x;
      const float x1 = x0 + delta_x;
      const float y = 0;
      for ( float z = platform_zmin; z < platform_zmax; z += zdelta )
        {
          PStack<pVect>& t_coords = even ? p_tile_coords : p1_tile_coords;
          p_tex_coords += trmax; p_tex_coords += tsmax;
          t_coords += pVect(x0,y,z);
          p_tex_coords += trmax; p_tex_coords += tsmin;
          t_coords += pVect(x0,y,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmin;
          t_coords += pVect(x1,y,z+zdelta);
          p_tex_coords += trmin; p_tex_coords += tsmax;
          t_coords += pVect(x1,y,z);
          even = !even;
        }
    }

  while ( pVect* const v = p1_tile_coords.iterate() ) p_tile_coords += *v;

  platform_tile_coords.re_take(p_tile_coords);
  platform_tile_coords.to_gpu();
  platform_tex_coords.re_take(p_tex_coords);
  platform_tex_coords.to_gpu();
}

void
World::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
  pMatrix reflect; reflect.set_identity(); reflect.rc(1,1) = -1;
  transform_mirror = modelview * reflect * invert(modelview);
}

void
World::render_objects(Render_Option option)
{
  const float shininess_ball = 5;
  pColor spec_color(0.2,0.2,0.2);
  Render_FCtx fc(light_location,eye_location);
  Render_Ctx rc(fc);

  if ( option == RO_Shadow_Volumes )
    viewer_shadow_volume = 0;

  if ( option == RO_Normally )
    {
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D,texid_emacs);
      glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,shininess_ball);
      glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
      glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SEPARATE_SPECULAR_COLOR);
      glEnable(GL_COLOR_SUM);
    }

  if ( option == RO_Shadow_Volumes )
    {
      sphere.light_pos = light_location;
      for ( int i=0; i<chain_length; i++ )
        sphere.render_shadow_volume(balls[i].radius,balls[i].position);
    }
  else
    for ( int i=0; i<chain_length; i++ )
      sphere.render(balls[i].radius,balls[i].position);

  glDisable(GL_COLOR_SUM);
  glLightModeli(GL_LIGHT_MODEL_COLOR_CONTROL, GL_SINGLE_COLOR);
  glLightfv(GL_LIGHT0, GL_SPECULAR, dark);

  //
  // Render Platform
  //
  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  glEnable(GL_TEXTURE_2D);

  // Set up attribute (vertex, normal, etc.) arrays.
  //
  glBindTexture(GL_TEXTURE_2D,texid_syl);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormal3fv(platform_normal);
  platform_tex_coords.bind();
  glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);

  // Write lighter-colored, textured tiles.
  //
  glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR,spec_color);
  glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,2.0);
  glColor3f(0.35,0.35,0.35);
  glColor3f(0.55,0.55,0.55);
  glDrawArrays(GL_QUADS,0,half_elements+4);

  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
}

void
World::render()
{
  // Get any waiting keyboard commands.
  //
  cb_keyboard();

  // Start a timer object used for tuning this code.
  //
  frame_timer.frame_start();

  /// Emit a Graphical Representation of Simulation State
  //

  // Understanding of the code below not required for introductory
  // lectures.

  // That said, much of the complexity of the code is to show
  // the ball shadow and reflection.


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
  glClearStencil(0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT );

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);
  glDisable(GL_BLEND);

  glLightModeli(GL_LIGHT_MODEL_TWO_SIDE,1);
  glLightfv(GL_LIGHT0, GL_POSITION, light_location);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0.5);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0);

  pColor ambient_color(0x555555);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);
  glLightfv(GL_LIGHT0, GL_DIFFUSE, white * opt_light_intensity);
  glLightfv(GL_LIGHT0, GL_AMBIENT, dark);
  glLightfv(GL_LIGHT0, GL_SPECULAR, white * opt_light_intensity);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);

  glShadeModel(GL_SMOOTH);

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

  Ball& ball = balls[0];

  ogl_helper.fbprintf
    ("Ball Pos  [%5.1f,%5.1f,%5.1f] Vel [%+5.1f,%+5.1f,%+5.1f]\n",
     ball.position.x,ball.position.y,ball.position.z,
     ball.velocity.x,ball.velocity.y,ball.velocity.z );

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.5f  (TAB or '`' to change, +/- to adjust)\n",
                      cvar->name,cvar->var[0]);

  const int half_elements = platform_tile_coords.elements >> 3 << 2;

  //
  // Render ball reflection.  (Will be blended with dark tiles.)
  //

  // Write stencil at location of dark (mirrored) tiles.
  //
  glDisable(GL_LIGHTING);
  glEnable(GL_STENCIL_TEST);
  glStencilFunc(GL_NEVER,2,2);
  glStencilOp(GL_REPLACE,GL_KEEP,GL_KEEP);
  platform_tile_coords.bind();
  glVertexPointer(3, GL_FLOAT, sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glDrawArrays(GL_QUADS,half_elements+4,half_elements-4);
  glEnable(GL_LIGHTING);
  glDisableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);

  // Prepare to write only stenciled locations.
  //
  glStencilFunc(GL_EQUAL,2,2);
  glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);

  // Use a transform that reflects objects to other side of platform.
  //
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glMultTransposeMatrixf(transform_mirror);

  // Reflected front face should still be treated as the front face.
  //
  glFrontFace(GL_CW);

  render_objects(RO_Normally);

  glFrontFace(GL_CCW);
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glDisable(GL_STENCIL_TEST);


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

  if ( opt_platform_texture )
    {
      glEnable(GL_TEXTURE_2D);
      platform_tex_coords.bind();
      glTexCoordPointer(2, GL_FLOAT,2*sizeof(float), 0);
      glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }

  platform_tile_coords.bind();
  glVertexPointer
    (3, GL_FLOAT,sizeof(platform_tile_coords.data[0]), 0);
  glEnableClientState(GL_VERTEX_ARRAY);
  glNormal3fv(platform_normal);

  if ( opt_platform_texture ) glEnable(GL_TEXTURE_2D);

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

  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER,0);
  glDisable(GL_STENCIL_TEST);
  glDepthFunc(GL_LESS);

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient_color);

  //
  // First pass, render using only ambient light.
  //
  glDisable(GL_LIGHT0);

  // Send balls, tiles, and platform to opengl.
  // Do occlusion test too.
  //
  render_objects(RO_Normally);

  //
  // Second pass, add on light0.
  //

  // Turn off ambient light, turn on light 0.
  //
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, dark);
  glEnable(GL_LIGHT0);


  glClear(GL_STENCIL_BUFFER_BIT);

  // Make sure that only stencil buffer written.
  //
  glColorMask(false,false,false,false);
  glDepthMask(false);

  // Don't waste time computing lighting.
  //
  glDisable(GL_LIGHTING);
  glDisable(GL_TEXTURE_2D);

  // Set up stencil test to count shadow volume surfaces: plus 1 for
  // entering the shadow volume, minus 1 for leaving the shadow
  // volume.
  //
  glEnable(GL_STENCIL_TEST);
  // sfail, dfail, dpass
  glStencilOpSeparate(GL_FRONT,GL_KEEP,GL_KEEP,GL_INCR_WRAP);
  glStencilOpSeparate(GL_BACK,GL_KEEP,GL_KEEP,GL_DECR_WRAP);
  glStencilFuncSeparate(GL_FRONT_AND_BACK,GL_ALWAYS,1,-1); // ref, mask
 
  // Write stencil with shadow locations based on shadow volumes
  // cast by light0 (light_location).  Shadowed locations will
  // have a positive stencil value.  Routine will set viewer_shadow_volume
  // to the number of view volumes containing the eye.
  //
  render_objects(RO_Shadow_Volumes);

  glEnable(GL_LIGHTING);
  glColorMask(true,true,true,true);
  glDepthMask(true);

  // Use stencil test to prevent writes to shadowed areas.
  //
  glStencilOp(GL_KEEP,GL_KEEP,GL_KEEP);
  glStencilFunc(GL_EQUAL,viewer_shadow_volume,-1); // ref, mask

  // Allow pixels to be re-written.
  //
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_BLEND);
  glBlendEquation(GL_FUNC_ADD);
  glBlendFunc(GL_ONE,GL_ONE);

  // Render.
  //
  render_objects(RO_Normally);

  glDisable(GL_BLEND);
  glDisable(GL_STENCIL_TEST);


  // Render Marker for Light Source
  //
  insert_tetrahedron(light_location,0.5);

  pError_Check();

  glColor3f(0.5,1,0.5);

  frame_timer.frame_end();

  ogl_helper.user_text_reprint();

  glutSwapBuffers();
}


void
World::cb_keyboard()
{
  if ( !ogl_helper.keyboard_key ) return;
  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);
  const float move_amt = 0.4;

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
  case 'h': case 'H': opt_head_lock = !opt_head_lock; break;
  case 'l': case 'L': opt_move_item = MI_Light; break;
  case 'n': case 'N': opt_platform_texture = !opt_platform_texture; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 's': case 'S': balls_stop(); break;
  case 'v': case 'V': opt_time_step_alt = !opt_time_step_alt; break;
  case 9: variable_control.switch_var_right(); break;
  case 96: variable_control.switch_var_left(); break; // `, until S-TAB works.
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;
  default: printf("Unknown key, %d\n",ogl_helper.keyboard_key); break;
  }

  gravity_accel.y = opt_gravity ? -opt_gravity_accel : 0;

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
      case MI_Ball: balls_translate(adjustment,0); break;
      case MI_Ball_V: balls_push(adjustment,0); break;
      case MI_Light: light_location += adjustment; break;
      case MI_Eye: eye_location += adjustment; break;
      default: break;
      }
      modelview_update();
    }

}
