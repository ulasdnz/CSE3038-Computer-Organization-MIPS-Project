.data

input: .asciiz "Input: "
output: .asciiz "Output:\n"
buffer: .space 100

	.align 2
array: .space 400

	      .align 2
outputarray: .space 120
	
newline: .asciiz "\n"
space: .asciiz " "

.text
main: 
	#peinr first num
	la $a0, input    # Load and print string asking for string
   	li $v0, 4
   	syscall
   	
   	li $v0, 8       # take in input
  	la $a0, buffer  # load byte space into address
  	li $a1, 100      # allot the byte space for string
  	move $t0, $a0   # save string to t0
    	syscall
  	
  	
  	jal parseString #parse the string into an array of integers
  	
  	move $a0, $v0 # the size of the array is moved to $a0 to pass as argument
  	jal isqrt # call sqrt function to get the size of the 2-D array
  	
  	
  	move $a0, $v0 # $a0 is the length of 2-D matrix
  	jal mystery_operation
  	
  	move $a0, $v0
  	jal print_array
    	
    	li $v0,10
   	syscall
   	
   	
   	
   	
   	
   	
    	
parseString: #Parses given string to an array and returns the size of the resulting array
	# $s0 = i
	# $t1 = current character from string
	# $s1 = number
	# $t2 = set to 1 if number is negative, otherwise 0
	# $s2 = current index of the array (multiples of 4)
	
	
	lbu $t1, buffer($s0) #S0 = i
    	beq $t1, $zero, exitparse
    	
    	beq $t1, 10, spacefound #branch if newline character is found
    	beq $t1, 32, spacefound #branch if space is found
    	
    	beq $t1, 45 negativecharfound #if character "-" is found, set $t2 to 1
    	

    	mul $s1, $s1, 10 #multiply current sum with 10 
    	subi $t1, $t1, 48 #Get the digit by subtracting 48 (ASCII Table)
    	add $s1, $s1, $t1 #Add new digit into $s1  
    		
increment:
    	addi $s0, $s0, 1 #increment i by 1
    	j parseString
    	
negativecharfound:
	addi $t2, $zero, 1
	j increment

    	
spacefound: # When a space is found
	addi $s0, $s0, 1 #increment i by 1
	lbu $t3, buffer($s0) #read the next character in buffer
	beq $t3, 32, spacefound #loop until the next character is not space
	
	beq $t2, 1, negativenumber #If $t2 is 1 (our number is negative) jump to negativenumber 
storeinarray:	#store the final value in array's corresponding location
	sw $s1, array($s2) #move the parsed number into our array
	move $s1, $zero #reset $s1 register to calculate new sum
   	
   	addi $s2, $s2, 4 #$s2 is the index of our array
   	
   	j parseString

negativenumber: #Multiply number with -1 for negative numbers
	mul $s1, $s1, -1 #Multiply s1 with -1 if we have a negative number
	add $t2, $zero, $zero #make $t2 register 0 in the beginning
	j storeinarray
	
exitparse:
	div $v0, $s2, 4
    	jr $ra
    	
    	

isqrt:
  	# v0 - return / root
  	# t0 - bit
  	# t1 - num
	# t2,t3 - temps
  	move  $v0, $zero        # initalize return
  	move  $t1, $a0          # move a0 to t1

  	addi  $t0, $zero, 1
  	sll   $t0, $t0, 30      # shift to second-to-top bit

isqrt_bit:
  	slt   $t2, $t1, $t0     # num < bit
  	beq   $t2, $zero, isqrt_loop

  	srl   $t0, $t0, 2       # bit >> 2
  	j     isqrt_bit

isqrt_loop:
  	beq   $t0, $zero, isqrt_return

  	add   $t3, $v0, $t0     # t3 = return + bit
  	slt   $t2, $t1, $t3
  	beq   $t2, $zero, isqrt_else

  	srl   $v0, $v0, 1       # return >> 1
  	j     isqrt_loop_end

isqrt_else:
  	sub   $t1, $t1, $t3     # num -= return + bit
  	srl   $v0, $v0, 1       # return >> 1
  	add   $v0, $v0, $t0     # return + bit

isqrt_loop_end:
  	srl   $t0, $t0, 2       # bit >> 2
  	j     isqrt_loop

isqrt_return:
  	jr  $ra
  	
  	
  	
  	
  	
mystery_operation:
	# $s0 = i
	# $s1 = j
	# $t0 = length
	# $t2 = row sum
	# $t3 = column sum
	# $t4 = row offset
	# $t5 = column offset
	
	move $t0, $a0 #Initialize length
	
	move $s0, $zero #initialize i
	
mystery_outer_loop:
	
	slt $t1, $s0, $t0
	beq $t1, $zero mystery_outer_end
	
	addi $t2, $zero, 1 #initialize row sum and column sum to 1
	addi $t3, $zero, 1
	
	move $s1, $zero # initialize j
mystery_inner_loop:
	
	slt $t1, $s1, $t0
	beq $t1, $zero mystery_inner_end
	
	add $t6, $zero, 2
	div $s1, $t6
	mfhi $t6
	
	beq $t6, $zero, mystery_even_j
	
	# Row offset calculation in %s2
	addi $s2, $s0, 1 # i + 1
	mul $s2, $s2, $a0 # length * (i+1)
	add $s2, $s2, $s1 # length * (i+1) + j
	mul $s2, $s2, 4 # 4 * [length * (i+1) + j]
	
	# Column offset calculation in $s3
	move $s3, $s1 # j
	mul $s3, $s3, $a0 # length * j
	add $s3, $s3, $s0 # length * j + i 
	mul $s3, $s3, 4 # 4 * [length * j + i]
	
mystery_inner_sum:
	
	lw $s4, array($s2) # $s4 holds rowsum value
	lw $s5, array($s3) # $s5 holds column sum value
	
	mul $t2, $t2, $s4 # rowsum *=
	mul $t3, $t3, $s5 # columnsum *=
	
	addi $s1, $s1, 1 # increment j by 1
	
	j mystery_inner_loop
	
	
mystery_even_j:
	# Row offset calculation in %s2
	move $s2, $s0 # i
	mul $s2, $s2, $a0 # length * (i)
	add $s2, $s2, $s1 # length * (i) + j
	mul $s2, $s2, 4 # 4 * [length * (i) + j]
	
	# Column offset calculation in $s3
	move $s3, $s1 # j
	mul $s3, $s3, $a0 # length * j
	addi $s3, $s3, 1
	add $s3, $s3, $s0 # length * j + (i + 1) 
	mul $s3, $s3, 4 # 4 * [length * j + i + 1]
	
	j mystery_inner_sum
	

mystery_inner_end:
	
	#Row offset calculation
	div $s6, $s0, 2 # i / 2
	mul $s6, $s6, 4 # 4 * (i / 2)
	
	
	#Column offset calculation
	div $s7, $t0, 2 # length / 2
	div $t7, $s0, 2 # i / 2
	add $s7, $s7, $t7
	mul $s7, $s7, 4
	
	
	sw $t2, outputarray($s6)
	sw $t3, outputarray($s7)
	
	
	addi $s0, $s0, 2 # increment i by 2
	j mystery_outer_loop

mystery_outer_end:
	
	jr $ra
	
	
	
print_array:
	# $s0 = i

	move $t0, $a0 #move a0 into t0 (length of array)
	div $t1, $t0, 2 #$t1 holds half of the size
	
	move $s0, $zero #initialize i
	
	la $a0, output    # Load and print string asking for string
   	li $v0, 4
   	syscall
	
print_array_loop:
	
	beq $s0, $t0, print_exit
	beq $s0, $t1, print_newline
	
print_number:
	mul $s2, $s0, 4
	lw $s3, outputarray($s2)
	
	li $v0, 1
	move $a0, $s3
	syscall 
	
	
	la $a0, space    # Load and print string asking for string
   	li $v0, 4
   	syscall
	
	
	
	addi $s0, $s0, 1
   	j print_array_loop
   	
print_newline:
	la $a0, newline    # Load and print string asking for string
   	li $v0, 4
   	syscall
   	
   	j print_number
	
print_exit:
	jr $ra
