#define _USE_MATH_DEFINES
#include <math.h>

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include <cstring>

//cena para correr em diferentes SO (rever depois se é necessário)
#ifdef __linux__
#include <unistd.h>
#include <sstream>

#elif _WIN32
#include <direct.h>
#include <io.h>
#else
#endif


using namespace std;

struct Point{
    float x;
    float y;
    float z;
};

// Bezier patches
vector<vector<int>> patches;
vector<Point> points;

// Read patch file
bool readFile(string file) {
    string line, number;
    int i = 0, numberPatch = 0;

    char tmp[256];

    getcwd(tmp, 256); //tmp which contains the directory

    string path(tmp);

    int found = path.find("Generator"); // finds generator's localization

    replace(path.begin(), path.end(), '\\', '/');
    path.erase(path.begin() + found, path.end());

    string pathPatch = path + "Models/" + file;

    ifstream infile(pathPatch, ios::binary | ios::in);

    if (!infile) {
        cout << "Error opening patch file!\n";
        return false;
    }

    while (getline(infile, line, '\n')) {
        line.erase(std::remove(line.begin(), line.end(), '\r'), line.end());

        if (i==0){
            numberPatch = stoi(line);
        }
        else if (i <= numberPatch){
            istringstream iss(line);
            vector<int> patch;
            while(getline(iss, number, ',')){
                patch.push_back(stoi(number));
            }
            patches.push_back(patch);
        }
        else if(i > numberPatch + 1){
            istringstream iss(line);
            int j = 0;
            float p[3];

            while (getline(iss, number, ',')){
                p[j] = stof(number);
                j++;
            }
            points.push_back({p[0], p[1], p[2]});
        }
        i++;
    }

    infile.close();
    return true;
}

// Write point in file
void write2File(string res, string file) {
    //generats .3d file
    char tmp[256];

    getcwd(tmp, 256); //tmp which contains the directory

    string path(tmp);

    int found = path.find("Generator"); // finds generator's localization

    replace(path.begin(), path.end(), '\\', '/');
    path.erase(path.begin() + found, path.end());

    string path3d = path + "Models/" + file;

    // Create and open a text file
    ofstream MyFile(path3d);

    // Write to the file
    MyFile << res;

    // Close the file
    MyFile.close();
    cout << "File written successfully\n";
}


bool createPlane(float length, float divisions, string file) {
    string res = "";

    if (length < 0 || divisions < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    Point p1, p2, p3, p4;
    float z1, z2, x1, x2;
    p1.y = p2.y = p3.y = p4.y = 0;

    for (float axeZ = -divisions; axeZ < divisions; axeZ++) {
        z1 = axeZ * length;
        z2 = (axeZ + 1) * length;

        for (float axeX = -divisions; axeX < divisions; axeX++) {
            x1 = axeX * length;
            x2 = (axeX + 1) * length;

            p1 = {x1, 0, z1};
            p2 = {x2, 0, z1};
            p3 = {x2, 0, z2};
            p4 = {x1, 0, z2};

            res = res + to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                    to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                    to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "\n";

            res = res + to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "/" +
                  to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                  to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "\n";
        }
    }

    write2File(res, file);
    return true;
}


bool createBox(int units, int grid, string file) {
    string res = "";

    if (units < 0 || grid < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    //Vetor de crescimento de triângulos
    const int vetores[3][2][3] = { {{ 1,0,0 },{ 0,1,0 }}, {{ 0,0,-1 },{ 0,1,0 }}, {{ 0,0,-1 },{ 1,0,0 }} };

    float length = static_cast<float>(units) / grid;
    float begin = static_cast<float>(units) / 2;

    float i1 = 0 - begin;
    float i2 = 0 - begin;
    float i3 = begin;


    //faz as faces inversas também
    for (int i = 0; i < 2; i++) {
        float a1 = i1;
        float a2 = i2;
        float a3 = i3;

        for (int j = 0; j < grid; j++) {
            //de modo a conseguir subir na grid, é necessário guardar o primeiro ponto da ultima grid
            float aa1 = a1;
            float aa2 = a2;
            float aa3 = a3;

            for (int k = 0; k < grid; k++) {

                float b1 = a1 + (vetores[i][0][0] * length);
                float b2 = a2 + (vetores[i][0][1] * length);
                float b3 = a3 + (vetores[i][0][2] * length);

                float c1 = a1 + (vetores[i][1][0] * length);
                float c2 = a2 + (vetores[i][1][1] * length);
                float c3 = a3 + (vetores[i][1][2] * length);

                float d1 = a1 + ((vetores[i][0][0] + vetores[i][1][0]) * length);
                float d2 = a2 + ((vetores[i][0][1] + vetores[i][1][1]) * length);
                float d3 = a3 + ((vetores[i][0][2] + vetores[i][1][2]) * length);

                if(i==0){
                    //Face frontal
                    res = res + to_string(a1) + ";" + to_string(a2) + ";" + to_string(a3) + "/" +
                          to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                          to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "\n";

                    res = res + to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                          to_string(d1) + ";" + to_string(d2) + ";" + to_string(d3) + "/" +
                          to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "\n";


                    //Face inversa
                    res = res + to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "/" +
                            to_string(0-a1) + ";" + to_string(0-a2) + ";" + to_string(0-a3) + "/" +
                            to_string(0-c1) + ";" + to_string(0-c2) + ";" + to_string(0-c3) + "\n";

                    res = res + to_string(0-d1) + ";" + to_string(0-d2) + ";" + to_string(0-d3) + "/" +
                          to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "/" +
                          to_string(0-c1) + ";" + to_string(0-c2) + ";" + to_string(0-c3) + "\n";
                } else if (i==1){
                    //Face Inversa
                    res = res + to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                            to_string(a1) + ";" + to_string(a2) + ";" + to_string(a3) + "/" +
                            to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "\n";

                    res = res + to_string(d1) + ";" + to_string(d2) + ";" + to_string(d3) + "/" +
                            to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                            to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "\n";

                    //Face frontal
                    res = res + to_string(0-a1) + ";" + to_string(0-a2) + ";" + to_string(0-a3) + "/" +
                            to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "/" +
                            to_string(0-c1) + ";" + to_string(0-c2) + ";" + to_string(0-c3) + "\n";

                    res = res + to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "/" +
                            to_string(0-d1) + ";" + to_string(0-d2) + ";" + to_string(0-d3) + "/" +
                            to_string(0-c1) + ";" + to_string(0-c2) + ";" +  to_string(0-c3) + "\n";
                }

                a1 = b1;
                a2 = b2;
                a3 = b3;
            }

            a1 = aa1 + (vetores[i][1][0] * length);
            a2 = aa2 + (vetores[i][1][1] * length);
            a3 = aa3 + (vetores[i][1][2] * length);

        }
    }

    i1 = 0 - begin;
    i2 = begin;
    i3 = begin;
    float a1 = i1;
    float a2 = i2;
    float a3 = i3;

    for (int i = 0; i < grid; i++) {
        float aa1 = a1;
        float aa2 = a2;
        float aa3 = a3;

        for (int j = 0; j < grid; j++) {
            float b1 = a1 + (vetores[2][0][0] * length);
            float b2 = a2 + (vetores[2][0][1] * length);
            float b3 = a3 + (vetores[2][0][2] * length);

            float c1 = a1 + (vetores[2][1][0] * length);
            float c2 = a2 + (vetores[2][1][1] * length);
            float c3 = a3 + (vetores[2][1][2] * length);


            float d1 = a1 + ((vetores[2][0][0] + vetores[2][1][0]) * length);
            float d2 = a2 + ((vetores[2][0][1] + vetores[2][1][1]) * length);
            float d3 = a3 + ((vetores[2][0][2] + vetores[2][1][2]) * length);

            //Face de cima
            res = res + to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "/" +
                    to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                  to_string(a1) + ";" + to_string(a2) + ";" + to_string(a3) + "\n";

            res = res + to_string(b1) + ";" + to_string(b2) + ";" + to_string(b3) + "/" +
                    to_string(c1) + ";" + to_string(c2) + ";" + to_string(c3) + "/" +
                    to_string(d1) + ";" + to_string(d2) + ";" + to_string(d3) + "\n";

            //Face de baixo
            res = res + to_string(0-c1) + ";" + to_string(0-c2) + ";" + to_string(0-c3) + "/" +
                    to_string(0-a1) + ";" + to_string(0-a2) + ";" + to_string(0-a3) + "/" +
                    to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "\n";

            res = res + to_string(0-b1) + ";" + to_string(0-b2) + ";" + to_string(0-b3) + "/" +
                  to_string(0-d1) + ";" + to_string(0-d2) + ";" + to_string(0-d3) + "/" +
                  to_string(0-c1) + ";" + to_string(0-c2) + ";" + to_string(0-c3) + "\n";

            a1 = b1;
            a2 = b2;
            a3 = b3;
        }
        a1 = aa1 + (vetores[2][1][0] * length);
        a2 = aa2 + (vetores[2][1][1] * length);
        a3 = aa3 + (vetores[2][1][2] * length);

    }

    write2File(res, file);
    return true;
}


bool createSphere(float radius, int slices, int stacks, string file) {
    string res = "";

    if (radius < 0 || slices < 0 || stacks < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    float alpha;
    float aStep = (2*M_PI)/slices;
    float beta;
    float bStep = M_PI/stacks;

    Point p1, p2, p3, p4;

    for(float b=-(stacks/2); b<(stacks/2); b++) {
        beta=(b*bStep);

        for(float a=0; a<slices; a++) {
            alpha=(aStep*a);

            p1 = {radius*cosf(beta)*sinf(alpha),
                  radius*sinf(beta),
                  radius*cosf(beta)*cosf(alpha)};

            p2 = {radius*cosf(beta)*sinf(aStep*(a+1)),
                  p1.y,
                  radius*cosf(beta)*cosf(aStep*(a+1))};

            p3 = {radius*cosf((b+1)*bStep)*sinf(aStep*(a+1)),
                    radius*sinf((b+1)*bStep),
                    radius*cosf((b+1)*bStep)*cosf(aStep*(a+1))};

            p4 = {radius*cosf((b+1)*bStep)*sinf(alpha),
                    p3.y,
                    radius*cosf((b+1)*bStep)*cosf(alpha)};

            res = res + to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                  to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                  to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "\n";

            res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                  to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "/" +
                  to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "\n";

        }
    }

    write2File(res, file);
    return true;
}


bool createCone(float radius, float height, int slices, int stacks, string file) {
    string res = "";

    if (radius < 0 || height < 0 || slices < 0 || stacks < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    //Calcute height of each stack
    float stackHeight = height / stacks;

    float angle = (2 * M_PI) / slices;
    Point p1, p2, p3, p4;

    //Circunference of points, given slices height and radius
    for (float i = 0; i < stacks; i++) {
        float stackRadius = ((radius * (height - (stackHeight * i))) / height);
        float stackRadius2 = ((radius * (height - (stackHeight * (i + 1)))) / height);

        for (int c = 0; c < slices; c++) {
            // Sides
            float alpha = angle * c;
            float alpha2 = angle * (c + 1);

            float p1x = cos(alpha) * stackRadius;
            float p1y = stackHeight * i;
            float p1z = -sin(alpha) * stackRadius;
            float p2x = cos(alpha2) * stackRadius;
            float p2y = stackHeight * i;
            float p2z = -sin(alpha2) * stackRadius;
            float p3x = cos(alpha) * stackRadius2;
            float p3y = stackHeight * (i + 1);
            float p3z = -sin(alpha) * stackRadius2;
            float p4x = cos(alpha2) * stackRadius2;
            float p4y = stackHeight * (i + 1);
            float p4z = -sin(alpha2) * stackRadius2;
            p1 ={cos(alpha) * stackRadius, stackHeight * i, -sin(alpha) * stackRadius};
            p2 ={cos(alpha2) * stackRadius, stackHeight * i, -sin(alpha2) * stackRadius};
            p3 ={cos(alpha) * stackRadius2, stackHeight * (i + 1), -sin(alpha) * stackRadius2};
            p4 ={cos(alpha2) * stackRadius2, stackHeight * (i + 1), -sin(alpha2) * stackRadius2};

            if (i == 0) {
                res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                        to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                        to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "\n";

                res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                        to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                        to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "\n";

                // Base
                res = res + to_string(0.000000) + ";" + to_string(0.000000) + ";" + to_string(0.000000) + "/" +
                      to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                        to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "\n";
            }
            else if (i != (stacks - 1)) {
                res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                      to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                      to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "\n";

                res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                      to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                      to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "\n";
            }
            else {
                res = res + to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                      to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                      to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "\n";
            }
        }
    }
    write2File(res, file);
    return true;
}

bool createCylinder(float radius, float height, int slices, string file) {
    string res = "";

    if (radius < 0 || height < 0 || slices < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    float sectorStep = M_PI * 2 / slices;

    for (int i = 0; i <= slices; i++) {
        float alpha = i * sectorStep;
        float nextAlpha = sectorStep + alpha;
        float p1x = radius * sin(alpha);
        float p1z = radius * cos(alpha);
        float p2x = radius * sin(nextAlpha);
        float p2z = radius * cos(nextAlpha);


        //Base Top
        res = res + to_string(0.0f) + ";" + to_string(height) + ";" + to_string(0.0f) + "/" +
                to_string(p1x) + ";" + to_string(height) + ";" + to_string(p1z) + "/" +
                to_string(p2x) + ";" + to_string(height) + ";" + to_string(p2z) + "\n";

        //Base Bot
        res = res + to_string(0.0f) + ";" + to_string(0.0f) + ";" + to_string(0.0f) + "/" +
              to_string(p2x) + ";" + to_string(0.0f) + ";" + to_string(p2z) + "/" +
              to_string(p1x) + ";" + to_string(0.0f) + ";" + to_string(p1z) + "\n";

        //Side1
        res = res + to_string(p1x) + ";" + to_string(0.0f) + ";" + to_string(p1z) + "/" +
              to_string(p2x) + ";" + to_string(height) + ";" + to_string(p2z) + "/" +
              to_string(p1x) + ";" + to_string(height) + ";" + to_string(p1z) + "\n";

        //Side2
        res = res + to_string(p1x) + ";" + to_string(0.0f) + ";" + to_string(p1z) + "/" +
              to_string(p2x) + ";" + to_string(0.0f) + ";" + to_string(p2z) + "/" +
              to_string(p2x) + ";" + to_string(height) + ";" + to_string(p2z) + "\n";
    }

    write2File(res, file);
    return true;
}

bool createTorus(float in_radius, float  out_radius, int slices, int stacks, string file){
    string res = "";

    if (in_radius < 0 || out_radius < 0 || slices < 0 || stacks < 0) return false;

    int found = file.find(".3d");
    if(found <= 0) return false;

    float R = ((out_radius - in_radius) / 2) + in_radius;
    float r = ((out_radius - in_radius) / 2);
    float teta = (M_PI * 2) / slices;
    float fi = (M_PI * 2) / stacks;
    Point p1, p2, p3, p4;

    for (float i = 0; i < slices; i++) {
        float tStep = i * teta;
        float next_tStep = tStep + teta;
        for (float j = 0; j < stacks; j++) {
            float fStep = j * fi;
            float next_fStep = fStep + fi;

            p1 = {R*cosf(tStep) + r * cosf(fStep) * cosf(tStep),
                  R*sinf(tStep) + r * cosf(fStep) * sinf(tStep),
                  r* sinf(fStep)};
            p2 = {R*cosf(next_tStep) + r * cosf(fStep) * cosf(next_tStep),
                  R*sinf(next_tStep) + r * cosf(fStep) * sinf(next_tStep),
                  r* sinf(fStep)};
            p3 = {R*cosf(next_tStep) + r * cosf(next_fStep) * cosf(next_tStep),
                  R*sinf(next_tStep) + r * cosf(next_fStep) * sinf(next_tStep),
                  r* sinf(next_fStep)};
            p4 = {R*cosf(tStep) + r * cosf(next_fStep) * cosf(tStep),
                  R*sinf(tStep) + r * cosf(next_fStep) * sinf(tStep),
                  r* sinf(next_fStep)};


            res = res + to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                  to_string(p2.x) + ";" + to_string(p2.y) + ";" + to_string(p2.z) + "/" +
                  to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "\n";


            res = res + to_string(p1.x) + ";" + to_string(p1.y) + ";" + to_string(p1.z) + "/" +
                  to_string(p3.x) + ";" + to_string(p3.y) + ";" + to_string(p3.z) + "/" +
                  to_string(p4.x) + ";" + to_string(p4.y) + ";" + to_string(p4.z) + "\n";
        }
    }

    write2File(res, file);
    return true;
}

Point multMatrixVector(float u[4], vector<vector<Point>> matrix, float v[4]){
    // aux = U * M
    vector<Point> aux(4);
    for (int i = 0; i < 4; ++i) {
        aux[i] = {0,0,0};
    }

    for (int j = 0; j < 4; ++j) {
        for (int k = 0; k < 4; ++k) {

            Point p = matrix[k][j];
            float x = p.x;
            float y = p.y;
            float z = p.z;
            p = {x*u[k], y*u[k], z*u[k]};

            Point p_aux = aux[j];
            aux[j] = {p.x+p_aux.x, p.y+p_aux.y, p.z+p_aux.z};
        }
    }

    // final = aux * V
    Point final = {0,0,0};

    for(int j =0; j<4;++j){
        final.x = final.x + (aux[j].x * v[j]);
        final.y = final.y + (aux[j].y * v[j]);
        final.z = final.z + (aux[j].z * v[j]);
    }
    return final;
}

vector<vector<Point>> matrixMultiplication(Point p[4][4], float m[4][4]){
    // res = M * P
    vector<vector<Point>> res(4,vector<Point>(4));
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            res[i][j] = {0,0,0};
        }
    }

    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            for (int k = 0; k < 4; ++k) {
                Point point = p[k][j];
                float x = point.x;
                float y = point.y;
                float z = point.z;
                point = {x*m[i][k], y*m[i][k], z*m[i][k]};

                Point aux = res[i][j];
                res[i][j] = {point.x + aux.x, point.y + aux.y, point.z + aux.z};
            }
        }
    }

    // result = res * Mt
    vector<vector<Point>> result(4,vector<Point>(4));
    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            result[i][j] = {0,0,0};
        }
    }

    for (int i = 0; i < 4; ++i) {
        for (int j = 0; j < 4; ++j) {
            for (int k = 0; k < 4; ++k) {
                Point point = res[i][k];
                float x = point.x;
                float y = point.y;
                float z = point.z;
                point = {x*m[k][j], y*m[k][j], z*m[k][j]};

                Point aux = result[i][j];
                result[i][j] = {point.x + aux.x, point.y + aux.y, point.z + aux.z};
            }
        }
    }
    return result;
}

string calcBezier(Point p[4][4], int tessellation){
    float pu=0, pv=0;
    vector<vector<Point>> grid(tessellation+1, vector<Point>(tessellation+1));
    for (int j = 0; j <= tessellation; j++) {
        for (int k = 0; k <= tessellation; k++) {
            grid[j][k] = {0,0,0};
        }
    }
    float m[4][4] = {{-1, 3,  -3, 1},
                     {3, -6, 3, 0},
                     {-3, 3, 0, 0},
                     {1, 0, 0, 0}};
    string res;

    vector<vector<Point>> matrix = matrixMultiplication(p, m);

    float step = 1.f/(float)tessellation;
    for (int i = 0; i <= tessellation; i++) {
        pu = (float)i*step;
        //pv = ((float) i) / ((float) tessellation);
        float u_vector[4] = {(float)pow(pu,3), (float)pow(pu,2),pu,1};
        //float v_vector[4] = {(float)pow(pv,3), (float)pow(pv,2),pv,1};
        for (int j = 0; j <= tessellation; j++) {
            pv = (float)j*step;
            //pu = ((float) j) / ((float) tessellation);
            //float u_vector[4] = {(float)pow(pu,3), (float)pow(pu,2),pu,1};
            float v_vector[4] = {(float)pow(pv,3), (float)pow(pv,2),pv,1};
            grid[i][j] = multMatrixVector(u_vector, matrix, v_vector);
        }
    }

    for (int j = 0; j < tessellation; j++) {
        for (int k = 0; k < tessellation; k++) {

            res += to_string(grid[j][k].x) + ";" + to_string(grid[j][k].y) + ";" + to_string(grid[j][k].z) + "/" +
                   to_string(grid[j+1][k].x) + ";" + to_string(grid[j+1][k].y) + ";" + to_string(grid[j+1][k].z) + "/" +
                   to_string(grid[j][k+1].x) + ";" + to_string(grid[j][k+1].y) + ";" + to_string(grid[j][k+1].z) + "\n";

            res +=  to_string(grid[j+1][k].x) + ";" + to_string(grid[j+1][k].y) + ";" + to_string(grid[j+1][k].z) + "/" +
                    to_string(grid[j+1][k+1].x) + ";" + to_string(grid[j+1][k+1].y) + ";" + to_string(grid[j+1][k+1].z) + "/" +
                    to_string(grid[j][k+1].x) + ";" + to_string(grid[j][k+1].y) + ";" + to_string(grid[j][k+1].z) + "\n";
        }
    }
    return res;
}

bool bezier(string inFile, int tessellation, string outFile){
    string res;
    if (tessellation < 0) return false;

    if (!readFile(inFile)) return false;

    //Calc points of grid
    Point m[4][4] = {0};
    for (int i = 0; i < patches.size(); i++) {
        for (int column = 0; column < 4; column++) {
            for (int row = 0; row < 4; row++) {
                m[row][column] = points[patches[i][row + column * 4]];
            }
        }

        res += calcBezier(m, tessellation);
    }

    write2File(res, outFile);
    return true;
}

bool isNumber(const string& str){
    for (char const& c : str) {
        if (std::isdigit(c) == 0) return false;
    }
    return true;
}

bool parseInput(string primitive, vector<string> params) {
    bool res = true;

    if (primitive == "box") {
        if (params.size() == 3 && isNumber(params[0]) && isNumber(params[1])) {
            res = createBox(stoi(params[0]), stoi(params[1]), params[2]);
        }
        else res = false;
    }
    else if (primitive == "sphere") {
        if (params.size() == 4 && isNumber(params[0]) &&
            isNumber(params[1]) && isNumber(params[2])) {
            res = createSphere(stod(params[0]), stoi(params[1]), stoi(params[2]), params[3]);
        }
        else res = false;
    }
    else if (primitive == "cone") {
        if (params.size() == 5 && isNumber(params[0]) && isNumber(params[1]) && isNumber(params[2]) && isNumber(params[3])) {
            res = createCone(stod(params[0]), stod(params[1]), stoi(params[2]), stoi(params[3]), params[4]);
        }
        else res = false;
    }
    else if (primitive == "plane") {
        if (params.size() == 3 && isNumber(params[0]) && isNumber(params[1])) {
            res = createPlane(stod(params[0]), stod(params[1]), params[2]);
        }
        else res = false;
    }
    else if (primitive == "cylinder") {
        if (params.size() == 4 && isNumber(params[0]) && isNumber(params[1]) && isNumber(params[2])) {
            res = createCylinder(stod(params[0]), stod(params[1]), stoi(params[2]), params[3]);
        }
        else res = false;
    }
    else if (primitive == "torus") {
        if (params.size() == 5 && isNumber(params[0]) && isNumber(params[1]) && isNumber(params[2]) &&
            isNumber(params[3])) {
            res = createTorus(stod(params[0]), stod(params[1]), stoi(params[2]), stoi(params[3]), params[4]);
        } else res = false;
    }
    else if(primitive == "bezier"){
        if (params.size() == 3 && isNumber(params[1])){
            res = bezier(params[0], stoi(params[1]), params[2]);
        } else res = false;
    }
    return res;
}

int main(int argc, char const *argv[]){

    if (argc == 1) {
        cout << "Not enough arguments\n";
        return 1;
    }

    string primitive(argv[1]);
    vector<string> parameters;

    transform(primitive.begin(), primitive.end(), primitive.begin(), ::tolower);

    for (int i = 2; i < argc; ++i) {
        parameters.push_back(argv[i]);
    }

    if(!parseInput(primitive, parameters)){
        cout << "Arguments are invalid\n";
    }

    return 1;
}

