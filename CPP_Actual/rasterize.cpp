// inspiration: https://github.com/ssloy/tinyrenderer/wiki/Lesson-2:-Triangle-rasterization-and-back-face-culling

#include <iostream>
#include "filehandler.h"
#include "barycentric.h"

// hardset output height and width
const float setWidth = 200;
const float setHeight = 200;
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
        multiplier = (setWidth - padding*2) / pointsWidth;
    }
    else { 
        multiplier = (setHeight - padding*2) / pointsHeight;
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
    
    // NOTE we are ignoring the 3D dimention in barycentric for now !
    // todo: for loop for all triangles
    readyOutputFile(fileName);
    for (int i = 0; i < triangleCount; i++){
        int tri = i * 3;
        float* triangleVerts = (float*)malloc(sizeof(float) * 6);
        triangleVerts[0] = vertices[faces[tri] * 3];
        triangleVerts[1] = vertices[faces[tri] * 3 + 1];
        triangleVerts[2] = vertices[faces[tri + 1] * 3];
        triangleVerts[3] = vertices[faces[tri + 1] * 3 + 1];
        triangleVerts[4] = vertices[faces[tri + 2] * 3];
        triangleVerts[5] = vertices[faces[tri + 2] * 3 + 1];

        triangle(fileName, triangleVerts);
    }

    cout << "All done!" << endl;
    free(vertices);
    free(faces);

    return 0;
}