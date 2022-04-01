.text
li $v0, 5
syscall
move $s0,$v0
li $t0,1
li $s7, 0
loop1:
bgt $t0,$s0,endloop1
li $t1,1
li $t2, 1
	loop2:
	bgt $t1, $t0, endloop2
	mul $t2,$t2,$t1
	addi $t1,$t1,1
	j loop2
	endloop2:
	add $s7, $s7, $t2
	addi $t0,$t0, 1
	j loop1
endloop1:
move $a0, $s7
li $v0, 1
syscall
