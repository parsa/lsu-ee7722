### LSU EE 4702-x (Fall 2020)
##
##  Makefile for Homework 3 (Based on Links demo.)
##

GP_ROOT =  ../../../..

.PHONY:  clean
default: hw03 hw03-sol

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include

ASM_WSRC = $(GP_ROOT)/util/asm-w-src
GPU_GET_PATH = $(GP_ROOT)/util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
ifneq ($(MAKECMDGOALS),clean)
  DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
  GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))
  DHASH := $(shell $(GPU_GET_PATH) -dhash)
endif

# Optimization Flag (Omitted from debug builds by make rules.)
#
OPT_FLAG = -O3

# Recognized both by nvcc and g++
#
IDENTICAL_FLAGS = -g $(INCLUDE)

# Used both by nvcc and g++, but requires an -Xcompiler prefix for nvcc
#
COMMON_FLAGS = -Wall -Wno-parentheses  -fopenmp -march=native

# Used only by nvcc.
#
CUCC_ONLY_FLAGS = -std c++17 --gpu-architecture=$(GPU_ARCH)

# Used by the CUDA compiler (ptxas)
#
PTXASFLAGS = -Xptxas --warn-on-local-memory-usage \
	 -Xptxas --warn-on-spills --ptxas-options=-v -lineinfo

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++17 \
	$(shell GraphicsMagick++-config --cppflags --cxxflags)

COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)

CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell GraphicsMagick++-config --ldflags --libs) -lnvidia-ml -lcuda

SRC_FILES = hw03.cc links-kernel.cu
all := hw03

hw03: $(addsuffix .o,$(basename $(SRC_FILES)))

$(BUILD_CC_FILE_PATH):
	;

# Include dependencies that were created by %.d rules.
#
ifneq ($(DHASH),)
-include $(SRC_FILES:=.$(DHASH))
endif

# Prepare file holding dependencies, to be included in this file.
#
%.cc.$(DHASH): %.cc
	@set -e; rm -f $@; \
	 $(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
	 sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	 rm -f $@.$$$$

%.cu.$(DHASH): %.cu
	@set -e; rm -f $@; \
	 $(CUCC) -M $(CUFLAGS) $< > $@.$$$$; \
	 sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	 rm -f $@.$$$$

%.o: %.cc Makefile $(BUILD_CC_FILE_PATH)
	$(CXX) $(CXXFLAGS) $(OPT_FLAG) -S $*.cc \
	  -fverbose-asm -o - | $(ASM_WSRC) > $*.s
	$(CXX) $(CXXFLAGS) -c $*.s
	$(CXX) $(CXXFLAGS) -c $*.cc -o $*-debug.o

%.o: %.cu Makefile $(BUILD_CC_FILE_PATH)
	$(CUCC) $(CUFLAGS) -c $*.cu -o $*-debug.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -c $*.cu
	$(CUCC) $(CUFLAGS) -ptx $*.cu -o $*.ptx &
	$(CUCC) $(CUFLAGS) $(PTXASFLAGS) -cubin $*.cu -o $*.cubin && \
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass &

$(all):%:
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)

hw03-sol: hw03
	ln -f hw03 hw03-sol
	ln -f hw03-debug hw03-sol-debug

clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin \
	$(all) $(all:=-debug) *.s *.d *.d.[0-9][0-9][0-9][0-9][0-9] \
	$(all:=-sol) $(all:=-sol-debug)


