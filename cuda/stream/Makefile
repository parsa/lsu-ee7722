
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
 --ptxas-options=-v  --gpu-architecture=sm_20  -g -O3 

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
CXXFLAGS = $(CFLAGS)
LIBRARIES =   


default: all

all: stream stream-full stream-2

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o: Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass


stream-full: stream-full.cu
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


stream-2.o: stream-2.cc stream-2-kernel.cu stream-2.cuh Makefile
stream-2-kernel.o: Makefile stream-2.cuh stream-2-kernel.cu

stream.o: stream.cc stream-kernel.cu Makefile
stream: stream.o stream-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

stream-2: stream-2.o stream-2-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin
