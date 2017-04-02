#include <iostream>
#include "imshow.h"
#include "vecmath.h"

// thanks go to Lode Vandevenne for the LodePNG library and examples

int main(int argc, char* argv[]) {
  // make a 512x512 image
  uint w, h;
  w = h = 512;
  const int sz = w*h;
  unsigned char rgba [sz*4];

  // construct the camera/screen
  view cam;
  cam.aspectRatio = (float)w / (float)h;
  cam.fov = 90;
  cam.pos = vec3(0,0,-5);
  cam.fwd = vec3(0,0,1); // straight forward
  cam.w = w;
  cam.h = h;

  uint coord;
  for (uint y=0; y<h; y++) {
    for (uint x=0; x<w; x++) {
      coord = (x+y*h) * 4;
      ray r = cam.getRayForPixel(x,y);
      rgba[coord+0] = (r.direction.x+1)*127;
      rgba[coord+1] = (r.direction.y+1)*127;
      rgba[coord+2] = (r.direction.z+1)*127;
      rgba[coord+3] = 255;
    }
  }

  show("Sample image", rgba, 512, 512);
}
