### LSU EE 7700-2 (Sp 08), Graphics Processors
##
##  Makefile for cpu-only demo programs.
##
## $Id:$

INCLUDE =
LIBDIR  =

PROG_NAMES = demo-1-4-lighting

default: $(PROG_NAMES)

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g 
COMPILERFLAGS = -Wall
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt

OBJ_NAMES = $(PROG_NAMES:=.o)

$(OBJ_NAMES): frame_buffer.h coord.h Makefile

$(PROG_NAMES): %: %.o Makefile
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

.cc.o:
	$(CXX) $(CFLAGS) -fverbose-asm -S $*.cc
	$(CXX) $(CFLAGS) -c $*.s
