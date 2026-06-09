.data
	msg_num1: .asciiz "Enter a:  "
	msg_num2: .asciiz "Enter b: "
	msg_quotient: .asciiz "Quotient: "
	msg_remainder: .asciiz "Remainder: "
	line_brk: .asciiz "\n"
.text
.global main

main:
	#In mảng nhập số a
	la $a0,msg_num1
	li $v0,4
	syscall
	
	#Nhập số a
	li $v0,5
	syscall
	#Lưu vào $t0
	move $t0,$v0
	
	#linebrk
	la $a0,line_brk
	li $v0,4
	syscall
	
	# In mảng nhập số b
	la $a0,msg_num2
	li $v0,4
	syscall
	
	#Nhập số b
	li $v0,5
	syscall

	#Lưu vào $t1
	move $t1,$v0
	
	#linebrk
	la $a0,line_brk
	li $v0,4
	syscall
	
	
	#Lấy a chia cho b
	div $t0,$t1
	
	
	# In kết quả
	#In thương số
	la $a0,msg_remainder
	li $v0,4
	syscall
	
	mfhi $a0
	
	li $v0,1
	syscall
	
	#linebrk
	la $a0,line_brk
	li $v0,4
	syscall
	
	#In số dư
	la $a0,msg_quotient
	li $v0,4
	syscall
	
	mflo $a0
	
	li $v0,1
	syscall
	
	#Kết thúc chương trình
	li $v0,10
	syscall
	
	
	
	