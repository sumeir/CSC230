.data

bob:
	.word 212
	
connie:
	.word 40122
	
.text
	# Store the sum of integer
	# at 'bob' and integer at
	# 'connie' into register
	# $12 -- and without using
	# bob or connie directly
	# in a 'lw' instruction
	# (ie must use register and
	# an offset of zero).
	
	la $14, 0x10010000 # address of bob
	la $15, 4($14) # address of connie
	
	lw $8, ($14) # bob
	lw $9, ($15) # connie
	add $15, $8, $9 # result
	
	