// -*- c++ -*-

#ifndef UTIL_CONTAINERS_H
#define UTIL_CONTAINERS_H

#include <vector>
#include <assert.h>

using namespace std;

template <typename T>
class pVectorI : public vector<T*> {
public:
  pVectorI():vector<T*>(){}
  pVectorI(T* nd):vector<T*>(){ vector<T*>::push_back(nd); }
  void erase() { while ( T* nd = pop() ) delete nd; }

  void operator = (T* nd) { vector<T*>::clear(); vector<T*>::push_back(nd); }
  T* operator += (T* nd) { vector<T*>::push_back(nd); return nd; }
  void operator += (pVectorI<T> v) {
    for ( unsigned int i=0; i<v.size(); i++ ) vector<T*>::push_back(v[i]);
    }
  pVectorI<T> operator + (pVectorI<T> v) {
    pVectorI<T> r = *this; r += v;
    return r;
    }
  operator int () { return vector<T*>::size(); }
  operator bool () { return !vector<T*>::empty(); }
  T* pop()
  {
    if ( vector<T*>::empty() ) return NULL;
    T* const rv = vector<T*>::back();
    vector<T*>::pop_back();
    return rv;
  }
  bool member(T* nd)
  {
    for ( int i=0; i<vector<T*>::size(); i++ )
      if ( vector<T*>::at(i) == nd ) return true;
    return false;
  }
};

template <typename T>
class pVector : public vector<T> {
public:
  pVector():vector<T>(){};
  pVector(size_t sz):vector<T>(sz){};
  void operator += (T nd) { vector<T>::push_back(nd); }
  void operator += (vector<T> v)
    {
      for ( int i=0; i<v.size(); i++ ) vector<T>::push_back(v[i]);
    }
  bool pop(T& val)
  {
    if ( vector<T>::empty() ) return false;
    val = vector<T>::back();
    vector<T>::pop_back();
    return true;
  }
  T pop()
  {
    if ( vector<T>::empty() ) return T(0);
    T val = vector<T>::back();
    vector<T>::pop_back();
    return val;
  }
};

template <typename T>
class pVectorI_Iter {
public:
  // Make sure this is some kind of error.
  pVectorI_Iter(const pVectorI_Iter<T>& iter);

  pVectorI_Iter(vector<T*>& nodesp):nodes(nodesp),size(nodes.size()),idx(-1){}
  operator bool () { 
    const bool rv = ++idx < size;
    if ( !rv ) assert( size <= int(nodes.size()) );
    c = rv ? nodes[idx] : NULL;
    return rv;
  }
  operator T* ()  { return c; }
  operator int () { return idx; }
  operator long int () { return idx; }
  operator size_t () { return idx; }
  T* curr() { return c; }
  T* operator -> () { return c; }
private:
  vector<T*>& nodes;
  T *c;
  const int size;
  int idx;
};

template <typename T>
class pVector_Iter {
public:
  // Make sure this is some kind of error.
  pVector_Iter(const pVector_Iter<T>& iter);

  pVector_Iter(vector<T>& nodesp):nodes(nodesp),size(nodes.size()),idx(-1){}
  operator bool () {
    const bool rv = ++idx < size;
    c = rv ? nodes[idx] : NULL;
    return rv;
  }
  operator T ()  { return c; }
  T curr() { return c; }
private:
  vector<T>& nodes;
  T c;
  const int size;
  int idx;
};

template <typename T>
class pMap_Str_Obj_Iter {
  typedef map<string,T> pMap_SOI_Elt;
public:
  pMap_Str_Obj_Iter(pMap_SOI_Elt& gfm):gfmi(gfm.begin()),gfmend(gfm.end()){}
  operator bool ()
  {
    if ( gfmi == gfmend ) return false;
    current = &gfmi->second;
    gfmi++;
    return true;
  }
  operator T* () { return current; }
  T* operator -> () { return current; }
private:
  typename pMap_SOI_Elt::iterator gfmi, gfmend;
  T *current;
};

#endif
