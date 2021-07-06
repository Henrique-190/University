#include <stdio.h>

void fazMedia (int a) {
    float x=0.0;
    float b=0.0;
    while (x!=0 || a==0) {
        scanf("%f",&x);  
        a += x;
        b++;
    }
    b--;
    float media = a/b;
    printf("A média é: %f\n",media);
}

int main() {
    fazMedia(0);
    return 0;
}
