#ifndef PSTRING_H
#define PSTRING_H

#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <malloc.h>
#include <stdarg.h>
#include <stdio.h>
#include <string>

template <typename Data, int size> class Linger_Pool {
public:
  Linger_Pool()
  {
    tail = size - 1;
    memset(storage,0,sizeof(storage[0])*size);
  }
  ~Linger_Pool()
  {
    for(int i=0; i<size; i++) if( storage[i] ) free( storage[i] );
  }
  Data *add(Data *elt)
  {
    if( storage[tail] ) free( storage[tail] );
    storage[tail] = elt;
    tail = tail ? tail - 1 : size - 1;
    return elt;
  }
  inline Data* operator += (Data* elt) { return add(elt); }

private:
  Data* storage[size];
  int tail;
};

typedef Linger_Pool<char,128> Linger_Char;

class pString {
private:
  void cpy(const char *sp)
  {
    if( !sp ) { s = NULL;  occ = size = 0;  return; }
    s = strdup(sp);
    occ = size = strlen(s);
  }
  void init_space(int initial_string_size)
  {
    size = initial_string_size;
    occ = 0;
    if( !size ) { s = NULL;  return; }
    s = (char*)malloc(size+1);
    s[0] = 0;
  }

public:
  // Make STRING the new string value without copying. Free STRING
  // later if necessary.
  void assign_take(char *string)
  {
    if(s) free(s);
    s = string;
    occ = size = s ? strlen(s) : 0;
  }
  void assign_substring(const char *start, const char *stop)
  {
    if(s){ s[0] = 0;  occ = 0; }
    append_substring(start,stop);
  }

  pString(const std::string& s){ cpy(s.c_str()); }
  pString(const char *sp){ cpy(sp); }
  pString(const pString &str){ cpy(str.s); }
  pString(pString&& str){
    s = str.s;
    occ = str.occ;
    size = str.size;
    str.s = NULL;
    str.occ = str.size = 0;
  }

  pString(){ cpy(NULL); }
  pString(int initial_string_size) { init_space(initial_string_size);}
  ~pString(){
    if(s) free(s);
  };
  char *sprintf(const char *fmt,...)
  {
    va_list ap;

    va_start(ap, fmt);
    char* const rv = vsprintf(fmt,ap);
    va_end(ap);
    return rv;
  }
  char *vsprintf(const char *fmt, va_list ap)
  {
    va_list ap2;  va_copy(ap2,ap);
    char maybe[80];
    int buf_limit = sizeof(maybe) - 1;
    int final_size = ::vsnprintf(maybe,buf_limit,fmt,ap);

    if ( final_size < buf_limit ){ operator += (maybe);  return s; }

    char *buffer = new char[final_size+1];
    ::vsprintf(buffer,fmt,ap2);
    va_end(ap2);

    operator += (buffer);
    delete buffer;
    return s;
  }

  char *linger() {return lc->add(remove());}
  char *dup() {return s ? strdup(s) : NULL;}
  char *remove()
  {
    if ( !s ) return NULL;
    char *rv = (char*)realloc(s,occ+1);
    cpy(NULL);
    return rv;
  }
  inline bool operator != (pString &rs2) { return operator != (rs2.s); }
  inline bool operator == (pString &rs2) { return operator == (rs2.s); }
  inline bool operator != (const char *s2){ return ! operator == (s2); }
  inline bool operator == (const char *s2)
  { return !s || !s2 ? !s && !s2 : !strcmp(s,s2); }
  inline bool operator ! (){ return !s; }
  inline void operator = (pString &str)
  {
    if( !s ) { cpy(str.s); return; }
    s[0] = 0;  occ = 0;
    operator += (str.s);
  }
  inline void operator = (const char *c)
  {
    if( !s ) { cpy(c); return; }
    s[0] = 0;  occ = 0;
    operator += (c);
  }
  inline operator char*(){ return s;}
  inline std::string ss(){ return std::string(s); }
  int len(){ return occ; }
  int col()
  {
    int i = occ;
    while( i && s[i-1] != '\n' && s[i-1] != '\r' ) i--;
    return occ - i;
  }
  inline pString operator + (const pString &s2){ return operator +(s2.s); }
  inline friend pString operator + (std::string&& c, const pString& s2)
  { return pString(c) + s2; }
  inline friend pString operator + (const char *c, const pString& s2)
  { return pString(c) + s2; }
  pString operator + (const char *c) {pString rv(s); rv += c; return rv;}
  void operator += (char c)
  {
    if( occ == size )
      {
        if( size == 0 ) init_space(64);
        else
          {
            size <<= 1;
            s = (char*)realloc(s,size+1);
          }
      }
    s[occ++] = c;  s[occ] = 0;
  }

  void operator += (const char *c)
  {
    if( !s ) { cpy(c);  return; }
    int c_len = strlen(c);
    int new_occ = occ + c_len;
    if( new_occ > size )
      {
        size = new_occ;
        s = (char*)realloc(s,size+1);
      }
    memcpy(&s[occ],c,c_len+1);
    occ = new_occ;
  }
  inline void operator += (const std::string& str)
  { operator += (str.c_str()); }
  inline void operator += (const pString &str) { operator += (str.s); }
  void append(const char *c){ operator += (c); }
  void append_take(char *c)
  {
    if( occ ) { append(c);  free(c); }
    else { assign_take(c); }
  }
  void append_substring(const char *c, const char *stop)
  {
    if( c >= stop ) return;
    const char *ci = c;
    while( ci < stop && *ci ) ci++;
    const int c_len = ci - c;
    int new_occ = occ + c_len;
    if( new_occ > size )
      {
        if( !size ) init_space(new_occ);
        else s = (char*)realloc(s,new_occ+1);
        size = new_occ;
      }
    memcpy(&s[occ],c,c_len);
    occ = new_occ;
    s[occ] = 0;
  }

  char *s;
  static Linger_Char *lc;
private:
  int size; // Maximum string size that can fit in allocated space.
  int occ;  // Current string size.
};

class pStringF: public pString {
public:
  pStringF(const char* fmt,...) __attribute__ ((format(printf,2,3)))
    :pString()
  {va_list ap; va_start(ap,fmt); vsprintf(fmt,ap); va_end(ap);}
};

inline const char*
pstringf(const char* fmt,...) __attribute__ ((format(printf,1,2)));
inline const char*
pstringf(const char* fmt,...)
{
  pString rs;
  va_list ap;
  va_start(ap,fmt);
  rs.vsprintf(fmt,ap);
  va_end(ap);
  return rs.linger();
}

#endif
