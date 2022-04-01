.macro getaddr(%addr, %i, %j)
	mul %addr, %i, 10
	add %addr, %addr, %j
	sll %addr, %addr, 2
.end_macro

.data
graph: .word 0:400
path: .word -1:40
visit: .word 0:40

.text
li $s7, 0 #ok
li $v0, 5
syscall
move $s0, $v0 #V
li $v0, 5
syscall
move $s1, $v0 #m
li $t0, 0 #mark
in:
bge $t0, $s1,endi
li $v0, 5
syscall
move $t2, $v0 #i
li $v0, 5
syscall
move $t3, $v0 #j
addi $t2, $t2, -1
addi $t3, $t3, -1
getaddr($t4, $t2, $t3)
li $t5, 1
sw $t5, graph($t4)
getaddr($t4, $t3, $t2)
sw $t5, graph($t4)
addi $t0, $t0, 1
j in
endi:
sw $0, path($0)
sll $t0, $s0, 2
li $t1, 1
sw $t1, visit($t0)#qidian biao ji
move $a0, $t1 #current
jal hamcycle
beq $v0, 0, endmain
li $s7, 1 #ok = 1
endmain:
beq $s7, 0, a00
li $a0, 1
j prin
a00:
li $a0, 0
prin:
li $v0, 1
syscall
li $v0, 10
syscall




hamcycle:
bne $a0, $s0,init
addi $t0, $a0, -1 #current - 1
sll $t0, $t0, 2
lw $t0, path($t0) #path
getaddr ($t1, $t0, $0)
lw $t0, graph($t1)
beq $t0, 0, r0
r1:
li $v0, 1
jr $ra
r0:
li $v0, 0
jr $ra

init:
li $t7, 1 #v
loopc:
bge $t7, $s0, r0
sll $t2, $t7, 2 #addv
lw $t3, visit($t2) #visit[v]
addi $t0, $a0, -1 #current - 1
sll $t0, $t0, 2
lw $t0, path($t0) #path
getaddr ($t1, $t0, $t7) #path current-1
lw $t4, graph($t1)
bne $t3, 0, newloop
beq $t4, 0, newloop
li $t5, 1
sw $t5, visit($t2) #t2 addv
sll $t0, $a0, 2 #t0 currentaddress
sw $t7, path($t0)
addi $sp, $sp, -12
sw $ra 0($sp)
sw $a0 4($sp)
sw $t7 8($sp)
addi $a0, $a0, 1
jal hamcycle
lw $ra 0($sp)
lw $a0 4($sp)
lw $t7 8($sp)
addi $sp, $sp, 12
beq $v0, 0, re
j r1
re:
sll $t0, $a0, 2
li $t1, -1
sw $t1, path($t0)
sll $t1, $t7, 2
sw $0, visit($t1)
newloop:
addi $t7, $t7, 1
j loopc


