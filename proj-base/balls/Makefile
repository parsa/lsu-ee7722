
INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  \
  -I../include -I../../include

CUDAPATH = /usr/local/cuda

# -Xnvopencc -LIST:source=on

COMPILERFLAGS = -Xcompiler -Wall --ptxas-options=-v \
   -Xcompiler -Wno-unused-function -use_fast_math
OPTFLAGS = -O3

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc 

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Xcompiler -Wno-strict-aliasing \
  -Xcompiler -Wno-parentheses 

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CXXFLAGS = $(CFLAGS)  $(MAGICKCXX) -std=c++11
CUFLAGS = $(CFLAGS) -Xcompiler -std=gnu++98

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)


default: balls

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CUFLAGS) -c $*.cu

# balls.o: demo-x-kernel.cu demo-x.cuh
balls-kernel.o: Makefile balls.cuh balls-kernel.cu


balls: balls.cc shapes.h tiles.h Makefile balls.cuh balls-kernel.o
	$(CXX) $(CXXFLAGS) $(OPTFLAGS) $@.cc balls-kernel.o -o $@ $(LIBRARIES)
	$(CXX) $(CXXFLAGS) $@.cc -o $@-debug balls-kernel.o $(LIBRARIES)


clean:
	/bin/rm -f  *.o *~ *.sass *.cubin *.ptx balls balls-debug

