		.data
		 str:        .space 2560
		 specials:   .space 100
		 output:     .space 2560
		 prmpt1:     .asciiz "\nInput Text: "
		 prmpt2:     .asciiz "\nParser characters: "
		 prmpt3:     .asciiz "\nOutput: \n"

		  
		.text           	  
main:
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
			la $s2, output			  # Address of the output string is in $s2 register.
			
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
		        la   $a0, output        	# prints the "output" string. 
		        syscall
		
			li	$v0, 10		# syscall code 10 is for exit
			syscall			#
# end of main
