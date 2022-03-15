# Skeleton file provided to students in UVic CSC 230, Summer 2021
# Original file copyright Mike Zastre, 2021

.include "a4support.asm"

.data

.eqv	MAX_ARRAY_SIZE 1024

.align 2
ARRAY_1:	.space MAX_ARRAY_SIZE
ARRAY_2:	.space MAX_ARRAY_SIZE
ARRAY_3:	.space MAX_ARRAY_SIZE
ARRAY_4:	.space MAX_ARRAY_SIZE
ARRAY_5:	.space MAX_ARRAY_SIZE
ARRAY_6:	.space MAX_ARRAY_SIZE
ARRAY_7:	.space MAX_ARRAY_SIZE
ARRAY_8:	.space MAX_ARRAY_SIZE

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

FILENAME_1:	.asciiz "integers-10-6.bin"
FILENAME_2:	.asciiz "integers-10-21.bin"

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE



.globl main
.text 
main:

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $a0, FILENAME_1
	la $a1, ARRAY_1
	jal read_file_of_ints
	add $s1, $zero, $v0
	
	la $a0, FILENAME_2
	la $a1, ARRAY_2
	jal read_file_of_ints
	add $s2, $zero, $v0
	
	
	# WRITE YOUR SOLUTION TO THE PART E PROBLEM
	# HERE...
	
	# A3 = accumulate_max(A1)
	la $a0, ARRAY_1
	la $a1, ARRAY_3
	move $a2, $s1
	jal accumulate_max
	
	# A4 = accumulate_max(A2)
	la $a0, ARRAY_2
	la $a1, ARRAY_4
	move $a2, $s1
	jal accumulate_max
	
	# A5 = reverse_array(A3)
	la $a0, ARRAY_3
	la $a1, ARRAY_5
	move $a2, $s1
	jal reverse_array
	
	# A6 = pairwise_max(A4, A5)
	la $a0, ARRAY_4
	la $a1, ARRAY_5
	la $a2, ARRAY_6
	move $a3, $s1
	jal pairwise_max
	
	# A7 = accumulate_sum(A6)
	la $a0, ARRAY_6
	la $a1, ARRAY_7
	move $a2, $s1
	jal accumulate_sum
	
	# output to console: A7[-1]
	move $t7, $s1
	mul $t7, $t7, 4
	addi $t7, $t7, -4
	la $t6, ARRAY_7
	add $t7, $t7, $t6
	lw $t5, 0($t7)
	sw $t5, ARRAY_8
	la $a0, ARRAY_8
	addi $a1, $zero, 1
	jal dump_ints_to_console
	
	
	# Get outta here.		
	add $v0, $zero, 10
	syscall	

# PROCEDURES FROM PARTS A, B, C, and D
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
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

# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
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

# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
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
	
	
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
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
