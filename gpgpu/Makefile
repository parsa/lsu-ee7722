
CUDAPATH = /usr/local/cuda
GPINCLUDE = -I../include

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

# Flags for c++ compiler only.
#
CCFLAGS =  $(shell Magick++-config --cxxflags) -Wall \
	-Wno-strict-aliasing -Wno-parentheses \
	-I $(CUDAPATH)/include

# Flags that should be passed to both nvcc and the c++ compiler.
#
NVCCCCFLAGS = -O3 -g  $(GPINCLUDE)

# Flags recognized only by nvcc.
#
NVCCFLAGS =  --ptxas-options=-v

NVCC = $(CUDAPATH)/bin/nvcc
CXX = g++

.SUFFIXES: .cu .cuh

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 


default:balloon

.cc.o:
	$(CXX) $(CCFLAGS) $(NVCCCCFLAGS) -c $*.cc

.cu.o:
	$(NVCC) $(NVCCFLAGS) $(NVCCCCFLAGS) -c $*.cu

balloon.o: Makefile ../include/coord.h ../include/util.h ../include/shader.h 
balloon.o: balloon.cuh balloon.cc

balloon-kernel.o: Makefile balloon.cuh balloon-kernel.cu

balloon: balloon-kernel.o balloon.o
	$(NVCC) $(NVCCFLAGS) $(NVCCCCFLAGS) -o $@ $^ $(LIBRARIES) 

clean:
	/bin/rm -f *.o *.cubin *.ptx
