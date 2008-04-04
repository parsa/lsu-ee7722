// -*- c++ -*-
#ifndef GLEXTFUNCS_H
#define GLEXTFUNCS_H

// Types (Uppercase for pointers)
// i, int; u, unsigned int; v, void; s, sizei; e, enum.
// C, char*; K, const char*

typedef int (*lfunc_u_e)(GLenum);
typedef int (*lfunc_i_U)(unsigned int*);
typedef int (*lfunc_i_iiU)(int, int, unsigned int*);
typedef int (*lfunc_i_uK)(unsigned int, const char*);
typedef void (*lfunc_v_uusSSEC)(uint,uint,
                                GLsizei,GLsizei*,GLsizei*,GLenum*,char*);

#define PTR_INIT(t,name) t ptr_##name;
#include "glextfuncs.h"
#undef PTR_INIT
#define PTR_INIT(t,name) ptr_##name = (t) glutGetProcAddress(#name);

inline void
lglext_ptr_init()
{
# include "glextfuncs.h"  
}

#undef PTR_INIT

#else

#ifdef PTR_INIT

PTR_INIT(lfunc_u_e,glCreateShader);

PTR_INIT(lfunc_i_iiU,glXWaitVideoSyncSGI);
PTR_INIT(lfunc_i_U,glXGetVideoSyncSGI);

PTR_INIT(lfunc_v_uusSSEC,glGetActiveVaryingNV);
PTR_INIT(lfunc_i_uK,glGetVaryingLocationNV);

#endif

#endif
