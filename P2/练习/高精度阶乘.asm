.data
s: .word 0:1000
space: .asciiz " "


.text
li $v0, 5
syscall
move $a0, $v0
jal func
li $v0, 10
syscall

func:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
li $s0, 1 #digit
li $s1, 0 #carry
li $t0, 1
sll $t0, $t0, 2
li $t1, 1
sw $t1, s($t0)#s[1] = 1
li $t0, 2 #i=2
loop1:
bgt $t0, $a0, endloop1
	li $t1, 1 #j=1
	loop2:
	bgt $t1, $s0, endloop2
	sll $t2, $t1, 2
	lw $t3, s($t2)
	mul $t4, $t3, $t0
	add $t4, $t4, $s1
	li $t5, 10 #10
	div $t4, $t5
	mfhi $t5
	sw $t5, s($t2)
	mflo $s1
	addi $t1, $t1, 1
	j loop2
	endloop2:
	while:
	beq $s1, 0, endwhile
	li $t5, 10 #
	div $s1, $t5
	sll $t2, $t1, 2
	mfhi $t5
	sw $t5, s($t2)
	mflo $s1
	addi $t1, $t1, 1
	j while
	endwhile:
	addi $s0, $t1, -1
	addi $t0, $t0, 1
	j loop1
endloop1:
move $t0, $s0
loopprint:
ble $t0, 0, endprin
sll $t1, $t0, 2
lw $a0, s($t1)
li $v0, 1
syscall
addi $t0, $t0, -1
j loopprint
endprin:
la $a0, space
li $v0, 4
syscall
jr $ra