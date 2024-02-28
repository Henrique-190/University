# Verifica se uma string pode ser convertida para Float
def is_float(val):
    try:
        float(val)
    except ValueError:
        return False
    return True


# Verifica se uma string pode ser convertida para Int
def is_int(val):
    try:
        int(val)
    except ValueError:
        return False
    return True


# Converte lista, float ou int em string. Caso seja string, adiciona aspas no início e fim
def toStr(element):
    if type(element) == list:
        string = "["
        first = True
        for el in element:
            if not first:
                string += ", "
            else:
                first = False
            string += toStr(el)
        string += "]"
    elif is_int(element) or is_float(element):
        string = str(element)
    else:
        string = "\"" + element + "\""
    return string
