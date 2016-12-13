### LSU EE 4702-1 (Fall 2016), GPU Programming
##
##  Makefile for Final Exam code.
##


COURSE_INCLUDE_DIR_POSSIBILITIES = \
 ../include ../../include ../../../include ../../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

CXX = g++

.SUFFIXES: .cu .cuh

PACKAGE_CXXFLAGS = $(shell Magick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) --std=c++11 \
	 -g -Wall -Wno-strict-aliasing -Wno-parentheses -fopenmp

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: fep1 


.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

fep1: fep1.cc $(INCLUDES)
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

fep1-sol: fep1-sol.cc $(INCLUDES)
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

clean:
	/bin/rm -f fep1 fep1-debug fep1-sol fep1-sol-debug *.o *~

