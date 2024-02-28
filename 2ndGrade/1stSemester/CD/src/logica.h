#ifndef MOD_B_LOGICA_H
#define MOD_B_LOGICA_H

// TROCA A POSIÇÃO DA INFORMAÇÃO DE DOIS SÍMBOLOS DENTRO DE UM BLOCO.
void swap(SYM_INFO *xp, SYM_INFO *yp);

// ORGANIZA O ARRAY "SYM_INFO" DE UM BLOCO POR ORDEM DECRESCENTE DE FREQUÊNCIAS.
void bubbleSort_freq(BLOCO *block);

// ORGANIZA O ARRAY "SYM_INFO" DE UM BLOCO POR ORDEM CRESCENTE DE SÍMBOLOS.
void bubbleSort_sym(BLOCO *block);

// ENCONTRA O ÍNDICE RELATIVO À METADE DA SOMA TOTAL DE FREQUÊNCIAS DE UMA PARTE DO BLOCO (COMPREENDIDA ENTRE OS ÍNDICES "MIN" E "MAX");
int find_half(BLOCO *b, int min, int max);

// ATRIBUI O CÓDIGO SHANNON-FANO A CADA SÍMBOLO DE UM BLOCO.
void cod_sf(BLOCO *block);

// FUNÇÃO AUXILIAR À "COD_SF" QUE ADICIONA A CADA SÍMBOLO O BIT (0 OU 1) NO FINAL DO SEU CÓDIGO;
void add_bits(int min, int max, BLOCO *block, int counter);

#endif //MOD_B_LOGICA_H