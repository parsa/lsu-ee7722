### LSU EE 4702-x / EE 7722
##
##  Makefile for Links Demo
##

OPT_FLAGS = -O3

# Uncomment the line below for GPU optimization.
#
# OPT_FLAGS = -G


CUDAPATH = /usr/local/cuda

COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR)


CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code 
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

CUXX = $(CUDAPATH)/bin/nvcc

CXX = $(CUXX)

LINKS_CC_SRC = links.cc
LINKS_CU_SRC = links-kernel.cu

SRC_FILES = $(LINKS_CC_SRC)
CU_SRC_FILES = $(LINKS_CU_SRC)
OBJ_FILES = $(SRC_FILES:.cc=.o) $(CU_SRC_FILES:.cu=.o)

.SUFFIXES: .cu .cuh

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))

COMMONFLAGS = -g -Xcompiler -Wall -Xcompiler -Wno-unused-function \
  $(INCLUDE) $(MAGICKCXX) $(OPT_FLAGS) \
 -Xcompiler -Wno-parentheses


CUFLAGS = $(COMMONFLAGS) -Xcompiler --std=gnu++98 \
 -use_fast_math --gpu-architecture=sm_30

CXXFLAGS = $(COMMONFLAGS) -Xcompiler --std=c++11  -Xcompiler -fopenmp

PTXASFLAGS = -Xptxas --warn-on-local-memory-usage \
 -Xptxas --warn-on-spills  \
  --verbose 

LINKFLAGS = -Xcompiler -fopenmp

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 
LIBDIR  =

default: links


INCLUDES_BASE = util.h glextfuncs.h coord.h shader.h pstring.h misc.h \
	        gl-buffer.h texture-util.h 

INCLUDES = $(patsubst %,$(COURSE_INCLUDE_DIR)/%,$(INCLUDES_BASE)) \
	 shapes.h Makefile

# Include dependencies that were created by %.d rule.
#
ifneq ($(MAKECMDGOALS),clean)
-include $(SRC_FILES:.cc=.d) $(CU_SRC_FILES:.cu=.d)
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
	$(CXX) $(CXXFLAGS) -c $*.cc

%.o: %.cu Makefile
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) --source-in-ptx -ptx $*.cu -o $*.ptx
	$(CUXX) $(CUFLAGS) $(PTXASFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass


links: $(OBJ_FILES)
	$(CUXX) $(CUFLAGS) $(OBJ_FILES)  $(LINKFLAGS) \
	-o $@ $(LIBDIR)  $(LIBRARIES) 


clean:
	/bin/rm -f links links-debug *.d *.o *~ *.sass *.ptx *.cubin 

