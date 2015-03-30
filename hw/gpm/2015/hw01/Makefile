
INCLUDE =  -I../../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm

CUDUMPFLAGS = --print-line-info --print-code 
# --print-life-ranges --life-range-mode wide

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_35  -g  \
	-Xcompiler -fopenmp -O3

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)
LIBRARIES = -lrt -lpthread 

default: hw01 hw01sol


hw01.o: util.h
hw01sol.o: util.h

%.o: %.cc Makefile
	$(CXX) $(CFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx &
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

hw01: hw01.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)

hw01sol: hw01sol.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)


clean:
	/bin/rm *.o *.ptx *.sass *.cubin hw01
