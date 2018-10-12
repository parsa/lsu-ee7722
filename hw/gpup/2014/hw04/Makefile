### LSU EE 4702-1 (Fall 2014), GPU Programming
##
##  Makefile for Homework 4
##


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

CXX = g++

.SUFFIXES: .cu .cuh

PACKAGE_CXXFLAGS = $(shell Magick++-config --cppflags --cxxflags)

CXXFLAGS = $(INCLUDE) $(PACKAGE_CXXFLAGS) $(OPTFLAGS) --std=c++11 \
	 -g -Wall -Wno-strict-aliasing -Wno-parentheses

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: hw04 hw04sol

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

INCLUDES_BASE = util.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

hw04: hw04.cc $(INCLUDES) hw04-graphics.cc
	$(CXX) $(CXXFLAGS) $<  $(LINKFLAGS) $(OPT_FLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 
	$(CXX) $(CXXFLAGS) $< $(LINKFLAGS) \
	-o $@-debug $(LIBDIR) $(LIBRARIES) 

hw04sol: hw04
	/bin/rm -f hw04sol
	ln hw04 hw04sol


clean:
	/bin/rm -f hw04 hw04-debug hw04sol hw04-sol-debug *.o *~

