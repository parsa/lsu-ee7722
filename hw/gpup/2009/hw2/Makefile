### LSU EE 4702-1 (Fall 2009), GPU Programming
##
##  Makefile for Homework 1
##
## $Id:$

COURSE_INCLUDE_DIR = ./include

INCLUDE = -I$(COURSE_INCLUDE_DIR)


default: hw2 hw2sol


CFLAGSMAGIK_MAYBE := $(shell Magick++-config --cppflags --cxxflags)
LDFLAGSMAGIK := $(shell Magick++-config  --ldflags --libs)
ifeq ($(CFLAGSMAGIK_MAYBE),)
CFLAGSMAGIK :=
else
CFLAGSMAGIK := $(CFLAGSMAGIK_MAYBE) -DMAGICK
endif

OPTFLAGS = -O3

CFLAGS = $(INCLUDE) -Wall -g3  $(CFLAGSMAGIK)
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt $(LDFLAGSMAGIK)

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile


hw2: hw2.cc $(INCLUDES)
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.cc -o $@ $(LIBRARIES)
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)

hw2sol: hw2sol.cc $(INCLUDES)
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.cc -o $@ $(LIBRARIES)
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)

clean:
	/bin/rm -f  *.o *~ *.sass *.cubin *.ptx *.html hw2 hw2sol
