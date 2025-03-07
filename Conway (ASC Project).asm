.data
    index1: .space 4 
    index2: .space 4
    index3: .space 4

    coordonata_x: .space 4 
    coordonata_y: .space 4

    m: .space 4
    n: .space 4
    p: .space 4
    k: .space 4

    count: .space 4
    element: .space 4
    linie: .space 4
    coloana: .space 4

    mat1: .space 1600
    mat2: .space 1600

    deschidere: .asciz "in.txt"
    scriere: .asciz "out.txt"
    nrDeschidere: .long 0
    nrScriere: .long 0
    read: .asciz "r"
    write: .asciz "w"

    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d"
    newLine: .asciz "\n"
.text
.global main

/*deschidem fisierele si citim m,n si p*/
main:
    pushl $read
	pushl $deschidere
	call fopen
	popl %ebx
	popl %ebx
	movl %eax, nrDeschidere

	pushl $write
	pushl $scriere
	call fopen
	popl %ebx
	popl %ebx
	movl %eax, nrScriere

	pushl $m
	pushl $formatScanf
	pushl nrDeschidere
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
	
	pushl $n
	pushl $formatScanf
	pushl nrDeschidere
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
	
	pushl $p
	pushl $formatScanf
	pushl nrDeschidere
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx
	
	jmp read_mat
	
/*citeste matricei 1 si matricei 2 (copie)*/
read_mat:
	movl $0, index1

	movl $19, %ebx
	movl %ebx, %eax
	movl $20, %ebx
	movl $0, %edx
	mull %ebx
	addl $19, %eax

	am_ramas_fara_nume_de_etichete:
		movl index1, %ecx
		cmp %eax, %ecx
		je insert_ones

		lea mat1, %edi
		movl $0, (%edi,%ecx,4)
	
		lea mat2, %edi
		movl $0, (%edi,%ecx,4)

		incl index1
		jmp am_ramas_fara_nume_de_etichete

/*citeste coordonatele x(linie) si y(coloana) si le insereaza in matricea 1 si 2*/
insert_ones:
	movl $1, index1
	for_p:
		movl index1, %ecx
		cmp p, %ecx
		jg evolutii

		pushl $coordonata_x
		pushl $formatScanf
		pushl nrDeschidere
		call fscanf
		popl %ebx
		popl %ebx
		popl %ebx
	
		pushl $coordonata_y
		pushl $formatScanf
		push nrDeschidere
		call fscanf
		popl %ebx
		popl %ebx
		popl %ebx

		movl coordonata_x, %eax
		incl %eax
		movl $20, %ebx
		movl $0, %edx
		mull %ebx
		addl coordonata_y, %eax
		incl %eax

		lea mat1, %edi
		movl $1, (%edi, %eax, 4)

		lea mat2, %edi
		movl $1, (%edi, %eax, 4)

		incl index1
		jmp for_p

/*OK,asta o sa fie probabil,posibil,maybe,perhaps greu de inteles..
-evolutii contine un for pentru numarul de evolutii (k)
-acesta contine un for pentru numarul de linii (atentie, citim de la 1 la m (inclusiv m), nu are rost sa verificam si marginile
-acesta contine un for pentru numarul de coloane (aceeasi regula ca la linii)
-inseram in "count" suma elementelor vecinilor
-restul.. este o gramada de verificari if/else (modificand matricea mat1)
-nu uita sa rescrii matricea mat2*/
evolutii:
	pushl $k
	pushl $formatScanf
	pushl nrDeschidere
	call fscanf
	popl %ebx
	popl %ebx
	popl %ebx

	movl $1, index1
	pentru_k:
		movl $1, index2

		movl index1, %ecx
		cmp k, %ecx
		jg print_matrix
		pentru_m:
			movl $1, index3

			movl index2, %ecx
			cmp m, %ecx
			jg transmitere
			pentru_n:
				movl $0, count

				movl index3, %ecx
				cmp n, %ecx
				jg end_m

				/*element*/
				movl index2, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				movl %ecx, element

				/*vecinul din stanga-sus*/
				movl index2, %eax
				subl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				subl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din sus*/
				movl index2, %eax
				subl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din dreapta-sus*/
				movl index2, %eax
				subl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				addl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din stanga*/
				movl index2, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				subl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din dreapta*/
				movl index2, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				addl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din stanga-jos*/
				movl index2, %eax
				addl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				subl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din jos*/
				movl index2, %eax
				addl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				/*vecinul din dreapta-sus*/
				movl index2, %eax
				addl $1, %eax
				movl $20, %ebx
				movl $0, %edx
				mull %ebx
				addl index3, %eax
				addl $1, %eax
				lea mat2, %edi
				movl (%edi, %eax, 4), %ecx
				addl %ecx, count

				movl $0, %eax
				cmp %eax, element
				je if_zero

				movl $1, %eax
				cmp %eax, element
				je if_one

				if_zero:
					movl $3, %eax
					cmp %eax, count
					jne end_n
					
					movl index2, %eax
					movl $20, %ebx
					movl $0, %edx
					mull %ebx
					addl index3, %eax
					lea mat1, %edi
					movl $1, (%edi, %eax, 4)

					jmp end_n
				if_one:
					movl $3, %eax
					cmp %eax, count
					je end_n

					movl $2, %eax
					cmp %eax, count
					je end_n

					movl index2, %eax
					movl $20, %ebx
					movl $0, %edx
					mull %ebx
					addl index3, %eax
					lea mat1, %edi
					movl $0, (%edi, %eax, 4)

					jmp end_n

				end_n:
					incl index3
					jmp pentru_n
			end_m:
				incl index2
				jmp pentru_m
		transmitere:
			movl $1, linie
			transmiterea_informatiilor_linie:
				movl $1, coloana
				movl linie, %eax
				cmp m, %eax
				jg end_k
				transmiterea_informatiilor_coloana:
					movl coloana, %eax
					cmp n, %eax
					jg end_transmiterea_informatiilor_linie

					movl linie, %eax
					movl $20, %ebx
					movl $0, %edx
					mull %ebx
					addl coloana, %eax

					lea mat1, %edi
					movl (%edi, %eax, 4), %ecx

					lea mat2, %edi
					movl %ecx, (%edi, %eax, 4)

					incl coloana
					jmp transmiterea_informatiilor_coloana
				end_transmiterea_informatiilor_linie:
					incl linie
					jmp transmiterea_informatiilor_linie
		end_k:
			incl index1
			jmp pentru_k

/*printeaza matricea 1 in fisier*/
print_matrix:
	movl $1, index1
	for_lines:
		movl $1, index2
		movl index1, %ecx
		cmp m, %ecx
		jg et_exit
			for_columns:
			movl index2, %ecx
			cmp n, %ecx
			jg cont

			movl index1, %eax
			movl $20, %ebx
			movl $0, %edx
			mull %ebx
			addl index2, %eax

			lea mat1, %edi
			movl (%edi, %eax, 4), %ebx

			pushl %ebx
			pushl $formatPrintf
			pushl nrScriere
			call fprintf
			popl %ebx
			popl %ebx
			popl %ebx
			
			pushl nrScriere
			call fflush
			popl %ebx

			incl index2
			jmp for_columns
	cont:
		pushl $newLine
		pushl nrScriere
		call fprintf
		popl %ebx
		popl %ebx

		pushl nrScriere
		call fflush
		popl %ebx

		incl index1
		jmp for_lines
/*iesirea din program*/
et_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80