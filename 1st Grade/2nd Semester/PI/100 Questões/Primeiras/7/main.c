#include <stdio.h>
#include <string.h>

char *mystrcat(char s1[], char s2[]) {
    int i = strlen(s1);
    int j = 0;

    while (s2[j] != '\0') {
        s1[i] = s2[j];
        i++;
        j++;
    }
    s1[i++] = '\0';

    return s1;
}
