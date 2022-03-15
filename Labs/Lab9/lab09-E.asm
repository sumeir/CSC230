
	.data 0x10010000 	# Normally the default, but forcing it anyway as
				# MARS might be misconfigured for some reason.
	
	.eqv	PIXEL_ON  0x00ffffff
	.eqv	PIXEL_OFF 0x00000000
	.eqv	ROWS      16
	
BITMAP_DISPLAY:
	.space 1024		# Ensuring all further .data values are outside of Bitmap Tool words

PATTERN:
	.word	0x0000
		0x07f8
		0x0ff8
		0x0f38
		0x1e38
		0x1c38
		0x1e38
		0x0ff8
		0x0ff8
		0x03f8
		0x0738
		0x0738
		0x0e38
		0x0e38
		0x1e38
		0x0000
	
	.text
	
	la $s0, BITMAP_DISPLAY
	la $s1, PATTERN
	
	addi $s2, $zero, ROWS
LOOP_ROW:


	addi $s2, $s2, -1
	bne $s2, $zero, LOOP_ROW
	
EXIT:
	addi $v0, $zero, 10
	syscall