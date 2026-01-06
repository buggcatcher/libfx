# libfx (C / ASM core)

Libreria estesa e modulare in Assembly per il riutilizzo diretto in progetti C/C++.


## Target ABI

- x86_64: System V AMD64
- arm64: AAPCS64


## Caratteristiche

- Compatibilità C/C++
- Modularità
- Supporto multi-architettura (x86_64, arm64)
- Facilità di estensione e manutenzione
- API C stabile (extern "C" per C++)
- backend multipli (C / ASM)
- selezione implementazione a compile-time
- struttura compatibile con progetti complessi
- Gestione delle vulnerabilità note della libreria standard
- Non conforme ai requisiti di valutazione della 42


## Uso da C++

```cpp
extern "C" {
#include <libft.h>
}
```


## Funzionamento: launcher.sh, Makefile, main e uso di fx_atoi

- **launcher.sh**: è uno script di utilità che semplifica la compilazione e l'esecuzione della libreria. Può automatizzare la scelta dell'architettura, la pulizia dei file temporanei e il lancio dei comandi del Makefile. Dopo aver reso eseguibile lo script (`chmod +x ./launcher.sh`), puoi avviarlo con `./launcher.sh` per compilare e testare la libreria senza dover ricordare tutti i comandi manualmente.

- **Makefile**: contiene le regole di compilazione per tutti i backend e le architetture supportate. Puoi specificare la variabile `ARCH` (ad esempio `make ARCH=arm64`) per scegliere tra implementazioni C o Assembly e tra diverse architetture. Il Makefile si occupa di:
  - Compilare i sorgenti corretti (C o ASM)
  - Collegare i file oggetto
  - Generare la libreria o l'eseguibile finale

- **main.c / main.cpp**: sono esempi di programmi che utilizzano la libreria. In C++ si include l'header tramite `extern "C"` per garantire la compatibilità. Dal main puoi chiamare qualsiasi funzione dell'API, ad esempio:

```c
#include <libft.h>
int main() {
    int n = fx_atoi("123");
    // ...
}
```

- **Utilizzo di fx_atoi in Assembly (.s)**: se scegli come backend l'implementazione Assembly (ad esempio per ARM64 o x86_64), la funzione `fx_atoi` sarà compilata dal relativo file `.s` (come `src/arm64/fx_atoi.S`). La selezione dell'implementazione Assembly avviene in modo automatico: se l'architettura rilevata è compatibile, il Makefile e lo script di lancio compileranno e collegheranno direttamente la versione `.s` altrimenti defaulta a `.c`.


## Esecuzione dello script di lancio

Per poter eseguire lo script `launcher.sh`, è necessario renderlo eseguibile. Puoi farlo con il comando:

```sh
chmod +x ./launcher.sh
```

Dopo averlo reso eseguibile, puoi avviarlo con:

```sh
./launcher.sh
```

Lo script rileva automaticamente l’architettura (ad esempio x86_64), seleziona il backend corretto (C o Assembly), ti permette di scegliere se eseguire il main in C o C++, compila i sorgenti e avvia il programma. In questo modo puoi testare la libreria senza ricordare tutti i comandi manualmente.


## Documentazione

- [fx_atoi (ARM64/C)](doc/fx_atoi.md)

