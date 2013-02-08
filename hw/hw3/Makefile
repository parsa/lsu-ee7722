### LSU EE 7700-2 (Spring 2013), GPU Microarchitecture
##
##  Makefile for Homework 3
##


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_20  -g

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)
LIBRARIES = -lrt -lpthread

default: all

all: hw3

%.o: %.cc Makefile
	$(CXX) $(CFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass

hw3: hw3.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)


clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin
