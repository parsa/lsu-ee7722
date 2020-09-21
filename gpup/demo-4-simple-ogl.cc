/// LSU EE 4702-1 (Fall 2020), GPU Programming
//
 /// Minimal OpenGL Program

 /// Purpose
//
//   Show complete OpenGL program in compact form.

//   The routine draws a single triangle.


 /// To compile and run:
//
//     make
//     demo-4-simple-ogl

#if 0
/// Background
//

 /// References
//
// :ogl46: OpenGL Specification Version 4.6
//         http://www.opengl.org/registry/doc/glspec46.compatibility.pdf

/// Software Used in This Demo
//

 /// OpenGL (NVidia's Implementation)
 //
 //  A library for using GPUs.
 //
 //  In this demo, it's used to draw a triangle on the frame buffer.

 /// Glut
 //
 //  A library for initializing OpenGL.


/// Important Concepts in this Demo
//

 /// Role of OpenGL, and glut, and how code organized.
 //
 /// Basic OpenGL Frame Buffer Operations
 //
 /// OpenGL Primitives
 //
 /// OpenGL Rendering Pass
 //
 /// OpenGL Function Naming Conventions

/// Concepts Covered in the Next Demo, more-ogl.cc
 //
 //  Coordinate spaces and transformation matrices.
 //  Color and other vertex attributes.


/// Organization of This Demo
//

 /// The main routine
 //
 //  Use glut to set up window (and associated frame buffer).
 //
 //  Tell glut to run our render routine when needed.
 //
 /// The render routine
 //
 //  Paint the frame buffer with a triangle using OpenGL.


/// OpenGL Primitives and The Rendering Pass
//
// :ogl46: Section 10.1  Primitives

 // :Practice Problems:
 //  2018 Final Exam Problem 1 Drawing simple figures.
 // https://www.ece.lsu.edu/koppel/gpup/2018/fe.pdf

 // :Def: OpenGL Primitive
 // A shape (or collection of shapes) that OpenGL can render on to the
 // frame buffer. For example, a triangle.
 //
 // - There are a small number of primitives.
 // - More complex objects are constructed from primitives by non OpenGL code.
 //
 // In most cases, primitives are some form of triangle.
 //
 /// Each type of primitive:
 //
 //  - Consists of one or more Vertices.
 //  - Defines a shape. (Triangle, line, etc.)
 //  - May have a relationship with a neighboring primitive.
 //    (See GL_TRIANGLE_STRIP)


 // :Def: Rendering Pass
 // A place in the execution of an OpenGL program in which OpenGL
 // is rendering (writing the frame buffer with) primitives.
 //
 // - A rendering pass renders multiple instances of the same primitive,
 //     for example, 200 triangles.
 //
 /// Performing a Rendering Pass
 //
 //  Simple method: glBegin / glEnd
 //  - The rendering pass starts at glBegin and ends at glEnd.
 //  - This method is considered inefficient, but used in this set.
 //
 //  Efficient method: glDraw. (Or similar)
 //  - The entire rendering pass is performed during the call go glDraw.
 //  - This method will be used in later sets.


 /// Some Commands
 //
     glBegin(PRIMITIVE);
 //  Start a rendering pass to render PRIMITIVE.
 //  Subsequent vertices used to form PRIMITIVE.
 //
 //  - PRIMITIVE can be GL_TRIANGLES, GL_LINE_STRIP, etc. (See below)
 //
 //
      glVertex3f(x,y,z);
 //  "Send" vertex coordinate x,y,z to OpenGL.
 //
 //  - Interpretation of that vertex depends on the current primitive.
 //  - Normally a large number of vertices sent to OpenGL.
 //
 //
      glEnd();
 //   Tell OpenGL that we are no longer rendering PRIMITIVE.
 //

 /// Primitive Type:  GL_TRIANGLES
     glBegin(GL_TRIANGLES);
//
 //  Isolated triangles.
 //
 //  Let v1, v2, v3, v4, v5, v6 be the vertices specified in glVertex.
 //
 //  Triangle 1: (v1,v2,v3)
 //  Triangle 2: (v4,v5,v6)
 //
 //  To render T triangles need 3T vertices.

 /// Primitive Type:  GL_TRIANGLE_STRIP
     glBegin(GL_TRIANGLE_STRIP);
 //
 //  Triangles sharing an edge with neighbors.
 //
 //  Let v1, v2, v3, v4, v5 be the vertices specified in glVertex.
 //
 //  Triangle 1: (v1,v2,v3)
 //  Triangle 2: (v4,v3,v2)  // Note backward order.
 //  Triangle 3: (v3,v4,v5)
 //
 //  To render T triangles need T+2 vertices.

 /// Primitive Type:  GL_TRIANGLE_FAN
     glBegin(GL_TRIANGLE_FAN);
 //
 //  Triangles sharing an edge with neighbors, and all sharing one vertex.
 //
 //  Let v1, v2, v3, v4, v5 be the vertices specified in glVertex.
 //
 //  Triangle 1: (v1,v2,v3)
 //  Triangle 2: (v1,v3,v4)
 //  Triangle 3: (v1,v4,v5)
 //
 //  To render T triangles need T+2 vertices.

 /// Primitive Types: GL_LINES, GL_LINE_STRIPS, GL_LINE_LOOP
     glBegin(GL_LINES);
 //
 //  Lines. Or more precisely, thin rectangles.

 /// Primitive Type: GL_POINTS
     glBegin(GL_POINTS);
 //
 //  Dots.


 /// Deprecated Primitives
 //
 //  These primitives are deprecated because the only advantage over
 //  other primitives is convenience.
 //
 //  Primitive Type: GL_QUADS, GL_QUAD_STRIP, GL_POLYGON

#endif


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

  // Note: Coordinate spaces and transformation matrices described
  // in demo-5-more-ogl.cc.
  //
  // In other words, you can skip ahead to the "Purple Triangle" section.

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

  // Note: Coordinate spaces and transformation matrices described
  // in demo-5-more-ogl.cc.


  ///
  /// Emit One Purple Triangle
  ///

  //  Indicate type of primitive.
  //
  glBegin(GL_TRIANGLES);

  //  Specify color attribute.
  //
  //  This will be used for all vertices specified after this point.
  //
  glColor3ub( 0x58, 0x0d, 0xa6); // Red, Green, Blue
  //
  // Note: "3ub" indicates 3 arguments of type unsigned byte.

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
  glutInitWindowSize( 1280, 960 );

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
