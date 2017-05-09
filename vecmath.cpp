#include "vecmath.h"

#define DEG_TO_RAD 0.0174533

vec3::vec3 () {
  x = y = z = 0;
}

vec3::vec3 (float vx,float vy,float vz) {
  x = vx;
  y = vy;
  z = vz;
}

vec3& vec3::operator= (const vec3& rhs) {
  x = rhs.x;
  y = rhs.y;
  z = rhs.z;
  return *this;
}

vec3 vec3::operator+ (const vec3& rhs) const {
  return vec3 (x+rhs.x,y+rhs.y,z+rhs.z);
}

vec3 vec3::operator- (const vec3& rhs) const {
  return vec3 (x-rhs.x,y-rhs.y,z-rhs.z);
}

vec3 vec3::operator* (const float scalar) const {
  return vec3 (x*scalar,y*scalar,z*scalar);
}


view::view (int width, int height, float fieldOfView) {
  w = width;
  h = height;
  aspectRatio = ((float)w) / ((float)h);
  fov = fieldOfView;
  fovrad = (fov/2.0)*DEG_TO_RAD;
  fovtan = tan(fovrad);
  fovtanAspect = tan(fovrad)/aspectRatio;
}

ray view::getRayForPixel(int x, int y) {
  ray r;
  r.origin = pos;
  r.direction.x = (2*x-(float)w) / ((float)w) * fovtan;
  r.direction.y = ((float)h-2*y) / ((float)h) * fovtanAspect;
  r.direction.z = 1;
  r.direction.makeNormalized();

  return r;
}