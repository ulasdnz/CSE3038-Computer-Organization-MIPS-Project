.data
firstnum: .asciiz "Enter the first numerator: "
firstden: .asciiz "Enter the first denominator: "
secondnum: .asciiz "Enter the second numerator: "
secondden: .asciiz "Enter the second denominator: "
plussign: .asciiz " + "
dividesign: .asciiz "/"
equalssign: .asciiz " = "


.text
main: 
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
	
	
	li $v0, 10 #Terminate the program 
        syscall 
		
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
	
