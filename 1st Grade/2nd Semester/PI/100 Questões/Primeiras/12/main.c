#include <stdio.h>

void delete (int i, char s[]) {
    for (i;s[i];i++)
        s[i]=s[i+1];
}

void strnoV (char s[]) {
    int x = 0;
    while(s[x])
        if (s[x]=='A' || s[x]=='E' || s[x]=='I' || s[x]=='O' || s[x]=='U' || s[x]=='a' || s[x]=='e' || s[x]=='i' || s[x]=='o' || s[x]=='u')
            delete(x,s);
        else x++;
}
