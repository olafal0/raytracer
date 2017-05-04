#include <iostream>
#include <chrono>
#include <cfloat>
#include <omp.h>
#include <cuda.h>
#include "imshow.h"
#include "vecmath.h"

#define THREADS_PER_BLOCK 1024
#define NUM_BLOCKS 16*6
#define CHUNK_SIZE (THREADS_PER_BLOCK*NUM_BLOCKS)

// thanks go to Lode Vandevenne for the LodePNG library and examples

// kernel function should take a pixel, construct a ray for it, and cast against all spheres in the scene
__global__
void getColorAtPixel (int startIdx, int w, int h, float fovtan, float fovtanAspect, v3 origin, unsigned char *rgba, float *sphereList, int numSpheres) {
  // copy the whole sphere list into shared memory
  // this requires 16KiB per block for 1000 spheres, and more than 1000 spheres is not yet handled
  extern __shared__ float spheres[];
  for (int i=threadIdx.x;i<numSpheres*4;i+=blockDim.x) {
    spheres[i] = sphereList[i];
  }
  __syncthreads();
  float *px = &spheres[0];
  float *py = &spheres[numSpheres];
  float *pz = &spheres[numSpheres*2];
  float *rad = &spheres[numSpheres*3];

  int idx = (threadIdx.x + blockIdx.x * blockDim.x) + startIdx;
  for (idx; idx < w*h; idx += blockDim.x*gridDim.x) {

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
    int bestHitSphere = -1;
    v3 bestPt, bestNorm;

    /*
      Accesses for this thread:
      p{x,y,z}[0..n]
      rad[0..n]
      then write to rgba[idx*4..idx*4+4]
    */

    for (int i=0; i<numSpheres; i++) {
      distanceX = origx - px[i];
      distanceY = origy - py[i];
      distanceZ = origz - pz[i];

      dotProduct = dirx*(distanceX) + diry*(distanceY) + dirz*(distanceZ);
      distanceSqr = distanceX*distanceX + distanceY*distanceY + distanceZ*distanceZ;
      importantPart = dotProduct*dotProduct - distanceSqr + rad[i]*rad[i];

      d = -dotProduct - sqrtf(importantPart);
      if (d < bestDist) {
        bestDist = d;
        bestHitSphere = i;
      }
    }


    unsigned char pixvalue = 0;
    if (bestHitSphere >= 0) {
      bestPt.x = origx + dirx*bestDist;
      bestPt.y = origy + diry*bestDist;
      bestPt.z = origz + dirz*bestDist;
      //bestNorm.y = (py[i] - bestPt.y) * (1.0/rad[i]);
      //bestNorm.x = (px[i] - bestPt.x) * (1.0/rad[i]);
      bestNorm.z = (pz[bestHitSphere] - bestPt.z) * (1.0/rad[bestHitSphere]);
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
  float *px, *py, *pz, *rad, *spheres;
  spheres = (float*)calloc(nSpheres*4,sizeof(float));
  // px = (float*)calloc(nSpheres,sizeof(float));
  // py = (float*)calloc(nSpheres,sizeof(float));
  // pz = (float*)calloc(nSpheres,sizeof(float));
  // rad = (float*)calloc(nSpheres,sizeof(float));
  px = &(spheres[0]);
  py = &spheres[nSpheres];
  pz = &spheres[nSpheres*2];
  rad = &spheres[nSpheres*3];

  // allocate device spheres
  //float *dpx, *dpy, *dpz, *drad;
  // errorCheck(cudaMalloc(&dpx,sizeof(float)*nSpheres));
  // errorCheck(cudaMalloc(&dpy,sizeof(float)*nSpheres));
  // errorCheck(cudaMalloc(&dpz,sizeof(float)*nSpheres));
  // errorCheck(cudaMalloc(&drad,sizeof(float)*nSpheres));
  float *dspheres;
  errorCheck(cudaMalloc(&dspheres,sizeof(float)*nSpheres*4));

  // initialize host spheres
  for (int i=0; i<nSpheres; i++) {
    px[i] = ((i%2)*2-1)*0.05*i;
    py[i] = (((i/2)%2)*2-1)*0.05*i;
    pz[i] = i*0.1;
    rad[i]= 0.5;
  }

  // copy host spheres to device
  // errorCheck(cudaMemcpy(dpx,px,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  // errorCheck(cudaMemcpy(dpy,py,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  // errorCheck(cudaMemcpy(dpz,pz,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  // errorCheck(cudaMemcpy(drad,rad,sizeof(float)*nSpheres,cudaMemcpyHostToDevice));
  errorCheck(cudaMemcpy(dspheres,spheres,sizeof(float)*nSpheres*4,cudaMemcpyHostToDevice));
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
    getColorAtPixel<<<NUM_BLOCKS, THREADS_PER_BLOCK, nSpheres*4*sizeof(float)>>>(0,w,h,fvtan,fvtanAsp,orig,drgba,dspheres,nSpheres);
    cudaDeviceSynchronize();
    errorCheck(cudaGetLastError());
  }

  end = std::chrono::system_clock::now();
  elapsed_seconds = end-start;
  std::cout << (elapsed_seconds.count()*1000.0/iterations) << "\n";

  cudaMemcpy(rgba,drgba,sizeof(unsigned char)*sz*4,cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();

  if (argc > 2) show("Sample image", rgba, w, h);

  free(spheres);
  delete[] rgba;
  cudaFree(dspheres);
}