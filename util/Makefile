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

SRC_FILE = gpu-get-cc.cc

.SUFFIXES: .cu .cuh

COMMONFLAGS = -g -std=c++11 -Xcompiler -Wall -Xcompiler -Wno-unused-function \
  $(INCLUDE) $(OPT_FLAGS) -Xcompiler -Wno-parentheses --gpu-architecture=sm_35

CXXFLAGS = $(COMMONFLAGS)

LINKFLAGS = 

LIBRARIES =   -lm  -lrt -lcuda -lnvidia-ml 
LIBDIR  =

.PHONY: gpu-get-cc-force
default: gpu-get-cc-force

gpu-get-cc-force:
	@ $(CXX) $ $(CXXFLAGS) $(LINKFLAGS) $(SRC_FILE) -o gpu-get-cc \
	 $(LIBRARIES)



clean:
	/bin/rm -f gpu-get-cc *.o *~

