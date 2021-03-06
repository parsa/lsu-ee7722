### LSU EE 7722 (Spring 2017), GPU Microarchitecture
##
##  Makefile for Homework 2
##

SRC_FILES = hw02.cu hw02-sol.cu

.PHONY: default
default: hw02 hw02-sol

GP_ROOT =  ../../../..

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-line-info --print-code 
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include

ASM_WSRC = $(GP_ROOT)/util/asm-w-src

GPU_GET_PATH = $(GP_ROOT)/util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))

# Optimization Flag (Omitted from debug builds by make rules.)
#
OPT_FLAG = -O3

# Recognized both by nvcc and g++
#
IDENTICAL_FLAGS = -g $(INCLUDE)

# Used both by nvcc and g++, but requires an -Xcompiler prefix for nvcc
#
COMMON_FLAGS = -Wall -Wno-parentheses -fopenmp -march=native

# Used only by nvcc.
#
CUCC_ONLY_FLAGS = -std c++11 --ptxas-options=-v  --gpu-architecture=$(GPU_ARCH)

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++11


COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)
CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)

LIBRARIES = -lrt -lpthread  -lcuda -lnvidia-ml

default: hw02

$(BUILD_CC_FILE_PATH):
	;

# Include dependencies that were created by %.d rules.
#
ifneq ($(MAKECMDGOALS),clean)
-include $(SRC_FILES:=.d)
endif

# Prepare file holding dependencies, to be included in this file.
#
%.cc.d: %.cc
	@set -e; rm -f $@; \
         $(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.cu.d: %.cu
	@set -e; rm -f $@; \
         $(CUCC) -M $(CUFLAGS) $< > $@.$$$$; \
         sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
         rm -f $@.$$$$

%.o: %.cc Makefile
	$(CXX) $(CXXFLAGS) $(OPT_FLAG) -S $*.cc \
	  -fverbose-asm -o - | $(ASM_WSRC) > $*.s
	$(CXX) $(CXXFLAGS) -c $*.s
	$(CXX) $(CXXFLAGS) -c $*.cc -o $*-debug.o

%.o: %.cu Makefile $(BUILD_CC_FILE_PATH)
	$(CUCC) $(CUFLAGS) -c $*.cu -o $*-debug.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -c $*.cu
	$(CUCC) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUCC) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

hw02 hw02-sol:%: %.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)


clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin hw02 hw02-debug hw02-sol *.s \
	build-cc hw02-sol-debug \
	*.d *.d.[0-9][0-9][0-9][0-9][0-9]
