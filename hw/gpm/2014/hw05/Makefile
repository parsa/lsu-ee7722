
default: hw05

SRCS = hw05.cc

CXX = icpc
LD = icpc
CXXFLAGS = -g -O3   -offload=mandatory -openmp
LINKFLAGS = -loffload -lrt 

OBJ_FILES = $(SRCS:.cc=.o)

%.o: %.cc Makefile util.h
	$(CXX) $(CXXFLAGS) -S $<
	$(CXX) $(CXXFLAGS) -c $<

hw05: $(OBJ_FILES)
	$(LD) $(CXXFLAGS) $(LINKFLAGS) $(OBJ_FILES) -o $@

clean:
	rm -f *~ *.o *MIC.o hw05 *.s *MIC.s
