/** \file io.c
 * Ficheiro com funções que respondem a determinados comandos
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "io.h"
#include "interface.h"
#include "dados.h"
#include "logica.h"
#include "listas.h"
#include "io_aux.h"

void grava(FILE *ficheiro,ESTADO *e) {
    ficheiro = fopen("ficheiro.txt", "w");
    mostrar_tabuleiro(e, ficheiro, 1);
    fprintf(ficheiro, "\n");
    movs(e, ficheiro, 1);
    fclose(ficheiro);
}


void jog(ESTADO *e) {
    LISTA l = l_coord_adj(obter_ultima_jogada(e), obter_jogador_atual(e));
    l = hipord(l, e);
    LISTA segundal = l;

    if (!jogada_favoravel(l, e)) {
        int t = tamanho_lista(segundal);
        srand(time(NULL));
        int resultado = (rand() % t);
        for (; resultado > 0; resultado--, segundal = proximo(segundal));
        COORDENADA *coord;
        coord = (COORDENADA *) devolve_cabeca(segundal);
        jogar(e, *coord);
    }
}


void jog2(ESTADO *e) {
    LISTA l = l_coord_adj(obter_ultima_jogada(e), obter_jogador_atual(e));
    l = area_par_possivel(l, e);

    int t = tamanho_lista(l);
    srand(time(NULL));

    int resultado = (rand() % t);
    for (; resultado > 1; resultado--, l = proximo(l));
    COORDENADA *coord;
    coord = (COORDENADA *) devolve_cabeca(l);
    jogar(e, *coord);
}


ESTADO le(FILE *ficheiro) {
    ficheiro = fopen("ficheiro.txt", "r");
    ESTADO *estado;
    estado = inicializar_estado();

    int num_jog;
    char jog1[BUF_SIZE], jog2[BUF_SIZE], linha[BUF_SIZE];

    for (int i = 0; fgets(linha, BUF_SIZE, ficheiro) != NULL && i < 8; i++)
        str_to_casa(linha, estado, i);

    for (int i = 0; fgets(linha, BUF_SIZE, ficheiro) != NULL; i++) {
        int num_tokens = sscanf(linha, "%d: %s %s", &num_jog, jog1, jog2);
        if (num_tokens == 3 || num_tokens == 2) {
            COORDENADA c1 = str_to_coord(jog1);
            COORDENADA c2 = num_tokens == 3 ? str_to_coord(jog2) : (COORDENADA) {-1, -1};
            armazena_jogada(c1, c2, i, estado);

            if (num_tokens == 3) estado->num_jogadas++;
            estado->jogador_atual = num_tokens == 3 ? 1 : 2;
            estado->ultima_jogada.linha = num_tokens == 3 ? c2.linha : c1.linha;
            estado->ultima_jogada.coluna = num_tokens == 3 ? c2.coluna : c1.coluna;
        }
    }
    fclose(ficheiro);
    return *estado;
}


void movs(ESTADO *e,FILE *stdout,int output) {
    int j = obter_numero_de_jogadas(e), i, linUm, colUm;
    if (output == 2) fprintf(stdout, "__| Jogador 1 | Jogador 2\n");

    for (i = 0; i < j; i++) {
        linUm = obter_x_jogada(e, i, 1).linha + 1;
        colUm = obter_x_jogada(e, i, 1).coluna + 97;
        int linDois = obter_x_jogada(e, i, 2).linha + 1;
        int colDois = obter_x_jogada(e, i, 2).coluna + 97;

        if (output == 1) fprintf(stdout, "%02d: %c%d %c%d\n", i + 1, colUm, linUm, colDois, linDois);
        else fprintf(stdout, "%02d|    %c%d     |    %c%d\n", i + 1, colUm, linUm, colDois, linDois);
    }

    if (obter_jogador_atual(e) == 2) {
        linUm = e->jogadas[j].jogador1.linha + 1;
        colUm = e->jogadas[j].jogador1.coluna + 97;

        if (output == 1) fprintf(stdout, "%02d: %c%d\n", i + 1, colUm, linUm);
        else {
            fprintf(stdout, "%02d|    %c%d\n", i + 1, colUm, linUm);
            fprintf(stdout, "¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\n");
        }
    }
}


void pos(ESTADO *e,int jogada) {
    int itemp = jogada;

    while (itemp < obter_numero_de_jogadas(e)) {
        int linha1 = obter_x_jogada(e, itemp, 1).linha;
        int coluna1 = obter_x_jogada(e, itemp, 1).coluna;
        int linha2 = obter_x_jogada(e, itemp, 2).linha;
        int coluna2 = obter_x_jogada(e, itemp, 2).coluna;

        e->tab[7 - linha1][coluna1] = VAZIO;
        e->tab[7 - linha2][coluna2] = VAZIO;
        itemp++;
    }
    e->tab[7 - obter_x_jogada(e, itemp, 1).linha][obter_x_jogada(e, itemp, 1).coluna] = VAZIO;
    e->jogador_atual = 1;
    e->ultima_jogada = obter_x_jogada(e, jogada - 1, 2);
    e->tab[7 - obter_ultima_jogada(e).linha][obter_ultima_jogada(e).coluna] = BRANCA;
    e->num_jogadas = jogada;
}
