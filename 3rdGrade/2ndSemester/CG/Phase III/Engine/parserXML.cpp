#include <map>
#include "parserXML.h"

string pathModels;

int nthOccurrence(const std::string& str, const std::string& findMe, int nth){
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

        int previndexI;
        int nextindexI = 0;
        for (int i = 1; i <= 3; i++) {
            previndexI = nextindexI;
            nextindexI = nthOccurrence(line, "/", i);

            string ponto = line.substr(previndexI, nextindexI - previndexI);
            nextindexI++;

            try {
                float previndexJ;
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

Camera* parseCamera(XMLElement* camera) {
    Camera *cam = new Camera;
    XMLElement* position_xml = camera->FirstChildElement("position");
    if (position_xml != nullptr) {
        cam->position[0] = stof(position_xml->Attribute("x"));
        cam->position[1] = stof(position_xml->Attribute("y"));
        cam->position[2] = stof(position_xml->Attribute("z"));
    }

    XMLElement* lookAt_xml = camera->FirstChildElement("lookAt");
    if (lookAt_xml != nullptr) {
        cam->lookAt[0] = stof(lookAt_xml->Attribute("x"));
        cam->lookAt[1] = stof(lookAt_xml->Attribute("y"));
        cam->lookAt[2] = stof(lookAt_xml->Attribute("z"));
    }

    XMLElement* up_xml = camera->FirstChildElement("up");
    if (up_xml != nullptr) {
        cam->up[0] = stof(up_xml->Attribute("x"));
        cam->up[1] = stof(up_xml->Attribute("y"));
        cam->up[2] = stof(up_xml->Attribute("z"));
    }

    XMLElement* projection_xml = camera->FirstChildElement("projection");
    if (projection_xml != nullptr) {
        cam->projection[0] = stof(projection_xml->Attribute("fov"));
        cam->projection[1] = stof(projection_xml->Attribute("near"));
        cam->projection[2] = stof(projection_xml->Attribute("far"));
    }
    return cam;
}

std::map<string,pair<int,int>> ficheiros;
int indexo = 0;
Group parseGroup(XMLElement* group, bool father, vector<float> *vert){
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
                    if (ficheiros.find(pathModels + namefile) != ficheiros.end()) {
                        auto it = ficheiros.find(pathModels + namefile);
                        g.vboIndexes.push_back(it->second);
                    }
                    else {
                        vector<Point> pontosFicheiro = readFile(pathModels + namefile);
                        ficheiros.insert({pathModels + namefile, pair<int,int>{indexo,pontosFicheiro.size()}});
                        g.vboIndexes.emplace_back(indexo,pontosFicheiro.size());
                        indexo += pontosFicheiro.size();
                        for (Point p : pontosFicheiro){
                            vert->push_back(p.x);
                            vert->push_back(p.y);
                            vert->push_back(p.z);
                        }
                        //pontos.insert(pontos.end(), pontosFicheiro.begin(), pontosFicheiro.end());
                    }

                    model_xml = model_xml->NextSiblingElement();
                }
            }
            else if(transform == element->Name()){
                XMLElement* transform_xml = element->FirstChildElement();
                while (transform_xml != nullptr){
                    if(scale==transform_xml->Name()){
                        float x, y, z;
                        const char * attribute;
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
                        if (transform_xml->Attribute("x") != nullptr && transform_xml->Attribute("y") != nullptr &&
                            transform_xml->Attribute("z") != nullptr) {
                            float x, y, z;
                            const char *attribute;
                            attribute = transform_xml->Attribute("x");
                            x = stof(attribute);
                            attribute = transform_xml->Attribute("y");
                            y = stof(attribute);
                            attribute = transform_xml->Attribute("z");
                            z = stof(attribute);

                            Transform t = {"translate", x, y, z, 0};
                            g.transformations.push_back(t);
                        }
                        else {
                            vector<Point> pontos;
                            float time = -1;
                            string point = "point";
                            bool align = false;
                            if (transform_xml->Attribute("time") != nullptr) {
                                time = stof(transform_xml->Attribute("time"));
                                if(transform_xml->Attribute("align", "True")) align = true;
                                XMLElement *element = transform_xml->FirstChildElement();

                                while (element != nullptr) {
                                    if (point == element->Name()) {
                                        float x = stof(element->Attribute("x"));
                                        float y = stof(element->Attribute("y"));
                                        float z = stof(element->Attribute("z"));

                                        Point p = {x,y,z};
                                        pontos.push_back(p);
                                    }
                                    element = element->NextSiblingElement();
                                }
                            }
                            Transform t = {"translate", 0,0,0, 0, time, align, pontos};
                            g.transformations.push_back(t);
                        }
                    }
                    else if (rotate == transform_xml->Name()){
                        float x, y, z, angle, time = -1;
                        const char * attribute;

                        if(transform_xml->Attribute("angle") != nullptr){
                            attribute = transform_xml->Attribute("angle");
                            angle = stof(attribute);
                        }
                        else{
                            attribute = transform_xml->Attribute("time");
                            time = stof(attribute);
                        }

                        angle = stof(attribute);
                        attribute = transform_xml->Attribute("x");
                        x = stof(attribute);
                        attribute = transform_xml->Attribute("y");
                        y = stof(attribute);
                        attribute = transform_xml->Attribute("z");
                        z = stof(attribute);

                        Transform t = {"rotate", x, y, z, angle,time};
                        g.transformations.push_back(t);
                    }
                    transform_xml = transform_xml->NextSiblingElement();
                }
            }
            else if (subGroup == element->Name()) {
                Group gr = parseGroup(element, true,vert);
                g.subGroups.push_back(gr);
            }
            element = element->NextSiblingElement();
            if (element == nullptr && father) return g;
        }
        //if (!father) world.groups.push_back(g);
        group = group->NextSiblingElement();
    } while (group != nullptr);

    return g;
}


// XML parsing function
bool parseInput(const char* file_name, World *w, vector<float> *vert){
    char tmp[256];
    getcwd(tmp, 256); //tmp which contains the directory
    string path(tmp);
    int found = path.find("Engine"); // finds engine's localization

    replace(path.begin(), path.end(), '\\', '/');
    path.erase(path.begin() + found, path.end());

    pathModels = path + "Models/";

    path = pathModels + file_name;
    strcpy(tmp, path.c_str());

    XMLDocument doc;
    XMLError eResult = doc.LoadFile(tmp);
    XMLCheckResult(eResult)

    XMLElement *world_xml = doc.FirstChildElement("world");
    if(world_xml != nullptr){
        XMLElement* camera = world_xml->FirstChildElement("camera");
        if (camera != nullptr) {
            w->cam = parseCamera(camera);
        }else return false;
        XMLElement *group = world_xml->FirstChildElement("group");
        if(group != nullptr){
            Group g = parseGroup(group, false,vert);
            (*w).groups.push_back(g);
        }else return false;
    }else return false;

    return true;
}

