/*
 Autores:
 - Diogo da Silva Rebelo, a93278, 2ºAno, MIEI, Universidade do Minho;
 - Henrique José Fernandes Alvelos, a93316, 2ºAno, MIEI, Universidade do Minho.

1. Descrição das principais funções:
 i. shaf_COD: Função que pega num ficheiro com extensão .shaf e outro com extensão .cod e descodifica, dando origem um ficheiro
              com o nome desse ficheiro (sem extensão .cod nem .shaf) e retornando o nome desse mesmo. Primeiramente, transfere
              esses ficheiros que pegou inicialmente para a memória, coloca cada bloco do ficheiro cod numa árvore binária,
              construindo uma lista de árvores binárias com esses códigos. Quanto ao ficheiro shaf, divide em blocos e
              converte-o em binário, em que cada caractere no ficheiro shaf é equivalente a outros 8 caracteres em binário.
              Depois disso, usa a lista de árvores e a lista de blocos em binário e começa a encontrar os códigos
              correspondentes.
    i.1: Funções usadas:
        sizef;
        output;
        cria_arvore;
        insere_lista;
        inverte_lista;
        shaf_BIN;
        insere_binario;
        inverte_binario;
        find_cod;
        t_blocos.

        
 ii. rle_SHAF_cod: Função que pega num ficheiro com extensão .rle.shaf e outro com extensão .rle.cod e descodifica, podendo dar
                 origem um dos dois ficheiros: apenas sem a extensão .shaf, se forçar só a descodificação SF, ou sem a extensão
                 .rle.shaf. A descodificação SF é feita na função shaf_cod. Quanto à descompressão RLE, o ficheiro criado com a 
                 função acima é passado para a memória e é convertido em binário. Depois disso, verifica de 8 em 8 caracteres se 
                 é igual a "00000000". Se for, verifica os próximos 8 e converte-o para decimal, representando, em ascii, a letra
                 a ser repetida. Além disso, verifica os próximos 8 caracteres e também os converte para decimal, representando,
                 em ascii, o número de vezes que essa função é repetida. Com isto, imprime o número de vezes essa letra. Se não
                 for igual a "00000000", converte para decimal e imprime esse número como se fosse uma "char"
    ii.1 Funções usadas:
        shaf_cod;
        sizef;
        bin_decimal.

 2. Estruturas de Dados:
 - STRING_D -> Lista ligada de strings utilizada para alocar os caracteres binários;
 - COD_D -> usada para alocar o código ascii correspondente a um determinado binário e o tamanho desse binário;
 - BTREE_D -> Árvore de procura onde estão os códigos de um bloco do ficheiro .cod;
 - LISBTREE_D -> Lista das árvores de procura onde estão os códigos de cada bloco do ficheiro .cod.
*/

#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include "modD.h"

#define FSIZE_DEFAULT_BLOCK_SIZE 524288       // Default block size = 512 KBytes
#define FSIZE_MIN_BLOCK_SIZE 512              // Min block size = 512 Bytes
#define FSIZE_MAX_BLOCK_SIZE 67108864         // Max block size = 64 MBytes
#define FSIZE_MAX_NUMBER_OF_BLOCKS 4294967296 // Max number of blocks that can be returned = 2^32 blocks
#define FSIZE_MAX_SIZE_FSEEK 2147483648       // Max size permitted in fseek/ftell functions = 2 GBytes
#define FSIZE_ERROR_BLOCK_SIZE -1             // Error: Block size is larger than max value
#define FSIZE_ERROR_NUMBER_OF_BLOCKS -2       // Error: Number of Blocks exceeds max value permitted
#define FSIZE_ERROR_IN_FILE -3                // Error: Opening or reading file
#define FSIZE_ERROR_IN_FTELL -1L              // Error: When using ftell()

/* Diferentes estruturas de dados */

//Lista ligada de strings
typedef struct string_D
{
    char *nodo;
    struct string_D *prox;
} STRING_D;

//Lista que contém o código ascii e o tamanho codificação dele em binário
typedef struct cod_D
{
    int codigo;
    int tamanho;
} COD_D;

//Árvore de procura com os códigos de cada bloco
typedef struct btree_D
{
    int raiz;
    int codigo;
    struct btree_D *direito;
    struct btree_D *esquerdo;
} BTREE_D;

//Lista de árvores de procura com os códigos de cada bloco
typedef struct lisbtree_D
{
    struct btree_D *bloco;
    struct lisbtree_D *prox;
} LISBTREE_D;

/* Funções */

long long fsizeD(FILE *fp_in, unsigned char *filename, unsigned long *the_block_size, long *size_of_last_block)
{
    unsigned long long total;
    long long n_blocks;
    unsigned long n_read, block_size;
    unsigned char *temp_buffer;
    int fseek_error;
    FILE *fp;

    block_size = *the_block_size;
    if (block_size > FSIZE_MAX_BLOCK_SIZE)
        return (FSIZE_ERROR_BLOCK_SIZE);
    if (block_size == 0UL)
        block_size = FSIZE_DEFAULT_BLOCK_SIZE;
    if (block_size < FSIZE_MIN_BLOCK_SIZE)
        block_size = FSIZE_MIN_BLOCK_SIZE;
    *the_block_size = block_size;

    if (filename == NULL || *filename == 0)
        fp = fp_in;
    else
    {
        fp = fopen(filename, "rb");
        if (fp == NULL)
            return (FSIZE_ERROR_IN_FILE);
    }

    fseek_error = fseek(fp, 0L, SEEK_SET);
    if (fseek_error)
        return (FSIZE_ERROR_IN_FILE);

    fseek_error = fseek(fp, 0L, SEEK_END);
    if (!fseek_error)
    {
        total = ftell(fp);
        if (total == FSIZE_ERROR_IN_FTELL)
            return (FSIZE_ERROR_IN_FILE);
        n_blocks = total / block_size;
        if (n_blocks * block_size == total)
            *size_of_last_block = block_size;
        else
        {
            *size_of_last_block = total - n_blocks * block_size;
            n_blocks++;
        }
        fseek_error = fseek(fp, 0L, SEEK_SET);
        if (fseek_error)
            return (FSIZE_ERROR_IN_FILE);
        else
            return (n_blocks);
    }

    n_blocks = FSIZE_MAX_SIZE_FSEEK / block_size - 1; // In reality fseek() can't handle FSIZE_MAX_SIZE_FSEEK of 2GBytes, so let's use a smaller size
    fseek_error = fseek(fp, n_blocks * block_size, SEEK_SET);
    if (fseek_error)
        return (FSIZE_ERROR_IN_FILE);

    temp_buffer = malloc(sizeof(unsigned char) * block_size);
    do
    {
        n_blocks++;
        n_read = fread(temp_buffer, sizeof(unsigned char), block_size, fp);
    } while (n_read == block_size && n_blocks <= FSIZE_MAX_NUMBER_OF_BLOCKS);

    free(temp_buffer);
    if (n_blocks > FSIZE_MAX_NUMBER_OF_BLOCKS)
        return (FSIZE_ERROR_NUMBER_OF_BLOCKS);

    if (n_read == 0L)
    {
        *size_of_last_block = block_size;
        n_blocks--;
    }
    else
        *size_of_last_block = n_read;

    if (filename == NULL || *filename == 0)
    {
        fseek_error = fseek(fp, 0L, SEEK_SET);
        if (fseek_error)
            return (FSIZE_ERROR_IN_FILE);
    }
    else
        fclose(fp);

    return (n_blocks);
}

/* Retorna informação do ficheiro consoante o inteiro i:
    - número de blocos;
    - tamanho do bloco;
    - tamanho do último bloco;
    - tamanho total.
*/
unsigned long sizef(char *filename, int i)
{
    unsigned long long total;
    long long n_blocks;
    unsigned long size_of_last_block, block_size;
    FILE *fp;

    block_size = FSIZE_DEFAULT_BLOCK_SIZE;
    n_blocks = fsizeD(NULL, ("%s", filename), &block_size, &size_of_last_block);
    total = (n_blocks - 1) * block_size + size_of_last_block;

    if (i == 1)
        return n_blocks;
    else if (i == 2)
        return block_size;
    else if (i == 3)
        return size_of_last_block;
    else
        return total;
}

/* Apresenta o resultado no output */
void output(char *fileSHAF, double tempo, char *nome, int tipo)
{
    printf("Diogo Rebelo, a93278, MIEI - CD\n");
    printf("Henrique Alvelos, a93316, MIEI - CD\n");

    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    printf("Data: %d-%02d-%02d %02d:%02d:%02d\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min,
           tm.tm_sec);

    printf("Módulo D (descodificação dum ficheiro shaf)\n");
    printf("Número de blocos: %ld\n", sizef(fileSHAF, 1));
    long int tamanho_antigo = tipo != 3 ? sizef(("%s", fileSHAF), 4) : 0;
    long int tamanho_novo = 0;
    if (tipo != 3)
    {
        tamanho_novo = sizef(("%s", nome), 4);
    }
    printf("Tamanho do ficheiro antes e depois do ficheiro gerado: %ld/%ld\n", tamanho_antigo, tamanho_novo);
    printf("Tempo de execução do módulo em milissegundos: %f\n", tempo);
    tipo == 3 ? printf("Nenhum ficheiro gerado\n") : printf("Ficheiro gerado: %s\n", nome);
}

/* Coloca numa árvore de procura o código recebido */
BTREE_D *insere_arvore(char *code, BTREE_D *arvore, int ascii)
{
    //Coloca 0 ou 1 na raíz consoante a 1ª char do código
    if (code[0] == '0')
        arvore->raiz = 0;
    else
        arvore->raiz = 1;
    arvore->codigo = -1;

    /* Insere o resto da string na árvore binária, recursivamente. Quando a string termina, coloca o código ascii
       correspondente
    */
    if (code[1])
    {
        if (code[1] == '0')
        {
            if (!(arvore->esquerdo))
            {
                arvore->esquerdo = malloc((sizeof(struct btree_D)));
                arvore->esquerdo->esquerdo = NULL;
                arvore->esquerdo->direito = NULL;
            }
            arvore->esquerdo = insere_arvore(code + 1, arvore->esquerdo, ascii);
        }
        else if (code[1] == '1')
        {
            if (!(arvore->direito))
            {
                arvore->direito = malloc((sizeof(struct btree_D)));
                arvore->direito->esquerdo = NULL;
                arvore->direito->direito = NULL;
            }
            arvore->direito = insere_arvore(code + 1, arvore->direito, ascii);
        }
    }
    else
        arvore->codigo = ascii;

    return arvore;
}

/* Insere *a cabeça da lista de strings o binário convertido */
STRING_D *insere_binario(char *binario, STRING_D *lista)
{
    STRING_D *nova;
    nova = malloc(sizeof(struct string_D));

    nova->prox = lista;
    nova->nodo = strdup(binario);

    return nova;
}

/* Insere à cabeça da lista a árvore de procura criada */
LISBTREE_D *insere_lista(BTREE_D *codigos, LISBTREE_D *lista)
{
    LISBTREE_D *result;
    result = malloc(sizeof(struct lisbtree_D));
    result->prox = lista;
    result->bloco = codigos;

    return result;
}

/* Inverte a lista de árvores */
LISBTREE_D *inverte_lista(LISBTREE_D *lista)
{
    LISBTREE_D *result;
    result = malloc(sizeof(struct lisbtree_D));
    result = NULL;
    while (lista->prox)
    {
        result = insere_lista(lista->bloco, result);
        lista = lista->prox;
    }
    result = insere_lista(lista->bloco, result);
    return result;
}

/* Inverte a string de binários */
STRING_D *inverte_binario(STRING_D *bin)
{
    STRING_D *nova;
    nova = malloc(sizeof(struct string_D));
    nova = NULL;
    while (bin->prox)
    {
        nova = insere_binario(bin->nodo, nova);
        bin = bin->prox;
    }
    return nova;
}

/* Coloca cada código do bloco na árvore binária */
BTREE_D *cria_arvore(BTREE_D *bTreeCod, char *read_COD, int bloco)
{
    //Aloca memória para cada sub-árvore da árvore de códigos
    bTreeCod->esquerdo = (BTREE_D *)malloc(sizeof(struct btree_D));
    bTreeCod->direito = (BTREE_D *)malloc(sizeof(struct btree_D));

    //Coloca em i o índice da posição inicial da codificação do 1º bloco
    int n_arrobas = 4;
    int i = 0;
    for (; n_arrobas; i++)
    {
        if (read_COD[i] == '@')
            n_arrobas--;
    }

    int ascii = 0;

    //Se não for o 1º bloco, coloca em i o índice da posição inicial da codificação do x bloco
    while (bloco)
    {
        n_arrobas = 2;
        for (; n_arrobas && read_COD[i]; i++)
            if (read_COD[i] == '@')
                n_arrobas--;
        bloco--;
    }

    //Coloca cada código binário dum bloco do ficheiro .cod em memória numa árvore de procura
    while (read_COD[i] != '@')
    {
        if (read_COD[i] == ';')
        {
            ascii++;
            i++;
        }
        else
        {
            int tamanho = 1;
            for (; read_COD[i + tamanho] != ';' && read_COD[i + tamanho] != '@'; tamanho++)
                ;
            char code[tamanho];
            for (int ii = 0; ii < tamanho; ii++)
                code[ii] = read_COD[ii + i];
            code[tamanho] = '\0';

            if (code[0] == '0')
                bTreeCod->esquerdo = insere_arvore(code, bTreeCod->esquerdo, ascii);
            else
                bTreeCod->direito = insere_arvore(code, bTreeCod->direito, ascii);
            i += tamanho;
        }
    }
    return bTreeCod;
}

/* Retorna uma string binária que representa um bloco de codificação SF */
char *shaf_BIN(char *file_content, char *binary, int nbloco)
{
    //Coloca em i o índice da posição inicial do tamanho da codificação SF do 1º bloco
    int index = 0;
    int n_arrobas = 2;
    for (; n_arrobas; index++)
    {
        if (file_content[index] == '@')
            n_arrobas--;
    }

    //Obtém o tamanho do bloco e coloca em index a posição inicial da codificação SF do bloco
    int tamanho;
    while (nbloco > (-1))
    {
        tamanho = 0;
        while (file_content[index] != '@')
        {
            int z = file_content[index] - '0';
            tamanho = tamanho * 10 + z;
            index++;
        }
        index++;

        //Se não for o 1º bloco, coloca em index o índice da posição inicial do tamanho da codificação SF do x bloco
        if (nbloco)
        {
            index += tamanho;
            index++;
        }
        nbloco--;
    }
    //Transforma cada elemento de um bloco do ficheiro .shaf em binário
    while (tamanho)
    {
        int elem_ascii = file_content[index];
        for (int i = 7; i >= 0; i--)
        {
            int k = elem_ascii >> i;
            if (k & 1)
                strcat(binary, "1");
            else
                strcat(binary, "0");
        }
        index++;
        tamanho--;
    }
    return binary;
}

/* Obtém a char codificada e o tamanho do código binário que representa */
COD_D *find_cod(char *binary, struct btree_D *tree)
{
    COD_D *codigo;
    codigo = malloc(sizeof(struct cod_D));

    //Posiciona a árvore de acordo com o primeiro elemento do código binário
    int i = 0;
    codigo->codigo = -1;
    codigo->tamanho = 0;
    if (binary)
    {
        if (binary[i] == '0')
        {
            tree = tree->esquerdo;
        }
        else
        {
            tree = tree->direito;
        }
    }

    //Posiciona a árvore de acordo com o próximo elemento do código binário
    while (tree && binary[i + 1])
    {
        codigo->codigo = tree->codigo;

        if (binary[i + 1] == '0')
        {
            tree = tree->esquerdo;
        }
        else
        {
            tree = tree->direito;
        }
        codigo->tamanho++;
        i++;
    }

    //Se não for encontrado nenhum código, o tamanho é igual a 0
    if (codigo->codigo == -1)
    {
        codigo->tamanho = 0;
    }
    return codigo;
}

/* Obter o tamanho do bloco do ficheiro original ou .shaf */
int t_blocos(char *file_content, int bloco, int cod_ou_shaf)
{
    int index = 0;
    int result = 0;
    int n_arrobas = cod_ou_shaf ? (3 + bloco * 2) : (2 + bloco * 2);

    //Coloca em i o índice da posição inicial do tamanho do 1º bloco, original ou .shaf
    while (n_arrobas && file_content[index])
    {
        if (file_content[index] == '@')
            n_arrobas--;
        index++;
    }

    //Obtém o tamanho do bloco original ou .shaf
    while (file_content[index] != '@')
    {
        int z = file_content[index] - '0';
        result = result * 10 + z;
        index++;
    }
    return result;
}

/* Faz a descodificação SF */
char *shaf_COD(char *file_SHAF, char *file_COD, int rle)
{
    //Calcula o tamanho dos ficheiros
    unsigned int tamanho_shaf = sizef(file_SHAF, 4);
    unsigned int tamanho_cod = sizef(file_COD, 4);

    //Cria as strings com os respetivos tamanhos para guardar os ficheiros
    char read_SHAF[tamanho_shaf];
    char read_COD[tamanho_cod];

    //Abre os ficheiros e coloca-os em memória
    FILE *shaf;
    shaf = fopen(("%s", file_SHAF), "rb");
    fread(read_SHAF, 1, tamanho_shaf, shaf);
    fclose(shaf);

    FILE *cod;
    cod = fopen(("%s", file_COD), "r+");
    fread(read_COD, 1, tamanho_cod, cod);

    //Obtém o número original de blocos
    int original_nblocos = 0;
    int index = 3;
    while (read_COD[index] != '@')
    {
        int z = read_COD[index] - '0';
        original_nblocos = original_nblocos * 10 + z;
        index++;
    }

    LISBTREE_D *lista;
    lista = malloc(sizeof(struct lisbtree_D));
    lista = NULL;

    //Cria uma lista de árvores com cada um dos códigos
    for (int i = 0; i < original_nblocos; i++)
    {
        BTREE_D *codigos;
        codigos = malloc(sizeof(struct btree_D));
        codigos = cria_arvore(codigos, read_COD, i);
        lista = insere_lista(codigos, lista);
    }
    lista = inverte_lista(lista);

    //Guarda no número de blocos do ficheiro .shaf
    int n_blocos_shaf;
    shaf = fopen(("%s", file_SHAF), "rb");
    fscanf(shaf, "@%d@", &n_blocos_shaf);
    fclose(shaf);

    STRING_D *binario;
    binario = malloc(sizeof(struct string_D));
    binario->prox = NULL;

    //Transforma o ficheiro .shaf, que está em memória, em binário
    char *bbloco;
    for (int i = 0; i < n_blocos_shaf; i++)
    {
        bbloco = malloc((tamanho_shaf * 8) * sizeof(char));
        bbloco[0] = '\0';
        bbloco = shaf_BIN(read_SHAF, bbloco, i);
        binario = insere_binario(bbloco, binario);
    }
    binario = inverte_binario(binario);

    COD_D *codigo;
    codigo = malloc(sizeof(struct cod_D));

    //Abre o ficheiro original para escrita com o nome sem a terminação ".shaf"
    FILE *original;
    char *nome_original;
    nome_original = strdup(file_SHAF);
    unsigned long tam_nome_original = strlen(nome_original);
    nome_original[tam_nome_original - 5] = '\0';
    original = fopen(("%s", nome_original), "w+");

    //Substitui o binário pela codificação das árvores binárias de procura
    int index_bloco = 0;
    while (binario)
    {
        int tam_bloco_original = t_blocos(read_COD, index_bloco, 1);
        int tam_bloco_codificado = 0;
        codigo->codigo = '\0';
        codigo->tamanho = 0;
        for (int i = 0; tam_bloco_codificado < tam_bloco_original; i++)
        {
            codigo = find_cod(binario->nodo, lista->bloco);
            tam_bloco_codificado++;
            (binario->nodo) += codigo->tamanho;
            if (codigo->tamanho)
                putc(codigo->codigo, original);
        }

        index_bloco++;
        lista = lista->prox;
        binario = binario->prox;
    }
    fclose(original);
    return nome_original;
}

/* Converte binários para decimal */
int bin_decimal(char *binario)
{
    int result = 0;
    for (int i = strlen(binario) - 1, j = 0; i >= 0; i--, j++)
    {
        unsigned char k = binario[i] - '0';
        k <<= j;
        result += k;
    }
    return result;
}

/* Faz a descodificação SF e/ou RLE */
char *rle_SHAF_cod(char *fileRLE_SHAF, char *fileRLE_COD, char *mode)
{
    char *nome;

    //Verifica se o ficheiro é rle
    int apenas_rle = 0;
    if (mode){
        if(!strcmp(mode,"r")) {
            apenas_rle = 1;
            nome = strdup(fileRLE_SHAF);
        }
    }

    //Faz a descodificação SF
    if(!apenas_rle) nome = shaf_COD(fileRLE_SHAF, fileRLE_COD, 1);

    //Verifica se não existe o modo (s - apenas compressão SF)
    if (!mode || apenas_rle)
    {
        FILE *rle;
        rle = fopen(("%s", nome), "rb");

        int length = strlen(nome);
        int tamanho_rle = sizef(nome, 4);

        nome[length - 4] = '\0';
        FILE *result;
        result = fopen(("%s", nome), "w+");

        //Coloca o ficheiro RLE em memória
        char read_RLE[tamanho_rle];
        fread(read_RLE, tamanho_rle, 1, rle);
        char *binary_RLE;
        binary_RLE = malloc(sizeof(char) * tamanho_rle * 8);

        //Conversão binária char a char
        for (int index = 0; index < tamanho_rle; index++)
        {
            int elem_ascii = read_RLE[index];
            for (int i = 7; i >= 0; i--)
            {
                int k = elem_ascii >> i;
                if (k & 1)
                    strcat(binary_RLE, "1");
                else
                    strcat(binary_RLE, "0");
            }
        }

        int bin_index = 0;
        int tamanho_binario = 8 * tamanho_rle;

        while (bin_index < tamanho_binario)
        {
            char *letra;
            letra = strndup(binary_RLE, 8);

            /* Verifica se a letra representa ou não um ponto:
             - Se for: vê a letra seguinte e o número de vezes a repetir, imprimindo essa letra n vezes;
             - Se não for: apenas imprime a letra no ficheiro.
             */
            if (!strcmp(letra, "00000000"))
            {
                binary_RLE += 8;
                bin_index += 8;
                letra = strndup(binary_RLE, 8);
                char *n_vezes;
                n_vezes = malloc(sizeof(char) * 8);
                binary_RLE += 8;
                bin_index += 8;
                n_vezes = strndup(binary_RLE, 8);

                int letra_rep = bin_decimal(letra);
                int n = bin_decimal(n_vezes);

                for (int ind = 0; ind < n; ind++)
                {
                    putc(letra_rep, result);
                }
                binary_RLE += 8;
                bin_index += 8;
            }
            else
            {
                int l = bin_decimal(letra);
                putc(l, result);
                binary_RLE += 8;
                bin_index += 8;
            }
        }
        fclose(result);
        return nome;
    }
    //Se o modo (5º argumento) for igual a "s", então só faz a descodificação SF. Senão, faz as duas descodificações
    else if (mode[0] == 's')
        return nome;
    else
        return "none";
}