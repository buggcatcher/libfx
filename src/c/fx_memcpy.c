#include "libfx.h"

void	*fx_memcpy(void *dest, const void *src, size_t n)
{
	if (!src)
		return (dest);
	if (!dest)
		return (NULL);
	return (fx_memmove(dest, src, n));
}