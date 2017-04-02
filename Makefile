CFLAGS=-std=c++14 -march=native -Wall -lSDL

all: raytrace.o lodepng.o imshow.o vecmath.o
	g++ $(CFLAGS) -o raytrace.out raytrace.o lodepng.o imshow.o vecmath.o

%.o: %.cpp
	g++ $(CFLAGS) -c $< $!
