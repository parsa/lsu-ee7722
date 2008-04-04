// -*- c++ -*-


#ifndef GL_FUNC_PTR_H_stage_1
#define GL_FUNC_PTR_H_stage_1
#define GL_FUNC_PTR_H_stage_1_do 1
#define PTR_DEF(type,name) type ptr##name;
#else
#ifndef GL_FUNC_PTR_H_stage_2
#define GL_FUNC_PTR_H_stage_2
#define GL_FUNC_PTR_H_stage_2_do 1
#define PTR_DEF(type,name) ptr##name = (type) glutGetProcAddress(#name);
#endif
#endif

#if GL_FUNC_PTR_H_stage_1_do
typedef int (*lfunc_i_U)(unsigned int*);
typedef int (*lfunc_i_iiU)(int, int, unsigned int*);
typedef int (*lfunc_i_uC)(unsigned int, const char*);
typedef void (*lfunc_v_uusSSEC)(uint,uint,sizei,sizei*,sizei*,enum*,char*);
#endif

#if GL_FUNC_PTR_H_stage_2_do
inline void
pgl_gl_ptr_init()
{
#endif

#if GL_FUNC_PTR_H_stage_1_do || GL_FUNC_PTR_H_stage_2_do

PTR_DEF( lfunc_i_iiU, glXWaitVideoSyncSGI );
PTR_DEF( lfunc_i_uC, glGetVaryingLocationNV );
PTR_DEF( lfunc_v_uusSSEC, glGetActiveVaryingNV );
PTR_DEF( lfunc_u_u, ptr_glCreateShader);

#endif

#if GL_FUNC_PTR_H_stage_2_do
#undef GL_FUNC_PTR_H_stage_2_do
}
#endif

#undef PTR_DEF

#undef GL_FUNC_PTR_H_stage_1_do

