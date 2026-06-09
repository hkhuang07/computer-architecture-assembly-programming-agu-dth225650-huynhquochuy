.data
input: .asciiz "Nhap vao mot ki tu: "
output_before: .asciiz "Ki tu lien truoc: "
output_after: .asciiz "Ki tu lien sau: "
line_brk: .asciiz "\n"
.text
main:
	la $a0,input
	li $v0,4
	syscall
	
	li $v0,12
	syscall
	
	move $t0,$v0	#LƯU KÍ TỰ VÀO ST0
	move $t1,$t0	#LƯU KÍ TỰ TRONG $T0 VÀO $T1 ĐỂ TÍNH TOÁN
	addi $t1,$t1,-1 #TRỪ ĐI 1 ĐƠN VỊ TA ĐƯỢC KÍ TỰ LIỀN TRƯỚC
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#XUẤT KÍ TỰ LIỀN TRƯỚC
	la $a0,output_before
	li $v0,4
	syscall
	
	move $a0,$t1	
	li $v0,11	
	syscall
	
	move $t1,$t0	#LƯU KÍ TỰ TRONG $T0 VÀO $T1 ĐỂ TÍNH TOÁN
	addi $t1,$t1,1	#CỘNG THÊM 1 ĐƠN VỊ TA ĐƯỢC KÍ TỰ LIỀN SAU
	
	la $a0,line_brk
	li $v0,4
	syscall
	
	#XUẤT KÍ TỰ LIỀN SAU
	
	la $a0,output_after
	li $v0,4
	syscall
	
	move $a0,$t1
	li $v0,11
	syscall
	
	li $v0,10
	syscall
	
	