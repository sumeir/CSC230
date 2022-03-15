.text 
	# $8 : initial value for which we look for trailing zeros
	# $9 : the counter to keeps track of # of trailing zeros (result)
	# $10 :  the result of the AND with the mask
	
	#*------------------------------------------------------------------------------------------------*
	# The program exits the loop when it finds a set bit (1). This is a problem, because if we're 
	# looking for trailing zeroes in the value 0x00000000, there are no set bits, and the program goes 
	# into an infinite loop. 
	# A possible solution is to look at the value when entering the loop and just exit the loop if  
	# the value is 0x00000000. The counter in this case is 0, as initialized before the loop. This is 
	# correct, as there is no set (1) bit in the sequence, hence no trailing zeroes.
	# My solution is shown in the code below, implemented by comparing $8 with $0, and exiting the
	# loop if equal.
	#*------------------------------------------------------------------------------------------------*
	
	ori $8, $0, 0x00000000   # same as "addi $8, $0, 0xc800"
	
	ori $9, $0, 0		# counter
loop:
	beq $8, $0, exit # (sol): exit the loop if the value is 0
	andi $10, $8, 1
	bne $10, $0, exit
	addi $9, $9, 1
	srl $8, $8, 1
	b loop
	
exit:
	nop			# answer is in $9
	
	
