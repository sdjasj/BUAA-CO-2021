.data 
enter: .asciiz "\n"
Move: .asciiz "->"
a: .ascii "a"
bb: .ascii "b"
c: .ascii "c"


.text
main:
li $v0, 5
syscall
move $s0, $v0
lb $a0, a
lb $a1, bb
lb $a2, c
move $a3, $s0  #a0=a,a1=b,a2=c,a3 = n
jal hnt
li $v0, 10
syscall

hnt:
bne $a3, $0, else_1
jr $ra
else_1:
addi $sp, $sp, -20
sw $ra, 0($sp)
sb $a0, 4($sp)
sb $a1, 8($sp)
sb $a2, 12($sp)
sb $a3, 16($sp)
addi $a3, $a3, -1
move $t0, $a1
move $a1, $a2
move $a2, $t0
jal hnt
lw $ra, 0($sp)
lb $a0, 4($sp)
lb $a1, 8($sp)
lb $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20 #printf
li $v0, 11
syscall
move $t1, $a0 #t1 = a0
la $a0, Move
li $v0, 4
syscall
move $a0, $a2
li $v0, 11
syscall
la $a0, enter
li $v0, 4
syscall
move $a0, $t1
addi $sp, $sp, -20
sw $ra, 0($sp)
sb $a0, 4($sp)
sb $a1, 8($sp)
sb $a2, 12($sp)
sb $a3, 16($sp)
move $t2, $a0
move $a0, $a1
move $a1, $t2
addi $a3, $a3, -1
jal hnt
lw $ra, 0($sp)
lb $a0, 4($sp)
lb $a1, 8($sp)
lb $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20
jr $ra



