#include "libfx.h"

char	*fx_strdup(const char *s)
{
	char	*res;
	size_t	s_len;

	if (!s)
		return (NULL);
	s_len = fx_strulen(s);
	res = fx_calloc(s_len + 1, sizeof(char));
	if (!res)
		return (NULL);
	fx_strlcpy(res, s, s_len + 1);
	return (res);
}
