### LSU EE 4702-1 (Fall 2009), GPU Programming
##
##  Makefile for Classroom Demos
##
## $Id:$


COURSE_INCLUDE_DIR = ../include

INCLUDE = -I$(COURSE_INCLUDE_DIR)


COMPILERFLAGS =  -Wall 

CXX = g++

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default:all
all:demo-2-springs demo-1-simple demo-3-balls demo-4-simple-ogl \
	demo-5-more-ogl demo-6-lighting demo-7-vtx-arrays demo-8-texture \
	demo-9-shader

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile


demo-1-simple.o:  $(INCLUDES)
demo-1-simple: demo-1-simple.o 
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-2-springs.o: $(INCLUDES)
demo-2-springs: demo-2-springs.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-3-balls.o: $(INCLUDES)
demo-3-balls: demo-3-balls.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


demo-4-simple-ogl.o: $(INCLUDES)
demo-4-simple-ogl: demo-4-simple-ogl.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


demo-5-more-ogl.o: $(INCLUDES)
demo-5-more-ogl: demo-5-more-ogl.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-6-lighting.o: $(INCLUDES)
demo-6-lighting: demo-6-lighting.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-7-vtx-arrays.o: $(INCLUDES)
demo-7-vtx-arrays: demo-7-vtx-arrays.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-8-texture.o: $(INCLUDES)
demo-8-texture: demo-8-texture.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-9-shader.o: $(INCLUDES)
demo-9-shader: demo-9-shader.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

