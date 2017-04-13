#include <cmath>
#include "immintrin.h"

class vec3;
class sphere;
class view;
struct ray;
struct rayhit;

class vec3 {
public:
  float x, y, z;
  vec3();
  vec3(float,float,float);
  inline float magnitude() { return sqrt(x*x+y*y+z*z); }
  inline float sqrMagnitude() { return x*x+y*y+z*z; };
  inline vec3 normalized() {
    float m = magnitude();
    return vec3(x/m,y/m,z/m);
  };
  inline void makeNormalized() {
    float m = magnitude();
    x = x/m;
    y = y/m;
    z = z/m;
  };
  void rotateAroundX(float degrees);
  void rotateAroundY(float degrees);
  float dot(const vec3 rhs);
  vec3& operator= (const vec3& rhs);
  vec3 operator+ (const vec3& rhs) const;
  vec3 operator* (const float scalar) const;
  vec3 operator- (const vec3& rhs) const;
};

struct rayhit {
public:
  vec3 point, normal;
  float distance;
  bool hitSomething;
  explicit operator bool() const {
    return hitSomething;
  }
};

struct ray {
public:
  vec3 origin, direction;
  rayhit castAgainst(const sphere);
};

class sphere {
public:
  vec3 pos;
  float rad;
  sphere () {
    pos = vec3(0,0,0);
    rad = 0.5;
  };
};

// represents a combination camera/screen
class view {
private:
  float fovrad;
  float fovtan;
  float fovtanAspect;
public:
  vec3 pos;
  vec3 fwd;
  float aspectRatio = 1; // width / height
  float fov = 90; // in degrees, in x direction
  unsigned int w, h; // in pixels
  ray getRayForPixel(int,int);
  view (int width, int height, float fieldOfView);
};
