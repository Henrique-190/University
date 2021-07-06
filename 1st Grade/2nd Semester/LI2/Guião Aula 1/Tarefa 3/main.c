#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main() {
    int a,b,c;
    float fa,fb,fc,area,condition1, condition2, condition3;
    printf ("Coloque aqui os três comprimentos do triângulo:\n");
    scanf ("%d", &a);
    scanf ("%d", &b);
    scanf ("%d", &c);
    condition1 = (((abs (b-c))<a) && (a<(b + c)));
    condition2 = (((abs (a-c))<b) && (b<(a + c)));
    condition3 = (((abs (b-a))<c) && (c<(b + a)));
    fa = (float)a;
    fb = (float)b;
    fc = (float)c;
    area = sqrt (((fa+fb+fc)/2)*(((fa+fb+fc)/2)-fa)*(((fa+fb+fc)/2)-fb)*(((fa+fb+fc)/2)-fc));
    if (condition1 && condition2 && condition3) {
        if ((a == b) && (b == c)) {
            printf("O triângulo é equilátero e possui uma área de %f unidades", area);
        }
        else if ((a == b) || (b == c) || (a == c)) {
            printf("O triângulo é isóseles e possui uma área de %f unidades", area);
        }
        else printf("O triângulo é escaleno e possui uma área de %f unidades", area);
    }
    else printf("Os valores são inválidos");
    return 0;
}
