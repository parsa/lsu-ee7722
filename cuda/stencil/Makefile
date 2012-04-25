
INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  -use_fast_math -g --gpu-architecture=sm_21 \
 -Xptxas -dlcm=ca

# -maxrregcount

# --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_13


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =    -lrt 



default: stencil

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass


stencil.o: stencil.cc stencil-kernel.cu stencil.cuh Makefile
stencil-kernel.o: Makefile stencil.cuh stencil-kernel.cu

stencil: stencil.o stencil-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

stencil-2d.o: stencil-2d.cc stencil-2d-kernel.cu stencil-2d.cuh Makefile
stencil-2d-kernel.o: Makefile stencil-2d.cuh stencil-2d-kernel.cu

stencil-2d: stencil-2d.o stencil-2d-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

