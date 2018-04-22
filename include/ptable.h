// -*- c++ -*-
#ifndef PTABLE_H
#define PTABLE_H

#include "pstring.h"
#include <algorithm>
#include <sys/ioctl.h>
#include <unistd.h>

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
  pTable():num_lines(0),line(""),body(""),opt_underline(false),stream(NULL){};

  int num_lines;
  pString line, body;
  bool opt_underline;
  FILE *stream;
  enum Justification { pT_Unset, pT_Left, pT_Center, pT_Right };

  struct Hdr_Info {
    Hdr_Info(const char* h, Justification jp)
    {
      Justification j1 =
        h[0] == '<' ? pT_Left :
        h[0] == '|' ? pT_Center :
        h[0] == '>' ? pT_Right : pT_Unset;
      const bool jset = j1 != pT_Unset;
      just = jset ? j1 : jp;
      header = jset ? h + 1 : h;
    };
    string header;
    Justification just;
  };

  struct Col_Info {
    Col_Info(int s,int w,const char *sp,const char *h,Justification j)
      :start(s),width(w),sep(sp),hi(h,j){};
    const int start;
    const int width;
    const string sep;
    const Hdr_Info hi;
  };
  class Span_Info {
  public:
    Span_Info(int col_nump, int ncolsp, const char *h, Justification j)
      :col_num(col_nump), ncols(ncolsp), hi(h,j){};
    int col_num;
    int ncols;
    Hdr_Info hi;
  };

  vector<Col_Info> col_info;
  vector<Span_Info> span_info;

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
    assert( header_span_stack.empty() );
    if ( !body.len() )
      {
        vector<string> hls = { string("") };

        // Single-Column Headers
        for ( auto& ci: col_info )
          {
            if ( hls.back().length() > 0 ) hls.emplace_back("");
            const int hlen = utf8_len(ci.hi.header);
            int pos_start =
              ( ci.hi.just == pT_Left ? 0 :
                ci.hi.just == pT_Center
                ? ( ci.width - hlen ) >> 1 : ci.width - hlen )
              + ci.start - ci.sep.length();
            int pos_search = max(0,pos_start);
            auto hli = find_if
              ( hls.begin(), hls.end(),
                [&](const string s){return utf8_len(s) <= pos_search; } );
            string& hl = *hli;
            int pad = pos_search - utf8_len(hl) + ci.sep.length();
            hl += string(pad,' ') + ci.hi.header;
          }

        // Multi-Column Headers
        sort( span_info.begin(), span_info.end(),
              [](Span_Info a, Span_Info b)
              { return a.col_num < b.col_num || a.ncols < b.ncols; } );
        for ( auto& si: span_info )
          {
            if ( hls.back().length() > 0 ) hls.emplace_back("");
            const int hlen = utf8_len(si.hi.header);
            assert( si.col_num + si.ncols <= int(col_info.size()) );
            Col_Info &ci = col_info[si.col_num];
            int pos_start = ci.start - ci.sep.length();
            int pos_search = max(0,pos_start);
            auto hli = find_if
              ( hls.begin(), hls.end(),
                [&](const string s){return utf8_len(s) <= pos_search; } );
            string& hl = *hli;
            const int c_last = si.col_num + si.ncols - 1;
            const int width = col_info[c_last].start + col_info[c_last].width
              - col_info[si.col_num].start;
            const int lpad_width =
              ( si.hi.just == pT_Left ? 0 :
                si.hi.just == pT_Center
                ? ( width - hlen ) >> 1 : width - hlen );
            const int rpad_width = width - hlen - lpad_width;
            int pre_pad = pos_search - utf8_len(hl) + ci.sep.length();
            hl += string(pre_pad,' ')
              + string(lpad_width,'-') + si.hi.header + string(rpad_width,'-');
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
        if ( stream ) fprintf(stream,"%s",body.s);
      }
    body += line + "\n";
    if ( stream ) fprintf(stream,"%s\n",line.s);
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
    col_info.emplace_back(pre_len,row.len(),sep,h,jp);
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

  void header_span(const char* h, int ncols, Justification jp = pT_Center)
  {
    if ( num_lines == 1 )
      span_info.emplace_back( col_info.size(), ncols, h, jp );
  }

  vector<int> header_span_stack;
  void header_span_start(const char* h, Justification jp = pT_Center )
    {
      if ( num_lines != 1 ) return;
      header_span_stack.push_back(span_info.size());
      header_span(h,0,jp);
    }

  void header_span_end()
    {
      if ( num_lines != 1 ) return;
      assert( !header_span_stack.empty() );
      const int idx = header_span_stack.back();
      Span_Info& si = span_info[idx];
      assert( si.ncols == 0 );
      header_span_stack.pop_back();
      si.ncols = col_info.size() - si.col_num;
    }

  const char* body_get()
    {
      row_end();
      return body.s;
    }

};

#endif
