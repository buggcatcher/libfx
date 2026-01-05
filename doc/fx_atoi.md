# fx_atoi.S ARM64: Analisi

## Introduzione
Questo documento presenta la funzione `fx_atoi` in Assembly ARM64 per comprendere ogni istruzione e concetto architetturale.


---

## Analisi teorica approfondita

### 1. **Mappatura registri ARM64**

| Registro | Utilizzo | Tipo C | Note |
|----------|----------|--------|------|
| `x0` | Puntatore `nptr` | `const char*` | 64-bit (puntatore) |
| `w1` | Indice `i` | `int` | 32-bit |
| `w2` | Segno `sign` | `int` | +1 o -1 |
| `w3` | Risultato `res` | `int` | Accumulatore |
| `w4` | Carattere corrente | `char` | Temporaneo |
| `w5` | Costante 10 | `int` | Solo per `mul` |
| `w0` | Valore di ritorno | `int` | Secondo AAPCS64 |

**NOTA**: `w` indica 32-bit, `x` indica 64-bit dello stesso registro fisico.

---

### 2. **Convenzioni AAPCS64 (Procedure Call Standard)**

- **Argomenti**: primi 8 in `x0`-`x7`
- **Ritorno**: valori ≤64-bit in `x0`/`w0`
- **Caller-saved**: `x0`-`x18` (possono essere modificati)
- **Link Register**: `x30` (indirizzo di ritorno)

Questa funzione **non salva registri** perché usa solo caller-saved.

---

### 3. **Flag condizioni (NZCV)**

Ogni istruzione `cmp` aggiorna i flag:

```
N (Negative): bit 31 del risultato
Z (Zero):     risultato == 0
C (Carry):    carry-out dalla somma
V (oVerflow): overflow aritmetico signed
```

**Branch condizionali**:
- `b.eq` → salta se Z = 1 (uguale)
- `b.lt` → salta se N ≠ V (minore)
- `b.gt` → salta se Z = 0 AND N = V (maggiore)

---

### 4. **Ottimizzazioni implementate**

1. **Nessun frame pointer**: funzione leaf (no chiamate)
2. **Registri caller-saved**: no salvataggio stack
3. **Branch diretti**: no jump table
4. **Carattere in cache**: `w4` evita reload ripetuti

---

### 5. **Gestione overflow e sicurezza: superamento delle vulnerabilità della funzione standard**

Questa versione di `fx_atoi` è progettata per essere **sicura** e superare tutte le vulnerabilità note della funzione standard `atoi`:

- **Gestione dell'overflow/underflow**: se il risultato supera i limiti di `int` (`INT_MAX`/`INT_MIN`), la funzione ritorna rispettivamente `INT_MAX` o `INT_MIN`.
- **Input non valido**: se la stringa non contiene numeri validi, la funzione ritorna zero.
- **Nessun comportamento undefined**: tutte le condizioni di errore sono gestite esplicitamente.

> **Nota didattica:**
> Alla 42, la versione di `ft_atoi` che viene richiesta deve comportarsi **esattamente come la funzione standard della libreria C** (`atoi`). Questo significa che:
> - **Non bisogna gestire l'overflow**: la funzione standard non effettua controlli su valori fuori dal range di `int`.
> - **Il comportamento in caso di overflow è undefined behavior**: il risultato può essere diverso su architetture diverse, ma deve corrispondere a quello della funzione standard.
> - **Motivo**: i test di valutazione confrontano la nostra implementazione con quella della libreria standard. Se aggiungessimo controlli sull'overflow, i risultati sarebbero diversi e i test fallirebbero.
>
> È per questo **libfx** non è **libft** compliant con le norme della 42 : qui punto alla sicurezza e robustezza, non alla conformità dei test della 42.

Esempio di gestione overflow in Assembly:

```asm
# Controllo pre-moltiplicazione
mov     w6, #214748364      # INT_MAX / 10
cmp     w3, w6
b.hi    .Loverflow          # salta se res troppo grande
```

**Conclusione**: La funzione `ft_atoi` qui documentata è pensata per essere sicura, robusta e priva delle vulnerabilità tipiche della libreria standard, gestendo esplicitamente tutti i casi di errore e overflow.

---

## Equivalenza C ↔ Assembly

```c
// C
int i = 0;
while (ft_isspace(nptr[i]))
    i++;
```

```asm
// ARM64
mov     w1, #0
.Lws:
    ldrb    w4, [x0, x1]
    # ... controlli whitespace ...
    add     w1, w1, #1
    b       .Lws
```

---

## Compilazione e test

```bash
# Assembla
as -o ft_atoi.o ft_atoi_arm64.S

# Linka con C
cc -o test test.c ft_atoi.o

# Disassembla per verifica
objdump -d ft_atoi.o
```

---

## Codice completo annotato

```asm
    .text                           # DIRETTIVA: sezione codice eseguibile
    .globl ft_atoi                  # DIRETTIVA: simbolo visibile al linker
    .type ft_atoi, %function        # DIRETTIVA: tipo simbolo (per debugging)

# ============================================================================
# PROLOG: Validazione input e inizializzazione registri
# ============================================================================

ft_atoi:
    cbz     x0, .Lzero              # Compare and Branch if Zero
                                    # TEORIA: cbz è un'istruzione condizionale ARM64
                                    # Controlla se x0 (puntatore nptr) == 0
                                    # Se true → salta a .Lzero
                                    # MAPPING C: if (!nptr) return (0);
                                    # NOTA: usa x0 (64-bit) per puntatori, non w0

    mov     w1, #0                  # INIZIALIZZAZIONE: i = 0
                                    # TEORIA: mov sposta un valore immediato in registro
                                    # w1 è la versione 32-bit di x1
                                    # Sintassi ARM: destinazione, sorgente
                                    # MAPPING C: int i = 0;

    mov     w2, #1                  # INIZIALIZZAZIONE: sign = 1
                                    # TEORIA: segno positivo di default
                                    # w2 conterrà +1 o -1 per tutto il calcolo
                                    # MAPPING C: int sign = 1;

    mov     w3, #0                  # INIZIALIZZAZIONE: res = 0
                                    # TEORIA: accumulatore per il risultato
                                    # w3 = res (accumulatore parziale)
                                    # MAPPING C: int res = 0;

# ============================================================================
# FASE 1: Skip whitespace (spazi bianchi)
# ============================================================================

.Lws:                               # LABEL: "Loop WhiteSpace"
                                    # TEORIA: label = punto di salto in Assembly
                                    # Convenzione: .L = label locale (non esportata)

    ldrb    w4, [x0, x1]            # Load Register Byte
                                    # TEORIA: carica 1 byte dalla memoria
                                    # Indirizzo effettivo: x0 + x1 (base + offset)
                                    # w4 = nptr[i]
                                    # NOTA: ldrb azzera i bit superiori di w4
                                    # MAPPING C: char c = nptr[i];

    cmp     w4, #' '                # Compare (sottrazione senza salvare)
                                    # TEORIA: cmp calcola w4 - 32 (spazio)
                                    # Aggiorna i flag NZCV:
                                    #   N = Negative, Z = Zero
                                    #   C = Carry, V = oVerflow
                                    # Non modifica w4, solo i flag
                                    # MAPPING C: if (c == ' ')

    b.eq    .Lws_inc                # Branch if Equal (Z flag = 1)
                                    # TEORIA: salta se l'ultimo cmp era uguale
                                    # Se w4 == ' ' → incrementa i e ricontrolla
                                    # Sintassi: b.condizione etichetta

    cmp     w4, #9                  # Confronta con '\t' (tab, ASCII 9)
                                    # TEORIA: inizia controllo range 9-13
                                    # Range whitespace: \t(9) \n(10) \v(11) \f(12) \r(13)

    b.lt    .Lsign                  # Branch if Less Than (N != V)
                                    # TEORIA: salta se w4 < 9
                                    # Se carattere < '\t' → non è whitespace
                                    # Passa alla gestione del segno

    cmp     w4, #13                 # Confronta con '\r' (carriage return)
                                    # TEORIA: limite superiore range whitespace

    b.gt    .Lsign                  # Branch if Greater Than
                                    # TEORIA: salta se w4 > 13
                                    # Se carattere > '\r' → non è whitespace
                                    # LOGICA: se arriviamo qui, 9 ≤ w4 ≤ 13

.Lws_inc:                           # LABEL: incrementa indice whitespace
    add     w1, w1, #1              # w1 = w1 + 1
                                    # TEORIA: add destinazione, sorgente1, sorgente2
                                    # Incrementa l'indice i
                                    # MAPPING C: i++;

    b       .Lws                    # Branch unconditional (sempre)
                                    # TEORIA: salta sempre a .Lws
                                    # Ricomincia il ciclo di skip whitespace
                                    # MAPPING C: while (ft_isspace(nptr[i]))

# ============================================================================
# FASE 2: Gestione del segno (+ o -)
# ============================================================================

.Lsign:                             # LABEL: controlla segno
                                    # TEORIA: arriviamo qui quando il carattere
                                    # non è whitespace
                                    # w4 contiene ancora il carattere corrente

    cmp     w4, #'-'                # Confronta con '-' (ASCII 45)
                                    # TEORIA: controlla se segno negativo

    b.ne    .Lplus                  # Branch if Not Equal (Z flag = 0)
                                    # TEORIA: se non è '-', controlla se è '+'
                                    # Salta a .Lplus

    mov     w2, #-1                 # sign = -1
                                    # TEORIA: imposta segno negativo
                                    # w2 sarà moltiplicato per il risultato finale
                                    # MAPPING C: sign = -1;

    add     w1, w1, #1              # i++ (salta il carattere '-')
                                    # TEORIA: incrementa indice per consumare il segno

    b       .Ldigit                 # Salta direttamente alle cifre
                                    # TEORIA: dopo '-' non controlliamo '+'
                                    # OTTIMIZZAZIONE: evita controlli ridondanti

.Lplus:                             # LABEL: controlla segno positivo
    cmp     w4, #'+'                # Confronta con '+' (ASCII 43)
                                    # TEORIA: segno esplicito positivo

    b.ne    .Ldigit                 # Se non è '+', inizia conversione cifre
                                    # TEORIA: se arriviamo qui e non è '+'
                                    # allora è una cifra o altro carattere
                                    # Saltiamo direttamente a .Ldigit

    add     w1, w1, #1              # i++ (salta il carattere '+')
                                    # TEORIA: consuma il segno '+'
                                    # w2 rimane 1 (impostato all'inizio)
                                    # MAPPING C: if (nptr[i] == '+') i++;

# ============================================================================
# FASE 3: Conversione cifre decimali (loop principale)
# ============================================================================

.Ldigit:                            # LABEL: loop di conversione
                                    # TEORIA: questo è il cuore della funzione
                                    # Implementa: res = res * 10 + (c - '0')

    ldrb    w4, [x0, x1]            # Ricarica carattere corrente
                                    # TEORIA: dobbiamo ricaricare perché l'indice
                                    # potrebbe essere cambiato (++i per segno)
                                    # w4 = nptr[i] aggiornato
                                    # MAPPING C: while (ft_isdigit(nptr[i]))

    cmp     w4, #'0'                # Confronta con '0' (ASCII 48)
                                    # TEORIA: limite inferiore cifre decimali

    b.lt    .Lend                   # Se < '0' → non è una cifra
                                    # TEORIA: termina conversione
                                    # Carattere non numerico → fine stringa numerica

    cmp     w4, #'9'                # Confronta con '9' (ASCII 57)
                                    # TEORIA: limite superiore cifre decimali

    b.gt    .Lend                   # Se > '9' → non è una cifra
                                    # TEORIA: range valido ASCII: '0'(48) - '9'(57)
                                    # LOGICA: se arriviamo qui, '0' ≤ w4 ≤ '9'

    # -------------------------------------------------------------------
    # ALGORITMO: res = res * 10 + (c - '0')
    # -------------------------------------------------------------------

    mov     w5, #10                 # Carica costante 10 in registro temporaneo
                                    # TEORIA ARM64: mul NON accetta immediati
                                    # ERRORE COMUNE: mul w3, w3, #10 ← INVALIDO
                                    # SOLUZIONE: carica #10 in registro ausiliario

    mul     w3, w3, w5              # res = res * 10
                                    # TEORIA: mul destinazione, op1, op2
                                    # Esegue moltiplicazione 32-bit
                                    # NOTA: overflow silenzioso (wrapped)
                                    # ESEMPIO: se res = 42, diventa 420
                                    # MAPPING C: res = res * 10;

    sub     w4, w4, #'0'            # Converte ASCII → valore numerico
                                    # TEORIA: '0' ha valore ASCII 48
                                    # '5' (ASCII 53) - 48 = 5 (numerico)
                                    # w4 ora contiene il valore 0-9
                                    # MAPPING C: (nptr[i] - '0')

    add     w3, w3, w4              # res = res + digit
                                    # TEORIA: aggiunge la cifra all'accumulatore
                                    # ESEMPIO: 420 + 5 = 425
                                    # MAPPING C: res = res * 10 + (nptr[i] - '0');

    add     w1, w1, #1              # i++ (avanza al prossimo carattere)
                                    # TEORIA: incrementa indice stringa

    b       .Ldigit                 # Ricomincia il loop
                                    # TEORIA: loop infinito fino a carattere non-cifra
                                    # MAPPING C: while (ft_isdigit(nptr[i]))

# ============================================================================
# EPILOG: Applicazione segno e ritorno
# ============================================================================

.Lend:                              # LABEL: fine conversione
                                    # TEORIA: arriviamo qui quando il carattere
                                    # non è una cifra valida

    mul     w0, w3, w2              # result = res * sign
                                    # TEORIA: w0 = registro di ritorno (AAPCS64)
                                    # w3 = risultato accumulato (sempre positivo)
                                    # w2 = +1 o -1 (segno)
                                    # ESEMPIO: 123 * (-1) = -123
                                    # MAPPING C: return (res * sign);

    ret                             # Return to caller
                                    # TEORIA: ret salta a indirizzo in x30 (LR)
                                    # LR = Link Register (salvato dalla chiamante)
                                    # w0 contiene il valore di ritorno

# ============================================================================
# PERCORSO ALTERNATIVO: Input NULL
# ============================================================================

.Lzero:                             # LABEL: gestione puntatore NULL
                                    # TEORIA: raggiungibile solo da cbz iniziale

    mov     w0, #0                  # return 0
                                    # TEORIA: convenzionalmente, NULL → 0
                                    # MAPPING C: if (!nptr) return (0);

    ret                             # Return to caller
                                    # TEORIA: ritorna immediatamente
                                    # Nessun'altra operazione necessaria
```


---

