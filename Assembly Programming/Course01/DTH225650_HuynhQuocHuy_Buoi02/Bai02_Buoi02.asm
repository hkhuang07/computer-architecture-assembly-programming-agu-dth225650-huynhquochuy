.data
msg_nhapx: .asciiz "Nhap X: "
msg_nhapy: .asciiz "Nhap Y: "
msg_phep: .asciiz "Nhap phep toan: "
msg_not: .asciiz "Phep toan nhap vao khong hop le: "
msg_ketqua: .asciiz "Ket qua: "
msg_linebrk: .asciiz "\n"
.globl main
.text
main: 
	#Nhap
	li $v0, 4
	la $a0, msg_nhapx
	syscall			# in nhan nhap X
	
	li $v0,5		#luu X
	syscall			#in X 
	
	move $t0, $v0		#$t0 chua so X
	
	li $v0,4
	la $a0, msg_nhapy
	syscall			#in nhan nhap Y
	
	li $v0, 5		#luu Y
	syscall			#in Y
	
	move $t1,$v0		#$t1 chua so Y
	
	li $v0, 4
	la $a0, msg_phep
	syscall			#In nhan nhap phep toan 
	
	li $v0, 12		#lưu kí tự phép toán
	syscall			#In ký tự 
	
	move $t2, $v0		#$t2 chứa kí tự phép toán
	
	li $v0,4
	la $a0,msg_linebrk
	syscall			#In nhan xuong hang
	
	#Xử lý
	bne $t2,'+', kiemtrapheptru  #Khong phai phep cong thì chuyển sang Kiểm tra phép trừ
	
	add $t5,$t0,$t1 	#$t5 = X + Y
	
	li $v0,4
	la $a0, msg_ketqua
	syscall			#in ketqua
	
	li $v0,1
	move $a0,$t5
	syscall			#In ket qua phep cộng
	
	j exit
	
	kiemtrapheptru:
	bne $t2,'-',khonghople	#Khong phai phep tru thì chuyển sang Không hợp lệ
	
	sub $t5,$t0,$t1		#$t5=X-Y
	
	li $v0,1
	move $a0,$t5
	syscall 		#In ket qua phep trừ
	
	j exit
	
	khonghople:
	la $a0, msg_not
	li $v0,4
	syscall 		#In nhãn không hợp lệ
	
	exit: 
	li $v0, 10		#Lưu kết quả vào $v0
	syscall			#In kết quả
	
	
	
	
