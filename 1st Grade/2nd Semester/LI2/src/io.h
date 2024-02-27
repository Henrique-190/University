#ifndef RASTROSLI2_IO_H
#define RASTROSLI2_IO_H

#include "dados.h"
#include "listas.h"

/**
@file io.h
Funções que respondem a determinados comandos.
*/

/**
\brief Função que grava o estado atual do jogo num ficheiro que se chama "Ficheiro.txt".
 \param ficheiro Apontador para o ficheiro;
 \param e Estado.
*/
void grava(FILE *ficheiro, ESTADO *e);


/**
\brief Função que joga pela vez do jogador. Heurística: Flood Fill.
 \param e Estado do jogo.
 */
void jog(ESTADO *e);


/**
\brief Função que joga pela vez do jogador. Heurística: Estratégia baseada na paridade.
 \param e Estado do jogo.
 */
void jog2 (ESTADO *e);


/**
\brief Função que lê o ficheiro criado e altera o estado do jogo.
 \param ficheiro apontador do ficheiro.
 \returns O estado que estava no ficheiro.
*/
ESTADO le(FILE *ficheiro);


/**
\brief Função que imprime todas as jogadas anteriores.
\brief Se o jogador a jogar for o jogador 2, então significa que o jogador 1 já jogou.
 \param e Estado;
 \param stdout Apontador para o ficheiro;
 \param output Dá a opção de imprimir de uma forma (se é para o ficheiro criado, ou para a interface).
*/
void movs(ESTADO *e,FILE *stdout,int output);


/**
\brief Função que volta para um número de jogada menor que o atual.
 \param e Estado;
 \param jogada Jogada para onde o jogador quer recuar.
*/
void pos(ESTADO *e,int jogada);

#endif //RASTROSLI2_IO_H
