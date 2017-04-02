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
  vec3& operator= (const vec3& rhs);
  vec3 operator+ (const vec3& rhs);
  vec3 operator* (const float scalar);
  vec3 operator- (const vec3& rhs);
};

struct rayhit {
public:
  vec3 point, normal;
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
