#ifndef XMLCheckResult
	#define XMLCheckResult(a_eResult) if (a_eResult != XML_SUCCESS) { printf("Error: %i\n", a_eResult); return a_eResult; }
#endif

#define  _USE_MATH_DEFINES
#include <math.h>
#include <stdlib.h>
#include <GL/glut.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include "tinyxml2.h"
#include <cstring>
#include <string>
#include <algorithm>
#include <stdio.h>

#ifdef __linux__
#include <unistd.h>
#elif _WIN32
#include <direct.h>
#include <io.h>
#else
#endif

using namespace tinyxml2;
using namespace std;

struct Point {
    float x;
    float y;
    float z;
};

struct Camera {
    float position[3] = {0,0,0};
    float lookAt[3] = { 0,0,0 };
    float up[3] = { 0,0,0 };
    float projection[3] = { 0,0,0 };
};

struct World {
    Camera *cam = new Camera;
    vector<string> files;
    vector<Point> points;
};

World world;

// Camera rotation
float alpha;
float betA;
float radius;

// Axes ON and OFF
bool axes = false;

// Line mode ON and OFF
bool lines = false;


int nthOccurrence(const std::string& str, const std::string& findMe, int nth)
{
    size_t  pos = 0;
    int     cnt = 0;

    while (cnt != nth && pos != std::string::npos)
    {
        pos += 1;
        pos = str.find(findMe, pos);
        cnt++;
    }
    return pos;
}

bool readFile(string file) {

    ifstream infile(file, ios::binary | ios::in);

    if (!infile) {
        return false;
    }

    string line;

    while (getline(infile, line, '\n')) {
        line.erase(std::remove(line.begin(), line.end(), '\r'), line.end());

        int previndexI = 0;
        int nextindexI = 0;
        for (int i = 1; i <= 3; i++) {
            previndexI = nextindexI;
            nextindexI = nthOccurrence(line, "/", i);

            string ponto = line.substr(previndexI, nextindexI - previndexI);
            nextindexI++;

            try {
                float previndexJ = 0;
                float nextindexJ = 0;
                float coordenadas[3] = { 0,0,0 };
                for (int j = 1; j <= 3; j++) {
                    previndexJ = nextindexJ;
                    nextindexJ = nthOccurrence(ponto, ";", j);
                    string pt = ponto.substr(previndexJ, nextindexJ - previndexJ);
                    coordenadas[j-1] = stof(pt);
                    nextindexJ++;
                }
                Point point = { coordenadas[0], coordenadas[1], coordenadas[2] };
                world.points.push_back(point);
            }
            catch (const std::invalid_argument& e) {
                cout << ".3d File Lines Invalid" << "\n";
                return false;
            }
        }
    }

    infile.close();

    return true;
}

void changeSize(int w, int h) {

    // Prevent a divide by zero, when window is too short
    // (you cant make a window with zero width).
    if(h == 0)
        h = 1;

    // compute window's aspect ratio
    float ratio = w * 1.0 / h;

    // Set the projection matrix as current
    glMatrixMode(GL_PROJECTION);
    // Load Identity Matrix
    glLoadIdentity();

    // Set the viewport to be the entire window
    glViewport(0, 0, w, h);

    // Set perspective
    gluPerspective(45.0f ,ratio, 1.0f ,1000.0f);

    // return to the model view matrix mode
    glMatrixMode(GL_MODELVIEW);
}

// Draw triangles based on the vertices previously stored
void drawPrimitives(){
    glBegin(GL_TRIANGLES);
    for(Point pt : world.points){

        glColor3f(static_cast <float> (rand()) / static_cast <float> (RAND_MAX)
                , static_cast <float> (rand()) / static_cast <float> (RAND_MAX)
                , static_cast <float> (rand()) / static_cast <float> (RAND_MAX));

        glVertex3f(pt.x, pt.y, pt.z);

    }
    glEnd();
}

// Draw xyz axes
void drawAxes(){
    glBegin(GL_LINES);

    // draw line for x axis
    glColor3f(1.5, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(1.5, 0.0, 0.0);

    // draw line for y axis
    glColor3f(0.0, 1.5, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 1.5, 0.0);

    // draw line for Z axis
    glColor3f(0.0, 0.0, 1.5);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 1.5);
    glEnd();
}

void renderScene(void) {

    // clear buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glLoadIdentity();


    gluLookAt(world.cam->position[0], world.cam->position[1], world.cam->position[2],
        world.cam->lookAt[0], world.cam->lookAt[1], world.cam->lookAt[2],
        world.cam->up[0], world.cam->up[1], world.cam->up[2]);

    // set the camera


    //Mode
    if (lines)
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    else glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

    //Axes
    if(axes)
        drawAxes();

    //Primitives
    drawPrimitives();

    // End of frame
    glutSwapBuffers();
}

// Change display mode or draw axes with keyboard
void processKeys(unsigned char key, int i, int j){
    switch(key){

        // Press L to set ON and OFF line display mode
        case 'l':
            if(lines)
                lines = false;
            else lines = true;

            glutPostRedisplay();
            break;

            // Press A to set ON and OFF the axes
        case 'a':
            if(axes)
                axes = false;
            else axes = true;
            glutPostRedisplay();
            break;

            // Press I to zoom in
        case 'i':
            radius -= 1;
            if(radius < 0)
                radius = 0;

            world.cam->position[0] = radius * cos(betA) * sin(alpha);
            world.cam->position[1] = radius * sin(betA);
            world.cam->position[2] = radius * cos(betA) * cos(alpha);
            glutPostRedisplay();
            break;

            // Press O to zoom out
        case 'o':
            radius += 1;

            world.cam->position[0] = radius * cos(betA) * sin(alpha);
            world.cam->position[1] = radius * sin(betA);
            world.cam->position[2] = radius * cos(betA) * cos(alpha);
            glutPostRedisplay();
            break;
    }
}


//Move camera with keyboard
void processSpecialKeys(int key, int xx, int yy) {
    
    switch(key){
        case GLUT_KEY_LEFT:
            alpha -= M_PI/30;
            break;

        case GLUT_KEY_RIGHT:
            alpha += M_PI/30;
            break;

        case GLUT_KEY_UP:
            betA += M_PI / 30;

            if(betA >= M_PI / 2) {
                betA = M_PI / 2 - 0.001;
            }

            break;

        case GLUT_KEY_DOWN:
            betA -= M_PI / 30;
            
            if(betA <= -M_PI / 2) {
                betA = -M_PI / 2 + 0.001;
            }

            break;
    }
    world.cam->position[0] = radius * cos(betA) * sin(alpha);
    world.cam->position[1] = radius * sin(betA);
    world.cam->position[2] = radius * cos(betA) * cos(alpha);
    glutPostRedisplay();
}

bool initGlut(int argc, char** argv) {

    bool res;

    char tmp[256];

    getcwd(tmp, 256); //tmp which contains the directory

    string path(tmp);

    int found = path.find("Engine"); // finds generator's localization

    replace(path.begin(), path.end(), '\\', '/');
    path.erase(path.begin() + found, path.end());

    path = path + "Models/";


    for (int i = 0; i < world.files.size(); i++) {
        string file = path + world.files[i];
        res = readFile(file);
        if(!res) return false;
    }

// init GLUT and the window
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DEPTH|GLUT_DOUBLE|GLUT_RGBA);
    glutInitWindowPosition(100,100);
    glutInitWindowSize(800,800);
    glutCreateWindow("Engine");

// Required callback registry
    glutDisplayFunc(renderScene);
    glutReshapeFunc(changeSize);

// Callback registration for keyboard processing
    glutKeyboardFunc(processKeys);
    glutSpecialFunc(processSpecialKeys);

//  OpenGL settings
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);

// enter GLUT's main cycle
    glutMainLoop();
    return true;
}

bool parseInput(const char* file_name){
    char tmp[256];

    getcwd(tmp, 256); //tmp which contains the directory

    string path(tmp);

    int found = path.find("Engine"); // finds engine's localization
    
    
    replace(path.begin(), path.end(), '\\', '/');
   
    path.erase(path.begin() + found, path.end());
    

    path = path + "Models/" + file_name;
    
    strcpy(tmp, path.c_str());

    XMLDocument doc;
    XMLError eResult = doc.LoadFile(tmp);
    XMLCheckResult(eResult);
    

    
    XMLElement* position_xml;
    XMLElement* model_xml;

    XMLElement *world_xml = doc.FirstChildElement("world");
    if(world_xml != nullptr){
        XMLElement* camera = world_xml->FirstChildElement("camera");
        if (camera != nullptr) {
            XMLElement* position_xml = camera->FirstChildElement("position");
            if (position_xml != nullptr) {
                world.cam->position[0] = stof(position_xml->Attribute("x"));
                world.cam->position[1] = stof(position_xml->Attribute("y"));
                world.cam->position[2] = stof(position_xml->Attribute("z"));
            }

            XMLElement* lookAt_xml = camera->FirstChildElement("lookAt");
            if (lookAt_xml != nullptr) {
                world.cam->lookAt[0] = stof(lookAt_xml->Attribute("x"));
                world.cam->lookAt[1] = stof(lookAt_xml->Attribute("y"));
                world.cam->lookAt[2] = stof(lookAt_xml->Attribute("z"));
            }

            XMLElement* up_xml = camera->FirstChildElement("up");
            if (up_xml != nullptr) {
                world.cam->up[0] = stof(up_xml->Attribute("x"));
                world.cam->up[1] = stof(up_xml->Attribute("y"));
                world.cam->up[2] = stof(up_xml->Attribute("z"));
            }

            XMLElement* projection_xml = camera->FirstChildElement("projection");
            if (projection_xml != nullptr) {
                world.cam->projection[0] = stof(projection_xml->Attribute("fov"));
                world.cam->projection[1] = stof(projection_xml->Attribute("near"));
                world.cam->projection[2] = stof(projection_xml->Attribute("far"));
            }
        }
        XMLElement *group = world_xml->FirstChildElement("group");
        if(group != nullptr){
            XMLElement *models = group->FirstChildElement("models");
            if(models != nullptr){
                model_xml = models->FirstChildElement("model");
            }else return false;
        }else return false;
    }else return false;
    while(model_xml != nullptr) {
        const char* strfile;

        strfile = model_xml->Attribute("file");
        string namefile = strfile;
        world.files.push_back(namefile);

        model_xml = model_xml->NextSiblingElement();
    }
    radius = sqrt(pow(world.cam->position[0], 2) + pow(world.cam->position[1], 2) + pow(world.cam->position[2], 2));

    betA = asin(world.cam->position[1] / radius);
    alpha = asin(world.cam->position[0]/ sqrt(pow(world.cam->position[2], 2) + pow(world.cam->position[0], 2)));

    return true;
}



int main(int argc, char **argv) {
    if (argv[1]!=nullptr && parseInput(argv[1])) {
        if (!initGlut(argc, argv)) {
            cout << ".3d File Invalid\n";
        }
    } else {
        cout << "XML File Invalid\n";
    }
    return 1;
}

