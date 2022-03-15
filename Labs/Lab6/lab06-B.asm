.text
	addi $s0, $zero, 5
loop:
	beq $s0, $zero, finish
	
	jal display_dashes
	jal delay_400_msec

	jal display_blanks
	jal delay_400_msec
	
	jal display_digits_21
	jal delay_400_msec
	
	jal display_blanks
	jal delay_400_msec
	
	addi $s0, $s0, -1
	
	beq $zero, $zero, loop
	
finish:
	addi $v0, $zero, 10
	syscall


# Use only $s0 - $s7 for computation in
# this procedure.

display_dashes:	
	jr $ra
	
	
# Use only $s0 - $s7 for computation in
# this procedure.

display_blanks:
	jr $ra

		
# Use only $s0 - $s7 for computation in
# this procedure.
		
display_digits_21:
	jr $ra
	
# Nothing needs to be done for the
# delay_400_msec procedure.
	
delay_400_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 400
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
