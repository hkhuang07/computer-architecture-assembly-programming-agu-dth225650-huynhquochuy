.data
	msg_char: .asciiz "Enter charater: "
	msg_result: .asciiz "Result: "
	msg_isnum: .asciiz " is number! "
	msg_notnum: .asciiz " isn't number! "
	line_brk: .asciiz "\n"
.text
.globl main
main:
	#In mảng nhập
	la $a0,msg_char
	li $v0,4
	syscall
	#Nhập kí tự mã ct = 12
	li $v0,12
	syscall
	
	#lưu kt
	move $t0,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#In mảng kết quả
	la $a0,msg_result 
	li $v0,4
	syscall
	#In ký tự
	move $a0,$t0
	li $v0,11
	syscall
	
	#Lưu 9 và 0
	li $s0,'0'
	li $s1,'9'
	
	#So sanh char < 0 ? Không là số
	blt $t0,$s0,IsnotNumber
	#So sanh char > 9 ? Không là số
	bgt $t0,$s1,IsnotNumber
	
	#La so
	la $a0,msg_isnum
	li $v0,4
	syscall
	j exit

	#Khong la so
	IsnotNumber:
	la $a0,msg_notnum
	li $v0,4
	syscall
	
	exit:
	
	