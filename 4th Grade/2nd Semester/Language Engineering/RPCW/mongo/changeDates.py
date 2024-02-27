import os
import json

def sanitizeString(string):
    return string.replace('\\', '\\\\').replace("\n", "\\n").replace("\r", "\\r").replace("\t", "\\t").replace('"', '”').replace('\u0002',"").replace('\u0001',"").replace('\u001f', "")

contrario = False

def sanitizeDate(date):
    if len(date) == 10:
        if contrario:
            day = date[0:2]
            month = date[3:5]
        else: 
            month = date[0:2]
            day = date[3:5]
        year = date[6:]
        pass
    elif len(date) == 8: #Ano não tem dois primeiros dígitos
        if contrario:
            day = date[0:2]
            month = date[3:5]
        else: 
            month = date[0:2]
            day = date[3:5]
        year = date[6:]
        if year[0] == "0" or year[0] == "1" or year[0] == "2":
            year = "20" + year    
        else:
            year = "19" + year
    else:
        print(date)
        return date
    return year + "-" + month + "-" + day

def sanitizeItem(item, file):
    for key in item.keys():
        if key in ["Data do Acordão", "Data", "Data da Decisão"]:
            file.write('"' + key + '"' + ": " + '"' + sanitizeDate(item[key]) + '",\n\t')
            continue

            
        if type(item[key]) == int:
            file.write('"' + key + '"' + ": " + str(item[key]) + ',\n\t')
        elif type(item[key]) == list:
            elements = ""
            if len(item[key]) > 0:
                for element in item[key]:
                    elements += '"' + sanitizeString(element) + '",'
                elements = elements[:-1]
            file.write('"' + key + '"' + ": [" + elements + '],\n\t')
        elif key == "tribunal":
            file.write('"' + key + '"' + ": " + '"' + sanitizeString(item[key]) + '"\n')
        else:
            file.write('"' + key + '"' + ": " + '"' + sanitizeString(item[key]) + '",\n\t')
            

def change(file):
    global contrario
    if file == "jtrl_acordaos.json":
        contrario = True
    with open("data/" + file, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    with open("data/" + file, "w") as file:
        file.write("[\n\t")
        for item in data[:-1]:
            file.write("{\n\t")
            sanitizeItem(item, file)
            file.write("},\n\t")

        file.write("{\n\t")
        sanitizeItem(data[-1], file)
        file.write("}\n\t")

        file.write("]\n\t")
    contrario = False


for f in os.listdir("data"):
    print(f)
    change(f)
