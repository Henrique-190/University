#include "dados.h"
#include <stdio.h>
#include "logica.h"
#include "interface.h"

//Função que inicia o jogo
int jogar(ESTADO *e, COORDENADA c) {
    printf("jogar %d %d\n", c.coluna, c.linha);
   if (verifica_jogada(e,c)==0) {
       printf("Erro! Introduza uma jogada válida.");
       scanf("%d", &c.linha);
       scanf("%d", &c.coluna);
       jogar(e, c);
   }
   else refresh_board(e,c);
   return 1;
}

//função que verifica se a jogada é válida
int verifica_jogada (ESTADO *e, COORDENADA c) {

    int plinha = c.linha;
    int pcoluna = c.coluna;
    int alinha = e->ultima_jogada.linha;
    int acoluna = e->ultima_jogada.coluna;
    int rlinha = plinha-alinha;
    int rcoluna = pcoluna-acoluna;

    if (e->tab[c.linha][c.coluna]==VAZIO) {
        if (rlinha>=(-1) && rlinha<=1 && rcoluna>=(-1) && rcoluna<=1) {
            return 0;
        }
        else return 1;
    }
}