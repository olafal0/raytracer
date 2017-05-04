#include <iostream>
#include <chrono>
#include <cfloat>
#include <omp.h>
#include <cuda.h>
#include "imshow.h"
#include "vecmath.h"

// for GTX 760:
// 1024 threads per block
// 2048 threads per SM
// 16 blocks per SM
// 6 SMs

#define THREADS_PER_BLOCK 1024
#define NUM_BLOCKS 16*6
// use WARPS_PER_BLOCK to set blockDim.y, warpSize to set blockDim.x
#define WARPS_PER_BLOCK (THREADS_PER_BLOCK/32)

// thanks go to Lode Vandevenne for the LodePNG examples

// each warp (each 32 threads) is reponsible for one pixel
// pixel id = threadIdx.y + blockIdx.x * blockDim.x
// threadIdx.x is id (0..31) of thread in the warp for that pixel
// each thread should perform a warp-stride loop over sphere list and find its best match
// then, log2(32)=5 loops of warp shuffles to reduce values,
// until threadIdx.x=0 has the closest hit sphere

// kernel function should take a pixel, construct a ray for it, and cast against all spheres in the scene
__global__
void getColorAtPixel (int w, int h, float fovtan, float fovtanAspect, v3 origin, unsigned char *rgba, float *sphereList, int numSpheres) {
  // copy the whole sphere list into shared memory
  // this requires 16KiB per block for 1000 spheres, unlimited spheres are not yet handled
  extern __shared__ float spheres[];
  for (int i=threadIdx.x+(threadIdx.y*blockDim.x);i<numSpheres*4;i+=blockDim.x*blockDim.y) {
    spheres[i] = sphereList[i];
  }
  __syncthreads();
  float *px = &spheres[0];
  float *py = &spheres[numSpheres];
  float *pz = &spheres[numSpheres*2];
  float *rad = &spheres[numSpheres*3];
  
  // do for each pixel...
  int idx = (threadIdx.y + blockIdx.x * blockDim.y);
  for (; idx < w*h; idx += blockDim.y*gridDim.x) {

    // get pixel coords
    int x = idx % w;
    int y = idx / w;

    // find out which thread in the warp we are
    int wid = threadIdx.x;

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

    for (int i=wid; i<numSpheres; i+=blockDim.x) {
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

    // reduce to minimum using warp shuffles
    for (int d=1; d<warpSize; d*=2) {
      float otherDist = __shfl_down(bestDist,d);
      float otherBest = __shfl_down(bestHitSphere,d);
      if (otherDist < bestDist) {
        bestDist = otherDist;
        bestHitSphere = otherBest;
      }
    }

    int pixidx = idx*4;

    // use other threads in warp for writing
    bestDist = __shfl(bestDist,0);
    bestHitSphere = __shfl(bestHitSphere,0);
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
    if (wid==3) pixvalue = 255;
    if (wid < 4) {
      rgba[pixidx+wid] = pixvalue;
    }
  }
  // ops: 28 per pixel + (19 per sphere)
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
  else iterations = 10;
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

  // allocate host spheres as one array
  float *spheres, *px, *py, *pz, *rad;
  spheres = (float*)calloc(nSpheres*4,sizeof(float));
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

  float fvtan = cam.fovtan;
  float fvtanAsp = cam.fovtanAspect;
  v3 orig;
  orig.x = cam.pos.x;
  orig.y = cam.pos.y;
  orig.z = cam.pos.z;

  //cudaDeviceSetCacheConfig(cudaFuncCachePreferL1);
  dim3 blockSize(32,WARPS_PER_BLOCK);

  start = std::chrono::system_clock::now();

  for (int iter=0; iter<iterations; iter++) {
    getColorAtPixel<<<NUM_BLOCKS, blockSize, nSpheres*4*sizeof(float)>>>(w,h,fvtan,fvtanAsp,orig,drgba,dspheres,nSpheres);
  }
  cudaDeviceSynchronize();
  errorCheck(cudaGetLastError());

  end = std::chrono::system_clock::now();
  elapsed_seconds = end-start;
  std::cout << (elapsed_seconds.count()*1000.0/iterations) << "\n";

  cudaMemcpy(rgba,drgba,sizeof(unsigned char)*sz*4,cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();

  if (argc > 2) show("Sample image", rgba, w, h);

  free(spheres);
  delete[] rgba;
  cudaFree(dspheres);
  cudaFree(drgba);
}