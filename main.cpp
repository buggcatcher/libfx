#include <iostream>
#include <unistd.h>
#include "inc/libft.h"

int main() {
    char cwd[1024];
    char input[256];
    int result;
    char *newline;

    if (getcwd(cwd, sizeof(cwd)))
        std::cout << "[C++ program] Eseguito da: " << cwd << "/main.cpp" << std::endl;
    else
        std::cout << "[C++ program] PWD: (errore getcwd)" << std::endl;
    std::cout << "Inserisci una stringa da convertire: ";
    if (!std::cin.getline(input, sizeof(input))) {
        std::cout << "Errore lettura input." << std::endl;
        return 1;
    }
    newline = input;
    while (*newline) {
        if (*newline == '\n') *newline = '\0';
        ++newline;
    }
    result = fx_atoi(input);
    std::cout << "fx_atoi('" << input << "') = " << result << std::endl;
    return 0;
}
