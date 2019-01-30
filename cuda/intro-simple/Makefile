

default: all
all: thds omp cuda

thds: thds.cc Makefile
	g++ $< -o $@ -O3 -march=native -Wall -std=c++11 -lpthread

omp: omp.cc Makefile
	g++ $< -o $@ -O3 -march=native -fopenmp -Wall

cuda: cuda.cu Makefile
	nvcc -o $@ $< -O3 -Xcompiler -Wall

clean:
	/bin/rm -f thds omp cuda
