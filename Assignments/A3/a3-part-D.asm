# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
DIAMOND_ROW:
	.word	9
DIAMOND_COLUMN:
	.word	9
	
DIAMOND_COLOUR_1:
	.word 0x00db93c0
	
	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_s 115
	.eqv LETTER_space 32
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $t8, 0xffff0000	
	lb $t9, 0($t8)		
	ori $t9, $t9, 0x02	
	sb $t9, 0($t8)
	
	and $t7, $zero, $zero	# $t7 : set if color toggled to student color, 0 otherwise
	ori $t6, $t6, 1		# $t6 : 1
	
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	lw $a2, DIAMOND_COLOUR_1
	jal draw_bitmap_diamond

check_for_event:
	la $t8, KEYBOARD_EVENT_PENDING
	lw $t9, 0($t8)
	beq $t9, $zero, check_for_event
	
# the code that follows will be executed after a keypress is recorded and the interrupt handled
	
	lw $t2, KEYBOARD_EVENT
	beq $t2, LETTER_space, is_space
	beq $t2, LETTER_a, is_a
	beq $t2, LETTER_d, is_d
	beq $t2, LETTER_w, is_w
	beq $t2, LETTER_s, is_s
	b done

is_space:
	beq $t7, $t6, toggle_to_default_color
	beqz $t7, toggle_to_student_color

is_a:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	add $a2, $zero, 0x00000000
	jal draw_bitmap_diamond
	
	lw $t3, DIAMOND_COLUMN
	subi $t3, $t3, 1
	sw $t3, DIAMOND_COLUMN
	b check_color
	

is_d:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_diamond
	
	lw $t3, DIAMOND_COLUMN
	addi $t3, $t3, 1
	sw $t3, DIAMOND_COLUMN
	b check_color

is_w:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_diamond
	
	lw $t3, DIAMOND_ROW
	subi $t3, $t3, 1
	sw $t3, DIAMOND_ROW
	b check_color

is_s:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_diamond
	
	lw $t3, DIAMOND_ROW
	addi $t3, $t3, 1
	sw $t3, DIAMOND_ROW
	b check_color

toggle_to_default_color:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	lw $a2, DIAMOND_COLOUR_1
	jal draw_bitmap_diamond
	and $t7, $zero, $zero	# unset $t7
	b done
	
	
toggle_to_student_color:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	addi $a2, $zero, 0x00933760
	jal draw_bitmap_diamond
	and $t7, $t6, $t6	# set $t7
	b done
	
check_color:
	beq $t7, $t6, redraw_in_student_color
	b redraw_in_default_color
	
redraw_in_student_color:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	addi $a2, $zero, 0x00933760
	jal draw_bitmap_diamond
	b done
	
redraw_in_default_color:
	lw $a0, DIAMOND_ROW
	lw $a1, DIAMOND_COLUMN
	lw $a2, DIAMOND_COLOUR_1
	jal draw_bitmap_diamond
	b done
	
	
done:
	sw $zero, KEYBOARD_EVENT_PENDING
	b check_for_event
 
.data
    .eqv DIAMOND_COLOUR_BLACK 0x00000000
    
.text

draw_bitmap_diamond:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	# copy $a0, $a1, $a2 values into $s0, $s1, $s2
	add $s0, $zero, $a0
	add $s1, $zero, $a1
	add $s2, $zero, $a2

	# draw diamond, starting left-right and top-bottom
	
	# column : (center-3) , row : (center)
	add $a0, $s0, $zero
	addi $a1, $s1, -3
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center-2) , row : (center-1) to  (center+1) 
	
	addi $a0, $s0, -1
	addi $a1, $s1, -2
	add $a2, $s2, $zero
	jal set_pixel
	
	add $a0, $s0, $zero
	addi $a1, $s1, -2
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 1
	addi $a1, $s1, -2
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center-1) , row : (center-2) to  (center+2)
	
	addi $a0, $s0, -2
	addi $a1, $s1, -1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, -1
	addi $a1, $s1, -1
	add $a2, $s2, $zero
	jal set_pixel
	
	add $a0, $s0, $zero
	addi $a1, $s1, -1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 1
	addi $a1, $s1, -1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 2
	addi $a1, $s1, -1
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center) , row : (center-3) to  (center+3)
	
	addi $a0, $s0, -3
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, -2
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, -1
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	add $a0, $s0, $zero
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 1
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 2
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 3
	add $a1, $s1, $zero
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center+1) , row : (center-2) to  (center+2)
	
	addi $a0, $s0, -2
	addi $a1, $s1, 1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, -1
	addi $a1, $s1, 1
	add $a2, $s2, $zero
	jal set_pixel
	
	add $a0, $s0, $zero
	addi $a1, $s1, 1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 1
	addi $a1, $s1, 1
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 2
	addi $a1, $s1, 1
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center+2) , row : (center-1) to  (center+1)
	
	addi $a0, $s0, -1
	addi $a1, $s1, 2
	add $a2, $s2, $zero
	jal set_pixel
	
	add $a0, $s0, $zero
	addi $a1, $s1, 2
	add $a2, $s2, $zero
	jal set_pixel
	
	addi $a0, $s0, 1
	addi $a1, $s1, 2
	add $a2, $s2, $zero
	jal set_pixel
	
	# column : (center+3) , row : (center)
	
	add $a0, $s0, $zero
	addi $a1, $s1, 3
	add $a2, $s2, $zero
	jal set_pixel
	
	
exit_draw_bitmap_diamond:
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra


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

.data 

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv DIAMOND_COLOUR_WHITE 0x00FFFFFF
