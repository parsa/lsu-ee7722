
DECUDA = /home/faculty/koppel/lbuild/decuda-0.4.2/decuda
INCLUDE = -I../include

LIBDIR  =

COMPILERFLAGS =    -Wall

CXX = g++

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags) 

default:all

all:demo-2-springs demo-1-simple demo-3-balls

.cc.o:
	$(CXX) $(CFLAGS) -c $*.cc

demo-1-simple.o: Makefile ../include/coord.h ../include/util.h ../include/shader.h 
demo-1-simple.o: demo-1-simple.cc

demo-1-simple: demo-1-simple.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 


demo-2-springs.o: Makefile ../include/coord.h ../include/util.h ../include/shader.h 
demo-2-springs.o: demo-2-springs.cc

demo-2-springs: demo-2-springs.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

demo-3-balls.o: Makefile ../include/coord.h ../include/util.h ../include/shader.h 
demo-3-balls.o: demo-3-balls.cc shapes.h
demo-3-balls.o: demo-3-balls.cc

demo-3-balls: demo-3-balls.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

