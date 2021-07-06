/** \file main.c
 * Ficheiro com a função principal.
 */
#include <stdio.h>
#include "dados.h"
#include "interface.h"

/**
@file main.c
 Ficheiro principal.
*/

/**
\brief Função principal do projeto.
*/
int main() {
    ESTADO *e, *ae;
    e = inicializar_estado();
    ae = inicializar_estado();

    FILE *ficheiro;
    ficheiro = fopen("ficheiro.txt", "w+");

    while (interpretador(ae, e, ficheiro));
}
