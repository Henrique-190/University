#define BUF_SIZE 1024
#include <string.h>
#include <stdio.h>
#include "dados.h"
#include "interface.h"

////funções
// Função que mostra o tabuleiro ao receber um estado
// i é linha; j é coluna;
void mostrar_tabuleiro(ESTADO *e) {
    COORDENADA c;
    for(int i=7; i>=0;i--) {
        for(int j=0;j<8;j++) {
            c.coluna=j; c.linha=i;
            if(i==1 && j==1) putchar('1');
            else if(i==8 && j==8) putchar('2');
            else if(obter_estado_casa(e,c)==VAZIO) putchar('.');
            else if(obter_estado_casa(e,c)==BRANCA) putchar('*');
            else putchar('#');
        } putchar('\n');
    }
}

// Função que atualiza o tabuleiro com a nova jogada
void refresh_board (ESTADO *e, COORDENADA c) {
    e->tab[e->ultima_jogada.linha][e->ultima_jogada.coluna]=PRETA;
    e->tab[c.linha][c.coluna]=BRANCA;
    e->ultima_jogada.linha=c.linha;
    e->ultima_jogada.coluna=c.coluna;
}

// Função que interpreta
int interpretador(ESTADO *e) {
    char linha[BUF_SIZE];
    char col[2], lin[2];
    if(fgets(linha, BUF_SIZE, stdin) == NULL)
        return 0;
    if(strlen(linha) == 3 && sscanf(linha, "%[a-h]%[1-8]", col, lin) == 2) {
        COORDENADA coord = {*col - 'a', *lin - '1'};
        jogar(e, coord);
        mostrar_tabuleiro(e);
    }
    return 1;
}