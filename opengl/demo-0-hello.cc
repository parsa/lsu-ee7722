/// LSU EE 7700-2 (Sp 08), Graphics Processors
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
//

#include <stdio.h>
#include <GL/gl.h>
#include <GL/freeglut.h>

/// OpenGL API Design

// API abstracts structure of graphics hardware.

// Most commands set state, a few trigger rendering.

// State refers to the rendering pipeline (an abstraction of the GPU).

// The state which commands change is explicitly quantified
// and intentionally limited.

// OpenGL intentionally omits convenient features that might appear in
// a graphics library, such as "graphics contexts" which specify
// collections of state settings such as color, lighting, transform,
// line styles.  They are omitted because they might be inefficient
// to implement and so it would make it too easy for a user to
// slow down rendering.


/// OpenGL and glut

// OpenGL is an API for using the rendering pipeline to paint
// a frame buffer.

// It is NOT an API for locating or changing a frame buffer, that is
// something which is done through the window system API.

// Glut (gl utility toolkit) allows one to start OpenGL with a
// frame buffer on both Unix Systems (Linux,Solaris,Mac OS X, etc.)
// and MS Windows systems.

// Glut is intended for quick demos, not complete applications.

// Ideally, OpenGL would already be integrated with GTK, a system
// for building GUI apps. Alas, at the moment one can only use OpenGL
// with a GTK mod.



void
display_callback()
{
  /// Initialize Frame Buffer

  //  Set color used for initialization.
  //
  glClearColor(0.1, 0.1, 0.1, 0);    // Red, Green, Blue, Alpha

  //  Clear color buffer using color registered above.
  //
  glClear( GL_COLOR_BUFFER_BIT );


  /// Specify Transformation Matrices
  //
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(-1,-0.5,-3);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Left, Right, Top, Bottom, Front, Back
  glFrustum(-0.8,+0.8,-0.8,0.8,1,5000);

  /// Emit One Purple Triangle
  //

  //  Specify color attribute.
  //
  //  This will be used for all vertices specified after this point.
  //
  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue
  // Note: "3ub" indicates 3 arguments of type unsigned byte.


  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);


  //  Trigger the processing of a vertex using the indicated
  //  coordinates and whatever attributes have been specified up to
  //  this point (such as color).
  //
  glVertex3f( 1.5, 0, -3.2 );

  glVertex3f( 0, 5, -5 );

  //  Trigger vertex processing and, since the triangle is complete,
  //  all further processing all the way to the frame buffer.
  //
  glVertex3f( 9, 6, -9 );

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
  glutCreateWindow("Hello, world!  - The lonely triangle.");


  /// Specify Display Callback Function
  //
  //  Tell glut to call specified callback function each time our
  //  window needs to be painted (updated). (E.g., after re-size and
  //  after window is damaged by overlapping windows.)
  //
  //  Note that glut won't call this function unless it is "spinning"
  //  the message loop.
  //
  glutDisplayFunc(&display_callback);


  /// Spin the Message Loop
  //
  //  Tell glut to run (spin) the message loop, the mechanism used
  //  to communicate with the windowing system.  Some messages will
  //  indicate that "our" window needs to be painted and for these
  //  glut will call the display function registered above.
  //
  glutMainLoop();

  return 0;
}
