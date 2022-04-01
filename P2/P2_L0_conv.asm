.data
f: .word 0:400
g: .word 0:400
h: .word 0:400
space: .asciiz " "
enter: .asciiz "\n"
.macro getadd(%ans,%i,%j)
	sll %ans, %i, 4
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro 
.macro dushu (%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro 


.text
dushu($s0)#m1
dushu($s1)#n1
dushu($s2)#m2
dushu($s3)#n2
li $t0, 0
in1:
bge $t0, $s0,endin1
	li $t1, 0
	in2:
		bge $t1, $s1,endin2
		li $v0, 5
		syscall
		getadd($t2,$t0,$t1)
		sw $v0, f($t2)
		addi $t1,$t1,1
		j in2
		endin2:
		addi $t0, $t0, 1
		j in1
endin1:
li $t0, 0
in3:
bge $t0, $s2,endin3
	li $t1, 0
	in4:
		bge $t1, $s3,endin4
		li $v0, 5
		syscall
		getadd($t2,$t0,$t1)
		sw $v0, h($t2)
		addi $t1,$t1,1
		j in4
		endin4:
		addi $t0, $t0, 1
		j in3
endin3:
sub $s4, $s0, $s2#m1-m2
addi $s4, $s4, 1
sub $s5, $s1, $s3#n1-n2
addi $s5, $s5, 1
li $t0,0 #i
js1:bge $t0, $s4, endjs1
	li $t1, 0#j
	js2:bge $t1, $s5, endjs2
	li $t2, 0#ans
	#jisuan 1 ge
	li $t3,0#k
	t1:add $t9, $t0, $t3#i+k
	   bge $t9, $s0, endt1
	   li $t4, 0#l
	   t2:add $t8, $t1, $t4#j+l
	   	  bge $t8, $s1, endt2
	   	  getadd($t5,$t9,$t8)
	   	  lw $t5, f($t5)
	   	  getadd($t6,$t3,$t4)
	   	  lw $t6, h($t6)
	   	  mul $t7, $t5,$t6
	   	  add $t2, $t2, $t7
	   	  addi $t4, $t4, 1
	   	  j t2
	   	  endt2:
	   addi $t3, $t3, 1
	   j t1
	   endt1:
	   getadd($t3,$t0,$t1)
	   sw $t2, g($t3)
	   addi $t1, $t1, 1
	   j js2
	endjs2:
	addi $t0, $t0, 1
	j js1
endjs1:
li $t0, 0
prin1:
bge $t0, $s4, endp1
	li $t1, 0
	prin2:bge $t1, $s5, endp2
	getadd($t2,$t0,$t1)
	lw $a0, g($t2)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	addi $t1, $t1, 1
	j prin2
	endp2:
	la $a0, enter
	li $v0, 4
	syscall
	addi $t0, $t0,1
	j prin1
endp1:
li $v0, 10
syscall