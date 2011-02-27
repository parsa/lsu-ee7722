### LSU EE 7700-2 (Sp 2011), GPU Microarchitecture
#
#  Homework 1
#
#  See stream-2.cc for instructions.


INCLUDE =  -I../include  -I../../include
CUDAPATH = /usr/local/cuda


COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_11

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)
LIBRARIES = -lrt

default: stream-2

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx


stream-2.o: stream-2.cc stream-2-kernel.cu stream-2.cuh Makefile
stream-2-kernel.o: Makefile stream-2.cuh stream-2-kernel.cu

stream-2: stream-2.o stream-2-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $^ $(LIBRARIES)
