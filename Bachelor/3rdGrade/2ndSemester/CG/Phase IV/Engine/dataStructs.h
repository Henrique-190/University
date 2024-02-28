#ifndef ENGINE_DATASTRUCTS_H
#include <GL/glew.h>
#include <GL/glut.h>
#define ENGINE_DATASTRUCTS_H

#include <vector>
#include <string>
#include <iostream>

using namespace std;

struct Point {
    float x;
    float y;
    float z;
    //float nx;
    //float ny;
    //float nz;
    //float tx;
    //float tz;
};

struct Transform {
    string name;
    float x;
    float y;
    float z;
    float angle;
    float time = 0;
    bool align;
    vector<Point> points;
};

struct Camera {
    float position[3] = {0,0,0};
    float lookAt[3] = { 0,0,0 };
    float up[3] = { 0,0,0 };
    float projection[3] = { 0,0,0 };
};

struct Light{
    string type;
    Point pos;
    Point dir;
    float cutoff;
};

struct Color{
    float diffuse[4] = {0.8f, 0.8f, 0.8f, 1.0f};
    float ambient[4] = {0.2f, 0.2f, 0.2f, 1.0f};
    float specular[4] = {0,0,0, 1.0f};
    float emissive[4] = {0,0,0, 1.0f};
    float shininess = -1;
};

struct Model{
    string file3D;
    int textureID;
    int vertexCount;
    int indexBegin;
    //int indexEnd;
    Color color;
};

struct Group{
    vector<Transform> transformations; // geometric transforms
    vector<Model> models;              // models of group
    vector<Group> subGroups;           // subgroups of the group
    //vector<pair<int,int>> vboIndexes;
};

struct World {
    Camera *cam = new Camera;
    vector<Light> ligths;
    vector<Group> groups;
};

#endif //ENGINE_DATASTRUCTS_H
