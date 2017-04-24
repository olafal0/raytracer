#include <iostream>
#include <chrono>
#include <cfloat>
#include <omp.h>
#include <cuda.h>
#include "imshow.h"
#include "vecmath.h"

#define THREADS_PER_BLOCK 512
#define NUM_BLOCKS 512
#define CHUNK_SIZE (THREADS_PER_BLOCK*NUM_BLOCKS)

// thanks go to Lode Vandevenne for the LodePNG library and examples

// kernel function should take a pixel, construct a ray for it, and cast against all spheres in the scene
__global__
void getColorAtPixel (int startIdx, int w, int h, float fovtan, float fovtanAspect, v3 origin, unsigned char *rgba, float *px, float *py, float *pz, float *rad, int numSpheres) {
  int idx = (threadIdx.x + blockIdx.x * blockDim.x) + startIdx;
  if (idx > w*h) return;

  // get pixel coords
  int x = idx % w;
  int y = idx / w;

  // get normalized ray direction
  float dirx, diry, dirz;
  dirx = (2*x-(float)w) / ((float)w) * fovtan;
  diry = ((float)h-2*y) / ((float)h) * fovtanAspect;
  dirz = 1;
  float magn = sqrtf(dirx*dirx + diry*diry + dirz*dirz);
  dirx /= magn;
  diry /= magn;
  dirz /= magn;

  float origx, origy, origz;
  origx = origin.x;
  origy = origin.y;
  origz = origin.z;

  float distanceX, distanceY, distanceZ, dotProduct, distanceSqr, importantPart, d;

  float bestDist =  FLT_MAX;
  v3 bestPt, bestNorm;
  bool gotBestHit = false;

  for (int i=0; i<numSpheres; i++) {
    distanceX = origx - px[i];
    distanceY = origy - py[i];
    distanceZ = origz - pz[i];

    dotProduct = dirx*(distanceX) + diry*(distanceY) + dirz*(distanceZ);
    distanceSqr = distanceX*distanceX + distanceY*distanceY + distanceZ*distanceZ;
    importantPart = dotProduct*dotProduct - distanceSqr + rad[i]*rad[i];

    d = -dotProduct - sqrtf(importantPart);
    if (d < bestDist) {
      bestPt.x = origx + dirx*d;
      bestPt.y = origy + diry*d;
      bestPt.z = origz + dirz*d;
      //bestNorm.y = (py[i] - bestPt.y) * (1.0/rad[i]);
      //bestNorm.x = (px[i] - bestPt.x) * (1.0/rad[i]);
      bestNorm.z = (pz[i] - bestPt.z) * (1.0/rad[i]);
      bestDist = d;

      gotBestHit = true;
    }
  }


  unsigned char pixvalue = 0;
  if (gotBestHit) {
    float normalDot = bestNorm.z;
    if (normalDot<0) normalDot = 0;
    pixvalue = (normalDot)*255;
  }
  int pixidx = idx*4;
  rgba[pixidx+0] = pixvalue;
  rgba[pixidx+1] = pixvalue;
  rgba[pixidx+2] = pixvalue;
  rgba[pixidx+3] = 255;
}

void errorCheck (int errorCode) {
  if (errorCode != cudaSuccess) {
    printf("%s\n", cudaGetErrorString(cudaGetLastError()));
  }
  return;
}

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

  // we only need to allocate device's texture memory, the GPU will set it
  unsigned char *drgba;
  errorCheck(cudaMalloc(&drgba,sizeof(unsigned char)*sz*4));

  // construct the camera/screen
  view cam = view(w,h,90.0);
  cam.pos = vec3(0,0,-5);
  cam.fwd = vec3(0,0,1); // straight forward

  // allocate host spheres
  float *px, *py, *pz, *rad;
  px = (float*)calloc(nSpheres,sizeof(float));
  py = (float*)calloc(nSpheres,sizeof(float));
  pz = (float*)calloc(nSpheres,sizeof(float));
  rad = (float*)calloc(nSpheres,sizeof(float));

  // allocate device spheres
  float *dpx, *dpy, *dpz, *drad;
  errorCheck(cudaMalloc(&dpx,sizeof(float)*nSpheres));
  errorCheck(cudaMalloc(&dpy,sizeof(float)*nSpheres));
  errorCheck(cudaMalloc(&dpz,sizeof(float)*nSpheres));
  errorCheck(cudaMalloc(&drad,sizeof(float)*nSpheres));

  // initialize host spheres
  for (int i=0; i<nSpheres; i++) {
    px[i] = ((i%2)*2-1)*0.05*i;
    py[i] = (((i/2)%2)*2-1)*0.05*i;
    pz[i] = i*0.1;
    rad[i]= 0.5;
  }

  // copy host spheres to device
  errorCheck(cudaMemcpy(dpx,px,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  errorCheck(cudaMemcpy(dpy,py,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  errorCheck(cudaMemcpy(dpz,pz,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  errorCheck(cudaMemcpy(drad,rad,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  cudaDeviceSynchronize();

  std::chrono::time_point<std::chrono::system_clock> start, end;
  std::chrono::duration<double> elapsed_seconds;

  start = std::chrono::system_clock::now();

  //void getColorAtPixel (int startIdx, int w, int h, float fovtan, float fovtanAspect, vec3 origin, unsigned char *rgba, float *px, float *py, float *pz, float *rad, int numSpheres)

  float fvtan = cam.fovtan;
  float fvtanAsp = cam.fovtanAspect;
  v3 orig;
  orig.x = cam.pos.x;
  orig.y = cam.pos.y;
  orig.z = cam.pos.z;

  for (int iter=0; iter<iterations; iter++) {
    for (int i=0; i<sz; i+=CHUNK_SIZE) {
      getColorAtPixel<<<NUM_BLOCKS, THREADS_PER_BLOCK>>>(i,w,h,fvtan,fvtanAsp,orig,drgba,dpx,dpy,dpz,drad,nSpheres);
    }
    cudaDeviceSynchronize();
    errorCheck(cudaGetLastError());
    
  }

  end = std::chrono::system_clock::now();
  elapsed_seconds = end-start;
  std::cout << (elapsed_seconds.count()*1000.0/iterations) << "\n";

  cudaMemcpy(rgba,drgba,sizeof(unsigned char)*sz*4,cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();

  if (argc > 2) show("Sample image", rgba, w, h);

  free(px);
  free(py);
  free(pz);
  free(rad);
  delete[] rgba;
}