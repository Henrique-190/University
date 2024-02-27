import subprocess
import os

for file in os.listdir("data"):
    aux = file.replace("_acordaos.json", "")
    process = subprocess.Popen(['mongoimport', '-d', 'Acordaos', '-c', aux, 'data/' + file, '--jsonArray'],
                     stdout=subprocess.PIPE, 
                     stderr=subprocess.PIPE)
    stdout, stderr = process.communicate()
    print(stdout, stderr)