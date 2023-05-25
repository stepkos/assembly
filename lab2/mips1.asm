.data
    primes: .space 100     # Tablica przechowująca liczby pierwsze
    n:      .word 100      # Górne ograniczenie zakresu
    space: .asciiz " "        # Spacja

.text
.globl main
main:
    # Inicjalizacja tablicy liczb pierwszych
    li $t0, 0               # Indeks tablicy
    li $t1, 2               # Pierwsza liczba do sprawdzenia
    lw $t2, n              # Wczytaj górne ograniczenie zakresu
    la $a0, primes          # Adres tablicy liczb pierwszych

init_loop:
    beq $t1, $t2, exit     # Przejdź do etykiety exit, jeśli liczba jest większa lub równa górnemu ograniczeniu
    sb $zero, ($a0)        # Ustaw wartość 0 na danym indeksie tablicy
    addiu $t1, $t1, 1      # Zwiększ wartość liczby o 1
    addiu $a0, $a0, 1      # Zwiększ indeks tablicy o 1
    j init_loop            # Powtórz pętlę

exit:
    # Wykonaj sito Eratostenesa
    li $t0, 2               # Początkowy indeks tablicy
    lw $t2, n              # Wczytaj górne ograniczenie zakresu
    la $a0, primes          # Adres tablicy liczb pierwszych

sieve_loop:
    beq $t0, $t2, print_primes   # Przejdź do etykiety print_primes, jeśli indeks tablicy jest większy lub równy górnemu ograniczeniu
    lb $t1, ($a0)         # Wczytaj wartość z tablicy

    beqz $t1, sieve_loop   # Powtórz pętlę, jeśli wartość jest równa 0

    li $t3, 2               # Pierwszy wielokrotny liczby
    mul $t3, $t3, $t0       # Pomnóż pierwszy wielokrotny przez indeks
    addiu $t3, $t3, 2     # Dodaj indeks, aby uzyskać prawidłowy wielokrotny

    addu $a1, $zero, $t3    # Przekazanie wielokrotnego jako argumentu do procedury mark_multiples
    jal mark_multiples      # Wywołanie procedury

    addiu $t0, $t0, 1      # Zwiększ indeks tablicy o 1
    addiu $a0, $a0, 1      # Zwiększ indeks tablicy o 1
    j sieve_loop           # Powtórz pętlę

print_primes:
    # Wyświetlanie liczb pierwszych
    li $v0, 4               # Kod systemowego wywołania (print_string)
    la $a0, primes          # Adres tablicy liczb pierwszych

print_loop:
    lb $t1, ($a0)         # Wczytaj wartość z tablicy

    beqz $t1, exit_program  # Przejdź do etykiety exit_program, jeśli wartość jest równa 0

    move $a0, $t1           # Przekazanie wartości jako argumentu do procedury print_int
    li $v0, 1               # Kod systemowego wywołania (print_int)
    syscall                # Wywołanie systemowe

    li $v0, 4               # Kod systemowego wywołania (print_string)
    la $a0, space          # Wypisz spację
    syscall                # Wywołanie systemowe

    addiu $a0, $a0, 1      # Zwiększ indeks tablicy o 1
    j print_loop            # Powtórz pętlę

exit_program:
    li $v0, 10              # Kod systemowego wywołania (exit)
    syscall                # Wywołanie systemowe

mark_multiples:
    # Procedura oznaczająca wielokrotności jako złożone
    li $t4, 0               # Wartość 0 oznacza złożoną
    lw $t5, n              # Wczytaj górne ograniczenie zakresu
    la $a2, primes          # Adres tablicy liczb pierwszych

mark_loop:
    blt $a1, $t5, mark       # Przejdź do etykiety mark, jeśli wielokrotny jest mniejszy niż górne ograniczenie zakresu

    jr $ra                 # Powrót z procedury

mark:
    lw $t6, ($a2)          # Wczytaj wartość z tablicy do tymczasowego rejestru
    addiu $t6, $t6, 0    # Dodaj wartość do rejestru tymczasowego
    sb $t6, ($a2)          # Zapisz wartość w tablicy
    addiu $a1, $a1, 2    # Dodaj indeks, aby uzyskać kolejny wielokrotny
    addiu $a2, $a2, 1      # Zwiększ indeks tablicy o 1
    j mark_loop            # Powtórz pętlę


