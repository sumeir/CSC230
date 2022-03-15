	.data

S1:	.asciiz "In what year were you born? "
S2:	.asciiz "What year is it now? "
S3:	.asciiz "You will turn "
S4: 	.asciiz " years old this year.\n"
SPACE:	.asciiz " "
NL:	.asciiz "\n"
	
	.text
main:

	la $a0, S1
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5 # read integer (birth year)
	syscall
	# birth year now stored in $v0
	add $s0, $v0, $zero # copy birth year to $s0
	
	la $a0, S2
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 5 # read integer (current year)
	syscall
	# current year now stored in $v0
	add $s1, $zero, $v0 # copy current year to $s1
	
	# age = current year - birth year
	sub $s2, $s1, $s0
	# $s2 : age
	
	la $a0, S3
	addi $v0, $zero, 4
	syscall	
	
	add $a0, $zero, $s2 # add age to $a0
	addi $v0, $zero, 1
	syscall # print age
	
	la $a0, S4
	addi $v0, $zero, 4
	syscall	
				
	addi $v0, $zero, 10
	syscall
