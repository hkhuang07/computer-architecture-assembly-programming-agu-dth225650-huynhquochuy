.data 
input: .asciiz "Nhap vao mot chuoi: "
output: .asciiz "Chuoi chuyen sang chu thuong: "
line_brk: .asciiz "\n"
str: .space 1024
.globl main
.text
main: 
	#NHẬP
	la $a0,input
	li $v0,4
	syscall
	
	la $a0,str
	li $a1,1024
	li $v0,8
	syscall
	
	#XỬ LÝ
	la $t2,str
	
	loop:
	lb $t1,($t2)
	beqz $t1,exit
	
	# KIỂM TRA KÍ TỰ CHỮ 
	blt $t1,'A',giunguyen
	bgt $t1,'z',giunguyen
	add $t1,$t1,0x20
	sb $t1,($t2)
	
	giunguyen: 
	addi $t2,$t2,1
	
	j loop
	
	#XUẤT
	exit:
	la $a0,line_brk
	li $v0,4
	syscall
	
	la $a0,output
	li $v0,4
	syscall
	
	la $a0,str
	li $v0,4
	syscall
	
	li $v0,10
	syscall
	