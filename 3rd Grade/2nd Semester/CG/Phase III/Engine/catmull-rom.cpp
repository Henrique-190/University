#include "catmull-rom.h"

using namespace std;

void buildRotMatrix(float *x, float *y, float *z, float *m) {

    m[0] = x[0]; m[1] = x[1]; m[2] = x[2]; m[3] = 0;
    m[4] = y[0]; m[5] = y[1]; m[6] = y[2]; m[7] = 0;
    m[8] = z[0]; m[9] = z[1]; m[10] = z[2]; m[11] = 0;
    m[12] = 0; m[13] = 0; m[14] = 0; m[15] = 1;
}


void cross(float *a, float *b, float *res) {

    res[0] = a[1]*b[2] - a[2]*b[1];
    res[1] = a[2]*b[0] - a[0]*b[2];
    res[2] = a[0]*b[1] - a[1]*b[0];
}


void normalize(float *a) {

    float l = sqrt(a[0]*a[0] + a[1] * a[1] + a[2] * a[2]);
    a[0] = a[0]/l;
    a[1] = a[1]/l;
    a[2] = a[2]/l;
}


float length(float *v) {

    float res = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    return res;

}

void multMatrixVector(float *m, float *v, float *res) {

    for (int j = 0; j < 4; ++j) {
        res[j] = 0;
        for (int k = 0; k < 4; ++k) {
            res[j] += v[k] * m[j * 4 + k];
        }
    }

}


void getCatmullRomPoint(float t, float *p0, float *p1, float *p2, float *p3, float *pos, float *deriv) {
    int i = 0;
    float t_matrix[4] = {t*t*t, t*t, t, 1};
    float t_matrix_derivative[4] = {3*t*t, 2*t, 1, 0};
    float P[3][4] = {{p0[0], p1[0], p2[0], p3[0]},
                     {p0[1], p1[1], p2[1], p3[1]},
                     {p0[2], p1[2], p2[2], p3[2]}};
    float A[3][4];

    // catmull-rom matrix
    float m[4][4] = {	{-0.5f,  1.5f, -1.5f,  0.5f},
                         { 1.0f, -2.5f,  2.0f, -0.5f},
                         {-0.5f,  0.0f,  0.5f,  0.0f},
                         { 0.0f,  1.0f,  0.0f,  0.0f}};

    pos[0] = 0.0; pos[1] = 0.0; pos[2] = 0.0;
    deriv[0] = 0.0; deriv[1] = 0.0; deriv[2] = 0.0;

    // Compute A = M * P
    for(i = 0; i < 4; i++){
        multMatrixVector(&m[0][0], P[i], A[i]);
    }

    // Compute pos = T * A
    for(i = 0; i < 3; i++)
        pos[i] = A[i][0] * t_matrix[0] + A[i][1] * t_matrix[1] + A[i][2] * t_matrix[2] + A[i][3] * t_matrix[3];

    // compute deriv = T' * A
    for(i = 0; i < 3; i++)
        deriv[i] = A[i][0] * t_matrix_derivative[0] + A[i][1] * t_matrix_derivative[1] + A[i][2] *
                t_matrix_derivative[2] + A[i][3] * t_matrix_derivative[3];
}


// given  global t, returns the point in the curve
void getGlobalCatmullRomPoint(float gt, float *pos, float *deriv, vector<Point> p) {

    int pointsCount = p.size();
    float t = gt * pointsCount; // this is the real global t
    int index = floor(t);  // which segment
    t = t - index; // where within  the segment

    // indices store the points
    int indices[4];
    indices[0] = (index + pointsCount-1)%pointsCount;
    indices[1] = (indices[0]+1)%pointsCount;
    indices[2] = (indices[1]+1)%pointsCount;
    indices[3] = (indices[2]+1)%pointsCount;

    float p0[3] = {p[indices[0]].x, p[indices[0]].y, p[indices[0]].z};
    float p1[3] = {p[indices[1]].x, p[indices[1]].y, p[indices[1]].z};
    float p2[3] = {p[indices[2]].x, p[indices[2]].y, p[indices[2]].z};
    float p3[3] = {p[indices[3]].x, p[indices[3]].y, p[indices[3]].z};
    getCatmullRomPoint(t,p0, p1, p2, p3, pos, deriv);
}


void renderCatmullRomCurve(vector<Point> points) {
    float t;
    float dir[3], pos[3];
    glBegin(GL_LINE_LOOP);
    for(t = 0.0 ; t < 1.0 ; t += 0.001){
        getGlobalCatmullRomPoint(t,pos,dir, points);
        glVertex3f(pos[0],pos[1],pos[2]);
    }
    glEnd();
}
