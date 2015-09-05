/// LSU EE 4702-X / EE 7722   -*- c++ -*-
//
 ///  CUDA Utility Classes and Macros

 /// Purpose
//
//   A set of classes and macros for using OpenGL. Intended to support
//   classroom work, not tested for production use.

#ifndef UTIL_H
#define UTIL_H

#include <stdio.h>
#include <stdarg.h>
#include <math.h>
#include <Magick++.h>

#define ALSO_GL

#include "glextfuncs.h"
#include "pstring.h"
#include "misc.h"

// Rename keys so a single namespace can be used for regular (ASCII)
// keys and "special" ones.

#define FB_KEY_F1         ( GLUT_KEY_F1          + 0x100 )
#define FB_KEY_F2         ( GLUT_KEY_F2          + 0x100 )
#define FB_KEY_F3         ( GLUT_KEY_F3          + 0x100 )
#define FB_KEY_F4         ( GLUT_KEY_F4          + 0x100 )
#define FB_KEY_F5         ( GLUT_KEY_F5          + 0x100 )
#define FB_KEY_F6         ( GLUT_KEY_F6          + 0x100 )
#define FB_KEY_F7         ( GLUT_KEY_F7          + 0x100 )
#define FB_KEY_F8         ( GLUT_KEY_F8          + 0x100 )
#define FB_KEY_F9         ( GLUT_KEY_F9          + 0x100 )
#define FB_KEY_F10        ( GLUT_KEY_F10         + 0x100 )
#define FB_KEY_F11        ( GLUT_KEY_F11         + 0x100 )
#define FB_KEY_F12        ( GLUT_KEY_F12         + 0x100 )
#define FB_KEY_LEFT       ( GLUT_KEY_LEFT        + 0x100 )
#define FB_KEY_UP         ( GLUT_KEY_UP          + 0x100 )
#define FB_KEY_RIGHT      ( GLUT_KEY_RIGHT       + 0x100 )
#define FB_KEY_DOWN       ( GLUT_KEY_DOWN        + 0x100 )
#define FB_KEY_PAGE_UP    ( GLUT_KEY_PAGE_UP     + 0x100 )
#define FB_KEY_PAGE_DOWN  ( GLUT_KEY_PAGE_DOWN   + 0x100 )
#define FB_KEY_HOME       ( GLUT_KEY_HOME        + 0x100 )
#define FB_KEY_END        ( GLUT_KEY_END         + 0x100 )
#define FB_KEY_INSERT     ( GLUT_KEY_INSERT      + 0x100 )
#define FB_KEY_DELETE     127


inline bool
pError_Check(int error = -1)
{
  const int err = glGetError();
  if ( err == GL_NO_ERROR ) return false;
  if ( err == error ) return true;
  fprintf(stderr,"GL Error: %s\n",gluErrorString(err));
  pError_Exit();
  return true; // Unreachable.
}

inline void GE() { pError_Check(); }

#define P_GL_PRINT_STRING(token) lprint_string(token,#token);

inline void
lprint_string(int token, const char *name)
{
  pError_Check();
  char* const str = (char*)glGetString(token);
  if ( pError_Check(GL_INVALID_ENUM) )
    printf("S %s: ** Unrecognized**\n",name);
  else
    printf("S %s: \"%s\"\n",name,str);
}

#define PRINT_ATTRIBUTE(token) lprint_attribute(token,#token);
inline void
lprint_attribute(int token, const char *name)
{
  pError_Check();
  int val;
  glGetIntegerv(token,&val);
  if ( pError_Check(GL_INVALID_ENUM) )
    printf("Attribute %s: ** Unrecognized **\n",name);
  else
    printf("Attribute %s: %d\n",name,val);
}

class pOpenGL_Helper;

#ifdef GP_UTIL_DECLARE_ONLY
extern pOpenGL_Helper* opengl_helper_self_;
#else
pOpenGL_Helper* opengl_helper_self_ = NULL;
#endif


struct pTimer_Info {
  pString label;
  bool timing;
  bool per_frame;
  int end_count;
  double start;
  double duration;
  double frac;
  double last;
};

class pFrame_Timer {
public:
  pFrame_Timer():inited(false),work_description(NULL)
  {
    query_timer_id = 0;
    frame_group_size = 5;
    frame_rate = 0;
    cpu_frac = 0;
    cuda_in_use = false;
  }
  void work_unit_set(const char *description, double multiplier = 1)
  {
    work_multiplier = multiplier;
    work_accum = 0;
    work_description = strdup(description);
  }
  void work_amt_set(int amt){ work_accum += amt; }
  int user_timer_per_start_define(const char *label)
  { return user_timer_define(label,false); }
  int user_timer_define(const char *label, bool per_frame = true);
  void user_timer_start(int timer_id);
  void user_timer_end(int timer_id);
  void init();
  void frame_start();
  void frame_end();
  const char* frame_rate_text_get() const { return frame_rate_text.s; }
  int frame_group_size;
  void cuda_frame_time_set(float time_ms)
  { cuda_tsum_ms += time_ms; cuda_in_use = true; }
private:
  void frame_rate_group_start();
  void var_reset()
  {
    frame_group_count = 0;
    cpu_tsum = gpu_tsum_ns = cuda_tsum_ms = 0;
    work_accum = 0;
  }
  bool inited;
  bool cuda_in_use;
  double frame_group_start_time;
  int frame_group_count;
  double gpu_tsum_ns, gpu_tlast, cpu_tsum, cpu_tlast, cuda_tsum_ms, cuda_tlast;
  double work_accum;
  double work_multiplier;
  int work_count_last;
  char *work_description;
  double work_rate;

  double frame_rate;
  double cpu_frac, gpu_frac, cuda_frac;
  double time_render_start;
  GLuint query_timer_id;
  uint xfcount;  // Frame count provided by glx.
  pString frame_rate_text;

  PStack<pTimer_Info> timer_info;
};

#ifndef GP_UTIL_DECLARE_ONLY

void
pFrame_Timer::init()
{
  inited = true;
  if ( glutExtensionSupported("GL_EXT_timer_query") )
    glGenQueries(1,&query_timer_id);
  frame_group_start_time = time_wall_fp();
  var_reset();
  frame_rate_group_start();
#ifdef CUDA
  cudaEventCreate(&frame_start_ce);
  cudaEventCreate(&frame_stop_ce);
#endif
}

int 
pFrame_Timer::user_timer_define(const char *label, bool per_frame)
{
  const int timer_id = timer_info.occ();
  pTimer_Info* const ti = timer_info.pushi();
  ti->label = label;
  ti->timing = false;
  ti->duration = 0;
  ti->end_count = 0;
  ti->per_frame = per_frame;
  return timer_id;
}

void
pFrame_Timer::user_timer_start(int timer_id)
{
  pTimer_Info* const ti = &timer_info[timer_id];
  ASSERTS( !ti->timing );
  ti->timing = true;
  ti->start = time_wall_fp();
}

void
pFrame_Timer::user_timer_end(int timer_id)
{
  pTimer_Info* const ti = &timer_info[timer_id];
  if ( !ti->timing ) return;
  ASSERTS( ti->timing );
  ti->timing = false;
  ti->end_count++;
  ti->duration += time_wall_fp() - ti->start;
}


void
pFrame_Timer::frame_rate_group_start()
{
  const double last_wall_time = frame_group_start_time;
  const double last_frame_count = max(frame_group_count,1);
  const double last_frame_count_inv = 1.0 / last_frame_count;
  frame_group_start_time = time_wall_fp();
  const double group_duration = frame_group_start_time - last_wall_time;
  const double group_duration_inv = 1.0 / group_duration;

  while ( pTimer_Info* const ti = timer_info.iterate() )
    {
      ti->frac = ti->duration * group_duration_inv;
      ti->last = ti->per_frame
        ? ti->duration * last_frame_count_inv
        : ti->duration / max(1,ti->end_count);
      ti->duration = 0;  ti->end_count = 0;
    }

  gpu_tlast = 1e-9 * gpu_tsum_ns * last_frame_count_inv;
  cpu_tlast = cpu_tsum * last_frame_count_inv;
  cuda_tlast = 1e-3 * cuda_tsum_ms * last_frame_count_inv;
  frame_rate = last_frame_count / group_duration;
  cpu_frac = cpu_tsum / group_duration;
  gpu_frac = 1e-9 * gpu_tsum_ns / group_duration;
  cuda_frac = 1e-3 * cuda_tsum_ms / group_duration;
  if ( work_description )
    {
      work_rate = work_multiplier * work_accum / group_duration;      
    }
  var_reset();
}

void
pFrame_Timer::frame_start()
{
  if ( !inited ) init();
  pError_Check();
  if ( query_timer_id ) glBeginQuery(GL_TIME_ELAPSED_EXT,query_timer_id);
  pError_Check();
  time_render_start = time_wall_fp();
  if ( frame_group_count++ >= frame_group_size ) frame_rate_group_start();
}

void
pFrame_Timer::frame_end()
{
  const double time_render_elapsed = time_wall_fp() - time_render_start;
  if ( query_timer_id )
    {
      glEndQuery(GL_TIME_ELAPSED_EXT);
      int timer_val = 0;
      glGetQueryObjectiv(query_timer_id,GL_QUERY_RESULT,&timer_val);
      gpu_tsum_ns += timer_val;
    }
  cpu_tsum += time_render_elapsed;
  const uint xfcount_prev = xfcount;
  if ( ptr_glXGetVideoSyncSGI ) ptr_glXGetVideoSyncSGI(&xfcount);
  frame_rate_text = "";

  frame_rate_text.sprintf("FPS: %.2f XF ", frame_rate);
  if ( ptr_glXGetVideoSyncSGI )
    frame_rate_text.sprintf("%2d", xfcount - xfcount_prev );
  else
    frame_rate_text += "--";

  frame_rate_text += "  GPU.GL ";
  if ( query_timer_id )
    frame_rate_text.sprintf
      ("%6.3f ms (%4.1f%%)", 1000 * gpu_tlast, 100 * gpu_frac);
  else
    frame_rate_text += "---";

  frame_rate_text += "  GPU.CU ";
  if ( cuda_in_use )
    frame_rate_text.sprintf
      ("%6.3f ms (%4.1f%%)", 1000 * cuda_tlast, 100 * cuda_frac);
  else
    frame_rate_text += "---";

  frame_rate_text.sprintf
    ("  CPU %6.2f ms (%4.1f%%)", 1000 * cpu_tlast, 100 * cpu_frac);

  if ( work_description )
    frame_rate_text.sprintf("  %s %7.1f", work_description, work_rate);

  while ( pTimer_Info* const ti = timer_info.iterate() )
    {
      struct { double mult; const char* lab; } fmt;
      if ( ti->last >= 0.001 ) { fmt.mult = 1000; fmt.lab = "ms"; } 
      else { fmt.mult =1e6; fmt.lab= "us"; }
      frame_rate_text.sprintf
        ("  %s %7.3f %s (%4.1f%%)", ti->label.s,
         fmt.mult * ti->last, fmt.lab, 100 * ti->frac);
    }
}

#endif

struct pVariable_Control_Elt
{
  char *name;
  float *var;
  float inc_factor, dec_factor;
  int *ivar;
  int inc, min, max;
  bool exponential;
  double get_val() const { return var ? *var : double(*ivar); }
};

class pVariable_Control {
public:
  pVariable_Control()
  {
    size = 0;  storage = (pVariable_Control_Elt*)malloc(0); current = NULL;
    inc_factor_def = pow(10,1.0/45);
  }
  void insert(int &var, const char *name, int inc = 1,
              int min = 0, int max = 0x7fffffff )
  {
    pVariable_Control_Elt* const elt = insert_common(name);
    elt->ivar = &var;
    elt->inc = 1;
    elt->min = min;
    elt->max = max;
    elt->exponential = false;
  }

  void insert(float &var, const char *name, float inc_factor = 0, 
              bool exponentialp = true )
  {
    pVariable_Control_Elt* const elt = insert_common(name);
    elt->var = &var;
    elt->inc_factor = inc_factor ? inc_factor : inc_factor_def;
    elt->dec_factor = 1.0 / elt->inc_factor;
    elt->exponential = exponentialp;
  }

  void insert_linear(float &var, const char *name, float inc_factor = 0)
  { insert(var,name,inc_factor,false); }

  void insert_power_of_2
  (int &var, const char *name, int min = 1, int max = 0x7fffffff)
  {
    pVariable_Control_Elt* const elt = insert_common(name);
    elt->ivar = &var;
    elt->inc_factor = 1;
    elt->dec_factor = 1;
    elt->min = min;
    elt->max = max;
    elt->exponential = true;
  }

private:
  pVariable_Control_Elt* insert_common(const char *name)
  {
    size++;
    const int cidx = current - storage;
    storage = (pVariable_Control_Elt*)realloc(storage,size*sizeof(*storage));
    pVariable_Control_Elt* const elt = &storage[size-1];
    current = &storage[ size == 1 ? 0 : cidx ];
    elt->name = strdup(name);
    elt->ivar = NULL;
    elt->var = NULL;
    return elt;
  }
public:

  void adjust_higher() {
    if ( !current ) return;
    if ( current->var )
      {
        if ( current->exponential ) current->var[0] *= current->inc_factor;
        else                        current->var[0] += current->inc_factor;
      }
    else
      {
        if ( current->exponential ) current->ivar[0] <<= 1;
        else                        current->ivar[0] += current->inc;
        set_min(current->ivar[0],current->max);
      }
  }
  void adjust_lower() {
    if ( !current ) return;
    if ( current->var )
      {
        if ( current->exponential ) current->var[0] *= current->dec_factor;
        else                        current->var[0] -= current->inc_factor;
      }
    else
      {
        if ( current->exponential ) current->ivar[0] >>= 1;
        else                        current->ivar[0] -= current->inc;
        set_max(current->ivar[0],current->min);
      }
  }
  void switch_var_right()
  {
    if ( !current ) return;
    current++;
    if ( current == &storage[size] ) current = storage;
  }
  void switch_var_left()
  {
    if ( !current ) return;
    if ( current == storage ) current = &storage[size];
    current--;
  }
  int size;
  pVariable_Control_Elt *storage, *current;
  float inc_factor_def;
};

const void* const all_glut_fonts[] =
  { GLUT_STROKE_ROMAN,
    GLUT_STROKE_MONO_ROMAN,
    GLUT_BITMAP_9_BY_15,
    GLUT_BITMAP_8_BY_13,
    GLUT_BITMAP_TIMES_ROMAN_10,
    GLUT_BITMAP_TIMES_ROMAN_24,
    GLUT_BITMAP_HELVETICA_10,
    GLUT_BITMAP_HELVETICA_12,
    GLUT_BITMAP_HELVETICA_18 };

const void* const glut_fonts[] =
  { 
    GLUT_BITMAP_TIMES_ROMAN_10,
    GLUT_BITMAP_HELVETICA_10,
    GLUT_BITMAP_HELVETICA_12,
    GLUT_BITMAP_8_BY_13,
    GLUT_BITMAP_9_BY_15,
    GLUT_BITMAP_HELVETICA_18,
    GLUT_BITMAP_TIMES_ROMAN_24
 };

class pOpenGL_Helper {
public:
  pOpenGL_Helper(int& argc, char** argv)
  {
    animation_frame_count = 0;
    animation_qscale = 5;  // Quality, 1-31; 1 is best.
    animation_video_count = 0; // Number of videos generated.
    animation_frame_rate = 60;
    animation_record = false;
    user_text_reprint_called = false;
    glut_font_idx = 2;
    opengl_helper_self_ = this;
    width = height = 0;
    frame_period = -1; // No timer callback.
    next_frame_time = 0;
    cb_keyboard();
    ogl_debug = false;
    init_gl(argc, argv);
    glDebugMessageCallback(debug_msg_callback,(void*)this);
  }
  ~pOpenGL_Helper(){}

  void rate_set(double frames_per_second)
  {
    frame_period = 1.0 / frames_per_second;
    animation_frame_rate = int(0.5 + frames_per_second);
  }

  static void
  debug_msg_callback
  (uint source, uint tp, uint id, uint severity, int length,
   const char* message, const void *user_data)
  { printf("--- DBG MSG severity %d\n%s\n",severity,message); }

  double next_frame_time, frame_period;
  static void cb_timer_w(int data){ opengl_helper_self_->cbTimer(data); }
  void cbTimer(int data)
  {
    glutPostRedisplay();
    if ( frame_period < 0 ) return;
    const double now = time_wall_fp();
    if ( next_frame_time == 0 ) next_frame_time = now;
    next_frame_time += frame_period;
    const double delta = next_frame_time - now;
    const int delta_ms = delta <= 0 ? 0 : int(delta * 1000);
    glutTimerFunc(delta_ms,cb_timer_w,0);
  }

  // Use DISPLAY_FUNC to write frame buffer.
  //
  void display_cb_set
  (void (*display_func)(void *), void *data)
  {
    user_display_func = display_func;
    user_display_data = data;
    glutDisplayFunc(&cb_display_w);
    glutKeyboardFunc(&cb_keyboard_w);
    glutSpecialFunc(&cb_keyboard_special_w);
# ifdef GLX_SGI_video_sync
    glutIdleFunc(cb_idle_w);
# else
    glutTimerFunc(10,cb_timer,0);
    cbTimer(0);
# endif
    glutMainLoop();
  }

  void use_timer()
  {
    glutIdleFunc(NULL);
    glutTimerFunc(10,cb_timer_w,0);
    printf("Switching from idle callback to timer callback.\n");
  }

  static void cb_idle_w(){ opengl_helper_self_->cb_idle(); }
  void cb_idle()
  {
    if ( false || !ptr_glXGetVideoSyncSGI ) { use_timer(); return; }
#   ifdef GLX_SGI_video_sync
    unsigned int count;
    ptr_glXGetVideoSyncSGI(&count);
    unsigned int count_after;
    if ( ptr_glXWaitVideoSyncSGI(1,0,&count_after) )
      {
        use_timer();
        return;
      }
    glutPostRedisplay();
# endif
  }

  bool ogl_debug_set(bool setting)
  {
    const bool rv = ogl_debug;
    ogl_debug = setting;
    if ( rv != setting ) {
      if ( setting ) glEnable(GL_DEBUG_OUTPUT);
      else           glDisable(GL_DEBUG_OUTPUT);
    }
    return rv;
  }

  // Return width and height of frame buffer.
  //
  int get_width() { return width; }
  int get_height() { return height; }

  // Key pressed by user since last call of DISPLAY_FUNC.
  // ASCII value, one of the FB_KEY_XXXX macros below, or 0 if
  // no key pressed.
  //
  int keyboard_key;
  int keyboard_modifiers;
  bool keyboard_shift, keyboard_control, keyboard_alt;
  int keyboard_x, keyboard_y;  // Mouse location when key pressed.

  PStack<pString> user_frame_text;

  // Print text in frame buffer, starting at upper left.
  // Arguments same as printf.
  //
  void fbprintf(const char* fmt, ...)
  {
    va_list ap;
    pString& str = *user_frame_text.pushi();
    va_start(ap,fmt);
    str.vsprintf(fmt,ap);
    va_end(ap);

    if ( user_text_reprint_called ) return;

    if ( !frame_print_calls ) glWindowPos2i(10,height-20);
    frame_print_calls++;

    glutBitmapString((void*)glut_fonts[glut_font_idx],(unsigned char*)str.s);
  }

  void user_text_reprint()
  {
    user_text_reprint_called = true;
    glDisable(GL_DEPTH_TEST);
    glWindowPos2i(10,height-20);
    while ( pString* const str = user_frame_text.iterate() )
      glutBitmapString
        ((void*)glut_fonts[glut_font_idx],(unsigned char*)str->s);  
    user_frame_text.reset();

    const int64_t now = int64_t( time_wall_fp() * 2 );
    if ( now & 1 && animation_record )
      {
        glWindowPos2i(10,10);
        glutBitmapString
          ((void*)glut_fonts[glut_font_idx], (unsigned char*)"REC");
      }

    glEnable(GL_DEPTH_TEST);
  }

  void cycle_font()
  {
    const int font_cnt = sizeof(glut_fonts) / sizeof(glut_fonts[0]);
    glut_font_idx++;
    if ( glut_font_idx >= font_cnt ) glut_font_idx = 0;
    printf("Changed to %d\n",glut_font_idx);
  }

private:
  void init_gl(int& argc, char** argv)
  {
    exe_file_name = argv && argv[0] ? argv[0] : "unknown name";
    glutInit(&argc, argv);
    lglext_ptr_init();

    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL );
    glutInitWindowSize(854,480);

    pStringF title("OpenGL Demo - %s",exe_file_name);

    glut_window_id = glutCreateWindow(title);

    // Note: These functions don't work before a window is created.
    //
    P_GL_PRINT_STRING(GL_VENDOR);
    P_GL_PRINT_STRING(GL_RENDERER);
    P_GL_PRINT_STRING(GL_VERSION);

  }

  static void cb_display_w(void){ opengl_helper_self_->cb_display(); }
  void cb_display(void)
  {
    shape_update();
    frame_print_calls = 0;
    user_display_func(user_display_data);

    if ( animation_record || animation_frame_count ) 
      animation_grab_frame();

    cb_keyboard();
  }

  void shape_update()
  {
    const int width_new = glutGet(GLUT_WINDOW_WIDTH);
    const int height_new = glutGet(GLUT_WINDOW_HEIGHT);
    width = width_new;
    height = height_new;
  }

  static void cb_keyboard_w(unsigned char key, int x, int y)
  {opengl_helper_self_->cb_keyboard(key,x,y);}
  static void cb_keyboard_special_w(int key, int x, int y)
  {opengl_helper_self_->cb_keyboard(key+0x100,x,y);}
  void cb_keyboard(int key=0, int x=0, int y=0)
  {
    keyboard_key = key;
    keyboard_modifiers = key ? glutGetModifiers() : 0;
    keyboard_shift = keyboard_modifiers & GLUT_ACTIVE_SHIFT;
    keyboard_alt = keyboard_modifiers & GLUT_ACTIVE_ALT;
    keyboard_control = keyboard_modifiers & GLUT_ACTIVE_CTRL;
    keyboard_x = x;
    keyboard_y = y;
    if ( !key ) return;
    if ( keyboard_key == FB_KEY_F12 ) { write_img(); return; }
    if ( keyboard_key == FB_KEY_F11 ) { cycle_font(); return; }
    if ( keyboard_key == FB_KEY_F10 )
      { 
        animation_record = !animation_record; 
        printf("Animation recording %s\n",
               animation_record ? "starting, press F10 to stop." : "ending");
        return;
      }
    glutPostRedisplay();
  }

  Magick::Image* image_new(int format)
  {
    using namespace Magick;
    glReadBuffer(GL_FRONT_LEFT);
    const int size = width * height;
    int bsize;
    const char* im_format;
    switch ( format ){
    case GL_RGBA: bsize = size * 4; im_format = "RGBA"; break;
    case GL_RGB: bsize = size * 3; im_format = "RGB"; break;
    default: bsize = 0; im_format = ""; ASSERTS( false );
    }
    char* const pb = (char*) malloc(bsize);
    glPixelStorei(GL_PACK_ALIGNMENT,1);
    glReadPixels(0,0,width,height,format,GL_UNSIGNED_BYTE,pb);
    Image* const image = new Image( width, height, im_format, CharPixel, pb);
    image->flip();
    free(pb);
    return image;
  }

public:
  void write_img(const char* file_name = NULL)
  {
    using namespace Magick;
    pStringF file_name_default("%s.png",exe_file_name);
    Image* const image = image_new(GL_RGBA);
    image->write(file_name ? file_name : file_name_default.s);
    delete image;
  }

  bool animation_record;
  int animation_qscale;
  int animation_frame_rate;
private:
  int animation_frame_count;
  int animation_video_count;

  void animation_grab_frame()
  {
    using namespace Magick;
    if ( animation_frame_count > 6000 ) animation_record = false;
    const char* const ifmt = "tiff";
    if ( !animation_record )
      {
        if ( !animation_frame_count ) return;
        pStringF video_file_name
          ("%s-%d.mp4", exe_file_name, animation_video_count);
        animation_video_count++;
        // http://www.ffmpeg.org/ffmpeg-doc.html
        // -b BITRATE
        // -vframes NUM
        // -r FPS
        // -pass [1|2]
        // -qscale NUM   Quality, 1-31; 1 is best.
        PSplit dir_pieces(__FILE__,'/');
        if ( dir_pieces.occ() > 1 ) dir_pieces.pop();
        pString this_dir(dir_pieces.joined_copy());
        pStringF ffmpeg_path("%s/bin/ffmpeg",this_dir.s);
        pStringF ffplay_path("%s/bin/ffplay",this_dir.s);
        pStringF ffmpeg_cmd
          ("%s -r %d -qscale %d -i /tmp/frame%%04d.%s "
           "-vframes %d  -y %s",
           ffmpeg_path.s,
           animation_frame_rate,
           animation_qscale,
           ifmt, animation_frame_count, video_file_name.s);
        system(ffmpeg_cmd.s);
        printf("Generated video from %d frames, filename %s, using:\n%s\n",
               animation_frame_count,
               video_file_name.s, ffmpeg_cmd.s);
        printf("Copy, edit, paste command above to regenerate video, \n");
        printf("visit http://www.ffmpeg.org/ffmpeg-doc.html for more info.\n");
        printf("Use the following command to view:\n%s %s\n",
               ffplay_path.s, video_file_name.s);
        animation_frame_count = 0;
        return;
      }
    Image* const image = image_new(GL_RGB);
    pStringF image_path("/tmp/frame%04d.%s",animation_frame_count,ifmt);
    animation_frame_count++;
    image->depth(8);
    image->write(image_path.s);
    delete image;
  }

private:
  const char* exe_file_name;
  bool ogl_debug;
  double render_start;
  int width;
  int height;
  int frame_print_calls;
  bool user_text_reprint_called;
  int glut_font_idx;
  int glut_window_id;
  void (*user_display_func)(void *data);
  void *user_display_data;

};

#endif
