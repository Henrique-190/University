#ifndef PROJETOLI2_INTERFACE_H
#define PROJETOLI2_INTERFACE_H

////funções
int jogar(ESTADO *e, COORDENADA c);
void mostrar_tabuleiro(ESTADO *e);
int interpretador(ESTADO *e);
void refresh_board (ESTADO *e, COORDENADA c);

#endif //PROJETOLI2_INTERFACE_H
