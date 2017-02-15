

default: hw01

hw01: hw01.cc
	g++ $< -o $@ -O3 -g -Wall -std=c++11 -lpthread
	g++ $< -o $@-debug -O0 -g -Wall -std=c++11 -lpthread


clean:
	/bin/rm -f hw01 hw01-debug
