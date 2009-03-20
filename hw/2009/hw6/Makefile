### LSU EE 7700-1 (Sp 2009), Graphics Processors
##
##  Makefile for Homework 1
##
## $Id:$

default: hw6


CFLAGSMAGIK_MAYBE := $(shell Magick++-config --cppflags --cxxflags)
LDFLAGSMAGIK := $(shell Magick++-config  --ldflags --libs)
ifeq ($(CFLAGSMAGIK_MAYBE),)
CFLAGSMAGIK :=
else
CFLAGSMAGIK := $(CFLAGSMAGIK_MAYBE) -DMAGICK
endif

OPTFLAGS = -O3

CFLAGS =  -Wall -g3  $(CFLAGSMAGIK)
CC = gcc
CXX = g++
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt $(LDFLAGSMAGIK)

hw6: hw6.cc util.h coord.h Makefile
	$(CXX) $(CFLAGS) $(OPTFLAGS) $@.cc -o $@ $(LIBRARIES)
	$(CXX) $(CFLAGS) $@.cc -o $@-debug $(LIBRARIES)

