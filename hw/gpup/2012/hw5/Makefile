### LSU EE 4702-1 (Fall 2012), GPU Programming
##
##  Makefile for Homework 5
##
## $Id:$


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = 

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h cuda-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	  Makefile

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump
CXX = $(CUDAPATH)/bin/nvcc

COMPILERFLAGS = -g -O3  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CUFLAGS = $(CFLAGS) -Xcompiler --std=gnu++98
CXXFLAGS = $(CFLAGS) $(MAGICKCXX) -Xcompiler --std=c++11
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)


.SUFFIXES: .cu .cuh

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

SRC_FILES = hw5.cc
CU_SRC_FILE = hw5-cuda.cu

OBJ_FILES = $(SRC_FILES:.cc=.o) $(CU_SRC_FILE:.cu=.o) 

OBJ_FILES_SOL = hw5-sol.o hw5-sol-cuda.o

default: hw5 hw5-sol


%.o: %.cc $(INCLUDES) Makefile
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CXX) $(CUFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CUFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CUFLAGS) --compile $*.cu

hw5-cuda.o: hw5.cuh
hw5-sol-cuda.o: hw5-sol.cuh


hw5: $(OBJ_FILES)
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

hw5-sol: $(OBJ_FILES_SOL)
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 



clean:
	/bin/rm -f hw5-sol hw5 hw5-debug *.o *~ *.sass *.cubin *.ptx

