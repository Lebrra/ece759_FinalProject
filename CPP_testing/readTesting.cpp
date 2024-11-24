#include <iostream>
#include <fstream>
#include <string>
using namespace std;

void readVertices(string fileName, float* vertices) {
    ifstream readFile(fileName + "_vertices.txt");
    string line;
    const string delim = ", ";

    getline(readFile, line);
    int vertCount = stoi(line);     // assuming inputs are valid since they came from another script
    vertices = (float*)malloc(sizeof(float) * vertCount * 3);  // assuming 3D for now

    for (int i = 0; i < vertCount; i++){
        getline(readFile, line);

        // each line is a 3D coordinate: "x, y, z"
        vertices[3 * i] = stof(line.substr(0, line.find(delim)));
        line = line.substr(line.find(delim) + 2, line.length());
        vertices[3 * i + 1] = stof(line.substr(0, line.find(delim)));
        line = line.substr(line.find(delim) + 2, line.length());
        vertices[3 * i + 2] = stof(line);
    }

    cout << "Vertices preview:" << endl;
    for(int i = 0; i < 10; i++){
        cout << vertices[i] << endl;
    }
}

void readFaces(string fileName, int* faces) {
    ifstream readFile(fileName + "_faces.txt");
    string line;
    const string delim = ", ";

    getline(readFile, line);
    int vertCount = stoi(line);     // assuming inputs are valid since they came from another script
    faces = (int*)malloc(sizeof(int) * vertCount * 3);  // assuming 3D for now

    for (int i = 0; i < vertCount; i++){
        getline(readFile, line);

        // each line is 3 indices of a coordinate from vertices that make a triangle: "int, int, int"
        faces[3 * i] = stoi(line.substr(0, line.find(delim)));
        line = line.substr(line.find(delim) + 2, line.length());
        faces[3 * i + 1] = stoi(line.substr(0, line.find(delim)));
        line = line.substr(line.find(delim) + 2, line.length());
        faces[3 * i + 2] = stoi(line);
    }

    cout << "Faces preview:" << endl;
    for(int i = 0; i < 10; i++){
        cout << faces[i] << endl;
    }
}

int main(int argc, char** argv) {
    // Create and open a text file
    //ofstream MyFile("filename.txt");

    //// Write to the file
    //MyFile << "Files can be tricky,\nbut it is fun enough!";

    //// Close the file
    //MyFile.close();

    string fileName = argv[1];
    cout << "Processing file: " << fileName << endl;

    // gather data:
    float* vertices;
    readVertices(fileName, vertices);
    int* faces;
    readFaces(fileName, faces);
    
    // do cool things !

    free(vertices);
    free(faces);

    return 0;
}