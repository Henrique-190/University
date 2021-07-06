#include <stdio.h>
#include <string.h>

void strrev (char s[]){
    char c;
    int pos,b,x,length;
    length = strlen(s);
    b = length/2;
    x = 0;
    while (x<b) {
        pos = length-1-x;
        c = s[x];
        s[x] = s[pos];
        s[pos] = c;
        x++;
    }
}
