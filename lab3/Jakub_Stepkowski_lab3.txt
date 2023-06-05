.data
	RAM:						.space	4096
	
	msg_podaj_ilosc_wierszy: 	.asciiz	"Podaj ilosc wierszy: "
    msg_podaj_ilosc_kolumn: 	.asciiz "Podaj ilosc kolumn: "
    
    msg_podaj_wiersz:			.asciiz "Podaj wiersz: "
    msg_podaj_kolumne:			.asciiz "Podaj kolumne: "
    msg_podaj_liczbe:			.asciiz "Podaj liczbe: "
    
    msg_menu:					.asciiz "0. wyjscie\n1. odczytaj\n2. zapisz\n"
    msg_bledna_wartosc:			.asciiz "Niepoprawne dane wejsciowe\n"
    
    msg_nowa_linia:				.asciiz "\n"
    
.text
	# t0 - ilosc wierszy
    # t1 - ilosc kolumn
    # t2 - nr wiersza
    # t3 - nr kolumny
    # t4 - numer do wpisania
    # t5 - opcja w menu
    
    # s0 - adres pierwszego elementu pierwszej kolumny
    # s1 - adres wiersza w tablicy


	# Wypisz zapytanie o ilosc wierszy
	li $v0, 4
	la $a0, msg_podaj_ilosc_wierszy
	syscall
	
	# Wczytaj ilosc wierszy
	li $v0, 5
	syscall
	move $t0, $v0
	
	# Wypisz zapytanie o ilosc kolumn
	li $v0, 4
	la $a0, msg_podaj_ilosc_kolumn
	syscall
	
	# Wczytaj ilosc kolumn
	li $v0, 5
	syscall
	move $t1, $v0
	
 	mul $s0, $t0, 4 			# mnozymy razy 4 by uzyskac adres
 	
 	loop:
 		li $t3, 0 				# resetujemy nr kolumny
    	sw $s0, RAM($s1)		# zapisujemy adres na pierwszy element kolumny w tablicy
        mul $t4, $t2, 100		# mnoznymy nr wiersza razy 100 by usykac nr ktory chcemy wpisac
        
        loop2:		
       	 	addi $t4, $t4, 1	# dodajemy 1 do liczby u zyskac nr ktory chcemy wpisac
            sw $t4, RAM($s0)	# zapisuję tą liczbę do tablicy
            addi $t3, $t3, 1	# inkrementujemy nr kolumny
            addi $s0, $s0, 4	# ustawienie wskaznika na kolejny element 
            bne $t1, $t3, loop2	# jesli nie doszlismy do konca to powtarzamy petle
        
        addi $t2, $t2, 1		# inkrementujemy nr wiersza
        addi $s1, $s1, 4		# ustawiamy wskaznik na adres wskazujacy kolejna kolumne
        blt $t2, $t0, loop		# jesli nie doszlismy do konca wierszy to powtarzamy operacje
        
    menu:
        
		# Wypisz zapytanie o opcje w menu
		li $v0, 4
		la $a0, msg_menu
		syscall
	
		# Wczytaj wartosc ktora opcja w menu
		li $v0, 5
		syscall
		move $t5, $v0
		
		# jesli uzytkownik wpisal 0 to konczymy program
		beq $t5, $zero, end
		
		# jesli nie to pobieramy dane wejsciowe i umieszczamy je w t0 i t1
		# -------------------------------------
		# Wypisz zapytanie o wierszy
		li $v0, 4
		la $a0, msg_podaj_wiersz
		syscall
	
		# Wczytaj wiersz
		li $v0, 5
		syscall
		move $t0, $v0
	
		# Wypisz zapytanie o ilosc kolumn
		li $v0, 4
		la $a0, msg_podaj_kolumne
		syscall
	
		# Wczytaj kolumne
		li $v0, 5
		syscall
		move $t1, $v0
		# -------------------------------------
		
		# instukcje znalezienia odpowiedniego miejsca w tablicy
		# t0 - indeks wiersza
        # t1 - indeks kolumny
        # s2 - finalna pozycja
        mul $t0, $t0, 4		# mnozymy razy 4 by uzyskac adres wiersza
        lw $t3, RAM($t0)	# adres wiersza szukanego
        mul $t1, $t1, 4		# mnozymy razy 4 by uzyskac adres kolumny
        add $s2, $t3, $t1	# dodajemy by uzyksac pozycje komorki w pamieci
		
		
		# jesli wpisal 1 to odczyt
		beq $t5, 1, read
		
		# jesli wpisal 2 to zapis
		beq $t5, 2, write
		
		# jesli program jest tu czyli nie wykonaly sie skoki oznacza to ze...
		# wpisana zostla inna opcja czyli zostala podana niepoprawna wartosc
		# wypisujemy komunikat i wypisujemy menu ponownie
		li $v0, 4
		la $a0, msg_bledna_wartosc
		syscall
		j menu
		
		read:
			# wypisz wartosc
			li $v0, 1
			lw $a0, RAM($s2)
            syscall
            
            # zlam linie
            li $v0, 4
			la $a0, msg_nowa_linia
			syscall

			j menu
		
		write:
			# spytaj o liczbe
			li $v0, 4
			la $a0, msg_podaj_liczbe
			syscall
			
			# wczytaj liczbe do t4
			li $v0, 5
			syscall 
			
			# wczytaj liczbe do ramu
			sw $v0, RAM($s2)
		
			j menu
        
	end:
		# zakoncz program
        li $v0, 10
        syscall    
   