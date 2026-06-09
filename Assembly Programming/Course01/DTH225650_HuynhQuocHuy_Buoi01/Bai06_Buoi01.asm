.data
msg_input1: .asciiz "Nhap so thu nhat: "
msg_input2: .asciiz "Nhap so thu hai: "
msg_input3: .asciiz "Nhap so thu ba: "
msg_output: .asciiz " Max cua ba so: "

line_brk: .asciiz "\n"

.text 
main:
 	#Nhap So Thu Nhat
 	la $a0,msg_input1
 	li $v0,4
 	syscall
 	
 	li $v0,5
 	syscall
 	move $t0,$v0  	#t0 la so thu nhat
 	
 	la $a0,line_brk
 	li $v0,4
 	syscall
 	
 	#Nhap so thu hai
 	la $a0,msg_input2
 	li $v0,4
 	syscall
 	
 	li $v0,5
 	syscall
 	move $t1,$v0  	#t1 la so thu hai
 	
 	la $a0,line_brk
 	li $v0,4
 	syscall
 	
 	#Nhap so thu ba
 	la $a0,msg_input3
 	li $v0,4
 	syscall
 	
 	li $v0,5
 	syscall
 	move $t2,$v0  	#t2 la so thu nhat
 	
 	la $a0,line_brk
 	li $v0,4
 	syscall
 	
 	#tim max
 	move $t3,$t0	#t3: max
 	bgt $t3,$t1,sosanh2
 	move $t3,$t1
 	
 	sosanh2: 
 	bgt $t3,$t2,exit
 	move $t3,$t2
 	
 	exit:
 	la $a0,msg_output
 	li $v0,4
 	syscall
 	
 	move $a0,$t3
 	li $v0,1
 	syscall
 	
 	li $v0,10
 	syscall
 	
 	
 	