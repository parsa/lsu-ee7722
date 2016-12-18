
INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code 
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide


# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -O3 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

# -maxrregcount

# --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_13


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags) -std=c++11
CUFLAGS = $(CFLAGS) -Xcompiler -std=gnu++98

LIBRARIES =   



default: sort

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CUFLAGS) -c $*.cu
	$(CXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass


sort.o: sort.cc sort-kernel.cu sort.cuh Makefile
sort-kernel.o: Makefile sort.cuh sort-kernel.cu

sort: sort.o sort-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	/bin/rm -f  *.o *~ sort-kernel.sass *.cubin *.ptx sort

