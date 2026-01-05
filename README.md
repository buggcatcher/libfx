# libft (C / ASM core)

Libreria estesa e modulare, predisposta per riscrittura progressiva in Assembly e riutilizzo diretto in progetti C/C++.
- uso in progetti C e C++
- stabilità ABI
- sostituzione incrementale C → Assembly
- supporto x86_64 e arm64


## Struttura
- `includes/` — Header files
- `c/` — Implementazioni in C
- `asm/x86_64/` — Implementazioni Assembly x86_64
- `asm/arm64/` — Implementazioni Assembly arm64

## Obiettivi
- Modularità
- Supporto multi-architettura (x86_64, arm64)
- Facilità di estensione e manutenzione
- Compatibilità C/C++


## Caratteristiche

- no compliant 42
- API C stabile (extern "C" per C++)
- backend multipli (C / ASM)
- selezione implementazione a compile-time
- struttura compatibile con progetti complessi
- Gestione delle vulnerabilità note della libreria standard

## Target ABI

- x86_64: System V AMD64
- arm64: AAPCS64

## Uso da C++

```cpp
extern "C" {
#include <libft.h>
}
```

## Documentazione

- [ft_atoi (ARM64/C)](doc/ft_atoi.md)
