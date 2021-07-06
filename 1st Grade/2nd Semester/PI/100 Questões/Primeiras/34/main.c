#include <stdio.h>
void delete (int i, int s[],int n) {
    int a = i;
    while (a<n) {
        s[a]=s[a+1];
        a++;
    }
}

int elimRepOrd (int v[], int N) {

    int i = 0;
    int j = 0;
    int pivo;
    pivo = v[i];
    i++;

    while (i < N) {

        if (v[i] == pivo) {
            delete(i, v, N);
            N--;
        } else {
            pivo = v[i];
            i++;
        }
    }
    return N;
}