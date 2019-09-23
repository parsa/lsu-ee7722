### LSU EE 7700-1 (Sp 2010), GPU Microarchitecture
##
##  Makefile for cpu-only demo programs.
##
##

GP_ROOT =  ..
COURSE_INCLUDE_DIR = $(GP_ROOT)/include

INCLUDE = -I$(COURSE_INCLUDE_DIR)

PROG_NAMES = simple demo-1-one-triangle demo-2-many-triangles \
 demo-3-color-and-z-buffering demo-4-lighting demo-5-textures

CFLAGSMAGIK_MAYBE := $(shell GraphicsMagick++-config --cppflags --cxxflags)
LDFLAGSMAGIK := $(shell GraphicsMagick++-config  --libs)
ifeq ($(CFLAGSMAGIK_MAYBE),)
CFLAGSMAGIK :=
else
CFLAGSMAGIK := $(CFLAGSMAGIK_MAYBE) -DMAGICK
endif

ASM_WSRC = $(GP_ROOT)/util/asm-w-src

default: $(PROG_NAMES)

CXXFLAGS = -std=c++11 -g3 -march=native -Wall -fopenmp
CXXFLAGS +=  $(INCLUDE) $(CFLAGSMAGIK)

CXX = g++
LIBRARIES =  -lX11 -lglut -lGL -lGLU -lm -lpthread  -lrt $(LDFLAGSMAGIK)

OBJ_NAMES = $(PROG_NAMES:=.o)

$(OBJ_NAMES): frame_buffer.h coord.h Makefile $(COURSE_INCLUDE_DIR)/misc.h

$(PROG_NAMES): %: %.o Makefile
	$(CXX) $(CXXFLAGS) -o $@ $< $(LIBRARIES)

%.o: %.cc Makefile
	$(CXX) $(CXXFLAGS) -fverbose-asm -S $*.cc -o - | $(ASM_WSRC) > $*.s
	$(CXX) $(CXXFLAGS) -c $*.s

clean:
	/bin/rm -f *.s  *.o *~ *.sass *.cubin *.ptx *.html $(PROG_NAMES)

