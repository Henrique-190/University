#include <stdio.h>

int conta(char c,char s[]){
    int n,m; 
    n= m= 0;

    while (s[m]){
        if (s[m]==c)
            n++;
        m++;
    }
    return n;
}


char charMaisfreq (char s[]) {
    if (s == "/0") return '0';
    else {char d;
          int x = 0, y = 0,a;
          while (s[x]) {
            a = conta(s[x],s);
            if (a>y) {y=a;
                d=s[x];
                x++;}
            else {x++;}
        }
        return d;
    }
    
}
