	.text
	.globl ft_atoi
	.type ft_atoi, @function

ft_atoi:
	test    %rdi, %rdi
	je      .Lzero

	xor     %eax, %eax
	xor     %ecx, %ecx
	mov     $1, %edx

.Lws:
	movzbq  (%rdi,%rcx), %r8
	cmp     $' ', %r8
	je      .Lws_inc
	cmp     $9, %r8
	jb      .Lsign
	cmp     $13, %r8
	ja      .Lsign
.Lws_inc:
	inc     %rcx
	jmp     .Lws

.Lsign:
	cmp     $'-', %r8
	jne     .Lplus
	mov     $-1, %edx
	inc     %rcx
	jmp     .Ldigit
.Lplus:
	cmp     $'+', %r8
	jne     .Ldigit
	inc     %rcx

.Ldigit:
	movzbq  (%rdi,%rcx), %r8
	cmp     $'0', %r8
	jb      .Lend
	cmp     $'9', %r8
	ja      .Lend
	imul    $10, %eax
	sub     $'0', %r8
	add     %r8d, %eax
	inc     %rcx
	jmp     .Ldigit

.Lend:
	imul    %edx, %eax
	ret

.Lzero:
	xor     %eax, %eax
	ret
