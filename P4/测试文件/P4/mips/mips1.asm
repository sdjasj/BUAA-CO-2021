li $s0, 3014
li $s1, 4813
li $s2, -25
li $t0, 0
sw $s0, 4($t0)
addiu $t0, $t0, 8
sw $s1, 16($t0)
lw $s4, -4($t0)
li $s6, 0x302c
jr $s6
li $2, 656
li $28 15446