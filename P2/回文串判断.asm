.data
s1: .space 400

.text
main:
	li $v0, 5
	syscall
	move $s0, $v0 #n
	li $t0, 0
	in:bge $t0,$s0,endin
	li $v0, 12
	syscall
	sb $v0, s1($t0)
	addi $t0, $t0, 1
	j in
	endin:li $t0, 0
	addi $t1, $s0,-1
	huiwen:bgt $t0, $t1, endhui
	lb $t2, s1($t0)
	lb $t3, s1($t1)
	bne $t2, $t3, endhui
	addi $t1, $t1, -1
	addi $t0, $t0, 1
	j huiwen
	endhui:bgt $t0, $t1, yes
	li $a0, 0
	j prin
	yes:li $a0, 1
	prin:li $v0, 1
	syscall
	li $v0, 10
	syscall	