
	.data
	.eqv  BITMAP_DISPLAY 0x10010000
	.eqv  PIXEL_WHITE    0x00ffffff
	
	.text
	
	li $s1, PIXEL_WHITE
	
	# Draw a row of white pixels on the bitmap display tool
	# Use row 4. You will need to write a loop!
	
	and $t0, $zero, $zero
	la $s0, BITMAP_DISPLAY
	addi $s0, $s0, 256
	
	row4_loop:
	beq $t0, 16, column3_initialize
	sw $s1, 0($s0)
	addi $s0, $s0, 4
	addi $t0, $t0, 1
	b row4_loop

	# Draw a column of white pixels on the bitmap display tool
	# Use column 3. You will need to write a loop!
	
	column3_initialize:
	and $t0, $zero, $zero
	la $s0, BITMAP_DISPLAY
	addi $s0, $s0, 12
	
	column3_loop:
	beq $t0, 16, exit
	sw $s1, 0($s0)
	addi $s0, $s0, 64
	addi $t0, $t0, 1
	b column3_loop
	
	exit:
	addi $v0, $zero, 10
	syscall
