#include <string.h>
#include <stdio.h>
#include <stdlib.h>


long block_tam(char s); //Recebe a letra do comando que dará o tamanho de cada bloco.

int taxa_de_rle(long tam_bloco, char arr[]); // Calcula a taxa de compressão RLE do bloco de texto.

int rle_comp_block(int forcado, long nr_blocos, long tam_ult, long tam_bloco, long *tam_file, char *filename , long *tam_blocos_rle); //Função que analisa o ficheiro que foi dado e cria um ficheiro RLE comprimido.

void modA_freq(char *filename, long nr_blocos, long tam_file, long tam_blocos, long tam_ult); //Função que cria o ficheiro FREQ e calcula a frequência que cada caracter tem no ficheiro original.

void modA_freq_rle(char *filename, long nr_blocos, long tam_file, long *tam_blocos); //Função que cria o ficheiro FREQ e calcula a frequência que cada caracter tem no ficheiro RLE.

void calcula_rle(long tam_file, long *nr_blocos, long *tam_ult, long block_size); //Análise do tamanho do ficheiro e da sua divisão em blocos para se poder proceder à compressão RLE.

int main_modA(char *filename, int force_rle, char bs); //Função que chama todas as funções anteriores e calcula a compressão RLE e a frequência do ficheiro.

char arg_tam(int argn, char *argv[]); //Analisa os argumentos que são fornecidos pela linha de comandos e retorna o char correspondente ao tamanho dos blocos