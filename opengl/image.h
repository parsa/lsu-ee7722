// -*- c++ -*-

// Quick & Dirty Image Loading Routines, so far, only pnm

#ifndef IMAGE_H
#define IMAGE_H

#include <stdio.h>
#include <malloc.h>

class P_Image_Read {
public:
  P_Image_Read(const char *path, int transp):image_loaded(false),data(NULL)
  {
    FILE* const in = fopen(path,"r");
    if ( !in ) return;
    const int MAXLINE = 300;
    char line[MAXLINE];

    fgets(line,MAXLINE,in);
    if( !strcmp(line,"P6") ) {
      fprintf(stderr,"Unexpected first line.\n"); exit(1);
    }

    while ( 1 ) {
      fgets(line,MAXLINE,in);
      if( feof(in) ) {
        fprintf(stderr,"Unexpected end of file.\n"); exit(1);
      }
      if( line[0] != '#' ) break;
    }

    sscanf(line,"%d %d",&width,&height);
    const int num = width * height;
    const int size = num * 4;
    data = (unsigned char*) malloc( size );
    unsigned char *dp = data;
    fread(dp,1,1,in);
    for ( int i = 0; i < num; i++ )
      {
        fread(dp,1,3,in);
        dp[3] = ( ( dp[0] == dp[1] ) && dp[2] == transp ) ? 0 : 255;
        dp += 4;
      }
    fclose(in);
    image_loaded = true;
  };
  ~P_Image_Read() {if ( data ) free(data);  data = NULL;}
  void color_invert()
  {
    const int num = width * height * 4;
    for ( int i = 0; i < num; i+=4 )
      {
        unsigned char* const dp = &data[i];
        const int sum = dp[0] + dp[1] + dp[2];
        dp[3] = (unsigned char)(255 - sum * 0.3333333);
        dp[0] = dp[1] = dp[2] = 255;
      }
  }
  bool image_loaded;
  int width, height, maxval;
  unsigned char *data;
private:
};


#endif
