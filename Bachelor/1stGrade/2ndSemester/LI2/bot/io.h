#ifndef BOT_IO_H
#define BOT_IO_H

#include "dados.h"
#include "listas.h"
#include <stdio.h>

/**
@file io.h
Funções que respondem a determinados comandos.
*/

/**
\brief Função que grava o estado atual do jogo num ficheiro que se chama "Ficheiro.txt".
 \param c Ficheiro;
 \param e Estado.
*/
void grava(char c[], ESTADO *e);

/**
\brief Função que lê o ficheiro criado e altera o estado do jogo.
 \param c Ficheiro.
 \returns O estado que estava no ficheiro.
*/
ESTADO le(char c[]);


/**
\brief Função que imprime todas as jogadas anteriores.
\brief Se o jogador a jogar for o jogador 2, então significa que o jogador 1 já jogou.
 \param e Estado;
 \param stdout Apontador para o ficheiro;
 \param output Dá a opção de imprimir de uma forma (se é para o ficheiro criado, ou para a interface).
*/
void movs(ESTADO *e,FILE *stdout,int output);

#endif //BOT_IO_H
