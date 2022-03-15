.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $a0, $zero, 0x2b
	jal count_up_with_display
	jal display_dashes
	
finish:
	addi $v0, $zero, 10
	syscall


# $a0: Maximum counter value

count_up_with_display:
	jr $ra


# $a0: hex digit to be displayed
# $a1: 0 == right display; 1 == left display

display_hex_digit:
	jr $ra
	
	
delay_400_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 400
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	

display_dashes:
	jr $ra
	
