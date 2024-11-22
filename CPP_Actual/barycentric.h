#ifndef BARYCENTRIC_H
#define BARYCENTRIC_H

#include <string>
using namespace std;

// inspiration: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling

float* barycentric(float* points2D, float x2D, float y2D);

void triangle(string fileName, float* points2D);

#endif