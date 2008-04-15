### LSU EE 7700-2 (Sp 08), Graphics Processors
##
##  Makefile for Homework
##
## $Id:$

INCLUDE =
LIBDIR  =

HW_NAME = hw5
OPTFLAGS = -O3

default: $(HW_NAME)

COMPILERFLAGS = -Wall
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g 
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt

DEPENDENCIES = util.h coord.h pstring.h glextfuncs.h shader.h Makefile


$(HW_NAME): $(HW_NAME).cc $(DEPENDENCIES)
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.cc $(LIBRARIES) -o $@
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)
#

