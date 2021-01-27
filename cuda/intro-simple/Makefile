

GP_ROOT =  ../..
ASM_WSRC = $(GP_ROOT)/util/asm-w-src
SASS_FILTER = $(GP_ROOT)/util/sass-filter --show-source-code

default: all
all: thds omp cuda

thds: thds.cc Makefile
	g++ $< -o $@ -O3 -march=native -Wall -std=c++17 -lpthread
	g++ $< -g -S $@ -O3 -march=native -fopenmp -Wall -o - \
	  | $(ASM_WSRC) > $@.s

omp: omp.cc Makefile
	g++ $< -o $@ -O3 -march=native -fopenmp -Wall
	g++ $< -g -S $@ -O3 -march=native -fopenmp -Wall -o - \
	  | $(ASM_WSRC) > $@.s

cuda: cuda.cu Makefile
	nvcc -o $@ $< -O3 -Xcompiler -Wall
	nvcc $< -cubin -O3 -Xcompiler -Wall -lineinfo -o $@.cubin
	nvdisasm $@.cubin | $(SASS_FILTER) > $@.sass

clean:
	/bin/rm -f thds omp cuda *.s *.sass *.cubin
