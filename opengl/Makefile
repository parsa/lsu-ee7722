### LSU EE 7700-1 (Sp 2009), Graphics Processors
##
##  Makefile for OpenGL demo programs.
##
## $Id:$

INCLUDE =
LIBDIR  =

PROG_NAMES = demo-3-textures demo-2-transfer demo-0-hello \
	demo-5-fshader

default: $(PROG_NAMES)

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g 
COMPILERFLAGS = -Wall
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)

OBJ_NAMES = $(PROG_NAMES:=.o)

$(OBJ_NAMES): util.h coord.h image.h Makefile

$(PROG_NAMES): %: %.o Makefile
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

.cc.o:
	$(CXX) $(CFLAGS) -fverbose-asm -S $*.cc
	$(CXX) $(CFLAGS) -c $*.s
