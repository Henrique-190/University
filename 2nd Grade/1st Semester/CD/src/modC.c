/*
Autores:
 Gonçalo da Cunha Freitas, 2ºano, Universidade do Minho
 António Ricardo Vieira da Fonseca, 2ºano, Universidade do Minho
Ultima modificação:
 02/01/2021
Descrição das principais funções criadas:
  - A função imprimeOutput() gera um texto na consola que inclui o nome dos autores do módulo, o módulo e uma sucinta descrição do seu propósito.
    Também imprime o número de blocos em que o ficheiro de output foi dividido, o tamanho antes/depois e a taxa de compressão de cada um dos blocos,
    e a compressão global, os dois com precisão de duas casas decimais.
    Finalmente apresenta o tempo de execução do módulo em milissegundos e o nome do ficheiro gerado.
    ºArgumentos:
        int n_blocos - número de blocos em que o ficheiro de output foi dividido
        int t_antes[] - array que contem o tamanhos dos blocos do ficheiro a ser codificado
        int t_despois[] - array que contem o tamanho dos blocos do ficheiro codificado
        clock_t tempo - tempo em ciclos de relógio do início da execução do módulo
        char *fichOrigin - nome do ficheiro a ser codificado
  - A função find_t_antes() devolve o tamanho de cada um dos blocos do ficheiro original, tendo como ponto de refenrência os caracteres '@'
    que têm como identificação na tabela ASCII o número decimal 64.
    ºArgumentos:
        int n_blocos -  número de blocos em que o ficheiro original foi dividido
        unsigned char *buffer - buffer que contém o ficheiro .cod
  - As funções getbufferC() e getbufferO() põem em memória o ficheiro .cod e o ficheiro original, respetivamente.
    A getbufferC() usa a função ftell pois tem em consideração que o ficheiro .cod é relativamente pequeno, enquanto que a getbufferO()
    recebe o tamanho a ser alocado em memória (pois a transferência para memória é feita em blocos de tamanho pré-definido).
    ºArgumentos:
        FILE *fp - apontador para o ficheiro a ser alocado
        int tam_bloco - tamanho (em bytes) a ser alocado  
  - As funções getfichSHAF() e getfichCOD() simplesmente manipulam strings para obter o nome do ficheiro .shaf e .cod
    ºArgumentos:
        char *nome - nome do ficheiro a ser alterado
  - A função getCod() inicializa o conjunto de structs COD que contêm o caracter e o seu código, através do buffer que contém a informação do ficheiro .cod
    ºArgumentos:
        unsigned char *buffer - array que é uma cópia do ficheiro .cod
        int n_blocos - número de blocos em que o ficheiro original foi dividido 
        int *max_size - número máximo de caracteres que um código tem (ao ler o buffer guarda o maior tamanho dos códigos)
  - A função pre_binaryBuffer() inicializa um array de unsigned char com os códigos referentes aos caracteres guardados no ficheiro original.
    Ou seja, se o ficheiro original contiver "aaa" e o código do "a" for "10" inicializa o array com "101010".
    ºArgumentos:
         CODs cod - struct com os caracteres e respetivos códigos do bloco a ser codificado
         char* buffer - array que contém um bloco do ficheiro original 
         int max_size - tamanho máximo que um código pode ter
         int t_antes - tamanho do bloco do ficheiro original
         int *len - tamanho do array gerado
         unsigned char * pre_BIN - array com os códigos SF por ordem em relação ao bloco a ser codificado
  - A função byteTobit() transforma um array de "1" e "0" de até 8 elementos num unsigned char, ou seja "transforma" o array em binário.
    ºArgumentos:
        unsigned char *pre_BIN - array com até 8 caracteres "1" e "0" a ser convertido 
  - A função initFout() inicializa o ficheiro de saída com os caracteres iniciais ("@" e o número de blocos)-
    ºArgumentos:
        FILE *fout - apontador para o ficheiro de saída (.shaf)
        int n_blocos - número de blocos em que o ficheiro original foi dividido
  - A função Print_binaryBuffer() escreve no ficheiro .shaf os códigos em binario. Faz isso pegando 8 em 8 caracteres do array pre_BIN
    e transformando isso num byte. Se o número de caracteres no array pre_BIN não for múltiplo de 8 vai adaptar os ultímos caracteres fazendo um 
    shift para a esquerda, ou seja, o padding existente será um conjunto de bits nulos.
    ºArgumentos:
        FILE *fout - apontador para o ficheiro de saída (.shaf)
        unsigned char *pre_BIN - array com os códigos SF por ordem em relação ao bloco a ser codificado
        int t_antes - tamanho do bloco do ficheiro original
        int len - tamanho do array pre_BIN
  - A função cleanFile() limpa o ficheiro de saída no caso de já existir um ficheiro com o mesmo nome
    ºArgumentos:
        char *nome - nome do ficheiro de saída (.shaf)
  - A função moduloC() é a função principal que dá forma ao módulo, establecendo as bases e inicializando variáveis de forma
    a que o módulo corra corretamente.
    ºArgumentos:
        char *fichOrigin - nome do ficheiro de entrada

  - O tipo de dados COD é uma struct cod que contem um caracter e um array de char com o código respetivo
  - O tipo de dados CODs é um array de 256 (todos os caracteres da tabela ASCII) elementos do tipo COD
*/

#include "modC.h"

void imprimeOutput(int n_blocos,int t_antes[], int t_depois[], clock_t tempoI, char *fichOrigin){
    struct tm *data;
    time_t seg;
    time(&seg);
    data = localtime(&seg);
    float comp,compGlobal=0;
    clock_t tempoF = clock();

    printf("Gonçalo da Cunha Freitas, a93297, ");
    printf("António Ricardo Vieira da Fonseca, a93167, ");
    printf("MIEI/CD, %d-%d-%d ",data->tm_mday,data->tm_mon+1,data->tm_year+1900);
    printf("\nMódulo: c (codificação dum ficheiro de símbolos)");
    printf("\nNúmero de blocos: %d", n_blocos);
    for(int i=0; i<n_blocos; i++){
        comp = 100 - (float)t_depois[i]/t_antes[i] * 100;
        printf("\nTamanho antes/depois & taxa de compressão (bloco %d): %d / %d | %.2f %%",i,t_antes[i],t_depois[i], comp);
        compGlobal+=comp;
    }
    compGlobal/=n_blocos;
    printf("\nTaxa de compressão global: %.2f %%", compGlobal);
    printf("\nTempo de execução do módulo (milissegundos): %f",1000*(tempoF - tempoI) / (double)CLOCKS_PER_SEC);
    printf("\nFicheiro gerado: %s.shaf\n",fichOrigin);
}

int *find_t_antes(int n_blocos, unsigned char *buffer){
    int i=3; int at=0;
    int *t_antes=malloc(n_blocos*sizeof(int));
    while(at<n_blocos){
        for(;buffer[i] != 64;i++); i++; //avança até ao elemento seguinte do proximo "@"

        t_antes[at]=strtol(buffer+i,NULL,10);  // guarda o tamanho do bloco

        for(;buffer[i] != 64;i++); i++; // avança a parte que diz o tamanho do bloco até ao elemento seguinte do proximo "@"
        at++;
    }

   return t_antes;
}

unsigned char *getbufferC(FILE *fp){
    int size;
    fseek(fp,0,SEEK_END);
    size=ftell(fp);
    unsigned char *bufferF = malloc(size);
    fseek(fp, 0, SEEK_SET);
    fread(bufferF,size,1,fp);
    return bufferF;
}

char *getfichSHAF(char *nome){
    char *fichSHAF = malloc(strlen(nome)+6);
    strcpy(fichSHAF,nome);
    strcat(fichSHAF,".shaf");
    return fichSHAF;
}

char *getfichCOD(char *nome){
    char *fichCOD=malloc(strlen(nome)+5);
    strcpy(fichCOD,nome);
    strcat(fichCOD,".cod");

    return fichCOD;
}

unsigned char *getbufferO(FILE *fp, int tam_bloco){
    int size;
    unsigned char *buffer = malloc(tam_bloco);
    fread(buffer,tam_bloco,1,fp);
    return buffer;
}

CODs *getCod(unsigned char *buffer,int n_blocos, int *max_size){
    CODs *cod = malloc(sizeof(CODs)*n_blocos);
    char temp[30];
    int at=0,idx=0,i=0,idxC=0;
    int length;
    while(at<4) {
        if(buffer[idx] == (int)'@') at++;
        idx++;
    }

    for(int j=0;j<n_blocos;j++){
        idxC=0;

        while(at%2!=0){
            if(buffer[idx+i] == (int)'@') at++;
            idx++;
        }

        while(buffer[idx+i] != (int)'@'){
            if(buffer[idx+i] != (int)';'){
                int indice=0;
                cod[j][idxC].c=i;           // i significa o número ascii do caracter referente ao código que está a ser lido
                while(buffer[idx+i] != (int)';' && buffer[idx+i] != (int)'@'){
                 temp[indice]=buffer[idx+i];
                    indice++; idx++;
                }
             temp[indice]='\0';
                cod[j][idxC].codigo = malloc(indice);
                strcpy(cod[j][idxC].codigo, temp);

                idxC++;
                if(indice > *max_size) *max_size = indice;
            }
            if(buffer[idx+i] == (int)';')i++;
        }
        at++;
        idx=idx+i+1;
        i=0;
    }
    return cod;
}

void pre_binaryBuffer(CODs cod, char* buffer,int max_size, int t_antes, int *len, unsigned char * pre_BIN){
    (*len)=0;
    for(int i=0; i < t_antes; i++){
        int j=0;
        for(;cod[j].c != *(buffer+i); j++);
        for(int n=0; n<strlen(cod[j].codigo);n++){
            pre_BIN[(*len)+n] = cod[j].codigo[n];
        }
        (*len)+=strlen(cod[j].codigo);
    }
    pre_BIN[++(*len)] = '\0';
}

unsigned char byteTobit(unsigned char *pre_BIN){
    unsigned char ok = strtol(pre_BIN,NULL,2);
    return ok;
}

void initFout(FILE *fout, int n_blocos){
    fseek(fout,0,SEEK_SET);
    fprintf(fout,"@%d",n_blocos);
}

int Print_binaryBuffer(FILE *fout, unsigned char *pre_BIN, int t_antes, int len){
    unsigned char *BIN=malloc(t_antes*2);    // assumindo que o tamanho do bloco codificado será menor do que o dobro do tamanho do bloco original
    unsigned char byte[9];
    int i = 0,idx=0;
    while(idx<len/8){
        int j;
        for(j=0;j<8;j++,i++){
            byte[j] = pre_BIN[i];
        }
        byte[j]='\0';
        BIN[idx]=byteTobit(byte);
        idx++;
    }
    if(len%8){
        int j;
        unsigned char final_byte[8];
        for(j=0;pre_BIN[i]!='\0';j++,i++){
            final_byte[j] = pre_BIN[i];
        }
        final_byte[j]='\0';
        BIN[idx++]= (byteTobit(final_byte) << (8 - j));
    }

    fprintf(fout,"@%d@",idx);
    for(int n=0; n<idx;n++){
        fputc(BIN[n],fout);
    }
   
    return idx;
}

void cleanFile(char *nome){
    fclose(fopen(nome,"w"));
}

void moduloC(char *fichOrigin){
    clock_t tempo;tempo = clock();
    FILE *fp = fopen(fichOrigin,"rb");

    if (fp == NULL) printf("\nFicheiro original inexistente\n\n"); // verifica se o ficheiro original existe

    else{
        char *fichCOD = getfichCOD(fichOrigin); // descobre o nome do ficheiro cod
        FILE *fpCOD = fopen(fichCOD,"rb");
        if(fpCOD == NULL) printf("\nFicheiro .cod inexistente\n\n");  // verifica se o ficheiro .cod existe

        else{
            unsigned char *bufferC = getbufferC(fpCOD);  // buffer com o ficheiro .cod

            unsigned char tipoFich; // RLE ou NORMAL
            int n_blocos;
            sscanf(bufferC,"@%c@%d@",&tipoFich,&n_blocos);  // guarda o tipo de ficheiro e o número de blocos

            int *t_antes = find_t_antes(n_blocos,bufferC);
            CODs *cod = malloc(sizeof(CODs)*n_blocos);
            int max_size=0;
            cod=getCod(bufferC,n_blocos,&max_size); // inicializa os structs CODs e devolve o maior tamanho dos códigos
            free(bufferC);

            int *t_depois=malloc(n_blocos);
            unsigned char **bufferO=malloc(sizeof(unsigned char*)*n_blocos); // cria um array de buffers
            fseek(fp,0,SEEK_SET);
            for(int i=0;i<n_blocos;i++){   // inicializa o array de buffers com os blocos do ficheiro original
                bufferO[i]= getbufferO(fp,t_antes[i]);
            }
            fclose(fp);
            fclose(fpCOD);
            
            char *fichSHAF = getfichSHAF(fichOrigin);
            cleanFile(fichSHAF);
            FILE *fout = fopen(fichSHAF,"ab");
            unsigned char *pre_BIN=malloc(max_size*t_antes[0]+1);
            initFout(fout, n_blocos);
            int len;
            for(int i=0;i<n_blocos;i++){  // inicializa o array com 0's e 1's e depois "escreve em binário" no ficheiro
                pre_binaryBuffer(cod[i],bufferO[i],max_size, t_antes[i], &len, pre_BIN);
                t_depois[i]=Print_binaryBuffer(fout,pre_BIN,t_antes[i], len);
                strcpy(pre_BIN,"");
            }
            free(cod);

            imprimeOutput(n_blocos, t_antes, t_depois, tempo,fichOrigin);
        }
    }
}
