#ifndef BOT_INTERFACE_H
#define BOT_INTERFACE_H

#include <stdio.h>
#include "dados.h"

/**
@file interface.h
Funções que modificam a interface do jogo.
*/

/**
\brief Função que mostra o tabuleiro ao receber um estado
 \param e Estado;
 \param stdout Apontador do ficheiro para onde vai imprimir o tabuleiro;
 \param cmd Número do comando.
*/
void mostrar_tabuleiro(ESTADO *e,FILE *stdout,int cmd);

#endif //BOT_INTERFACE_H
