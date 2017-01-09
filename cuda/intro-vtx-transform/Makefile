INCLUDE =  -I../../include
LIBDIR  =

CUDAPATH = /usr/local/cuda

CC = gcc
CUXX = $(CUDAPATH)/bin/nvcc
GXX = g++
PXX = pgc++

CUDUMP = $(CUDAPATH)/bin/nvdisasm
CUDUMPFLAGS = --print-code
# --print-line-info
# --print-instruction-encoding
# --print-life-ranges --life-range-mode wide


CFLAGS_GCC = -Wall -Wno-unused-function -Wno-strict-aliasing \
	-fopenmp -O3 -g
CFLAGS_COMMON_NVCC_TRAN = $(foreach f,$(CFLAGS_GCC),-Xcompiler $f)

CFLAGS_COMMON_NVCC_REC = -std=c++11 $(INCLUDE)

CFLAGS = $(CFLAGS_COMMON_NVCC_REC) $(CFLAGS_GCC) -I$(CUDAPATH)/include

CUFLAGS = $(CFLAGS_COMMON_NVCC_REC) $(CFLAGS_COMMON_NVCC_TRAN) \
 -Xcompiler -std=gnu++98 \
 --ptxas-options=-v  --gpu-architecture=sm_30 -lineinfo

PCFLAGS = $(INCLUDE) $(CFLAGS_COMMON_NVCC_REC) \
 -acc -ta=tesla:cc30,nordc,keep -Minfo -Mneginfo -Msafeptr -Mkeepasm -O4 -fast


.SUFFIXES: .cu .cuh

TARGETS = vtx-xform vtx-xform-size vtx-xform-sum	\
	  vtx-xform-omp vtx-xform-better vtx-xform-s2


LIBRARIES = -lrt -lpthread
ACCLIBRARIES =  -L/opt/pgi/linux86-64/16.10/lib \
  -Xlinker -rpath=/opt/pgi/linux86-64/16.10/lib \
 -laccapi -laccg -laccn -laccg2 -lcudadevice -lpgatm -lpthread -lnspgc -lpgc -lpgmp -lnuma


# /opt/pgi/linux86-64/2016/cuda/8.0/bin/nvlink --arch=sm_60 -m64
 # -L/usr/local/cuda/lib64
 # -L/usr/lib64 -L/usr/lib/gcc/x86_64-redhat-linux/6.3.1 -L/usr/lib/gcc/x86_64-redhat-linux/6.3.1/../../../../lib64 /usr/lib64/crt1.o /usr/lib64/crti.o

# /opt/pgi/linux86-64/16.10/lib/trace_init.o
# /usr/lib/gcc/x86_64-redhat-linux/6.3.1/crtbegin.o
# /opt/pgi/linux86-64/16.10/lib/initmp.o

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

vtx-xform-s2: vtx-xform-s2.o vtx-xform-s2-acc.o vtx-xform-s2-main.o
	$(GXX) $(CFLAGS)  -o $@ $(LIBDIR) $^ $(LIBRARIES) \
	$(FLAGS_FOR_GCC_LINKING_CUDART_PGI)

all: vtx-xform vtx-xform-better vtx-xform-sum vtx-xform-omp \
 vtx-xform-local vtx-xform-sum

vtx-xform-size-oa: vtx-xform-size-oa.cc vtx-xform-size-oa.h vtx-xform-size-acc.o Makefile
	$(PXX) $(PCFLAGS) $@.cc -o $@ vtx-xform-size-acc.o -L $(CUDAPATH)/lib64 -lcudart

HAVE_PGI:
	$(PXX) -V

$(PGI_OBJ): %.o: %.cc  Makefile vtx-xform-s2.h | HAVE_PGI
	$(PXX) $(PCFLAGS) -c $*.cc

%.o: %.cc Makefile
	$(GXX) $(CFLAGS) -S $*.cc
	$(GXX) $(CFLAGS) -c $*.s

%.o: %.cu Makefile util.h
	$(CUXX) $(CUFLAGS) -c $*.cu
	$(CUXX) $(CUFLAGS) -ptx $*.cu -o $*.ptx &
	$(CUXX) $(CUFLAGS) -cubin $*.cu -o $*.cubin
	$(CUDUMP) $(CUDUMPFLAGS) $*.cubin > $*.sass

%: %.o
	$(CUXX) $(CUFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES)


clean:
	/bin/rm -f *.o *.ptx *.sass *.bin *.gpu *.s *.cubin $(TARGETS)
