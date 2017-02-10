

default: all
all: thds omp cuda

thds: thds.cc
	g++ $< -o $@ -O3 -Wall -std=c++11 -lpthread

omp: omp.cc
	g++ $< -o $@ -O3 -fopenmp -Wall

cuda: cuda.cu
	nvcc -o $@ $< -O3 -Xcompiler -Wall

clean:
	/bin/rm -f thds omp cuda
