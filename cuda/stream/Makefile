
INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda

CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code 
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

GPU_GET_PATH = ../../util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=$(GPU_ARCH)  -g  \
	-Xcompiler -fopenmp -Xcompiler -O3 -lineinfo -std=c++11


# # -Xnvopencc -LIST:source=on

# # --use_fast_math  bug:
# #   Execution problem occurs with --use_fast_math and certain data placement.

# COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
#  --ptxas-options=-v  --gpu-architecture=sm_20  -g -O3 

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc
CUXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g 
CXXFLAGS = $(CFLAGS)  -std=c++11
CUFLAGS = $(CFLAGS) -Xcompiler -std=gnu++98
LIBRARIES =   


default: stream-cpu-only all

all: stream stream-full stream-2

stream-cpu-only: stream-cpu-only.cc Makefile
	g++ -g --verbose-asm -O3 -fopenmp $< -S -o $@.s 
	g++ -O3 -fopenmp $@.s -o $@

$(BUILD_CC_FILE_PATH):
	;

%.o: %.cc Makefile
#	$(CXX) $(CFLAGS) -S $<
	$(CXX) $(CFLAGS) -c $<

%.o: %.cu Makefile util.h $(BUILD_CC_FILE_PATH)
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx &
	$(CUXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass


stream-full: stream-full.o
	$(CUXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


stream-2.o: stream-2.cc stream-2-kernel.cu stream-2.cuh Makefile
stream-2-kernel.o: Makefile stream-2.cuh stream-2-kernel.cu

stream.o: stream.cc stream-kernel.cu Makefile
stream: stream.o stream-kernel.o
	$(CUXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

stream-2: stream-2.o stream-2-kernel.o
	$(CUXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin stream stream-full stream-2
