#include <cmath>

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
  float magnitude();
  vec3 normalized();
  void makeNormalized();
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
  unsigned int rgba;
  sphere () {
    pos = vec3(0,0,0);
    rad = 0.5;
    rgba = 0xffffffff;
  };
};

// represents a combination camera/screen
class view {
public:
  vec3 pos;
  vec3 fwd;
  float aspectRatio = 1; // width / height
  float fov = 90; // in degrees, in x direction
  unsigned int w, h; // in pixels
  ray getRayForPixel(int,int);
};
