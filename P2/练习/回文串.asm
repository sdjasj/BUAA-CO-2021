.data
	str: .space 30

.text
	li $v0, 5
	syscall
	move $s0, $v0#n
	li $t0, 0
loop:
	slt $t1,$t0,$s0
	beq $t1,$0,endloop
	li $v0, 12
	syscall
	sll $t2, $t0, 1
	sb $v0, str($t2)
	addi $t0, $t0, 1
	j loop
endloop:
	li $t0, 0#p
	sll $t1, $s0, 1#q
	addi $t1, $t1, -2
cmp:
	slt $t2, $t0, $t1
	beq $t2, $0, endcmp
	lb $t3, str($t0)
	lb $t4, str($t1)
	bne $t3, $t4, endcmp
	addi $t0, $t0, 2
	addi $t1, $t1, -2
	j cmp
endcmp:
	bge $t0, $t1, yes
	j no
yes:
	li $a0, 1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
no:
	li $a0, 0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
		
	
		