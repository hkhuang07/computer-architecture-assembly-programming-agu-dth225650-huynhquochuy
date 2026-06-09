.data
	msg_num1: .asciiz "Enter number 1: "
	msg_num2: .asciiz "Enter number 2: "
	msg_num3: .asciiz "Enter number 3: "
	line_brk: .asciiz "\n"
	msg_max: .asciiz "Max of 3 number is: "
.text
.global main
main:
	#In nhập số 
	la $a0,msg_num1
	li $v0,4
	syscall
	#Nhập số
	li $v0,5
	syscall
	#Lưu số
	move $t0,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#In nhập số 
	la $a0,msg_num2
	li $v0,4
	syscall
	#Nhập số
	li $v0,5
	syscall
	#Lưu số
	move $t1,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#In nhập số 
	la $a0,msg_num3
	li $v0,4
	syscall
	
	#Nhập số
	li $v0,5
	syscall
	#Lưu số
	move $t2,$v0
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Lưu max = số 1
	move $s0,$t0
	
	#So sánh 1 và 2 nếu 1 lớn hơn chuyền đến so sánh với 3
	bge $s0,$t1,Branche3
	move $s0,$t1
	
	#So sánh với 3 nếu 1 lớn hơn chuyển đến in kết luận
	Branche3:
	bge $s0,$t2,Print
	move $s0,$t2
	
	Print:
	#In kết luận
	la $a0,msg_max
	li $v0,4
	syscall
	
	move $a0,$s0
	
	li $v0,1
	syscall
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#Kết thúc chương trình
	li $v0,10
	syscall
	
	