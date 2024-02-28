/** \file logica.c
 * Ficheiro com funções que verificam a jogabilidade do jogo.
 */
#include <stdio.h>
#include "dados.h"
#include "logica.h"
#include "io_aux.h"

void jogar(ESTADO *e, COORDENADA c) {
    if (!verifica_coord(e, c)) printf("Jogada impossível, tente novamente.\n");
    else refresh_board(e, c);
}


int verifica_coord(ESTADO *e, COORDENADA c) {
    int reslinha = c.linha - obter_ultima_jogada(e).linha;
    int rescoluna = c.coluna - obter_ultima_jogada(e).coluna;
    CASA casa = obter_estado_casa(e, c);

    return (reslinha >= (-1) && reslinha <= 1 && rescoluna >= (-1) && rescoluna <= 1 &&
            (casa == VAZIO || casa == UM || casa == DOIS)) ? 1:0;
}


int fim_jogo(ESTADO *e) {
    COORDENADA ultcrd = obter_ultima_jogada(e);
    COORDENADA c;
    int result = 0;

    if (ultcrd.linha == 0 && ultcrd.coluna == 0) {
        return 1;
    } else if (ultcrd.linha == 7 && ultcrd.coluna == 7)
        return 2;

    for(int i=-1;i<=1;i++)
        for(int j=-1;j<=1;j++){
            c.linha=ultcrd.linha+i;
            c.coluna=ultcrd.coluna+j;
            if (coordenada_valida(c) && verifica_coord(e,c))
                result++;
        }

    if (result == 0)
        return (obter_jogador_atual(e) == 1) ? 2 : 1;
    return 2 + result;
}
