/// LSU EE 4702-1 (Fall 2009), GPU Programming
//
 /// Minimal OpenGL Program

// $Id:$

 /// Purpose
//
//   Show complete OpenGL program in compact form.

//   The routine draws a single triangle.


 /// To compile and run:
//
//     make
//     demo-4-simple-ogl


// C Standard IO (part of C library) header.
//
#include <stdio.h>

// OpenGL library header.
//
#include <GL/gl.h>

// Glut (OpenGL utility) library header.
//
#include <GL/freeglut.h>


/// Render: Paint Frame Buffer
///
void
render()
{
  // This routine called each time OS wants a region of the screen
  // painted.

  ///
  /// Clear Frame Buffer  (Set all pixels to same color.)
  ///

  //  Tell OpenGL what color to clear the frame to.
  //  The color below is a dark gray.
  //
  glClearColor(0.1, 0.1, 0.1, 0);    // Red, Green, Blue, Alpha

  //  Clear color buffer using color specified by last glClearColor call.
  //
  glClear( GL_COLOR_BUFFER_BIT );


  ///
  /// Specify Transformation Matrices
  ///

  // Tell OpenGL that subsequent matrix commands are for modelview matrix.
  //
  glMatrixMode(GL_MODELVIEW);
  //
  // The modelview matrix transforms from object (world) to eye space.

  // Load an identity matrix into modelview matrix.
  //
  glLoadIdentity();

  // Multiply modelview matrix by a translation matrix.
  // (Note that there is no OpenGL glLoadTranslatef().
  //
  glTranslatef(-1,-0.5,-3);
  //
  // Note: the "f" means arguments are of type float.
  //
  // This modelview is for a viewer at (1,0.5,3);


  // Tell OpenGL that subsequent matrix commands are for projection matrix.
  //
  glMatrixMode(GL_PROJECTION);

  // Load an identity matrix into projection matrix.
  //
  glLoadIdentity();

  // Multiply projection matrix by a frustum transformation.
  //
  // Left, Right, Top, Bottom, Front, Back
  glFrustum( -0.8, +0.8, -0.8, 0.8, 1, 5000 );


  ///
  /// Emit One Purple Triangle
  ///

  //  Specify color attribute.
  //
  //  This will be used for all vertices specified after this point.
  //
  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue
  //
  // Note: "3ub" indicates 3 arguments of type unsigned byte.


  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);


  // Specify vertices for a triangle.
  //
  glVertex3f( 1.5, 0, -3.2 );
  glVertex3f( 0,   5, -5 );
  glVertex3f( 9,   6, -9 );
  //
  // Note: "3f" indicates 3 arguments of type float.
  //
  // Note: If we specify 3 more vertices we get another triangle.
  //
  // At this point a triangle painted in "back" frame buffer.


  glEnd();  // No more triangles for now.


  /// Swap Color Buffers
  //
  //  The commands above wrote the "back" color buffer, which is
  //  not displayed.  Swap the back and front buffers so our triangle
  //  will be visible.  (This double-buffering approach makes frame
  //  transitions seem instantaneous.)
  //
  //  OpenGL "knows" how to write the different buffers, but it does
  //  not know how to swap them, which is why the call below uses glut.
  //
  glutSwapBuffers();            // Swap front and back buffers.
}

int
main(int argc, char **argv)
{

  /// Initialize glut
  //
  //   Glut will remove and process selected command line arguments.
  //
  glutInit(&argc, argv);


  /// Request Frame Buffer
  //
  //  Tell glut to get a frame buffer with the listed bitplanes:
  //
  //   GLUT_RGBA:    Get color buffers with bitplanes for red, green,
  //                 blue, and alpha components.
  //   GLUT_DOUBLE:  Two color buffers, one for display, for update.
  //   GLUT_DEPTH:   Request a z-buffer bitplane.
  //
  glutInitDisplayMode( GLUT_RGBA | GLUT_DOUBLE | GLUT_DEPTH );


  /// Request Window
  //
  glutInitWindowSize( 640, 480 );

  // Create a new window.
  //
  glutCreateWindow("Hello, world!  - The lonely triangle.");


  /// Specify Display Callback Function
  //
  //
  //  Tell glut to call specified callback function (render) each time
  //  our window needs to be painted (updated). (E.g., after re-size
  //  or after window is damaged by overlapping windows.)
  //
  //
  //  Note that glut won't call this function unless it is "spinning"
  //  the message loop.
  //
  glutDisplayFunc(&render);


  /// Spin the Message Loop
  //
  //  Tell glut to run (spin) the message loop, the mechanism used
  //  to communicate with the windowing system.  Some messages will
  //  indicate that "our" window needs to be painted and for these
  //  glut will call the display function registered above.
  //
  glutMainLoop();

  // When code reaches this point the program is about to exit.

  return 0;
}
