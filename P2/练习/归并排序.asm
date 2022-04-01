.data
a: .word 0:400
r: .word 0:400
space: .asciiz " "
.text
main:
li $v0, 5
syscall
move $s0, $v0
li $t0, 1
loopin1:
bgt $t0, $s0, endin1
li $v0, 5
syscall
sll $t1, $t0, 2
sw $v0, a($t1)
addi $t0, $t0, 1
j loopin1
endin1:
li $a0, 1 #l
move $a1, $s0 #s
jal qbsort
li $t0, 1
loopprint:
bgt $t0, $s0, endp1
sll $t1, $t0, 2
lw $a0, a($t1)
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall 
addi $t0, $t0, 1
j loopprint
endp1:
li $v0, 10
syscall


qbsort:
bne $a0, $a1, begin
jr $ra
begin:
add $t0, $a0, $a1
srl $t0, $t0, 1 #t0=mid
addi $sp, $sp, -16
#gbsort(l,mid)
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t0, 12($sp)
move $a1, $t0
jal qbsort
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t0, 12($sp)
addi $sp, $sp, 16
#gbsort(mid+1,s)
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $t0, 12($sp)
move $a0, $t0
addi $a0, $a0, 1
jal qbsort
lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $t0, 12($sp)
addi $sp, $sp, 16

move $t1, $a0#i = l
addi $t2, $t0, 1#j = mid+1
move $t3, $a0 #k = l
loop1:
bgt $t1, $t0, end1
bgt $t2, $a1, end1
sll $t4, $t1, 2
sll $t5 ,$t2, 2
lw $t6, a($t4) #ai
lw $t7, a($t5) #aj
bgt $t6, $t7, else1
sll $t4, $t3, 2
sw $t6, r($t4)
addi $t3, $t3, 1
addi $t1, $t1, 1
j loop1
else1:
sll $t5, $t3, 2
sw $t7, r($t5)
addi $t3, $t3, 1
addi $t2, $t2, 1
j loop1
end1:
bgt $t1, $t0, if2
loop2:
bgt $t1, $t0, if2
sll $t4, $t3, 2
sll $t5, $t1, 2
lw $t5, a($t5)
sw $t5, r($t4)
addi $t3, $t3, 1
addi $t1, $t1, 1
j loop2

if2:
bgt $t2, $a1, loop4b
loop3:
bgt $t2, $a1, loop4b
sll $t4, $t3, 2
sll $t5, $t2, 2
lw $t5, a($t5)
sw $t5, r($t4)
addi $t3, $t3, 1
addi $t2, $t2, 1
j loop3
loop4b:
move $t1, $a0
loop4:
bgt $t1, $a1, endfuc
sll $t4, $t1, 2
lw $t5, r($t4)
sw $t5, a($t4)
addi $t1, $t1, 1
j loop4
endfuc:
jr $ra