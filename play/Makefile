INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include  -I../include
LIBDIR  =

CUDAPATH = /usr/local/cuda-4.2
CUDAPATH = /usr/local/cuda
CUDUMP = $(CUDAPATH)/bin/cuobjdump

# -Xnvopencc -LIST:source=on

# --use_fast_math  bug:
#   Execution problem occurs with --use_fast_math and certain data placement.

COMPILERFLAGS = -deviceemu -Xcompiler -Wall -G -Xcompiler -g  --ptxas-options=-v
COMPILERFLAGS = -O3  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses --cudafe-options=-no-restrict \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20

COMPILERFLAGS = -g  -Xcompiler -Wall -Xcompiler -Wno-unused-function \
 -Xcompiler -Wno-parentheses \
 --ptxas-options=-v  -use_fast_math --gpu-architecture=sm_20


CC = gcc
CXX = $(CUDAPATH)/bin/nvcc

.SUFFIXES: .cu .cuh

CFLAGS = $(COMPILERFLAGS) $(INCLUDE) -g  -Xcompiler -Wno-strict-aliasing
CXXFLAGS = $(CFLAGS)  $(shell Magick++-config --cppflags --cxxflags)
CXXFLAGS = $(CFLAGS) -I/usr/include/ImageMagick
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt \
  $(shell Magick++-config --ldflags --libs)


default: demo-x-collide

.cc.o:
	$(CXX) $(CXXFLAGS) -c $*.cc

.cu.o:
	$(CXX) $(CFLAGS) --ptx $*.cu -o $*.ptx && \
	$(CXX) $(CFLAGS) --cubin $*.ptx -o $*.cubin && \
	$(CUDUMP) -sass $*.cubin > $*.sass &
	$(CXX) $(CFLAGS) --compile $*.cu

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
	# cgc -profile vp40 -oglsl -entry vs_main_circle -o cube4_vshader.s \
	 # cube4_vshader.cc
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

demo-x-collide.o: Makefile ../include/coord.h ../include/util.h
demo-x-collide.o: ../include/cuda-util.h  ../include/shader.h 
demo-x-collide.o: demo-x-collide.cc shapes.h demo-x-kernel.cu demo-x.cuh
demo-x-collide.o: tiles.h boxes.h

demo-x-kernel.o: Makefile demo-x.cuh demo-x-kernel.cu demo-x-collide.cc
demo-x-kernel.o: demo-x-boxes.cu ../include/cuda-util-kernel.h

demo-x-collide: demo-x-collide.o demo-x-kernel.o
	$(CXX) $(COMPILERFLAGS) -o $@ $(LIBDIR) $^ $(LIBRARIES) 

