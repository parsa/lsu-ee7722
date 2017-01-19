
INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  \
  -I../include -I../../include

CUDAPATH = /usr/local/cuda

# -Xnvopencc -LIST:source=on

GPU_GET_PATH = ../../util/gpu-get-cc

.PHONY: default
default: balls

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))
build-cc:  # Let make know that build-cc now exists, though not by this rule.
	;


COMPILERFLAGS = -Xcompiler -Wall --ptxas-options=-v \
   -Xcompiler -Wno-unused-function -use_fast_math
OPTFLAGS = -O3

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc 

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Xcompiler -Wno-strict-aliasing \
  -Xcompiler -Wno-parentheses 

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CXXFLAGS = $(CFLAGS)  $(MAGICKCXX) -std=c++11 --gpu-architecture=$(GPU_ARCH)
CUFLAGS = $(CFLAGS) -Xcompiler -std=gnu++98 --gpu-architecture=$(GPU_ARCH)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs) -lnvidia-ml -lcuda


.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu build-cc
	$(CXX) $(CUFLAGS) -c $*.cu

# balls.o: demo-x-kernel.cu demo-x.cuh
balls-kernel.o: Makefile balls.cuh balls-kernel.cu


balls: balls.cc shapes.h tiles.h Makefile balls.cuh balls-kernel.o
	$(CXX) $(CXXFLAGS) $(OPTFLAGS) $@.cc balls-kernel.o -o $@ $(LIBRARIES)
	$(CXX) $(CXXFLAGS) $@.cc -o $@-debug balls-kernel.o $(LIBRARIES)


clean:
	/bin/rm -f build-cc  *.o *~ *.sass *.cubin *.ptx balls balls-debug

