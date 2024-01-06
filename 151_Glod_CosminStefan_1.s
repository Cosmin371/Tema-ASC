.data
	s: .space 1600 #18 linii si coloane +2 pentru matricea extinsa
	s1: .space 1600 #copie
	
	formatScanf: .asciz "%ld"
	formatPrintf: .asciz "%ld "
	newLine: .asciz "\n"
	formatString: .asciz "%s"
	formatChar: .asciz "%c"
	zeroX: .asciz "0x"
	formatPrintfX: .asciz "%02X"
	
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
	aux: .space 4
	
	c: .space 4
	mesaj: .space 12
	mesaj_criptat: .space 24
	
	lenMesaj: .space 4
	byte_asamblat: .space 4
.text
.global main
main:
	#cin >> n
	pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

	#cin >> m
	pushl $m
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

	#cin >> p
	pushl $p
	pushl $formatScanf
	call scanf
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
	call scanf
	popl %ebx
	popl %ebx

	#cin >> right
	pushl $right
	pushl $formatScanf
	call scanf
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

	# cin >> k
	pushl $k
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx


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

	#cin >> c // cerinta
	pushl $c
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx

cmpl $1, c
je cerinta2

#--------------------------------------------

cerinta1:

	#cin >> mesaj
	pushl $mesaj
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx

lea mesaj, %esi
aflare_lungime_mesaj:
	xorl %ecx, %ecx
	parcurgere_mesaj:
		movb (%esi, %ecx, 1), %al
		cmpb $0, %al
		je sfarsit_parcurgere_mesaj
		
		incl %ecx
		jmp parcurgere_mesaj
	sfarsit_parcurgere_mesaj:
	
	movl %ecx, lenMesaj
sfarsit_aflare_lungime_mesaj:

pushl $zeroX				#afisare "0x"
call printf
popl %ebx

pushl $0
call fflush
popl %ebx

creare_cheie: # cheia este stocata in variabila criptare

	lea mesaj, %esi
	xorl %ecx, %ecx			#ecx = 0
	xorl %edx, %edx 		# edx pentru a sti pe ce byte ne aflam
	
	for_byte:
	
	cmpl %edx, lenMesaj
	je sfarsit_for_byte
	
	movl $8, %ebx			# 8 shiftari pana sa schimbam byte ul
	xorl %eax, %eax			# eax = 0
		
	asamblare_byte:
		cmpl %ecx, dimMat	# daca ecx a ajuns la finalul matricei sa o ia de la inceput
		jne skip_resetare
			
		resetare:
		xorl %ecx, %ecx
			
		skip_resetare:		# nu se reseteaza ecx ul
		cmpl $0, %ebx		# daca nu mai avem shiftari disponibile, iesim
		je sfarsit_asamblare_byte
		
		movl %ebx, aux		# am nevoie de un registru in plus,
					# o sa-l folosesc pe ebx temporar
		
		movl (%edi, %ecx, 4), %ebx	# valoarea din matrice pe pozitia ecx
		sal $1, %eax			# shiftez la stanga, sa fac loc urmatorului bit
		addl %ebx, %eax			# adaug urmatorul bit obtinut la iterarea curenta
		
		movl aux, %ebx		# restitui valoarea lui ebx inapoi
		
		incl %ecx		# urmatorul element din matrice
		decl %ebx		# scade numarul de shiftari disponibile
		jmp asamblare_byte
	sfarsit_asamblare_byte:
	
	xorb (%esi, %edx, 1), %al	# xor pentru byte ul din mesaj si cel din matrice
	
	afisare_rezultat:
	
		pusha
		pushl %eax
		pushl $formatPrintfX
		call printf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
		popa
	
	sfarsit_afisare_rezultat:
	
	incl %edx
	jmp for_byte
	
	sfarsit_for_byte:

sfarsit_creare_cheie:
jmp exit

#--------------------------------------

cerinta2:

	pushl $mesaj_criptat	#citire mesaj criptat
	pushl $formatString
	call scanf
	popl %ebx
	popl %ebx
	
lea mesaj_criptat, %esi
addl $2, %esi			# trec peste partea cu "0x"

aflare_lungime_mesaj_criptat:	# aflu lungimea mesajului criptat, apoi o impart la doi
	xorl %ecx, %ecx		# practic aflu lungimea mesajului decriptat
	parcurgere_mesaj_criptat:
		movb (%esi, %ecx, 1), %al
		cmpb $0, %al
		je sfarsit_parcurgere_mesaj_criptat
		
		incl %ecx
		jmp parcurgere_mesaj_criptat
	sfarsit_parcurgere_mesaj_criptat:
	
	sar $1, %ecx		# impart la 2
	movl %ecx, lenMesaj
sfarsit_aflare_lungime_mesaj_criptat:

creare_cheie2: # cheia este stocata in variabila criptare

	xorl %ecx, %ecx		# ecx pentru a sti pozitia elementului din vector
	xorl %edx, %edx		# edx pentru a sti pe ce byte ne aflam
	
	lea mesaj_criptat, %esi
	addl $2, %esi
	
	for_byte2:
	
	cmpl %edx, lenMesaj
	je sfarsit_for_byte2
	
	movl $8, %ebx		# 8 shiftari
	xorl %eax, %eax
		
	asamblare_byte2:
		cmpl %ecx, dimMat
		jne skip_resetare2
			
		resetare2:
		xorl %ecx, %ecx
			
		skip_resetare2:
		cmpl $0, %ebx
		je sfarsit_asamblare_byte2
		
		movl %ebx, aux
		
		movl (%edi, %ecx, 4), %ebx
		sal $1, %eax
		addl %ebx, %eax
		
		movl aux, %ebx
		
		incl %ecx
		decl %ebx
		jmp asamblare_byte2
	sfarsit_asamblare_byte2:
	
	movl %eax, byte_asamblat	# stochez byte-ul asamblat intr-o adresa de memorie,
					# am nevoie de registrul eax
	
	calcul_byte:
		xorl %ebx, %ebx
		
		movl %edx, %eax
		sal $1, %eax			#inmultesc cu 2
		movb (%esi, %eax, 1), %bh
						# inainte de 60 sunt cifrele, dupa sunt caracterele ABCDEF
						
		part1:				# partea 1 din byte-ul citit		
		cmpb $60, %bh
		jl cifra1
		caracter1:
			subb $55, %bh
			jmp part2
		cifra1:
			subb $48, %bh
		
		part2:				# partea a 2 a din byte-ul citit
		incl %eax
		movb (%esi, %eax, 1), %bl
		
		cmpb $60, %bl
		jl cifra2
		
		caracter2:
			subb $55, %bl
			jmp final_transformare
		cifra2:
			subb $48, %bl
			
		final_transformare:		# lipesc cele 2 parti
			movb %bl, %al		# copiez partea dreapta pentru ca urmeaza sa fie stearsa
			sar $4, %ebx		# shiftez la dreapta, aducand din bh in bl, dar stergand ultimii 4 biti
			addb %al, %bl		# pun cei 4 biti inapoi
		
	sfarsit_calcul_byte:
	
	movl byte_asamblat, %eax
	xorb %bl, %al				# efectuez XORarea finala
	
	afisare_decriptare:
	
		pusha
		pushl %eax
		pushl $formatChar
		call printf
		popl %ebx
		popl %ebx
		
		pushl $0
		call fflush
		popl %ebx
		popa
		
	sfarsit_afisare_decriptare:
	
	incl %edx
	jmp for_byte2
	
	sfarsit_for_byte2:

sfarsit_creare_cheie2:

exit:
	movl $1, %eax
	xor %ebx, %ebx
	int $0x80
