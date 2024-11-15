// inspiration: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling

#include <iostream>

// hardset output height and width
const float setWidth = 200;
const float setHeight = 200;
const float padding = 0;

// returns 3D point
float* barycentric(float* points2D, float x2D, float y2D) {
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
void triangle(float* points2D) {
    // find bounds of the triangle so we don't have to go through every pixel for every tri:
    float minX = std::min(std::min(points2D[0], points2D[2]), points2D[4]);
    float maxX = std::min(std::max(points2D[0], points2D[2]), points2D[4]);
    float minY = std::min(std::min(points2D[1], points2D[3]), points2D[5]);
    float maxY = std::min(std::max(points2D[1], points2D[3]), points2D[5]);


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

void adjustToSize(float* points2D, int pairCount) {
    float minX = 0;
    float maxX = 0;
    float minY = 0;
    float maxY = 0;

    // calculate min and max -es
    for (int i = 0; i < pairCount; i++) {
        if (i % 2 == 0) {
            // x
            if (points2D[i] < minX) minX = points2D[i];
            if (points2D[i] > maxX) maxX = points2D[i];
        }
        else {
            // y
            if (points2D[i] < minY) minY = points2D[i];
            if (points2D[i] > maxY) maxY = points2D[i];
        }
    }

    // create multiplier based off larger difference
    float pointsWidth = maxX - minX;
    float pointsHeight = maxY - minY;

    float multiplier;
    if (pointsWidth > pointsHeight) {
        multiplier = (setWidth - padding*2) / pointsWidth;
    }
    else { 
        multiplier = (setHeight - padding*2) / pointsHeight;
    }

    // apply multiplier to all points (and offset if any points are negative)
    for (int i = 0; i < pairCount; i++) {
        if (i % 2 == 0 && minX < 0) {
            // x
            points2D[i] -= minX;
        }
        else if (i % 2 == 1 && minY < 0) {
            // y
            points2D[i] -= minY;
        }

        points2D[i] *= multiplier;
    }
}

int main(int argc, char** argv) {
    // todo: these will be pulled from a csv? later
    int vectorCount = 3;
    float* vectors = (float*)malloc(sizeof(float) * vectorCount * 2);
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