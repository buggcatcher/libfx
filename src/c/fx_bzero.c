#include "libfx.h"

void	fx_bzero(void *s, size_t n)
{
	fx_memset(s, 0, n);
}