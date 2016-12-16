
INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

# -Xptxas -dlcm=cg

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  -use_fast_math -g --gpu-architecture=sm_20


# -maxrregcount

# --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_13


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =    -lrt 



default: matrix-mult

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass

matrix-mult.o: matrix-mult.cc matrix-mult-kernel.cu matrix-mult.cuh Makefile
matrix-mult-kernel.o: Makefile matrix-mult.cuh matrix-mult-kernel.cu

matrix-mult: matrix-mult.o matrix-mult-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	/bin/rm -f  *.o *~ *.cubin *.ptx matrix-mult

