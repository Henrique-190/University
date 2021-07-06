#include <stdio.h>

char *mystrcpy(char s1[], const char s2[]) {
    int i;

    for(i=0;s2[i]!='\0';i++){
        s1[i] = s2[i];}

    s1[i++] = '\0';


    return s1;
}