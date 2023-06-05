.data
	
	text1:	.asciiz	"text1\n"
	text2:	.asciiz	"text2\n"
	text3:	.asciiz	"text3\n"

.text

	main:
		li $v0, 4
		la $a0, text1
		syscall
		
		jal func1
		
		li $v0, 10
	 	syscall 
		

	func1:
		
		# push $ra to stack
		# stack in mips is decreasing
		sub $sp, $sp, 4
		sw $ra, ($sp)
	
		li $v0, 4
		la $a0, text2
		syscall
		
		jal func2
		
		# pop from stack
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		# back from function
		jr $ra
	

	func2:
		
		sub $sp, $sp, 4
		sw $ra, ($sp)
		
		li $v0, 4
		la $a0, text3
		syscall
		
		lw $ra, ($sp)
		addi $sp, $sp, 4
		
		jr $ra
	
	