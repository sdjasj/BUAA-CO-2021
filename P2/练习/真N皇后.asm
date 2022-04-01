.data
hash: .word 0:100
p: .word 0:100
space: .asciiz " "
enter: .asciiz "\n"
.macro getadd(%ans, %i)
	sll %ans, %i, 2
.end_macro 
.macro dushu(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.text
li $s1, 0 #count
dushu($s0) #n
li $a0, 1 #index
jal generatep
move $a0, $s1
li $v0, 1
syscall
la $a0, enter
li $v0, 4
syscall
li $v0, 10
syscall



generatep:
addi $t0, $s0, 1
bne $a0, $t0, dfs
addi $s1, $s1, 1
li $t0, 1#k
lp:
bgt $t0, $s0, endlp
getadd($t1, $t0)
lw $a0, p($t1)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t0, $t0, 1
j lp
endlp:
la $a0, enter
li $v0, 4
syscall
jr $ra
dfs:
li $t0, 1 #x
loop:
bgt $t0, $s0, endloop
getadd($t1, $t0) #addr x
lw $t2, hash($t1)
bne $t2, $0, next
li $t9, 1#flag
li $t8, 1#pre
panduan:
bge $t8, $a0, endpd
sub $t3, $a0, $t8 #index-pre
getadd($t4, $t8)
lw $t4, p($t4)#ppre
sub $t4, $t0, $t4#x-ppre
beq $t3, $t4,else
mul $t4, $t4, -1
beq $t3, $t4,else
j pdnext
else:
li $t9, 0
j endpd
pdnext:
addi $t8, $t8, 1
j panduan
endpd:
beq $t9, $0, next
getadd($t3, $a0)
sw $t0, p($t3)
li $t3, 1
sw $t3, hash($t1)
addi $sp, $sp -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $t0, 8($sp)
sw $t1, 12($sp)
addi $a0, $a0, 1
jal generatep
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $t0, 8($sp)
lw $t1, 12($sp)
addi $sp, $sp 16
li $t3, 0
sw $t3, hash($t1)
next:
addi $t0, $t0, 1
j loop
endloop:
jr $ra