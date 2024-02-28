lista =[
"jsta_acordaos.json",
"jtca_acordaos.json",
"jtrl_acordaos.json",
"jtcn_acordaos.json",
"jstj_acordaos.json"
]

import json

def print_unique_keys(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
        keys = {}
        for item in data:
            for key in item.keys():
                if key in keys.keys():
                    keys[key] +=1
                else:
                    keys[key] = 1
        for key in keys.keys():
            print(key)

print("jstj_acordaos.json")
print_unique_keys("jstj_acordaos.json")
quit()
for file in lista:
    print(file)
    print_unique_keys("data/" + file)
    print("\n\n\n\n")