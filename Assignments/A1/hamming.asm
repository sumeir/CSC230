# UVic CSC 230, Summer 2021
# Assignment #1, part B

# Student name: Sumeir Khinda 
# Student number: V00933760


.text

start:
	lw $8, testcase3_a  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	lw $9, testcase3_b  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# Algorithm: XOR the last bit of the test cases with each other. If the result is 1 
	# increment the counter. Shift right both the test cases, and repeat. Terminate
	# when both test cases have been shifted to be 0x00000000

	# $15 : final result
	and $15, $0, $0
	
	# $10: result of XOR($12,$13)
	and $10, $0, $0
	
	# $11 : 0x00000001
	ori $11, $0, 0x00000001
	
	# $12: last bit of $8
	and $12, $0, $0
	
	# $13: last bit of $9
	and $13, $0, $0
	
	# $16: result of OR($8,$9)
	and $16, $0, $0
	
loop:
	or $16, $8, $9
	beq $16, $0, exit
	and $12, $8, $11
	and $13, $9, $11
	xor $10, $12, $13
	srl $8, $8, 1
	srl $9, $9, 1
	beq $10, $11, increment
	b loop
	
increment:
	add $15, $15, $11
	b loop
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

# Note: These test cases are not exhaustive. The teaching team
# will use other test cases when evaluating student submissions
# for this part of the assignment.

# testcase1: Hamming distance is 32
testcase1_a:
	.word	0x00000000
testcase1_b:
	.word   0xffffffff
	    

# testcase2: Hamming distance is 0
testcase2_a:
	.word	0xabcd0123
testcase2_b:
	.word   0xabcd0123
	
	
# testcase3: Hamming distance is 16
testcase3_a:
	.word	0xffff0000
testcase3_b:
	.word   0xaaaaaaaa
	
	
# testcase4: Hamming distance is 11
testcase4_a:
	.word	0xcafef00d
testcase4_b:
	.word   0xfacefade
