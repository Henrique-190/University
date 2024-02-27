#ifndef ENGINE_CATMULL_ROM_H
#define ENGINE_CATMULL_ROM_H

#include <GL/glew.h>
#include <GL/glut.h>
#include <stdlib.h>
#include <math.h>
#include <vector>
#include <iostream>
#include "dataStructs.h"

void buildRotMatrix(float *x, float *y, float *z, float *m);
void cross(float *a, float *b, float *res);
float length(float *v);
void normalize(float *a);
void getGlobalCatmullRomPoint(float gt, float *pos, float *deriv, std::vector<Point> points);
void renderCatmullRomCurve(std::vector<Point> points);

#endif //ENGINE_CATMULL_ROM_H
