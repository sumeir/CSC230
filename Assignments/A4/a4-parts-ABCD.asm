# Skeleton file provided to students in UVic CSC 230, Summer 2021
# Original file copyright Mike Zastre, 2021

.include "a4support.asm"


.globl main

.text 

main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $a0, FILENAME_1
	la $a1, ARRAY_A
	jal read_file_of_ints
	add $s0, $zero, $v0	# Number of integers read into the array from the file
	
	la $a0, ARRAY_A
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part A test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal accumulate_sum
	
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part B test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal accumulate_max
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part C test
	#
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	add $a2, $zero, $s0
	jal reverse_array
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Part D test
	#
	
	la $a0, FILENAME_1
	la $a1, ARRAY_A
	jal read_file_of_ints
	add $s0, $zero, $v0
	
	la $a0, ARRAY_A
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	la $a0, FILENAME_2
	la $a1, ARRAY_B
	jal read_file_of_ints
	
	la $a0, ARRAY_B
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	la $a0, ARRAY_A
	la $a1, ARRAY_B
	la $a2, ARRAY_C
	add $a3, $zero, $s0
	jal pairwise_max
	
	la $a0, ARRAY_C
	add $a1, $zero, $s0
	jal dump_ints_to_console
	
	
	# Get outta here...
	add $v0, $zero, 10
	syscall	
	
	
# Accumulate sum: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the sum of all
# integers from the index back to towards zero in the first
# array. The arrays are of the same size; the size is the third
# parameter.
#
accumulate_sum:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	add $s0, $zero, $a0
	add $s1, $zero, $a1
	add $s2, $zero, $a2
	
	and $t0, $zero, $zero	# $t0 : current int in first array
	and $t6, $zero, $zero	# $t6 : previous accumulated sum
	and $t7, $zero, $zero	# $t7 : current accumulated sum
	
loop_accumulate_sum:
	beq $s2, $zero, exit_accumulate_sum
	
	lw $t0, 0($s0)
	add $t7, $t0, $t6
	sw $t7, 0($s1)
	
	add $t6, $zero, $t7
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, -1
	
	b loop_accumulate_sum

exit_accumulate_sum:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


# Accumulate max: Accepts two integer arrays where the value to be
# stored at each each index in the *second* array is the maximum
# of all integers from the index back to towards zero in the first
# array. The arrays are of the same size;  the size is the third
# parameter.
#
accumulate_max:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	add $s0, $zero, $a0
	add $s1, $zero, $a1
	add $s2, $zero, $a2
	
	and $t0, $zero, $zero	# $t0 : current int in first array
	lw $t7, 0($s0)		# $t7 : accumulated max (initiialized to first int in the array)
	
loop_accumulate_max:
	beq $s2, $zero, exit_accumulate_max
	
	lw $t0, 0($s0)
	bgt $t0, $t7, found_new_max_accumulate_max
	
	sw $t7, 0($s1)
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, -1
	
	b loop_accumulate_max

found_new_max_accumulate_max:
	add $t7, $zero, $t0
	b loop_accumulate_max
	
exit_accumulate_max:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

	
# Reverse: Accepts an integer array, and produces a new
# one in which the elements are copied in reverse order into
# a second array.  The arrays are of the same size; 
# the size is the third parameter.
#
reverse_array:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	add $s1, $zero, $a1
	add $s2, $zero, $a2
	
	mul $t7, $s2, 4
	addi $t7, $t7, -4	# $t7 : offset for current int in first array (initialized to offset for last int) 
	add $s0, $a0, $t7
	
	and $t0, $zero, $zero	# $t0 : current int in first array


loop_reverse_array:
	beq $s2, $zero, exit_reverse_array
	
	lw $t0, 0($s0)
	sw $t0, 0($s1)
	
	addi $s0, $s0, -4
	addi $s1, $s1, 4
	addi $s2, $s2, -1
	
	b loop_reverse_array
	
exit_reverse_array:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
	
# Reverse: Accepts three integer arrays, with the maximum
# element at each index of the first two arrays is stored
# at that same index in the third array. The arrays are 
# of the same size; the size is the fourth parameter.
#	
pairwise_max:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	add $s0, $zero, $a0
	add $s1, $zero, $a1
	add $s2, $zero, $a2
	add $s3, $zero, $a3
	
	and $t0, $zero, $zero
	and $t1, $zero, $zero
	and $t6, $zero, $zero
	and $t7, $zero, $zero
	
loop_pairwise_max:
	beq $s3, $zero, exit_pairwise_max
	
	lw $t0, 0($s0)
	lw $t1, 0($s1)
	
	sub $t7, $t1, $t0
	add $t6, $zero, $t0
	bgezal $t7, second_array_cur_is_max_pairwise_max
	sw $t6, 0($s2)
	
	addi $s0, $s0, 4
	addi $s1, $s1, 4
	addi $s2, $s2, 4
	addi $s3, $s3, -1
	b loop_pairwise_max

second_array_cur_is_max_pairwise_max:
	add $t6, $zero, $t1
	jr $ra

exit_pairwise_max:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
	

.data

.eqv	MAX_ARRAY_SIZE 1024

.align 2

ARRAY_A:	.space MAX_ARRAY_SIZE
ARRAY_B:	.space MAX_ARRAY_SIZE
ARRAY_C:	.space MAX_ARRAY_SIZE

FILENAME_1:	.asciiz "integers-10-6.bin"
FILENAME_2:	.asciiz "integers-10-21.bin"


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# In this region you can add more arrays and more
# file-name strings. Make sure you use ".align 2" before
# a line for a .space directive.


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
