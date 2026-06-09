.data
input: .asciiz "Nhap vao mot chuoi: "
output:	.asciiz "\nChuoi dao nguoc la: "
str: .space 1024
.text
li $v0,4 	#lệnh nhập nhãn
la $a0,input	
syscall		# In Nhãn Input

li $v0,8	#lệnh nhập chuỗi
la $a0,str
li $a1,1024
syscall		#In Chuỗi

#Đưa vào Stack
li $t2,0
la $t0,str

loop_push:
lb $t1,($t0)	#$t1 lưu chuỗi
beqz $t1,end	#stack $t1 = 0 --> End
addi $sp,$sp,-1 #$sp--
sb $t1,($sp)	#$sp =$t1
addi $t0,$t0,1 	#$t0=$t0+1
addi $t2,$t2,1	#$t2=$t2+1
j loop_push

end:
li $v0,4	#lệnh nhập nhãn
la $a0,output	
syscall		#In nhãn Output

		#Lấy ra từ Stack
loop_pop:
lb $t1,($sp)		#$t1=$sp
addi $sp,$sp,1		#$sp=$sp+1	
addi $t2,$t2,-1		#$t2=$t2-1

li $v0,11	#lệnh sao chép chuỗi
move $a0,$t1	#sao chép $t1 cho $a0
syscall		#In chuỗi $t1

bgtz $t2, loop_pop #Nếu $t2 > 0 --> lặp lại loop pop
li $v0,10	
syscall
	