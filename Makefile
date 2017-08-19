CXX=g++
CXXFLAGS=-std=c++11 -march=native -Wall -fopenmp -O3
NVFLAGS=-std=c++11 -arch compute_30 -code sm_30,sm_37 -O3
LDFLAGS=-lSDL

# files common to both versions
SOURCES_COMMON=imshow.cpp vecmath.cpp
OBJECTS=$(SOURCES_COMMON:.cpp=.o)

# CPU version source files
SOURCES_CPU=raytrace.cpp
OBJECTS_CPU=$(SOURCES_CPU:.cpp=.o)

# GPU version source files
SOURCES_CUDA=raytrace.cu
OBJECTS_CUDA=$(SOURCES_CUDA:.cu=cu.o)

# build version with debugging - used with valgrind/callgrind
prof: CXXFLAGS += -g
prof: all

# build CPU implementation by default
all: $(OBJECTS) $(OBJECTS_CPU)
	$(CXX) $(CXXFLAGS) -o raytrace.out $(OBJECTS) $(OBJECTS_CPU) $(LDFLAGS)

# build GPU CUDA version
cuda: CXX = nvcc
cuda: CXXFLAGS = $(NVFLAGS)
cuda: $(OBJECTS) $(OBJECTS_CUDA)
	$(CXX) $(CXXFLAGS) -o raytrace.cuda.out $(OBJECTS) $(OBJECTS_CUDA) $(LDFLAGS)

# generate assembly for all sources
asm: $(SOURCES_COMMON:.cpp=.S) $(SOURCES_CPU:.cpp=.S)

# implicit rule for .cpp -> .o files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# implicit rule for CUDA .cu -> .o files
# note that .cpp files *should* be passed to system's $CXX by default
%cu.o: %.cu
	$(CXX) $(CXXFLAGS) -c $< -o $@

# implicit rule for assembly generation
%.S: %.cpp
	$(CXX) $(CXXFLAGS) -S $< -o $@ -fverbose-asm

clean:
	rm -f *.o *.gch *.out *.S