#include <iostream>
#include <chrono>
#include <omp.h>
#include "imshow.h"
#include "vecmath.h"

// thanks go to Lode Vandevenne for the LodePNG library and examples

void getColorAtPixel (ray r, sphere *s, int numSpheres, unsigned char color[]);

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "Usage: raytrace numSpheres\n";
    return 0;
  }
  int nSpheres = atoi(argv[1]);
  int iterations = 10;
  // make a 512x512 image
  uint w, h;
  w = 1920;
  h = 1080;
  const int sz = w*h;
  unsigned char *rgba = new unsigned char[sz*4];

  // construct the camera/screen
  view cam = view(w,h,90.0);
  cam.pos = vec3(0,0,-5);
  cam.fwd = vec3(0,0,1); // straight forward

  sphere *s = new sphere[nSpheres];
  for (int i=0; i<nSpheres; i++) {
    s[i] = sphere();
    s[i].pos = vec3(0,0,0);
    s[i].rad = 1;
  }

  std::chrono::time_point<std::chrono::system_clock> start, end;
  std::chrono::duration<double> elapsed_seconds;

  start = std::chrono::system_clock::now();

  uint coord;
  unsigned char color[4];
#pragma omp parallel shared(rgba) private(coord,color)
  for (int iter=0; iter<iterations; iter++) {
    #pragma omp for
    for (uint y=0; y<h; y++) {
      coord = (y*w)*4;
      for (uint x=0; x<w; x++) {
        coord += 4;
        ray r = cam.getRayForPixel(x,y);
        getColorAtPixel(r,s,nSpheres,color);
        rgba[coord+0] = color[0];
        rgba[coord+1] = color[1];
        rgba[coord+2] = color[2];
        rgba[coord+3] = color[3];
      }
    }
  }

  end = std::chrono::system_clock::now();
  elapsed_seconds = end-start;
  std::cout << (elapsed_seconds.count()*1000.0/iterations) << "\n";

  show("Sample image", rgba, w, h);

  delete[] s;
  delete[] rgba;
}

void getColorAtPixel (ray r, sphere *s, int numSpheres, unsigned char color[]) {
  // find the closest hit
  rayhit bestHit;
  bestHit.hitSomething = false;
  for (int i=0; i<numSpheres; i++) {
    rayhit hit = r.castAgainst(s[i]);
    if (hit) {
      if (bestHit) {
        if (hit.distance < bestHit.distance) {
          bestHit = hit;
        }
      } else {
        bestHit = hit;
      }
    }
  }
  unsigned char pixvalue;
  if (bestHit) {
    float normalDot = -bestHit.normal.dot(vec3(0,0,-1));
    if (normalDot<0) normalDot = 0;
    pixvalue = (normalDot)*255;
  } else {
    pixvalue = 0;
  }
  color[0] = pixvalue;
  color[1] = pixvalue;
  color[2] = pixvalue;
  color[3] = 255;
}
