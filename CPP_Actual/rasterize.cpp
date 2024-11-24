// inspiration: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling

#include <iostream>
#include "filehandler.h"
#include "pixel.h"

// hardset output height and width
const int definedSize = 256;
const float padding = 0;

// vertices.length == vertexCount * 3 (1d array of 3d vertices)
void adjustToSize(float* vertices, int vertexCount) {
    float minX = 0;
    float maxX = 0;
    float minY = 0;
    float maxY = 0;

    // calculate min and max -es
    for (int i = 0; i < vertexCount; i++) {
        int x = i * 3;  // x + 1 = y

        if (vertices[x] < minX) minX = vertices[x];
        if (vertices[x] > maxX) maxX = vertices[x];
        if (vertices[x + 1] < minY) minY = vertices[x + 1];
        if (vertices[x + 1] > maxY) maxY = vertices[x + 1];
    }

    // create multiplier based off larger difference
    float pointsWidth = maxX - minX;
    float pointsHeight = maxY - minY;

    float multiplier;
    if (pointsWidth > pointsHeight) {
        multiplier = (definedSize - padding*2) / pointsWidth;
    }
    else { 
        multiplier = (definedSize - padding*2) / pointsHeight;
    }

    // apply multiplier to all points (and offset if any points are negative)
    for (int i = 0; i < vertexCount; i++) {
        int x = i * 3;  // x + 1 = y
        if (minX < 0){
            vertices[x] -= minX;
        }
        if (minY < 0){
           vertices[x + 1] -= minX; 
        }

        vertices[x] *= multiplier;
        vertices[x + 1] *= multiplier;
    }
}

int main(int argc, char** argv) {
    string fileName = argv[1];
    cout << "Processing file: " << fileName << endl;

    // gather data:
    int vertCount = getVertexCount(fileName);
    int triangleCount = getFaceCount(fileName);

    float* vertices = (float*)malloc(sizeof(float) * vertCount * 3);
    int* faces = (int*)malloc(sizeof(int) * triangleCount * 3);
    
    readVertices(fileName, vertices);
    readFaces(fileName, faces);

    cout << "This file has " << vertCount << " vertices and " << triangleCount << " triangles!" << endl;

    cout << "Adjusting to size..." << endl;
    adjustToSize(vertices, vertCount);
    
    bool* pointTests = (bool*)malloc(sizeof(bool) * definedSize * definedSize);
    for(int i = 0; i < definedSize*definedSize; i++) pointTests[i] = false;

    // do math
    cout << "Comparing pixels with triangles..." << endl;
    float* triangle = (float*)malloc(sizeof(float) * 6);
    for(int tri = 0; tri < triangleCount; tri++){
        triangle[0] = vertices[faces[tri]];
        triangle[1] = vertices[faces[tri] + 1];
        triangle[2] = vertices[faces[tri + 1]];
        triangle[3] = vertices[faces[tri + 1] + 1];
        triangle[4] = vertices[faces[tri + 2]];
        triangle[5] = vertices[faces[tri + 2] + 1];

        // do parallelism here
        for (int x = 0; x < definedSize; x++){
            for (int y = 0; y < definedSize; y++){
                if (!pointTests[y*definedSize + x]) pointTests[y*definedSize + x] = inTriangle(triangle, x, y);
            }
        }
    }
    free(triangle);

    // write
    cout << "Writing results..." << endl;
    float* pixel = (float*)malloc(sizeof(float) * 3);
    readyOutputFile(fileName);
    for (int i = 0; i < definedSize * definedSize; i++){
        pixel[0] = i % definedSize;
        pixel[1] = i / definedSize;
        if (pointTests[i] == false) pixel[2] = 0;
        else pixel[2] = 1;
        writeVertex(fileName, pixel);
    }
    free(pixel);

    cout << "All done!" << endl;
    free(vertices);
    free(faces);

    return 0;
}

// Leah - how to run in command line:
// compile: g++ -o rasterize.exe rasterize.cpp filehandler.cpp barycentric.cpp
// execute: read.exe [fileName no extention]