import os
import json


def get_value_types(data):
    types = {}
    for item in data:
        for value in item.keys():
            value_type = type(item[value]).__name__
            if value_type == "str":
                continue
            if value_type not in types:
                types[value_type] = set()    
            types[value_type].add(value[30])
    return types

def print_value_types(data):
    value_types = get_value_types(data)
    for value_type, value in value_types.items():
        print(f"Tipo: {value_type}")
        print(f"Valor: {value}\n")


for file in os.listdir("data"):
    with open("data/" + file, 'r') as f:
        print(file)
        json_data = json.load(f)
        print_value_types(json_data)
