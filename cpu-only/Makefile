### LSU EE 7700-1 (Sp 2009), Graphics Processors
##
##  Makefile for cpu-only demo programs.
##
## $Id:$

COURSE_INCLUDE_DIR = ../include

INCLUDE = -I$(COURSE_INCLUDE_DIR)
LIBDIR  =

PROG_NAMES = simple demo-1-one-triangle demo-2-many-triangles \
 demo-3-color-and-z-buffering demo-4-lighting demo-5-textures

CFLAGSMAGIK_MAYBE := $(shell Magick++-config --cppflags --cxxflags)
LDFLAGSMAGIK := $(shell Magick++-config  --ldflags --libs)
ifeq ($(CFLAGSMAGIK_MAYBE),)
CFLAGSMAGIK :=
else
CFLAGSMAGIK := $(CFLAGSMAGIK_MAYBE) -DMAGICK
endif

default: $(PROG_NAMES)

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g3  $(CFLAGSMAGIK)
COMPILERFLAGS = -Wall 
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt $(LDFLAGSMAGIK)

OBJ_NAMES = $(PROG_NAMES:=.o)

$(OBJ_NAMES): frame_buffer.h coord.h Makefile $(COURSE_INCLUDE_DIR)/misc.h

$(PROG_NAMES): %: %.o Makefile
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

.cc.o:
	$(CXX) $(CFLAGS) -fverbose-asm -S $*.cc
	$(CXX) $(CFLAGS) -c $*.s
