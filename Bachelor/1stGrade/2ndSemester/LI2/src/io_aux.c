/** \file io_aux.c
 * Ficheiro com funções auxiliares dos comandos.
 */
#include <stdlib.h>
#include "dados.h"
#include "logica.h"
#include "io_aux.h"

int area_par(ESTADO *etemp, COORDENADA c) {
    jogar(etemp, c);
    return (fim_jogo(etemp) % 2 == 0) ? 1 : 0;
}


LISTA area_par_possivel (LISTA l, ESTADO *e) {
    ESTADO etemp;
    etemp = *e;
    LISTA result = criar_lista();
    LISTA s_result = criar_lista();
    for (; !lista_esta_vazia(l); l = proximo(l)) {
        COORDENADA *cor;
        cor = (COORDENADA *) devolve_cabeca(l);
        if (coordenada_valida(*cor) && verifica_coord(e, *cor)) {
            s_result = insere_cabeca(s_result, cor);
            if (area_par(&etemp, *cor)) {
                result = insere_cabeca(result, cor);
            }
        }
        etemp = *e;
    }
    return lista_esta_vazia(result) ? s_result : result;
}


int compara_coord(COORDENADA c,ESTADO *e) {
    int difc = c.coluna - obter_ultima_jogada(e).coluna;
    int difl = c.linha - obter_ultima_jogada(e).linha;
    difl = (obter_jogador_atual(e)==2)? (-1*difl):(difl);
    return (verifica_coord(e, c)) &&
           ((difl == 0 && difc == -1) || (difl == -1 && difc >= -1 && difc <= 1)) ? 1 : 0;
}


int coordenada_valida(COORDENADA c) {
    return (c.linha >= 0 && c.linha <= 7 && c.coluna >= 0 && c.coluna <= 8) ? 1:0;
}


LISTA hipord(LISTA l,ESTADO *e) {
    LISTA sl, r = criar_lista(), result = criar_lista();

    for (int i = 0; i < 2; i++) {
        r = insere_cabeca(r, devolve_cabeca(l));
        l = proximo(l);
    }

    sl = proximo(l);
    r = insere_cabeca(r, devolve_cabeca(sl));
    r = insere_cabeca(r, devolve_cabeca(l));
    sl = proximo(sl);

    for (; !(lista_esta_vazia(sl)); sl = proximo(sl))
        r = insere_cabeca(r, devolve_cabeca(sl));

    for (; !(lista_esta_vazia(r)); r = proximo(r)) {
        COORDENADA *coord;
        coord = (COORDENADA *) devolve_cabeca(r);
        if (coordenada_valida(*coord) && verifica_coord(e, *coord))
            result = insere_cabeca(result, devolve_cabeca(r));
    }
    return result;
}


int jogada_favoravel(LISTA l, ESTADO *e) {
    ESTADO etemp;
    etemp = *e;

    while (!lista_esta_vazia(l)) {
        COORDENADA *coord;
        coord = (COORDENADA *) devolve_cabeca(l);
        etemp = *e;

        if (compara_coord(*coord, e) || verifica_fim_jogo(&etemp, *coord)) {
            jogar(e, *coord);
            return 1;
        }
        l=proximo(l);
    }
    return 0;
}


LISTA l_coord_adj (COORDENADA ultcrd,int jogador) {
    LISTA l = criar_lista();
    int num1 = (jogador == 1) ? 1 : -1;
    int num2 = (jogador == 1) ? 1 : -1;

    for (int z = 1; z >= -1; z--) {
        for (int i = 1; i >= -1; i--) {
            COORDENADA *coord;
            coord = malloc(sizeof(COORDENADA));
            (*coord).linha = ultcrd.linha + num2;
            (*coord).coluna = ultcrd.coluna + num1;
            l = insere_cabeca(l, coord);
            num1 = (jogador == 1) ? num1 - 1 : num1 + 1;
        }
        (jogador == 1) ? num2-- : num2++;
        num1 = (jogador == 1) ? 1 : -1;
    }
    return l;
}


COORDENADA str_to_coord (const char *coordenada) {
    COORDENADA coord = {*coordenada - 'a', *(coordenada + 1) - '1'};
    return coord;
}


int verifica_fim_jogo(ESTADO *etemp, COORDENADA c) {
    jogar(etemp, c);
    return (fim_jogo(etemp) == 1 || fim_jogo(etemp) == 2) ? 1:0;
}
