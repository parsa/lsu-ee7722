
INCLUDES = -I.

SOURCES = List.cpp Metric.cpp Eval.cpp
HFILES = Eval.h List.h Metric.h Parser.h ScopeExit.h Utils.h

NVCC_FLAGS= -O3 -g --std=c++11 -Xcompiler -Wall

LIBS = -lcuda -lnvperf_host -lnvperf_target

OBJS = $(SOURCES:.cpp=.o)

DEFAULT: $(OBJS)

%.o: %.cpp Makefile $(HFILES)
	nvcc -c $(NVCC_FLAGS) $(INCLUDES) $<

clean:
	/bin/rm -f $(OBJS)

