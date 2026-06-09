.data
input: .asciiz "Nhap vao mot ki tu "
ketqua: .asciiz "Ket qua: "
laso: .asciiz " Kí tu vua nhap la so. "
khongso: .asciiz " Ki tu vua nhap khong la so "
line_brk: .asciiz "\n"
.globl main 
.text
main:
	# NHẬP
	la $a0,input
	li $v0,4
	syscall
	
	li $v0,12
	syscall
	
	move $t0,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	# XỬ LÝ
	blt $t0,'0',khonglaso
	bgt $t0,'9',khonglaso
	
	la $a0,ketqua
	li $v0,4
	syscall
	
	la,$a0,laso
	li $v0,4
	syscall
	
	j exit
	
	khonglaso:
	la $a0,khongso
	li $v0,4
	syscall
	
	la $a0,line_brk
	li $v0,4
	syscall
	 
	 exit:
	 li $v0,10
	 syscall
	
	