.data
input1: .asciiz "Nhap vao mot so nguyen n: "
input2: .asciiz "Nhap vao mot so nguyen m: "
output: .asciiz " Ket Qua: "
line_brk: .asciiz "\n"

.text
main: 
	li $v0,4
	la $a0,input1
	syscall

	li $v0,5
	syscall
	move $t0,$v0    	# t0 = n

	li $v0,4 
	la $a0,input2
	syscall

	li $v0,5
	syscall
	move $t1,$v0		# t1 = m

	li $v0,4
	la $a0,line_brk
	syscall

	li $v0,4
	la $a0,output
	syscall

#Xu Ly
# t5 thanh ghi tam

# t1 luu 2*n
	li $t5,2 
	mul $t2,$t5,$t1

# t2 luu 5*m
	li $t5,5
	mul $t3,$t5,$t1

# t4 luu 2*n +5*m
	add $t4,$t2,$t3

	li $v0,1
	move $a0,$t4
	syscall

	li $v0,10
	syscall

