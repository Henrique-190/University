import os
import json

lista = ["jsta_acordaos.json",
"jtca_acordaos.json",
"jtrl_acordaos.json",
"jtcn_acordaos.json",
"jstj_acordaos.json"]

def sanitizeString(string):
    return string.replace('\\', '\\\\').replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t").replace('"', '”').replace('\u0002',"").replace('\u0001',"").replace('\u001f', "")

def sanitizeItem(item):
    anos = r""
    dentroDecisao = False
    dentroSumario = False
    texto = ""
    for key in item.keys():
        if key == "url":
            dentroSumario = False
            dentroDecisao = False
            if texto != "":
                texto += anos + '",\n\t'
            print(texto + '"' + key + '"' + " : " + '"' + sanitizeString(item[key]) + '",\n\t')
            texto = ""
        elif dentroDecisao:
            texto += '\\"' + sanitizeString(key) + '\\"' +" : " + '\\"' + sanitizeString(item[key]) + '\\"'
        elif key == "Decisão Texto Integral":
            dentroDecisao = True
            dentroSumario = False
            if texto != "":
                print(texto + '",')
            texto = '"' + key + '"' + ": " + '"' + sanitizeString(item[key])
        elif dentroSumario:
            texto += '\\"' + sanitizeString(key) + '\\"' +" : " + '\\"' + sanitizeString(item[key]) + '\\"'
        elif key == "Sumário":
            dentroSumario = True
            texto = '"' + key + '"' + ": " + '"' + sanitizeString(item[key])
        elif key == "tribunal":
            print('"' + key + '"' + ": " + '"' + sanitizeString(item[key]) + '"')
        else:
            try:
                int(key)
                anos += key + ": " + str(item[key]) + ", "
            except:
                if type(item[key]) == int:
                    print('"' + key + '"' + ": " + str(item[key]) + ',')
                elif type(item[key]) == list:
                    elements = ""
                    if len(item[key]) > 0:
                        for element in item[key]:
                            elements += '"' + sanitizeString(element) + '",'
                        elements = elements[:-1]
                    print('"' + key + '"' + ": [" + elements + '],')
                else:
                    print('"' + key + '"' + ": " + '"' + sanitizeString(item[key]) + '",')


def change(file):
    with open(file, "r") as f:
        data = json.load(f)
        print("[")
        for item in data[:-1]:
            print("{")
            sanitizeItem(item)
            print("},")
        
        print("{")
        sanitizeItem(data[-1])
        print("}")
        
        print("]")


#change("data/jsta_acordaos.json")
#change("data/jtca_acordaos.json")
#change("data/jtrl_acordaos.json")
#change("output.txt")
#change("data/jtcn_acordaos.json")
change("data/jstj_acordaos.json")