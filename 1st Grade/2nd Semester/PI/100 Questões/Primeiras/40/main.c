#include <stdio.h>

void transposta (int N, float m [N][N]) {
    float arr [N][N];
    int i = 0, p = 0;

    while (p<N){
        int i = 0;
        while (i<N){
            arr [p][i]= m [i][p];
            i++;
        }
        p++;
    }

    i=0;
    while (i<N){
        int c = 0;
        while(c<N){
            m [i][c]=arr [i][c];
            c++;
        }
        i++;
    }
}