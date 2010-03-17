/// LSU EE 7700-1 (Sp 2010), GPU Microarchitecture
//
 /// Texturing Demonstration

// $Id:$

 /// Purpose
//
//   Demonstrate texturing techniques.

 /// More Information
//
//   OpenGL documentation.
//     http://www.ece.lsu.edu/koppel/gp/refs/glspec21.pdf


 /// What Code Does

// The code shows an undulating tube (use p to pause) pierced by a
// purple quadrilateral. After turning on texturing (use m) the course
// syllabus will appear on the quadrilateral and tube.

// Relevant User Interface:

//  m: Change texture application modes. Initially texturing off.
//  a: Change texture magnification filtering options.
//  i: Change texture minification filtering options.
//  b: Turn blending on and off. Affects appearance of syllabus on rectangle.
//  p: Pause/resume.


/// Texturing and this Code

 /// Initialization

 //  Textures loaded from image files by the procedure pTexture_From_Image.
 //    The procedure sets basic options for the texture, loads the data,
 //    possibly modifies it, and passes it to OpenGL. It returns
 //    a texture id that is used to refer to the texture.

 //  Two textures are loaded, one for the tube and one for the
 //  quadrilateral. (As of this writing they are the same image with
 //  different options.)


 /// Texture Coordinates

 //  Regardless of its size the coordinate space for a texture is from
 //  (0,0), the upper left, to (1,1), the lower right. The symbol s is
 //  used for the horizontal axis (akin to x) and t is used for the
 //  vertical axis (akin to y).

 //  The pTexture_From_Image procedure sets texturing so that
 //  coordinates outside the valid range wrap, so that both (0.2,0.2)
 //  and (0.2,1.2) refer to the same texture location.

 //  Texture coordinates are one of the attributes specified with a
 //  vertex. The Tube::render routine now collects texture coordinates
 //  for the tube and individually specifies them for the
 //  quadrilateral (which was a triangle in earlier versions). The
 //  texture coordinates are passed as an array using
 //  glTexCoordPointer or individually using commands such as
 //  glTexCoord2f.

 //  For the tube the texture s coordinate is a scaled version of theta
 //  and the t coordinate is a scaled version of z.


 /// Texture Filtering
 //  OpenGL 2.1 3.8.8

 //  The user interface can be used to select minification filtering
 //  (the i key) and magnification filtering (the a key).  The chosen
 //  filter options are passed to OpenGL using a glTexParameterf call
 //  placed before vertices are sent to OpenGL.


 /// Texture Mode (Application Options)
 //  OpenGL 2.1 3.8.13

 //  There are many useful ways of combining a texel with the lighted
 //  color (or other texture's texels). These are selected in part by
 //  specifying a /mode/ in a call to glTexEnvi. Search for
 //  GL_TEXTURE_ENV_MODE and try user interface key m.


 /// Texture Use

 //  Commands such as glTexEnvi operate on the /bound texture/, that
 //  is, the texture specified in the last call to
 //  glBindTexture. (Search for this.)

 //  Texturing (2D) is turned on using glEnable(GL_TEXTURE_2D) and
 //  turned off with a correspondence glDisable.


 /// Blending

 //  The quadrilateral is displayed with blending turned on, meaning,
 //  its pixel values will be blended with any pixels already in the
 //  frame buffer. This blending improves anti-aliased text appearance
 //  by allowing the gray edges of text to blend with colors in back
 //  of the text.

 //  Blending is turned on using glEnable(GL_BLEND) and is set to
 //  blend using the alpha channel of the "source" meaning the textured
 //  quadrilateral.



#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <deque>

#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/coord.h>
#include <gp/texture-util.h>


 ///
 ///  Create and Initialize a Texture Object from a File
 ///
enum { PT_Invert = 1, PT_To_Alpha = 2 };

GLuint
pTexture_From_Image
(char *file_name, int option = 0, int transp = 256 )
{
  P_Image_Read image(file_name,transp);
  if ( !image.image_loaded ) return 0;
  if ( option & PT_To_Alpha ) image.gray_to_alpha();
  if ( option & PT_Invert ) image.color_invert();
  GLuint texture_id;

  // Generate a texture id (name). (This doesn't create a texture object.)
  //
  glGenTextures(1,&texture_id);

  // Create a texture object for texture_id (since one doesn't yet exist).
  //
  glBindTexture(GL_TEXTURE_2D,texture_id);

  // Set some parameters for our new texture object.
  //
  glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP,1);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);

  // Load data into the texture object.
  //
  glTexImage2D
    (GL_TEXTURE_2D,
     0,                // Level of Detail (0 is base).
     GL_RGBA,          // Internal format to be used for texture.
     image.width, image.height,
     0,                // Border
     image.gl_fmt,     // GL_BGRA: Format of data read by this call.
     image.gl_type,    // GL_UNSIGNED_BYTE: Size of component.
     (void*)image.data);
  pError_Check();

  return texture_id;
}


// Display a tetrahedron, used to indicate light position.
//
void
insert_tetrahedron(pCoor& loc, float size)
{
  pCoor v0(loc.x,loc.y,loc.z);
  pCoor v1(loc.x,loc.y-size,loc.z+size);
  pCoor v2(loc.x-.866*size,loc.y-size,loc.z-0.5*size);
  pCoor v3(loc.x+.866*size,loc.y-size,loc.z-0.5*size);
  static pColor c1(0xffffff);
  static pColor c2(0xff00);

  glDisable(GL_LIGHTING);

#define TRI(va,vb,vc)                                                         \
  {                                                                           \
    pVect n = cross(va,vb,vc);                                                \
    glNormal3fv(n);                                                           \
    glColor3fv(c1);  glVertex3fv(va);                                         \
    glColor3fv(c2);  glVertex3fv(vb);                                         \
    glVertex3fv(vc);                                                          \
  }

  glBegin(GL_TRIANGLES);
  TRI(v0,v1,v2); TRI(v0,v2,v3); TRI(v0,v3,v1);
  glEnd();

# undef TRI

  glEnable(GL_LIGHTING);
}


// Class for re-using sine and cosine values.
//
class MTrig {
public:
  MTrig():size(0),storage(NULL){}
  void init(int sizep){
    size = sizep;
    if ( storage ) delete storage;
    storage = new float[size];
    idx = 0;
    full = false;
  }
  float sin(float theta){ return trig(theta,::sin); }
  float cos(float theta){ return trig(theta,::cos); }
private:
  float trig(float theta,double (*func)(double))
  {
    if ( !full ) { storage[idx] = func(theta);  full = idx == size - 1; }
    if ( idx == size ) idx = 0;
    return storage[idx++];
  }
  int size;
  float* storage;
  int idx;
  bool full;
};


#define ENUM_LABEL(c) { #c, c }
struct pEnum_Label { const char *label; int value; };
pEnum_Label texture_env_modes[] = {
  { "Texturing Off", 0 },
  ENUM_LABEL(GL_REPLACE),
  ENUM_LABEL(GL_MODULATE),
  ENUM_LABEL(GL_DECAL),   // Blend using alpha value of texture.
  ENUM_LABEL(GL_BLEND),   // Blend using separate alpha.
  ENUM_LABEL(GL_ADD),     // Sum of colors, product of alphas.
  ENUM_LABEL(GL_COMBINE), // Use separate combine function.
  {NULL,0}
};

pEnum_Label texture_min_filters[] = {
  ENUM_LABEL( GL_NEAREST_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_LINEAR_MIPMAP_NEAREST ),
  ENUM_LABEL( GL_NEAREST_MIPMAP_LINEAR ),
  ENUM_LABEL( GL_LINEAR_MIPMAP_LINEAR ),
  {NULL,0}
};

pEnum_Label texture_mag_filters[] = {
  ENUM_LABEL( GL_NEAREST ),
  ENUM_LABEL( GL_LINEAR ),
  {NULL,0}
};

 ///
 /// Tube Object
 ///

class Tube {
public:
  Tube(pOpenGL_Helper &fb):ogl_helper(fb){ init(); }
  static void render_w(void *moi){ ((Tube*)moi)->render(); }
  void init();
  void modelview_update();
  void render();
private:
  pOpenGL_Helper &ogl_helper;
  pVariable_Control variable_control;
  pFrame_Timer frame_timer;

  pCoor eye_location;
  pVect eye_direction;
  pMatrix modelview;
  bool opt_move_light;

  float r0;
  float x_shift;
  float pattern_pitch_z;
  float opt_pattern_levels;
  float opt_pattern_width;

  float opt_light_intensity;
  pCoor opt_light_location;
  bool opt_pause;
  bool opt_blend;

  double time_last_frame;
  double time_app;

  pCoor* coor_buffer;
  pVect* norm_buffer;
  float* text_buffer;

  int num_coor_alloc;
  MTrig tarray;

  int opt_texture_env_mode;
  int opt_texture_min_filter;
  int opt_texture_mag_filter;

  GLuint texture_id_syllabus;
  GLuint texture_id_image;

};

void
Tube::init()
{
  time_app = 0;
  time_last_frame = time_wall_fp();

  // Tell frame timer that work unit is "MB/s" and how should be scaled.
  //
  frame_timer.work_unit_set("MB/s",1e-6);

  r0 = 2;                 // Tube radius.
  x_shift = 0.4;          // Tube x offset.
  pattern_pitch_z = 0.25; // Triangle size (z axis).

  opt_pattern_levels = 50;    // Tube depth (z direction.)
  opt_pattern_width = 50;     // Triangle size (circumferential).

  opt_light_intensity = 2;
  opt_light_location.set(( r0 - 0.1 ), 0, -3 );

  eye_location.set(0,0,2.5);
  eye_direction.set(0,0,-1);
  modelview_update();

  // Arrange that variables below can be modified from the keyboard.
  //
  variable_control.insert(opt_light_intensity,"Light Intensity");

  coor_buffer = NULL;
  norm_buffer = NULL;
  num_coor_alloc = 0;

  texture_id_syllabus =
    pTexture_From_Image("gp.png",PT_Invert | PT_To_Alpha,true);
  //  texture_id_image = pTexture_From_Image("ee_bdg_to_ur_ed.ppm",false,-1);
  texture_id_image = pTexture_From_Image("gp.png");

  opt_texture_env_mode = 0;
  opt_texture_min_filter = 0;
  opt_texture_mag_filter = 0;
  opt_blend = true;

  opt_pause = false;
}

void
Tube::modelview_update()
{
  pMatrix_Translate center_eye(-eye_location);
  pMatrix_Rotation rotate_eye(eye_direction,pVect(0,0,-1));
  modelview = rotate_eye * center_eye;
}


void
Tube::render()
{
  frame_timer.frame_start();

  glClearColor(0,0,0.0,0.5);
  glClearDepth(1.0);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );

  // Have frame timer provide timing information for top of image.
  //
  ogl_helper.fbprintf("%s\n",frame_timer.frame_rate_text_get());

  ///
  /// Transformation Matrix Setup
  ///

  glMatrixMode(GL_MODELVIEW);
  glLoadTransposeMatrixf(modelview);

  const int win_width = ogl_helper.get_width();
  const int win_height = ogl_helper.get_height();
  const float aspect = float(win_width) / win_height;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-0.8,+0.8,-0.8/aspect,0.8/aspect,1,5000);

  glViewport(0, 0, win_width, win_height);
  pError_Check();

  ///
  /// Adjust options based on user input.
  ///

  pVect adjustment(0,0,0);
  pVect user_rot_axis(0,0,0);

  switch ( ogl_helper.keyboard_key ) {
  case FB_KEY_LEFT: adjustment.x = -0.1; break;
  case FB_KEY_RIGHT: adjustment.x = 0.1; break;
  case FB_KEY_UP: adjustment.z = -0.1; break;
  case FB_KEY_DOWN: adjustment.z = 0.1; break;
  case FB_KEY_PAGE_DOWN: adjustment.y = -0.1; break;
  case FB_KEY_PAGE_UP: adjustment.y = 0.1; break;
  case FB_KEY_DELETE: user_rot_axis.y = 1; break;
  case FB_KEY_INSERT: user_rot_axis.y =  -1; break;
  case FB_KEY_HOME: user_rot_axis.x = 1; break;
  case FB_KEY_END: user_rot_axis.x = -1; break;
  case 'b': case 'B': opt_blend = !opt_blend; break;
  case 'l': case 'L': opt_move_light = true; break;
  case 'e': case 'E': opt_move_light = false; break;
  case 'p': case 'P': opt_pause = !opt_pause; break;
  case 'm': opt_texture_env_mode++;
    if ( !texture_env_modes[opt_texture_env_mode].label )
      opt_texture_env_mode = 0;
    break;
  case 'i': opt_texture_min_filter++;
    if ( !texture_min_filters[opt_texture_min_filter].label )
      opt_texture_min_filter = 0;
    break;
  case 'a': opt_texture_mag_filter++;
    if ( !texture_mag_filters[opt_texture_mag_filter].label )
      opt_texture_mag_filter = 0;
    break;

  case 9: variable_control.switch_var_right(); break;
  case '-':case '_': variable_control.adjust_lower(); break;
  case '+':case '=': variable_control.adjust_higher(); break;

  default: break;
  }

  // Update eye_direction based on keyboard command.
  //
  if ( user_rot_axis.x || user_rot_axis.y )
    {
      pMatrix_Rotation rotall(pVect(0,0,-1),eye_direction);
      user_rot_axis *= rotall;
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
      if ( opt_move_light ) opt_light_location += adjustment;
      else                  eye_location += adjustment;
      modelview_update();
    }


  glLightfv(GL_LIGHT0, GL_POSITION, opt_light_location);

  const float light_intensity[4] =
    {opt_light_intensity, opt_light_intensity, opt_light_intensity, 1.0};
  const float light_off[4] = {0,0,0,0};
  const float light_dim[4] = {0.1,0.1,0.1,1};

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, &light_dim[0]);

  glLightfv(GL_LIGHT0, GL_DIFFUSE, &light_intensity[0]);
  glLightfv(GL_LIGHT0, GL_AMBIENT, &light_off[0]);

  glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 0);
  glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1);
  glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.25);

  glEnable(GL_LIGHT0);
  glEnable(GL_LIGHTING);

  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_COLOR_MATERIAL);

  pVariable_Control_Elt* const cvar = variable_control.current;
  ogl_helper.fbprintf("VAR %s = %.3f  (+/- to adjust)\n",
		      cvar->name,cvar->var[0]);
  ogl_helper.fbprintf("Texture Mode: %s  (m to change)\n",
		      texture_env_modes[opt_texture_env_mode].label);
  ogl_helper.fbprintf("Min Filter: %s  (i to change)\n",
		      texture_min_filters[opt_texture_min_filter].label);
  ogl_helper.fbprintf("Mag Filter: %s  (a to change)\n",
		      texture_mag_filters[opt_texture_mag_filter].label);
  ogl_helper.fbprintf("Blending %s\n", opt_blend ? "ON" : "OFF");
  if ( opt_pause )
    ogl_helper.fbprintf("Animation PAUSED  (p to resume)");
  else
    ogl_helper.fbprintf("Animation RUNNING  (p to pause)");

  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LESS);

  // Insert marker (green tetrahedron) to show light location.
  //
  insert_tetrahedron(opt_light_location,0.05);

  //
  // Insert a tessellated tube in the vertex list.
  //

  float z = -1;
  pColor color_purple(0x580da6);  // LSU Spirit Purple
  pColor color_gold(0xf9b237);    // LSU Spirit Gold


  //
  // Compute Tube Specifications
  //

  const int pattern_width = 3 * int( opt_pattern_width * 0.33333333 );
  const int pattern_levels = int( opt_pattern_levels + 0.5 );

  // Number of vertices passed to OpenGL.
  const int vertices_per_ring = 3 * 2 * pattern_width;

  const int num_coor = pattern_levels * vertices_per_ring;

  const double cycles_per_second = 0.2;
  const double now = time_wall_fp();
  const double delta_t = now - time_last_frame;
  time_last_frame = now;
  if ( !opt_pause ) time_app += delta_t;
  const double phase_n = time_app * cycles_per_second;
  const double phase = phase_n * 2.0 * M_PI;

  const float wavelength_z = 2.8;
  const float radians_per_z = 2.0 * M_PI / wavelength_z;

  int num_bytes = 0;

  const float ampl = 0.2;

  glColor3fv( color_gold );

  // If number of vertices has changed re-allocate our storage
  // (coor_buffer, norm_buffer, text_buffer) and MTrig object and also
  // remember that gpu's buffer needs to be updated.

  if ( num_coor_alloc != num_coor )
    {
      if ( coor_buffer )
	{ delete coor_buffer; delete norm_buffer; delete text_buffer; }
      coor_buffer = new pCoor[num_coor];
      norm_buffer = new pVect[num_coor];
      text_buffer = new float[num_coor*2];

      tarray.init( vertices_per_ring * 4 );
      num_coor_alloc = num_coor;
    }

  // Outer Loop: z axis (down axis of tube).
  //
  {
    pCoor* cptr = coor_buffer;
    pVect* nptr = norm_buffer;
    float* tptr = text_buffer;

    const float delta_theta = M_PI / pattern_width;

    for ( int i = 0; i < pattern_levels; i++ )
      {
	const float next_z = z - pattern_pitch_z;
	const float last_z = z + pattern_pitch_z;
	float theta = i & 1 ? delta_theta : 0;
	const float angle_z = phase + radians_per_z * z;
	const float angle_nz = phase + radians_per_z * next_z;
	const float angle_lz = phase + radians_per_z * last_z;
	const float r = r0 * ( 1 + ampl * sin( angle_z ) );
	const float rnz = r0 * ( 1 + ampl * sin( angle_nz ) );
	const float rlz = r0 * ( 1 + ampl * sin( angle_lz ) );
	const float cos_z = cos(angle_z);
	const float cos_lz = cos(angle_lz);
	const float cos_nz = cos(angle_nz);
	const float z_scale = -0.125;
	const float th_scale = -1.0 / ( 2 * M_PI );

	// Inner Loop: around circumference of tube.
	//
	while ( theta < 4 * M_PI - delta_theta )
	  {
	    const bool first_round = theta < 2 * M_PI;
	    const float z1 = first_round ? next_z : last_z;
	    const float rz1 = first_round ? rnz : rlz;
	    const float cos_z1 = first_round ? cos_nz : cos_lz;

	    float cos_theta = tarray.cos(theta);  // Reassigned
	    float sin_theta = tarray.sin(theta);  // Reassigned

	    pCoor v0(x_shift + r * cos_theta, r * sin_theta, z);
	    pVect v0_normal(-cos_theta,-sin_theta,cos_z);

	    *tptr++ = theta * th_scale; *tptr++ = z * z_scale;

	    theta += delta_theta;

	    cos_theta = tarray.cos(theta);
	    sin_theta = tarray.sin(theta);

	    pCoor v1(x_shift + rz1 * cos_theta, rz1 * sin_theta, z1);
	    pVect v1_normal(-cos_theta,-sin_theta,cos_z1);

	    *tptr++ = theta * th_scale; *tptr++ = z1 * z_scale;

	    theta += delta_theta;

	    cos_theta = tarray.cos(theta);
	    sin_theta = tarray.sin(theta);

	    pCoor v2(x_shift + r * cos_theta, r * sin_theta, z);
	    pVect v2_normal(-cos_theta,-sin_theta,cos_z);

	    *tptr++ = theta * th_scale; *tptr++ = z * z_scale;

	    *nptr++ = v0_normal; *nptr++ = v1_normal; *nptr++ = v2_normal;

	    *cptr++ = v0; *cptr++ = v1; *cptr++ = v2;

	  }
	z = next_z;
      }
  }

  if ( opt_texture_env_mode )
    {
      // Make the Image texture the current 2D texture.
      //
      glBindTexture(GL_TEXTURE_2D,texture_id_image);

      // Set parameters in texture object (texture_id_image).
      //
      glTexParameterf
        (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
         texture_min_filters[opt_texture_min_filter].value);

      glTexParameterf
        (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
         texture_mag_filters[opt_texture_mag_filter].value);

      // Set parameter for texture unit.
      //
      glTexEnvi
        (GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE,
         texture_env_modes[opt_texture_env_mode].value);

      glEnable(GL_TEXTURE_2D);
    }

  // Render Tube
  //
  // Note that now texture coordinates are also sent.
  //
  glNormalPointer(GL_FLOAT,0,norm_buffer);
  glVertexPointer(3,GL_FLOAT,sizeof(pCoor),coor_buffer);
  glTexCoordPointer(2,GL_FLOAT,0,text_buffer);
  glEnableClientState(GL_NORMAL_ARRAY);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glDrawArrays(GL_TRIANGLES,0,num_coor);
  glDisableClientState(GL_NORMAL_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  num_bytes += sizeof(float) * 6 * num_coor;

  frame_timer.work_amt_set(num_bytes);

  // Insert additional quadrilateral.
  //
  {
    // Position of vertices:
    //
    //       v3        v2
    //
    //       v0        v1
    //
    pCoor v0( -1, -1, -5 );
    pCoor v1(  5, -1, -3 );
    pCoor v2(  5,  6, -1 );
    pCoor v3( -1,  6, -3 );

    pVect normal(cross(v2,v1,v0));

    glColor3fv( color_purple );
    // Make primitive more sensitive to light because purple is a dark color.
    glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, 0.2);
    glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.05);

    if ( opt_texture_env_mode )
      {
        // Make the Syllabus texture the current 2D texture.
        //
	glBindTexture(GL_TEXTURE_2D,texture_id_syllabus);

        // Enable Blending
        //
        // Blending helps with anti-aliasing the syllabus text.
        // (Blending is not a texture-specific feature.)
        // When blending is off an alpha test is used to make the syllabus
        // "paper" transparent.
        //
        if ( opt_blend )
          glEnable(GL_BLEND);
        else
          glEnable(GL_ALPHA_TEST);
        glAlphaFunc(GL_GREATER,0.1);
	glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
      }

    glBegin(GL_QUADS);

    // Note: Texture coordinate (0,0) is upper-left.
    //
    glTexCoord2f(0,1); glNormal3fv(normal);  glVertex3fv(v0);
    glTexCoord2f(1,1); glNormal3fv(normal);  glVertex3fv(v1);
    glTexCoord2f(1,0); glNormal3fv(normal);  glVertex3fv(v2);
    glTexCoord2f(0,0); glNormal3fv(normal);  glVertex3fv(v3);

    glEnd();

    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);
    glDisable(GL_ALPHA_TEST);

  }

  glColor3f(0,1,0); // This sets the text color. Don't know why.

  pError_Check();

  frame_timer.frame_end();

  glutSwapBuffers();

}

int
main(int argc, char **argv)
{
  pOpenGL_Helper popengl_helper(argc,argv);
  Tube tube(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(tube.render_w,&tube);

  return 0;
}
