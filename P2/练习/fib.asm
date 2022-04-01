.data
input: .asciiz "Please input the number N"
out: .asciiz "The answer is:"

.text
la $a0, input
li $v0, 4
syscall
li $v0, 5
syscall
move $a0, $v0
jal fib
move $s0, $v0
la $a0, out
li $v0, 4
syscall
move $a0, $s0
li $v0, 1
syscall
li $v0, 10
syscall

fib:
beq $a0, 1, endfib
beq $a0, 2, endfib
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $t0, 4($sp)
sw $t1, 8($sp)
sw $ra, 12($sp)
addi $a0, $a0, -1
jal fib
lw $a0, 0($sp)
lw $t0, 4($sp)
lw $t1, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
move $t0, $v0
addi $sp, $sp, -16
sw $a0, 0($sp)
sw $t0, 4($sp)
sw $t1, 8($sp)
sw $ra, 12($sp)
addi $a0, $a0, -2
jal fib
lw $a0, 0($sp)
lw $t0, 4($sp)
lw $t1, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16
move $t1, $v0
add $v0, $t0, $t1
jr $ra
endfib:
li $v0, 1
jr $ra