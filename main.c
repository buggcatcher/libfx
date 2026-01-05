#include <stdio.h> // printf, fgets
#include <unistd.h> // getcwd
#include <stdlib.h> // free
#include "inc/libfx.h"

char plus1(unsigned int i, char c) {
    (void)i;
    return c + 1;
}

int main(void) {
    char cwd[1024];
    char *newline;
    char input[256];
    int  result;

    if (getcwd(cwd, sizeof(cwd)))
        printf("\033[0;32m[C program] Eseguito da: %s/main.c\033[0m\n", cwd);
    else
        printf("[C program] PWD: (errore getcwd)\n");
    printf("Inserisci una stringa da convertire: ");
    if (!fgets(input, sizeof(input), stdin)) { // very unsafe, for demo only
        printf("Errore lettura input.\n");
        return 1;
    }
    newline = input;
    while (*newline) {
        if (*newline == '\n') *newline = '\0';
        ++newline;
    }

    char *mod_input = fx_strmapi(input, plus1);
    
    result = fx_atoi(mod_input);
    printf("fx_atoi('%s') = %d\n", mod_input, result);
    if (mod_input)
        free(mod_input);
    return 0;
}
