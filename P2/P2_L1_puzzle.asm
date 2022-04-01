.data
arr: .word 0:100



mark: .word 0:100


dxy: .word -1:1 
	 .word 0:2 
	 .word -1:1 
	 .word 1:1 
	 .word 0:2 
	 .word 1:1
.macro dushu(%reg)
	li $v0, 5
	syscall
	move %reg, $v0
.end_macro 
.macro getadd(%ans,%i,%j)
	mul %ans, %i, 10
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro 
.macro getadd2(%ans,%i,%j)
	sll %ans, %i, 1
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro 
.text
li $s7, 0#count
dushu($s0)#n
dushu($s1)#m
li $t0, 0
in1:
bge $t0, $s0, endin1
	li $t1, 0
	in2:
	bge $t1, $s1,endin2
	li $v0, 5
	syscall
	getadd($t2,$t0,$t1)
	sw $v0, arr($t2)
	addi $t1, $t1, 1
	j in2
	endin2:
	addi $t0, $t0, 1
	j in1
endin1:
dushu($a0)#bx
dushu($a1)#by
dushu($s2)#ex
dushu($s3)#ey
addi $s2, $s2, -1
addi $s3, $s3, -1
addi $a0, $a0, -1
addi $a1, $a1, -1
li $t0, 1
getadd($t1,$a0,$a1)
sw $t0, arr($t1)
sw $t0, mark($t1)
jal dfs
move $a0, $s7
li $v0, 1
syscall
li $v0, 10
syscall


dfs:
bne $a0, $s2, else
bne $a1, $s3, else
addi $s7, $s7, 1
jr $ra

else:
li $t0, 0 #i
loopd:
bge $t0, 4, endld
li $t9, 0
li $t8, 1
getadd2($t1,$t0,$t9)
lw $t1, dxy($t1) #dxyi0
getadd2($t2,$t0,$t8)
lw $t2, dxy($t2) #dxyi1
add $t3, $t1, $a0 #nx
add $t4, $t2, $a1 #ny
blt $t3, $0, next
blt $t4, $0, next
bge $t3, $s0, next
bge $t4, $s1, next
getadd($t5, $t3,$t4)#addr nxny
lw $t6, arr($t5)
bne $t6, $0, next
lw $t6, mark($t5)
bne $t6, $0, next
li $t8, 1
sw $t8, mark($t5)
addi $sp, $sp, -28
sw $ra 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t5, 12($sp)
sw $t0, 16($sp)
sw $t3, 20($sp)
sw $t4, 24($sp)
move $a0, $t3
move $a1, $t4
jal dfs
lw $ra 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t5, 12($sp)
lw $t0, 16($sp)
lw $t3, 20($sp)
lw $t4, 24($sp)
addi $sp, $sp, 28
li $t8, 0
sw $t8, mark($t5)
next:
addi $t0, $t0, 1
j loopd
endld:
jr $ra