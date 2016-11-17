### LSU EE 4702-1 (Fall 2016), GPU Programming
##
##  Makefile for Classroom Demos
##


COURSE_INCLUDE_DIR = ../include
CUDAPATH = /usr/local/cuda



OPT_FLAGS =  -O3
# OPT_FLAGS =

CXX = g++

CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code 
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide


CUXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

INCLUDE = -I$(COURSE_INCLUDE_DIR)

PACKAGE_CXXFLAGS = $(shell Magick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) -std=gnu++11 \
         -Wno-parentheses \
	 -I$(CUDAPATH)/include \
	 -g -Wall -Wno-strict-aliasing

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11  -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: all
#default: demo-11-a-comp-shader
all:demo-1c-coord demo-2-springs demo-1-simple demo-3-balls demo-4-simple-ogl \
	demo-5-more-ogl demo-6-lighting demo-7-vtx-arrays demo-8-texture \
	demo-9-shader demo-1d-objects demo-10-shader demo-11-a-comp-shader \
	demo-cuda-01-simple demo-cuda-02-basics demo-cuda-03-shared-mem \
        demo-cuda-04-acc-pat demo-0-coor

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h cuda-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile


CUFLAGS = -g $(OPT_FLAGS) -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses -Xcompiler -std=gnu++98 \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_30 \
 $(INCLUDE)

%.o: %.cc Makefile $(INCLUDES)
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

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

demo-11-a-comp-shader.o: $(INCLUDES)
demo-11-a-comp-shader: demo-11-a-comp-shader.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-11-comp-shader.o: $(INCLUDES)
demo-11-comp-shader: demo-11-comp-shader.o
	$(CXX) $(LINKFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-cuda-01-simple: demo-cuda-01-simple.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

demo-cuda-02-basics: demo-cuda-02-basics.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

demo-cuda-03-shared-mem: demo-cuda-03-shared-mem.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

demo-cuda-04-acc-pat: demo-cuda-04-acc-pat.o demo-cuda-04-acc-pat-cuda.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

clean:
	/bin/rm -f  *.o *~ *.sass *.cubin *.ptx

