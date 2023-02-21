.data

input: .asciiz "Input: "
type: .asciiz "Type: "
output: .asciiz "Output: "
newlineoutput: .asciiz "Output:\n"
inputlist: .space 200

convertnumberoutput: .space 100




str:        .space 2560
		 specials:   .space 100
		 output3:     .space 2560
		 prmpt1:     .asciiz "\nInput Text: "
		 prmpt2:     .asciiz "\nParser characters: "
		 prmpt3:     .asciiz "\nOutput: \n"



firstnum: .asciiz "Enter the first numerator: "
firstden: .asciiz "Enter the first denominator: "
secondnum: .asciiz "Enter the second numerator: "
secondden: .asciiz "Enter the second denominator: "
plussign: .asciiz " + "
dividesign: .asciiz "/"
equalssign: .asciiz " = "


buffer: .space 100

	.align 2
array: .space 400

	      .align 2
outputarray: .space 120
	
newline: .asciiz "\n"
space: .asciiz " "


welcome: .asciiz "Welcome to our MIPS project!\n"
mainmenutext: .asciiz "Main Menu:\n"
firstopt: .asciiz "1. Base Converter\n"
secondopt: .asciiz "2. Add Rational Number\n"
thirdopt: .asciiz "3. Text Parser\n"
fourthopt: .asciiz "4. Mystery Matrix Operation\n"
fifthopt: .asciiz "5. Exit\nPlease select an option: "
newlines: .asciiz "\n\n"

programendstext: .asciiz "Program ends. Bye :)"
invalidinput: .asciiz "Invalid input! Try again. \n"
.text

main:
	la $a0, welcome    # menu string
   	li $v0, 4
   	syscall
   	
   	j mainmenurest
	
mainmenu:
	
	jal clearregisters

	la $a0, newlines    # print newlines
   	li $v0, 4
   	syscall
mainmenurest:
	la $a0, mainmenutext    # menu string
   	li $v0, 4
   	syscall
   	la $a0, firstopt    # menu string
   	li $v0, 4
   	syscall
   	la $a0, secondopt    # menu string
   	li $v0, 4
   	syscall
   	la $a0, thirdopt    # menu string
   	li $v0, 4
   	syscall
   	la $a0, fourthopt    # menu string
   	li $v0, 4
   	syscall
   	la $a0, fifthopt    # menu string
   	li $v0, 4
   	syscall
   	
   	
   	
   	
	li $v0, 5
	syscall
	move $t0, $v0
	
	
	beq $v0, 1, question1
	beq $v0, 2, question2
	beq $v0, 3, question3
	beq $v0, 4, question4
	beq $v0, 5, endprogram
	
	
	#Invalid input
	la $a0, invalidinput    # menu string
   	li $v0, 4
   	syscall
   	
   	j mainmenu

	

endprogram:
	la $a0, programendstext    # print program ends text
   	li $v0, 4
   	syscall
	
	li $v0,10
   	syscall
   	
question1:
	
	#Rreet registers
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0




	
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
	
	
	j mainmenu
	
	
	
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
	
	
question3:
		 li   $v0, 4    	 	 # Syscall to print prmpt1 string
       		 la   $a0, prmpt1         	# $a0 <-  "\nInput Text: "
	        syscall
		
		la $a0, str      
		addi	$a1, $zero,2560	  	# move the max number the computer can read $a1
		li	$v0, 8		  	# read string
		syscall			
		
		
		
		li   $v0, 4    	   		# Syscall to print prmpt2 string
       		la   $a0, prmpt2         	# $a0 <- "\nParser characters: "
       		syscall
		
		la $a0, specials      
		addi	$a1, $zero,100		
		li	$v0, 8			#  read string (special characters)
		syscall				





			addi $t7,$zero,32 			  # t7 has ascii value of the "whitespace" which is 32.
			la $s0,str				  # $s0 has the starting address of the string.
			la $s1, specials			  # $s1 has the starting address of the special characters.
			

while:      		lb $t0,0($s0)				  # t0 has current character value of str.				  
			beq $t0, $zero, secondPhase       	  # if current value is 0, jump to second phase.
			j checkSpecials				  # else jump to checkSpecials to check if it should be removed.
	     Resume:    addi $s0,$s0,1			  	  # $s0 = $s0 + 1 (increment $s0 so that it points to the next character of the string.)
		        j    while
			
checkSpecials: 
			
			add $t2, $zero,$s1			  # $t2 has the starting address of the special characters.
loopSpecials:
			lb $t3,0($t2)				  # Load special characters to $t3 register..
			beq $t3,$zero, Resume			  # if it reaches the end of the string, jump to "Resume" label.
			beq $t3, $t7, notFount
			bne $t3,$t0, notFount			  # if ($t3 != $t0) jump notFound
			sb $t7, 0($s0)				  # else, if it finds that it is special character, modify it by storing whitespace character in it.
			j Resume
	notFount:	addi $t2,$t2,1				  # if it is not end of the "special characters" string and 
			j loopSpecials				  # it did not match with a special character yet, increment $t2 by 1 and continue to compare.

	
			# In the second phase, we delete the whitespace and store the words one by one to "output" string 
			# We also add "\n" to the end of the every word in the string.
			
			# Loops the characters and if it sees a non white space character, 
			#it will jump to the second loop and start to store characthers in the "output" string until it encounters another whitespace or
			# reaches to the end of the string. When it encounters a whitespace,
			# it will concatenate "\n" in the end and jump back to the first loop.
			
secondPhase:   		la $s0,str			  # Address of the first string which is modified by removing the special characters.
			la $s2, output3			  # Address of the output string is in $s2 register.
			
	secondLoop:     lb $t0, 0($s0)	
			beq $t0, $zero, theEnd		  # if we reach end of the first string, it will jump to the "theEnd" label.
			bne $t0, $t7, Extract		  # if the current character is not whitespace, jump to "Extract" and start to store it into the "output" string.
			addi $s0,$s0,1			  # otherwise increment $s0 by 1 and check the next character.
			j secondLoop	
			
			
			# Separates the whitspaces and concatenates "/n" (new line) into the end of the word.
			
	Extract:	lb $t1, 0($s0)			# Load non-whitespace characters into the $t1 register.
			beq $t1, $zero, theEnd		# if its end of the string, jump to tbe "theEnd" label.
			bne $t1, $t7, continue		# if its not a white space, jump to "continue" label.
			addi $t3, $zero,10		# if it encounters with a whitespace, store "/n" (new line) into the end of the word.
			sb $t3, 0($s2)			
			addi $s2,$s2,1
			j secondLoop
	continue:	sb $t1, 0($s2)			# continue to store the characters into the "output" string.
			addi $s2,$s2,1			# point to the next address byte of the "output" string by inceremting the $s2 register by 1.
			addi $s0,$s0,1
			j Extract

          theEnd:
		        add $t3, $zero,$zero		# $t3 = 0, so we will add 0 to the end of the output string which it is the end of the string characther.
			sb $t3, 0($s2)
       			li   $v0, 4    	   		
		        la   $a0, prmpt3         	#  Syscall to print prmpt3 string ("\nOutput: \n")
		        syscall
			li   $v0, 4    	   		
		        la   $a0, output3        	# prints the "output" string. 
		        syscall
		
			j mainmenu		#
# end of main

	
		
			
				
					
							
	
	
	
question4: 
	
	
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0



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
    	
    	j mainmenu
   	
   	
   	
   	
   	
    	
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
	
	la $a0, newlineoutput    # Load and print string asking for string
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
	

question2: 
	#peinr first num
	li $v0, 4
	la $a0, firstnum
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	#print and read first denominator
	li $v0, 4
	la $a0, firstden
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	#peinr second numerator
	li $v0, 4
	la $a0, secondnum
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	#print and read second denominator
	li $v0, 4
	la $a0, secondden
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0
	
	
	mul $t0, $s0, $s3 #multiply first numerator with second denominator
	mul $t1, $s1, $s2 #multiply first denominator with second numerator
	
	add $t0, $t0, $t1 # sum the multiplied numerators and store in $t4
	mul $t1, $s1, $s3 #multiply both dneominators and store in 
	
	
	move $a0, $t0
	move $a1, $t1
	
	jal gcd # Call the gcd function
	
	#Divide both parts with the gcd 
	div $a0, $v0
	mflo $t0
	div $a1, $v0 
	mflo $t1
	
	#Print Output
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 4
	la $a0, dividesign
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, plussign
	syscall
	
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, dividesign
	syscall
	
	li $v0, 1
	move $a0, $s3
	syscall
	
	li $v0, 4
	la $a0, equalssign
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, dividesign
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	
	j mainmenu
		
gcd:
	#Store saced registers
	addi $sp, $sp, -16
	sw $s0, 16($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	gcdloop:
	sgt $t0, $s1, $zero
	beq $t0, $zero, gcdexit
	
	div $s0, $s1
	mfhi $t1 #t1 holds arg1 % arg2
	move $s0, $s1 #arg1 = arg2
	move $s1, $t1 #arg2 = arg1 % arg2
	
	j gcdloop
	
	gcdexit:
	move $v0, $s0 #move the result in v0
	#Load saced registers
	lw $s0, 16($sp)
	lw $s1, 8($sp)
	lw $s2, 4($sp)
	lw $s3, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra
	


clearregisters:
	li $t0, 0
    	li $t1, 0
    	li $t2, 0
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    li $t9, 0

    li $s0, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0
	
	jr $ra

	