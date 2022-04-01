lui $16, 0x2486
ori $16 0xff54
lui $12 0xffff
ori $12 0xffff
li $a0, 1
li $a1, -100
jal dfs
move $s6, $v0
li $t9, 3114
j no


dfs:
move $t0, $a1
l1:
bgez $t0, end
addiu $t0, $t0, 1
j l1
end:
addiu $v0, $t0, 26
addiu $t0, $t0, 11
jr $ra
no:
