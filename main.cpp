#include <iostream>
#include "inc/libft.h"

int main(int argc, char **argv) {
    if (argc < 2) {
        std::cout << "Usage: " << argv[0] << " <string>" << std::endl;
        return 1;
    }
    int result = ft_atoi(argv[1]);
    std::cout << "ft_atoi('" << argv[1] << "') = " << result << std::endl;
    return 0;
}
