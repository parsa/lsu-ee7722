### LSU EE 4702-1 (Fall 2016), GPU Programming
##
##  Makefile for Homework 7
##

SRC_FILES = hw07.cc hw07-cuda.cu hw07-cuda-sol.cu

.PHONY: default
default: hw07 hw07-sol

hw07: hw07.o hw07-cuda.o
hw07-sol: hw07.o hw07-cuda-sol.o

GP_ROOT =  ../../../..

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-line-info --print-code 
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include
LIBRARIES = -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt -lnvidia-ml \
	 $(shell Magick++-config --ldflags)

# Include the course libraries. So far a CUPTI interface.
#
DUMMY:= $(shell $(MAKE) -C $(GP_ROOT)/lib)
LIBRARIES += $(shell $(GP_ROOT)/lib/ld-flags)
INCLUDE += -I$(GP_ROOT)/lib

ASM_WSRC = $(GP_ROOT)/util/asm-w-src
GPU_GET_PATH = $(GP_ROOT)/util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))

# Optimization Flag (Omitted from debug builds by make rules.)
#
OPT_FLAG = -O3

## CUDA Debug Flags
#
CUDA_DEBUG_FLAGS = -G -lineinfo -D__P_CUDA_DEBUG__

# Recognized both by nvcc and g++
#
IDENTICAL_FLAGS = -g $(INCLUDE)

# Used both by nvcc and g++, but requires an -Xcompiler prefix for nvcc
#
COMMON_FLAGS = -Wall -Wno-parentheses -fopenmp -march=native

# Used only by nvcc.
#
CUCC_ONLY_FLAGS = -std c++11 --ptxas-options=-v \
  --gpu-architecture=$(GPU_ARCH)

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++11 $(shell Magick++-config --cppflags --cxxflags)


COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)
CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)

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
	ln -fs $*-debug.o $*-cu-debug.o

%.o: %.cu Makefile $(BUILD_CC_FILE_PATH)
	$(CUCC) $(CUFLAGS) $(CUDA_DEBUG_FLAGS) -c $*.cu -o $*-cu-debug.o
	$(CUCC) $(CUFLAGS) -c $*.cu -o $*-debug.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -c $*.cu
	$(CUCC) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUCC) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

hw07 hw07-sol:%:
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)
	$(CUCC) $(CUFLAGS) $(CUDA_DEBUG_FLAGS) -o $@-cu-debug \
	  $(^:.o=-cu-debug.o) $(LIBRARIES)

clean:
	/bin/rm -f *.o *.ptx *.sass *.cubin hw07 hw07-debug hw07-sol *.s \
	hw07-cu-debug hw07-sol-cu-debug hw07-sol-debug \
	build-cc \
	*.d *.d.[0-9][0-9][0-9][0-9][0-9] *.d *.d.[0-9][0-9][0-9][0-9]

