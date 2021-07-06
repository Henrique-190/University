#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "mod_b.h"
#include "modA.h"
#include "modD.h"
#include "modC.h"

#define MAX 256

int main(int argn, char *argv[])
{
    if (!strcmp(argv[2], "-m"))
    {
        if (!strcmp(argv[3], "f"))
        {
            char bs = arg_tam(argn, argv);
            if (!strcmp(argv[4], "-c") && !strcmp(argv[5], "r"))
                main_modA(argv[1], 1, bs); // módulo f com rle
            else
            {
                main_modA(argv[1], 0, bs); // módulo f normal
            }
        }
        else if (!strcmp(argv[3], "t"))
        {
            mod_b(argv[1]);
        }
        else if (!strcmp(argv[3], "c"))
        {
            moduloC(argv[1]);
        }
        else if (!strcmp(argv[3], "d"))
        {
            clock_t begin = clock();
            FILE *fp;
            char nome[MAX];

            // Tipo = que vai usar (shaf para original (0), rle.shaf para rle(1), rle.shaf para original(2) ou nenhum(3))
            int tipo = 0;

            strcpy(nome, argv[1]);

            char *gerado;

            int rle = 0;
            if (argv[4])
                if (!strcmp(argv[4], "r"))
                    rle = 1;

            if (rle) {
                tipo = 2;
                gerado = rle_SHAF_cod(argv[1], nome, argv[4]);
            } else {

                //Altera a extensão ".shaf" para ".cod"
                unsigned int tam = strlen(nome);
                tam--;
                nome[tam] = '\0';
                nome[tam - 1] = 'd';
                nome[tam - 2] = 'o';
                nome[tam - 3] = 'c';

                //Abre o ficheiro especificado em "nome", lê a char posterior ao @ e guarda-a na variável rN
                char rN;
                fp = fopen(nome, "r");
                fscanf(fp, "@%c", &rN);
                fclose(fp);

                //Verifica se o ficheiro sofreu compressão RLE ou SHAF ou nenhuma, atribuindo os tipos especificados

                if (rN == 'R') {
                    if (argv[4])
                        tipo = 1;
                    else
                        tipo = 2;
                    gerado = rle_SHAF_cod(argv[1], nome, argv[4]);
                } else if (rN == 'N')
                    gerado = shaf_COD(argv[1], nome, 0);
                else
                    tipo = 3;
            }

            clock_t end = clock();
            double time_spent = (double) (end - begin) / CLOCKS_PER_SEC;
            time_spent *= 1000;
            output(argv[1], time_spent, gerado, tipo);
        }

        else
            printf("\n\nInput incorreto\n\n");

        return 0;
    }
}
