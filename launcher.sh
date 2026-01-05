#!/bin/zsh
# launcher.sh - Scegli se compilare/eseguire main_c (C) o main_cpp (C++)

# Colori
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
ORANGE='\033[38;5;208m'
NC='\033[0m'

# Rileva architettura hardware
arch=$(uname -m)
print "${PURPLE}\nLauncher libfx${NC}"
print "${YELLOW}Architettura rilevata: $arch${NC}"
if [[ "$arch" == "x86_64" ]]; then
    print "${ORANGE}Userai backend assembly: src/x86_64/fx_atoi.S${NC}"
    export ARCH=x86_64
elif [[ "$arch" == "aarch64" ]]; then
    print "${ORANGE}Userai backend assembly: src/arm64/fx_atoi.S${NC}"
    export ARCH=arm64
else
    print "${ORANGE}Backend assembly non specificato per questa architettura. Verrà usato il backend C.${NC}"
    export ARCH=c
fi
print "${PURPLE}1) C (main_c)${NC}"
print "${PURPLE}2) C++ (main_cpp)${NC}"
print "${PURPLE}q) Esci${NC}"
print -n "\nSeleziona: ${NC}"
read scelta

if [[ "$scelta" == "1" ]]; then
    print "\n${ORANGE}Compilo ed eseguo main_c...${NC}"
    if make c; then
        ./main_c
    else
        print "${YELLOW}Errore nella compilazione C.${NC}"
    fi
elif [[ "$scelta" == "2" ]]; then
    print "\n${ORANGE}Compilo ed eseguo main_cpp...${NC}"
    if make cpp; then
        ./main_cpp
    else
        print "${YELLOW}Errore nella compilazione C++.${NC}"
    fi
elif [[ "$scelta" == "q" ]]; then
    print "${PURPLE}Uscita.${NC}"
else
    print "${YELLOW}Scelta non valida.${NC}"
fi
