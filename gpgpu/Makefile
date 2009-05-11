
CUDAPATH = /usr/local/cuda
INCLUDE =

LIBDIR  =

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -deviceemu -Xcompiler -Wall --keep  --ptxas-options=-v
COMPILERFLAGS =  -O3 -Xcompiler -Wall --keep --ptxas-options=-v
#COMPILERFLAGS =   -Xcompiler -Wall --keep --ptxas-options=-v

CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 


default:balloon

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) -c $*.cu
#	~/lbuild/decuda-0.4.2/decuda -p -o $*.cubin.ptx $*.sm_10.cubin 

balloon.o: Makefile ../opengl/coord.h ../opengl/util.h ../opengl/shader.h 
balloon.o: balloon.cuh balloon.cc

balloon-kernel.o: Makefile balloon.cuh balloon-kernel.cu

balloon: balloon-kernel.o balloon.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

