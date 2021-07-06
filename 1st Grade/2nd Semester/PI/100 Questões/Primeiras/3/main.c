#include <stdio.h>

void segundo () {
    int a,b,x;
    a=b=0;
    x=1;

    while (x!=0) {
        printf("Escreva um número:");
        scanf("%d",&x);
        if (x>a) {
            b = a;
            a = x;}
        else if (x>b) b=x;
        else {}          
    }
    printf("O segundo maior número é:%d",b);
}

int main() {
    segundo();
    return 0;
}

