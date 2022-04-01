.data
arr1: .word 0:400
arr2: .word 0:400
arr3: .word 0:400
space: .asciiz " "
enter: .asciiz "\n"
.macro getadd (%ans,%i,%j)
	mul %ans, %i, 10
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro 

.text
main:
	li $v0, 5
	syscall
	move $s0, $v0 #n
	li $t0,0
	in1:bge $t0, $s0, endin1
		li $t1, 0
		in2:bge $t1, $s0, endin2
			li $v0, 5
			syscall
			getadd ($t2,$t0,$t1)
			sw $v0, arr1($t2)
			addi $t1, $t1, 1
			j in2
		endin2:
		addi $t0, $t0, 1
		j in1
	endin1:li $t0, 0
	in3:bge $t0, $s0, endin3
		li $t1, 0
		in4:bge $t1, $s0, endin4
			li $v0, 5
			syscall
			getadd ($t2,$t0,$t1)
			sw $v0, arr2($t2)
			addi $t1, $t1, 1
			j in4
		endin4:
		addi $t0, $t0, 1
		j in3
	endin3:
		li $t0, 0
	cheng1:bge $t0, $s0, endcheng1
		   li $t1, 0
		   cheng2:bge $t1, $s0, endcheng2
		   		  li $t2, 0
		   		  li $t3, 0
		   		  cheng3: bge $t2, $s0,endcheng3
		   				  getadd ($t4,$t0,$t2)
		   				  lw $t5, arr1($t4)
		   				  getadd ($t4, $t2, $t1)
		   				  lw $t6, arr2($t4)
		   				  mul $t7, $t5, $t6
		   				  add $t3, $t3, $t7
		   				  addi $t2,$t2, 1
		   				  j cheng3
		   		  endcheng3:
		   		  getadd ($t4,$t0,$t1)
		   		  sw $t3, arr3($t4)
		   		  addi $t1, $t1, 1
		   		  j cheng2
		   endcheng2:
		   addi $t0, $t0, 1
		   j cheng1
	endcheng1:
			li $t0, 0
			prin1:bge $t0, $s0, endp1
			li $t1, 0
			prin2:bge $t1, $s0, endp2
				  getadd($t3, $t0,$t1)
				  lw $a0, arr3($t3)
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
				addi $t0, $t0, 1
				j prin1
			endp1:
				li $v0, 10
				syscall



