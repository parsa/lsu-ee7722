
PGIPATH = /opt/pgi/linux86-64/16.10


GXX = g++
PXX = $(PGIPATH)/bin/pgc++

GP_ROOT =  ../..


CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code
# --print-line-info
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide

CUCC = $(CUDAPATH)/bin/nvcc
CXX = g++

INCLUDE =  -I$(GP_ROOT)/include  -I$(CUDAPATH)/include \
	-I$(PGIPATH)/etc/include_acc

ASM_WSRC = $(GP_ROOT)/util/asm-w-src
GPU_GET_PATH = $(GP_ROOT)/util/gpu-get-cc

BUILD_CC_FILE_PATH = $(CURDIR)/build-cc
DUMMY := $(shell  $(MAKE) -C $(dir $(GPU_GET_PATH)))
GPU_ARCH := $(shell $(GPU_GET_PATH) $(BUILD_CC_FILE_PATH))
GPU_ARCHP := $(subst sm_,cc,$(GPU_ARCH))

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
CUCC_ONLY_FLAGS = -std c++11 --gpu-architecture=$(GPU_ARCH) \
   --ptxas-options=-v -lineinfo

# Used only by g++
#
CXX_ONLY_FLAGS = -std=c++11

COMMON_FLAGS_PREFIXED = $(COMMON_FLAGS:%=-Xcompiler %)

CXXFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS) $(CXX_ONLY_FLAGS)
CUFLAGS = $(IDENTICAL_FLAGS) $(COMMON_FLAGS_PREFIXED) $(CUCC_ONLY_FLAGS)

LIBRARIES = -lrt -lpthread -lcuda -lnvidia-ml -ldl

PCFLAGS = $(INCLUDE) -g \
 -acc -ta=tesla:$(GPU_ARCHP),nordc,keep \
 -Minfo -Mneginfo -Msafeptr -Mkeepasm -O4 -fast


ACCLIBRARIES =  -L/opt/pgi/linux86-64/16.10/lib \
  -Xlinker -rpath=/opt/pgi/linux86-64/16.10/lib \
 -laccapi -laccg -laccn -laccg2 -lcudadevice -lpgatm  -lpgc -lpgmp -lnuma

# /opt/pgi/linux86-64/2016/cuda/8.0/bin/nvlink --arch=sm_60 -m64
 # -L/usr/local/cuda/lib64
 # -L/usr/lib64 -L/usr/lib/gcc/x86_64-redhat-linux/6.3.1 -L/usr/lib/gcc/x86_64-redhat-linux/6.3.1/../../../../lib64 /usr/lib64/crt1.o /usr/lib64/crti.o

# /opt/pgi/linux86-64/16.10/lib/trace_init.o
# /usr/lib/gcc/x86_64-redhat-linux/6.3.1/crtbegin.o
# /opt/pgi/linux86-64/16.10/lib/initmp.o

todo= vtx-xform vtx-xform-better vtx-xform-sum vtx-xform-omp \
 vtx-xform-local vtx-xform-size vtx-xform-s2

SRC_FILES = $(todo:=.cu)

TARGETS = vtx-xform vtx-xform-size vtx-xform-sum	\
	  vtx-xform-omp vtx-xform-better vtx-xform-s2


# /opt/pgi/linux86-64/16.10/lib/acc_init_link_cuda.o
 # -laccapi -laccg
# -laccn -laccg2 -ldl -lcudadevice -lpgatm -lstdc++ -lpgmp -lnuma
# -lpthread -lnspgc -lpgc -lm -lgcc -lc -lgcc -lgcc_s
# /usr/lib/gcc/x86_64-redhat-linux/6.3.1/crtend.o /usr/lib64/crtn.o

FLAGS_FOR_PGI_LINKING_CUDART_PGI = -L$(CUDAPATH)/lib64 -lcudart

FLAGS_FOR_GCC_LINKING_CUDART_PGI = -L$(CUDAPATH)/lib64 -lcudart $(ACCLIBRARIES) 


default: vtx-xform-s2
#default: vtx-xform-size-oa
#default: $(TARGETS)

PGI_SRC = vtx-xform-s2-acc.cc vtx-xform-size-acc.cc
PGI_OBJ = $(PGI_SRC:.cc=.o)

SRCS_S2_LINK = vtx-xform-s2.o vtx-xform-s2-main.o 
SRCS_S2 = $(SRCS_S2_LINK) vtx-xform-s2-acc.o 
$(SRCS_S2): vtx-xform-s2.h
vtx-xform-s2: $(SRCS_S2)
	$(GXX) $(CXXFLAGS)  -o $@ $(SRCS_S2_LINK) $(LIBRARIES) \
	$(FLAGS_FOR_GCC_LINKING_CUDART_PGI)

all: vtx-xform vtx-xform-better vtx-xform-sum vtx-xform-omp \
 vtx-xform-local vtx-xform-sum


HAVE_PGI:
	$(PXX) -V

vtx-xform-s2-acc.o: vtx-xform-s2-acc.cc Makefile | HAVE_PGI
	$(PXX) $(PCFLAGS) -fPIC -c $<
	ld -shared -o $*.so $@
	$(CUDUMP) $(CUDUMPFLAGS) vtx-xform-s2-acc.n001.bin > vtx-xform-s2-acc.n001.sass
#	ar r vtx-xform-s2.so $*.so




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
	$(CUCC) $(CUFLAGS) -cubin $*.ptx -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

$(all):%: %.o
	$(CUCC) $(CUFLAGS) $(OPT_FLAG) -o $@ $^ $(LIBRARIES)
	$(CUCC) $(CUFLAGS) -o $@-debug $(^:.o=-debug.o) $(LIBRARIES)

clean:
	/bin/rm -f $(BUILD_CC_FILE_PATH) *.o *.ptx *.sass *.cubin *.d \
	*.bin *.gpu \
	$(all) $(all:=-debug) *.s *.d.[0-9][0-9][0-9][0-9][0-9]

