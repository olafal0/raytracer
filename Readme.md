## The Appplication: Raytracing
Raytracing is an algorithm for rendering in a highly detailed, physically accurate way. In real life, light is emitted by light sources, bounces off of (or is refracted by) objects, and then some of that light hits our eye or a camera. For speed, raytracing involves going backwards: start at the "eye", shoot a ray outwards, and if collisions are detected, use those to generate a color for each pixel of the image.

In this specific implementation of raytracing, full physical accuracy is not expected. It will generate an image which is shaded in a very simple manner, using sphere primatives.

## Perfomance Estimation
Raytracing is not very memory intensive. For small scenes with few objects, the only memory that will be used is roughly 20 bytes per sphere in the scene,
and about 50 bytes for the view object. Pretty much any thread will be able to contain the entire set of scene information in cache. Also, all of the scene
information is not modified during rendering. The result of all of these factors is that the rendering process can have almost no overhead.

Increasing the number of spheres does increase the memory bandwidth needed. We can get an estimate of this:
`bandwidth = imageWidth*imageHeight*4 + numSpheres*20 + 50`

Determining the bound sizes of flops comes down to estimating the number of FLOPs needed per pixel.
There are two functions which represent the bulk of the floating-point work done. These are:

* `ray view::getRayForPixel(int x, int y)`
* `rayhit ray::castAgainst(const sphere s)`

The first of these returns an eye ray for a given pixel. In the initial version, this function is poorly optimized.
All that really needs to be done is either 1 or 2 adds, but it is doing many multiplications, additions, and even a sqrt().
(Currently, 12 multiplications, 2 additions, and 1 square root. Optimally, this would be 2 additions only.)

The second function returns the "best hit" for a ray against a sphere, which includes information such as the hit point and hit normal.
If there is no collision, that is also recorded.
Currently, the operation tally of this function is 15 multiplications, 21 adds, 1 branch, and 2 square roots. This happens on a per-sphere basis.

So, we can get a rough estimate of FLOPs. If *n* is the number of spheres, that gives us 35\*n FLOPs per pixel, or 35\*n\*w\*h FLOPs per image.

The estimated performance, in milliseconds taken to render a 1920x1080 image:

![](expected-raytrace-perf.png)

## Real Performance measurement
This is the measured performance, in milliseconds per 1920x1080 image, compared to the theoretical best:

![](actual-raytrace-perf.png)

Performance is, unsurpringly, worse than it could be, by about an order of magnitude.
There are two major culprits of this, in my estimation. One, the function that
constructs eye rays is doing much more work than it could be doing.
Two, none of the heavy lifting (raycasting itself) is parallelized beyond simple
multithreading. Many vector functions (magnitude, dot product, etc) could be easily parallelized with SIMD instructions, and so could the raycast functions.

I believe these two areas for improvement could net a very significant increase in performance, and could likely get very close to the ideal performance.
