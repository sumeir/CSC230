.data
result:
	.space 4
.text
	li $8, 12
	li $9, -12
	li $10, 10
	li $11, 200
	
	add $15, $11, $10
	add $14, $8, $9
	sub $13, $8, $9
	add $15, $11, $11
	add $15, $15, $11
	sw $15, result