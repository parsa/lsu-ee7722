### LSU EE 4702-1 (Fall 2020), GPU Programming
##
##  Makefile for Homework 1
##


COURSE_INCLUDE_DIR_POSSIBILITIES = \
 ../include ../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

CXX = g++

.SUFFIXES: .cu .cuh

PACKAGE_CXXFLAGS = $(shell GraphicsMagick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) --std=c++17 \
	 -g -Wall -Wno-strict-aliasing -Wno-parentheses

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell GraphicsMagick++-config --ldflags --libs) 
LIBDIR  =

default: hw01


.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

hw01: hw01.cc $(INCLUDES) hw01-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

hw01-sol: hw01-sol.cc $(INCLUDES) hw01-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

clean:
	/bin/rm -f hw01 hw01-debug hw01-sol hw01-sol-debug *.o *~

