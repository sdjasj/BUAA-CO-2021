.text
li $v0, 5
syscall
move $s0, $v0 #n
li $s1, 0 #ans
li $t0, 1
loop1:
bgt $t0, $s0, endl1
li $t1, 1 #temp
move $t2, $t0
	loop2:
	beq $t2, $0, endl2
	mul $t1, $t1, $t2
	addi $t2, $t2, -1
	j loop2
	endl2:
add $s1, $s1, $t1
addi $t0, $t0, 1
j loop1
endl1:
move $a0, $s1
li $v0, 1
syscall
li $v0, 10
syscall