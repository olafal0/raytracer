#include "raytrace.h"
#include "imshow.h"
#include <cfloat>
#include <chrono>
#include <iostream>

// thanks go to Lode Vandevenne for the LodePNG examples

int main(int argc, char *argv[]) {
    // if we didn't get enough arguments, print usage instructions and exit
    if (argc < 2) {
        std::cout << "Usage: raytrace numSpheres [show]\n";
        return 0;
    }

    // atoi is unsafe, but that's not a significant risk here
    int nSpheres = atoi(argv[1]);

    // if there's any third argument, no matter what it is, only do
    // one iteration and display the output
    int iterations;
    if (argc > 2)
        iterations = 1;
    else
        iterations = 100;

    // make the image
    const uint width = 1920;
    const uint height = 1080;
    uint8_t *image = makeImage(width, height);

    // construct the camera/screen
    view cam = view(width, height, 90.0);
    cam.pos = vec3(0, 0, -5); // five units back,
    cam.fwd = vec3(0, 0, 1);  // pointing straight forward

    // make the sphere list
    // this is a structure of arrays, rather than an array of structures
    // sphere i is given by s.x[i], s.y[i], s.z[i]; with radius s.radius[i]
    // this is done to optimize memory accesses, and speeds up AVX instructions
    SphereList spheres;
    spheres.x = (float *)calloc(nSpheres, sizeof(float));
    spheres.y = (float *)calloc(nSpheres, sizeof(float));
    spheres.z = (float *)calloc(nSpheres, sizeof(float));
    spheres.radius = (float *)calloc(nSpheres, sizeof(float));

    // initialize the spheres into sort of an X pattern, to avoid looking dull
    for (int i = 0; i < nSpheres; i++) {
        spheres.x[i] = ((i % 2) * 2 - 1) * 0.05 * i;
        spheres.y[i] = (((i / 2) % 2) * 2 - 1) * 0.05 * i;
        spheres.z[i] = i * 0.1;
        spheres.radius[i] = 0.5;
    }

    // start the clock
    std::chrono::time_point<std::chrono::system_clock> start, end;
    std::chrono::duration<double> elapsed_seconds;
    start = std::chrono::system_clock::now();

    for (int iter = 0; iter < iterations; iter++) {
#pragma omp parallel for shared(image)
        for (uint y = 0; y < height; y++) {
            uint coord;
            unsigned char color[4];
            coord = (y * width) * 4;
            for (uint x = 0; x < width; x++) {
                coord += 4;
                // get the color for this pixel and set the image color
                ray r = cam.getRayForPixel(x, y);
                getColorAtPixel(spheres, r, nSpheres, color);
                image[coord + 0] = color[0];
                image[coord + 1] = color[1];
                image[coord + 2] = color[2];
                image[coord + 3] = color[3];
            }
        }
    }

    // stop the clock and output average time in ms
    end = std::chrono::system_clock::now();
    elapsed_seconds = end - start;
    std::cout << (elapsed_seconds.count() * 1000.0 / iterations) << "\n";

    // if there was any third command-line arg, show the output
    if (argc > 2)
        show("Sample image", image, width, height);

    free(spheres.x);
    free(spheres.y);
    free(spheres.z);
    free(spheres.radius);
    delete[] image;
}

uint8_t *makeImage(uint width, uint height) {
    const int sz = width * height;
    unsigned char *image = new unsigned char[sz * 4];
    return image;
}

inline void getColorAtPixel(SphereList spheres, ray r, int numSpheres,
                            unsigned char color[]) {

    // direction, origin
    float x[2], y[2], z[2];
    x[0] = r.direction.x;
    x[1] = r.origin.x;
    y[0] = r.direction.y;
    y[1] = r.origin.y;
    z[0] = r.direction.z;
    z[1] = r.origin.z;

    rayhit bestHit = getBestHit(spheres, numSpheres, r, x, y, z);

    // create the color value based on the normal.z of the best hit
    unsigned char pixvalue = 0;
    if (bestHit.exists) {
        float normalDot = bestHit.normal.z;
        if (normalDot < 0)
            normalDot = 0;
        pixvalue = normalDot * 255;
    }
    color[0] = pixvalue;
    color[1] = pixvalue;
    color[2] = pixvalue;
    color[3] = 255;
}

inline rayhit getBestHit(SphereList spheres, int numSpheres, ray r, float x[2],
                         float y[2], float z[2]) {
    // number of lanes to use at once, maximum - 16 allows for 512-bit AVX
    const int simdSize = 16;
    float distancesX[simdSize], distancesY[simdSize], distancesZ[simdSize];
    float dotProducts[simdSize], distancesSqr[simdSize],
        importantParts[simdSize], ds[simdSize];

    /*
    find the closest hit
    math stolen from Wikipedia
    en.wikipedia.org/wiki/Line–sphere_intersection
    this is the math that has to happen:
    d = -(ray.direction ⋅ (ray.origin - sphere.position)) +
    sqrt(
        (ray.direction ⋅ (ray.origin - sphere.position))^2 -
        abs(ray.origin - sphere.position)^2 + sphere.radius^2
    )
    notice that the term under the square root is added, instead of
    both added and subtracted - this is because we aren't doing a
    line-sphere intersection, but a ray-sphere intersection;
    we don't need negative values.
    */

    rayhit bestHit;
    bool gotBestHit = false;
    bestHit.distance = FLT_MAX;
    for (int i = 0; i < numSpheres - (numSpheres % simdSize); i += simdSize) {
// use AVX instructions to calculate the intersection for each sphere
// in its own SIMD lane.
#pragma omp simd
        for (int j = 0; j < simdSize; j++) {
            // distances: ray.origin - sphere.position
            distancesX[j] = x[1] - spheres.x[i + j];
            distancesY[j] = y[1] - spheres.y[i + j];
            distancesZ[j] = z[1] - spheres.z[i + j];

            // dotProducts: ray.direction ⋅ (ray.origin - sphere.position)
            dotProducts[j] = x[0] * (distancesX[j]) + y[0] * (distancesY[j]) +
                             z[0] * (distancesZ[j]);
            // distancesSqr: (ray.origin - sphere.position)^2
            distancesSqr[j] = distancesX[j] * distancesX[j] +
                              distancesY[j] * distancesY[j] +
                              distancesZ[j] * distancesZ[j];
            // importantParts is the term under the square root, so named
            // because its value determines the number of solutions.
            // importantParts < 0 : no solutions
            // importantParts >= 0 : 1 or more solutions (intersections)
            // exist
            importantParts[j] = dotProducts[j] * dotProducts[j] -
                                distancesSqr[j] +
                                spheres.radius[i + j] * spheres.radius[i + j];
        }

#pragma omp simd
        for (int j = 0; j < simdSize; j++) {
            if (importantParts[j] < 0) {
                // if there are no solutions, skip sphere i+j in best
                // distance calculations.
                // information on SIMD lane divergence is hard to find,
                // but this *shouldn't* cause slowdowns beyond wasting a lane
                continue;
            }

            // compare distances to find the closest intersection
            // this is actually faster from being in a SIMD directive block
            ds[j] = -dotProducts[j] - sqrt(importantParts[j]);
            if (ds[j] < bestHit.distance) {
                bestHit.point = r.origin + r.direction * ds[j];
                // we don't need to calculate the x and y components of
                // the normal, since our shading is so simplistic
                /*
                bestHit.normal.y = (spheres.y[i + j] - bestHit.point.y) *
                                   (1.0 / spheres.radius[i + j]);
                bestHit.normal.x = (spheres.x[i + j] - bestHit.point.x) *
                                   (1.0 / spheres.radius[i + j]);
                */
                bestHit.normal.z = (spheres.z[i + j] - bestHit.point.z) *
                                   (1.0 / spheres.radius[i + j]);
                bestHit.distance = ds[j];

                gotBestHit = true;
            }
        }
    }

    // clean up - process spheres that don't fit into multiples of $simdSize
    // this is just repeating the process above, but without simd directives
    // this is so the simd blocks will have a size guarantee instead of a guess
    int i = numSpheres - (numSpheres % simdSize);
    for (int j = 0; j < (numSpheres % simdSize); j++) {

        distancesX[j] = x[1] - spheres.x[i + j];
        distancesY[j] = y[1] - spheres.y[i + j];
        distancesZ[j] = z[1] - spheres.z[i + j];

        dotProducts[j] = x[0] * (distancesX[j]) + y[0] * (distancesY[j]) +
                         z[0] * (distancesZ[j]);
        distancesSqr[j] = distancesX[j] * distancesX[j] +
                          distancesY[j] * distancesY[j] +
                          distancesZ[j] * distancesZ[j];
        importantParts[j] = dotProducts[j] * dotProducts[j] - distancesSqr[j] +
                            spheres.radius[i + j] * spheres.radius[i + j];
        if (importantParts[j] < 0) {
            continue;
        }
        ds[j] = -dotProducts[j] - sqrt(importantParts[j]);
        if (ds[j] < bestHit.distance) {
            bestHit.point = r.origin + r.direction * ds[j];
            // we don't need to calculate the x and y components of
            // the normal, since our shading is so simplistic
            /*
            bestHit.normal.y = (py[i+j] - bestHit.point.y) *
            (1.0/rad[i+j]);
            bestHit.normal.x = (px[i+j] - bestHit.point.x) *
            (1.0/rad[i+j]);
            */
            bestHit.normal.z = (spheres.z[i + j] - bestHit.point.z) *
                               (1.0 / spheres.radius[i + j]);
            bestHit.distance = ds[j];
            gotBestHit = true;
        }
    }
    bestHit.exists = gotBestHit;
    return bestHit;
}