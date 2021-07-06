#include <stdio.h>

typedef struct slist {
int valor;
struct slist *prox;
} *LInt;

typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

/*Pergunta 1*/
int retiraNeg (int v[], int N){
    int i = 0;
    int counter = N;
    while(N){
        if(v[i]<0){
            int counter = N-1;
            int x = i;
            while (counter){
                v[x] = v[x+1];
                counter--;
                x++;
            }
        } else {
            i++;
            N--;
        }
    }
}

/*Pergunta 3*/
int maximo (LInt l){
    int max = 0;
    while(l){
        if (l->valor > max){
            max = l->valor;
        }
        l = l->prox;
    }
    return max;
}


/*Pergunta 4*/
int removeAll (LInt *l, int x){
    int removidos =0 ;
    while(*l){
        if ((*l)->valor==x){
            (*l)=(*l)->prox;
            removidos++;
        }
        else l = &((*l)->prox);
    }
    return removidos;
}

/*Pergunta 5*/
LInt arrayToList (int v[], int N){
    LInt *resultado;
    LInt res = NULL;
    resultado = &res;
    int i = 0;
    while(N){
        (*resultado) = malloc(sizeof(struct slist));
        (*resultado)->valor = v[i];
        resultado = &((*resultado)->prox);
        i++;
        N--;
    }
    return res;
}

/*                          PARTE B                             */

/*Pergunta 1*/
int minheapOK (ABin a){
    if (!a) return 1;
    else if (a->dir && a->esq)
            return (minheapOK(a->dir) && minheapOK(a->esq) && 
            a->valor < a->dir->valor && a->valor < a->esq->valor) ? 1 :0;
         else if (a->dir)
                return (minheapOK(a->dir) && a->valor < a->dir->valor) ? 1 : 0;
             else if (a->esq)
                    return (minheapOK(a->esq) && a->valor < a->esq->valor) ? 1 : 0;
                 else return 1;
}

/*Pergunta 2*/
int maxHeap (ABin a){
    int max = 0;
    if (a->dir && a->esq){
        max = maxHeap(a->dir)>maxHeap(a->esq) ? maxHeap(a->dir) : maxHeap(a->esq);
    }
    else if (a->dir){
        max = maxHeap(a->dir);
    }
    else if (a->esq){
        max = maxHeap(a->esq);
    }
    else return a->valor;
}

/*Pergunta 3*/
void removeMin (ABin *a){
    if ((*a)->dir&& (*a)->esq){
        if ((*a)->dir->valor < (*a)->esq->valor){
            (*a)->valor = (*a)->dir->valor;
            removeMin((*a)->dir);
        } else {
            (*a)->valor = (*a)->esq->valor;
            removeMin((*a)->dir);
        }
    }
    else if ((*a)->dir){
        *a= (*a)->dir;
    }
    else if ((*a)->esq){
        *a= (*a)->esq;
    }
    else *a = NULL;
}