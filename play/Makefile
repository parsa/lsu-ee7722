INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  -I../include
LIBDIR  =

CUDAPATH = /usr/local/cuda
CUDAPATH2 = /usr/local/cuda-2.3
DECUDA = /home/faculty/koppel/lbuild/decuda-0.4.2/decuda
LNVDIS = /home/faculty/koppel/lbuild/nv50dis/nvdis

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -deviceemu -Xcompiler -Wall -G -Xcompiler -g  --ptxas-options=-v
COMPILERFLAGS = -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 --ptxas-options=-v  -use_fast_math 


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g -O3  -Xcompiler -Wno-strict-aliasing \
  -Xcompiler -Wno-parentheses 

MAGICKCXX_RAW := $(shell Magick++-config --cppflags --cxxflags)
# Remove openmp, which doesn't play well with nvcc.
MAGICKCXX := $(filter-out -fopenmp,$(MAGICKCXX_RAW))
CXXFLAGS = $(CFLAGS)  $(MAGICKCXX)

LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)


default: demo-x-collide cube4

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) -c $*.cu
	$(CXX) $(CFLAGS) -cubin $*.cu -o $*.cubin
	$(CXX) $(CFLAGS) -ptx $*.cu -o $*.ptx

cube6.o: Makefile ../include/coord.h ../include/util.h shader.h 
cube5.o: Makefile coord.h util.h shader.h 

cube5_shader.s: cube5_shader.cc
	echo -profile vp40 -oglsl -entry main_physics -o cube5_shader-physics.s \
	 cube5_shader.cc
	echo -profile vp40 -oglsl -entry main_faces -o cube5_shader-faces.s \
	 cube5_shader.cc

cube6: cube6.o
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube5: cube5.o cube5_shader.s
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube4.o: Makefile coord.h util.h shader.h

cube4: cube4.o cube4_vshader.cc
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

xcube4.o: Makefile coord.h util.h shader.h

xcube4: xcube4.o cube4_vshader.cc
	cgc -profile vp40 -oglsl -entry vs_main_circle -o cube4_vshader.s \
	 cube4_vshader.cc
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube3: cube3.o
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube2: cube2.o
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube: cube.o
	$(CC) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

demo-x-collide.o: Makefile ../include/coord.h ../include/util.h ../include/shader.h 
demo-x-collide.o: demo-x-collide.cc shapes.h demo-x-kernel.cu demo-x.cuh
demo-x-collide.o: tiles.h boxes.h

demo-x-kernel.o: Makefile demo-x.cuh demo-x-kernel.cu demo-x-collide.cc

demo-x-collide: demo-x-collide.o demo-x-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

