#!/bin/bash

input_directory="data"
output_directory="data2"

# Verifica se o diretório de saída existe, caso contrário, cria-o
mkdir -p "$output_directory"

# Percorre todos os arquivos no diretório de entrada
for input_file in "$input_directory"/*.json; do
    # Obtém o nome do arquivo sem o caminho completo
    filename=$(basename "$input_file")

    # Cria o caminho completo para o arquivo de saída
    output_file="$output_directory/$filename"

    # Executa o comando 'tr' no arquivo de entrada e redireciona a saída para o arquivo de saída
    tr -d "[:cntrl:]" < "$input_file" > "$output_file"

    echo "Concluído: $input_file"
done
