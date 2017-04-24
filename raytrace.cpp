#include <iostream>
#include <chrono>
#include <cfloat>
#include <omp.h>
#include "imshow.h"
#include "vecmath.h"

// thanks go to Lode Vandevenne for the LodePNG library and examples

void getColorAtPixel (float *px, float *py, float *pz, float *rad, ray r, int numSpheres, unsigned char color[]);

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "Usage: raytrace numSpheres [show]\n";
    return 0;
  }
  int nSpheres = atoi(argv[1]);
  int iterations;
  if (argc > 2) iterations = 1;
  else iterations = 100;
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

  float *px, *py, *pz, *rad;
  px = (float*)calloc(nSpheres,sizeof(float));
  py = (float*)calloc(nSpheres,sizeof(float));
  pz = (float*)calloc(nSpheres,sizeof(float));
  rad = (float*)calloc(nSpheres,sizeof(float));

  for (int i=0; i<nSpheres; i++) {
    px[i] = ((i%2)*2-1)*0.05*i;
    py[i] = (((i/2)%2)*2-1)*0.05*i;
    pz[i] = i*0.1;
    rad[i]= 0.5;
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
        getColorAtPixel(px,py,pz,rad,r,nSpheres,color);
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

  if (argc > 2) show("Sample image", rgba, w, h);

  free(px);
  free(py);
  free(pz);
  free(rad);
  delete[] rgba;
}

void getColorAtPixel (float *px, float *py, float *pz, float *rad, ray r, int numSpheres, unsigned char color[]) {

  // direction, origin
  float x[2], y[2], z[2];
  x[0] = r.direction.x;
  x[1] = r.origin.x;
  y[0] = r.direction.y;
  y[1] = r.origin.y;
  z[0] = r.direction.z;
  z[1] = r.origin.z;

  float distancesX[8], distancesY[8], distancesZ[8];
  float dotProducts[8], distancesSqr[8], importantParts[8], ds[8];

  // find the closest hit
  rayhit bestHit;
  bool gotBestHit = false;
  bestHit.distance = FLT_MAX;
  for (int i=0; i<numSpheres-(numSpheres%8); i+=8) {
    // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
    #pragma omp simd
    for (int j=0; j<8; j++) {
      distancesX[j] = x[1] - px[i+j];
      distancesY[j] = y[1] - py[i+j];
      distancesZ[j] = z[1] - pz[i+j];

      dotProducts[j] = x[0]*(distancesX[j]) + y[0]*(distancesY[j]) + z[0]*(distancesZ[j]);
      distancesSqr[j] = distancesX[j]*distancesX[j] + distancesY[j]*distancesY[j] + distancesZ[j]*distancesZ[j];
      importantParts[j] = dotProducts[j]*dotProducts[j] - distancesSqr[j] + rad[i+j]*rad[i+j];
    }

    #pragma omp simd
    for (int j=0; j<8; j++) {
      if (importantParts[j] < 0) {
        continue;
      }

      ds[j] = -dotProducts[j] - sqrt(importantParts[j]);
      if (ds[j] < bestHit.distance) {
        bestHit.point = r.origin + r.direction*ds[j];
        bestHit.normal.y = (py[i+j] - bestHit.point.y) * (1.0/rad[i+j]);
        bestHit.normal.x = (px[i+j] - bestHit.point.x) * (1.0/rad[i+j]);
        bestHit.normal.z = (pz[i+j] - bestHit.point.z) * (1.0/rad[i+j]);
        bestHit.distance = ds[j];

        gotBestHit = true;
      }
    }
  }

  int i = numSpheres-(numSpheres%8);
  for (int j=0; j<(numSpheres%8); j++) {
    
    distancesX[j] = x[1] - px[i+j];
    distancesY[j] = y[1] - py[i+j];
    distancesZ[j] = z[1] - pz[i+j];

    dotProducts[j] = x[0]*(distancesX[j]) + y[0]*(distancesY[j]) + z[0]*(distancesZ[j]);
    distancesSqr[j] = distancesX[j]*distancesX[j] + distancesY[j]*distancesY[j] + distancesZ[j]*distancesZ[j];
    importantParts[j] = dotProducts[j]*dotProducts[j] - distancesSqr[j] + rad[i+j]*rad[i+j];
    if (importantParts[j] < 0) {
      continue;
    }
    ds[j] = -dotProducts[j] - sqrt(importantParts[j]);
    if (ds[j] < bestHit.distance) {
      bestHit.point = r.origin + r.direction*ds[j];
      // hit->normal = (s.pos - hit->point) * (1.0/rad[i]);
      //bestHit.normal.y = (py[i+j] - bestHit.point.y) * (1.0/rad[i+j]);
      //bestHit.normal.x = (px[i+j] - bestHit.point.x) * (1.0/rad[i+j]);
      bestHit.normal.z = (pz[i+j] - bestHit.point.z) * (1.0/rad[i+j]);
      bestHit.distance = ds[j];
      gotBestHit = true;
    }
  }

  unsigned char pixvalue = 0;
  if (gotBestHit) {
    float normalDot = bestHit.normal.z;
    if (normalDot<0) normalDot = 0;
    pixvalue = (normalDot)*255;
  }
  color[0] = pixvalue;
  color[1] = pixvalue;
  color[2] = pixvalue;
  color[3] = 255;
}
