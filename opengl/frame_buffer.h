/// LSU EE 7700-2 (Sp 08), Graphics Processors  -*- c++ -*-
//
 ///  CPU-Only Demos' Include File

 // $Id:$

 /// Purpose

//  Frame buffer simulation class and support functions. 


#ifndef FRAME_BUFFER_H
#define FRAME_BUFFER_H
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/freeglut.h>
#include <stdarg.h>
#include <deque>
#include <string>

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

typedef int int32_t;

class pFrame_Buffer;
pFrame_Buffer* frame_buffer_self_ = NULL;

inline void
pError_Exit()
{
  exit(1);
}

inline void
pError_Msg(char *msg)
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


// Print OpenGL string attribute corresponding to token.
//
#define FB_GL_PRINT_STRING(token)                        \
{ const char* const str = (char*) glGetString(token); \
  printf("S %s - ",#token); \
  if ( str ) printf("\"%s\"\n",str); else printf("not available.\n"); \
}

// Return number of seconds since 1970 UTC.
//
double
time_wall_fp()
{
  struct timespec now;
  clock_gettime(CLOCK_REALTIME,&now);
  return now.tv_sec + ((double)now.tv_nsec) * 1e-9;
}

// Basic Frame Buffer Simulation
//
class pFrame_Buffer {
public:
  pFrame_Buffer(int& argc, char** argv)
  {
    frame_buffer_self_ = this;
    width = height = 0;
    cb_keyboard();
    init_gl(argc, argv);
  }
  ~pFrame_Buffer(){}

  // Use DISPLAY_FUNC to write frame buffer.
  //
  void show(void (*display_func)(pFrame_Buffer& fb))
  {
    user_display_func = display_func;
    glutDisplayFunc(&cb_display_w);
    glutKeyboardFunc(&cb_keyboard_w);
    glutSpecialFunc(&cb_keyboard_special_w);
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
  void fbprintf(const char* fmt,...)
  {
    va_list ap;
    va_start(ap,fmt);
    const int size = vsnprintf(NULL,0,fmt,ap);
    va_end(ap);
    char* const buffer = (char*) malloc(size+1);
    va_start(ap,fmt);
    vsprintf(buffer,fmt,ap);
    va_end(ap);
    print_list.push_back(buffer);
  }

  // Tell frame buffer object that this is when DISPLAY_FUNC will
  // start rendering computations. Should be placed where application-related
  // code ends and rendering pipeline code starts.
  //
  void render_timing_start()
  {
    render_start = time_wall_fp();
  }

private:
  void init_gl(int& argc, char** argv)
  {
    exe_file_name = argv && argv[0] ? argv[0] : "unknown name";
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH );
    glutInitWindowSize(640,480+status_height);

    std::string title("OpenGL Demo - " + exe_file_name);

    glut_window_id = glutCreateWindow(title.c_str());

    FB_GL_PRINT_STRING(GL_VENDOR);
    FB_GL_PRINT_STRING(GL_RENDERER);
    FB_GL_PRINT_STRING(GL_VERSION);
  }

  static void cb_display_w(void){ frame_buffer_self_->cb_display(); }
  void cb_display(void)
  {
    shape_update();
    if ( keyboard_key == FB_KEY_F12 ) write_img();
    glClearColor(0.0,0.0,0.0,1);
    glClearDepth(1.0);
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glEnable(GL_NORMALIZE);
    const double frame_start = time_wall_fp();
    render_timing_start(); // User may call this in display func.
    user_display_func(*this);
    const double end_time = time_wall_fp();
    const double elapsed_time = end_time - frame_start;
    const double render_elapsed_time = end_time - render_start;
    glDisable(GL_DEPTH_TEST);
    glColor3f(1,1,1);
    glWindowPos2i(10,height+status_height-20);
    fbprintf
      ("Render Time %.3f ms,  Frame Time %.3f ms,  Potential Frame Rate %.1f\n",
       render_elapsed_time * 1000, elapsed_time * 1000, 1.0 / elapsed_time);
    char* const str = print_list.back();
    glutBitmapString(GLUT_BITMAP_HELVETICA_12,(unsigned char*)str);
    free(str);
    print_list.pop_back();

    glWindowPos2i(10,height-20);

    for ( ; !print_list.empty(); print_list.pop_front() )
      {
        char* const str = print_list.front();
        glutBitmapString(GLUT_BITMAP_HELVETICA_12,(unsigned char*)str);
        free(str);
      }

    cb_keyboard();
    glutSwapBuffers();
  }

  void shape_update()
  {
    const int width_new = glutGet(GLUT_WINDOW_WIDTH);
    const int height_new = glutGet(GLUT_WINDOW_HEIGHT) - status_height;
    width = width_new;
    height = height_new;
  }

  static void cb_keyboard_w(unsigned char key, int x, int y)
  {frame_buffer_self_->cb_keyboard(key,x,y);}
  static void cb_keyboard_special_w(int key, int x, int y)
  {frame_buffer_self_->cb_keyboard(key+0x100,x,y);}
  void cb_keyboard(int key=0, int x=0, int y=0)
  {
    keyboard_key = key;
    keyboard_x = x;
    keyboard_y = y;
    if ( !key ) return;
    glutPostRedisplay();
  }

  void write_img()
  {
    std::string pipe_name ( "pnmtopng > " + exe_file_name + ".png");
    FILE* const fp = popen(pipe_name.c_str(), "w");
    if ( !fp )
      {
        fprintf(stderr, "Could not open pipe for screenshot.\n");
        return;
      }
    const int full_height = height + status_height;
    fprintf(fp,"P6\n%d %d 255\n",width,full_height);
    glReadBuffer(GL_FRONT_LEFT);
    const int size = width * full_height;
    char* const pbuffer = (char*) malloc(size * 3);
    glReadPixels(0,0,width,full_height,GL_RGB,GL_UNSIGNED_BYTE,pbuffer);
    for ( int y=full_height-1; y>=0; y-- )
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
  static const int status_height = 26;
  std::string exe_file_name;
  double render_start;
  int width;
  int height;  // Height of simulated frame buffer, not displayed window.
  int glut_window_id;
  void (*user_display_func)(pFrame_Buffer& frame_buffer);
  std::deque<char*> print_list;
};

#endif
