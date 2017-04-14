#include <iostream>
#include <chrono>
#include <cfloat>
#include <omp.h>
#include "imshow.h"
#include "vecmath.h"

// thanks go to Lode Vandevenne for the LodePNG library and examples

int main(int argc, char* argv[]) {
  if (argc < 2) {
    std::cout << "Usage: raytrace numSpheres\n";
    return 0;
  }
  int nSpheres = atoi(argv[1]);
  int iterations = 100;
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

#pragma omp parallel shared(rgba)
  for (int iter=0; iter<iterations; iter++) {
    #pragma omp for
    for (uint vy=0; vy<h; vy++) {
      uint coord = (vy*w)*4;
      ray r;
      r.origin = cam.pos;
      // dir.y = ((float)cam.h-2*vy) / ((float)cam.h) * cam.fovtanAspect;
      // dir.z = 1;
      for (uint vx=0; vx<w; vx++) {
        coord += 4;
        // dir.x = (2*vx-(float)cam.w) / ((float)cam.w) * cam.fovtan;
        // //r.direction.x = (float)(2*vx-cam.w) * viewXmod;
        // r.direction = dir.normalized();
        r = cam.getRayForPixel(vx,vy);

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
        for (int i=0; i<nSpheres; i++) {
          
          // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
          //float dotProduct = direction.dot(origin-s.pos);
          float dotProduct = x[0]*(x[1]-px[i]) + y[0]*(y[1]-py[i]) + z[0]*(z[1]-pz[i]);
          //float distanceBetweenSqr = (origin-s.pos).sqrMagnitude();
          float distanceBetweenX = x[1]-px[i];
          float distanceBetweenY = y[1]-py[i];
          float distanceBetweenZ = z[1]-pz[i];
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


        rgba[coord+0] = pixvalue;
        rgba[coord+1] = pixvalue;
        rgba[coord+2] = pixvalue;
        rgba[coord+3] = 255;
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