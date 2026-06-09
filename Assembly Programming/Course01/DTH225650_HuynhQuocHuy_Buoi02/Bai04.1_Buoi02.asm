.data
msg_input: .asciiz "Nhap vao mot ki tu: "
msg_output: .asciiz " Chuyen sang ki tu hoa la: "
msg_khongchu: .asciiz " Khong phai ki tu chu "
line_brk: .asciiz "\n"

.text
main:
	#Nhap Ký Tự
	la $a0, msg_input
	li $v0, 4		#sao nhãn
	syscall 		#Xuất nhãn Nhập Ký tự
	
	li $v0,12		#Xuất ký tự
	syscall
	
	move $t0,$v0		#Lưu kí tự vào $t1
	
	la $a0, line_brk
	li $v0,4
	syscall			#xuống dòng	
	
	#Xử Lý
	blt $t0, 'A',khong_hoa
	bgt $t0, 'Z',khong_hoa
	
	la $a0,msg_output
	li $v0,4
	syscall			#In nhãn chuyển sang ký tự hoa
	
	move $a0,$t0
	li $v0,11		#sao ký tự 11
	syscall 		#Xuất ký tự
	
	j exit
	
	khong_hoa:
	#kiem tra chu thuong
	blt $t0,'a',khong_thuong
	bgt $t0,'z',khong_thuong
	
	addi $t0,$t0, -32	# Trừ ký tự thường đi 32 thành ký tự hoa
	
	la $a0,msg_output
	li $v0, 4
	syscall			#xuất mảng chuyển sang ký tự hoa
	
	move $a0,$t0
	li $v0,11
	syscall			#Xuất kết quả kí tự hoa
	
	j exit
	
	khong_thuong:
	move $a0,$t0
	li $v0,11
	syscall 		#Xuat ký tự vừa nhập
	
	la $a0,msg_khongchu
	li $v0, 4
	syscall			#Xuat nhã không chữ
	
	exit:
	li $v0, 10
	syscall
	
	
	
	
	