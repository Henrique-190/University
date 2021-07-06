/*
Autores:
 Gonçalo Miguel Leão Barros Oliveira Pinto, 2ºano, Universidade do Minho
 Teresa Costa Pires Gil Fortes, 2ºano, Universidade do Minho
Ultima modificação:
 03/01/2021
Descrição das principais funções criadas:
    :: file_to_buff:
        Recebe o nome do ficheiro .freq e passa o seu conteúdo para uma string (buffer).

    :: scan_file:
        Recebe o buffer e vai ao seu conteúdo buscar o tipo do ficheiro e o número de blocos, guardando-os na struct DADOS.

    :: scan_block:
        Recebe o buffer e um inteiro, e vai lendo o buffer, até conseguir ler o bloco de índice correspondente ao inteiro que se recebeu por argumento, atualizando a struct BLOCO com a devida informação.
*/

#include <stdio.h>
#include <stdlib.h>
#include "scan.h"
#include "data.h"

char *file_to_buff(char *filename)
{
    FILE *fp;
    int length;
    if ((fp = fopen(filename, "r+")) == NULL)
    {
        printf("Erro ao ler o ficheiro");
        return NULL;
    }
    fseek(fp, 0, SEEK_END);
    length = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    char *buffer = malloc(length);
    fread(buffer, 1, length, fp);
    fclose(fp);
    return buffer;
}

DADOS *scan_file(char *buffer)
{
    DADOS *data = (DADOS *)malloc(sizeof(DADOS));
    int nb;
    char ft;
    // ARMAZENAR TIPO DE FICHEIRO E NÚMERO DE BLOCOS.
    sscanf(buffer, "@%c@%d", &ft, &nb);
    data->ft = ft;
    data->n_blocks = nb;

    return data;
}

int get_algarismos(int n)
{
    int tmp = n;
    int n_alg = 1;
    while (tmp >= 10)
    {
        n_alg++;
        tmp /= 10;
    }
    return n_alg;
}

BLOCO scan_block(char buffer[], int idb)
{
    BLOCO *block = malloc(sizeof(struct bloco));
    int tf, nb, length = 0, f;
    char c;
    sscanf(buffer, "@%c@%d", &c, &nb);

    length += 3 + get_algarismos(nb);

    for (int i = 0; i < nb && i <= idb; ++i)
    {
        length += i * 255;
        sscanf((buffer + length), "@%d@", &tf);

        length += 2 + get_algarismos(tf);

        if (idb == i)
            block->t_freq = tf;

        for (int j = 0; j < 256; j++)
        {
            if (sscanf((buffer + length + j), "%d;", &f) == 1)
                length += get_algarismos(f);

            if (i == idb)
            {
                block->info[j].freq = f;
                block->info[j].sym = j;
            }
        }
    }

    return *block;
}