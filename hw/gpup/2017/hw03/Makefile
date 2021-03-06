### LSU EE 4702-1 (Fall 2017), GPU Programming
##
##  Makefile for Homework 3
##

GP_ROOT =  ../../../..

.PHONY:  clean
default: hw03 hw03-sol

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code
# --print-line-info
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include

ASM_WSRC = $(GP_ROOT)/util/asm-w-src
GPU_GET_PATH = $(GP_ROOT)/util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))
DHASH := $(shell $(GPU_GET_PATH) -dhash)

# Optimization Flag (Omitted from debug builds by make rules.)
#
OPT_FLAG = -O3

# Recognized both by nvcc and g++
#
IDENTICAL_FLAGS = -g $(INCLUDE)

# Used both by nvcc and g++, but requires an -Xcompiler prefix for nvcc
#
COMMON_FLAGS = -Wall -Wno-parentheses  -fopenmp

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++11 $(shell Magick++-config --cppflags --cxxflags)

COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)

CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)

SRC_FILES = hw03.cc
all := hw03 hw03-sol


$(BUILD_CC_FILE_PATH):
	;

# Include dependencies that were created by %.d rules.
#
ifneq ($(MAKECMDGOALS),clean)
-include $(SRC_FILES:=.$(DHASH))
endif

# Prepare file holding dependencies, to be included in this file.
#
%.cc.$(DHASH): %.cc
	@set -e; rm -f $@; \
	 $(CXX) -M $(CXXFLAGS) $< > $@.$$$$; \
	 sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	 rm -f $@.$$$$

%.o: %.cc Makefile $(BUILD_CC_FILE_PATH)
	$(CXX) $(CXXFLAGS) $(OPT_FLAG) -S $*.cc \
	  -fverbose-asm -o - | $(ASM_WSRC) > $*.s
	$(CXX) $(CXXFLAGS) -c $*.s
	$(CXX) $(CXXFLAGS) -c $*.cc -o $*-debug.o

$(all):%: %.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)

clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin \
	$(all) $(all:=-debug) *.s *.d *.d.[0-9][0-9][0-9][0-9][0-9] \
	*.d.[0-9][0-9][0-9][0-9]
