.data
a: .word 0:500
bb: .word 0:500
c: .word 0:2000
.macro getadd(%ans,%i)
	sll %ans, %i, 2
.end_macro
.macro dushu(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
 .end_macro 
.text
dushu($s0) #lens1
dushu($s1) #lens2
li $t0, 0
in1:
bge $t0, $s0, endin1
li $v0, 5
syscall
sll $t1, $t0, 2
sw $v0, a($t1)
addi $t0, $t0, 1
j in1
endin1:
li $t0, 0
addi $t1, $s0, -1
tran1:
bge $t0, $t1, endt1
sll $t2, $t0, 2
lw $t3, a($t2)
sll $t2, $t1, 2
lw $t4, a($t2)
sw $t3, a($t2)
sll $t2, $t0, 2
sw $t4, a($t2)
addi $t0, $t0, 1
addi $t1, $t1, -1
j tran1
move $t0, $s0
endt1:
addi $t0, $s0,-1
tt:
blt $t0, 0, endtt
getadd($t1, $t0)
lw $t2, a($t1)
addi $t3, $t0, 1
getadd($t3, $t3)
sw $t2, a($t3)
addi $t0, $t0, -1
j tt
endtt:
li $t0, 0
in2:
bge $t0, $s1, endin2
li $v0, 5
syscall
sll $t1, $t0, 2
sw $v0, bb($t1)
addi $t0, $t0, 1
j in2
endin2:
li $t0, 0
addi $t1, $s1, -1
tran2:
bge $t0, $t1, endt2
sll $t2, $t0, 2
lw $t3, bb($t2)
sll $t2, $t1, 2
lw $t4, bb($t2)
sw $t3, bb($t2)
sll $t2, $t0, 2
sw $t4, bb($t2)
addi $t0, $t0, 1
addi $t1, $t1, -1
j tran2
endt2:
addi $t0, $s1,-1
ttt:
blt $t0, 0, endttt
getadd($t1, $t0)
lw $t2, bb($t1)
addi $t3, $t0, 1
getadd($t3, $t3)
sw $t2, bb($t3)
addi $t0, $t0, -1
j ttt
endttt:

li $t0, 1#i
js1:
bgt $t0, $s0, endjs1
li $t1, 0#k
li $t2, 1 #m
	js2:
	bgt $t2, $s1, endjs2
	add $t3, $t0, $t2
	addi $t3, $t3, -1 #i+m-1
	getadd($t4, $t3) #addr i+m-1
	lw $t5, c($t4)
	getadd($t6, $t0)
	lw $t6, a($t6)
	getadd($t7,$t2)#m
	lw $t7, bb($t7)
	mul $t6, $t6, $t7
	add $t5, $t5, $t1
	add $t5, $t5, $t6
	sw $t5, c($t4) #ci+m-1
	li $t6, 10
	div $t5, $t6
	mflo $t1
	mfhi $t6 #%10
	sw $t6, c($t4)
	addi $t2, $t2, 1
	j js2
	endjs2:
	add $t3, $t0, $s1
	getadd($t4, $t3)
	sw $t1, c($t4)
	addi $t0, $t0, 1
	j js1
endjs1:
add $s2, $s0, $s1#lenc
lq:
getadd($t0,$s2)
lw $t0, c($t0)
bne $t0, $0, endlq
ble $s2, 1, endlq
addi $s2, $s2, -1
j lq
endlq:
move $t1, $s2#i
prin:
blt $t1, 1, endprin
getadd($t2, $t1)
lw $a0, c($t2)
li $v0, 1
syscall
addi $t1, $t1, -1
j prin
endprin:
li $v0, 10
syscall

