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
#include <assert.h>

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
    query_objects[0] = 0;
    query_pending = false;
    frame_group_size = 5;
    frame_rate = 0;
    cpu_frac = 0;
    cuda_in_use = false;
    phys_timed = false;
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
  void phys_start();
  void phys_end();
  void frame_start();
  void frame_end();
  const char* frame_rate_text_get() const { return frame_rate_text.s; }
  int frame_group_size;
  void cuda_frame_time_set(float time_ms)
  { cuda_tsum_ms += time_ms; cuda_in_use = true; }
private:
  void frame_rate_group_start_check();
  void frame_rate_group_start();
  void var_reset()
  {
    frame_group_count = 0;
    phys_tsum = cpu_tsum = gpu_tsum_ns = cuda_tsum_ms = 0;
    work_accum = 0;
  }
  bool inited;
  bool cuda_in_use;
  bool frame_inside;
  bool phys_inside;
  bool phys_timed;
  double frame_group_start_time;
  int frame_group_count;
  double gpu_tsum_ns, gpu_tlast, cpu_tsum, cpu_tlast, cuda_tsum_ms, cuda_tlast;
  double phys_tsum, phys_tlast;
  double work_accum;
  double work_multiplier;
  int work_count_last;
  char *work_description;
  double work_rate;

  double frame_rate;
  double cpu_frac, gpu_frac, cuda_frac, phys_frac;
  double time_render_start;
  double time_phys_start;
  union {
    struct { GLuint query_objects[12]; };
    struct { GLuint qo_timer[2],
        qo_vtx_sub[2], qo_vtx_inv[2], qo_frag_inv[2], qo_clp_pin[2],
        qo_clp_pout[2];
    };
  };
  int qa_idx;
  GLint qv_vtx_sub, qv_vtx_inv, qv_clp_pin, qv_clp_pout, qv_frag_inv;
  bool query_pending;
  uint xfcount;  // Frame count provided by glx.
  pString frame_rate_text;

  PStack<pTimer_Info> timer_info;
};

#ifndef GP_UTIL_DECLARE_ONLY

void
pFrame_Timer::init()
{
  inited = true;
  frame_inside = false;
  phys_inside = false;
  glGenQueries(sizeof(query_objects)/sizeof(query_objects[0]),query_objects);
  qa_idx = 0;
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
pFrame_Timer::frame_rate_group_start_check()
{
  if ( frame_group_count++ >= frame_group_size
       && time_wall_fp() - frame_group_start_time > 1 )
    frame_rate_group_start();
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
  phys_tlast = phys_tsum * last_frame_count_inv;
  cuda_tlast = 1e-3 * cuda_tsum_ms * last_frame_count_inv;
  frame_rate = last_frame_count / group_duration;
  cpu_frac = cpu_tsum / group_duration;
  phys_frac = phys_tsum / group_duration;
  gpu_frac = 1e-9 * gpu_tsum_ns / group_duration;
  cuda_frac = 1e-3 * cuda_tsum_ms / group_duration;
  if ( work_description )
    {
      work_rate = work_multiplier * work_accum / group_duration;      
    }
  var_reset();
}

void
pFrame_Timer::phys_start()
{
  if ( !inited ) init();
  phys_timed = true;
  frame_rate_group_start_check();
  assert( !phys_inside );
  phys_inside = true;
  time_phys_start = time_wall_fp();
}

void
pFrame_Timer::phys_end()
{
  const double time_phys_elapsed = time_wall_fp() - time_phys_start;
  phys_tsum += time_phys_elapsed;
  phys_inside = false;
}

void
pFrame_Timer::frame_start()
{
  if ( !inited ) init();
  if ( phys_inside ) phys_end();
  assert( !frame_inside );
  frame_inside = true;
  pError_Check();
  if ( query_objects[0] )
    {
      glBeginQuery(GL_TIME_ELAPSED,qo_timer[qa_idx]);
      glBeginQuery(GL_VERTICES_SUBMITTED_ARB,qo_vtx_sub[qa_idx]);
      glBeginQuery(GL_VERTEX_SHADER_INVOCATIONS_ARB,qo_vtx_inv[qa_idx]);
      glBeginQuery(GL_CLIPPING_INPUT_PRIMITIVES_ARB,qo_clp_pin[qa_idx]);
      glBeginQuery(GL_CLIPPING_OUTPUT_PRIMITIVES_ARB,qo_clp_pout[qa_idx]);
      glBeginQuery(GL_FRAGMENT_SHADER_INVOCATIONS_ARB,qo_frag_inv[qa_idx]);
    }
  pError_Check();
  time_render_start = time_wall_fp();
  if ( !phys_timed ) frame_rate_group_start_check();
}

inline string
commaize(int64_t i)
{
  if ( abs(i) < 10000 ) return to_string(i);
  bool n = i < 0;
  int64_t a = n ? -i : i;
  string as = to_string(a);
  string is = n ? "-" : "";
  int gpos = as.size() % 3 ?: 3;
  for ( char c: as )
    {
      // 3 999;  2 99;  1 9;
      is += c;
      gpos--;
      if ( gpos == 0 ) { is += ","; gpos = 3; }
    }
  assert( is.back() == ',' );
  is.pop_back();
  return move(is);
}

void
pFrame_Timer::frame_end()
{
  const double time_render_elapsed = time_wall_fp() - time_render_start;
  if ( query_objects[0] )
    {
      glEndQuery(GL_TIME_ELAPSED);
      glEndQuery(GL_VERTICES_SUBMITTED_ARB);
      glEndQuery(GL_VERTEX_SHADER_INVOCATIONS_ARB);
      glEndQuery(GL_CLIPPING_INPUT_PRIMITIVES_ARB);
      glEndQuery(GL_CLIPPING_OUTPUT_PRIMITIVES_ARB);
      glEndQuery(GL_FRAGMENT_SHADER_INVOCATIONS_ARB);

      qa_idx = 1 - qa_idx;
      if ( query_pending )
        {
          int timer_val = 0;
          glGetQueryObjectiv(qo_timer[qa_idx],GL_QUERY_RESULT,&timer_val);
          glGetQueryObjectiv(qo_vtx_sub[qa_idx],GL_QUERY_RESULT,&qv_vtx_sub);
          glGetQueryObjectiv(qo_vtx_inv[qa_idx],GL_QUERY_RESULT,&qv_vtx_inv);
          glGetQueryObjectiv(qo_clp_pin[qa_idx],GL_QUERY_RESULT,&qv_clp_pin);
          glGetQueryObjectiv(qo_clp_pout[qa_idx],GL_QUERY_RESULT,&qv_clp_pout);
          glGetQueryObjectiv(qo_frag_inv[qa_idx],GL_QUERY_RESULT,&qv_frag_inv);
          gpu_tsum_ns += timer_val;
        }
      query_pending = true;
    }
  assert( frame_inside );
  frame_inside = false;
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
  if ( query_objects[0] )
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
    ("  CPU GR %6.2f ms (%4.1f%%)", 1000 * cpu_tlast, 100 * cpu_frac);

  if ( phys_timed )
    frame_rate_text.sprintf
      ("  CPU PH %6.2f ms (%4.1f%%)", 1000 * phys_tlast, 100 * phys_frac);

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
  frame_rate_text.sprintf
    ("\n Vertices: %s   Clip Prim: in %s  out %s   "
     "Fragments: %s   Frag/Vtx: %.1f",
     commaize(qv_vtx_inv).c_str(),
     commaize(qv_clp_pin).c_str(),
     commaize(qv_clp_pout).c_str(),
     commaize(qv_frag_inv).c_str(),
     double(qv_frag_inv)/max(1,qv_vtx_inv));

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


class pGL_Restore_Later {
public:
  pGL_Restore_Later(const vector<GLuint> caps)
    {
      for ( auto cap: caps ) settings.emplace_back( glIsEnabled(cap), cap );
    }
  ~pGL_Restore_Later()
    {
      for ( auto s: settings )
        if ( get<0>(s) ) glEnable(get<1>(s)); else glDisable(get<1>(s));
    }

  vector<tuple<bool,GLuint> > settings;
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

  vector<pString> user_frame_text;

  // Print text in frame buffer, starting at upper left.
  // Arguments same as printf.
  //
  void fbprintf(const char* fmt, ...)
  {
    va_list ap;
    user_frame_text.emplace_back();
    pString& str = user_frame_text.back();
    va_start(ap,fmt);
    str.vsprintf(fmt,ap);
    va_end(ap);

    if ( user_text_reprint_called ) return;

    frame_print_calls++;
    glut_stroke_print(str.s);
  }

  void glut_stroke_window_change()
  {
    glGetFloatv( GL_SMOOTH_LINE_WIDTH_RANGE, glut_line_range_px );

    const float win_ht_lines = height / ( px_per_point * font_size_pt );
    height_mx = win_ht_lines * glut_font_height;
    const float condense_factor = 1.4; // Amount by which to squish font.
    width_mx = condense_factor * height_mx / height * width;
    const float stroke_width_pt = font_size_pt / 20.0f;
    glut_stroke_width_px =
      std::min
      ( glut_line_range_px[1],
        std::max(1.0f,stroke_width_pt * px_per_point) );
    glut_stroke_sx = 2/width_mx;
    glut_stroke_sy = 2/height_mx;
    glut_x_mx_per_px = width_mx / width;
    glut_y_mx_per_px = height_mx / height;
    glut_stroke_line_first = height_mx/2-glut_font_height*1.5;
    glut_stroke_line_last = -height_mx/2+glut_font_height*0.5;
    const float ex = glutStrokeWidth(glut_fontid,'X');
    for ( auto& e: glut_stroke_mv ) e = 0;
    for ( int i: {0,5,10,15} ) glut_stroke_mv[i] = 1;
    glut_stroke_mv[3] = ex - width_mx/2;
    glut_stroke_mv[7] = glut_stroke_line_first;
  }

  void glut_stroke_frame_start()
  {
    glut_stroke_goto_line(0);
  }

  void glut_stroke_goto_line(float line)
    {
      glut_stroke_mv[7] =
        ( line>=0 ? glut_stroke_line_first : glut_stroke_line_last )
        - line * glut_font_height;
    }

  void glut_stroke_print(const char *s)
  {
    if ( s[0] == 0 ) return;
    const char *sp = s;
    int nlines = 0;
    while ( char c = *sp++ ) if ( c == '\n' ) nlines++;
    assert ( sp[-1] == 0 );
    if ( sp[-2] != '\n' ) nlines++;

    const bool antialias = glut_stroke_width_px > 1.25;

    pGL_Restore_Later restore_later
      ({GL_LIGHTING,GL_DEPTH_TEST,GL_LINE_SMOOTH,GL_TEXTURE_2D,GL_BLEND});

    glDisable(GL_TEXTURE_2D);

    if ( antialias )
      {
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
        glBlendEquation(GL_FUNC_ADD);
        glEnable(GL_LINE_SMOOTH);
      }
    else
      {
        glDisable(GL_BLEND);
        glDisable(GL_LINE_SMOOTH);
      }

    int shade_model;
    glGetIntegerv(GL_SHADE_MODEL,&shade_model);
    glDisable(GL_LIGHTING);
    glShadeModel(GL_FLAT);
    glDisable(GL_DEPTH_TEST);

    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glScalef(glut_stroke_sx,glut_stroke_sy,1);

    for ( int i: {0,1} )
      {
        glMatrixMode(GL_MODELVIEW);
        glPushMatrix();
        glLoadTransposeMatrixf(glut_stroke_mv);
        if ( i == 0 )
          {
            float s_n = 2.0f;
            float s_px =
              std::min( s_n * glut_stroke_width_px, glut_line_range_px[1] );
            glColor3f(0,0,0);
            glLineWidth( s_px );
            glTranslatef
              (glut_stroke_width_px*glut_x_mx_per_px,
               -glut_stroke_width_px*glut_y_mx_per_px,0);
          }
        else
          {
            glColor3f(0,1,0);
            glLineWidth( glut_stroke_width_px );
          }
        glutStrokeString(glut_fontid,(unsigned char*)s);
        glMatrixMode(GL_MODELVIEW);
        glPopMatrix();
      }

    glMatrixMode(GL_PROJECTION);
    glPopMatrix();

    glShadeModel(shade_model);

    glut_stroke_mv[7] -= glut_font_height * nlines;

  }

  void user_text_reprint()
  {
    user_text_reprint_called = true;
    glut_stroke_goto_line(0);
    pString all;
    for ( auto& s: user_frame_text ) all += s;
    glut_stroke_print(all.s);
    user_frame_text.clear();

    const int64_t now = int64_t( time_wall_fp() * 2 );
    if ( now & 1 && animation_record )
      {
        glut_stroke_goto_line(-1);
        glut_stroke_print("REC");
      }
  }

private:
  void init_gl(int& argc, char** argv)
  {
    exe_file_name = argv && argv[0] ? argv[0] : "unknown name";
    glutInit(&argc, argv);
    lglext_ptr_init();

    // Set window size to half the height of the display and
    // to a 19:9 aspect ratio.
    //
    const int screen_ht = glutGet(GLUT_SCREEN_HEIGHT);
    const int screen_wd = glutGet(GLUT_SCREEN_WIDTH);
    const int req_ht = screen_ht / 2;
    const int req_wd = req_ht * 16 / 9; // Match desired aspect ratio.

    const int screen_wd_mm = glutGet(GLUT_SCREEN_WIDTH_MM);
    px_per_point = float(screen_wd) / ( screen_wd_mm / 25.4 * 72 );
    font_size_pt = 10;

    // The other option: GLUT_STROKE_ROMAN,
    glut_fontid = (void*) GLUT_STROKE_MONO_ROMAN;
    glut_font_height = glutStrokeHeight(glut_fontid);

    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH | GLUT_STENCIL );
    glutInitWindowSize(req_wd,req_ht);

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
    glut_stroke_frame_start();
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
    glut_stroke_window_change();
  }

  static void cb_keyboard_w(unsigned char key, int x, int y)
  {opengl_helper_self_->cb_keyboard(key,x,y);}
  static void cb_keyboard_special_w(int key, int x, int y)
  {opengl_helper_self_->cb_keyboard(key+0x100,x,y);}
  void cb_keyboard(int key=0, int x=0, int y=0)
  {
    keyboard_key = 0;
    keyboard_modifiers = key ? glutGetModifiers() : 0;
    keyboard_shift = keyboard_modifiers & GLUT_ACTIVE_SHIFT;
    keyboard_alt = keyboard_modifiers & GLUT_ACTIVE_ALT;
    keyboard_control = keyboard_modifiers & GLUT_ACTIVE_CTRL;
    keyboard_x = x;
    keyboard_y = y;
    if ( !key ) return;
    if ( key == FB_KEY_F12 ) { write_img(); return; }
    if ( keyboard_control && ( key == '+' || key == '=' ) )
      {  font_size_pt *= 1.1;  return; }
    if ( keyboard_control && ( key == '-' || key == '_' ) )
      {  font_size_pt /= 1.1;  return; }
    if ( key == FB_KEY_F11 )
      {
        if ( keyboard_shift )
          font_size_pt /= 1.1;
        else
          font_size_pt *= 1.1;
        return;
      }
    if ( key == FB_KEY_F10 )
      { 
        animation_record = !animation_record; 
        printf("Animation recording %s\n",
               animation_record ? "starting, press F10 to stop." : "ending");
        return;
      }
    keyboard_key = key;
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
  float font_size_pt;
  float px_per_point;
  void *glut_fontid;
  float glut_font_height;
  float glut_stroke_width_px;
  float glut_baselineskip_m;
  float glut_stroke_mv[16];
  float glut_stroke_sx, glut_stroke_sy;
  float glut_stroke_line_first, glut_stroke_line_last;
  float glut_x_mx_per_px, glut_y_mx_per_px;
  float glut_line_range_px[2];
  float height_mx, width_mx;

  int frame_print_calls;
  bool user_text_reprint_called;
  int glut_window_id;
  void (*user_display_func)(void *data);
  void *user_display_data;

};

#endif
