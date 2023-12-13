.data
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	input_file: .ascii "in.txt"		

	w: .asciz "w"
	r: .asciz "r"
	pointer_input_file: .space 4
	n: .space 4
.text
.global main
main:
	pushl $r			# cadru de apel pentru fopen // input
	pushl $input_file
	call fopen
	popl %ebx
	popl %ebx

	movl %eax, pointer_input_file  # pointerul catre fisierul de iesire

	#cin >> n
	
	pushl $n
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	addl $12, %esp
	
	#pushl n
	#pushl $formatPrintf
	#call printf
	#addl $8, %esp
exit:
	movl $1, %eax
	xor %ebx, %ebx
	int $0x80
