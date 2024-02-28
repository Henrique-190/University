#include <string.h>
#include <stdio.h>
#include <stdlib.h>


long block_tam(char s); //recebido um character , devolve o tamanho dos blocos

int taxa_de_rle(long tam_bloco, char arr[]); //recebido um bloco e o seu tamanho, devolve a taxa de compressao rle

int rle_comp_block(int forcado, long nr_blocos, long tam_ult, long tam_bloco, long *tam_file, char *filename); //verifica se se vai executar a compressao rle ou nao ; se sim, cria um ficheiro rle e retorna a sua taxa de compressao

char* modA_freq(char *filename, long nr_blocos, long tam_file, long tam_blocos, long tam_ult); //cria um ficheiro.freq

void calcula_rle(long tam_file, long *nr_blocos, long *tam_ult, long block_size); // caso se gere o ficheiro rle, calcula os novos valores a ser recebidos pela funçao moA_freq

int main_modA(char *filename, int force_rle, char bs); // função mãe do modulo A

char arg_tam(int argn, char *argv[]); //analisa os argumenots e devolve o char que dita o tamanho dos blocos