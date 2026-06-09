.data 
input: .asciiz "Nhap : "
output: .asciiz "Ket qua: "
.globl main
.text
main:
	la $a0,input
	li $v0,4
	syscall
	
	li $v0,5
	syscall
	
	li $v0,4
	la $a1,output
	syscall
	
	move $a1,$v0
	syscall
	
	li $v0,10
	syscall
 