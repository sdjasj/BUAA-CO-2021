.data
arr: .word 0:81
lie: .word 0:9
zd: .word 0:18
fd: .word 0:18
space: .asciiz " "
no: .asciiz "No. "
enter: .asciiz "\n"


.macro getaddr(%addr,%i,%j,%k)
mul %k, %i, 9
add %addr, %k, %j
sll %addr, %addr, 2
.end_macro

.text
li $s0, 1#sum
li $s1, 8
li $s2, 7
li $a0, 1 #now
li $a1, 1 #r
jal bhh
li $v0, 10
syscall


bhh:
li $t0, 1 #i
loop1:
bgt $t0, $s1, endloop1
sll $t1, $t0, 2#addri
lw $t7, lie($t1)
bne $t7, 0, nextloop1
add $t2, $t0, $a1
sll $t2, $t2, 2 #addr r+i
lw $t6, zd($t2)
bne $t6, 0, nextloop1
addi $t3, $a1, 8
sub $t3, $t3, $t0
sll $t3, $t3, 2 #addr r-i+8
lw $t5, fd($t3)
bne $t5, 0, nextloop1
li $t4, 1
sw $t4, lie($t1)
sw $t4, zd($t2)
sw $t4, fd($t3)
getaddr($t5, $a1, $t0,$t6)
sw $t4, arr($t5)
bne $a0,8,else
addi $sp, $sp, -32
sw $ra 0($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $t0 12($sp)
sw $t1 16($sp)
sw $t2 20($sp)
sw $t3 24($sp)
sw $t5 28($sp)
jal print
lw $ra 0($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $t0 12($sp)
lw $t1 16($sp)
lw $t2 20($sp)
lw $t3 24($sp)
lw $t5 28($sp)
addi $sp, $sp, 32
j re
else:
addi $sp, $sp, -32
sw $ra 0($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $t0 12($sp)
sw $t1 16($sp)
sw $t2 20($sp)
sw $t3 24($sp)
sw $t5 28($sp)
addi $a0, $a0, 1
addi $a1, $a1, 1
jal bhh
lw $ra 0($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $t0 12($sp)
lw $t1 16($sp)
lw $t2 20($sp)
lw $t3 24($sp)
lw $t5 28($sp)
addi $sp, $sp, 32
re:
li $t4, 0
sw $t4, lie($t1)
sw $t4, zd($t2)
sw $t4, fd($t3)
sw $t4, arr($t5)
nextloop1:
addi $t0, $t0, 1
j loop1
endloop1:
jr $ra

print:
la $a0, no
li $v0, 4
syscall
move $a0, $s0
li $v0, 1
syscall
la $a0, enter
li $v0, 4
syscall
addi $s0, $s0, 1
li $t0, 1 #i
i:
bgt $t0, $s1,endi
li $t1, 1 #m
m:
bgt $t1, $s2, endm
getaddr($t2,$t0,$t1,$t6)
lw $a0, arr($t2)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t1, $t1, 1
j m
endm:
getaddr($t2,$t0,$t1,$t6)
lw $a0, arr($t2)
li $v0, 1
syscall 
la $a0, enter
li $v0, 4
syscall
addi $t0, $t0, 1
j i
endi:
jr $ra