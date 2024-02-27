import argparse
from Gramatica import Parse

parser = argparse.ArgumentParser(description='Exemplo de uso do argparse')

parser.add_argument('-i', '--input', help='Arquivo de entrada', required=True)
parser.add_argument('-o', '--output', help='Arquivo de saída')
parser.add_argument('-g', '--graphic', help='Arquivo gráfico')
parser.add_argument('-c', '--complexidade', help='Complexidade de McCabe')

args = parser.parse_args()

Parse(args.input, args.output, args.graphic, args.complexidade)