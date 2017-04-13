CFLAGS=-std=c++14 -march=native -Wall -lSDL -fopenmp -O3

all: raytrace.o lodepng.o imshow.o vecmath.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o

%.o: %.cpp
	g++ $(CFLAGS) -c $< $!

%.pg.o: %.cpp
	g++ $(CFLAGS) -c $< $! -pg

%.S: %.cpp
	g++ $(CFLAGS) -S $< $! -fverbose-asm

clean:
	rm -f *.o *.gch *.out

prof: raytrace.pg.o lodepng.pg.o imshow.pg.o vecmath.pg.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o -pg

asm: raytrace.S vecmath.S