# UVic CSC 230, Summer 2021
# Assignment #1, part C

# Student name: Sumeir Khinda 
# Student number: V00933760

# Using the binary multiply (i.e., repeated shfits + add) technique,
# multiply value in $8 with value in $9. The initial values in $8
# and $9 will always be less than 0x7FFF (i.e., only right-most 15
# bits are used, such that result will always fit into 32 bits and
# not otherwise cause an arithmetic overflow).
#
# Store the result of the multiply in $15.


.text

start:
	lw $8, testcase2_a  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	lw $9, testcase2_b  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

    # $15 : final result
    and $15, $0, $0
    
    # $10 : copy of the multiplier
    or $10, $0, $9
    
    # $11 : 0x00000001
    ori $11, $0, 0x00000001
    
    # $12 : result of ANDing the multiplier with the mask
    and $12, $0, $0
    
    # $13 : counter
    and $13, $0, $0
    
    # $14 : result of shifting multiplicand
    and $14, $0, $0


loop:
	beq $10, $0, exit
	and $12, $10, $11
	srl $10, $10, 1
	beq $12, $11, loop2
	add $13, $13, $11
	b loop
	
loop2:
	sllv $14, $8, $13
	add $15, $15, $14
	add $13, $13, $11
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

# testcase1: Result is 0x15
testcase1_a:
	.word	0x00000003
testcase1_b:
	.word   0x00000007
	    

# testcase2: Result is 0x00006c98
testcase2_a:
	.word	0x000000c8   # decimal 200
testcase2_b:
	.word   0x0000008b   # decimal 139


# testcase3: Result is 0x3fff0001
testcase3_a:
	.word	0x00007fff   # decimal 32767
testcase3_b:
	.word   0x00007fff
	
