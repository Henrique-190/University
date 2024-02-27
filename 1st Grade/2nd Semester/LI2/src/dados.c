/** \file dados.c
 * Ficheiro com funções que acedem aos dados
 */
#include <stdlib.h>
#include "dados.h"

void altera_comando(ESTADO *e, int cmd) {
    e->num_comando = cmd;
}


void armazena_jogada(COORDENADA c1, COORDENADA c2, int i, ESTADO *estado) {
    estado->jogadas[i].jogador1 = c1;
    estado->jogadas[i].jogador2 = c2;
}


ESTADO *inicializar_estado() {
    ESTADO *e;
    e = malloc(sizeof(ESTADO));

    e->jogador_atual = 2;
    e->num_comando = 1;
    e->num_jogadas = -1;
    e->ultima_jogada.linha = 4;
    e->ultima_jogada.coluna = 4;

    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            e->tab[i][j] = VAZIO;
        }
    }

    e->tab[3][4] = BRANCA;
    e->tab[7][0] = UM;
    e->tab[0][7] = DOIS;

    refresh_board(e, obter_ultima_jogada(e));
    return e;
}


int obter_comando(ESTADO *e) {
    return e->num_comando;
}


CASA obter_estado_casa(ESTADO *e, COORDENADA c) {
    return e->tab[7 - c.linha][c.coluna];
}


int obter_jogador_atual(ESTADO *e) {
    return e->jogador_atual;
}


int obter_numero_de_jogadas(ESTADO *e) {
    return e->num_jogadas;
}


COORDENADA obter_ultima_jogada(ESTADO *e) {
    return e->ultima_jogada;
}


COORDENADA obter_x_jogada(ESTADO *e,int i,int jogador) {
    return jogador == 1 ? e->jogadas[i].jogador1 : e->jogadas[i].jogador2;
}


void refresh_board (ESTADO *e, COORDENADA c) {
    if (e->jogador_atual == 2) {
        e->jogadas[obter_numero_de_jogadas(e)].jogador2.linha = c.linha;
        e->jogadas[obter_numero_de_jogadas(e)].jogador2.coluna = c.coluna;
        e->jogador_atual = 1;
        e->num_jogadas++;

    } else {
        e->jogador_atual = 2;
        e->jogadas[obter_numero_de_jogadas(e)].jogador1.linha = c.linha;
        e->jogadas[obter_numero_de_jogadas(e)].jogador1.coluna = c.coluna;
    }

    e->tab[7 - obter_ultima_jogada(e).linha][obter_ultima_jogada(e).coluna] = PRETA;
    int lin = 7 - c.linha;
    e->tab[lin][c.coluna] = BRANCA;

    e->ultima_jogada.linha = (c.linha);
    e->ultima_jogada.coluna = (c.coluna);
}


void str_to_casa (const char *linha, ESTADO *estado, int l) {
    for (int i = 0; i < 8; i++) {
        if (linha[i] == '*')
            estado->tab[l][i] = BRANCA;
        else if (linha[i] == '#')
            estado->tab[l][i] = PRETA;
        else if (linha[i] == '1')
            estado->tab[l][i] = UM;
        else if (linha[i] == '2')
            estado->tab[l][i] = DOIS;
        else
            estado->tab[l][i] = VAZIO;
    }
}
