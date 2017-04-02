#include <iostream>
#include <chrono>
#include "imshow.h"
#include "vecmath.h"

// thanks go to Lode Vandevenne for the LodePNG library and examples

void getColorAtPixel (ray r, sphere *s, int numSpheres, unsigned char color[]);

int main(int argc, char* argv[]) {
  // make a 512x512 image
  uint w, h;
  w = h = 900;
  const int sz = w*h;
  unsigned char rgba [sz*4];

  // construct the camera/screen
  view cam;
  cam.aspectRatio = (float)w / (float)h;
  cam.fov = 110.0;
  cam.pos = vec3(0,0,-5);
  cam.fwd = vec3(0,0,1); // straight forward
  cam.w = w;
  cam.h = h;

  sphere s[4];
  s[0] = sphere();
  s[0].pos = vec3(1.5,-1.5,0);
  s[0].rad = 1;
  s[1].pos = vec3(-1.5,-1.5,0);
  s[1].rad = 1;
  s[2].pos = vec3(-1.5,1.5,0);
  s[2].rad = 1;
  s[3].pos = vec3(1.5,1.5,0);
  s[3].rad = 1;

  sphere s1;
  s1.pos = vec3(2,0,0);
  s1.rad = 2.0;

  uint coord;
  unsigned char color[4];
  for (uint y=0; y<h; y++) {
    for (uint x=0; x<w; x++) {
      coord = (x+y*h) * 4;
      ray r = cam.getRayForPixel(x,y);
      getColorAtPixel(r,s,4,color);
      rgba[coord+0] = color[0];
      rgba[coord+1] = color[1];
      rgba[coord+2] = color[2];
      rgba[coord+3] = color[3];
    }
  }

  show("Sample image", rgba, w, h);
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
