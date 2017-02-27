
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
	-Xcompiler -fopenmp -Xcompiler -O3 -Xcompiler -march=native -lineinfo

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

all= vtx-xform vtx-xform-better vtx-xform-sum vtx-xform-omp \
 vtx-xform-local vtx-xform-size

TARGETS = vtx-xform vtx-xform-size vtx-xform-sum	\
	  vtx-xform-omp vtx-xform-better

default: $(TARGETS)

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  -std=c++11
CUFLAGS = $(CFLAGS) -std c++11

LIBRARIES = -lrt -lpthread -lcuda -lnvidia-ml

$(BUILD_CC_FILE_PATH):
	;

%.o: %.cc Makefile
	$(CXX) $(CFLAGS) -s $*.cc
	$(CXX) $(CFLAGS) -c $*.s

%.o: %.cu Makefile util.h $(BUILD_CC_FILE_PATH)
	$(CXX) $(CUFLAGS) -c $*.cu
	$(CXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx &
	$(CXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

$(all):%: %.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)


clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin $(all)
