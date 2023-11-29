.data
	intrare: .asciz "in.txt"
	iesire: .asciz "out.txt"
	fin: .space 4
	formatPrintf: .asciz "%ld "
	str: .space 3
	n: .space 4
	m: .space 4
.text
citire:
	movl $3, %eax
	movl fin, %ebx
	movl $str, %ecx
	movl $3, %edx
	int $0x80

	movl str, %eax
	movl %eax, %ebx
	andl $0xF, %eax   # prima cifra
	andl $0xF00, %ebx # a doua cifra
	shr $8, %ebx

	cmp $10, %ebx        # atunci numarul are doar o cifra
	jge sfarsit_atribuire

	xor %edx, %edx       # doua cifre
	movl $10, %ecx
	mull %ecx
	addl %ebx, %eax

	sfarsit_atribuire:
	ret

.global main

# schimb modul de a transforma variabila string in int
# citesc un caracter pe rand
# cand dau de "\n" aka 0x0a termin citirea pentru variabila respectiva


main:

	# deschide fisier de intrare
	movl $5, %eax
	movl $intrare, %ebx
	movl $0, %ecx
	movl $0644, %edx
	int $0x80
	
	# am adresa de unde sa citeasca in %eax acum
	movl %eax, fin

	call citire
	movl %eax, n
	
	pushl n
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx

	pushl $0
	call fflush
	popl %ebx
	
	call citire
	movl %eax, m
	
	pushl m
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx
exit:
	movl $1, %eax
	xor %ebx, %ebx
	int $0x80
