### LSU EE 4702-1 (Fall 2013), GPU Programming
##
##  Makefile for Homework 3
##
## $Id:$


OPT_FLAGS =

# Uncomment the line below for GPU optimization.
#
# OPT_FLAGS = -G


CUDAPATH = /usr/local/cuda

COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)




CUDUMP = $(CUDAPATH)/bin/cuobjdump
CUXX = $(CUDAPATH)/bin/nvcc
CXX = $(CUXX)

HW3_CC_SRC = hw3.cc
HW3_CC_SRC_SOL = hw3-sol.cc
HW3_CU_SRC = hw3-kernel.cu
HW3_CU_SRC_SOL = hw3-kernel-sol.cu

SRC_FILES = $(HW3_CC_SRC)
CU_SRC_FILES = $(HW3_CU_SRC)
OBJ_FILES = $(SRC_FILES:.cc=.o) $(CU_SRC_FILES:.cu=.o)

SRC_FILES_SOL = $(HW3_CC_SRC_SOL)
OBJ_FILES_SOL = $(SRC_FILES_SOL:.cc=.o) $(HW3_CU_SRC_SOL:.cu=.o)

.SUFFIXES: .cu .cuh

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

CUFLAGS = -g -Xcompiler -Wall -Xcompiler -Wno-unused-function \
  $(INCLUDE) $(MAGICKCXX) $(OPT_FLAGS) \
 -Xcompiler -Wno-parentheses \
 -use_fast_math --gpu-architecture=sm_20

PTXASFLAGS = -Xptxas --warn-on-local-memory-usage \
 -Xptxas --warn-on-spills  \
  --verbose 

LINKFLAGS =

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: hw3 hw3-sol


INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

# Include dependencies that were created by %.d rule.
#
ifneq ($(MAKECMDGOALS),clean)
-include $(SRC_FILES:.cc=.d) $(CU_SRC_FILES:.cu=.d)
-include $(SRC_FILES_SOL:.cc=.d) $(HW3_CU_SRC_SOL:.cu=.d)
endif

# Prepare file holding dependencies, to be included in this file.
#
%.d: %.cc
	@set -e; rm -f $@; \
         $(CXX) -M $(CUFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.d: %.cu
	@set -e; rm -f $@; \
         $(CUXX) -M $(CUFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.o: %.cc Makefile $(INCLUDES)
	$(CXX) $(CUFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) --source-in-ptx -ptx $*.cu -o $*.ptx
	$(CUXX) $(CUFLAGS) $(PTXASFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) -sass $*.cubin > $*.sass


hw3: $(OBJ_FILES)
	$(CUXX) $(CUFLAGS) $(OBJ_FILES)  $(LINKFLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 

hw3-sol: $(OBJ_FILES_SOL)
	$(CUXX) $(CUFLAGS) $(OBJ_FILES_SOL)  $(LINKFLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 


clean:
	/bin/rm -f hw3 hw3-debug *.d *.o *~ hw3-sol hw3-sol-debug *.sass *.ptx *.cubin hw3-sol

