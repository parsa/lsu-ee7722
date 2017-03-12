

default: hw01 hw01-sol

hw01 hw01-sol:%: %.cc
	g++ $< -o $@ -O3 -g -Wall -std=c++11 -lpthread
	g++ $< -o $@-debug -O0 -g -Wall -std=c++11 -lpthread


clean:
	/bin/rm -f hw01 hw01-debug hw01-sol hw01-sol-debug
