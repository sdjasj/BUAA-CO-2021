.data
jt: .asciiz "------->"
enter: .asciiz "\n"
tab: .asciiz "\t"
total: .asciiz "Total:"

.text 
loop:
li $v0, 5
syscall
move $s1, $v0 #n
beq $s1, $0, endl
la $a0, enter
li $v0, 4
syscall
syscall
li $s0, 0#i
move $a0, $s1
li $a1 'A'
li $a2, 'C'
li $a3, 'B'
jal movetower
la $a0, tab
li $v0, 4
syscall
la $a0, total
li $v0, 4
syscall
move $a0, $s0
li $v0, 1
syscall
la $a0, enter
li $v0, 4
syscall
syscall
j loop
endl:
li $v0, 10
syscall


movetower:
bne $a0, 1, else
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
move $a0, $a1
move $a1, $a3
jal movedisk
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $s3, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
move $a0, $a3
move $a1, $a2
jal movedisk
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $s3, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra
else:
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
addi $a0, $a0, -1
jal movetower
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
move $a0, $a1
move $a1, $a3
jal movedisk
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
addi $a0, $a0, -1
move $t0, $a1
move $a1, $a2
move $a2, $t0
jal movetower
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
move $a0, $a3
move $a1, $a2
jal movedisk
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
addi $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
addi $a0, $a0, -1
jal movetower
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
lw $ra, 16($sp)
addi $sp, $sp, 20
jr $ra

movedisk:
addi $s0, $s0, 1
li $v0, 11
syscall
la $a0, jt
li $v0, 4
syscall
move $a0,$a1
li $v0, 11
syscall
la $a0, enter
li $v0, 4
syscall
jr $ra