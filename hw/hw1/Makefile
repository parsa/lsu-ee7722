### LSU EE 4702-1 (Fall 2013), GPU Programming
##
##  Makefile for Homework 1
##
## $Id:$


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

CXX = g++

.SUFFIXES: .cu .cuh

PACKAGE_CXXFLAGS = $(shell Magick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) \
	 -g -Wall -Wno-strict-aliasing -Wno-parentheses

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: hw1 hw1-sol

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

hw1: hw1.cc $(INCLUDES) hw1-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

hw1-sol: hw1-sol.cc $(INCLUDES) hw1-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 


clean:
	/bin/rm -f hw1 hw1-debug *.o *~

