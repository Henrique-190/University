#ifndef XMLCheckResult
	#define XMLCheckResult(a_eResult) if (a_eResult != XML_SUCCESS) { printf("Error: %i\n", a_eResult); return a_eResult; }
#endif

#include "catmull-rom.h"
#include "parserXML.h"

#ifdef __linux__
#elif _WIN32
#include <direct.h>
#include <io.h>
#else
#endif

/*              Inicialização de variáveis globais                    */
World world;
int frame=0, time_=0, timebase=0;
vector<float> verticesLoad;
GLuint vertices;

// Rotação da camara
float alpha, betA, radius;
float dx=0, dy=0, dz=0;
float dxPerp=1, dzPerp=0;
float k = 2.5;
//Tamanho do ecrã
float width, height;
bool axes = false, lines = false, click = false, paused = false, firstPerson = false, helpMenu = false;


/*              Funções                    */

/**
 * @brief Calcula os frames por segundo
 */
void calcFPS(){
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

//Draw curves
bool curves = true;


/**
 * @brief Calcula a posição da camara
 */
void spherical2Cartesian() {
    world.cam->position[0] = radius * cos(betA) * sin(alpha);
    world.cam->position[1] = radius * sin(betA);
    world.cam->position[2] = radius * cos(betA) * cos(alpha);
}


/**
 * @brief Altera a dimensão da aplicação
 */
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
    gluPerspective(world.cam->projection[0] ,ratio, world.cam->projection[1] ,world.cam->projection[2]);

    // return to the model view matrix mode
    glMatrixMode(GL_MODELVIEW);
}


/**
 * @brief FALTA
 */
void animatedTranslate(Transform t){
    float yBefore[3] = { 0,1,0 };
    float turnCount = 0;

    float pos[3], deriv[3], Z[3], m[16];

    if(curves) renderCatmullRomCurve(t.points);

    float elapsedTime = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
    float actualTime = elapsedTime - t.time * turnCount;

    if(actualTime > t.time){
        turnCount++;
        actualTime = elapsedTime - t.time*turnCount;
    }

    float gt = actualTime*(!paused)/t.time;

    getGlobalCatmullRomPoint(gt, pos, deriv, t.points);

    if(t.align){
        normalize(deriv);

        // Z = X x Yi-1
        cross(deriv, yBefore, Z);
        normalize(Z);

        // Yi = Z x X
        float newY[3] {0,0,0};
        cross(Z, deriv, newY);
        normalize(newY);

        buildRotMatrix(deriv, newY, Z, m);

        glTranslatef(pos[0], pos[1], pos[2]);
        glMultMatrixf(m);
    }else
        glTranslatef(pos[0], pos[1], pos[2]);
}


/**
 * @brief FALTA
 */
void animatedRotate(Transform t){
    float elapsedTime = glutGet(GLUT_ELAPSED_TIME);
    float angle = 360/(t.time * 1000);

    if(!paused)
        glRotatef(elapsedTime * angle, t.x, t.y, t.z);
}


/**
 * @brief Responsável por tratar as transformações e desenhar os triângulos
 */
void drawGroups(vector<Group> groups, int *index){
    for(const Group& g : groups){
        glPushMatrix();
        for (const auto& t : g.transformations) {
            if (t.name=="translate"){
                if(t.time!=0) animatedTranslate(t);
                else glTranslatef(t.x, t.y, t.z);
            }
            else if (t.name=="scale") glScalef(t.x, t.y, t.z);
            else if (t.name=="rotate"){
                if(t.time!=-1) animatedRotate(t);
                else glRotatef(t.angle,t.x, t.y, t.z);
            }
        }
        for (pair<int,int> t : g.vboIndexes) {
            glBindBuffer(GL_ARRAY_BUFFER, vertices);
            glVertexPointer(3, GL_FLOAT, 0, 0);
            glDrawArrays(GL_TRIANGLES, t.first, t.second);
        }

        drawGroups(g.subGroups, index);

        glPopMatrix();
    }
}


/**
 * @brief Responsável por desenhar os eixos
 */
void drawAxes(){
    glBegin(GL_LINES);

    // draw line for x axis
    glColor3f(1.5, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(1000, 0.0, 0.0);

    // draw line for y axis
    glColor3f(0.0, 1.5, 0.0);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 1000, 0.0);

    // draw line for Z axis
    glColor3f(0.0, 0.0, 1.5);
    glVertex3f(0.0, 0.0, 0.0);
    glVertex3f(0.0, 0.0, 1000);
    glEnd();
    glColor3f(1, 1, 1);
}


/**
 * @brief Texto de ajuda
 */
vector<string> helpText(){
    vector<string> lines;
    lines.emplace_back("______________________________________________");
    lines.emplace_back("AJUDA");
    lines.emplace_back("- Mover o rato faz com que mude a perspetiva");
    lines.emplace_back("‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾");
    lines.emplace_back(" ");
    lines.emplace_back("______________________________________________");
    lines.emplace_back("PRIMEIRA PESSOA");
    lines.emplace_back("- SETA CIMA - Move para a frente");
    lines.emplace_back("- SETA BAIXO - Move para tras");
    lines.emplace_back("- SETA ESQUERDA - Move para a esquerda");
    lines.emplace_back("- SETA DIREITA - Move para a direita");
    lines.emplace_back("‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾");
    lines.emplace_back(" ");
    lines.emplace_back("______________________________________________");
    lines.emplace_back("MODO EXPLORADOR");
    lines.emplace_back("- SETA CIMA - Aproxima");
    lines.emplace_back("- SETA BAIXO - Afasta");
    lines.emplace_back("‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾");
    lines.emplace_back(" ");
    lines.emplace_back("______________________________________________");
    lines.emplace_back("TECLAS ESPECIAIS");
    lines.emplace_back("a - Ativa/desativa eixos");
    lines.emplace_back("l - Altera o preenchimento");
    lines.emplace_back("h - Sai do menu ajuda");
    lines.emplace_back("ESPACO - Para a animacao");
    lines.emplace_back("‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾");

    lines.emplace_back(" ");
    return lines;
}


/**
 * @brief Responsável por mostrar o texto de ajuda
 */
void showHelpMenu(){
    int size, y = 50, x = -15;
    char* text;
    vector<string> lines = helpText();

    glRasterPos2f(x, y) ;
    y-=4;

    glColor3f(1, 1, 1);

    for(string line : lines) {
        text = &line[0];
        size = line.size();
        glRasterPos2f(x, y);

        for (int i = 0; i < size; i++)
            glutBitmapCharacter(GLUT_BITMAP_HELVETICA_12, text[i]);

        y -= 4;
    }
}


/**
 * @brief Renderização do ficheiro xml. Caso a variável helpMenu seja verdadeira, desenha o menu de ajuda
 */
void renderScene() {
    // clear buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glLoadIdentity();
    if (helpMenu){
        gluLookAt(0,0,100,
                    0, 0, 0,
                  0.0f,1.0f,0.0f);

        showHelpMenu();
        glutPostRedisplay();
    }
    else {
        // set the camera
        gluLookAt(world.cam->position[0], world.cam->position[1], world.cam->position[2],
                  world.cam->position[0] + dx, world.cam->position[1] + dy, world.cam->position[2] + dz,
                  world.cam->up[0], world.cam->up[1], world.cam->up[2]);

        //Mode
        if (lines)
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        else glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

        //Primitives
        int index = 0;
        drawGroups(world.groups, &index);

        //Axes
        if (axes)
            drawAxes();

        calcFPS();
    }
    // End of frame
    glutSwapBuffers();
}


/**
 * @brief Inicialização do VBO
 */
void initVBO(const vector<Group> *gs) {
    glGenBuffers(1, &vertices);
    glBindBuffer(GL_ARRAY_BUFFER, vertices);
    glBufferData(GL_ARRAY_BUFFER, sizeof(float) * verticesLoad.size(), verticesLoad.data(), GL_STATIC_DRAW);
}


/**
 * @brief Responsável por gerir as teclas que recebe como input e redireciona para determinadas ações
 */
void processKeys(unsigned char key, int i, int j){
    switch(key){
        case 'h':
            if (!helpMenu)
                paused = true;
            else paused = false;
            helpMenu = !helpMenu;

            glutPostRedisplay();
            break;
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
        case ' ':
            paused ? paused = false : paused = true;
            break;
        case 'c':
            curves ? curves=false : curves = true;
    }
}


/**
 * @brief Responsável por gerir as teclas que recebe como input e redireciona para determinadas ações - Camara
 */
void processSpecialKeys(int key, int xx, int yy) {
    switch (key) {
        // Camera Controls
        case GLUT_KEY_UP:
            if (firstPerson) {
                world.cam->position[0] += dx * k;
                world.cam->position[1] += dy * k;
                world.cam->position[2] += dz * k;
            } else {
                radius -= 1;
                spherical2Cartesian();
                dx = - world.cam->position[0];
                dy = - world.cam->position[1];
                dz = - world.cam->position[2];
            }
            glutPostRedisplay();
            break;

        case GLUT_KEY_DOWN:
            if (firstPerson) {
                world.cam->position[0] -= dx * k;
                world.cam->position[1] -= dy * k;
                world.cam->position[2] -= dz * k;
            } else {
                radius += 1;
                spherical2Cartesian();
                dx = - world.cam->position[0];
                dy = - world.cam->position[1];
                dz = - world.cam->position[2];
            }
            glutPostRedisplay();
            break;

        case GLUT_KEY_RIGHT:
            if (firstPerson) {
                world.cam->position[0] += dxPerp * k;
                world.cam->position[2] += dzPerp * k;
                glutPostRedisplay();
            }
            break;

        case GLUT_KEY_LEFT:
            if (firstPerson) {
                world.cam->position[0] -= dxPerp * k;
                world.cam->position[2] -= dzPerp * k;
                glutPostRedisplay();
            }
            break;
    }
}


/**
 * @brief Responsável por gerir os movimentos do rato que recebe como input e redireciona para determinadas ações - Camara
 */
void processMouseMotion (int xx, int yy){
    if(click){
        // Origin in the center of window
        float centerX = xx - width/2;
        float centerY = -(yy - height/2);

        float alphaStep = centerX / width;
        float betaStep = centerY / height;

        alpha = alphaStep * (2*M_PI);
        betA = betaStep * (M_PI);

        if(betA >= M_PI/2)
            betA = M_PI/2 - 0.001;
        else if(betA <= -M_PI/2)
            betA = -M_PI/2 + 0.001;


        if(firstPerson) {
            dx = sin(alpha);
            dz = -cos(alpha);
            dy = sin(betA);
            dxPerp = sin(alpha + M_PI/2);
            dzPerp = -cos(alpha + M_PI/2);
        }
        else {
            spherical2Cartesian();
            dx = - world.cam->position[0];
            dy = - world.cam->position[1];
            dz = - world.cam->position[2];
        }

        glutPostRedisplay();
    }
}


/**
 * @brief Responsável por autorizar os movimentos do rato
 */
void processMouseButtons(int button, int state, int xx, int yy){
    if(button == GLUT_LEFT_BUTTON && state == GLUT_DOWN)
        click = true;

    else if(state == GLUT_UP)
        click = false;
}


/**
 * @brief Responsável por gerir as opções que recebe como input e redireciona para determinadas ações - Menu Camara
 */
void MenuCamera(int value){
    firstPerson = value == 1;
}


/**
 * @brief Responsável por gerir as opções que recebe como input e redireciona para determinadas ações - Menu Principal
 */
void MenuPrincipal(int value){
    switch(value) {
        case 2:
            lines = !lines;
            break;
        case 3:	// Axis
            axes = !axes;
            break;

        case 4:	// Help
            if (!helpMenu)
                paused = true;
            else paused = false;
            helpMenu = !helpMenu;
            break;

        case 5:	// Exit
            exit(0);
    }
}


/**
 * @brief Responsável modificar a posição inicial da camara
 */
void setupCamera(){
    radius = sqrt(pow(world.cam->position[0], 2) + pow(world.cam->position[1], 2) + pow(world.cam->position[2], 2));
    betA = asin(world.cam->position[1] / radius);
    alpha = asin(world.cam->position[0]/ sqrt(pow(world.cam->position[2], 2) + pow(world.cam->position[0], 2)));

    dx = world.cam->lookAt[0] - world.cam->position[0];
    dy = world.cam->lookAt[1] - world.cam->position[1];
    dz = world.cam->lookAt[2] - world.cam->position[2];
}


/**
 * @brief Inicialização do GLUT
 */
void initGlut(int argc, char** argv) {
    setupCamera();

    // init GLUT and the window
    glutInit(&argc, argv);
    width = glutGet(GLUT_SCREEN_WIDTH);
    height = glutGet(GLUT_SCREEN_HEIGHT);
    glutInitDisplayMode(GLUT_DEPTH|GLUT_DOUBLE|GLUT_RGBA);
    glutInitWindowPosition(width/2,height/2);
    glutInitWindowSize(width,height);
    glutCreateWindow("Engine");

    // Submenu for Camera Mode
    int subMenuCamera = glutCreateMenu(MenuCamera);
    glutAddMenuEntry("Modo Explorador", 0);
    glutAddMenuEntry("Primeira Pessoa", 1);

    //Menu
    glutCreateMenu(MenuPrincipal);
    glutAddSubMenu("Camera", subMenuCamera);
    glutAddMenuEntry("Linhas", 2);
    glutAddMenuEntry("Eixos", 3);
    glutAddMenuEntry("Ajuda", 4);
    glutAddMenuEntry("Sair", 5);

    glutAttachMenu(GLUT_RIGHT_BUTTON);

    // Required callback registry
    glutDisplayFunc(renderScene);
    glutReshapeFunc(changeSize);
    glutIdleFunc(renderScene);

    // Callback registration for keyboard processing
    glutKeyboardFunc(processKeys);
    glutSpecialFunc(processSpecialKeys);
    glutMotionFunc( processMouseMotion);
    glutPassiveMotionFunc( processMouseMotion);
    glutMouseFunc(processMouseButtons);

    #ifndef __APPLE__
        glewInit();
    #endif
    glEnableClientState(GL_VERTEX_ARRAY);

    //  OpenGL settings
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);

    initVBO(&world.groups);

    // enter GLUT's main cycle
    glutMainLoop();
    time_ = glutGet(GLUT_ELAPSED_TIME);
}


/**
 * @brief Função principal
 */
int main(int argc, char **argv) {
    if (argv[1]!=nullptr && parseInput(argv[1], &world, &verticesLoad)) {
        initGlut(argc, argv);
    } else {
        cout << "XML File Invalid\n";
    }
    return 1;
}

