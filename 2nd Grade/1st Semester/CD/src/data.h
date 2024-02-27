#ifndef MOD_B_DATA_H
#define MOD_B_DATA_H

typedef struct
{
    /** ID do símbolo */
    int sym;

    /** Frequência do símbolo */
    int freq;

    /** Código SF */
    char cod[256];

} SYM_INFO;

typedef struct bloco
{
    /** Info de cada símbolo */
    SYM_INFO info[256];

    /** Total de frequências */
    int t_freq;

} BLOCO;

typedef struct
{
    /** Tipo de ficheiro (R/N) */
    char ft;

    /** Número de blocos */
    int n_blocks;

} DADOS;

#endif //MOD_B_DATA_H
