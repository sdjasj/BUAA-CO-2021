li $1, 848
li $2, 8481
li $3, 447
li $4, 4878
li $5, 4876
li $6, 8979
li $7, 9741
li $8, 4871
li $9, 1409
li $10, 454
li $11, 47
li $12, 4721
li $13, 48787
li $14, 5989
li $15, 5987
li $16, 487
li $17, 5978
li $18, 47
li $19, 2021
li $20, 497
li $21, 587
li $22, 48
li $23, 488
li $24, 878
li $25, 487
li $26, 87
li $27, 481
li $28, 484
li $29, 4184
li $30, 48
li $31, 878
sb $1, 0($0)
sb $2, 1($0)
sb $3, 2($0)
sb $4, 3($0)
lh $4, 2($0)
sw $4, 0($0)
sh $5, 2($0)
sh $6, 4($0)
sh $7, 6($0)
lb $7, 5($0)
lb $7, 6($0)
lb $7, 7($0)
lb $8, 4($0)
sh $7, 6($0)
lbu $7, 5($0)
lbu $7, 6($0)
lbu $7, 7($0)
lbu $8, 4($0)
lhu $8, 6($0)
jal ddd
add $31, $1, $2
addi $15, $15, 1
ddd:
sw $31, 8($0)
jal d1
sw $31, 12($0)
lw $31, 0($0)
d1:
beq $31, $0,d2
li $31, 2
addi $31, $31, 5
d2:
li $31, 0

