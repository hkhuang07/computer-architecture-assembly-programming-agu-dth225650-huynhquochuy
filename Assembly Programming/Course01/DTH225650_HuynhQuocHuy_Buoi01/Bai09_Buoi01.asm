.data
input: .asciiz "Nhap mot so nguyen: "
output: .asciiz "/n Tong: "
.globl main
.text
main:
	#In Nhan Input
	li $v0,4	
	la $a0,input	
	syscall

	li $v0,5	
	syscall
	
	move $t0,$v0	# t0 = n
	mult $t0,$t0
	mflo $t3	# t3 =n*n
	
	li $t2,0
	move $t0,$t1 	# t1 = n*n
	# Vong Lap
	loop:
	add $t2,$t2,$t1		#	0=0+n*n
	addi $t1,$t1,1		#	n*n=n*n+1
	bgt $t1,$t3,exit_loop	#	(n*n)i <n*n
	j loop
	#Thoat Vong Lap
	#In Nhan Out
	exit_loop:
	li $v0,4		
	la $a0,output
	syscall
	#Ketqua
	li $v0,1
	move $a0,$t2
	syscall
	
	li $v0,10
	syscall
