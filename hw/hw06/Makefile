### LSU EE 4702-1 (Fall 2014), GPU Programming
##
##  Makefile for Homework 6
##


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

CUDAPATH = /usr/local/cuda

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
	   $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))



INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

CUDUMP = $(CUDAPATH)/bin/cuobjdump
CUXX = $(CUDAPATH)/bin/nvcc
CXX = $(CUXX)
#CXX = g++

.SUFFIXES: .cu .cuh

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

PACKAGE_CXXFLAGS = $(MAGICKCXX)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) \
	 -g -Xcompiler -Wall -Xcompiler -Wno-strict-aliasing \
	-Xcompiler -Wno-parentheses

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags)
LIBDIR  =

default: hw06

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
		gl-buffer.h texture-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

hw06: hw06.cc $(INCLUDES) hw06-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES)
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES)


clean:
	/bin/rm -f hw06 hw06-debug hw06-sol hw06-sol-debug *.o *~
