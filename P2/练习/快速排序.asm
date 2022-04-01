#input number n
#then input 0~n-1 number to sort
.macro getaddr (%addr, %i)
sll %addr, %i, 2
.end_macro

.data
arr: .word 0:100
space: .asciiz " "

.text
li $v0, 5
syscall
move $s0, $v0
li $t0, 0
loopin:#input
bge $t0, $s0, endin
li $v0, 5
syscall
getaddr($t1, $t0)
sw $v0, arr($t1)
addi $t0, $t0, 1
j loopin
endin:#use func
li $a0, 0
addi $t0, $s0, -1
move $a1, $t0
jal qsort
li $t0, 0
output:
bge $t0, $s0, endout
getaddr($t1, $t0)
lw $a0, arr($t1)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
addi $t0, $t0, 1
j output
endout:
li $v0, 10
syscall

qsort:
move $t0, $a0 #i = m
move $t1, $a1#k = n
add $t2, $t0, $t1
srl $t2, $t2, 1
sll $t2, $t2, 2
lw $t3, arr($t2) #mid = arr[(m+n)/2]
do:
w1:
getaddr ($t4,$t0)
lw $t4, arr($t4) #arr[i]
bge $t4, $t3, w2
addi $t0, $t0, 1
j w1
w2:
getaddr ($t5,$t1)
lw $t5, arr($t5) #arr[k]
ble $t5, $t3, swap
addi $t1, $t1, -1
j w2
swap:
bgt $t0, $t1, dowhile
move $t6, $t4
getaddr ($t4,$t0)
sw $t5, arr($t4)
getaddr ($t5,$t1)
sw $t6, arr($t5)
addi $t0, $t0, 1
addi $t1, $t1, -1
dowhile:
ble $t0, $t1, do
endw:
bge $t0, $a1, q2
addi $sp, $sp, -20
sw $ra 0($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $t0 12($sp)
sw $t1 16($sp)
move $a0, $t0
jal qsort
lw $ra 0($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $t0 12($sp)
lw $t1 16($sp)
addi $sp, $sp, 20
q2:
ble $t1, $a0, endq
addi $sp, $sp, -20
sw $ra 0($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $t0 12($sp)
sw $t1 16($sp)
move $a1, $t1
jal qsort
lw $ra 0($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $t0 12($sp)
lw $t1 16($sp)
addi $sp, $sp, 20
endq:
jr $ra
