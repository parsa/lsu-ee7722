
COURSE_INCLUDE_DIR = ../../include
CUDAPATH = /usr/local/cuda

INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  -I$(COURSE_INCLUDE_DIR)
LIBDIR  =
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

COMPILERFLAGS = -O3  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS) $(MAGICKCXX)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)

SRC_FILES = boxes.cc cuda-data.cc cuda-sched.cc \
	phys.cc phys-obj-tile.cc phys-obj-box.cc phys-obj-ball.cc \
	phys-contact.cc phys-resolve.cc \
	gra-platform.cc gra-shapes.cc gra-alhazan.cc \
	scene-setup.cc \
	render.cc

CU_SRC_FILE = k-main.cu

OBJ_FILES = $(SRC_FILES:.cc=.o) $(CU_SRC_FILE:.cu=.o) 

default: boxes

# Include dependencies that were created by %.d rule.
#
include $(SRC_FILES:.cc=.d) $(CU_SRC_FILE:.cu=.d)

# Prepare file holding dependencies, to be included in this file.
#
%.d: %.cc
	@set -e; rm -f $@; \
         $(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.d: %.cu
	@set -e; rm -f $@; \
         $(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.o: %.cc Makefile
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CXX) $(CFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CFLAGS) --compile $*.cu


boxes: $(OBJ_FILES)
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

clean:
	rm -f *.d *.o *.ptx *.sass *.cubin *~
