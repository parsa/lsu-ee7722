
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
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20


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
	 Makefile


default: boxes

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CFLAGS) --compile $*.cu

boxes.o: Makefile $(INCLUDES)
boxes.o: boxes.cc gra-shapes.h k-main.cuh
boxes.o: phys-obj-box.h phys-obj-tile.h

k-main.o: Makefile k-main.cuh k-main.cu boxes.cc
k-main.o: k-main.cu k-boxes.h

boxes: boxes.o k-main.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	rm -f *.o *.ptx *.sass *.cubin *~
