.data
input1: .asciiz "Nhap chieu rong hinh chu nhat: "
input2: .asciiz "Nhap chieu dai hinh chu nhat: "
output: .asciiz "Chu vi hinh chu nhat: "
output2: .asciiz "Dien tich hinh chu nhat: "
line_brk: .asciiz "\n"
.text
main: 
	#Nhap chieu rong
	la $a0,input1
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0 	#t0: chieu rong
	
	#nhap chieu dai
	la $a0,input2
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0    #1: chieu dai
	
	#Tinh chu vi
	add $t2,$t0,$t1 #tinh chu vi
	li $t3,2
	mul $t2,$t2,$t3
	
	#Tinh dien tich 
	mul $t4,$t0,$t1
	
	#Xuat ket qua
	la $a0,output 	# Xuat chu vi
	li $v0,4
	syscall
	
	move $a0,$t2
	li $v0,1
	syscall
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	la $a0,output2	#Xuat dien tich
	li $v0,4
	syscall
	
	move $a0,$t4
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
