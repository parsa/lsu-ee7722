// -*- c++ -*-

// Image loading class.

#ifndef IMAGE_H
#define IMAGE_H

#include <stdio.h>
#include <malloc.h>
#include <Magick++.h>

class P_Image_Read
{
public:
  P_Image_Read(const char *path, int transp):
    image(path),image_loaded(false),data(NULL)
  {
    using namespace Magick;
    width = image.columns();
    height = image.rows();
    size = width * height;
    if ( !width || !height ) return;
    if ( transp == 255 )
      image.transparent(Color("White"));
    pp = image.getPixels(0,0,width,height);
    for ( int i = 0; i < size; i++ ) pp[i].opacity = MaxRGB - pp[i].opacity;
    gl_fmt = GL_BGRA;
    gl_type = sizeof(PixelPacket) == 8 ? GL_UNSIGNED_SHORT : GL_UNSIGNED_BYTE;
    data = (unsigned char*) pp;
    image_loaded = true;
  };
  void color_invert()
  {
    using namespace Magick;
    for ( int i = 0; i < size; i++ )
      {
        PixelPacket& p = pp[i];
        p.red = MaxRGB - p.red;
        p.blue = MaxRGB - p.blue;
        p.green = MaxRGB - p.green;
      }
  }
  void gray_to_alpha()
  {
    using namespace Magick;
    for ( int i = 0; i < size; i++ )
      {
        PixelPacket& p = pp[i];
        const int sum = p.red + p.blue + p.green;
        p.opacity = (typeof p.opacity)( MaxRGB - sum * 0.3333333 );
        p.red = p.blue = p.green = 0;
      }
  }

  Magick::Image image;
  Magick::PixelPacket *pp;
  bool image_loaded;
  int width, height, maxval, size;
  unsigned char *data;
  int gl_fmt;
  int gl_type;
private:
};

#endif
