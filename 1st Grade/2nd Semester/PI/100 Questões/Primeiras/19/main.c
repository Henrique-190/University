#include <stdio.h>

int sufPref (char s1[], char s2[]) {
    int i = 0;
    int j = 0;
    int r = 0;

    while (s1[i] != '\0') {
        if (s1[i] == s2[j]) {
            r++;
            i++;
            j++;
        } else {
            r = 0;
            j = 0;
            i++;}
    }
    return r;
}
