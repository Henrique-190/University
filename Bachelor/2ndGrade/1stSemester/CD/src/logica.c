/*
Autores:
 Gonçalo Miguel Leão Barros Oliveira Pinto, 2ºano, Universidade do Minho
 Teresa Costa Pires Gil Fortes, 2ºano, Universidade do Minho
Ultima modificação:
 03/01/2021
Descrição das principais funções criadas:
    :: bubbleSort_freq & bubbleSort_sym:
        Recebe o bloco cujo array é suposto organizar da devida forma, uma por ordem decrescente de frequências e outra por ordem crescente dos símbolos, respetivamente;
        Estas funçôes passam como argumentos à função "swap" os enderenços dos dois elementos do array "SYM_INFO[256]" a trocar.

    :: cod_sf:
        Recebe o bloco para o qual se pretende realizar o código SF, e chama a função add_bits para um intervalo de inteiros, correspondente aos elementos que têm frequência != 0.

    :: add_bits:
        Função recursiva que tem como função realizar os códigos SF de cada símbolo:
            *Argumentos:
                - int min - indíce mínimo dos símbolos para os quais se vai fazer a função;
                - int max - indíce máximo dos símbolos para os quais se vai fazer a função;
                - BLOCO *block - apontador para o bloco;
                - int counter - indice do array do código de um elemento no qual vamos acrescentar o bit.
            *Funcionamento:
                - Através da função find_half vamos obter um índice.
                - Adiciona-se um '0' no fim do código de um elemento nos símbolos de índice compreendido entre o min e o valor obtido com a find_half;
                - Adiciona-se um '1' no fim do código de um elemento nos símbolos de índice compreendido entre o valor obtido com a find_half e o max;
                - Chama a função recursivamente para cada intervalo (de min a half e de half a max, acrescentando um ao counter), se não houver apenas um elemento nos intervalos.               
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "data.h"
#include "logica.h"

void swap(SYM_INFO *xp, SYM_INFO *yp)
{
    SYM_INFO temp = *xp;
    *xp = *yp;
    *yp = temp;
}

void bubbleSort_freq(BLOCO *block)
{
    int i, j;
    for (i = 0; i < 256 - 1; i++)

        // Last i elements are already in place
        for (j = 0; j < 256 - i - 1; j++)
            if (block->info[j].freq < block->info[j + 1].freq)
                swap(&(block->info[j]), &(block->info[j + 1]));
}

void bubbleSort_sym(BLOCO *block)
{
    int i, j;
    for (i = 0; i < 256 - 1; i++)

        // Last i elements are already in place
        for (j = 0; j < 256 - i - 1; j++)
            if ((block->info[j].sym) > (block->info[j + 1].sym))
                swap(&(block->info[j]), &(block->info[j + 1]));
}

// DEVOLVE O ÍNDICE A PARTIR DO QUAL SE COLOCA UM '1' NO CÓDIGO SF.
int find_half(BLOCO *b, int min, int max)
{
    int i, h, sum = 0, t = 0, sum1, sum2;

    for (i = min; i < max; i++)
        t += b->info[i].freq;

    h = floor(t / 2);
    for (i = min; sum < h && i < max; i++)
        sum += b->info[i].freq;

    sum1 = abs(sum - b->info[i - 1].freq - h);
    sum2 = abs(sum - h);
    if (sum1 < sum2)
        if (i - 1 != min)
            return i - 1;

    return i;
}

void cod_sf(BLOCO *block)
{
    int i, max;
    for (i = 0; (block->info[i].freq != 0) && i < 256; i++)
        ;
    max = i;

    add_bits(0, max, block, 0);
}

void add_bits(int min, int max, BLOCO *block, int counter)
{
    int i, half;
    half = find_half(block, min, max);

    // ADICIONA O '0'
    for (i = min; i < half; i++)
        block->info[i].cod[counter] = '0';

    // ADICIONA O '1'
    for (i = half; i < max; i++)
        block->info[i].cod[counter] = '1';

    // CHAMA RECURSIVA PARA CADA METADE
    if (half - min > 1)
        add_bits(min, half, block, (counter + 1));
    else
        block->info[min].cod[counter + 1] = '\0';

    if (max - half > 1)
        add_bits(half, max, block, (counter + 1));
    else
        block->info[half].cod[counter + 1] = '\0';
}
