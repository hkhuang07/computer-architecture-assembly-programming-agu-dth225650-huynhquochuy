.data
    msg_x:    	    .asciiz "Enter X: "        		  # Chuỗi thông báo yêu cầu nhập số thứ nhất
    msg_y:          .asciiz "Enter Y : "                  # Chuỗi thông báo yêu cầu nhập số thứ hai
    msg_operator:   .asciiz "Enter operator '+' or '-': " # Chuỗi thông báo yêu cầu nhập phép toán
    msg_sum:        .asciiz "Sum: "                       # Chuỗi thông báo hiển thị trước kết quả tổng
    msg_difference: .asciiz "Difference: "                # Chuỗi thông báo hiển thị trước kết quả hiệu
    msg_error:	    .asciiz "Just enter 1 option '+' or '-', please!!!"
    line_brk:       .asciiz "\n"                          # Kí tự xuống dòng (newline)

.text
.globl main

main:
    #-----------------------------------------------------------------------------
    # 1. Nhập số nguyên thứ nhất (X)
    #-----------------------------------------------------------------------------
    la $a0, msg_x     # load address: Nạp địa chỉ của chuỗi 'msg_number1' vào thanh ghi $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi thông báo

    li $v0, 5               # load immediate: Mã dịch vụ 5 là 'read_int' (đọc một số nguyên)
    syscall                 # Thực hiện syscall để đọc số nguyên X
    move $t0, $v0           # move: Di chuyển giá trị từ $v0 (chứa số X) vào thanh ghi $t0

    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng

    #-----------------------------------------------------------------------------
    # 2. Nhập số nguyên thứ hai (Y)
    #-----------------------------------------------------------------------------
    la $a0, msg_y     # load address: Nạp địa chỉ của chuỗi 'msg_number2' vào thanh ghi $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi thông báo

    li $v0, 5               # load immediate: Mã dịch vụ 5 là 'read_int'
    syscall                 # Thực hiện syscall để đọc số nguyên Y
    move $t1, $v0           # move: Di chuyển giá trị từ $v0 (chứa số Y) vào thanh ghi $t1

    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng

    #-----------------------------------------------------------------------------
    # 3. Nhập toán tử '+' hoặc '-'
    #-----------------------------------------------------------------------------
Input_Operator:
    la $a0, msg_operator    # load address: Nạp địa chỉ của chuỗi 'msg_operator' vào thanh ghi $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi thông báo

    li $v0, 12              # load immediate: Mã dịch vụ 12 là 'read_char' (đọc một ký tự)
    syscall                 # Thực hiện syscall để đọc ký tự toán tử
    move $t2, $v0           # move: Di chuyển giá trị từ $v0 (chứa mã ASCII của toán tử) vào thanh ghi $t2

    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng

    #-----------------------------------------------------------------------------
    # 4. Xử lý phép toán và xuất kết quả
    #-----------------------------------------------------------------------------
    li $s0, '+'		   	# load immediate: Nạp mã ASCII của ký tự '+' vào thanh ghi $s0
    li $s1, '-'             	# load immediate: Nạp mã ASCII của ký tự '-' vào thanh ghi $s0
    beq $t2, $s0, Do_Sum    	# branch if equal: Nếu toán tử ($t2) là '+', nhảy đến nhãn 'Do_Sum'
    beq $t2, $s1, Do_Difference # branch if equal: Nếu toán tử ($t2) là '-', nhảy đến nhãn 'Do_Difference'
    
    #Xử lý thông báo lỗi nếu user nhập không đúng phép tinh quy định!
    la $a0,msg_error
    li $v0,4
    syscall
    
    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng

    j Input_Operator
    
	
Do_Difference:
    # Nếu không phải là '+', thì là '-' (theo yêu cầu đề bài) -> Thực hiện phép trừ
    # In chuỗi "Difference: "
    la $a0, msg_difference  # load address: Nạp địa chỉ của chuỗi 'msg_difference' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi thông báo hiệu

    # Tính hiệu: $t3 = $t0 - $t1 (X - Y)
    sub $t3, $t0, $t1       # subtract: Lấy $t0 trừ $t1, lưu kết quả vào $t3

    # Xuất kết quả hiệu
    move $a0, $t3           # move: Di chuyển kết quả hiệu từ $t3 vào $a0 (đối số cho print_int)
    li $v0, 1               # load immediate: Mã dịch vụ 1 là 'print_int'
    syscall                 # Thực hiện syscall để in kết quả hiệu

    # Nhảy đến cuối chương trình sau khi in kết quả
    j Exit_Program          # jump: Nhảy đến nhãn 'Exit_Program' để kết thúc
	
Do_Sum:
    # Thực hiện phép cộng
    # In chuỗi "Sum: "
    la $a0, msg_sum         # load address: Nạp địa chỉ của chuỗi 'msg_sum' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi thông báo tổng

    # Tính tổng: $t3 = $t0 + $t1 (X + Y)
    add $t3, $t0, $t1       # add: Lấy $t0 cộng $t1, lưu kết quả vào $t3

    # Xuất kết quả tổng
    move $a0, $t3           # move: Di chuyển kết quả tổng từ $t3 vào $a0 (đối số cho print_int)
    li $v0, 1               # load immediate: Mã dịch vụ 1 là 'print_int'
    syscall                 # Thực hiện syscall để in kết quả tổng
    
    # Nhảy đến cuối chương trình sau khi in kết quả
    j Exit_Program          # jump: Nhảy đến nhãn 'Exit_Program' để kết thúc
	
Exit_Program:
    # -----------------------------------------------------
    # 5. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10              # load immediate: Mã dịch vụ 10 là 'exit'
    syscall                 # Thực hiện syscall để kết thúc chương trình