.data

input: .asciiz "Input: "
type: .asciiz "Type: "
output: .asciiz "Output: "
inputlist: .space 200

convertnumberoutput: .space 100

.text

main:
	
	la $a0, input    # Load and print string asking for input
   	li $v0, 4
   	syscall
   	
   	
	li $v0, 8       # take in input
  	la $a0, inputlist  # load byte space into address
  	li $a1, 200      # allot the byte space for string
  	move $t0, $a0   # save string to t0
    	syscall
    	
    	
    	la $a0, type    # Load and print string asking for type
   	li $v0, 4
   	syscall
   	
   	#reads type and store it in $s6
	li $v0, 5
	syscall
	move $s6, $v0
	
	
	jal length # Calculate the length of our string input
	
	move $a0, $v0 # length is the first argument to convertnumber
	move $a1, $s0 #type is the second argument
	jal first_digit_index
	move $a2, $v0
	jal convertnumber
	
	
	
	
	move $a0, $v0 #a0 holds the type one output
	move $a1, $v1 # a1 holds length of type two string
	move $a2, $s6 #$a2 holds the type given as input
	jal print_converted_output
	
	li $v0,10
   	syscall
	
	
	
first_digit_index:
	move $s0, $zero
	
first_digit_index_loop:
	lbu $t1, inputlist($s0)
	bne $t1, 32, first_digit_index_end#if space is current character
	
	addi $s0, $s0, 1
	j first_digit_index_loop
first_digit_index_end:
	move $v0, $s0
	jr $ra
	
length:
	# $s0 = i
	# $v0 = length variable 
	# $t0 - current character in string
    	
   
    
    	add $s0, $zero, $zero # initialize i
length_loop:
    	
    	lbu $t0, inputlist($s0) #load current charater into $t1
    	
    	beq $t0, 10, length_end # End if newline character is found (ASCII 10 is newline character)
    	beqz $t0, length_end
    	
    	addi $s0, $s0, 1
    	j length_loop


length_end:
	move $v0,$s0 # final i value is our length
	jr $ra
    	
    	
    	
convertnumber:
	


	# $v0 = output after conversion
	# $t0 = length of the string (passed as argument)
	# $t1 = current sum
	# $t2 = i 
	# $t3 = current character of string 
	# $t4 = current digit of the string as int
	# $t5 = current exponent of 2
	# $t6 = current exponent of 2 for type two
	# $t7 = current sum for type two
	# $s0 = holds the constant 4
	# $s1 = current index  of output string
	# %s3 = total sum for type two
	# $s7 = first index of nonspace character
	
	move $t0, $a0 # move a0 into t0 
	move $v0, $zero # Reset $v0
	addi $t2, $t0, -1 # intialize i to length - 1
	addi $t5, $zero, 0 # initialize exponent to 0
	addi $t6, $zero, 0
	addi $s0, $zero, 4
	move $s1, $zero
	move $s7, $a2
convertnumber1_loop:
	
	blt $t2, $zero, convertnumber1_loop_end # If i < length. end the loop
	
	lbu $t3, inputlist($t2) #load the current digit into $t3
	beq $t3, 32, convertnumber1_loop_decrement #continue if space is found
	
	seq $t4, $t3, 49 # $t4 holds the current digit (either 0 or 1)
	
	sllv $t1, $t4, $t5 # take the xponent of the current digit
	
	
	
	
	# if exponent mod 4 is not zero or exponent is zero, jump to label
	div  $t6, $s0
	mfhi $s2 
	bne $s2, $zero, convertnumber_signdigit_check
	beq $t6, $zero, convertnumber_signdigit_check
	
	
	
	#Call convert_hex function
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	move $a0, $s3
	move $a1, $s1
	jal convert_hex # add current sum to output by calling converthex function
	addi $s1, $s1, 1 # increment current digit of output string 
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	
	
	
	move $t6, $zero # reset exponent and sum to 0
	move $s3, $zero
	move $t7, $zero

	
convertnumber_signdigit_check:
	beq $t2, $s7, convertnumber1_loop_signdigit
convertnumber1_loop_addsum:
	sllv $t7, $t4, $t6
	add $s3, $s3, $t7
	
	addi $t5, $t5, 1 # increment exponent by 1
	addi $t6, $t6, 1
	add $v0, $v0, $t1 # add current sum to the output
	
	
		
convertnumber1_loop_decrement:
	addi $t2, $t2, -1
	j convertnumber1_loop
	
convertnumber1_loop_signdigit:
	mul $t1, $t1, -1 #multiply current sum with -1
	j convertnumber1_loop_addsum
	
convertnumber1_loop_end:   
	addi $sp, $sp -4
	sw $ra, 0($sp)
		
	move $a0, $s3
	move $a1, $s1
	jal convert_hex # add current sum to output by calling converthex function
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	
	move $v1, $s1 # move length of hexadecimal string as second output
    	jr $ra
    	


convert_hex: # takes a number and converts it to hexadecimal and places into output array
	#t0 = current digit 
	
	
	move $s4, $a0 # a0 holds number
	move $s5, $a1 # a1 holds current index of output string
	
	bge $s4, 10, converthex_letter
	addi $s4, $s4, 48 #If number is less than 10 just add 48 to reach its ASCII value 
	
convert_hex_store:
	sb $s4, convertnumberoutput($s5)
	jr $ra
	
converthex_letter:
	addi $s4, $s4, 55 #add 55 to start from A (for 10 ASCII value of A is 65)
	j convert_hex_store
	
print_converted_output:
	# $t0 = decimal output
	# $t1 = hex output length
	# $t2 = type
	
	move $t0, $a0 
	move $t1, $a1
	move $t2, $a2
	
	beq $t2, 2, print_converted_output_type2
	
	#Type 1 output
	la $a0, output    # output string
   	li $v0, 4
   	syscall
	
	li $v0, 1 #print decimal output
	move $a0, $t0
	syscall 
	
	j print_converted_output_end
	
	
print_converted_output_type2:

	#print output string
	la $a0, output    # output string
   	li $v0, 4
   	syscall
	
print_converted_output_type2_loop:

	blt $t1, $zero, print_converted_output_end
	
	lbu $t3, convertnumberoutput($t1)
	li $v0, 11
	move $a0, $t3
	syscall
	
	addi $t1, $t1, -1
	j print_converted_output_type2_loop
	
print_converted_output_end:
	jr $ra
	
