// inspiration: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling

#include <iostream>

const int width = 200;
const int height = 200;
// assuming vectors have already been adjusted to the correct size

// returns 3D point
float* barycentric(int* points2D, int x2D, int y2D) {
    float x = (points2D[2] - points2D[0]) * (points2D[1] - y2D) - (points2D[0] - x2D) * (points2D[3] - points2D[1]);
    float y = (points2D[0] - x2D) * (points2D[5] - points2D[1]) - (points2D[4] - points2D[0]) * (points2D[1] - y2D);
    float z = (points2D[4] - points2D[0]) * (points2D[3] - points2D[1]) - (points2D[2] - points2D[0]) * (points2D[5] - points2D[1]);

    float* point3D = (float*)malloc(sizeof(int) * 3);

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
void triangle(int* points2D) {
    // find bounds of the triangle so we don't have to go through every pixel for every tri:
    int minX = std::min(std::min(points2D[0], points2D[2]), points2D[4]);
    int maxX = std::min(std::max(points2D[0], points2D[2]), points2D[4]);
    int minY = std::min(std::min(points2D[1], points2D[3]), points2D[5]);
    int maxY = std::min(std::max(points2D[1], points2D[3]), points2D[5]);


    for (int x = minX; x <= maxX; x++) {
        for (int y = minY; y <= maxY; y++) {
            float* pixel = barycentric(points2D, x, y);
            if (pixel[0] < 0 || pixel[1] < 0 || pixel[2] < 0) continue;
            printf("(%g, %g, %g)\n", pixel[0], pixel[1], pixel[2]);
            //printf("(%g, %g, %g)\n", pixel[0] * width, pixel[1] * height, pixel[2]); ?
            // todo: what to do with this 3d point ?
            // todo: these are probably what we want to export into a new csv to then take back into python
        }
    }
}

int main(int argc, char** argv) {
    // todo: these will be pulled from a csv later
    int vectorCount = 3;
    int* vectors = (int*)malloc(sizeof(int) * vectorCount * 2);
    vectors[0] = 10;
    vectors[1] = 10;

    vectors[2] = 100;
    vectors[3] = 30;

    vectors[4] = 190;
    vectors[5] = 160;

    // todo: when vectorCount > 3, split into triangles to be processed instead of just plowing through like this

    triangle(vectors);
    return 0;
}