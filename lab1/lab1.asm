.data
	# tworzymy zmienne w pamieci
	licz1:       			.word 		0
	licz2:       			.word 		0
	wyn:         			.word 		0
	status:					.word		0 	# 0 - bez bledu, 1 - jest blad
	napisz_status:			.asciiz		"\n Status (0 - brak bledu, 1 - blad): "
  	napis_podaj_mnozna:  	.asciiz 	"Podaj mnozna: "
    napis_podaj_mnoznik: 	.asciiz 	"Podaj mnoznik: "
    napis_wynik:     		.asciiz 	"Wynik jest rowny "
    napis_za_duze: 			.asciiz 	"Za duze liczby"

.text
	# komunikacja z uzytkownikiem
	
	# wypisujemy komunikat "Podaj mnozna: " 
    li $v0, 4					# ustawiamy tryb wypisywania
    la $a0, napis_podaj_mnozna	# wypisujemy wiadomosc do uzytkownika
    syscall						# wywolanie systemowe

	# pobieramy liczbe z klawiatury i zapisujemy w $t0
    li $v0, 5		# ustawiamy tryb wprowadzania tak by uzytkownik mogl podac liczbe
    syscall			# wywolanie systemowe
    move $t0, $v0	# wrzucam mnozna do rejestru t0
	sw $t0, licz1	# umieszczamy wynik w pamieci (w sumie bez powodu ale tak bylo w polecniu ktore zakladalo ze nie bedziemy wczytywac z klawiatury)

	# wypisujemy komunikat "Podaj mnoznik: "
	li $v0, 4						# wypisz zapytanie
    la $a0, napis_podaj_mnoznik		# zapytanie o mnoznik
    syscall							# wywolanie systemowe
     
    # pobieramy liczbe z klawiatury i zapisuje w $t1
    li $v0, 5			# wprowadz mnoznik
    syscall				# wywolanie systemowe
    move $t1, $v0		# przenosze mnoznik do rejestru t1 
    sw $t1, licz2		# umieszczamy wynik w pamieci (w sumie bez powodu ale tak bylo w polecniu ktore zakladalo ze nie bedziemy wczytywac z klawiatury)

      
    # Legenda
    # $t0 - mnozna 
    # $t1 - mnoznik
    # $t2 - wynik
    # $t4 - ostatni bit
    # $t5 - liczba 1 przesunieta by sprawdzic czy nie jest za duza
    # $t6 - liczba 2 przesunieta by sprawdzic czy nie jest za duza
     
    # petla ktora bedzie wykonywac sie tak dluga jak mnozna jest rozna od 0
    loop:
    	beqz $t0, endloop 	# zakoncz wykonywanie jesli mnozna jest rowna zero 
     	
     	and $t4, $t1, 1		# zapisujemy do $t4 ostatni bit za pomoca maski
		beqz $t4, pominiecie		# gdy bit jest rowny zero nie dodajemy mnoznika
     	
     	# sprawdzamy czy jak dodamy to nie bedzie wieksza nic 32 bity
     	srl $t5, $t0, 1 	# dzielimy liczbe na 2 by sprawdzic czy nie bedzie za duza po dodaniu
     	srl $t6, $t2, 1 	# dzielimy liczbe na 2 by sprawdzic czy nie bedzie za duza po dodaniu
     	addu $t5, $t5, $t6 	# dodajemy pomniejszone wersje liczby
     	bgt $t5, 536870911, za_duza	# jesli jest za duza to przeskakujemy by wypisac blad
     	
     	add $t2, $t2, $t0	# dodaj mnozna do wyniku
     
 	pominiecie:
     	sll $t0, $t0, 1	# przesuwam w lewo mnozna, by zachowac sie jak przy mnozeniu na kartce
     	srl $t1, $t1, 1	# przesuwam w prawo mnoznik by otrzymac pojedyncza cyfre
     	
  	j loop # zapetlenie
    endloop:
     
    sw $t2, wyn # umieszczamy wynik w pamieci tak jak w poleceniu
    
    # wypisujemy komunikat "Wynik jest rowny "     
	li $v0, 4			# ustawiamy tryb wypisywania
    la $a0, napis_wynik	# wypisujemy wiadomosc do uzytkownika
    syscall				# wywolanie systemowe
     
    # wypisujemy sam winik
    li $v0, 1		# ustawiamy tryb wypisywania
    lw $a0, wyn		# wypisujemy liczbe uzytkownika
    syscall			# wywolanie systemowe
    j koniec		# przeskakujemy do etykiety by zakonczyc program         
             
	# sekcja wypisujaca ze liczba jest za duza
	za_duza:
		li $t7, 1 
		sw $t7, status
		li $v0, 4 				# ustawiamy tryb wypisywania
		la $a0, napis_za_duze	# wypisujemy wiadomosc do uzytkownika
		syscall 				# wywolanie systemowe
	
	koniec:
	
		# zlamianie lini i wypisanie etykiety
		li $v0, 4 				# ustawiamy tryb wypisywania
		la $a0, napisz_status	# wypisujemy znak konca lini i etykiete
		syscall 
	
		# wypisanie statusu
    	li $v0, 1		# ustawienie bitu na wypisani§e liczby
    	lw $a0, status	# podanie argumentu by wypisac status 0 - bez bledu, 1 - blad
    	syscall			# wywolanie systemowe
    
		li $v0, 10	# nalezycie konczymy program
		syscall		# wywolanie systemowe
	