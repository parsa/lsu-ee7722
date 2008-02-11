### LSU EE 7700-2 (Sp 08), Graphics Processors
##
##  Makefile for cpu-only demo programs.
##
## $Id:$

INCLUDE =
LIBDIR  =

default: hw1

OPTFLAGS = -O3

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g
COMPILERFLAGS = -Wall
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt

hw1: hw1.cc frame_buffer.h coord.h Makefile
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)
	$(CXX) $(CFLAGS) $(OPTFLAGS) -fverbose-asm -S $@.cc
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.s $(LIBRARIES) -o $@

