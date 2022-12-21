.data

inputMsg: .asciiz "Enter a number: "
msg: .asciiz "Calculating F(n) for n = "
fibNum: .asciiz "\nF(n) is: "
.text

main:

	li $v0, 4
	la $a0, inputMsg
	syscall

	# take input from user
	li $v0, 5
	syscall
	addi $a0, $v0, 0
	
	jal print_and_run
	
	# exit
	li $v0, 10
	syscall

print_and_run:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	add $t0, $a0, $0 

	# print message
	li $v0, 4
	la $a0, msg
	syscall

	# take input and print to screen
	add $a0, $t0, $0
	li $v0, 1
	syscall

	jal fib

	addi $a1, $v0, 0
	li $v0, 4
	la $a0, fibNum
	syscall

	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################	
	
fib: # variables modified: $a0, $t0, $v0
	# Compute and return fibonacci number
	beq $a0, $zero, zero_case    #if n=0 return 0
	beq $a0,1,one_case   #if n=1 return 1

	#Calling fib(n-1)
	sub $sp,$sp,4   #storing return address on stack
	sw $ra,0($sp)

	sub $a0,$a0,1   #n-1
	jal fib     #fib(n-1)
	add $a0,$a0,1

	lw $ra,0($sp)   #restoring return address from stack
	sw $v0,0($sp)
	#Calling fib(n-2)
	sub $sp,$sp,4   #storing return address on stack
	sw $ra,0($sp)

	sub $a0,$a0,2   #n-2
	jal fib     #fib(n-2)
	add $a0,$a0,2

	lw $ra,0($sp)   #restoring return address from stack
	add $sp,$sp,4

	lw $t0,0($sp)   #Pop return value from stack
	add $sp,$sp,4

	add $v0,$v0,$t0 # f(n - 2)+fib(n-1)
	jr $ra # decrement/next in stack

	zero_case:
	addi $v0 ,$zero, 0
	jr $ra
	one_case:
	addi $v0 ,$zero, 1
	jr $ra