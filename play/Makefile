INCLUDE = -I/usr/X11R6/include/ -I/opt/local/include
LIBDIR  = -L/usr/X11R6/lib
LIBDIR  =

COMPILERFLAGS = -Wall
CC = gcc
CXX = g++
CFLAGS = $(COMPILERFLAGS) $(INCLUDE)  -g -fverbose-asm -O3
CXXFLAGS = $(CFLAGS)
LIBRARIES =  -lX11 -lXi -lXmu  -lglut -lGL -lGLU -lm -lpthread  -lXxf86vm -lrt
LIBRARIES =  -lX11 -lXi -lglut -lGL -lGLU -lm -lpthread  -lrt


default:cube5

.cc.o:
	$(CXX) $(CFLAGS) -S $*.cc
	$(CXX) $(CFLAGS) -c $*.s

cube5.o: Makefile coord.h util.h shader.h 

cube5_shader.s: cube5_shader.cc
	cgc -profile vp40 -oglsl -entry main_physics -o cube5_shader-physics.s \
	 cube5_shader.cc
	cgc -profile vp40 -oglsl -entry main_faces -o cube5_shader-faces.s \
	 cube5_shader.cc

cube5: cube5.o cube5_shader.s
	$(CXX) $(CFLAGS) -o $@ $(LIBDIR) $< $(LIBRARIES)

cube4.o: Makefile coord.h util.h shader.h

cube4: cube4.o cube4_vshader.cc
	cgc -profile vp40 -oglsl -entry vs_main_circle -o cube4_vshader.s \
	 cube4_vshader.cc
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
