.data
	msg_input: .asciiz "Enter number: "
	msg_sum:	  .asciiz "Sum: "
	line_brk: .asciiz "\n"
.text
.global main
main:
	#Input number n
	la $a0,msg_input
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	move $s0,$v0 #$t0 lưu giá trị n
	
	la $a0,line_brk
	li $v0,4
	syscall

	#Tính n*n
	mult $s0,$s0 
	mflo $s1    #$s1 lưu n*n

	move $t0,$s0  #$t1 lưu liên tiếp nxn
	li $s2,0    #$s2 lưu tong= 0
	
	loop:
	bgt $t0, $s1, exit_loop
	add $s2, $s2, $t0  #tong=tong+n 
	addi $t0, $t0, 1  #
	j loop
	
	exit_loop:

	#In kết quả
	la $a0,msg_sum
	li $v0,4
	syscall
	
	move $a0, $s2
	li $v0,1
	syscall
	
	la $a0, line_brk      # In kí tự xuống dòng.
    	li $v0, 4
    	syscall
	
	#Kết thúc chương trình
	li $v0,10
	syscall