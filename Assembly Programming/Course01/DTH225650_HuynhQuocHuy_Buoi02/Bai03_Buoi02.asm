.data
msg_input: .asciiz "Nhap vao mot ki tu: "
msg_output: .asciiz "Ket qua: "
msg_so: .asciiz  " La So"
msg_khongso: .asciiz " Khong la so"
line_brk: .asciiz "\n"
.globl main
.text
main:
	# Nhap
	la $a0,msg_input
	li $v0, 4
	syscall			#Xuat nhan nhap mot ki tu
	
	li $v0,12
	syscall			#Xuat ki tu
	
	move $t0,$v0		#$t0 = kí tự vừa nhập
	 
	li $v0, 4 
	la $a0,line_brk
	syscall 		#Xuat nhan xuong dong
	
	# Xu ly  
	blt $t0, '0',khong_so	# < 0 không là số
	bgt $t0, '9',khong_so	# > 9 không là số

	la $a0, msg_output
	li $v0, 4
	syscall			# In nhan Ket qua
	
	move $a0, $t0	
	li $v0,11
	syscall			#In so đã nhập
	
	la $a0, msg_so
	li $v0,4
	syscall			#In nhan la so
	
	j exit
	
	khong_so: 
	la $a0, msg_output
	li $v0,4
	syscall			# In nhãn kết quả
	
	move $a0,$t0
	li $v0,11
	syscall			#In Kí Tự không là số vừa nhập
	
	la $a0,msg_khongso
	li $v0,4
	syscall			#In nhãn không là số
	
	exit: 
	li $v0,10
	syscall			#In ký tự vừa nhập
	
