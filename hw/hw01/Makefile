### LSU EE 7722 (Spring 2014), GPU Microarchitecture
##
##  Makefile for Homework 1
##


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_20  -g  -Xptxas -dlcm=cg

#  -Xptxas -dlcm=cg


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)
LIBRARIES = -lrt -lpthread

default: all

all: hw01

%.o: %.cc Makefile
	$(CXX) $(CFLAGS) -c $*.cc

# Compile, but also prepare ptx and sass (disassembled CUDA machine code) files.
#
%.o: %.cu Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass

hw01: hw01.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin hw01 *~

