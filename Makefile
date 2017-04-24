CFLAGS=-std=c++11 -march=native -Wall -fopenmp -O3
NVFLAGS=-std=c++11 -O3

all: raytrace.o lodepng.o imshow.o vecmath.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o -lSDL

%.o: %.cpp
	g++ $(CFLAGS) -c $< $!

%.pg.o: %.cpp
	g++ $(CFLAGS) -c $< $! -pg

%.cuda.o: %.cu
	nvcc $(NVFLAGS) -c $< $!

%.S: %.cpp
	g++ $(CFLAGS) -S $< $! -fverbose-asm

clean:
	rm -f *.o *.gch *.out

prof: raytrace.pg.o lodepng.pg.o imshow.pg.o vecmath.pg.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o -pg

asm: raytrace.S vecmath.S

cuda: raytrace.cuda.o lodepng.o imshow.o vecmath.o
	nvcc $(NVFLAGS) -o raytracecu.out raytrace.o lodepng.o imshow.o vecmath.o -lSDL