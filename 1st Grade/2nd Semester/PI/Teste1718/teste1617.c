typedef struct slist {
int valor;
struct slist *prox;
} *LInt;

typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

/*Pergunta 1*/
int limpaEspacos (char t[]){
    int x = 1;
    while(t[x]){
        if (t[x]==t[x-1] && t[x]==' '){
            int xx = x;
            while (t[xx]){
                t[xx]=t[xx+1];
                xx++;
            }
            t[xx-1]='\0';           
            }
        x++;
    }
    return x;
}

/*Pergunta 2*/
void transposta (int N, float m [N][N]){
    int i = 0;
    int j = 0;
    float arr[N][N];

    while (i<N){
        j= 0;
        while (j<N){
            arr[i][j] = m[j][i];
            j++;
        }
        i++;
    }

    i = 0;
    j = i;

    while (i<N){
        j=0;
        while (j<N){
            m[i][j] = arr[i][j];
            j++;
        }
        i++;
    }
}


/*Pergunta 3*/
LInt cloneL (LInt *l){
    LInt clone;
    LInt *inicio;
    inicio = &clone;

    while (*l){
        clone = malloc(sizeof(struct lligada));
        clone->valor = (*l)->valor;
        clone = clone->prox;
    }
    return *inicio;
}

/*Pergunta 4*/
int nivelV (ABin a, int n, int v[]){
    while (a){
        
    }
}


/*                      PARTE B                     */

typedef struct chunk {
int vs [MAXc];
struct chunk *prox;
} *CList;
typedef struct stackC {
CList valores;
int sp;
} StackC;

/*Pergunta 1*/
int push (StackC *s, int x) {
    if (*s){
        if((*s).sp==MAXc){
            
            CList

            (*s).sp = 1;
        }
    }
}