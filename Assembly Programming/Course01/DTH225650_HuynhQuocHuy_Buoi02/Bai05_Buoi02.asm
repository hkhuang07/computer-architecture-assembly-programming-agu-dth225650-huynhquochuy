.data
msg_input: .asciiz "Nhap mot chuoi: "
msg_output: .asciiz " Chuyen sang chuoi thuong la: "
str: .space 1024
linebrk: .asciiz "\n"
.text
main: 
	la $a0,msg_input
	li $v0,4
	syscall				#Xuat nhãn Nhập chuỗi
	
	la $a0,str
	li $a1,1024	
	li $v0,8			#Lưu chuỗi
	syscall
	
	#t1: chua ki tu hien hanh
	#t2: chua dia chi cua ki tu hien hanh
	la $t2,str
	
	loop:
	lb $t1,($t2)
	beqz $t1,exit
	
	#Kiem tra chu hoa
	blt $t1,'A',giuNguyen
	bgt $t1,'z',giuNguyen
	addi $t1,$t1,0x20
	sb $t1, ($t2)
	
	giuNguyen:
	addi $t2,$t2,1
	
	j loop
	 
	exit:
	#Xuat chuỗi thường
	li $v0,4
	la $a0,linebrk
	syscall	
	
	li $v0,4
	la $a0,msg_output
	syscall
	
	li $v0,4
	la $a0,str
	syscall
	
	li $v0,10
	syscall