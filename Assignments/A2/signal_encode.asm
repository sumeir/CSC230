# Skeleton file provided to students in UVic CSC 230, Summer 2021
# Original file copyright Mike Zastre, 2021
# Sumeir Khinda -- V00933760

.text


main:	


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
    ## Test code that calls procedure for part A
    jal sos_send

    ## signal_flash test for part B
    addi $a0, $zero, 0x24   # dot dot dash dot 0x24
    jal signal_flash

    ## signal_flash test for part B
    addi $a0, $zero, 0x73   # dash dash dash
    jal signal_flash
        
    ## signal_flash test for part B
    addi $a0, $zero, 0x23     # dot dash dot
    jal signal_flash
            
    ## signal_flash test for part B
    addi $a0, $zero, 0x11   # dash
    jal signal_flash  
    
    # signal_message test for part C
    la $a0, test_buffer
    jal signal_message

    # one_alpha_encode test for part D
    # the letter 'p' is properly encoded as 0x64.
    addi $a0, $zero, 'p'
    jal one_alpha_encode  
    
    # one_alpha_encode test for part D
    # the letter 'a' is properly encoded as 0x12
    addi $a0, $zero, 'a'
    jal one_alpha_encode
    
    # one_alpha_encode test for part D
    # the space' is properly encoded as 0xff
    addi $a0, $zero, ' '
    jal one_alpha_encode
    
    # message_into_code test for part E
    # The outcome of the procedure is here
    # immediately used by signal_message
    la $a0, message04
    la $a1, buffer01
    jal message_into_code
    la $a0, buffer01
    jal signal_message
    

get_outta_here:
    # Proper exit from the program.
    addi $v0, $zero, 10
    syscall


	
	
###########
# PROCEDURE
sos_send:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $a0, $zero, 0x03
	jal signal_flash
	addi $a0, $zero, 0x73
	jal signal_flash
	addi $a0, $zero, 0x03
	jal signal_flash
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# PROCEDURE
signal_flash:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp) # $s0 will eventually hold the low nibble of $a0 (length)
	sw $s1, 0($sp) # $s1 will eventually hold the high nibble of $a0 (sequence)
	beq $a0, 0xff, space_between_words
	andi $s0, $a0, 0x0f
	srl $s1, $a0, 4
	andi $s1, $s1, 0x0f
	and $t0, $zero, $zero # $t0: flow control for loop
	ori $t4, $zero, 0x8 # $t4 : 0b1000
	ori $t7, $zero, 4 # $t7 : 4
	ori $t6, $zero, 1 # t6 : 0b0001
flash_loop:
	beq $s0, $t7, loop_length4
	b loop_general

end_signal_flash:
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
loop_general:
	beq $s0, $t0, end_signal_flash
	addi $t0, $t0, 1
	and $t3, $s1, $t6 # $t3 = $s1 AND 0b0001 : the bit being checked for dot/dash
	srl $s1, $s1, 1
	and $t5, $t3, $t6 # $t5 = $t3 AND $t6 : holds result of ANDing the sequence with 0b0001
	beq $t5, $t6, dash # if $t5==$t6 then flash a dash 
	b dot # else, a dot

loop_length4:
	beq $s0, $t0, end_signal_flash
	addi $t0, $t0, 1
	and $t3, $s1, $t4 # $t3 = $s1 AND 0b1000 : the bit being checked for dot/dash
	sll $s1, $s1, 1
	and $t5, $t3, $t4 # $t5 = $t3 AND $t4 : holds result of ANDing the sequence with 0b1000
	beq $t5, $t4, dash # if $t5==$t4 then flash a dash 
	b dot # else, a dot

space_between_words:
	jal seven_segment_off
	jal delay_long
	jal delay_long
	jal delay_long
	b end_signal_flash

dot:
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	b flash_loop

dash:
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	b flash_loop


###########
# PROCEDURE
signal_message:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	add $s0, $a0, $zero # $s0: memory address
	lb $s1, 0($s0) # $s1 : current byte 

loop_signal_message:
	beq $s1, $zero, end_signal_message
	add $a0, $s1, $zero
	jal signal_flash
	add $s0, $s0, 1
	lb $s1, 0($s0)
	b loop_signal_message
	
end_signal_message:
	lw $s1, 0($sp)
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi, $sp, $sp, 12
	jr $ra
	
	
###########
# PROCEDURE
one_alpha_encode:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s7, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)
	sw $s6, 32($sp)
	addi $s7, $zero, ' '
	addi $s3, $zero, '.'
	addi $s4, $zero, '-'
	add $s0, $a0, $zero
	beq $s0, $s7, space_one_alpha_encode
	and $s5, $zero, $zero
	and $s6, $zero, $zero 
	ori $t0 $zero, 0x8 # 0b 1000 0000
	la $s1, codes
	lb $s2, 0($s1)
loop_one_alpha_encode:
	beq $s2, $s0, found_one_alpha_encode
	addi $s1, $s1, 8
	lb $s2, 0($s1)
	b loop_one_alpha_encode

result_one_alpha_encode:
	sll $s6, $s6, 4
	or $v0, $s5, $s6
end_one_alpha_encode:
	lw $s6, 32($sp)
	lw $s5, 28($sp)
	lw $s4, 24($sp)
	lw $s3, 20($sp)
	lw $s7, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 36
	jr $ra

space_one_alpha_encode:
	addi $v0, $zero, 0xff
	b end_one_alpha_encode

found_one_alpha_encode:
	addi $s1, $s1, 1
	lb $s2, 0($s1)
	beq $s2, $zero, result_one_alpha_encode
	beq $s2, $s3, dot_one_alpha_encode
	or $s6, $s6, $t0
	srl $t0, $t0, 1
	add $s5, $s5, 1
	b found_one_alpha_encode

dot_one_alpha_encode:
	srl $t0, $t0, 1
	add $s5, $s5, 1
	b found_one_alpha_encode
	


###########
# PROCEDURE
message_into_code:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	and $s2, $zero, $zero
	b loop_message_into_code

end_message_into_code:
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra

loop_message_into_code:
	lb $s2, 0($s0)
	beq $s2, $zero, end_message_into_code
	add $s0, $s0, 1
	add $a0, $s2, $zero
	jal one_alpha_encode
	add $s3, $v0, $zero
	sb $s3, 0($s1)
	addi $s1, $s1, 1
	b loop_message_into_code


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

#############
# DATA MEMORY
.data
codes:
    .byte 'a', '.', '-', 0, 0, 0, 0, 0
    .byte 'b', '-', '.', '.', '.', 0, 0, 0
    .byte 'c', '-', '.', '-', '.', 0, 0, 0
    .byte 'd', '-', '.', '.', 0, 0, 0, 0
    .byte 'e', '.', 0, 0, 0, 0, 0, 0
    .byte 'f', '.', '.', '-', '.', 0, 0, 0
    .byte 'g', '-', '-', '.', 0, 0, 0, 0
    .byte 'h', '.', '.', '.', '.', 0, 0, 0
    .byte 'i', '.', '.', 0, 0, 0, 0, 0
    .byte 'j', '.', '-', '-', '-', 0, 0, 0
    .byte 'k', '-', '.', '-', 0, 0, 0, 0
    .byte 'l', '.', '-', '.', '.', 0, 0, 0
    .byte 'm', '-', '-', 0, 0, 0, 0, 0
    .byte 'n', '-', '.', 0, 0, 0, 0, 0
    .byte 'o', '-', '-', '-', 0, 0, 0, 0
    .byte 'p', '.', '-', '-', '.', 0, 0, 0
    .byte 'q', '-', '-', '.', '-', 0, 0, 0
    .byte 'r', '.', '-', '.', 0, 0, 0, 0
    .byte 's', '.', '.', '.', 0, 0, 0, 0
    .byte 't', '-', 0, 0, 0, 0, 0, 0
    .byte 'u', '.', '.', '-', 0, 0, 0, 0
    .byte 'v', '.', '.', '.', '-', 0, 0, 0
    .byte 'w', '.', '-', '-', 0, 0, 0, 0
    .byte 'x', '-', '.', '.', '-', 0, 0, 0
    .byte 'y', '-', '.', '-', '-', 0, 0, 0
    .byte 'z', '-', '-', '.', '.', 0, 0, 0
    
message01:  .asciiz "a a a"
message02:  .asciiz "sos"
message03:  .asciiz "thriller"
message04:  .asciiz "billie jean"
message05:  .asciiz "the girl is mine"
message06:  .asciiz "pretty young thing"
message07:  .asciiz "human nature"
message08:  .asciiz "we are the world"
message09:  .asciiz "off the wall"
message10:  .asciiz "i want you back"

buffer01:   .space 128
buffer02:   .space 128
test_buffer:    .byte 0x03 0x73 0x03 0x00    # This is SOS
