.data
msg_in: .asciiz " Nhap so N : "
msg_out: "/n Xuat: "
msg_out1: .asciiz " N chia het cho 3 "
msg_out2: .asciiz " N Khong chia het cho 3"

line_brk: .asciiz "\n"

.text
main: 
	la $a0,msg_in
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	move $t1,$v0 	#$t0 chua so nguyen
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	la $a0,msg_out
	li $v0,4
	syscall
	
	move $a0,$t1
	li $v0,1
	syscall
	
	#Xu Ly Thong Tin
	li $t1,3
	
	div $t0,$t1
	
	mfhi $t2
	bnez $t2,msg_out2
	
	la $a0,msg_out1
	li $v0,4
	syscall
	
	j exit
	
	la $a0,msg_out2
	li $v0,4
	syscall
	
	exit:
	li $v0,10
	syscall
	
	