#include "vecmath.h"
#include <cstdint>

int main(int argc, char *argv[]);
void getColorAtPixel(SphereList spheres, ray r, int numSpheres,
                     unsigned char color[]);
rayhit getBestHit(SphereList spheres, int numSpheres, ray r, float x[2],
                  float y[2], float z[2]);
uint8_t *makeImage(uint width, uint height);