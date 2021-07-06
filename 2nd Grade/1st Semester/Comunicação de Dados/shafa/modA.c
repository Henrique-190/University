#include "modA.h"
#include "fsize.h"
/* Autores:
André Pizarro Martins, 2ºAno, Universidade do Minho
João Pedro Pereira Caldas, 2ºAno, Universidade do Minho
Última Modificação:
02/02/2021
Descrição das principais funções criadas:
-A função main_modA , que acaba por ser a função principal e que reúne todas as outras funções, mas que começa por calcular o número de blocos que o ficheiro vai ter, o tamanho destes blocos e o tamanho do respetivo ficheiro.
Os argumentos desta função são:
    char *filename - Nome do ficheiro recebido.
    int force_rle - Se é forçado ou nao a fazer a compressão RLE.
    char bs - Tamanho dos blocos.
Mais tarde esta função será auxiliada pela função rle_comp_block que irá comprimir o ficheiro inicial num outro ficheiro de extensão ".rle", e usa como argumentos:
    int forcado - Se o RLE vai ser forçado.
    long nr_blocos - Número de blocos do ficheiro.
    long tam_ult - Tamanho do último bloco.
    long tam_bloco - Tamanho do bloco que se encontra a fazer a compressão.
    long *tam_file - Tamanho do ficheiro.
    char *filename - Nome do ficheiro original.
Por fim, com o ficheiro RLE já feito, calcula-se a frequência com que os caracteres que aparecem neste respetivo ficheiro, usando-se a função modA_freq, que vai calcular as frequências bloco a bloco.
Os seus argumentos são:
    long tam_file - Tamanho do ficheiro RLE.
    long *nr_blocos - Número de blocos.
    long *tam_ult - Tamanho do último bloco.
    long block_size - tamanho dos blocos. */

long block_tam(char s)
{ //Recebe a letra do comando que dará o tamanho de cada bloco.

    long size;

    if (s == 'K')
        size = 655360;
    else if (s == 'm')
        size = 8388608;
    else if (s == 'M')
        size = 67108864;
    else
        size = 65536;

    return size;
}

int taxa_de_rle(long tam_bloco, char arr[])
{ // Calcula a taxa de compressão RLE do bloco de texto.

    long i, j, rle_count = 0, reps;
    char atual, anterior;

    atual = arr[0];

    for (i = 1; i < tam_bloco; i++)
    {

        anterior = atual;
        atual = arr[i];

        if (anterior == atual)
            reps++;

        else if (anterior == '0' || reps > 3)
        {
            rle_count += 3;
            reps = 1;
        }
        else
        { //Imprime a mesma letra até se esta não se repetir mais do que 3 vezes.

            for (j = 0; j < reps; j++)
                rle_count++;

            reps = 1;
        }
    }

    return (100 * (tam_bloco - rle_count) / tam_bloco);
}

int rle_comp_block(int forcado, long nr_blocos, long tam_ult, long tam_bloco, long *tam_file, char *filename)
{ //Função que analisa o ficheiro que foi dado e cria um ficheiro RLE comprimido.

    char *new_filename = malloc(sizeof(filename) + 4), anterior, atual;
    strcpy(new_filename, filename);
    strcat(new_filename, ".rle");
    int k, j, taxa, taxa_final = 0;
    long reps = 1, rle_count = 0, rle_count_total = 0, tam_bloco_atual = tam_bloco, i;
    unsigned char count;

    FILE *fp = fopen(filename, "rb");
    FILE *novo;

    char **arr = malloc(sizeof(char *) * nr_blocos);

    for (i = 0; i < nr_blocos; i++)
    {

        if (i == nr_blocos - 1)
            tam_bloco_atual = tam_ult;

        arr[i] = malloc(sizeof(char) * tam_bloco_atual);
    }

    if (fp == NULL)
        printf("Erro a abrir o ficheiro");
    else
    {

        novo = fopen(new_filename, "wb");

        if (novo == NULL)
            printf("Erro ao abrir o ficheiro RLE\n");
        else
        {

            fseek(fp, 0, SEEK_SET);

            if (nr_blocos == 1)
            {

                fread(arr[0], sizeof(char), tam_ult, fp);
                taxa = taxa_de_rle(tam_ult, arr[0]);
            }
            else
            {
                fread(arr[0], sizeof(char), tam_bloco, fp);
                taxa = taxa_de_rle(tam_bloco_atual, arr[0]);
            }

            if (taxa > 5 || forcado == 1)
            {

                fseek(fp, 0, SEEK_SET);

                tam_bloco_atual = tam_bloco;

                for (j = 0; j < nr_blocos; j++)
                { //faz a compressao pra cada bloco

                    if (j == nr_blocos - 1)
                        tam_bloco_atual = tam_ult;
                    fread(arr[j], sizeof(char), tam_bloco_atual, fp);
                    fseek(fp, tam_bloco_atual, SEEK_CUR);

                    atual = arr[j][0];

                    for (i = 1; i <= tam_bloco_atual; i++)
                    {

                        anterior = atual;
                        atual = arr[j][i];

                        if (anterior == atual)
                            reps++;

                        else if (anterior == '0' || reps > 3)
                        {

                            count = reps;

                            fputc('\0', novo);
                            fprintf(novo, "%c", anterior);
                            fprintf(novo, "%c", count);

                            rle_count += 3;
                            reps = 1;
                        }
                        else
                        { //Imprime a mesma letra até se esta não se repetir mais do que 3 vezes.

                            for (k = 0; k < reps; k++)
                            {
                                rle_count++;
                                fprintf(novo, "%c", anterior);
                            }
                            reps = 1;
                        }
                    }
                }
                rle_count_total += rle_count;
                taxa_final = (100 * (*tam_file - rle_count_total) / (*tam_file));

                *tam_file = rle_count_total;
            }
        }
    }
    fclose(novo);
    return taxa_final;
}

char *modA_freq(char *filename, long nr_blocos, long tam_file, long tam_blocos, long tam_ult)
{ //Função que cria o ficheiro FREQ e calcula a frequência que cada caracter tem no ficheiro RLE.

    long arr[nr_blocos][256], pos = 0, tam_blocos_aux = tam_blocos, j;
    int i, bloco_atual = 1;
    char c;
    FILE *fp = fopen(filename, "rb");
    FILE *novo;
    char *new_filename = malloc(sizeof(filename) + 5);
    strcpy(new_filename, filename);
    strcat(new_filename, ".freq");

    if (fp == NULL)
        printf("Erro a abrir o ficheiro");
    else
    {

        if (tam_file > 1024)
        {

            for (i = 0; i < nr_blocos; i++) // inicializar um array que pode
                for (j = 0; j < 256; j++)   // ser visto como um array de 256
                    arr[i][j] = 0;          // caracteres para cada bloco a 0

            for (i = 0; i < nr_blocos; i++)
            {

                pos = i * tam_blocos;

                if (i == nr_blocos - 1)
                    tam_blocos_aux = tam_ult;

                for (fseek(fp, pos, SEEK_SET), j = 0; !feof(fp) && j < tam_blocos_aux; fseek(fp, 1, SEEK_CUR), j++)
                { // percorre o ficheiro e soma o nr de ocorrencias
                    // de cada elemento no array de cada bloco
                    c = fgetc(fp);

                    arr[i][c]++; // No bloco i , guarda a quantidade de cada caracter para cada bloco            // var de controlo que garante que guarda a quantidade de elementos do bloco já foram lidos
                }
            }

            //---------------------------------------------
            novo = fopen(new_filename, "wb");

            if (novo == NULL)
                printf("Erro ao abrir o ficheiro FREQ\n");
            else
            {

                fprintf(novo, "@N@%ld", nr_blocos);

                for (i = 0; i < nr_blocos; i++)
                { // blocos começam no nr1 , logo,para o ciclo qunado i = nr_blocos +1

                    if (i == nr_blocos - 1)
                        fprintf(novo, "@%ld@", tam_ult); // o ultimo bloco terá um tamanho diferente
                    else
                        fprintf(novo, "@%ld@", tam_blocos); // os restantes devem ter o tamanho definido nos argumentos

                    for (j = 0; j < 256; j++)
                    { // imprime 256 elementos por bloco

                        if (j > 0 && arr[i][j] == arr[i][j - 1])
                            fprintf(novo, ";");
                        else
                            fprintf(novo, "%ld;", arr[i][j]);
                    }
                }
                fprintf(novo, "@0");

                fclose(novo);
            }
        }
    }

    return new_filename;
}

void calcula_rle(long tam_file, long *nr_blocos, long *tam_ult, long block_size)
{ //Análise do tamanho do ficheiro e da sua divisão em blocos para se poder proceder à compressão RLE.

    if (tam_file % block_size == 0)
        *nr_blocos = tam_file / block_size;
    else
        *nr_blocos = tam_file / block_size + 1;

    *tam_ult = tam_file - (*nr_blocos - 1) * block_size;

    if (*nr_blocos > 1 && *tam_ult <= 1024)
    {
        *tam_ult += block_size;
        *nr_blocos--;
    }
}

int main_modA(char *filename, int force_rle, char bs)
{ // Função que chama todas as funções anteriores e calcula a compressão RLE e a frequência do ficheiro.
    struct tm *data;
    time_t seg;
    time(&seg);
    data = localtime(&seg);
    clock_t tempoF = clock();

    int rle = 0;
    unsigned long long total, tam_file_rle;
    long n_blocks, nr_blocos_rle;
    unsigned long size_of_last_block, block_size, tam_ult_rle;
    FILE *fp;
    FILE *rle_fp;

    unsigned char *freq_file = malloc(sizeof(filename) + 4);
    strcpy(freq_file, filename);

    fp = fopen(filename, "rb");
    block_size = block_tam(bs);
    n_blocks = fsize(fp, NULL, &block_size, &size_of_last_block);
    total = (n_blocks - 1) * block_size + size_of_last_block;

    if (n_blocks > 1 && size_of_last_block <= 1024)
    {
        size_of_last_block += block_size;
        n_blocks--;
    }

    long *tam_blocos_rle = malloc(sizeof(long) * n_blocks);

    tam_file_rle = total;

    rle = rle_comp_block(force_rle, n_blocks, size_of_last_block, block_size, &tam_file_rle, filename);

    if (rle != 0)
    { //parte que falta e esta mal -> passar a modA_freq os dados certos do RLE

        strcat(freq_file, ".rle");

        calcula_rle(tam_file_rle, &nr_blocos_rle, &tam_ult_rle, block_size);

        modA_freq(freq_file, nr_blocos_rle, tam_file_rle, block_size, tam_ult_rle);
    }
    else
    {
        modA_freq(freq_file, n_blocks, total, block_size, size_of_last_block);
    }

    fclose(fp);

    printf("André Pizarro Martins, a93297, ");
    printf("João Pedro Pereira Caldas, a93171, ");
    //printf("MIEI/CD, %d-%d-%d ",data->tm_mday,data->tm_mon+1,data->tm_year+1900);
    printf("\nMódulo: A (Cálculo das frequências dos símbolos e compressão RLE)");
    printf("\n Ficheiro: %s (fichiero aberto)", filename);
    printf("\n %ld blocos de %lu bytes + 1 bloco de %lu bytes", n_blocks - 1, block_size, size_of_last_block);
    printf("\n Tamanho do ficheiro = %llu bytes", total);
    if (rle != 0)
        printf("\n Compressão RLE: %s (%d%% compressão)", freq_file, rle);
    printf("\n Ficheiro gerado: %s.freq\n", freq_file);

    return (0);
}

char arg_tam(int argn, char *argv[])
{
    char bs = 'k';
    int i;
    for (i = 2; i < argn - 1; i++)
        if (!strcmp(argv[i], "-b"))
        {
            bs = *argv[i + 1];
        }
    return bs;
}
