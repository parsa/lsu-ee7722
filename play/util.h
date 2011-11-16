// -*- c++ -*-

#ifndef UTIL_H
#define UTIL_H

#include <time.h>
#include <stdio.h>

#include "glextfuncs.h"

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

#define PRINT_STRING(token) lprint_string(token,#token);

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

class pFrame_Timer {
public:
  pFrame_Timer():inited(false),work_count(NULL),work_description(NULL){}
  void work_unit_set(int *count, char *description)
  {
    work_count = count;
    work_count_last = *work_count;
    work_description = strdup(description);
  }
  void init();
  void frame_rate_group_start();
  void frame_start();
  void frame_end();
  const char* frame_rate_text_get() const { return &buf[0]; }
private:
  bool inited;
  double frame_group_start_time;
  static const int frame_group_size = 60;
  int frame_group_count;
  double tsum, tlast, cpu_tsum, cpu_tlast;
  int tamt;
  int *work_count;
  int work_count_last;
  char *work_description;
  double work_rate;

  double frame_rate;
  double time_render_start;
  uint query_timer_id;
  uint xfcount;  // Frame count provided by glx.
  static const int bufsize = 80;
  char buf[bufsize+1];
};

void
pFrame_Timer::init()
{
  inited = true;
  buf[0] = 0;
  glGenQueries(1,&query_timer_id);
  tsum = 0; tlast = 0;
  cpu_tsum = 0; cpu_tlast = 0;
  tamt = 0;
  frame_group_start_time = time_wall_fp();
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
  cpu_tlast = 1e6 * cpu_tsum * last_frame_count_inv;
  frame_rate = last_frame_count / group_duration;
  if ( work_count )
    {
      work_rate = ( *work_count - work_count_last ) / group_duration;
      work_count_last = *work_count;
    }
  frame_group_count = 0;
  cpu_tsum = tsum = 0;
}

void
pFrame_Timer::frame_start()
{
  if ( !inited ) init();
  pError_Check();
  glBeginQuery(GL_TIME_ELAPSED_EXT,query_timer_id);
  pError_Check();
  time_render_start = time_process_fp();
  if ( frame_group_count++ >= frame_group_size ) frame_rate_group_start();
}

void
pFrame_Timer::frame_end()
{
  const double time_render_elapsed = time_process_fp() - time_render_start;
  glEndQuery(GL_TIME_ELAPSED_EXT);
  int timer_val;
  glGetQueryObjectiv(query_timer_id,GL_QUERY_RESULT,&timer_val);
  tsum += timer_val;
  cpu_tsum += time_render_elapsed;
  const uint xfcount_prev = xfcount;
  if ( ptr_glXGetVideoSyncSGI ) ptr_glXGetVideoSyncSGI(&xfcount);
  if ( work_count )
    snprintf(buf, bufsize,
             "FPS: %.2f XF %2d  GPU %.3f us  CPU %.1f us  %s %.1f /s",
             frame_rate, xfcount-xfcount_prev, tlast,cpu_tlast,
             work_description, work_rate);
  else
    snprintf(buf, bufsize, "FPS: %.2f XF %2d  GPU %.3f us  CPU %.1f us",
             frame_rate, xfcount-xfcount_prev, tlast,cpu_tlast);
}

#endif
