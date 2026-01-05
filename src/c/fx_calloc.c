#include "libfx.h"
#include <stdlib.h>
#include "libfx.h"

void	*fx_calloc(size_t nmemb, size_t size)
{
	void	*res;

	res = malloc(nmemb * size);
	if (!res)
		return (NULL);
	if (size > 0)
		fx_bzero(res, nmemb * size);
	return (res);
}