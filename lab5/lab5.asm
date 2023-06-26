.data
    coefs:        .float   6.7, 5, 4, 3
    degree:       .word    0
    msg:          .asciiz  "Podaj liczbe x: "
    msg_new_line: .asciiz  "\n"
    
.text

main:
    # wypisujemy wiadomosc msg
    li $v0, 4          
    la $a0, msg      
    syscall
    
    # pobieramy argument wielomianu
    li $v0, 6    
    syscall
    
    # jesli mialbys zakonczyc program to branch tutaj
    
    # ladujemy do rejestrow argumentow adres tablicy coefs oraz wartosc degree
	la $a0, coefs       
	lw $a1, degree     
	
	# liczbe zmiennoprzecinkowa ladujemy do specjalnego rejestru argumentu
	mov.d $f12, $f0
	
	# skaczemy do funkcji evel_poly 
    j eval_poly
    
eval_poly:

    # wczytujemy argumenty
    # t0 - coefs
    # t1 - degree
    # f6 - x
    move $t0, $a0  
	move $t1, $a1  
	mov.d $f6, $f12
	cvt.d.s $f6, $f6   # konwersujemy wartosc float na double
	
	# zapisujemy do $t0 adres ostatniego elementu
	move $t2, $t1
	sll $t2, $t2, 2    # mnozymy razy 4
	add $t0, $t0, $t2
	
	# double result = coefs[degree]
	l.s $f2, 0($t0)
	cvt.d.s $f2, $f2    # konwersja float na double dla result
	subi $t1, $t1, 1    # dekrementacja degree
	# dekrementacja wskaznika bedzie w petli
	
	# t0 - coefs pointer
	# t1 - degree
    # f2 - result
    # f6 - x
    
    # for (int i=degree-1; i >= 0; i--)
    
    loop:
       blt $t1, $zero, endloop # warunek wyjsca z petli
       subi $t0, $t0, 4  # dekrementacja adresu
       
       # wczytujemy wartosc coefs[i] tymczasowo do $f8
       l.s $f8, ($t0)
	   cvt.d.s $f8, $f8    # konwersja float na double
       
       # result = result * x
       mul.d $f2, $f2, $f6
       
       # result = result + coefs[i]
       add.d $f2, $f2, $f8
       
       subi $t1, $t1, 1  # dekrementacja iteratora
       j loop
    
    endloop:
        # wypisujemy wynik
        li $v0, 3           
        mov.d $f12, $f2  
        syscall   
        
        li $v0, 4
        la $a0, msg_new_line
        syscall

    j main
    
end:
    li $v0, 10
    syscall
