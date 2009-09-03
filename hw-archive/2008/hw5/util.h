// -*- c++ -*-

#ifndef UTIL_H
#define UTIL_H

#include <time.h>
#include <stdio.h>
#include <stdarg.h>

#include "glextfuncs.h"
#include "pstring.h"

template<typename T> T min(T a, T b){ return a < b ? a : b; }
template<typename T> T max(T a, T b){ return a > b ? a : b; }

double
time_wall_fp()
{
  struct timespec now;
  clock_gettime(CLOCK_REALTIME,&now);
  return now.tv_sec + ((double)now.tv_nsec) * 1e-9;
}

double
time_process_fp()
{
  struct timespec now;
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID,&now);
  return now.tv_sec + ((double)now.tv_nsec) * 1e-9;
}

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

inline void
pError_Exit()
{
  exit(1);
}

inline void
pError_Msg(const char *msg)
{
  fprintf(stderr,"User Error: %s\n",msg);
  pError_Exit();
}

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
pOpenGL_Helper* opengl_helper_self_ = NULL;

class pFrame_Timer {
public:
  pFrame_Timer():inited(false),work_description(NULL)
  {
    query_timer_id = 0;
    frame_group_size = 10;
    frame_rate = 0;
    cpu_frac = 0;
  }
  void work_unit_set(const char *description, double multiplier = 1)
  {
    work_multiplier = multiplier;
    work_accum = 0;
    work_description = strdup(description);
  }
  void work_amt_set(int amt){ work_accum += amt; }
  void init();
  void frame_start();
  void frame_end();
  const char* frame_rate_text_get() const { return frame_rate_text.s; }
  int frame_group_size;
private:
  void frame_rate_group_start();
  void var_reset()
  {
    frame_group_count = 0;
    cpu_tsum = tsum = 0;
    work_accum = 0;
  }
  bool inited;
  double frame_group_start_time;
  int frame_group_count;
  double tsum, tlast, cpu_tsum, cpu_tlast;
  double work_accum;
  double work_multiplier;
  int work_count_last;
  char *work_description;
  double work_rate;

  double frame_rate;
  double cpu_frac;
  double time_render_start;
  GLuint query_timer_id;
  uint xfcount;  // Frame count provided by glx.
  pString frame_rate_text;
};

void
pFrame_Timer::init()
{
  inited = true;
  if ( glutExtensionSupported("GL_EXT_timer_query") )
    glGenQueries(1,&query_timer_id);
  frame_group_start_time = time_wall_fp();
  var_reset();
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

  tlast = 1e-6 * tsum * last_frame_count_inv;
  cpu_tlast = cpu_tsum * last_frame_count_inv;
  frame_rate = last_frame_count / group_duration;
  cpu_frac = cpu_tsum / group_duration;
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
  time_render_start = time_process_fp();
  if ( frame_group_count++ >= frame_group_size ) frame_rate_group_start();
}

void
pFrame_Timer::frame_end()
{
  const double time_render_elapsed = time_process_fp() - time_render_start;
  if ( query_timer_id )
    {
      glEndQuery(GL_TIME_ELAPSED_EXT);
      int timer_val = 0;
      glGetQueryObjectiv(query_timer_id,GL_QUERY_RESULT,&timer_val);
      tsum += timer_val;
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

  frame_rate_text += "  GPU ";
  if ( query_timer_id )
    frame_rate_text.sprintf("%.3f us",tlast);
  else
    frame_rate_text += "---";

  frame_rate_text.sprintf
    ("  CPU %.2f ms (%.1f%%)", 1000 * cpu_tlast, 100 * cpu_frac);

  if ( work_description )
    frame_rate_text.sprintf("  %s %.3f", work_description, work_rate);
}

struct pVariable_Control_Elt {float *var; char *name;};

class pVariable_Control {
public:
  pVariable_Control()
  {
    size = 0;  storage = (pVariable_Control_Elt*)malloc(0); current = NULL;
  }
  void insert(float &var, const char *name)
  {
    size++;
    const int cidx = current - storage;
    storage = (pVariable_Control_Elt*)realloc(storage,size*sizeof(*storage));
    pVariable_Control_Elt* const elt = &storage[size-1];
    elt->var = &var;
    elt->name = strdup(name);
    current = &storage[ size == 1 ? 0 : cidx ];
  }
  void adjust_higher() {if ( current ) current->var[0] *= 1.05;}
  void adjust_lower() {if ( current ) current->var[0] *= 0.95;}
  void switch_var_right()
  {
    if ( !current ) return;
    current++;
    if ( current == &storage[size] ) current = storage;
  }
  int size;
  pVariable_Control_Elt *storage, *current;
};


class pOpenGL_Helper {
public:
  pOpenGL_Helper(int& argc, char** argv)
  {
    opengl_helper_self_ = this;
    width = height = 0;
    frame_period = -1; // No timer callback.
    next_frame_time = 0;
    cb_keyboard();
    init_gl(argc, argv);
    lglext_ptr_init();
  }
  ~pOpenGL_Helper(){}

  void rate_set(double frames_per_second)
  {
    frame_period = 1.0 / frames_per_second;
  }

  double next_frame_time, frame_period;
  static void cb_timer_w(int data){ opengl_helper_self_->cbTimer(data); }
  void cbTimer(int data)
  {
    glutPostRedisplay();
    if ( frame_period < 0 ) return;
    if ( next_frame_time == 0 ) next_frame_time = time_wall_fp();
    const double now = time_wall_fp();
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
    cbTimer(0);
    glutMainLoop();
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
  int keyboard_x, keyboard_y;  // Mouse location when key pressed.

  // Print text in frame buffer, starting at upper left.
  // Arguments same as printf.
  //
  void fbprintf(const char* fmt, ...)
  {
    va_list ap;
    pString str;
    va_start(ap,fmt);
    str.vsprintf(fmt,ap);
    va_end(ap);
    glutBitmapString(GLUT_BITMAP_HELVETICA_12,(unsigned char*)str.s);
  }

private:
  void init_gl(int& argc, char** argv)
  {
    exe_file_name = argv && argv[0] ? argv[0] : "unknown name";
    glutInit(&argc, argv);

    glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH );
    glutInitWindowSize(640,480);

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
    glWindowPos2i(10,height-20);
    user_display_func(user_display_data);
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
    keyboard_x = x;
    keyboard_y = y;
    if ( !key ) return;
    if ( keyboard_key == FB_KEY_F12 ) { write_img(); return; }
    glutPostRedisplay();
  }

  void write_img()
  {
    pStringF pipe_name("pnmtopng > %s.png",exe_file_name);
    FILE* const fp = popen(pipe_name, "w");
    if ( !fp )
      {
        fprintf(stderr, "Could not open pipe for screenshot.\n");
        return;
      }
    fprintf(fp,"P6\n%d %d 255\n",width,height);
    glReadBuffer(GL_FRONT_LEFT);
    const int size = width * height;
    char* const pbuffer = (char*) malloc(size * 3);
    glReadPixels(0,0,width,height,GL_RGB,GL_UNSIGNED_BYTE,pbuffer);
    for ( int y=height-1; y>=0; y-- )
      {
        char* row = &pbuffer[ y * width * 3 ];
        for ( int x=0; x<width; x++ )
          {
            putc(row[0],fp); putc(row[1],fp); putc(row[2],fp);
            row += 3;
          }
      }
    pclose(fp);
    free(pbuffer);
  }

private:
  const char* exe_file_name;
  double render_start;
  int width;
  int height;  // Height of simulated frame buffer, not displayed window.
  int glut_window_id;
  void (*user_display_func)(void *data);
  void *user_display_data;

};

#endif
