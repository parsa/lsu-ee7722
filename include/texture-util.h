/// -*- c++ -*-

#ifndef TEXTURE_UTIL_H
#define TEXTURE_UTIL_H

 ///
 /// Ad-Hoc Class for Reading Images
 ///

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
        p.opacity = decltype(p.opacity)( MaxRGB - sum * 0.3333333 );
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


 ///
 /// Create and initialize texture object using image file.
 ///

#ifdef GP_UTIL_DECLARE_ONLY
GLuint
pBuild_Texture_File
(const char *name, bool invert = false, int transp = 256 );
#else
GLuint
pBuild_Texture_File
(const char *name, bool invert = false, int transp = 256 )
{
  // Read image from file.
  //
  P_Image_Read image(name,transp);
  if ( !image.image_loaded ) return 0;

  // Invert colors. (E.g., to show text as white on black.)
  //
  if ( invert ) image.color_invert();

  GLuint tid;
  glGenTextures(1,&tid);
  glBindTexture(GL_TEXTURE_2D,tid);
  glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, 1);

  // Load data into the texture object.
  //
  glTexImage2D
    (GL_TEXTURE_2D,
     0,                // Level of Detail (0 is base).
     GL_RGBA,          // Internal format to be used for texture.
     image.width, image.height,
     0,                // Border
     image.gl_fmt,     // GL_BGRA: Format of data read by this call.
     image.gl_type,    // GL_UNSIGNED_BYTE: Size of component.
     (void*)image.data);
  pError_Check();

  return tid;
}
#endif

#endif
