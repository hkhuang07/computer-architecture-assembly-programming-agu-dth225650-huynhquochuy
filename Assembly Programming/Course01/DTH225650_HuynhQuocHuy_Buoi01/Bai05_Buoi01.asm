.data
msg_input1: .asciiz "Nhap so thu nhat: "
msg_input2: .asciiz "Nhap so thư hai: "
msg_input3: .asciiz "Nhap so thu ba: "
msg_tich: .asciiz "Tich ba so vua nhap "
line_brk: .asciiz "/n "
.globl main
.text
main: 
	#Nhap so thu nhat
	la $a0,msg_input1
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Nhap sp thu hai
	la $a0,msg_input2
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Nhap so thu ba
	la $a0,msg_input3
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t2,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Tich
	mul $t3,$t0,$t1
	mul $t3,$t3,$t2
	
	#Ketqua
	la $a0,msg_tich
	li $v0,4
	syscall
	
	move $a0,$t3
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
