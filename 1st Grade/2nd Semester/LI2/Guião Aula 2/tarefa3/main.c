#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Dificuldades a nível da multiplicação;
void multum () {
    int x, y, r;
    x = rand() % 10;
    y = rand() % 10;
    printf("Quanto é %d vezes %d?\n", x, y);
    scanf("%d", &r);

    while ((x * y) != r) {
        int b;
        b = (rand() % 3);
        opcaoErrada(b);
        printf("Quanto é %d vezes %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x * y) == r) {
        int a = (rand() % 3);
        opcaoCorreta(a);
        multum();
    }
}

void multdois () {
        int x,y,r;
        x = rand() % 100;
        y = rand() % 100;
        printf("Quanto é %d vezes %d?\n", x, y);
        scanf("%d", &r);

        while ((x * y) != r) {
            int b = (rand() % 3);
            opcaoErrada(b);
            printf("Quanto é %d vezes %d?\n", x, y);
            scanf("%d", &r);
        }

        while ((x * y) == r) {
            int a = (rand() % 3);
            opcaoCorreta(a);
            multdois();
        }
}

void multtres () {
        int x,y,r;
        x = rand() % 1000;
        y = rand() % 1000;
        printf("Quanto é %d vezes %d?\n", x, y);
        scanf("%d", &r);

        while ((x * y) != r) {
            int b = (rand() % 3);
            opcaoErrada(b);
            printf("Quanto é %d vezes %d?\n", x, y);
            scanf("%d", &r);
        }

        while ((x * y) == r) {
            int a = (rand() % 3);
            opcaoCorreta(a);
            multtres();
        }
}


// Dificuldades a nível da soma
void somaum () {
    int x,y,r;
    x = rand() % 10;
    y = rand() % 10;
    printf("Quanto é %d mais %d?\n", x, y);
    scanf("%d", &r);

    while ((x + y) != r) {
        int b = (rand() % 3);
        opcaoErrada(b);
        printf("Quanto é %d mais %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x + y) == r) {
        int a = (rand() % 3);
        opcaoCorreta(a);
        somaum();
    }
}

void somadois () {
    int x,y,r;
    x = rand() % 100;
    y = rand() % 100;
    printf("Quanto é %d mais %d?\n", x, y);
    scanf("%d", &r);

    while ((x + y) != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d mais %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x + y) == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        somadois();
    }
}

void somatres () {
    int x,y,r;
    x = rand() % 1000;
    y = rand() % 1000;
    printf("Quanto é %d mais %d?\n", x, y);
    scanf("%d", &r);

    while ((x + y) != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d mais %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x + y) == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        somatres();
    }
}


// Dificuldades a nível da subtração.
void subtum () {
    int x,y,r;
    x = rand() % 10;
    y = rand() % 10;
    printf("Quanto é %d menos %d?\n", x, y);
    scanf("%d", &r);

    while ((x - y) != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d menos %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x - y) == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        subtum();
    }
}

void subtdois () {
    int x,y,r;
    x = rand() % 100;
    y = rand() % 100;
    printf("Quanto é %d menos %d?\n", x, y);
    scanf("%d", &r);

    while ((x - y) != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d menos %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x - y) == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        subtdois();
    }
}

void subttres () {
    int x,y,r;
    x = rand() % 1000;
    y = rand() % 1000;
    printf("Quanto é %d menos %d?\n", x, y);
    scanf("%d", &r);

    while ((x - y) != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d menos %d?\n", x, y);
        scanf("%d", &r);
    }

    while ((x - y) == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        subttres();
    }
}


// Dificuldades a nível da divisão.
void divum () {
    int x,y,c,r;
    x = rand() % 10;
    y = rand() % 9;
    y = y+1;
    printf("Coloque apenas a parte inteira. ");
    printf("Quanto é %d sobre %d?\n", x, y);
    scanf("%d", &r);
    c = x/y;

    while (c != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d sobre %d?\n", x, y);
        scanf("%d", &r);
    }

    while (c == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        divum();
    }
}

void divdois () {
    int x,y,c,r;
    x = rand() % 100;
    y = rand() % 99;
    y = y+1;
    printf("Coloque apenas a parte inteira. ");
    printf("Quanto é %d sobre %d?\n", x, y);
    scanf("%d", &r);
    c = x/y;

    while (c != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d sobre %d?\n", x, y);
        scanf("%d", &r);
    }

    while (c == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        divdois();
    }
}

void divtres () {
    int x,y,c,r;
    x = rand() % 1000;
    y = rand() % 9999;
    y = y+1;
    printf("Coloque apenas a parte inteira. ");
    printf("Quanto é %d sobre %d?\n", x, y);
    scanf("%d", &r);
    c = x/y;

    while (c != r) {
        int b = (rand() % (0 - 3));
        opcaoErrada(b);
        printf("Quanto é %d sobre %d?\n", x, y);
        scanf("%d", &r);
    }

    while (c == r) {
        int a = (rand() % (0 - 3));
        opcaoCorreta(a);
        divtres();
    }
}


// Frases de incentivo.
void opcaoErrada (int b) {
 if (b == 0) {
   printf("Vá lá. Não desistas. Tenta outra vez.\n");}
 else if (b == 1) {
              printf("Então? O que se passa? Mantém a calma e pensa corretamente\n");}
      else printf("Errado, tenta novamente\n");
}


// Frases de apoio.
void opcaoCorreta(int a) {
if (a == 0) {
    printf("Parabéns! Acertaste!\n");}
else if (a == 1) {
         printf("És um ás na matemática!\n");}
     else printf("Belo trabalho!\n");
}



int main() {
    srand(time(NULL));
    printf("Escolha o nível de dificuldade (1 a 3):");
    int d;
    scanf("%d", &d);
    int o;

    if (d == 1) {
        printf("Escolha qual a opção artimética:\n 1 - Soma;\n 2 - Multiplicação;\n 3 - Subtração;\n 4 - Divisão\n");
        scanf("%d", &o);
        if (o == 1) { somaum(); }
        else if (o == 2) { multum(); }
        else if (o == 3) { subtum(); }
        else { divum(); }
    } else if (d == 2) {
              printf("Escolha qual a opção artimética:\n 1 - Soma;\n 2 - Multiplicação;\n 3 - Subtração;\n 4 - Divisão\n");
              scanf("%d", &o);
              if (o == 1) { somadois(); }
              else if (o == 2) { multdois(); }
                   else if (o == 3) { subtdois(); }
                        else { divdois(); }
    }
        else { printf("Escolha qual a opção artimética:\n 1 - Soma;\n 2 - Multiplicação;\n 3 - Subtração;\n 4 - Divisão\n");
               scanf("%d", &o);
               if (o == 1) { somatres(); }
               else if (o == 2) { multtres(); }
                    else if (o == 3) { subttres(); }
                         else { divtres(); }

        }
return 0;
}