.text
    .globl ft_atoi
    .type ft_atoi, %function

ft_atoi:
    cbz     x0, .Lzero          // NULL check
    mov     w1, #0              // i = 0
    mov     w2, #1              // sign = 1
    mov     w3, #0              // res = 0

.Lws:
    ldrb    w4, [x0, x1]        // carica nptr[i]
    cmp     w4, #' '            // spazio?
    b.eq    .Lws_inc
    cmp     w4, #9              // < '\t'?
    b.lt    .Lsign
    cmp     w4, #13             // > '\r'?
    b.gt    .Lsign

.Lws_inc:
    add     w1, w1, #1
    b       .Lws

.Lsign:
    cmp     w4, #'-'
    b.ne    .Lplus
    mov     w2, #-1             // sign = -1
    add     w1, w1, #1
    b       .Ldigit

.Lplus:
    cmp     w4, #'+'
    b.ne    .Ldigit
    add     w1, w1, #1

.Ldigit:
    ldrb    w4, [x0, x1]        // ricarica
    cmp     w4, #'0'
    b.lt    .Lend
    cmp     w4, #'9'
    b.gt    .Lend

                                // res = res * 10 + (c - '0')
    mov     w5, #10
    mul     w3, w3, w5          // no immediati
    sub     w4, w4, #'0'
    add     w3, w3, w4

    add     w1, w1, #1
    b       .Ldigit

.Lend:
    mul     w0, w3, w2          // return res * sign
    ret

.Lzero:
    mov     w0, #0
    ret