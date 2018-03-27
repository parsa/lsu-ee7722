// -*- c++ -*-
#ifndef PTABLE_H
#define PTABLE_H

#include "pstring.h"
#include <algorithm>
#include <sys/ioctl.h>

using namespace std;

inline int
utf8_len(const string& str)
{
  // http://www.zedwood.com/article/cpp-utf8-strlen-function
    int i,ix,q;
    for (q=0, i=0, ix=str.length(); i < ix; i++, q++)
    {
        const int c = (unsigned char) str[i];
        if      (c>=0   && c<=127) i+=0;
        else if ((c & 0xE0) == 0xC0) i+=1;
        else if ((c & 0xF0) == 0xE0) i+=2;
        else if ((c & 0xF8) == 0xF0) i+=3;
        else return 0;//invalid utf8
    }
    return q;
}

inline int
stdout_width_get()
{
  const int wid_cred_min = 10;
  const int wid_cred_max = 1000;
  const int wid_default = 80;
  auto cred = [&](int w){ return w >= wid_cred_min && w <= wid_cred_max; };
  struct winsize wsize;
  ioctl(STDOUT_FILENO, TIOCGWINSZ, &wsize);
  const int output_width_io =
    ioctl(STDOUT_FILENO, TIOCGWINSZ, &wsize) ? 0 : wsize.ws_col;
  if ( cred(output_width_io) ) return output_width_io;
  const int output_width_env = atoi( getenv("COLUMNS") ?: "0" );
  if ( cred(output_width_env) ) return output_width_env;
  return wid_default;
}

class pTable {
public:
  pTable():num_lines(0),line(""),body(""),opt_underline(false){};

  int num_lines;
  pString line, body;
  bool opt_underline;
  enum Justification { pT_Unset, pT_Left, pT_Center, pT_Right };

  struct Col_Info {
    Col_Info(int s,int w,Justification j, const char *sp,const char *h)
      :start(s),width(w),just(j),sep(sp),header(h){};
    const int start;
    const int width;
    const Justification just;
    const string sep;
    const string header;
  };
  vector<Col_Info> col_info;

  void row_start()
  {
    row_end();
    num_lines++;
  }
  int row_len_get() { return line.len(); }
  void row_end()
  {
    if ( !num_lines ) return;
    if ( !line.len() ) return;
    if ( !body.len() )
      {
        vector<string> hls = { string("") };
        for ( auto& ci: col_info )
          {
            if ( hls.back().length() > 0 ) hls.emplace_back("");
            const int hlen = utf8_len(ci.header);
            int pos_start =
              ( ci.just == pT_Left ? 0 :
                ci.just == pT_Center
                ? ( ci.width - hlen ) >> 1 : ci.width - hlen )
              + ci.start - ci.sep.length();
            int pos_search = max(0,pos_start);
            auto hli = find_if
              ( hls.begin(), hls.end(),
                [&](const string s){return utf8_len(s) <= pos_search; } );
            string& hl = *hli;
            int pad = pos_search - utf8_len(hl) + ci.sep.length();
            hl += string(pad,' ') + ci.header;
          }
        if ( hls.back().length() == 0 ) hls.pop_back();
        for ( auto& hl: hls ) body = hl + "\n" + body;
        if ( opt_underline )
          {
            string ul("");
            for ( auto& ci: col_info )
              {
                int pad = ci.start - ul.length();
                ul += string(pad,' ');
                ul += string(ci.width,'-');
              }
            body += ul + "\n";
          }
      }
    body += line + "\n";
    line = "";
  }
  template <typename T>
  void entry
  (const char* h, const char* fmt, T val, Justification jp = pT_Right)
  {
    pStringF row(fmt,val);
    const char* sep = line.len() ? " " : "";
    line += sep;
    const int pre_len = line.len();
    line += row;
    if ( num_lines != 1 ) return;
    Justification j1 =
      h[0] == '<' ? pT_Left :
      h[0] == '|' ? pT_Center :
      h[0] == '>' ? pT_Right : pT_Unset;
    const bool jset = j1 != pT_Unset;
    Justification j = jset ? j1 : jp;
    const char* const h1 = jset ? h + 1 : h;
    col_info.emplace_back(pre_len,row.len(),j,sep,h1);
  }
  template <typename T>
  void entry
  (const string s, const char* fmt, T val, Justification jp = pT_Right)
  { entry(s.c_str(),fmt,val,jp); }
  void entry
  (const char *h, const char* fmt, const string val, Justification jp = pT_Left)
  { entry(h,fmt,val.c_str(),jp); }
  void entry(const char* h, const int val)
  {
    pStringF fmt("%%%zdd",strlen(h));
    entry(h,fmt.s,val);
  }
  void entry(const char* h, const char val)
  {
    pStringF fmt("%%%zdc",strlen(h));
    entry(h,fmt.s,val,pT_Left);
  }
  void entry(const char* h, const pString& val)
  {
    pStringF fmt("%%%zds",strlen(h));
    entry(h,fmt.s,val.s,pT_Left);
  }

  const char* body_get()
    {
      row_end();
      return body.s;
    }

};

#endif
