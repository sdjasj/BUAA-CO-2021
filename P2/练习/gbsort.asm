.data
a: .word 0:1000
r: .word 0:1000
space: .asciiz " "
.macro dushu(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro 

.text
dushu($s0) #n
li $t0, 1
in1:
bgt $t0, $s0, endin1
li $v0, 5
syscall
sll $t1, $t0, 2
sw $v0, a($t1)
addi $t0, $t0, 1
j in1
endin1:
li $a0, 1
move $a1, $s0
jal gbsort
li $t0, 1
prin:
bgt $t0, $s0, endp
sll $t1, $t0, 2
lw $a0, a($t1)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t0, $t0, 1
j prin
endp:
li $v0, 10
syscall



gbsort:
bne $a0, $a1,else
jr $ra
else:
add $t0, $a0, $a1
srl $t0, $t0, 1 #mid
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t0, 12($sp)
move $a1, $t0
jal gbsort
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t0, 12($sp)
addi $sp, $sp, 16
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t0, 12($sp)
addi $a0, $t0, 1
jal gbsort
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t0, 12($sp)
addi $sp, $sp, 16
move $t1, $a0#i
addi $t2, $t0, 1#j
move $t3, $a0 #k
l1:
bgt $t1, $t0, endl1
bgt $t2, $a1, endl1
sll $t4, $t1, 2
lw $t4, a($t4) #ai
sll $t5, $t2, 2
lw $t5, a($t5) #aj
bgt $t4, $t5, else1
sll $t6, $t3, 2 #addr rk
sw $t4, r($t6)
addi $t3, $t3, 1
addi $t1, $t1, 1
j l1
else1:
sll $t6, $t3, 2 #addr rk
sw $t5, r($t6)
addi $t3, $t3, 1
addi $t2, $t2, 1
j l1
endl1:
res1:
bgt $t1, $t0, res2
sll $t4, $t3, 2
sll $t5, $t1, 2
lw $t5, a($t5)
sw $t5, r($t4)
addi $t3, $t3, 1
addi $t1, $t1, 1
j res1
res2:
bgt $t2, $a1, hb
sll $t4, $t3, 2
sll $t5, $t2, 2
lw $t5, a($t5)
sw $t5, r($t4)
addi $t3, $t3,1
addi $t2, $t2, 1
j res2
hb:
move $t1, $a0
loophb:
bgt $t1, $a1, endhb
sll $t2, $t1, 2 #add i
lw $t3, r($t2)
sw $t3, a($t2)
addi $t1, $t1, 1
j loophb
endhb:
jr $ra
