### LSU EE 4702-x / EE 7722
##
##  Makefile for GPU Utilities
##

OPT_FLAGS = 

CUDAPATH = /usr/local/cuda

COURSE_INCLUDE_DIR_POSSIBILITIES = ../include ../../include ../../../include

FOUND := $(foreach dir, $(COURSE_INCLUDE_DIR_POSSIBILITIES), \
           $(shell test -e $(dir) && echo $(dir)))
COURSE_INCLUDE_DIR := $(firstword $(FOUND))

INCLUDE = -I $(COURSE_INCLUDE_DIR) 

CXX = $(CUDAPATH)/bin/nvcc

SRC_FILES = gpu-get-cc.cc
OBJ_FILES = $(SRC_FILES:.cc=.o)

.SUFFIXES: .cu .cuh

COMMONFLAGS = -g -Xcompiler -Wall -Xcompiler -Wno-unused-function \
  $(INCLUDE) $(OPT_FLAGS) -Xcompiler -Wno-parentheses

CXXFLAGS = $(COMMONFLAGS)

LINKFLAGS = 

LIBRARIES =   -lm  -lrt -lcuda -lnvidia-ml 
LIBDIR  =

.PHONY: gpu-get-cc-force
default: gpu-get-cc-force

%.o: %.cc Makefile
	@ $(CXX) $(CXXFLAGS) -c $*.cc

gpu-get-cc-force: $(OBJ_FILES)
	@ $(CXX) $^ $(CXXFLAGS) $(LINKFLAGS) -o gpu-get-cc $(LIBRARIES)


clean:
	/bin/rm -f gpu-get-cc *.o *~

