### LSU EE 4702-X / EE 7722
##
##  Makefile for Spring Project Base
##
## $Id:$


COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)

OPT_FLAGS = -O3

INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h cuda-util.h

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	  Makefile

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump
CXX = $(CUDAPATH)/bin/nvcc

COMPILERFLAGS = -g   -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS) $(MAGICKCXX)

.SUFFIXES: .cu .cuh

LINKFLAGS = $(OPTFLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

SRC_FILES = spring.cc
CU_SRC_FILE = spring-cuda.cu

OBJ_FILES = $(SRC_FILES:.cc=.o) $(CU_SRC_FILE:.cu=.o) 

default: spring


%.o: %.cc $(INCLUDES) Makefile
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CXX) $(CFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CFLAGS) --compile $*.cu

spring-cuda.o: spring.cuh


spring: $(OBJ_FILES)
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


clean:
	/bin/rm -f spring spring-debug *.o *~ *.sass *.cubin *.ptx

