.data
msq_input: .asciiz "Nhap So nguyen duong N: "
msq_output: .asciiz "/n Xuat: "
msq_sole: .asciiz " N la so le "
msq_sochan: .asciiz " N la so chan "
.globl main
.text
main:
	li $t0,4
	la $a0,msq_input
	syscall
	
	li $v0,5
	syscall
	
	move $t0,$v0 	#t0: n
	
	li $t1,2
	# Chia $t0 cho $t1   
	#lo: thuong so 		
	div $t0,$t1	
	
	mfhi $t2
	beqz $t2,msq_sochan
	
	#la so le
	li $v0,4
	la $a0,msq_output
	syscall
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,msq_sole
	syscall
	
	j exit
	
	#la so chan
	li $v0,4
	la $a0,msq_output
	syscall
	
	li $v0,1
	move $a0,$t0
	syscall
	
	li $v0,4
	la $a0,msq_sochan
	syscall
	
	exit:
	li $v0,10
	syscall
	
	
