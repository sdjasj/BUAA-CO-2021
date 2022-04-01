.data
pno: .asciiz "no"
pyes: .asciiz "yes"

.text
li $v0, 5
syscall
move $s0, $v0
move $a0, $s0
jal nz
move $s1, $v0
move $s0,$a0
jal prime
move $s2,$v0
move $a0, $s1
jal prime
move $s3,$v0
bne $s2,1,no
bne $s3,1,no
la $a0, pyes
li $v0, 4
syscall
j end
no:
la $a0, pno
li $v0, 4
syscall
end:
li $v0, 10
syscall



nz:
li $t0, 0
li $t7,10
loopnz:
beq $a0, 0, endnz
div $a0, $t7
mflo $a0
mfhi $t2
mul $t0, $t0, 10
add $t0, $t0, $t2
j loopnz
endnz:
move $v0, $t0
jr $ra


prime:
beq $a0, 1, primeno
beq $a0, 2, primeyes
beq $a0, 3, primeyes
li $t0, 2
loopprime:
mul $t1, $t0, $t0
bgt $t1, $a0, primeyes
div $a0,$t0
mfhi $t2
beq $t2, 0, primeno
addi $t0, $t0,1
j loopprime
primeyes:
li $v0,1
jr $ra
primeno:
li $v0, 0
jr $ra