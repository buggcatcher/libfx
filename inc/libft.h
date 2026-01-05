#ifndef LIBFT_H
#define LIBFT_H

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
int ft_atoi(const char *nptr);

#ifdef __cplusplus
}
#endif

#endif
