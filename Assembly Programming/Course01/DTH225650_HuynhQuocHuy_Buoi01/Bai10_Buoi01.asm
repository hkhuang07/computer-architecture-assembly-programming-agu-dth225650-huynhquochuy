.data
input: .asciiz "Nhap mot so nguyen: "
output: .asciiz "/n Tong: "
.globl main 
.text
main: 
	#In Nhan Input
	li $v0, 4
	la $a0, input
	syscall			#In nhãn nhập
	
	li $v0, 5
	syscall			#in Só Vừa Nhập
	
	move $t0,$v0	# Luu N vao $t0
	
	loop:
	add $t0,$t0,1
	addi $t1,$t1,1
	bgt $t1, $t0, exit_loop
	j loop
	
	exit_loop:
	li $v0,4
	la $a0, output
	syscall
	 	
	move $a1,$t1
	syscall
	
	li $v0,10
	syscall
