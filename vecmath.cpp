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

// returns the magnitude of this vector
float vec3::magnitude() {
  return sqrt(x*x+y*y+z*z);
}

float vec3::sqrMagnitude() {
  return x*x+y*y+z*z;
}

// returns a new vec3 with a length of 1
vec3 vec3::normalized() {
  vec3 v;
  float m = magnitude();
  v.x = x/m;
  v.y = y/m;
  v.z = z/m;
  return v;
}

// sets x, y, and z so this vector has a length of 1
void vec3::makeNormalized() {
  float m = magnitude();
  x = x/m;
  y = y/m;
  z = z/m;
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
rayhit ray::castAgainst(const sphere s) {
  rayhit hit;
  // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
  float dotProduct = direction.dot(origin-s.pos);
  float distanceBetweenSqr = (origin-s.pos).sqrMagnitude();
  float importantPart = dotProduct*dotProduct - distanceBetweenSqr + s.rad*s.rad;
  if (importantPart < 0) {
    hit.hitSomething = false;
    return hit;
  } else {
    hit.hitSomething = true;
  }
  float d = -dotProduct - sqrt(importantPart);
  hit.point = origin + direction*d;
  hit.normal = (s.pos - hit.point).normalized();
  hit.distance = d;
  return hit;
}
