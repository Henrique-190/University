/*
Autores:
 Gonçalo Miguel Leão Barros Oliveira Pinto, 2ºano, Universidade do Minho
 Teresa Costa Pires Gil Fortes, 2ºano, Universidade do Minho
Ultima modificação:
 03/01/2021
Descrição das principais funções criadas:
    :: int mod_b(char *filename):
        Esta função recebe como argumento o nome do ficheiro .freq e tem como função, com o auxílio de funções auxiliares definidos noutros ficheiros:
            - passar o conteúdo do ficheiro para um buffer através da função "file_to_buff";
            - ler o buffer e passar a informação para as structs "DADOS" e "BLOCO" através das funções "scan_file" e "scan_block";
            - organizar o array relativo à informação de cada símbolo ("SYM_INFO[256]") por ordem decrescente de frequências com a função "bubbleSort_freq";
            - fazer o código SF de cada símbolo através das funções presentes no ficheiro "logica.c";
            - reorganizar o array relativo à informação de cada símbolo ("SYM_INFO[256]") por ordem crescente de símbolos com a função "bubbleSort_sym";
            - converter o nome do ficheiro .freq para .cod ("convert_filename");
            - imprimir a informação devida no ficheiro .cod com as funções definidas no ficheiro "print.c";
            - por último, imprime os outputs pretendidos no terminal.
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "scan.h"
#include "data.h"
#include "logica.h"
#include "print.h"
#include "mod_b.h"

int mod_b(char *filename)
{
    clock_t tempo;
    tempo = clock();

    int nb, i;

    DADOS *data = scan_file(file_to_buff(filename)); // STRUCT COM OS DADOS GERAIS DO FICHEIRO.
    nb = data->n_blocks;

    BLOCO blocks[nb]; // ARRAY DE UMA STRUCT COM A INFORMAÇÃO RELATIVA A CADA BLOCO.

    // INICIALIZAÇÃO DO BLOCO COM O IDENTIFICADOR DOS SÍMBOLOS E A SUA FREQUÊNCIA.
    for (i = 0; i < nb; ++i)
        blocks[i] = scan_block(file_to_buff(filename), i);

    for (i = 0; i < nb; ++i)
    {
        bubbleSort_freq(&blocks[i]); // ORGANIZAR O O ARRAY DO BLOCO POR ORDEM DECRESCENTE DE FREQUÊNCIAS.
        cod_sf(&blocks[i]);          // ATRIBUIÇÃO DO CÓDIGO Shannon-Fano A CADA SÍMBOLO.
        bubbleSort_sym(&blocks[i]);  // ORGANIZAR O O ARRAY DO BLOCO POR ORDEM CRESCENTE DE SÍMBOLOS.
    }

    // CRIA O FICHEIRO ".COD".
    FILE *fp = open_file(covert_filename(filename));

    print_file(fp, data); // IMRPIME O TIPO E O NÚMERO DE BLOCOS DO FICHEIRO.
    // IMPRIME A INFORMAÇÃO DOS BLOCOS.
    for (i = 0; i < nb; ++i)
        print_block(fp, &blocks[i]);

    end_file(fp); // IMPRIME 0 "@0" QUE INDICA QUE NÃO HÁ MAIS BLOCOS, OU SEJA, O FINAL DO FICHEIRO.

    // IMPRIME O OUTPUT
    struct tm *dia;
    time_t seg;
    time(&seg);
    dia = localtime(&seg);
    clock_t tempoF = clock();
    // Rabetice do output
    printf("Gonçalo Miguel Leão Barros Oliveira Pinto, a93265 & Teresa Costa Pires Gil Fortes, a93250, MIEI-CD, %d-%d-%d", dia->tm_mday, dia->tm_mon + 1, dia->tm_year + 1900);
    printf("\nMódulo: t (cálculo dos códigos dos símbolos");
    printf("\nNúmero de blocos: %d", nb);
    printf("\nTamanho dos blocos analisados no ficheiro de símbolos: ");
    for (int i = 0; i < nb; i++)
    {
        printf("%d", blocks[i].t_freq);
        if (i != nb - 1)
            printf("/");
    }
    printf(" bytes");
    printf("\nTempo de execução do módulo (milissegundos): %f", 1000 * (tempoF - tempo) / (double)CLOCKS_PER_SEC);
    printf("\nFicheiro gerado: %s\n\n", covert_filename(filename));

    return 0;
}