#include <stdio.h>
#include <string.h>

char *mystrstr (char s1[], char s2[]){
int i = 0;
int j = 0;
while (s1[i] && j!=strlen(s2)){
if (s1[i] == s2[j]){
i++;
j++;} else i++;
}


if (j==strlen(s2)) {
    i = i-j;
    return (s1+i);
    
}
else return (NULL);}
