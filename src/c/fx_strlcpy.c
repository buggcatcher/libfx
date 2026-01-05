#include "libfx.h"

size_t	fx_strlcpy(char *dst, const char *src, size_t sz)
{
	size_t	src_len;

	src_len = fx_strulen(src);
	if (src_len < sz)
		fx_memcpy(dst, src, src_len + 1);
	else if (sz != 0)
	{
		fx_memcpy(dst, src, sz - 1);
		dst[sz - 1] = '\0';
	}
	return (src_len);
}