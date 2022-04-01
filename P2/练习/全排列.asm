.data
symbol: .space 80
array: .space 80
enter: .asciiz "\n"
space: .asciiz " "

.text
li $v0, 5
syscall
move $s0, $v0 #n
li $a0, 0
jal dfs
li $v0, 10
syscall

dfs:
blt $a0, $s0, else
	li $s1, 0   #i
	prinlop:
	bge $s1, $s0,endp
	sll $t1, $s1, 2
	lw $a0, array($t1)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $s1, $s1, 1
	j prinlop
	endp:
	la $a0, enter
	li $v0, 4
	syscall
	jr $ra
	
	else:
	li $s1, 0   #i
		loop:
		bge $s1, $s0, endl
		sll $t1, $s1, 2
		lw  $t2, symbol($t1)#symboi==?
		bne $t2, $0, new
		sll $t3, $a0, 2 #index
		addi $t4, $s1,1
		sw $t4, array($t3)
		li $t2, 1
		sw $t2, symbol($t1)
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $a0, 4($sp)
		sw $s1, 8($sp)
		addi $a0, $a0, 1
		jal dfs
		lw $ra 0($sp)
		lw $a0, 4($sp)
		lw $s1 8($sp)
		addi $sp, $sp, 12
		sll $t1, $s1, 2
		sw $0, symbol($t1)
		new:
		addi $s1, $s1, 1
		j loop
		endl:
		jr $ra