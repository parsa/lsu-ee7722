// -*- c++ -*-

#ifndef MISC_H
#define MISC_H

#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <malloc.h>
#include <stdarg.h>
#include <stdio.h>
#include <time.h>
#include <algorithm>

#include "pstring.h"

using namespace std;

inline double
time_wall_fp()
{
  struct timespec now;
  clock_gettime(CLOCK_REALTIME,&now);
  return now.tv_sec + ((double)now.tv_nsec) * 1e-9;
}

inline double
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
pError_Msg_NP(const char *fmt, ...) __attribute__ ((format(printf,1,2)));

inline void
pError_Msg_NP(const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  pError_Exit();
}

inline void
pError_Msg(const char *fmt, ...) __attribute__ ((format(printf,1,2)));

inline void
pError_Msg(const char *fmt, ...)
{
  va_list ap;
  va_start(ap, fmt);
  fprintf(stderr,"User Error: ");
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  pError_Exit();
}

template<typename T> T set_max(T& a, T b){ if ( b > a ) a = b;  return a; }
template<typename T> T set_min(T& a, T b){ if ( b < a ) a = b;  return a; }


#define ASSERTS(expr) { if ( !(expr) ) abort();}
#define GCC_GE(maj,min) __GNUC__ \
  && ( __GNUC__ > (maj) || __GNUC__ == (maj) && __GNUC_MINOR__ >= (min) )

inline int w_popcount(unsigned int i)
{
# if GCC_GE(3,4)
  return __builtin_popcount(i);
# else
  int p = 0;
  while( i ) { p += i & 1; i >>= 1; }
  return p;
# endif
}

inline int w_clz(int i)
{
# if GCC_GE(3,4)
  return __builtin_clz(i);
# else
  if( i < 0 ) return 0;
  int lz = 31;
  while( i >>= 1 ) lz--;
  return lz;
# endif
}

inline int
lg(int i) // Doesn't work for 0.
{
  return 31-w_clz(i);
}


template <typename Data> class PStackIterator;
template <typename Data> class PStackIteratori;

template <typename Data> class PStack {
public:
  PStack(Data first) {init(); push(first);}
  PStack(PStack<Data>& s) { cpy(s); }
  PStack() {init();}
  void operator = (PStack<Data>& s) { cpy(s); }
  void reset() {
    if ( taken ) { storage = NULL;  size = 0;  taken = false; }
    else         { destruct_all(); }
    first_free = 0;  iterator = 0;
  };
  ~PStack(){ if ( storage && !taken ) { destruct_all(); free(storage); } }

  // Return true if the stack is not empty.
  operator bool () const { return first_free; }

  // Return number of items in the stack.
  int occ() const { return first_free; }

  Data* get_storage() { return storage; }
  Data* take_storage() { taken = true;  return storage; }

  Data* iterate()
  {
    if( iterator == first_free ) { iterator = 0; return NULL; }
    return &storage[iterator++];
  }

  bool iterate(Data &d)
  {
    if( iterator == first_free ) { iterator = 0; return false; }
    d = storage[iterator++];
    return true;
  }

  int iterate_get_idx() const { return iterator - 1; }

  Data iterate_reset()
  {
    static Data d;
    iterator = 0;
    return d;
  }

  void iterate_yank()
  {
    ASSERTS( iterator );
    const int idx = iterate_get_idx();
    storage[idx].~Data();
    first_free--;
    iterator = idx;
    if ( idx == first_free ) return;
    storage[idx] = storage[first_free];
  }

  // Pop the stack and return the popped item.
  operator Data () { return pop(); }

  // Push I onto the stack.
  Data operator += (Data i){push(i); return i;}

  // Push I onto the stack.
  Data push(Data i)
  {
    if( first_free == size ) alloc();
    new (&storage[first_free++]) Data(i);
    return i;
  }

  // Allocate an element, push it, and return a pointer.
  Data* pushi()
  {
    if( first_free == size ) alloc();
    Data* const rv = &storage[first_free++];
    new (rv) Data;
    return rv;
  }


  // Return top of stack but don't pop.
  Data& peek(){ return storage[first_free-1]; } // UNTESTED.
  Data peek_down(int distance){ return storage[first_free-distance-1]; }
  bool peek(Data &i) // UNTESTED
  {
    if( !first_free ) return false;
    i = peek();
    return true;
  }
  Data& operator [] (int idx) { return storage[idx]; }

  // Pop the stack and return popped item.
  Data pop()
  {
    Data rv = storage[--first_free];
    storage[first_free].~Data();
    return rv;
  }

  // Return true if stack non-empty just before call.  If non-empty,
  // pop the stack, assign popped item to I and return true.
  bool pop(Data &i)
  {
    if( !first_free ) return false;
    i = pop();
    return true;
  }

  void cpy(PStack<Data> &s)
  {
    init();
    alloc(s.occ());
    first_free = s.occ();
    const int cpy_amt = min(s.occ(),size);
    memcpy(storage,s.get_storage(),cpy_amt*sizeof(Data));
  }

private:
  void init() {
    first_free = 0;  size = 0;  storage = NULL;
    iterator = 0;  taken = false;
  }
  void alloc(int new_size = 0)
  {
    if( size )
      {
        size = new_size ? max(new_size,size) : size << 1;
        storage = (Data*) realloc(storage, size * sizeof(storage[0]));
      }
    else
      {
        size = new_size ? new_size : 32;
        storage = (Data*) malloc(size * sizeof(storage[0]));
      }
  }

  void destruct_all()
  {
    // Keep it simple, so compiler optimizes out entire loop if no destructor.
    for ( int i=0; i<first_free; i++ ) storage[i].~Data();
    first_free = 0;
  }

  Data *storage;
  bool taken;
  int first_free;
  int size;
  int iterator;
  friend class PStackIterator<Data>;
  friend class PStackIteratori<Data>;
};

template <typename Data>
class PStackIterator {
public:
  PStackIterator(PStack<Data>& pstack):pstack(pstack),index(0){}
  PStackIterator(PStackIterator<Data>& j)
    :pstack(j.pstack),index(j.get_idx()){}
  operator bool () { return index < pstack.first_free; }
  operator Data () { return pstack.storage[index]; }
  Data operator ++ () { fwd(); return pstack.storage[index]; }
  Data operator ++ (int) { fwd(); return pstack.storage[index-1]; }
  bool operator == (PStackIterator j){ return get_idx() == j.get_idx(); }
  bool operator != (PStackIterator j){ return get_idx() != j.get_idx(); }
  bool operator > (PStackIterator j){ return get_idx() > j.get_idx(); }
  bool operator >= (PStackIterator j){ return get_idx() >= j.get_idx(); }
  bool operator <= (PStackIterator j){ return get_idx() <= j.get_idx(); }
  bool operator < (PStackIterator j){ return get_idx() < j.get_idx(); }
  Data* ptr() { return &pstack.storage[index]; }
  Data operator -> () { return pstack.storage[index]; }
  int get_idx() const { return index; }
private:
  PStack<Data>& pstack;
  int index;
  void fwd()
  {
    if( pstack.first_free == index ) return;
    index++;
  }
};

template <typename Data> class PStackIteratori:
  public PStackIterator<Data>
{
public:
  PStackIteratori(PStack<Data>& pstack):PStackIterator<Data>(pstack){};
  Data* operator -> () { return PStackIterator<Data>::ptr(); }
};

template <typename Data> class PQueue {
public:
  PQueue(Data first) {init(); enqueue(first);}
  PQueue() {init();}
  ~PQueue(){ if(storage) free(storage); }

  void operator += (Data i){enqueue(i);}

  operator bool (){ return occupancy; }
  operator Data (){ return dequeue(); }
  operator Data* (){ return dequeuei(); }
  int occ() const { return occupancy; }

  Data head() {return storage[head_idx];}
  Data head(int pos)
  {
    abort(); // fatal("Not tested.");
    int idx = head_idx + pos;
    if( idx >= size ) idx -= size;
    return storage[idx];
  }
  Data* get_storage() const { return storage; }
  Data* headi() {return occupancy ? &storage[head_idx] : NULL;}
  Data peek_tail(int i)
  {
    int idx = tail_idx - i - 1;
    if( idx < 0 ) idx += size;
    return storage[idx];
  }

  Data* enqueuei()
  {
    if( occupancy == size ) alloc();
    Data* const rv = &storage[tail_idx++];
    new (rv) Data();
    if( tail_idx == size ) tail_idx = 0;
    occupancy++;
    return rv;
  }
  void enqueue(Data i){ Data* const ip = enqueuei(); *ip = i; }

  Data* popi()
  {
    if( !occupancy ) return NULL;
    tail_idx = tail_idx ? tail_idx - 1 : size - 1;
    occupancy--;
    return &storage[tail_idx];
  }
  Data pop()
  {
    Data* const i = popi();
    Data rv = *i;
    i->~Data();
    return rv;
  }

  Data dequeue(){static Data i; dequeue(i); return i;}

  Data* dequeuei()
  {
    if( !occupancy ) return NULL;
    Data* const i = &storage[head_idx++];
    if( head_idx == size ) head_idx = 0;
    occupancy--;
    return i;
  }

  bool dequeue(Data &i){
    Data* const ip = dequeuei();
    if( !ip ) return false;
    i = *ip;
    ip->~Data();
    return true;
  }

  Data* enqueue_at_headi()
  {
    if ( occupancy == size ) alloc();
    if ( !head_idx ) head_idx = size;
    Data* const rv = &storage[--head_idx];
    new (rv) Data();
    occupancy++;
    return rv;
  }

  void enqueue_at_head(Data i){ *enqueue_at_headi() = i; }

  bool iterate(Data &d)
  {
    if( iterator < 0 ) iterator = head_idx;
    if( iterator == tail_idx ) { iterator = -1;  return false; }
    d = storage[iterator];
    iterator++;
    if( iterator == size ) iterator = 0;
    return true;
  }

  void reset()
  {
    /*  if( !is_pod<Data>::value ) while( occ() ) pop();  */
    while( occ() ) pop();
    head_idx = 0;  tail_idx = 0;  occupancy = 0;  iterator = -1;
  }
  void operator = (Data i){reset();enqueue(i);}

private:

  void init()
  {
    occupancy = size = 0;  iterator = -1;
    head_idx = tail_idx = 0; // Pacify compiler.
    storage = NULL;
  }

  void alloc()
  {
    if( size )
      {
        ASSERTS( occupancy );
        const int new_size = size << 1;
        Data* const new_storage = (Data*) malloc(new_size * sizeof(storage[0]));
        Data* sto_ptr = new_storage;
        const bool wrap = tail_idx <= head_idx;
        const int stop = wrap ? size : tail_idx;
        for(int i = head_idx; i < stop; i++) *sto_ptr++ = storage[i];
        if( wrap ) for(int i = 0; i < tail_idx; i++) *sto_ptr++ = storage[i];
        free(storage);
        storage = new_storage;
        size = new_size;
        head_idx = 0;
        tail_idx = occupancy;
      }
    else
      {
        size = 16;
        storage = (Data*) malloc(size * sizeof(storage[0]));
        head_idx = 0;  tail_idx = 0;
      }
  }

  Data *storage;
  int occupancy; // Number of items in queue.
  int head_idx;  // If non-empty, points to head entry.
  int tail_idx;  // Points to next entry to be written.
  int iterator;
  int size;      // Size of storage.
};

class PSplit {
public:
  PSplit(const char *string, char delimiterp,
         int piece_limit = 0, int options = 0):
    queue(),free_at_destruct(!(options & DontFree)), delimiter(delimiterp)
  {
    const char *start = string;
    if( start )
      while( *start )
        {
          const char *ptr = start;
          while( *ptr && *ptr != delimiter ) ptr++;
          if( start != ptr )
            {
              if( --piece_limit == 0 ) { queue += strdup(start); break; }
              pString piece;
              piece.assign_substring(start,ptr);
              queue += piece.remove();
            }
          if( !*ptr ) break;
          start = ++ptr;
        }
    storage = queue.get_storage();
    storage_occ = queue.occ();
  }
  ~PSplit()
  {
    if( !free_at_destruct ) return;
    for(int i=0; i<storage_occ; i++)free(storage[i]);
  }
  //  static const int NoCompress = 1;  // Implement when needed.
  static const int DontFree = 2;
  int occ() const { return queue.occ(); }
  char* operator [] (int idx) const { return storage[idx]; }
  operator int () const { return queue.occ(); }
  bool operator ! () const { return !queue.occ(); }
  char* pop()
  {
    return queue.occ() ? queue.pop() : NULL;
  }
  operator bool () { return queue.occ(); }
  operator int () { return queue.occ(); }

  char* dequeue()
  {
    char* rv;
    if( queue.dequeue(rv) ) return rv;
    return NULL;
  }

  operator char* () { return dequeue(); }

  char* joined_copy()
  {
    if( !occ() ) return NULL;
    pString joined;
    for( char *piece = NULL; queue.iterate(piece); )
      {
        if( joined ) joined += delimiter;
        joined += piece;
      }
    return joined.remove();
  }

private:
  PQueue<char*> queue;
  const bool free_at_destruct;
  const char delimiter;
  char** storage;
  int storage_occ;
};


template <typename K, typename D> class PSList_Elt_Generic
{
public:
  K key;
  D data;
};

template <typename Data, typename Key = int> class PSList
{
  typedef PSList_Elt_Generic<Key,Data> Elt;
public:
  PSList(Data null_data):null_data(null_data),stack()
  {
    sorted = false;
    free_data = false;
  }
  PSList():stack()
  {
    sorted = false;
    free_data = false;
    memset(&null_data,0,sizeof(null_data));
  }

  Data* inserti(Key key)
  {
    Elt* const elt = stack.pushi();
    elt->key = key;
    sorted = false;
    return &elt->data;
  }

  void insert(Key key, Data data)
  {
    Data* const dataptr = inserti(key);
    *dataptr = data;
    sorted = false;
  }

  void operator += (PSList &l2)
  {
    for( Elt elt; l2.iterate(elt); ) stack += elt;
    sorted = false;
  }

  Data operator [] (int idx) {return stack.get_storage()[idx].data;}
  Key get_key(int idx) {return stack.get_storage()[idx].key; }

  int key_order(int k1, int k2){ return k1-k2; }
  int key_order(uint k1, uint k2)
  { return k1 > k2 ? 1 : k1 == k2 ? 0 : -1; }
  int key_order(const char *k1, const char *k2){ return strcmp(k1,k2); }
  int key_order(float k1, float k2){ return k1>k2 ? 1 : k1==k2 ? 0 : -1;}
  int key_order(double k1, double k2){ return k1>k2 ? 1 : k1==k2 ? 0 : -1;}

  Data get_eq(Key k)
  {
    const int idx = find_eq(k);
    return idx < 0 ? null_data : stack.get_storage()[idx].data;
  }

  Data get_ge(Key k)  // Smallest element >= k.
  {
    const int idx = find_ge(k);
    if ( idx >= 0 )
      {
        Elt* const storage = stack.get_storage();
        ASSERTS( key_order(storage[idx].key,k) >= 0 );
        ASSERTS( idx == 0 || key_order(storage[idx-1].key,k) <= 0 );
      }

    return idx < 0 ? null_data : stack.get_storage()[idx].data;
  }

  Data get_le(Key k)  // Largest element <= k.
  {
    const int idx = find_le(k);
    if ( idx >= 0 )
      {
        Elt* const storage = stack.get_storage();
        const int occ = stack.occ();
        ASSERTS( key_order(storage[idx].key,k) <= 0 );
        ASSERTS( idx + 1 == occ || key_order(storage[idx+1].key,k) >= 0 );
      }

    return idx < 0 ? null_data : stack.get_storage()[idx].data;
  }

  int find_eq(Key k)
  {
    int order;
    const int idx = find(k,order);
    return order || idx < 0 ? -1 : idx;
  }
  int find_le(Key k) // Largest element <= k.
  {
    int order;
    const int idx = find(k,order);
    if ( idx < 0 ) return -1;
    if ( order <= 0 ) return idx;
    return idx - 1;
  }
  int find_ge(Key k) // Smallest element >= k.
  {
    int order;
    int idx = find(k,order);
    if ( idx < 0 ) return -1;
    if ( order >= 0 ) return idx;
    idx++;
    return idx == stack.occ() ? -1 : idx;
  }

  // Deprecated
  int find(Key k)
  {
    const int idx = find_ge(k);
    return idx < 0 ? stack.occ() : idx;
  }

private:
  int find(Key k, bool exact)
  {
    int order;
    const int idx = find(k,order);
    return order ? -1 : idx;
  }
  int find(Key k, int &order)
  {
    sort();
    Elt* const storage = stack.get_storage();
    const int occ = stack.occ();
    if ( occ == 0 ) return -1;

    int index = 0;
    int delta = 1 << lg(occ);

    while ( true )
      {
        index += delta;
        if ( index >= occ )
          {
            order = key_order(storage[occ-1].key,k);
            if ( order <= 0 ) return occ - 1;
          }
        else
          {
            order = key_order(storage[index].key,k);
            if ( order == 0 ) return index;
          }

        if ( !delta ) return index;
        if ( order > 0 ) index ^= delta;

        delta >>= 1;
      }
  }


public:
  int occ() const { return stack.occ(); }

  static int comp_num(const void *a, const void *b)
  {return ((Elt*)a)->key == ((Elt*)b)->key ? 0 :
      ((Elt*)a)->key > ((Elt*)b)->key ? 1 : -1; }
  static int comp_str(const void *a, const void *b)
  {return strcmp(((Elt*)a)->key,((Elt*)b)->key);}

  typedef int (*Comp_Function)(const void*,const void*);
  Comp_Function get_comp(double *dummy){ return comp_num; }
  Comp_Function get_comp(float *dummy){ return comp_num; }
  Comp_Function get_comp(uint *dummy){ return comp_num; }
  Comp_Function get_comp(int32_t *dummy){ return comp_num; }
  Comp_Function get_comp(int64_t *dummy){ return comp_num; }
  Comp_Function get_comp(char** ){ return comp_str; }
  Comp_Function get_comp(const char** ){ return comp_str; }
  void sort()
  {
    if( sorted ) return;
    sorted = true;
    Elt* storage = stack.get_storage();
    Key *dummy = NULL;
    qsort(storage,stack.occ(),sizeof(Elt),get_comp(dummy));
  }

  bool iterate(Elt& elt) { sort(); return stack.iterate(elt);}
  bool iterate(Data &data) { Key dummy; return iterate(dummy,data); }
  bool iterate(Key& key, Data& data)
  {
    sort();
    Elt* const elt = stack.iterate();
    if( !elt ) return false;
    key = elt->key;
    data = elt->data;
    return true;
  }

  Data iterate()
  {
    sort();
    Elt* const elt = stack.iterate();
    return elt ? elt->data : null_data;
  }

  int iterate_get_idx() const { return stack.iterate_get_idx(); }

  Data iterate_reset()
  {
    static Data d;
    stack.iterate_reset();
    return d;
  }

  void reset(bool next_free_data = false)
  {
    if( free_data ) for( Elt elt; stack.pop(elt); ) free((void*)elt.data);
    else stack.reset();
    free_data = next_free_data;
  }

private:
  bool free_data;
  bool sorted;
  PStack<Elt> stack;
  Data null_data;
};

#endif
