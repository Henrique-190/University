#ifndef MOD_B_SCAN_H
#define MOD_B_SCAN_H
#include "data.h"

// PASSA O CONTEÚDO DE UM FICHEIRO PARA UMA STRING;
char *file_to_buff(char *filename);

// LÊ A INFORMAÇÃO RELATIVA AO TIPO E NUMÉRO DE BLOCOS DO "BUFFER" E COLOCA-A NA STRUCT "DADOS".
DADOS *scan_file(char *buffer);

// RETORNA O NÚMERO DE ALGARISMOS DE UM NÚMERO INTEIRO;
int get_algarismos(int n);

// LÊ A INFORMAÇÃO RELATIVA À FREQUÊNCIA DE CADA SÍMBOLO E COLACA-A NA STRUCT BLOCO", INICIALIZANDO TAMBÉM O ID DE CADA SÍMBOLO.
BLOCO scan_block(char *buffer, int idb);

#endif //MOD_B_SCAN_H
