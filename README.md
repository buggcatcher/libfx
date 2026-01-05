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

## Documentazione

- [ft_atoi (ARM64/C)](doc/ft_atoi.md)
