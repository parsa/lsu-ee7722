// -*- c++ -*-

#ifndef GL_BUFFER_H
#define GL_BUFFER_H

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>

#include "util.h"
#include "misc.h"

 ///
 /// Class for managing an OpenGL ARRAY_BUFFER
 ///

template <typename T>
class pBuffer_Object {
public:
  pBuffer_Object(){ data = NULL; init(); }
  ~pBuffer_Object()
  {
    if ( data ) free(data);
    glDeleteBuffers(created,bids);
  }

private:
  void init()
  {
    btarget = GL_ARRAY_BUFFER;
    glGenBuffers(2, bids);
    current = 0;
    bid = bids[current];
    created = 0;
    pError_Check();
    usage_hint = GL_DYNAMIC_COPY;
  }

public:
  T* alloc(int elements_p, GLenum hint = GL_DYNAMIC_COPY)
  {
    usage_hint = hint;
    if ( data ) pError_Msg("Double allocation of pBuffer_Object.");
    elements = elements_p;
    chars = elements * sizeof(T);
    data = new T[elements];
    created = 1;
    alloc_gpu_buffer();
    glBindBuffer(btarget,0);
    return data;
  }

  void re_take(vector<T>& stack, GLenum hint = GL_DYNAMIC_COPY,
            GLenum default_target = GL_ARRAY_BUFFER)
  {
    const int elements_taking = stack.size();
    const size_t sz_char = sizeof(T) * elements_taking;
    T* const cpy = new T[elements_taking];
    memcpy(cpy,stack.data(),sz_char);
    re_take(cpy,elements_taking,hint,default_target);
  }

  void re_take(PStack<T>& stack, GLenum hint = GL_DYNAMIC_COPY,
            GLenum default_target = GL_ARRAY_BUFFER)
  {
    const int elements_taking = stack.occ();
    re_take(stack.take_storage(),elements_taking,hint,default_target);
  }

  void re_take(T* stack, int elements_taking, GLenum hint = GL_DYNAMIC_COPY,
            GLenum default_target = GL_ARRAY_BUFFER)
  {
    const bool first_alloc = !created;
    usage_hint = hint;
    btarget = default_target;
    if ( !first_alloc && elements_taking != elements )
      pError_Msg("Second filling of pBuffer_Object with different # elem.");
    if ( !first_alloc ) free(data);
    data = stack;
    if ( !first_alloc ) return;
    elements = elements_taking;
    chars = elements * sizeof(T);
    alloc_gpu_buffer();
    glBindBuffer(btarget,0);
  }

  void take(PStack<T>& stack, GLenum hint = GL_DYNAMIC_COPY,
            GLenum default_target = GL_ARRAY_BUFFER)
  {
    if ( data ) pError_Msg("Double allocation of pBuffer_Object.");
    re_take(stack,hint,default_target);
  }

  void prepare_two_buffers()
  {
    ASSERTS( created == 1 );
    created = 2; bid_swap(); alloc_gpu_buffer(); bid_swap();
  }

private:
  void alloc_gpu_buffer()
  {
    bind();
    glBufferData(btarget,chars,NULL,usage_hint);
    pError_Check();
  }

public:
  void to_gpu()
  {
    bind();
    glBufferData(btarget, chars, data, usage_hint);
    pError_Check();
  }

  void from_gpu()
  {
    bind();
    T* const from_data = (T*)glMapBuffer(GL_ARRAY_BUFFER,GL_READ_ONLY);
    pError_Check();
    memcpy(data,from_data,chars);
    glUnmapBuffer(btarget);
    glBindBuffer(btarget,0);
  }

  void bind(GLenum target){ glBindBuffer(target,bid); }
  void bind(){ glBindBuffer(btarget,bid); }

  GLuint bid_read() const { return bids[current]; }
  GLuint bid_write()
  {
    bid_swap(); alloc_gpu_buffer(); bid_swap();
    return bids[1-current];
  }
  GLuint bid_fresh()
  {
    alloc_gpu_buffer();
    return bid;
  }

  void bid_swap()
  {
    current = 1 - current;
    bid = bids[current];
  }

  T& operator [] (int idx) { return data[idx]; }

  GLuint bids[2];
  GLuint bid;
  GLenum usage_hint;
  GLenum btarget;
  int created, current;
  T *data;
  int elements, chars;
};

#endif
