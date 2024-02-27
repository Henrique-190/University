/** \file interface.c
 * Ficheiro com funções que alteram a interface do ficheiro.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "dados.h"
#include "logica.h"
#include "io.h"

/**
\brief BUF_SIZE.
*/
#define BUF_SIZE 1024

void mostrar_tabuleiro(ESTADO *e,FILE *stdout,int cmd);
void prompt(ESTADO *e);
void vencedor(int jogador);

int interpretador(ESTADO *antigoe, ESTADO *e, FILE *ficheiro) {
    char linha[BUF_SIZE];
    mostrar_tabuleiro(e, stdout, 2);

    int r = fim_jogo(e);
    if (r == 1 || r == 2) {
        vencedor(r);
        return 0;
    }

    prompt(e);
    printf("Jogador %d, introduza uma jogada: ", obter_jogador_atual(e));

    if (fgets(linha, BUF_SIZE, stdin) == NULL) return 0;
    char col[2], lin[2];
    if (strlen(linha) == 3 && sscanf(linha, "%[a-h]%[1-8]", col, lin) == 2) {
        COORDENADA coord = {*col - 'a', *lin - '1'};
        jogar(e, coord);
        altera_comando(e, 1);
        return 1;
    }

    if (strcmp(linha, "gr\n") == 0) {
        grava(ficheiro, e);
        altera_comando(e, 2);
        return 1;
    }

    if (strcmp(linha, "ler\n") == 0) {
        *e=le(ficheiro);
        altera_comando(e, 3);
        return 1;
    }

    if (linha[0] == 'p' && linha[1] == 'o' && linha[2] == 's' && linha[3] == ' ' &&
        ((strlen(linha) == 6 && linha[4] >= 48 && linha[4] <= 57) ||
         (strlen(linha) == 7 && linha[4] > 48 && linha[4] <= 57 && linha[5] >= 48 && linha[5] <= 57))) {

        *(linha + 4) -= 48;
        int numero = *(linha + 4);
        if (strlen(linha) == 7) {
            *(linha + 5) -= 48;
            numero = (*(linha + 4)) * 10 + (*(linha + 5));
        }

        if (obter_comando(e) != 4) *antigoe = *e;

        if (numero > obter_numero_de_jogadas(antigoe)) {
            printf("Impossível, coloque um número inferior ao número de jogadas\n");
            return 1;
        } else if (numero > obter_numero_de_jogadas(e)) *e = *antigoe;

        if (numero == 0) {
            free(e);
            e = inicializar_estado();
        } else pos(e, numero);

        altera_comando(e, 4);
        return 1;
    }

    if (strcmp(linha, "movs\n") == 0) {
        movs(e, stdout, 2);
        altera_comando(e, 5);
        return 1;
    }

    if (strcmp(linha, "jog\n") == 0) {
        jog(e);
        altera_comando(e, 6);
        return 1;
    }
    if (strcmp(linha, "jog2\n") == 0) {
        jog2(e);
        altera_comando(e, 7);
        return 1;
    }
    if (strcmp(linha, "Q\n") == 0) {
        printf("Prazer!");
        return 0;
    }
    return 0;
}


void mostrar_tabuleiro(ESTADO *e,FILE *stdout,int cmd) {
    COORDENADA c;
    for (int lin = 8; lin > 0; lin--) {
        if (cmd == 2) fprintf(stdout, "%d ", lin);
        for (int col = 0; col <= 7; col++) {
            c.linha = lin - 1;
            c.coluna = col;
            if (cmd == 1) fprintf(stdout, "%c", obter_estado_casa(e, c));
            else fprintf(stdout, "%c ", obter_estado_casa(e, c));
        }
        fprintf(stdout, "\n");
    }
    if (cmd == 2) fprintf(stdout, "  a b c d e f g h \n");
}


void prompt(ESTADO *e) {
    printf("\n");

    printf(" _____________________________________________________________________________________________________\n");
    printf("|    Próximo jogador    |    Última jogada    |    Número de jogadas feitas    |    Último comando    |\n");
    printf("|           %d           |         %c%d          |               %02d               |          %d           |\n",
           obter_jogador_atual(e),
           obter_ultima_jogada(e).coluna + 97, obter_ultima_jogada(e).linha + 1, obter_numero_de_jogadas(e),
           obter_comando(e));
    printf(" ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n");
}


void vencedor(int jogador) {
    printf("  ______________________________________________________________________________________________________\n");
    printf("||‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾||\n");
    printf("||    ______       ||       ______     ||       ______     _______              ________     _   _   _  ||\n");
    printf("||  ||‾‾‾‾‾‾||    ||||    ||‾‾‾‾‾‾||  ||||    ||‾‾‾‾‾‾|| ||_______| \\\\      || | _______|   | | | | | | ||\n");
    printf("||  ||______||   ||  ||   ||______|| ||  ||   ||______|| ||_____    ||\\\\    || | |______    | | | | | | ||\n");
    printf("||  ||‾‾‾‾‾‾     ||__||   ||\\\\‾‾‾    ||__||   ||\\\\‾‾‾‾   ||_____|   ||  \\\\  || |_______ |   |_| |_| |_| ||\n");
    printf("||  ||          ||____||  ||  \\\\    ||____||  ||  ‾‾‾‾|| ||_______  ||    \\\\||  ______| |    _   _   _  ||\n");
    printf("||  ||         ||      || ||    \\\\ ||      || ||______|| ||_______| ||      \\\\ |________|   |_| |_| |_| ||\n");
    printf("||______________________________________________________________________________________________________||\n");
    printf("||‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾||\n");

    if (jogador == 1) {
        printf("||                                          ‾‾‾‾‾‾|                                                     ||\n");
        printf("||                                          ‾‾‾‾| |                                                     ||\n");
        printf("||                                              | |                                                     ||\n");
        printf("||                                              | |                                                     ||\n");
        printf("||                                              | |                                                     ||\n");
        printf("||                                              | |                                                     ||\n");

    } else {
        printf("||                                           |‾‾‾‾‾‾‾‾‾‾|                                               ||\n");
        printf("||                                            ‾‾‾‾‾‾‾ | |                                               ||\n");
        printf("||                                                    | |                                               ||\n");
        printf("||                                            ________| |                                               ||\n");
        printf("||                                            ||‾‾‾‾‾‾| |______                                         ||\n");
        printf("||                                            ||______|_|_____/                                         ||\n");
    }
}
