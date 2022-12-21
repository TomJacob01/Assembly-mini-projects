# check if user provided string is palindrome

.data

userInput: .space 64
stringAsArray: .space 256

welcomeMsg: .asciiz "Enter a string: "
calcLengthMsg: .asciiz "Calculated length: "
newline: .asciiz "\n"
yes: .asciiz "The input is a palindrome!"
no: .asciiz "The input is not a palindrome!"
notEqualMsg: .asciiz "Outputs for loop and recursive versions are not equal"

.text

main:

	li $v0, 4
	la $a0, welcomeMsg
	syscall
	la $a0, userInput
	li $a1, 64
	li $v0, 8
	syscall

	li $v0, 4
	la $a0, userInput
	syscall
	
	# convert the string to array format
	la $a1, stringAsArray
	jal string_to_array
	
	addi $a0, $a1, 0
	
	# calculate string length
	jal get_length
	addi $a1, $v0, 0
	
	li $v0, 4
	la $a0, calcLengthMsg
	syscall
	
	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	la $a0, stringAsArray
	
	# Function call arguments are caller saved
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	# check if palindrome with loop
	jal is_pali_loop
	
	# Restore function call arguments
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
	addi $s0, $v0, 0
	
	# check if palindrome with recursive calls
	jal is_pali_recursive
	bne $v0, $s0, not_equal
	
	beq $v0, 0, not_palindrome

	li $v0, 4
	la $a0, yes
	syscall
	j end_program

	not_palindrome:
		li $v0, 4
		la $a0, no
		syscall
		j end_program
	
	not_equal:
		li $v0, 4
		la $a0, notEqualMsg
		syscall
		
	end_program:
	li $v0, 10
	syscall
	
string_to_array:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	addi $t2, $a0, 64

	
	to_arr_loop:
		lb $t4, ($t0)
		sw $t4, ($t1)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4
	
		bne $t0, $t2, to_arr_loop
		
	jr $ra


#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################
	
get_length:
	lb $t0, newline
	add $v0 ,$zero, $zero
	loop:
	lw $t1 0($a0)
	# if equal we can finish
	beq $t1, $t0, end
	# adding all the bits in the word
	addi $v0, $v0, 32
	# moving to the next char
	addi $a0 ,$a0 ,4
	j loop
	end:
	jr $ra
	
	
is_pali_loop:
	# setting $t0 to be the last word
	srl $t3, $a1, 3
	add $t0, $a0, $t3
	beq $t0 $a0 one_case # empty string
	addi $t0, $t0, -4
	loop2:	
	beq $t0 $a0 one_case
	lw $t1, 0($a0)
	lw $t2, 0($t0)
	bne $t1 ,$t2, zero_case
	# moving to the next char
	addi $a0, $a0, 4
	addi $t0 $t0 -4
	slt $t3, $a0, $t0
	beq $t3, $zero, one_case
	j loop2
	
	zero_case:	
	addi $v0, $zero, 0
	jr $ra		
	one_case:
	addi $v0, $zero, 1
	jr $ra
	
is_pali_recursive:
	# setting up the recursion 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	# $t0 <- right pointer
	srl $t3, $a1, 3
	add $t0, $a0, $t3
	# Checking base cases
	beq $t0 $a0 one_case # empty string
	addi $t0, $t0, -4
	beq $t0 $a0 one_case # palindrom of size 1
	# checking the edges of the word
	lw $t1, 0($a0)
	lw $t2, 0($t0)
	bne $t1 ,$t2, zero_case
	# setting up for next stage of recursion
	addi $a0, $a0, 4
	addi $a1, $a1, -64
	jal is_pali_recursive
	j restore
	
	
	restore:
	lw $ra 0($sp)
	addi $sp $sp 4
	jr $ra
	
	
	

