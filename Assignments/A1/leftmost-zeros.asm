# UVic CSC 230, Summer 2021
# Assignment #1, part A

# Student name: Sumeir Khinda 
# Student number: V00933760

# Determine the number of left-most zeros in register $8's value
# Store this number in register $15


.text

start:
	lw $8, testcase4  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# $15 : final result	
	and $15, $0, $0
	
	# $9 : result of bitwise AND	
	and $9, $0, $0
	
	# $10 : 0x80000000	
	ori $10, $0, 0x80000000
	
	# $11 : 0x00000001	
	ori $11, $0, 1

loop:
	and $9, $8, $10
	beq $9, $10, exit
	add $15, $15, $11
	sll $8, $8, 1
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

testcase1:
	.word	0x00200020    # left-most zero bits is 10 

testcase2:
	.word 	0xfacefade    # left-most zero bits is 0
	
testcase3:
	.word  0x01020304     # left-most zero bits is 7
	
testcase4:
	.word  0x0000000c    # left-most zero bits is 28
	
testcase5:
	.word  0x7000000b     # left-most zero bits is 1

