.data
ok :.word 0

.text
li $v0, 5
syscall
move $s0, $v0
li $t1, 100
li $t2, 4
li $t3, 400
divu $s0, $t1
mfhi $t4 			#n%100
divu $s0, $t2
mfhi $t5			#n%4
divu $s0, $t3
mfhi $t6			#n%400
beq $t4, $0, sjn 	#n%100!=0
beq $t5, $0, ok1
j end


sjn:
beq $t6, $0, ok1
j end
 
ok1:
li $s1, 1
sw $s1, ok
j end

end:
lw $a0, ok
li $v0, 1
syscall

li $v0, 10
syscall
