#include "immintrin.h"
#include <cmath>

class vec3;
class sphere;
class view;
struct ray;
struct rayhit;

struct v3 {
    float x, y, z;
};

typedef struct SphereList { float *x, *y, *z, *radius; } SphereList;

class vec3 {
  public:
    float x, y, z;
    vec3();
    vec3(float, float, float);
    inline float magnitude() { return sqrt(x * x + y * y + z * z); }
    inline float sqrMagnitude() { return x * x + y * y + z * z; };
    inline vec3 normalized() {
        float m = magnitude();
        return vec3(x / m, y / m, z / m);
    };
    inline void makeNormalized() {
        float m = magnitude();
        x = x / m;
        y = y / m;
        z = z / m;
    };
    float dot(const vec3 rhs);
    vec3 &operator=(const vec3 &rhs);
    vec3 operator+(const vec3 &rhs) const;
    vec3 operator*(const float scalar) const;
    vec3 operator-(const vec3 &rhs) const;
};

struct rayhit {
    vec3 point, normal;
    float distance;
    bool exists;
};

struct ray {
    vec3 origin, direction;
};

// represents a combination camera/screen
class view {
  public:
    float fovrad;
    float fovtan;
    float fovtanAspect;
    vec3 pos;
    vec3 fwd;
    float aspectRatio = 1; // width / height
    float fov = 90;        // in degrees, in x direction
    unsigned int w, h;     // in pixels
    ray getRayForPixel(int, int);
    view(int width, int height, float fieldOfView);
};
