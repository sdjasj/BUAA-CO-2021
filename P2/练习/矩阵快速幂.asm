.macro getaddr (%ans,%i,%j)
	mul %ans, %i,10
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.data
arr1: .word 0:100
arr4: .word 0:100
arr3: .word 0:100
space: .asciiz " "
enter: .asciiz "\n"
.text
li $v0, 5
syscall
move $s0, $v0 #n
li $v0, 5
syscall
move $s1, $v0 #pow
li $t0, 0
in:
bge $t0, $s0,endin
	li $t1, 0
	in2:
	bge $t1, $s0, endin2
	li $v0, 5
	syscall
	getaddr($t2,$t0,$t1)
	sw $v0 arr1($t2)
	addi $t1, $t1, 1
	j in2
	endin2:
	addi $t0, $t0, 1
	j in
endin:
li $t0, 0
initarr1:
bge $t0, $s0,ksm
getaddr($t1,$t0,$t0)
li $t2,1
sw $t2, arr3($t1) #dan wei juzhen
addi $t0, $t0, 1
j initarr1
ksm:
beq $s1, 0, endksm
andi $t0, $s1, 1
	bne $t0, 1, next
		la $a0, arr3
		la $a1, arr1
		jal jzcf
	next:
	la $a0, arr1
	la $a1, arr1
	jal jzcf
	srl $s1, $s1, 1
	j ksm
endksm:
li $t0, 0
print1:
bge $t0, $s0, endp1
li $t1, 0
print2:
bge $t1, $s0, endp2
getaddr($t2, $t0, $t1)
lw $a0, arr3($t2)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t1, $t1, 1
j print2
endp2:
la $a0, enter
li $v0, 4
syscall
addi $t0, $t0, 1
j print1
endp1:
li $v0, 10
syscall



jzcf:
li $t0, 0
c1:
bge $t0, $s0, endc1
	li $t1, 0
	c2:
	bge $t1, $s0, endc2
		li $t2, 0
		c3:
		bge $t2, $s0, endc3
		getaddr($t3,$t0,$t1)#arr4
		getaddr($t4,$t0,$t2)
		add $t7, $a0, $t4
		lw $t4, ($t7)#arr
		getaddr ($t5, $t2, $t1)
		add $t7, $a1, $t5
		lw $t5, ($t7)#brr
		mul $t6, $t5, $t4
		lw $t4, arr4($t3)
		add $t4, $t4, $t6
		sw $t4, arr4($t3)
	addi $t2, $t2, 1
	j c3
		endc3:
	addi $t1, $t1, 1
	j c2
	endc2:	
addi $t0, $t0, 1
j c1
endc1:
li $t0, 0
sr1:
bge $t0, $s0, endsr1
	li $t1, 0
	sr2:
	bge $t1, $s0, endsr2
	getaddr($t3, $t0, $t1)#arr4ij
	lw $t4, arr4($t3)
	add $t5, $a0, $t3
	sw $t4, ($t5)
	li $t4, 0
	sw $t4, arr4($t3)
	addi $t1, $t1, 1
	j sr2
	endsr2:
	addi $t0, $t0, 1
	j sr1
endsr1:
jr $ra
