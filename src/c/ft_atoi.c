#include "inc/libft.h"
#include <limits.h>

static int	ft_isspace(int c)
{
	return (c == ' ' || (c >= 9 && c <= 13));
}

static int	ft_isdigit(int c)
{
	return (c >= '0' && c <= '9');
}

int	ft_atoi(const char *nptr)
{
	int i;
	int sign;
	long res;
	int digit;

	if (!nptr)
		return (0);

	i = 0;
	while (ft_isspace(nptr[i]))
		i++;

	sign = 1;
	if (nptr[i] == '+' || nptr[i] == '-')
		if (nptr[i++] == '-')
			sign = -1;

	res = 0;
	while (ft_isdigit(nptr[i]))
	{
		digit = nptr[i++] - '0';
		if (sign == 1 && (res > (LONG_MAX - digit) / 10))
			return (INT_MAX);
		if (sign == -1 && (-res < (LONG_MIN + digit) / 10))
			return (INT_MIN);
		res = res * 10 + digit;
	}

	if (i == 0 || !ft_isdigit(nptr[i-1]))
		return (0);

	if (sign == 1 && res > INT_MAX)
		return (INT_MAX);
	if (sign == -1 && -res < INT_MIN)
		return (INT_MIN);

	return ((int)(res * sign));
}

/*
Differenze principali tra C e Assembly:
- In C, i controlli sono più leggibili e modulari (funzioni di supporto), in ASM sono espansi in blocchi di salto.
- In C, la gestione del segno avviene con un if annidato; in ASM con cmp/b.ne/b.eq e mov.
- In C, il ciclo sulle cifre è più compatto; in ASM ogni operazione è esplicita (mul, add, sub).
- In ASM, la gestione di NULL è esplicita con un salto all'inizio; in C con un if subito.
- In C, il risultato viene ritornato direttamente; in ASM viene calcolato e messo in w0 prima del ret.
*/
