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

ray view::getRayForPixel(int x, int y) {
  ray r;
  r.origin = pos;
  /*
  // get the horizontal angle (rotation around y-axis)
  float xangle = (2*x-(float)w) / ((float)w); // from -1..+1
  xangle *= (fov*0.5) * DEG_TO_RAD; // convert to radians
  // do the same thing for vertical angle (rotation around x-axis) (note: I'm ignoring rotation around z, i.e. roll)
  float yangle = (2*y-(float)h) / ((float)h); // from -1..+1
  yangle *= (fov*0.5/aspectRatio) * DEG_TO_RAD;
  r.direction = fwd;

  r.direction.rotateAroundX(yangle);
  r.direction.rotateAroundY(xangle);
  r.direction.makeNormalized();
  */
  float fovrad = (fov/2.0)*DEG_TO_RAD;
  r.direction.x = (2*x-(float)w) / ((float)w) * tan(fovrad);
  r.direction.y = ((float)h-2*y) / ((float)h) * tan(fovrad*aspectRatio);
  r.direction.z = 1;
  r.direction.makeNormalized();

  return r;
}

rayhit ray::castAgainst(const sphere s) {
  rayhit hit;
  // math stolen from Wikipedia (en.wikipedia.org/wiki/Line–sphere_intersection)
  float dotProduct = direction.dot(origin-s.pos);
  float distanceBetween = (origin-s.pos).magnitude();
  float importantPart = dotProduct*dotProduct - distanceBetween*distanceBetween + s.rad*s.rad;
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
