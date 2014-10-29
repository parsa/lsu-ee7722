/// LSU EE 4702-1 (Fall 2014), GPU Programming
//

 /// Compute Shader -- Simple Example

/// Purpose
//
//   Very simple demonstration of compute shader.

/// References
//
// :ogl45: OpenGL Specification Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf
//
// :sl45:  The OpenGL Shading Language - Language Version 4.5
//         http://www.opengl.org/registry/doc/glspec45.compatibility.pdf

#if 0
/// Miscellaneous Background


 /// New Buffer Object Commands
 //

 ///  glMapBufferRange
 //   Return an ordinary C pointer to the contents of a buffer object.
 //   :ogl45: Section 6.3
 //
 //   After this executes the buffer object is said to be "mapped".
 //
 //   Can be used to read or write contents of buffer object from
 //   the CPU.
 //
 //   Don't leave buffer objects mapped!  Do what you need to do
 //   and then unmap them.

 ///  glUnmapBuffer
 //   Remove a mapping set by glMapBufferRange.
 //   :ogl45: Section 6.3


/// Compute Shader Background

 /// Compute Shaders
//   :ogl45: Chapter 19
//
//   A compute shader is a user-written routine that runs on the
//   GPU (typically, whether it actually does depends on the OpenGL
//   implementation).
//
//   Compute shaders are written in OpenGL Shading Language, the same
//   language as used for render pipeline stages, such as Vertex
//   Shaders.
//
//   Compute shaders are prepared in the same way as other shaders.
//

#endif


#define GL_GLEXT_PROTOTYPES
#define GLX_GLXEXT_PROTOTYPES

#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glx.h>
#include <GL/glxext.h>
#include <GL/glu.h>
#include <GL/freeglut.h>

#include <gp/util.h>
#include <gp/coord.h>
#include <gp/shader.h>
#include <gp/misc.h>

class World {
public:
  World(pOpenGL_Helper &fb):ogl_helper(fb){};

  pOpenGL_Helper& ogl_helper;

  static void frame_callback_w(void *moi){((World*)moi)->frame_callback();}
  void frame_callback();

  float *a, *x;
  int elts;

  GLuint a_bo;  // Input
  GLuint x_bo;  // Output

  pShader *sp_compute;  // Compute shader shader program.

};


void
World::frame_callback()
{
  /// Very Simple Compute Shader Demo
  //
  //  This routine:
  //
  //    - Initializes array "a" so that a[i] = i.
  //    - Uses a compute shader to write  x[i] = a[i] + 1.
  //    - Checks to make sure that x is correct.


  // Number of elements in array.
  //
  elts = 1000;

  // Prepare a Program Object containing a Compute Shader
  //
  sp_compute = new pShader("demo-11-a-shdr.cc");

  a = new float[elts];
  x = new float[elts];

  for ( int i=0; i<elts; i++ )
    {
      a[i] = i;  // Initialize the input array.
      x[i] = 0;  // Zero-out the output array, to help check for errors.
    }

  // Create names for buffer objects for arrays "a" and "x".
  //
  glGenBuffers(1,&a_bo);
  glGenBuffers(1,&x_bo); GE();


  // Copy data into buffer for input array, "a".
  //
  //  Note: GL_SHADER_STORAGE_BUFFER is "target" for shader programs.
  //
  glBindBuffer(GL_SHADER_STORAGE_BUFFER, a_bo);
  glBufferData
    (GL_SHADER_STORAGE_BUFFER,
     elts * sizeof(a[0]),       // Size, in bytes, to copy.
     a,                         // Pointer to data.
     GL_STREAM_READ);           // Hint about who, when, how accessed.

  // Copy data into buffer for output array, "x". (Init to zeros.)
  //
  glBindBuffer(GL_SHADER_STORAGE_BUFFER, x_bo);
  glBufferData
    (GL_SHADER_STORAGE_BUFFER,
     elts * sizeof(x[0]),       // Size, in bytes, to copy.
     x,                         // Pointer to data.
     GL_DYNAMIC_DRAW);          // Hint about who, when, how accessed.


  // "Install" compute shader on GPU.  This doesn't run it.
  //
  sp_compute->use();

  // Bind our buffer objects, a_bo and x_bo, to variables used in compute
  //   shader, which have binding 0 and 1. (See demo-11-a-shdr.cc.)
  //
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 0, a_bo);  GE();
  glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 1, x_bo);  GE();

  // Set value of compute shader's uniform to elts.
  //
  glUniform1i(1, elts); GE();

  // This is the setting used for local_size_x in the compute shader.
  // It indicates the number of members of a work group.
  //
  const int local_size_x = 64;

  // Compute the number of work groups that we need ..
  // .. based on the array size (elts) ..
  // .. and the work group size (local_size_x).
  //
  int ng_x = ( elts + local_size_x - 1 ) / local_size_x;


  // Launch the compute shader with ng_x work groups.
  // This executes the code in demo-11-a-shdr.cc.
  //
  glDispatchCompute( ng_x, 1, 1 );

  // At this point the code in demo-11-a-shdr.cc has finished executing.


  // Make buffer object x_bo readable here as array x_mapped.
  //
  //
  glBindBuffer(GL_SHADER_STORAGE_BUFFER, x_bo);
  //
  float* const x_mapped = (float*)
    glMapBufferRange
    ( GL_SHADER_STORAGE_BUFFER,   // Target
      0,                          // Offset. (Number of bytes to skip.)
      elts*sizeof(x[0]),          // Size, in bytes.
      GL_MAP_READ_BIT             // How mapped buffer will be used.
      );

  // Count how many elements have an incorrect value.
  //
  int err_count = 0;
  for ( int i=0; i<elts; i++ ) if ( x_mapped[i] != a[i] + 1 ) err_count++;

  printf("Finished with %d errors.\n", err_count);

  // Unmap buffer object from x_mapped.
  //
  // Important: This should be done before any other OpenGL commands.
  //
  glUnmapBuffer(GL_SHADER_STORAGE_BUFFER);

  // That's it.
  //
  exit(0);
}


int
main(int argc, char **argv)
{

  pOpenGL_Helper popengl_helper(argc,argv);
  World world(popengl_helper);

  popengl_helper.rate_set(30);
  popengl_helper.display_cb_set(world.frame_callback_w,&world);


  return 0;
}
