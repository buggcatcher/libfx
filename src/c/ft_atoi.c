#include "inc/libft.h"

// Corrisponde al ciclo .Lws in Assembly che salta gli spazi bianchi
static int	ft_isspace(int c)
{
	return (c == ' ' || (c >= 9 && c <= 13));
}

// Corrisponde al controllo .Ldigit in Assembly
static int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}

// Conversione stringa in intero (simile a atoi standard)
// Versione C didattica con commenti paralleli all'implementazione Assembly ARM64
int	ft_atoi(const char *nptr)
{
	int i;      // indice per scorrere la stringa (w1 in ASM)
	int sign;   // segno del risultato (w2 in ASM)
	int res;    // risultato accumulato (w3 in ASM)

	// Controllo puntatore nullo (cbz x0, .Lzero in ASM)
	if (!nptr)
		return (0);

	i = 0;
	// Salta tutti i caratteri di spazio bianco (ciclo .Lws in ASM)
	while (ft_isspace(nptr[i]))
		i++;

	// Gestione del segno (blocchi .Lsign e .Lplus in ASM)
	sign = 1;
	if (nptr[i] == '+' || nptr[i] == '-')
		if (nptr[i++] == '-')
			sign = -1;
	// In ASM, il segno viene gestito con cmp e mov, qui con un if annidato

	// Conversione delle cifre (ciclo .Ldigit in ASM)
	res = 0;
	while (ft_isdigit(nptr[i]))
	{
		// res = res * 10 + (nptr[i] - '0');
		// In ASM: mul w3, w3, #10; sub w4, w4, #'0'; add w3, w3, w4
		res = res * 10 + (nptr[i] - '0');
		i++;
	}
	// In ASM, il ciclo termina su carattere non cifra (b.lt/b.gt .Lend)

	// Ritorna il risultato con il segno (mul w0, w3, w2 in ASM)
	return (res * sign);
	// In ASM, il valore viene messo in w0 e ritornato con ret
}

/*
Differenze principali tra C e Assembly:
- In C, i controlli sono più leggibili e modulari (funzioni di supporto), in ASM sono espansi in blocchi di salto.
- In C, la gestione del segno avviene con un if annidato; in ASM con cmp/b.ne/b.eq e mov.
- In C, il ciclo sulle cifre è più compatto; in ASM ogni operazione è esplicita (mul, add, sub).
- In ASM, la gestione di NULL è esplicita con un salto all'inizio; in C con un if subito.
- In C, il risultato viene ritornato direttamente; in ASM viene calcolato e messo in w0 prima del ret.
*/
