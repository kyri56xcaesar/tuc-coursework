#include <stdio.h>
/* Faithful reproduction of the removed libc gets(): unbounded, no length check. */
char *gets(char *s) {
    char *p = s;
    int c;
    while ((c = getchar()) != EOF && c != '\n')
        *p++ = (char)c;
    *p = '\0';
    return s;
}
