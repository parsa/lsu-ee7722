
COURSE_INCLUDE_DIR = ../../include

INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  -I$(COURSE_INCLUDE_DIR)
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

COMPILERFLAGS = -O3  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses --cudafe-options=-no-restrict \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_21

COMPILERFLAGS = -O3  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_21


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
CXXFLAGS = $(CFLAGS) -I/usr/include/ImageMagick
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile


default: demo-x-collide

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CFLAGS) --compile $*.cu

demo-x-collide.o: Makefile $(INCLUDES)
demo-x-collide.o: demo-x-collide.cc shapes.h demo-x-kernel.cu demo-x.cuh
demo-x-collide.o: tiles.h boxes.h

demo-x-kernel.o: Makefile demo-x.cuh demo-x-kernel.cu demo-x-collide.cc
demo-x-kernel.o: demo-x-kernel.cu demo-x-boxes.cu

demo-x-collide: demo-x-collide.o demo-x-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	rm -f *.o *.ptx *.sass *.cubin *~
