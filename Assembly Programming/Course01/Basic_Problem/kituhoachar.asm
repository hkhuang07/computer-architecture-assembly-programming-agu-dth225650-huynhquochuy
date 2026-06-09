.data
input: .asciiz "Nhap vao mot ki tu: "
output: .asciiz "Ky tu sau khi chuyen sang chu hoa: "
khong_chu: .asciiz "Ky tu vua nhap vao khong phai chu: "
line_brk: .asciiz "\n"
.globl main
.text
main: 
	# NHẬP
	la $a0,input
	li $v0, 4
	syscall
	
	li $v0,12
	syscall
	
	move $t0,$v0
	
	la,$a0,line_brk
	li $v0,4
	syscall
	
	# XỬ LÝ VÀ XUẤT
	blt $t0,'A',khonghoa
	bgt $t0,'Z',khonghoa
	
	la $a0,output
	li $v0,4
	syscall
	
	move $a0,$t0
	li $v0,11
	syscall
	
	la,$a0,line_brk
	li $v0,4
	syscall
	
	j exit
	
	khonghoa:
	bgt $t0,'z',khongthuong
	blt $t0,'a',khongthuong
	
	addi $t0,$t0,-32
	
	la $a0,output
	li $v0,4
	syscall
	
	move $a0,$t0
	li $v0,11
	syscall
	
	la,$a0,line_brk
	li $v0,4
	syscall
	
	j exit
	
	khongthuong:
	la $a0,khong_chu
	li $v0,4
	syscall
	
	exit:
	li $v0,10
	syscall
	
	
	