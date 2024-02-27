#include <map>
#include "parserXML.h"

string pathModels;
map<string,pair<int,int>> ficheiros;
vector<float> vertexPoints, normalPoints, texturePoints;
map<string, int> texIDs;
int indexo = 0;


int loadTexture(std::string s) {

    unsigned int t,tw,th;
    unsigned char *texData;
    unsigned int texID;

    ilInit();
    ilEnable(IL_ORIGIN_SET);
    ilOriginFunc(IL_ORIGIN_LOWER_LEFT);
    ilGenImages(1,&t);
    ilBindImage(t);
    ilLoadImage((ILstring)s.c_str());
    tw = ilGetInteger(IL_IMAGE_WIDTH);
    th = ilGetInteger(IL_IMAGE_HEIGHT);
    ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE);
    texData = ilGetData();

    glGenTextures(1,&texID);

    glBindTexture(GL_TEXTURE_2D,texID);
    glTexParameteri(GL_TEXTURE_2D,	GL_TEXTURE_WRAP_S,		GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D,	GL_TEXTURE_WRAP_T,		GL_REPEAT);

    glTexParameteri(GL_TEXTURE_2D,	GL_TEXTURE_MAG_FILTER,   	GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,	GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, tw, th, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);
    glGenerateMipmap(GL_TEXTURE_2D);

    glBindTexture(GL_TEXTURE_2D, 0);

    return texID;

}


int readFile(string file){
    int vertex = 0;
    ifstream infile(file, ios::binary | ios::in);
    if (!infile) {
        cout << "Error opening .3d file!";
    }
    string line;

    while (getline(infile, line, '\n')) {
        vector<float> tokens;
        stringstream check1(line);

        string intermediate;
        while (getline(check1, intermediate, ';')) {
            tokens.push_back(stof(intermediate));
        }

        // Vertices
        vertexPoints.push_back(tokens[0]);
        vertexPoints.push_back(tokens[1]);
        vertexPoints.push_back(tokens[2]);

        // Normals
        normalPoints.push_back(tokens[3]);
        normalPoints.push_back(tokens[4]);
        normalPoints.push_back(tokens[5]);

        vertex++;

        // Texture coordinates
        texturePoints.push_back(tokens[6]);
        texturePoints.push_back(tokens[7]);
    }

    infile.close();

    cout << "Model " + file + " loaded!" << endl;
    return vertex;
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


void parsePointLight(XMLElement* light, Light* l){
    if (light != nullptr) {
        const XMLAttribute *posX = light->FindAttribute("posx");
        (*l).pos.x = stof(posX->Value());
        const XMLAttribute *posY = light->FindAttribute("posy");
        (*l).pos.y = stof(posY->Value());
        const XMLAttribute *posZ = light->FindAttribute("posz");
        (*l).pos.z = stof(posZ->Value());
    }
}


void parseDirecionalLight(XMLElement* light, Light* l){
    if (light != nullptr) {
        const XMLAttribute* dirX = light->FindAttribute("dirx");
        (*l).dir.x = stof(dirX->Value());
        const XMLAttribute* dirY = light->FindAttribute("diry");
        (*l).dir.y = stof(dirY->Value());
        const XMLAttribute* dirZ = light->FindAttribute("dirz");
        (*l).dir.z = stof(dirZ->Value());
    }
}


void parseSpotLight(XMLElement* light, Light* l){
    if (light != nullptr) {
        const XMLAttribute *posX = light->FindAttribute("posx");
        (*l).pos.x = stof(posX->Value());
        const XMLAttribute *posY = light->FindAttribute("posy");
        (*l).pos.y = stof(posY->Value());
        const XMLAttribute *posZ = light->FindAttribute("posz");
        (*l).pos.z = stof(posZ->Value());
        const XMLAttribute* dirX = light->FindAttribute("dirx");
        (*l).dir.x = stof(dirX->Value());
        const XMLAttribute* dirY = light->FindAttribute("diry");
        (*l).dir.y = stof(dirY->Value());
        const XMLAttribute* dirZ = light->FindAttribute("dirz");
        (*l).dir.z = stof(dirZ->Value());
        const XMLAttribute* cuttoff = light->FindAttribute("cutoff");
        (*l).cutoff = stof(cuttoff->Value());
    }
}


vector<Light> parseLights(XMLElement* lights){
    vector<Light> res;

    XMLElement* light = lights->FirstChildElement();

    while (light != nullptr) {
        Light l;
        const XMLAttribute *type = light->FindAttribute("type");

        if (type != nullptr) {
            if (strcmp(type->Value(), "point") == 0) {
                l.type = "point";
                parsePointLight(light, &l);

            }else if (strcmp(type->Value(), "directional") == 0) {
                l.type = "directional";
                parseDirecionalLight(light, &l);

            }else{
                l.type = "spot";
                parseSpotLight(light, &l);
            }
        }

        res.push_back(l);
        light = light->NextSiblingElement("light");
    }
    return res;
}


void parseColor(XMLElement* color, Color *cor){
    XMLElement* difusse = color->FirstChildElement("diffuse");
    if (difusse != nullptr){
        (*cor).diffuse[0] = stof(difusse->Attribute("R"))/255;
        (*cor).diffuse[1] = stof(difusse->Attribute("G"))/255;
        (*cor).diffuse[2] = stof(difusse->Attribute("B"))/255;
        (*cor).diffuse[3] = 1.0f;
    }
    XMLElement* ambient = color->FirstChildElement("ambient");
    if (ambient != nullptr){
        (*cor).ambient[0] = stof(ambient->Attribute("R"))/255;
        (*cor).ambient[1] = stof(ambient->Attribute("G"))/255;
        (*cor).ambient[2] = stof(ambient->Attribute("B"))/255;
        (*cor).ambient[3] = 1.0f;
    }
    XMLElement* specular = color->FirstChildElement("specular");
    if (ambient != nullptr){
        (*cor).specular[0] = stof(specular->Attribute("R"))/255;
        (*cor).specular[1] = stof(specular->Attribute("G"))/255;
        (*cor).specular[2] = stof(specular->Attribute("B"))/255;
        (*cor).specular[3] = 1.0f;
    }
    XMLElement* emissive = color->FirstChildElement("emissive");
    if (ambient != nullptr){
        (*cor).emissive[0] = stof(emissive->Attribute("R"))/255;
        (*cor).emissive[1] = stof(emissive->Attribute("G"))/255;
        (*cor).emissive[2] = stof(emissive->Attribute("B"))/255;
        (*cor).emissive[3] = 1.0f;
    }
    XMLElement* shininess = color->FirstChildElement("shininess");
    if(shininess != nullptr) (*cor).shininess = stof(shininess->Attribute("value"));
}


Group parseGroup(XMLElement* group, bool father){
    Group g;
    string models_xml = "models";
    string scale = "scale";
    string translate = "translate";
    string rotate = "rotate";
    string subGroup = "group";
    string transform = "transform";
    do {
        XMLElement* element = group->FirstChildElement();

        while (element != nullptr){
            if (models_xml==element->Name()){
                Model m;
                XMLElement* model_xml = element->FirstChildElement("model");

                while(model_xml != nullptr) {
                    const char* strfile = model_xml->Attribute("file");
                    m.file3D = strfile;

                    if (ficheiros.find(m.file3D) != ficheiros.end()) {
                        auto it = ficheiros.find(m.file3D);
                        m.indexBegin = it->second.first;
                        //m.indexEnd = it->second.second;
                        //g.vboIndexes.push_back(it->second);
                    }
                    else {
                        m.vertexCount = readFile(pathModels + m.file3D);
                        ficheiros.insert({m.file3D, pair<int,int>{indexo,m.vertexCount}});
                        m.indexBegin = indexo;
                        //m.indexEnd = m.vertexCount;
                        //g.vboIndexes.emplace_back(indexo,m.vertexCount);
                        indexo += m.vertexCount;

                    }

                    XMLElement* texture = model_xml->FirstChildElement("texture");
                    if(texture != nullptr){
                        const char* fileImg = texture->Attribute("file");
                        if(fileImg != nullptr){
                            if(texIDs.find(fileImg) == texIDs.end()){
                                string f = fileImg;
                                m.textureID = loadTexture(pathModels + "Img/" + f);
                                texIDs.insert({fileImg, m.textureID});
                            }
                            else m.textureID = texIDs.find(fileImg)->second;
                        }
                    }else m.textureID = 0;

                    XMLElement* color = model_xml->FirstChildElement("color");
                    if(color != nullptr){
                        Color cor;
                        parseColor(color, &cor);
                        m.color = cor;
                    }

                    model_xml = model_xml->NextSiblingElement();
                    g.models.push_back(m);
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
                Group gr = parseGroup(element, true);
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
bool parseInput(const char* file_name, World *w, vector<float> *v, vector<float>* n, vector<float>* t){
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
        XMLElement* lights = world_xml->FirstChildElement("lights");
        if (lights != nullptr) {
            (*w).ligths = parseLights(lights);
        };
        XMLElement *group = world_xml->FirstChildElement("group");
        if(group != nullptr){
            Group g = parseGroup(group, false);
            (*w).groups.push_back(g);
            *v = vertexPoints;
            *n = normalPoints;
            *t = texturePoints;
        }else return false;
    }else return false;

    return true;
}