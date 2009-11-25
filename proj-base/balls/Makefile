
INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  \
  -I../include -I../../include

CUDAPATH = /usr/local/cuda

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -deviceemu -Xcompiler -Wall -G -Xcompiler -g  --ptxas-options=-v
COMPILERFLAGS = -Xcompiler -Wall --ptxas-options=-v
OPTFLAGS = -O3

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)


default: balls

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) -c $*.cu

# balls.o: demo-x-kernel.cu demo-x.cuh
balls-kernel.o: Makefile balls.cuh balls-kernel.cu


balls: balls.cc shapes.h Makefile balls.cuh balls-kernel.o
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.cc balls-kernel.o -o $@ $(LIBRARIES)
	$(CXX) $(CFLAGS) $@.cc -o $@-debug balls-kernel.o $(LIBRARIES)

