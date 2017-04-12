CFLAGS=-std=c++14 -march=native -Wall -fopenmp -O3

all: raytrace.o lodepng.o imshow.o vecmath.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o -lSDL

%.o: %.cpp
	g++ $(CFLAGS) -c $< $!

%.pg.o: %.cpp
	g++ $(CFLAGS) -c $< $! -pg

clean:
	rm -f *.o *.gch *.out

prof: raytrace.pg.o lodepng.pg.o imshow.pg.o vecmath.pg.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o -pg
