### LSU EE 4702-1 (Fall 2020), GPU Programming
##
##  Makefile for Classroom Demos
##

GP_ROOT =  ..

.PHONY: ALL_TARGETS clean
default: ALL_TARGETS

CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code  --print-line-info
# --print-line-info
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include

ASM_WSRC = $(GP_ROOT)/util/asm-w-src
SASS_FILTER = $(GP_ROOT)/util/sass-filter --show-source-code
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
CUCC_ONLY_FLAGS = -std c++17 --gpu-architecture=$(GPU_ARCH) -lineinfo

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++17 \
 $(shell GraphicsMagick++-config --cppflags --cxxflags)

COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)

CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)

LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell GraphicsMagick++-config --libs) -lnvidia-ml -lcuda

ALL_MAIN = demo-1-simple.cc \
    demo-1c-coord.cc demo-2-springs.cc demo-3-balls.cc \
    demo-4-simple-ogl.cc demo-5-more-ogl.cc demo-6-lighting.cc \
    demo-7-vtx-arrays.cc demo-8-texture.cc demo-9-shader.cc \
    demo-1d-objects.cc demo-10-shader.cc demo-11-a-comp-shader.cc \
    demo-cuda-01-simple.cu demo-cuda-02-basics.cu \
    demo-cuda-03-shared-mem.cu demo-cuda-04-acc-pat.cc demo-0-coor.cc

SRC_FILES = $(ALL_MAIN) demo-cuda-04-acc-pat-cuda.cu

all := $(basename $(ALL_MAIN))

demo-cuda-04-acc-pat: demo-cuda-04-acc-pat-cuda.o

ALL_TARGETS: $(all)

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
	$(CUCC) $(CUFLAGS) -ptx $*.cu -o $*.ptx
	$(CUCC) $(CUFLAGS) -lineinfo -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin | $(SASS_FILTER) > $*.sass

$(all):%: %.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)

clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin *.d \
	$(filter-out demo-1-simple,$(all)) $(all:=-debug) *.s *.html \
	*.d.[0-9][0-9][0-9][0-9] *.d.[0-9][0-9][0-9][0-9][0-9]


