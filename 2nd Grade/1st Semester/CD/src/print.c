/*
Autores:
 Gonçalo Miguel Leão Barros Oliveira Pinto, 2ºano, Universidade do Minho
 Teresa Costa Pires Gil Fortes, 2ºano, Universidade do Minho
Ultima modificação:
 03/01/2021
Descrição das principais funções criadas:
    :: convert_filename:
        Recebe o nome do ficheiro .freq, copia-se o nome do ficheiro .freq para outra string à qual vamos juntar uma string cujo conteúdo é ".cod" devolvendo a string final com o nome pretendido.
    
    :: print_file & print_block:
        Recebem o apontador para um ficheiro no qual se vai a imprimir a informação que recebemos no segundo argumento de cada função (struct dos DADOS e do BLOCO, respetivamente).

*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "data.h"
#include "print.h"

char *covert_filename(char *filename)
{
    int i;
    unsigned long l = strlen(filename);
    char *add_cod = ".cod";
    char *dest = malloc(l - 1);

    for (i = 0; i < (l - 5); ++i)
        dest[i] = filename[i];

    dest[i] = '\0';
    strcat(dest, add_cod);
    return dest;
}

FILE *open_file(char *filename)
{
    FILE *fp;
    if ((fp = fopen(filename, "w+")) == NULL)
    {
        printf("Erro ao abrir o ficheiro");
        return NULL;
    }
    return fp;
}

void print_file(FILE *fp, DADOS *d)
{
    fseek(fp, 0, SEEK_END);
    fprintf(fp, "@%c@%d", d->ft, d->n_blocks);
}

void print_block(FILE *fp, BLOCO *b)
{
    fseek(fp, 0, SEEK_END);
    fprintf(fp, "@%d@", b->t_freq);
    for (int j = 0; j < 256; ++j)
    {
        if ((b->info[j].freq) != 0)
            fprintf(fp, "%s", b->info[j].cod);
        if (j != 255)
            fprintf(fp, ";");
    }
}

void end_file(FILE *fp)
{
    fseek(fp, 0, SEEK_END);
    fprintf(fp, "@0");
}