### LSU EE 7700-2 (Sp 08), Graphics Processors
##
##  Makefile for Homework 3
##
## $Id:$

INCLUDE =
LIBDIR  =

HW_NAME = hw3
OPTFLAGS = -O3

PROG_NAMES = $(HW_NAME) $(HW_NAME)sol

default: $(PROG_NAMES)

COMPILERFLAGS = -Wall
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g 
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt

DEPENDENCIES = util.h coord.h pstring.h glextfuncs.h Makefile


$(PROG_NAMES): %: %.cc $(DEPENDENCIES)
	$(CXX) $(CFLAGS) $(OPTFLAGS) -fverbose-asm -S $@.cc
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.s $(LIBRARIES) -o $@
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)

