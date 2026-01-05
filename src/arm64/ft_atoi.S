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

    mov     w6, #2147483647      // INT_MAX
    mov     w7, #-2147483648     // INT_MIN
    mov     w8, #214748364       // INT_MAX/10

.Ldigit:
    ldrb    w4, [x0, x1]        // ricarica
    cmp     w4, #'0'
    b.lt    .Lend
    cmp     w4, #'9'
    b.gt    .Lend

                                // res = res * 10 + (c - '0')
    mov     w5, #10
    // Overflow check
    cmp     w2, #1
    b.ne    .Lnegcheck
    cmp     w3, w8
    b.hi    .Lmax

.Lnegcheck:
    cmp     w2, #-1
    b.ne    .Lcalc
    mov     w9, #214748364       // INT_MIN/10 (positivo)
    cmp     w3, w9
    b.hi    .Lmin

.Lcalc:
    mul     w3, w3, w5          // no immediati
    sub     w4, w4, #'0'
    add     w3, w3, w4

    add     w1, w1, #1
    b       .Ldigit

.Lmax:
    mov     w0, w6
    ret

.Lmin:
    mov     w0, w7
    ret

.Lend:
    mul     w0, w3, w2          // return res * sign
    ret
    
.Lzero:
    mov     w0, #0
    ret