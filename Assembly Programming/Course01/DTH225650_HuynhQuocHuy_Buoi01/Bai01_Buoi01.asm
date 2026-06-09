.data
msg_input1: .asciiz "Nhap so thu nhat: "
msg_input2: .asciiz "Nhap so thu hai: "
msg_thuong: .asciiz "Thuong so la: "
msg_du: .asciiz " So du la: "

line_brk: .asciiz "\n"

.text
main:
	# li: load int 
	#la: load arr
	#move #add: + #sub: -
	#Nhap ki tu thu nhat
	la $a0,msg_input1  
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	move $t1,$v0 #$t1 ki tu thu nhat----
	
	la $a0,msg_input2
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	move $t2,$v0 #$t2 ki tu thu hai-----
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#thuong-----------------------------
	div $t1,$t2   # lo: thuong  hi: du
	
	la $a0,msg_thuong
	li $v0,4
	syscall
	
	mflo $a0 #thuong so
	li $v0,1
	syscall
	
	la $a0,line_brk
	li $v0,4
	 
	#sodu--------------------------------
	la $a0, msg_du
	li $v0,4
	syscall
	
	mfhi $a0 #so du
	li $v0,1
	syscall
	
	li $v0,10
	syscall
	
