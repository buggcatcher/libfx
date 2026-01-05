#ifndef LIBFX_H
#define LIBFX_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ================= CONVERTER ================= */

/**
 * @brief Convert string to int.
 *
 * - Skips ASCII whitespace
 * - Optional sign
 * - Base 10
 * - No overflow detection
 *
 * ABI-stable, ASM-replaceable.
 */
int fx_atoi(const char *nptr);

/**
 * @brief Apply function f to each character of s, returns new allocated string.
 */
char *fx_strmapi(const char *s, char (*f)(unsigned int, char));

/**
 * @brief Set n bytes of s to c (as unsigned char).
 */
void *fx_memset(void *s, int c, size_t n);

/**
 * @brief Set n bytes of s to zero.
 */
void fx_bzero(void *s, size_t n);

/**
 * @brief Allocate zero-initialized memory.
 */
void *fx_calloc(size_t nmemb, size_t size);

/**
 * @brief Copy up to sz-1 chars from src to dst, NUL-terminate.
 */
size_t fx_lcpy(char *dst, const char *src, size_t sz);

/**
 * @brief Copy up to sz-1 chars from src to dst, NUL-terminate (BSD strlcpy).
 */
size_t fx_strlcpy(char *dst, const char *src, size_t sz);

/**
 * @brief Copy n bytes from src to dest.
 */
void *fx_memcpy(void *dest, const void *src, size_t n);

/**
 * @brief Move n bytes from src to dest, safe for overlap.
 */
void *fx_memmove(void *dest, const void *src, size_t n);

/**
 * @brief Duplicate a string.
 */
char *fx_strdup(const char *s);

/**
 * @brief Return length of string.
 */
size_t fx_strulen(const char *s);

#ifdef __cplusplus
}
#endif

#endif // LIBFX_H
