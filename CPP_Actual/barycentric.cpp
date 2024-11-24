#include <iostream>
#include <math.h>
#include <string>
#include "filehandler.h"

#ifndef BARYCENTRIC_H

// returns 3D point
float* barycentric(float* points2D, float x2D, float y2D) {
    float x = (points2D[2] - points2D[0]) * (points2D[1] - y2D) - (points2D[0] - x2D) * (points2D[3] - points2D[1]);
    float y = (points2D[0] - x2D) * (points2D[5] - points2D[1]) - (points2D[4] - points2D[0]) * (points2D[1] - y2D);
    float z = (points2D[4] - points2D[0]) * (points2D[3] - points2D[1]) - (points2D[2] - points2D[0]) * (points2D[5] - points2D[1]);

    float* point3D = (float*)malloc(sizeof(float) * 3);

    if (std::abs(z) < 1) {
        point3D[0] = -1;
        point3D[1] = 1;
        point3D[2] = 1;
    }
    else {
        point3D[0] = 1.f - (x + y) / z;
        point3D[1] = y / z;
        point3D[2] = x / z;
    }

    return point3D;
}

// points2D will always be len = 6 (evens = x's odds = y's)
void triangle(string fileName, float* points2D) {
    // find bounds of the triangle so we don't have to go through every pixel for every tri:
    float minX = std::min(std::min(points2D[0], points2D[2]), points2D[4]);
    float maxX = std::min(std::max(points2D[0], points2D[2]), points2D[4]);
    float minY = std::min(std::min(points2D[1], points2D[3]), points2D[5]);
    float maxY = std::min(std::max(points2D[1], points2D[3]), points2D[5]);

    //int iterator = 0;
    for (int x = minX; x <= maxX; x++) {
        for (int y = minY; y <= maxY; y++) {
            float* pixel = barycentric(points2D, x, y);
            if (pixel[0] < 0 || pixel[1] < 0 || pixel[2] < 0) continue;
            //iterator++;
            writeVertex(fileName, pixel);
            //printf("(%g, %g, %g)\n", pixel[0], pixel[1], pixel[2]);
            //printf("(%g, %g, %g)\n", pixel[0] * width, pixel[1] * height, pixel[2]); ?
        }
    }

    // this often finds 0 valid pixels which seems odd...
    //std::cout << "Found " << iterator << " pixels!\n";
}

#endif