### LSU EE 4702-1 (Fall 2013), GPU Programming
##
##  Makefile for Classroom Demos
##
## $Id:$


COURSE_INCLUDE_DIR = ../include

INCLUDE = -I$(COURSE_INCLUDE_DIR)


OPT_FLAGS =  -O3

CXX = g++

.SUFFIXES: .cu .cuh

PACKAGE_CXXFLAGS = $(shell Magick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) \
	 -g -Wall -Wno-strict-aliasing

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: all
#default: demo-cuda-01-simple
all:demo-1c-coord demo-2-springs demo-1-simple demo-3-balls demo-4-simple-ogl \
	demo-5-more-ogl demo-6-lighting demo-7-vtx-arrays demo-8-texture \
	demo-9-shader demo-1d-objects demo-10-shader demo-2-live \
	demo-cuda-01-simple demo-cuda-02-basics demo-cuda-03-shared-mem

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h cuda-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump
CUXX = $(CUDAPATH)/bin/nvcc

CUFLAGS = -g -O3 -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

%.o: %.cc Makefile $(INCLUDES)
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass

demo-1-simple.o:  $(INCLUDES) demo-1-simple-graphics.cc
demo-1-simple: demo-1-simple.o 
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-1c-coord.o:  $(INCLUDES) demo-1c-coord-graphics.cc
demo-1c-coord: demo-1c-coord.o 
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-1d-objects.o:  $(INCLUDES) demo-1d-objects-graphics.cc
demo-1d-objects: demo-1d-objects.o 
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-2-springs.o: $(INCLUDES) demo-2-springs-graphics.cc
demo-2-springs: demo-2-springs.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-2-live.o: $(INCLUDES) demo-2-live-graphics.cc shapes.h
demo-2-live: demo-2-live.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-3-balls.o: $(INCLUDES)
demo-3-balls: demo-3-balls.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


demo-4-simple-ogl.o: $(INCLUDES)
demo-4-simple-ogl: demo-4-simple-ogl.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


demo-5-more-ogl.o: $(INCLUDES)
demo-5-more-ogl: demo-5-more-ogl.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-6-lighting.o: $(INCLUDES)
demo-6-lighting: demo-6-lighting.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-7-vtx-arrays.o: $(INCLUDES)
demo-7-vtx-arrays: demo-7-vtx-arrays.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-8-texture.o: $(INCLUDES)
demo-8-texture: demo-8-texture.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-9-shader.o: $(INCLUDES)
demo-9-shader: demo-9-shader.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-10-shader.o: $(INCLUDES)
demo-10-shader: demo-10-shader.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-cuda-01-simple: demo-cuda-01-simple.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

demo-cuda-02-basics: demo-cuda-02-basics.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

demo-cuda-03-shared-mem: demo-cuda-03-shared-mem.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

clean:
	/bin/rm -f  *.o *~ *.sass *.cubin *.ptx

