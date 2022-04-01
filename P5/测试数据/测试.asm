ori $28, 0
ori $29, 0
#data
li $8, 1
li $9, 11
li $10, 111
li $11, 1111
li $12, 11111
li $13, 111111
li $14, 1111111
li $15, 11111111
##addr
ori $16, 0
ori $17, 20
ori $18, 40
ori $19, 60
ori $20, 80
ori $21, 100
sw $8, 0($16)
sw $9, 4($16)
sw $10, 8($16)
sw $11, 12($16)
sw $12, 16($16)
sw $13, 20($16)
sw $14, 24($16)
sw $15, 28($16)
##zhuanfa
## 1 
lw $1, 0($16)
sw $1, 8($17)
nop
## 2
lw $2, 4($16)
addu $10, $10, $11
sw $2, 0($18)
# 3
addu $1, $3, $4
subu $2, $4, $3
ori $3, 151
sw $1, 16($16)
#stall
#4
ori $4, 4
sw $4, 0($0)
nop
nop
nop
##
lw $17, 0($0)
sw $4, 0($17)
##
#5
addu $7, $8, $9
##
addu $6, $8, $9
beq $6, $7, branch1
##
subu $3, $14, $15
nop
ori $25, 56
branch1:
#6
jal branch2
addu $31, $31, $31
#
nop
branch2:
subu $31, $31, $26
ori $31, 0x30e8
nop
nop
nop
nop
##
lw $4, 0($0)
beq $6, $4, branch2
##
nop
lw $4, 0($0)
ori $1, 0
beq $6, $4, branch2






