// -*- c++ -*-

#ifndef GL_CUDA_UTIL_H
#define GL_CUDA_UTIL_H

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>

#include "util.h"
#include "misc.h"

 /// CUDA API Error-Checking Wrapper
///
#define CE(call)                                                              \
 {                                                                            \
   const cudaError_t rv = call;                                               \
   if ( rv != cudaSuccess )                                                   \
     {                                                                        \
       pStringF msg("CUDA error %d, %s\n",rv,cudaGetErrorString(rv));         \
       pError_Msg(msg.s);                                                     \
     }                                                                        \
 }


 ///
 /// Class for managing CUDA device memory.
 ///

template <typename T>
class pCUDA_Memory {
public:
  pCUDA_Memory()
  {
    data = NULL;  dev_addr[0] = dev_addr[1] = NULL;  current = 0;  bid = 0;
    bo_ptr = NULL;
  }
  ~pCUDA_Memory()
  {
    if ( data ) if ( locked ) {CE(cudaFreeHost(data));} else { free(data); }
    if ( bid )
      {
        CE(cudaGLUnmapBufferObject(bid));
        CE(cudaGLUnregisterBufferObject(bid));
        glDeleteBuffers(1,&bid);
      }
  }

  T* alloc_locked_maybe(int elements_p, bool locked_p)
  {
    if ( data ) pError_Msg("Double allocation of pCUDA_Memory.");
    elements = elements_p;
    locked = locked_p;
    chars = elements * sizeof(T);
    if ( locked )
      { CE(cudaMallocHost((void**)&data,chars)); }
    else
      { data = (T*) malloc(chars); }
    new (data) T[elements];
    return data;
  }

  T* alloc(int nelem) { return alloc_locked_maybe(nelem,false); }
  T* alloc_locked(int nelem) { return alloc_locked_maybe(nelem,true); }

  void take(PStack<T>& stack)
  {
    if ( data ) pError_Msg("Double allocation of pCUDA_Memory.");
    elements = stack.occ();
    chars = elements * sizeof(T);
    data = stack.take_storage();
  }

  T& operator [] (int idx) const { return data[idx]; }

private:
  void alloc_maybe() { alloc_maybe(current); }
  void alloc_maybe(int side)
  {
    if ( !dev_addr[side] ) alloc_gpu_buffer(side);
  }

  void alloc_gpu_buffer(){ alloc_gpu_buffer(current); }
  void alloc_gpu_buffer(int side)
  {
    ASSERTS( !dev_addr[side] );
    CE(cudaMalloc(&dev_addr[side],chars));
  }

  void alloc_gl_buffer()
  {
    if ( bid ) return;
    glGenBuffers(1,&bid);
    glBindBuffer(GL_ARRAY_BUFFER,bid);
    glBufferData(GL_ARRAY_BUFFER,chars,NULL,GL_DYNAMIC_DRAW);
    glBindBuffer(GL_ARRAY_BUFFER,0);
    CE(cudaGLRegisterBufferObject(bid));
  }

public:
  T* get_dev_addr() { return get_dev_addr(current); }
  T* get_dev_addr(int side)
  { alloc_maybe(side); return (T*)dev_addr[side]; }
  T* get_dev_addr_read() { return get_dev_addr(current); }
  T* get_dev_addr_write() { return get_dev_addr(1-current); }

  void to_cuda()
  {
    if ( !dev_addr[current] ) alloc_gpu_buffer();
    CE(cudaMemcpy(dev_addr[current], data, chars, cudaMemcpyHostToDevice));
  }

  void from_cuda()
  {
    CE(cudaMemcpy(data, dev_addr[current], chars, cudaMemcpyDeviceToHost));
  }

  void cuda_to_gl()
  {
    alloc_gl_buffer();
    // Due to a bug in CUDA 2.1 this is slower than copying through host.
    CE(cudaGLMapBufferObject(&bo_ptr,bid));
    CE(cudaMemcpy(bo_ptr, dev_addr[current], chars, cudaMemcpyDeviceToDevice));
    CE(cudaGLUnmapBufferObject(bid));
  }

  void swap() { current = 1 - current; }
  void set_primary() { current = 0; }

  // Stuff below should be private to avoid abuse.
  void *dev_addr[2], *bo_ptr;
  GLuint bid;
  int current;
  T *data;
  bool locked;
  int elements, chars;
};


struct pCM_Struc_Info
{
  int elt_size;
  int offset_aos;
  int soa_elt_idx;
  size_t soa_cpu_base;
};

template<typename Taos, typename Tsoa>
class pCUDA_Memory_X : public pCUDA_Memory<Taos>
{
public:
  typedef pCUDA_Memory<Taos> pCM;
  pCUDA_Memory_X()
    : pCM(),alloc_unit_lg(8),alloc_unit_mask((1<<alloc_unit_lg)-1)
  {
    use_aos = false; data_aos_stale = false; soa_allocated = false;
  }
  void setup(uint elt_size, int offset_aos, void **soa_elt_ptr)
  {
    pCM_Struc_Info* const si = struc_info.pushi();
    si->elt_size = elt_size;
    si->offset_aos = offset_aos;
    si->soa_cpu_base = -1;
    si->soa_elt_idx = ((void**)soa_elt_ptr) - ((void**)&sample_soa);
  }
  void alloc(size_t nelements){ pCM::alloc(nelements); }
  void alloc_soa()
  {
    if ( soa_allocated ) return;
    soa_allocated = true;
    size_t soa_cpu_base_next = 0;
    while ( pCM_Struc_Info* const si = struc_info.iterate() )
      {
        si->soa_cpu_base = soa_cpu_base_next;
        const size_t size = pCM::elements * si->elt_size;
        const bool extra = size & alloc_unit_mask;
        const size_t size_round =
          ( size >> alloc_unit_lg ) + extra << alloc_unit_lg;
        soa_cpu_base_next += size_round;
      }
    cuda_mem_all.alloc(soa_cpu_base_next);
    void** soa_ptr = (void**)&soa;
    char* const cpu_base = (char*) &cuda_mem_all.data[0];
    while ( pCM_Struc_Info* const si = struc_info.iterate() )
      soa_ptr[si->soa_elt_idx] = cpu_base + si->soa_cpu_base;
  }

  Taos& operator [] (int idx)
  {
    if ( data_aos_stale ) soa_to_aos();
    return pCM::data[idx];
  }

  void aos_to_soa()
  {
    alloc_soa();
    while ( pCM_Struc_Info* const si = struc_info.iterate() )
      {
        char* const soa_cpu_base = &cuda_mem_all[si->soa_cpu_base];
        Taos* const aos_cpu_base =
          (Taos*)(((char*)&pCM::data[0])+si->offset_aos);
        for ( int i=0; i<pCM::elements; i++ )
          memcpy( soa_cpu_base + i*si->elt_size,
                  aos_cpu_base + i,  si->elt_size);
      }
  }
  void soa_to_aos()
  {
    while ( pCM_Struc_Info* const si = struc_info.iterate() )
      {
        char* const soa_cpu_base = &cuda_mem_all[si->soa_cpu_base];
        Taos* const aos_cpu_base =
          (Taos*)(((char*)&pCM::data[0])+si->offset_aos);
        for ( int i=0; i<pCM::elements; i++ )
          memcpy( aos_cpu_base + i,
                  soa_cpu_base + i*si->elt_size, si->elt_size);
      }
    data_aos_stale = false;
  }

  void to_cuda()
  {
    if ( use_aos ) { pCM::to_cuda();  return; }
    aos_to_soa();
    cuda_mem_all.to_cuda();
  }
  void from_cuda()
  {
    if ( use_aos ) { pCM::from_cuda();  return; }
    cuda_mem_all.from_cuda();
    data_aos_stale = true;
  }

  void swap()
  {
    pCM::swap();
    cuda_mem_all.swap();
  }

  void ptrs_to_cuda_soa_side(const char *dev_name, int side)
  {
    alloc_soa();
    void** soa = (void**)&shadow_soa[side];
    char* const dev_base = (char*) cuda_mem_all.get_dev_addr(side);
    while ( pCM_Struc_Info* const si = struc_info.iterate() )
      soa[si->soa_elt_idx] = dev_base + si->soa_cpu_base;
    CE(cudaMemcpyToSymbol
       (dev_name, soa, sizeof(Tsoa), 0, cudaMemcpyHostToDevice));
  }
  void ptrs_to_cuda(char *dev_name_0, char *dev_name_1 = NULL)
  {
    ptrs_to_cuda_soa(dev_name_0,dev_name_1);
  }
  void ptrs_to_cuda_soa(char *dev_name_0, char *dev_name_1 = NULL)
  {
    ptrs_to_cuda_soa_side(dev_name_0,0);
    if ( !dev_name_1 ) return;
    ptrs_to_cuda_soa_side(dev_name_1,1);
  }

  void ptrs_to_cuda_aos_side(const char *dev_name, int side)
  {
    void* const dev_addr = pCM::get_dev_addr(side);
    CE(cudaMemcpyToSymbol
       (dev_name, &dev_addr, sizeof(dev_addr), 0, cudaMemcpyHostToDevice));
  }
  void ptrs_to_cuda_aos(char *dev_name_0, char *dev_name_1 = NULL)
  {
    ptrs_to_cuda_aos_side(dev_name_0,0);
    if ( !dev_name_1 ) return;
    ptrs_to_cuda_aos_side(dev_name_1,1);
  }

  const int alloc_unit_lg, alloc_unit_mask;
  PStack<pCM_Struc_Info> struc_info;
  pCUDA_Memory<char> cuda_mem_all;
  bool use_aos;
  bool data_aos_stale;
  bool soa_allocated;

  Tsoa shadow_soa[2];
  Tsoa soa;

  Tsoa sample_soa;
  Taos sample_aos;
};

#endif
