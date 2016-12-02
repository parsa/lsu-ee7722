### LSU EE 4702-1 (Fall 2016), GPU Programming
##
##  Makefile for Homework 7
##


COURSE_INCLUDE_DIR_POSSIBILITIES = \
 ../include ../../include ../../../include ../../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))


OPT_FLAGS =  -O3
#OPT_FLAGS =

CXX = g++

CUDAPATH = /usr/local/cuda
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

default: hw07 hw07-sol

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h cuda-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile


CUFLAGS = -g $(OPT_FLAGS) -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses -Xcompiler -std=gnu++98 \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_30 \
 $(INCLUDE) -Xcompiler -fopenmp

%.o: %.cc Makefile $(INCLUDES)
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass


hw07-sol: hw07.o hw07-cuda-sol.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

hw07: hw07.o hw07-cuda.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

clean:
	/bin/rm -f  *.o *~ *.sass *.cubin *.ptx hw07 hw07-debug


