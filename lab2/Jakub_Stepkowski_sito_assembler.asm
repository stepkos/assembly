.data
	n: .word 40					# zakres w ktorym szukamy
	numall: .space 400			# deklaracja tablicy na wykreslanie
	primes: .space 100			# deklaracja tablicy samych liczb pierwszych 
	nprimes: .word 0			# ilosc liczb pierwszych w przedziale
	space_msg: .asciiz ", "		# zmienna z napisem
	
.text

# Legenda
# t0 - ilosc elementow
# t1 - licznik powtorzen petli
# s0 - wskaznik na aktualny element tablicy
# s1 - wskaznik do petli wewnetrzej

# t2 - rejestr rowny 1
# t3 - rejstr pomocniczy
main:
	lw $t0, n 				# wczytujemy do t0 dlugosc przedzialu na ktorym szukamy
	li $t2, 1				# wczytujemy do t2 wartosc 1 na stale by bylo nam pozniej wygodniej 
	jal set_loop_registers	# ustawienie rejestrow dla petli
	
# primes = [True for _ in range(N)]
# petla umieszczajaca same 1 w tablicy symbolizyjace prawde z kodu w pythonie	
loop:
	beq $t1, $t0, endloop	# warunek wyjscia z petli
	
	# operacja wewnarz petli inne to operacje sterujace petla
	sw $t2, 0($s0) # wypelnienie tablicy jedynkami

	jal increment	# inkrementacja zmiennnych petli za pomoca procedury
	j loop			# powrot do poczatku petli
	
endloop:

jal set_loop_registers	# ustawienie rejestrow dla petli

# primes[0] = False
sw $zero, 0($s0) 	# zapisanie zera do primes[0]
jal increment		# inkrementacja iteratora tak by trafic do kolejengo adresu

# primes[1] = False
sw $zero, 0($s0) 	# zapisanie zera do primes[1]
jal increment		# inkrementacja iteratora tak by trafic do kolejengo adresu

# petla glowna programu
# przechodzimy po liczbach i jesli jest 1 to wyrzucamy wielokrotnosci
loop2:
	div $t7, $t0, 2			# dzielimy przez 2 by nie iterowac niepotrzebnie
	bge $t1, $t7, endloop2	# warunek wyjscia z petli
	
	# jesli element jest rowny 0 to pomijamy jesli 1 to ustawiamy wielokrotnosci na 0
	lw $t3, 0($s0) 			# pomocniczo ladujemy do rejestru by porownac
	beq $t3, $zero, skip	# jesli wartosc jest zero to omijamy ja
	
	# zamiana kazdej wielokrotnosci odecnego elementu na false (0)
	# ---------------------------------------------------------------
	move $t4, $t1	# zapisujemy od rejestru pomocnicznego
	#add $t4, $t4, $t1 

	loop3:
		bge $t4, $t0, endloop3	# warunek wyjscia z petli
	
		# operacja wewnarz petli inne to operacje sterujace petla
		# t5 - adres elementu
		mul $t5, $t4, 4			# mnozymy razy 4 by uzyskac adres
		add $t5, $t5, $s0		# dodajemy offset
		sw $zero, 0($t5) 		# wstawienie 0 do tablicy

		add $t4, $t4, $t1		# iterujemy co $t1
		j loop3					# powracamy do petli
	
	endloop3:
	
	# -------------------------------------------------------------
	skip:
		jal increment	# inkrementacja zmiennnych petli za pomoca procedury
		j loop2		
	
endloop2:
	
jal set_loop_registers # zerowanie wspolczynnikow petli

la $t2, primes # wczytujemy adres primes to $t2
li $t4, 0 # ustanawiamy $t4 licznikiem liczb pierwszych

loop4:
	bge $t1, $t0, endloop4	# warunek wyjscia z petli
	
	lw $t3, 0($s0) # pomocniczo ladujemy do rejestru by porownac
	beq $t3, $zero, skip2 # wypsiz liczbe jesli 1
	
	# zapis do primes
	sw $t1, 0($t2) 
	add $t2, $t2, 4
	addi $t4, $t4, 1
	
	skip2:
		jal increment	# inkrementacja zmiennnych petli za pomoca procedury
		j loop4
	
endloop4:
sw $t4, nprimes

# petla wypisujaca primes
la $t2, primes # wczytujemy adres primes to $t2
li $t5, 0 # ustanawiamy $t4 licznikiem
loop5:
	beq $t5, $t4, endloop5
	
	# wypisywanie liczny
	li $v0, 1
	lw $t6, 0($t2)
	move $a0, $t6
	syscall
	
	# wypisywanie spacji i przecinka
	li $v0, 4
	la $a0, space_msg
	syscall
	
	# inkrementacja
	add $t2, $t2, 4
	add $t5, $t5, 1
	j loop5
	
endloop5:
	
# zakonczenie programu
li $v0, 10
syscall

# ustawianie rejestrow odpowiedzialnych za iteracje petli
set_loop_registers:
	li $t1, 0		# wyzerowanie iteratorsa
	la $s0, numall	# ustawienie wskaznika na pierwszy element
	jr $ra			# powrot do kolejnej instrukcji

increment:
	addi $s0, $s0, 4 # inkrementacja wskaznika
	addi $t1, $t1, 1 # inkrementacja warunku petli
	jr $ra			 # powrot
