#include <stdio.h>
#include <string.h>

int contaPal (char s[]){
    int i = 0, x = 0, a = strlen(s)-1;
    while(s[x]){
        if (x==a){
            if ((s[x] == ' ' || s[x] == '\n') && (s[x-1] == ' ' || s[x-1] == '\n')) x++;
            else {x++;
                  i++;}
        } else if (x==0) x++; 
               else if ((s[x] == ' ' || s[x] == '\n') && (s[x-1] != ' ' && s[x-1] != '\n')) {
                    x++;
                    i++;
                } else x++;
    }
    return i;
}
