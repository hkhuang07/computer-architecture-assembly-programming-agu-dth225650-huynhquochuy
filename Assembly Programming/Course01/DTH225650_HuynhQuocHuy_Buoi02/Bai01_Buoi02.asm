.data
msg_input: .asciiz "Nhap mot ki tu: "
msg_truoc: .asciiz "Ki tu lien truoc: "
msg_sau: .asciiz "Ki tu lien sau: "
line_brk: .asciiz "\n"
.text
main: 
	la $a0,msg_input
	li $v0,4
	syscall
	
	li $v0,12
	syscall
	
	move $t0,$v0	#$t0: ki tu nhap
	move $t1,$t0
	addi $t1,$t1,-1 #Ki tu lien truoc
	
	la $a0,line_brk
	li $v0,4
	syscall

	#Xuat ki tu lien truoc
	la $a0,msg_truoc
	li $v0,4
	syscall
	
	move $a0,$t1
	li $v0,11
	syscall
	
	move $t1,$t0
	addi $t1,$t1,1
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Xuat ki tu lien sau
	la $a0,msg_sau
	li $v0,4
	syscall
	
	move $a0,$t1
	li $v0,11
	syscall
	
	li $v0,10
	syscall
	
	
