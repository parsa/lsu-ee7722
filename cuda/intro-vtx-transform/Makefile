
INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda

CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code 
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  --gpu-architecture=sm_30  -g  \
	-Xcompiler -fopenmp -Xcompiler -O3 -lineinfo


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

TARGETS = vtx-xform vtx-xform-size vtx-xform-sum	\
	  vtx-xform-omp vtx-xform-better


CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)
LIBRARIES = -lrt -lpthread 

#default: vtx-xform
default: $(TARGETS)

all: vtx-xform vtx-xform-better vtx-xform-sum vtx-xform-omp \
 vtx-xform-local vtx-xform-sum


%.o: %.cc Makefile
	$(CXX) $(CFLAGS) -s $*.cc
	$(CXX) $(CFLAGS) -c $*.s

%.o: %.cu Makefile
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx &
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

%: %.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)


clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin $(TARGETS)
