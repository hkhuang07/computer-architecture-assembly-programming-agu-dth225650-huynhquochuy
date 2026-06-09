.data
	msg_input_string: .asciiz "Enter string: "
	msg_lowcase_string: .asciiz "Lowcase string: "
	line_brk: .asciiz "\n"
	
	string_buffer: .space 256
.text
.global main
main:
	#In chuỗi nhập
	la $a0,msg_input_string
	li $v0,4
	syscall
	
	#Nhập chuỗi
	la $a0,string_buffer
	li $a1,256
	li $v0,8 #8 là mã nhập chuỗi read_string của chương trình
	syscall
	
	#Khởi tạo con trỏ
	la $t0,string_buffer
	
	Loop:
	lb $t1,($t0) #lấy ký tự đầu tiên trong chuỗi $t0 lưu vào $t1
	beqz $t1,loopEnd #nếu ký tự đó là \0 đánh dấu hết chuỗi thì thoát loop
	
	li $s0,'A'
	li $s1,'Z'
	
	blt $t1,$s0,Next_Char #nếu ký tự nhỏ hơn A thì next đến ký tự tiếp theo
	bgt $t1,$s1,Next_Char #Nếu ký tự lớn hơn Z thì next đến ký tự tiếp theo
	
	li $s2,0x20 
	add $t1,$t1,$s2
	
	sb $t1,($t0) #Lưu ký tư mới vào bộ nhớ string_buffer
	
	Next_Char:
	addi $t0,$t0,1 #tăng vị trí xét ký tự trong chuỗi lên 1
	j Loop
	
	loopEnd:
	#Xuống dòng
	la $a0,line_brk
	li $v0,4
	syscall
	
	#In label chuỗi lowcase
	la $a0,msg_lowcase_string
	li $v0,4
	syscall
	
	#In chuỗi mỡi
	la $a0,string_buffer
	li $v0,4
	syscall
	
	#End Program
	li $v0,10
	syscall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	