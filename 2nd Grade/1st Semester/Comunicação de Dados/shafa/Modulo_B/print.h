#ifndef MOD_B_PRINT_H
#define MOD_B_PRINT_H

// CONVERTE O NOME DO FICHEIRO DE ".FREQ" PARA ".COD".
char *covert_filename(char *filename);

// ABRE O FICHEIRO ".COD".
FILE *open_file(char *filename);

// IMPRIME O TIPO DO FICHEIRO E O NÚMERO DE BLOCOS DO MESMO NO FICHEIRO ".COD".
void print_file(FILE *fp, DADOS *d);

// IMPRIME A FREQUÊNCIA TOTAL DE CADA BLOCO E O CÓDIGO SHANNON-FANO DE CADA SÍMBOLO NO FICHEIRO ".COD".
void print_block(FILE *fp, BLOCO *b);

// IMRPIME O "@0" NO FINAL DE FICHEIRO.
void end_file(FILE *fp);

#endif //MOD_B_PRINT_H
