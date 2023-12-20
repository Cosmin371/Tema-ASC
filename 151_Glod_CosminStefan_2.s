.data
	s: .space 1600 #18 linii si coloane +2 pentru matricea extinsa
	s1: .space 1600 #copie
	
	n: .space 4
	n2: .space 4
	m: .space 4
	m2: .space 4
	p: .space 4
	left: .space 4
	right: .space 4
	index: .space 4
	linie: .space 4
	coloana: .space 4
	k: .space 4
	vecini: .space 4
	dimMat: .space 4
	
	input_file: .asciz "in.txt"
	output_file: .asciz "out.txt"

	pointer_input_file: .long 0
	pointer_output_file: .long 0

	w: .asciz "w"
	r: .asciz "r"
	
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	newLine: .asciz "\n"
.text
.global main
main:
	pushl $w			# cadru de apel pentru fopen
	pushl $output_file
	call fopen
	popl %ebx
	popl %ebx

	movl %eax, pointer_output_file  # pointerul catre fisierul de iesire

	pushl $r
	pushl $input_file
	call fopen
	popl %ebx
	popl %ebx
	
	movl %eax, pointer_input_file	# pointerul catre fisierul de intrare

	#cin >> n
	pushl $n
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	#cin >> m
	pushl $m
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	#cin >> p
	pushl $p
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	lea s, %edi
	lea s1, %esi
	
	movl n, %eax
	movl %eax, n2
	movl m, %eax
	movl %eax, m2
	addl $2, n2
	addl $2, m2
	
	xorl %edx, %edx
	movl n2, %eax
	mull m2
	movl %eax, dimMat

xorl %ecx, %ecx				#initializare matrice s cu 0
initializare_matrice:
	cmp %ecx, dimMat
	je sfarsit_initializare_matrice
	
	movl $0, (%edi, %ecx, 4)
	incl %ecx
	jmp initializare_matrice
sfarsit_initializare_matrice:

movl $0, index
loop_citire:
	#for (index = 0; index < p; ++index)
	#	cin >> left >> right;
	#	s[left + 1][right + 1] = 1;

	movl index, %ecx
	cmp p, %ecx
	je sfarsit_loop_citire

	#cin >> left
	pushl $left
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	#cin >> right
	pushl $right
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	# s[left + 1][right + 1] =
	movl left, %eax
	incl %eax
	xor %edx, %edx
	mull m2
	addl right, %eax
	incl %eax
	movl $1, (%edi, %eax, 4)

	incl index
	jmp loop_citire
sfarsit_loop_citire:

citire_k:       # cin >> k
	pushl $k
	pushl $formatScanf
	pushl pointer_input_file
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
sfarsit_citire_k:

movl $0, index
for_k_loop:
	movl index, %ecx
	cmpl k, %ecx
	je sfarsit_for_k_loop

	xorl %ecx, %ecx
	resetare_matrice_s1:		# initializez toata matricea extinsa s1 cu 0
		cmp %ecx, dimMat
		je sfarsit_resetare_matrice_s1
		
		movl $0, (%esi, %ecx, 4)
		incl %ecx
		jmp resetare_matrice_s1
	sfarsit_resetare_matrice_s1:
	
	movl $1, linie
	pentru_linie:
		movl linie, %ecx
		cmp n, %ecx
		jg sfarsit_pentru_linie
		
		movl $1, coloana
		pentru_coloana:
			movl coloana, %ecx
			cmp m, %ecx
			jg sfarsit_pentru_coloana
			
			# calcul vecini element de pe pozitia [linie, coloana]
			movl $0, vecini
			
			# %eax = [linie, coloana]
			movl linie, %eax
			xor %edx, %edx
			mull m2
			addl coloana, %eax
			
			# %eax = [linie, coloana +1 -1]
			decl %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			addl $2, %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			
			# %eax = [linie - 1, coloana +0 +1 -1]
			subl m2, %eax #scad o linie
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			decl %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			decl %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			
			# %eax = [linie + 1, coloana +0 +1 -1]
			addl m2, %eax
			addl m2, %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			incl %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			incl %eax
			movl (%edi, %eax, 4), %ecx
			addl %ecx, vecini
			
			# inapoi la pozitia initiala [linie, coloana]
			subl m2, %eax
			decl %eax

			cmpl $1, (%edi, %eax, 4)
			je celula_vie
			
			celula_moarta:
				movl vecini, %ecx
				cmpl $3, %ecx
				je s1_1
				
				jmp s1_0
				
			celula_vie:
				movl vecini, %ecx
				cmp $1, %ecx
				jle s1_0
				
				cmp $4, %ecx
				jge s1_0
				
				jmp s1_1
			
			s1_0:
				movl $0, (%esi, %eax, 4)
				jmp sfarsit_comparatie
			s1_1:
				movl $1, (%esi, %eax, 4)
			
			sfarsit_comparatie:
			
			incl coloana
			jmp pentru_coloana
		sfarsit_pentru_coloana:

		incl linie
		jmp pentru_linie		
	sfarsit_pentru_linie:
	
	xorl %ecx, %ecx			# copiere matrice s1 inapoi in s
	copiere_matrice:
		cmp %ecx, dimMat
		je sfarsit_copiere_matrice
		
		movl (%esi, %ecx, 4), %eax
		movl %eax, (%edi, %ecx, 4)
		
		incl %ecx
		jmp copiere_matrice
	sfarsit_copiere_matrice:

	incl index
	jmp for_k_loop

sfarsit_for_k_loop:

afisare_matrice:
	movl $1, linie
	for_lines:
		movl linie, %ecx
		cmp n, %ecx
		jg sfarsit_afisare_matrice

		movl $1, coloana
		for_columns:
			movl coloana, %ecx
			cmp m, %ecx
			jg new_line

			movl linie, %eax
			xor %edx, %edx
			mull m2
			addl coloana, %eax

			pushl (%edi, %eax, 4)
			pushl $formatPrintf
			pushl pointer_output_file
			call fprintf
			popl %ebx
			popl %ebx
			popl %ebx

			pushl $0
			call fflush
			popl %ebx

			incl coloana
			jmp for_columns

	new_line:
	pushl $newLine
	pushl pointer_output_file
	call fprintf
	popl %ebx
	popl %ebx
	
	pushl $0
	call fflush
	popl %ebx

	incl linie
	jmp for_lines
sfarsit_afisare_matrice:
jmp exit

exit:
	movl $1, %eax
	xor %ebx, %ebx
	int $0x80
