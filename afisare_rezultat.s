.data
	rezultat: .space 11
	caracter: .space 1
	formatString: .asciz "%s"
	zeroX: .asciz "0x"
	formatPrintf: .asciz "%X"
	
	i: .space 4
	lenRez: .space 4
.text
.global main
main:
	
afisare_rezultat:
	lea rezultat, %edi
	
	pushl $zeroX		# afisez "0x"
	call printf
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	xorl %ecx, %ecx
	movl $0, i
loop_afisare:
	movl i, %ecx
	
	movl (%edi, %ecx, 1), %eax
	andl $0xFF, %eax
	
	cmp $0, %eax
	je sfarsit_loop_afisare
	
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
	
	incl linie
	jmp for_loop
sfarsit_loop_afisare:
sfarsit_afisare_rezultat:

exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
