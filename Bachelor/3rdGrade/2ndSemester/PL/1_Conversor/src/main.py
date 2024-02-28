# Imports
import datetime
import os
import re
import sys

from funcAux import toStr
from math import prod
from statistics import median

"""                     Variáveis globais                     """
# Representa as funções de agregação que o programa suporta
funcAux = ["sum", "mult", "media", "mediana", "maior", "menor", "ordemCrescente", "ordemDecrescente", "antiga",
           "recente"]

# Representa a lista de dicionários que o programa consegue construir a partir do ficheiro .csv
lDict = []


# Responsável por obter os dados de um ficheiro .csv, isto é, faz parse à primeira linha de modo a obter os nomes das
# colunas e, a seguir, faz um parse às restantes linhas para obter os dados relativos à primeira coluna.
# Caso dê erro, retorna uma string com a informação do que falhou.
def getLDict(linesCSV):
    cabecalho = []
    linha = linesCSV[0].replace("\n", "")
    global lDict

    # Leitura da primeira linha

    colunas = re.compile(r"([\w]+)({(\d)(,(\d))?}(::(\w+))?)?").findall(linha)

    for i in colunas:
        cabecalhoDict = {}
        """
        ('Notas', '{3,5}::media', '3', ',5', '5', '::media', 'media')
        """
        if i[0] != "":
            cabecalhoDict["funcao"] = i[0]
            if i[2] != "":
                cabecalhoDict["limInicial"] = i[2]
            if i[4] != "":
                cabecalhoDict["limFinal"] = i[4]
            if i[5] != "":
                cabecalhoDict["funcaoAdicional"] = (i[0] + "_" + i[6])
            cabecalho.append(cabecalhoDict)
        else:
            return "Coluna Não Válida: {0}".format(i)

    # Leitura das restantes linhas
    linesCSV = linesCSV[1:]

    for line in linesCSV:
        groups = re.compile(r"(([\w -]+),)|(([\w -]+)\n)|(\"([^\"][\w ,-]+)\",)|(\"([\w ,r-]+)\"\n)|,").findall(line)

        # Pelos grupos de captura existentes, sabe-se as posições específicas dos dados que se quer obter
        parameters = []
        for group in groups:
            if group[1] != '':
                parameters.append(group[1])
            elif group[3] != '':
                parameters.append(group[3])
            elif group[5] != '':
                parameters.append(group[5])
            elif group[7] != '':
                parameters.append(group[7])
            else:
                parameters.append('')

        i = 0
        lineDict = {}

        # Processamento por cada coluna da primeira linha: sabendo quantos valores das linhas pertencem a uma coluna,
        # basta colocar um contador i que é aumentado com o número de valores que cada coluna possui. Este valor é
        # possível de ser calculado com o parâmetro limInicial ou limFinal: caso o valor de limInicial não exista,
        # nparam = 1; caso o valor de limFinal não exista, nparam = limInicial; o último caso é aquele em que nparam
        # toma o valor de limFinal
        for col in cabecalho:
            nparam = 1
            if col.get("limInicial", None) is None:
                lista = parameters[i]
            elif col.get("limFinal", None) is None:
                nparam = int(col["limInicial"])
                lista = parameters[i:(i + nparam)]
            else:
                nparam = int(col["limFinal"])
                lista = [i for i in parameters[i:(i + int(col["limFinal"]))] if i != ""]

            i += nparam
            lineDict[col["funcao"]] = lista

            # A última parte a verificar é a função de agregação. Caso tenha, verifica qual é e, de acordo com cada
            # função, processa os valores da lista.
            if col.get("funcaoAdicional", None) is not None:
                try:
                    if col["funcaoAdicional"].endswith("_sum"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = sum(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_mult"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = prod(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_media"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = sum(floatLista) / len(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_mediana"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = median(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_maior"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = max(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_menor"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        lineDict[col["funcaoAdicional"]] = min(floatLista)
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_ordemCrescente"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        floatLista.sort()
                        lineDict[col["funcaoAdicional"]] = floatLista
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_ordemDecrescente"):
                        floatLista = []
                        for element in lista:
                            floatLista.append(float(element))
                        floatLista.sort(reverse=True)
                        lineDict[col["funcaoAdicional"]] = floatLista
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_antiga"):
                        date = datetime.datetime.strptime(lineDict[col["funcao"]][0], "%d-%m-%Y")
                        for element in lineDict[col["funcao"]]:
                            dateElement = datetime.datetime.strptime(element, "%d-%m-%Y")
                            if dateElement < date:
                                date = dateElement
                        lineDict[col["funcaoAdicional"]] = date.strftime("%d-%m-%Y")
                        lineDict.pop(col["funcao"])
                    elif col["funcaoAdicional"].endswith("_recente"):
                        date = datetime.datetime.strptime(lineDict[col["funcao"]][0], "%d-%m-%Y")
                        for element in lineDict[col["funcao"]]:
                            dateElement = datetime.datetime.strptime(element, "%d-%m-%Y")
                            if dateElement > date:
                                date = dateElement
                        lineDict[col["funcaoAdicional"]] = date.strftime("%d-%m-%Y")
                        lineDict.pop(col["funcao"])
                except TypeError:
                    return "Erro de tipos na função {0} da coluna {1}".format(col["funcaoAdicional"], col["funcao"])
                except ValueError:
                    return "Erro de tipos na função {0} da coluna {1}".format(col["funcaoAdicional"], col["funcao"])
        if lineDict != {}:
            lDict.append(lineDict)


# Tendo os dados, falta apenas escrever para o ficheiro
def write2json(fCSV):
    # O ficheiro tem o mesmo nome que o ficheiro original, apenas a extensão muda.
    fJSON = open(os.path.join("out", fCSV), "w", encoding="utf-8")
    fJSON.write("[")

    # De acordo com a sintaxe de um ficheiro .json, todos os "objetos" começam com uma vírgula e um "\n", daí que se
    # tenha criado uma variável booleana para o primeiro objeto
    objectFirst = True

    for line in lDict:
        string = ""
        if not objectFirst:
            string += ","
        else:
            objectFirst = False
        string += "\n\t{"

        # O mesmo pensamento que o comentário acima
        lineFirst = True
        for key in line.keys():
            if not lineFirst:
                string += ","
            else:
                lineFirst = False

            string += "\n\t\t" + " \"{0}\": {1}".format(key, toStr(line[key]))
        string += "\n\t}"
        fJSON.write(string)
    fJSON.write("\n]")
    fJSON.close()


filename = sys.argv[1]
try:
    f = open(os.path.join("resources", filename), mode="r", encoding="utf-8")
    lines = f.readlines()
    f.close()

    ans = getLDict(lines)

    if ans is None:
        filename = filename.replace(".csv", ".json")
        write2json(filename)
        print("Ficheiro {0} criado com sucesso".format(filename))
    else:
        print(ans)
except FileNotFoundError:
    print("Ficheiro não existente")
