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

// 3 mult, 2 add
float vec3::dot(const vec3 rhs) {
  return x*rhs.x + y*rhs.y + z*rhs.z;
}

void vec3::rotateAroundX (float degrees) {
  float rads = degrees * DEG_TO_RAD;
  float costheta = cos(rads);
  float sintheta = sin(rads);
  // don't modify x
  y = y*costheta + (z * -sintheta);
  z = y*sintheta + z*costheta;
}

void vec3::rotateAroundY (float degrees) {
  float rads = degrees * DEG_TO_RAD;
  float costheta = cos(rads);
  float sintheta = sin(rads);
  x = x*costheta + z*sintheta;
  z = x*-sintheta + z*costheta;
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

// 15 mult 21 add 1 branch 2 sqrt
bool ray::castAgainst(const sphere s, rayhit *hit) {
  // direction, origin, s.pos
  float x[3], y[3], z[3];
  x[0] = direction.x;
  x[1] = origin.x;
  x[2] = s.pos.x;
  y[0] = direction.y;
  y[1] = origin.y;
  y[2] = s.pos.y;
  z[0] = direction.z;
  z[1] = origin.z;
  z[2] = s.pos.z;
  
  // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
  //float dotProduct = direction.dot(origin-s.pos);
  float dotProduct = x[0]*(x[1]-x[2]) + y[0]*(y[1]-y[2]) + z[0]*(z[1]-z[2]);
  //float distanceBetweenSqr = (origin-s.pos).sqrMagnitude();
  float distanceBetweenX = x[1]-x[2];
  float distanceBetweenY = y[1]-y[2];
  float distanceBetweenZ = z[1]-z[2];
  float distanceBetweenSqr = distanceBetweenX*distanceBetweenX + distanceBetweenY*distanceBetweenY + distanceBetweenZ*distanceBetweenZ;
  float importantPart = dotProduct*dotProduct - distanceBetweenSqr + s.rad*s.rad;
  if (importantPart < 0) {
    return false;
  }

  float d = -dotProduct - sqrt(importantPart);
  hit->point = origin + direction*d;
  hit->normal = (s.pos - hit->point).normalized();
  hit->distance = d;
  return true;
}
