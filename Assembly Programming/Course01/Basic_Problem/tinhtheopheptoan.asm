.data
inputx: .asciiz "Nhap X: "
inputy: .asciiz "Nhap Y: "
inputk: .asciiz "Nhap phep toan: "
output: .asciiz "Ket qua: "
khonghople: .asciiz "Khong hop le: "
line_brk: .asciiz "\n"
.globl main
.text
main: 
	la $a0,inputx
	li $v0,4
	syscall
	
	li $v0,5
	syscall			# NHẬP VÀ LƯU X
	
	move $t0,$v0		# LƯU X VÀO $T0
	
	la $a0,inputy
	li $v0,4
	syscall
	
	li $v0,5
	syscall			# NHẬP VÀ LƯU Y
	
	move $t1,$v0		# LƯU Y VÀO $T1
	
	la $a0,inputk
	li $v0,4
	syscall
	
	
	li $v0,12
	syscall			# NHẬP VÀ LƯU PHÉP TOÁN
	
	move $t2,$v0		# LƯU PHÉP TOÁN VÀO $t2
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	# XỬ LÝ
	bne $t2,'+',kiemtrapheptru
	
	add $t5,$t0,$t1
	
	la $a0,output
	li $v0,4
	syscall
	
	li $v0,1
	move $a0,$t5
	syscall
	
	j exit
	
	kiemtrapheptru: 
	bne $t2,'-',khong_hop_le
	
	sub $t5,$t0,$t1
	
	li $v0,1
	move $a0,$t5
	syscall
	
	j exit
	
	khong_hop_le:
	
	la $a0,khonghople
	li $v0,4
	syscall
	
	exit:
	
	li $v0,10
	syscall
	
	
	
	
	
	
	
