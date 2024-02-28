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

struct Transform {
    string name;
    float x;
    float y;
    float z;
    float angle;
};

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

struct Group{
    vector<Transform> transformations; // geometric transforms
    vector<Point> points;              // vertices of the models
    vector<Group> subGroups;           // subgroups of the group
};

struct World {
    Camera *cam = new Camera;
    vector<Group> groups;
};

World world;
string pathModels;
int frame=0,time_=0,timebase=0;

// Camera rotation
float alpha;
float beta;
float radius;

// Axes ON and OFF
bool axes = false;

// Line mode ON and OFF
bool lines = false;


void calcFPS(){
    float fps;
    char s[100];

    frame++;
    time_=glutGet(GLUT_ELAPSED_TIME);

    if (time_ - timebase > 1000) {
        sprintf(s,"Engine: FPS:%4.2f", frame*1000.0/(time_ - timebase));
        timebase = time_;
        frame = 0;
        glutSetWindowTitle(s);
    }
}

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

vector<Point> readFile(string file) {
    vector<Point> res;

    ifstream infile(file, ios::binary | ios::in);

    if (!infile) {
        cout << "Error opening .3d file!";
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
                res.push_back(point);
            }
            catch (const std::invalid_argument& e) {
                cout << ".3d File Lines Invalid" << "\n";
            }
        }
    }

    infile.close();

    return res;
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
void drawPrimitives(vector<Point> points){
    srand(1);
    glBegin(GL_TRIANGLES);
    for(Point pt : points){

        glColor3f(static_cast <float> (rand()) / static_cast <float> (RAND_MAX)
                , static_cast <float> (rand()) / static_cast <float> (RAND_MAX)
                , static_cast <float> (rand()) / static_cast <float> (RAND_MAX));

        glVertex3f(pt.x, pt.y, pt.z);

    }
    glEnd();
}

void drawGroups(vector<Group> groups){
    for(Group g : groups){
        glPushMatrix();
        for (int i = 0; i < g.transformations.size(); ++i) {
            Transform t = g.transformations[i];
            if (t.name.compare("translate")==0) glTranslatef(t.x, t.y, t.z);
            else if (t.name.compare("scale")==0) glScalef(t.x, t.y, t.z);
            else if (t.name.compare("rotate")==0) glRotatef(t.angle,t.x, t.y, t.z);
        }
        drawGroups(g.subGroups);
        drawPrimitives(g.points);
        glPopMatrix();
    }
}

// Draw xyz axes
void drawAxes(){
    glBegin(GL_LINES);

    // draw line for x axis
    glColor3f(1.5, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(100, 0.0, 0.0);

    // draw line for y axis
    glColor3f(0.0, 1.5, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 100, 0.0);

    // draw line for Z axis
    glColor3f(0.0, 0.0, 1.5);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 100);
    glEnd();
}

void renderScene(void) {

    // clear buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glLoadIdentity();

    // set the camera
    gluLookAt(world.cam->position[0], world.cam->position[1], world.cam->position[2],
        world.cam->lookAt[0], world.cam->lookAt[1], world.cam->lookAt[2],
        world.cam->up[0], world.cam->up[1], world.cam->up[2]);


    //Mode
    if (lines)
        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    else glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

    //Axes
    if(axes)
        drawAxes();

    //Primitives
    drawGroups(world.groups);

    calcFPS();

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

            world.cam->position[0] = radius * cos(beta) * sin(alpha);
            world.cam->position[1] = radius * sin(beta);
            world.cam->position[2] = radius * cos(beta) * cos(alpha);
            glutPostRedisplay();
            break;

            // Press O to zoom out
        case 'o':
            radius += 1;

            world.cam->position[0] = radius * cos(beta) * sin(alpha);
            world.cam->position[1] = radius * sin(beta);
            world.cam->position[2] = radius * cos(beta) * cos(alpha);
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
            beta += M_PI/30;

            if(beta >= M_PI/2) {
                beta = M_PI/2 - 0.001;
            }

            break;

        case GLUT_KEY_DOWN:
            beta -= M_PI/30;
            
            if(beta <= -M_PI/2) {
                beta = -M_PI/2 + 0.001;
            }

            break;
    }
    world.cam->position[0] = radius * cos(beta) * sin(alpha);
    world.cam->position[1] = radius * sin(beta);
    world.cam->position[2] = radius * cos(beta) * cos(alpha);
    glutPostRedisplay();
}

bool initGlut(int argc, char** argv) {

// init GLUT and the window
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DEPTH|GLUT_DOUBLE|GLUT_RGBA);
    glutInitWindowPosition(100,100);
    glutInitWindowSize(800,800);
    glutCreateWindow("Engine");

// Required callback registry
    glutDisplayFunc(renderScene);
    glutReshapeFunc(changeSize);
    glutIdleFunc(renderScene);

// Callback registration for keyboard processing
    glutKeyboardFunc(processKeys);
    glutSpecialFunc(processSpecialKeys);

//  OpenGL settings
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);

// enter GLUT's main cycle
    glutMainLoop();
    time_ = glutGet(GLUT_ELAPSED_TIME);
    return true;
}


void parseCamera(XMLElement* camera) {
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
    radius = sqrt(pow(world.cam->position[0], 2) + pow(world.cam->position[1], 2) + pow(world.cam->position[2], 2));
    beta = asin(world.cam->position[1] / radius);
    alpha = asin(world.cam->position[0]/ sqrt(pow(world.cam->position[2], 2) + pow(world.cam->position[0], 2)));
}


Group parseGroup(XMLElement* group, bool father){
    Group g;
    string models = "models";
    string scale = "scale";
    string translate = "translate";
    string rotate = "rotate";
    string subGroup = "group";
    string transform = "transform";
    do {
        XMLElement* element = group->FirstChildElement();

        while (element != nullptr){
            if (models==element->Name()){
                XMLElement* model_xml = element->FirstChildElement("model");

                while(model_xml != nullptr) {
                    const char* strfile = model_xml->Attribute("file");
                    string namefile = strfile;
                    g.points = readFile(pathModels + namefile);

                    model_xml = model_xml->NextSiblingElement();
                }
            }
            else if(transform == element->Name()){
                XMLElement* transform_xml = element->FirstChildElement();
                while (transform_xml != nullptr){
                    if(scale==transform_xml->Name()){
                        float x, y, z;
                        const char * attribute = nullptr;
                        attribute = transform_xml->Attribute("x");
                        x = stof(attribute);
                        attribute = transform_xml->Attribute("y");
                        y = stof(attribute);
                        attribute = transform_xml->Attribute("z");
                        z = stof(attribute);

                        Transform t = {"scale", x, y, z, 0};
                        g.transformations.push_back(t);
                    }
                    else if (translate == transform_xml->Name()){
                        float x, y, z;
                        const char * attribute = nullptr;
                        attribute = transform_xml->Attribute("x");
                        x = stof(attribute);
                        attribute = transform_xml->Attribute("y");
                        y = stof(attribute);
                        attribute = transform_xml->Attribute("z");
                        z = stof(attribute);

                        Transform t = {"translate", x, y, z, 0};
                        g.transformations.push_back(t);
                    }
                    else if (rotate == transform_xml->Name()){
                        float x, y, z, angle;
                        const char * attribute = nullptr;

                        attribute = transform_xml->Attribute("angle");
                        angle = stof(attribute);
                        attribute = transform_xml->Attribute("x");
                        x = stof(attribute);
                        attribute = transform_xml->Attribute("y");
                        y = stof(attribute);
                        attribute = transform_xml->Attribute("z");
                        z = stof(attribute);

                        Transform t = {"rotate", x, y, z, angle};
                        g.transformations.push_back(t);
                    }
                    transform_xml = transform_xml->NextSiblingElement();
                }
            }
            else if (subGroup == element->Name()) {

                Group gr = parseGroup(element, true);
                g.subGroups.push_back(gr);
            }
            element = element->NextSiblingElement();
            if (element == nullptr && father) return g;
        }
        if (!father) world.groups.push_back(g);
        group = group->NextSiblingElement();
    } while (group != nullptr);

    return g;
}


// XML parsing function
bool parseInput(const char* file_name){
    char tmp[256];
    string path = pathModels + file_name;
    strcpy(tmp, path.c_str());

    cout << tmp << endl;

    XMLDocument doc;
    XMLError eResult = doc.LoadFile(tmp);
    XMLCheckResult(eResult);
    

    XMLElement *world_xml = doc.FirstChildElement("world");
    if(world_xml != nullptr){
        XMLElement* camera = world_xml->FirstChildElement("camera");
        if (camera != nullptr) {
            parseCamera(camera);
        }else return false;
        XMLElement *group = world_xml->FirstChildElement("group");
        if(group != nullptr){
            parseGroup(group, false);
        }else return false;
    }else return false;
    
    return true;
}


int main(int argc, char **argv) {
    char tmp[256];
    getcwd(tmp, 256); //tmp which contains the directory
    string path(tmp);
    int found = path.find("Engine"); // finds engine's localization

    replace(path.begin(), path.end(), '\\', '/');
    path.erase(path.begin() + found, path.end());

    pathModels = path + "Models/";

    if (argv[1]!=nullptr && parseInput(argv[1])) {
        if (!initGlut(argc, argv)) {
            cout << ".3d File Invalid\n";
        }
    } else {
        cout << "XML File Invalid\n";
    }
    return 1;
}

