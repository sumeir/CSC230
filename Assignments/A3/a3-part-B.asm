	.globl main

	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	.eqv  LETTER_a 97
	.eqv  LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $t0, 0xffff0000	# $t0 : address for MMIO Simulator's Receiver Control register
	lb $t1, 0($t0)		# $t1 : value of MMIO Simulator's Receiver Control register
	ori $t1, $t1, 0x02	# set bit 1 to enable Receiver keyboard interrupts
	sb $t1, 0($t0)
# the above instructions only need to be executed once. hence, i'm using 
# KEYBOARD_EVENT_PENDING to drive the check_for_event loop, not main
	
	
check_for_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $s1, $zero, check_for_event
	
# the instructions that follow will be executed if there is an event (after the keypress is saved into memory)

	lw $t2, KEYBOARD_EVENT
	and $t3, $zero, $zero		# $t3 will be used for space loop flow control
	la $t4, KEYBOARD_COUNTS
	beq $t2, LETTER_space, is_space
	b check_if_lowercase
	
is_space:
	beq $t3, 26, print_newline
	
	lb $a0, 0($t4)
	addi $v0, $zero, 1
	syscall
	
	la $a0, SPACE
	add $v0, $zero, 4
	syscall
	
	add $t4, $t4, 1
	add $t3, $t3, 1
	b is_space
	
print_newline:
	la $a0, NEWLINE
	add $v0, $zero, 4
	syscall
	b done
	
check_if_lowercase:
	blt $t2, 97, done		# not lowercase, ignore
	bgt $t2, 122, done		# not lowercase, ignore
	b is_lowercase
	
is_lowercase:
	sub $t5, $t2, LETTER_a		# $t5 : memory offset for the lowercase letter pressed
	add $t4, $t4, $t5		# $t4 : add the offset to the memory address
	lb $t5, 0($t4)			# load the current count for the keypress
	
	add $t5, $t5, 1			# increment the count
	sb $t5, 0($t4)			# store it back into the memory location
	b done
	
done:
	sw $zero, KEYBOARD_EVENT_PENDING
	b check_for_event
	
	

	.kdata

	.ktext 0x80000180
kernel_entry:
	mfc0 $k0, $13	# copy cause register value to $k0
	andi $k1, $k0, 0x7c	# mask out bits 2 to 6 (ExcCode) into $k1
	srl  $k1, $k1, 2	
	beq $zero, $k1, is_interrupt # if ExcCode is 0, it's an interrupt
	eret	# otherwise return to .text code (not handling other exceptions/traps)

is_interrupt:
	andi $k1, $k0, 0x0100	# $k1 : bit 8 of cause register
	bne $k1, $zero, is_keyboard_interrupt	# if bit 8 set, then we have a keyboard interrupt.
	eret	# otherwise return to .text code (not handling other interrupts)
	
is_keyboard_interrupt:
	la $k0, 0xffff0004 # $k0 : address of Receiver Data register
	lw $k1, 0($k0)	# $k1 : ASCII value of the key pressed
	sw $k1, KEYBOARD_EVENT # store the ASCII value in KEYBOARD_EVENT
	addi $k0, $zero, 1 # $k0 : 1
	sw $k0, KEYBOARD_EVENT_PENDING 
	b exit_kernel
	
exit_kernel:
	eret

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE	
