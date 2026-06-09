.data
input: .asciiz "Nhap vao mot chuoi: "
kq1: .asciiz "\nChuoi doi xung: "
kq2: .asciiz "\nChuoi khong doi xung: "
str: .space 1024
.text

li $v0,4
la $a0,input
syscall

li $v0,8
la $a0,str
li $a1,1024
syscall

li $t2,0	#t2: chieu dai chuoi
la $t0,str

#Đưa chuỗi vào Stack
loop:
lb $t1,($t0)
beq $t1,10,next
addi $sp,$sp,-1
sb $t1,($sp)
addi $t0,$t0,1
addi $t2,$t2,1
j loop

next:
li $t3,0
div $t2,$t3
mflo $t3
li $t4,1
la $t0,str

loop_xuly:
lb $t1,($t0)
lb $t5,($sp)
addi $sp,$sp,-1
bne $t1,$t5,khongdoixung
addi $t0,$t0,1
addi $t3,$t3,-1
bgtz $t3,loop_xuly

j doixung

khongdoixung:
li $t4,0
li $v0,4
la $a0,kq2
syscall

j exit

doixung:
li $v0,4
la $a0,kq1
syscall

exit:
li $v0,10
syscall
