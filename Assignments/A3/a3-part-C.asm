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
	
	.globl main
	.text	
	
	.eqv DIAMOND_SIZE 7
	
main:
	addi $a0, $zero, 5
	addi $a1, $zero, 5
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_diamond
	
	addi $a0, $zero, 12
	addi $a1, $zero, 9
	addi $a2, $zero, 0x0000ff00
	jal draw_bitmap_diamond
	
	addi $a0, $zero, 10
	addi $a1, $zero, 2
	addi $a2, $zero, 0x00ffffff
	jal draw_bitmap_diamond
	
	addi $a0, $zero, 2
	addi $a1, $zero, 14
	addi $a2, $zero, 0x000000ff
	jal draw_bitmap_diamond
	
	addi $a0, $zero, 7
	addi $a1, $zero, 5
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_diamond

	addi $v0, $zero, 10
	syscall
	

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

# Draws a 7x7 pixel diamond in the "Bitmap Display" tool
#
# $a0: row of diamond's midpoint
# $a1: column of diamond's midpoint
# $a2: colour of diamond
#
# The diamond will be seven pixels high, seven pixels wide
# (i.e. what is indicated by DIAMOND_SIZE).
#

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

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
