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

struct CatmullRom {
    float angle;
    float time = -1;
    vector<Point> points;
};


struct Camera {
    float position[3] = {0,0,0};
    float lookAt[3] = { 0,0,0 };
    float up[3] = { 0,0,0 };
    float projection[3] = { 0,0,0 };
};

struct Group{
    vector<Transform> transformations; // geometric transforms
    vector<CatmullRom> catmullrom;
    vector<Group> subGroups;           // subgroups of the group
    vector<pair<int,int>> vboIndexes;
};

struct World {
    Camera *cam = new Camera;
    vector<Group> groups;
};

#endif //ENGINE_DATASTRUCTS_H
