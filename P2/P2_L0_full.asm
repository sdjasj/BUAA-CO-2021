.data
symbol: .word 0:100
array: .word 0:100
space: .asciiz " "
enter: .asciiz "\n"
.text
li $v0, 5
syscall
move $s0, $v0#n
li $a0, 0
jal fullarray
li $v0, 10
syscall



fullarray:
blt $a0, $s0, dfs
li $t0,0
	prin:
	bge $t0, $s0, endprin
	sll $t1, $t0, 2#addr
	lw $a0, array($t1)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	j prin
	endprin:
	la $a0, enter
	li $v0, 4
	syscall
	jr $ra
dfs:
li $t0, 0#i
loop:
bge $t0, $s0, endloop
sll $t1, $t0, 2#addr i
lw $t2, symbol($t1)
bne $t2, $0,next
addi $t3, $t0, 1 #i+1
sll $t4, $a0, 2 #addrindex
sw $t3, array($t4)
li $t3, 1
sw $t3, symbol($t1)
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $ra, 4($sp)
sw $t0, 8($sp)
sw $t1, 12($sp)
addi $a0, $a0, 1
jal fullarray
lw $a0, 0($sp)
lw $ra, 4($sp)
lw $t0, 8($sp)
lw $t1, 12($sp)
addi $sp, $sp, 16
li $t4, 0
sw $t4, symbol($t1)
next:
addi $t0,$t0, 1
j loop
endloop:
jr $ra