
GP_ROOT =  ../..


CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code --print-line-info
# --print-line-info 
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include
LIBRARIES = -lrt -lpthread -lcuda -lnvidia-ml

# Include the course libraries. So far a CUPTI interface.
#
ifneq ($(MAKECMDGOALS),clean)
  DUMMY:= $(shell $(MAKE) -C $(GP_ROOT)/lib)
  LIBRARIES += $(shell $(GP_ROOT)/lib/ld-flags)
endif
INCLUDE += -I$(GP_ROOT)/lib


ASM_WSRC = $(GP_ROOT)/util/asm-w-src
SASS_FILTER = $(GP_ROOT)/util/sass-filter
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
CUCC_ONLY_FLAGS = -std c++14 --gpu-architecture=$(GPU_ARCH)

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++14

COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)

CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)


all= mb

SRC_FILES = $(all:=.cu)

TARGETS = mb

default: $(TARGETS)


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

%.o: %.cc Makefile
	$(CXX) $(CXXFLAGS) $(OPT_FLAG) -S $*.cc \
	  -fverbose-asm -o - | $(ASM_WSRC) > $*.s
	$(CXX) $(CXXFLAGS) -c $*.s
	$(CXX) $(CXXFLAGS) -c $*.cc -o $*-debug.o

%.o: %.cu Makefile $(BUILD_CC_FILE_PATH)
	$(CUCC) $(CUFLAGS) -c $*.cu -o $*-debug.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -c $*.cu
	$(CUCC) $(CUFLAGS) -ptx $*.cu -o $*.ptx &
	$(CUCC) $(CUFLAGS) -lineinfo -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin | $(SASS_FILTER) > $*.sass

$(all):%: %.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)

clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin *.d \
	$(all) $(all:=-debug) *.s *.d.[0-9][0-9][0-9][0-9][0-9] \
	 *.d.[0-9][0-9][0-9][0-9][0-9][0-9] *.d.[0-9][0-9][0-9][0-9]
