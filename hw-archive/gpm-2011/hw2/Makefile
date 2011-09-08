### LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
#
#  Homework 2
#
#  See stencil-2d.cc for instructions.

INCLUDE =  -I../include  -I../../include
CUDAPATH = /usr/local/cuda

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_11 -G

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)

default: sol

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx


stencil-2d.o: stencil-2d.cc stencil-2d-kernel.cu stencil-2d.cuh Makefile
stencil-2d-kernel.o: Makefile stencil-2d.cuh stencil-2d-kernel.cu

stencil-2d: stencil-2d.o stencil-2d-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $^ $(LIBRARIES)

sol.o: sol.cc sol-kernel.cu sol.cuh Makefile
sol-kernel.o: Makefile sol.cuh sol-kernel.cu

sol: sol.o sol-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $^ $(LIBRARIES)

