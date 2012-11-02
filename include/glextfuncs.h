// -*- c++ -*-
#ifndef GLEXTFUNCS_H
#define GLEXTFUNCS_H

// Types (Uppercase for pointers)
// i, int; u, unsigned int; v, void; s, sizei; e, enum.
// C, char*; K, const char*

typedef GLuint (*lfunc_u_uU)(GLuint,GLuint*);
typedef void (*lfunc_v_u)(GLuint);
typedef void (*lfunc_v_iff)(GLint,float,float);
typedef void (*lfunc_v_ifff)(GLint,float,float,float);
typedef GLuint (*lfunc_u_e)(GLenum);
typedef GLint (*lfunc_i_U)(unsigned int*);
typedef int (*lfunc_i_iiU)(int, int, unsigned int*);
typedef int (*lfunc_i_uK)(unsigned int, const char*);
typedef void (*lfunc_v_uusSSEC)(uint,uint,
                                GLsizei,GLsizei*,GLsizei*,GLenum*,char*);

#ifdef GP_UTIL_DECLARE_ONLY
#define PTR_INIT(t,name) extern t ptr_##name;
#else
#define PTR_INIT(t,name) t ptr_##name;
#endif
#include "glextfuncs.h"
#undef PTR_INIT
#define PTR_INIT(t,name) ptr_##name = (t) glutGetProcAddress(#name);

#ifdef GP_UTIL_DECLARE_ONLY
void lglext_ptr_init();
#else
void
lglext_ptr_init()
{
# include "glextfuncs.h"  
}
#endif

#undef PTR_INIT

#else

#ifdef PTR_INIT

PTR_INIT(lfunc_u_e,glCreateShader);

PTR_INIT(lfunc_v_u,glUseProgram);
PTR_INIT(lfunc_i_uK,glGetUniformLocation);
PTR_INIT(lfunc_v_iff, glUniform2f);
PTR_INIT(lfunc_v_ifff, glUniform3f);

PTR_INIT(lfunc_i_iiU,glXWaitVideoSyncSGI);
PTR_INIT(lfunc_i_U,glXGetVideoSyncSGI);

PTR_INIT(lfunc_v_uusSSEC,glGetActiveVaryingNV);
PTR_INIT(lfunc_i_uK,glGetVaryingLocationNV);

#endif

#endif
