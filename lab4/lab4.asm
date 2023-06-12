# =============================================
.eqv STACK_SIZE 2048

# =============================================
.data 
    # obszar na zapamietanie adresu stosu systemowego
    sys_stack_addr: .word 0
	
    # deklaracja własnego obszaru stosu
    stack: .space STACK_SIZE
    
    global_array: .word 1,2,3,4,5,6,7,8,9,10
    global_array_size: .word 10

# =============================================
.text
    # Czynności inicjalizacyjne
    sw $sp, sys_stack_addr      # zachowanie adresu stosu systemowego 
    la $sp, stack+STACK_SIZE    # zainicjowanie obszaru stosu


main:
	# Rezerwujemy miejsce na stosie
    sub $sp, $sp, 4             # utworzenie na stosie zmiennej s - int s;
    sub $sp, $sp, 8             # rezerwacja miejsca na stosie na pierwszy argument funkcji "global_array"
    sub $sp, $sp, 8             # rezerwacja miejsca na stosie na drugi argument funkcji "10"
    
    # Wczytujemy wartosci napierw do rejestru poznij na umieszczamy na stosie 
    la $t0, global_array        
    sw $t0, 4($sp)              # umieszczamy na stosie pierwszy argument fukncji "global_array"		       
    lw $t0, global_array_size	
    sw $t0, 0($sp)              # umieszczamy na stosie drugi argument funkcji "10"
     		        
    jal sum				        # "uruchamiamy" podprogram, ktorym jest funkcja sum
	
    lw $t0, ($sp)		        # pobieramy ze stosu wartosc ktora zwrocila funkcja
    sw $t1, 12($sp)		        # zapisujemy "s" do stosu
    add $sp, $sp, 12	        # usuniecie zwroconej wartosci i argumentow ze stosu
    
    # wypisanie wartosci
    li $v0, 1		        
    lw $a0, ($sp)                
    syscall
    
    add $sp, $sp, 4		        # usuwamy zmienna lokalna ze stosu

    # koniec podprogramu main
    lw $sp, sys_stack_addr          # odtworzenie wskaznika stosu systemowego
    li $v0, 10
    syscall

sum:
    sub $sp, $sp, 8 	# rezerawacja miejsca na stosie na wartosc zwracana i adres powrotu
    sw $ra, ($sp) 		# zapisujemy adres powrotu na stos
    sub $sp, $sp, 8		# rezerwacja miejsca na stosie na zmienne lokalne "s" oraz "i"
    sw $0, ($sp)        # zapisujemy wartosc s jako 0
    lw $t0, 16($sp)		# pobieramy rozmiar tablicy (argument drugi)
    subi $t0, $t0, 1	# zmiejszamy rozmiar tablicy o 1 tak by uzyskac i = array_size - 1;
    sw $t0, 4($sp)		# zapisujemy zmienna i
	
    # Legenda stosu wzglednem obecnego stack pointera
    # 0($sp) = s
    # 4($sp) = i
    # 8($sp) = $ra
    # 12($sp) = wartosc zwracana
    # 16($sp) = argument drugi - rozmiar tablicy "10"
    # 12($sp) = argument pierwszy - adres tablicy
    
   
    loop:
        lw $t0, 4($sp)          # wczytujemy zamienn i
        blt $t0, $0, endloop 	# jesli i < 0 to konczymy petle
        
        # wyliczamy s = s + array[i];
        # najpierw w $t0 chcemy miec prawidlowe "i"
        mul $t0, $t0, 4		# mnozymy razy 4 bo 1 slowo to bajty	
        lw $t1, 20($sp)		# do $t1 wczytuje address tablicy
        add $t0, $t1, $t0	# zapisujemy do $t0 ostateczny adres
        
        # sumujemy s i zapisujemy do stosu
        lw $t0, ($t0)		# wczytujemy do $t0 wartosc array[i]	
        lw $t1, ($sp)		# wczytujemy do $t1 wartosc sumy "s"
        add $t1, $t1, $t0	# dodajemy je do siebie i umieszczamy w $t1
        sw $t1, ($sp)		# nastepnie zapisujemy $t1 z powrotem na stosie
        
        # dekrementujemy iterator
        lw $t0, 4($sp)		# wczytuje wartosc "i"
        subi $t0, $t0, 1	# odejmujemy 1
        sw $t0, 4($sp)		# zapisujmy z powrotem do stosu
        j loop              # wykonujemy ponowne powtorzenie petli
    
    endloop:
    lw $t0, ($sp)		# wczytujemy wartosc "s" do rejestru $t0
    sw $t0, 12($sp)		# zapisujemy ja jako wartosc ktora zwraca funkcja
    add $sp, $sp, 8		# inkrementujemy wskaznik stosu tak by "usunac" lokalne zmienne
    lw $ra, ($sp)		# wczytujemy adres powrotu
    add $sp, $sp, 4		# usuwamy ze stosu na adres powrotu
    jr $ra			    # wyjscie z funkcji
