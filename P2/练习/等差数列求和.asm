.text
li $v0, 5
syscall
move $s0, $v0 #n
li $s1, 0 #ans
li $t0, 1
loop1:
bgt $t0, $s0, endl1
add $s1, $t0, $s1
addi $t0, $t0, 1
j loop1
endl1:
move $a0, $s1
li $v0, 1
syscall
li $v0, 10
syscall