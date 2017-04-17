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

  //show("Sample image", rgba, w, h);

  free(px);
  free(py);
  free(pz);
  free(rad);
  delete[] rgba;
}

void getColorAtPixel (float *px, float *py, float *pz, float *rad, ray r, int numSpheres, unsigned char color[]) {

  // direction, origin, s.pos
  float x[2], y[2], z[2];
  x[0] = r.direction.x;
  x[1] = r.origin.x;
  y[0] = r.direction.y;
  y[1] = r.origin.y;
  z[0] = r.direction.z;
  z[1] = r.origin.z;

  // find the closest hit
  rayhit bestHit, hit;
  bool gotBestHit = false;
  bestHit.distance = FLT_MAX;
  for (int i=0; i<numSpheres; i++) {
    // if (r.castAgainst(s,i,&hit)) {
    //   if (hit.distance < bestHit.distance) {
    //     bestHit = hit;
    //     gotBestHit = true;
    //   }
    // }

    /*
    For each 8 spheres:
    pvx = px[i:i+7]
    pvy = py[i:i+7]
    pvz = pz[i:i+7]
    _mm_set1_ps(x[0])
    _mm_set1_ps(y[0])
    _mm_set1_ps(z[0])
    _mm_set1_ps(x[1])
    _mm_set1_ps(y[1])
    _mm_set1_ps(z[1])
    __mm256 distances
    __mm256 dotProducts
    */
    
    // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
    //float dotProduct = direction.dot(origin-s.pos);
    //float distanceBetweenSqr = (origin-s.pos).sqrMagnitude();
    float distanceBetweenX = x[1]-px[i];
    float distanceBetweenY = y[1]-py[i];
    float distanceBetweenZ = z[1]-pz[i];
    float dotProduct = x[0]*(distanceBetweenX) + y[0]*(distanceBetweenY) + z[0]*(distanceBetweenZ);
    float distanceBetweenSqr = distanceBetweenX*distanceBetweenX + distanceBetweenY*distanceBetweenY + distanceBetweenZ*distanceBetweenZ;
    float importantPart = dotProduct*dotProduct - distanceBetweenSqr + rad[i]*rad[i];
    if (importantPart < 0) {
      continue;
    }

    float d = -dotProduct - sqrt(importantPart);
    // this is slower:
    // hit->point.x = x[1] + x[0]*d;
    // hit->point.y = y[1] + y[0]*d;
    // hit->point.z = z[1] + z[0]*d;
    hit.point = r.origin + r.direction*d;
    // hit->normal = (s.pos - hit->point) * (1.0/rad[i]);
    hit.normal.x = (px[i] - hit.point.x) * (1.0/rad[i]);
    hit.normal.y = (py[i] - hit.point.y) * (1.0/rad[i]);
    hit.normal.z = (pz[i] - hit.point.z) * (1.0/rad[i]);
    hit.distance = d;

    if (hit.distance < bestHit.distance) {
      bestHit = hit;
      gotBestHit = true;
    }

  }
  unsigned char pixvalue = 0;
  if (gotBestHit) {
    float normalDot = -bestHit.normal.dot(vec3(0,0,-1));
    if (normalDot<0) normalDot = 0;
    pixvalue = (normalDot)*255;
  }
  color[0] = pixvalue;
  color[1] = pixvalue;
  color[2] = pixvalue;
  color[3] = 255;
}
