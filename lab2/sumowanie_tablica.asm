.data 
	arr: .space 40
# Program wypisuje	
	
.text

# t0 - ilosc elementow tablicy
# t1 - licznik elementow tablicy
# s0 - wskaznik na aktualny element tablicy
# t2 - suma liczb w tablicy
# t3 - rejestr pomocniczy by przechowac liczbe do zmusmowania

main:
	li $t0, 3
	li $t1, 0
	la $s0, arr
	
loop:
	beq $t1, $t0, endloop	# warunek wyjscia z petli
	li $v0, 5 				# odczytaj inta
	syscall
	sw $v0, 0($s0) 			# wrzuc odczytanego inta do tablicy
	addi $s0, $s0, 4 		# inkrementacja wskaznika
	addi $t1, $t1, 1		# inkrementacja warunku petli
	j loop
	
endloop:
	
	la $s0, arr # ustawiamy wskaznik na pierwszy element
	li $t1, 0 # iterator petli ustawiamy na 0
	li $t2, 0

loop2:
	beq $t1, $t0, endloop2	# warunek wyjscia z petli
	
	lw $t3, 0($s0)
	add $t2, $t2, $t3		# dodanie do wyniku
	
	addi $s0, $s0, 4 		# inkrementacja wskaznika
	addi $t1, $t1, 1		# inkrementacja warunku petli
	j loop2

endloop2:	
	
	li $v0, 1
	move $a0, $t2
	syscall

	li $v0, 10
	syscall
	