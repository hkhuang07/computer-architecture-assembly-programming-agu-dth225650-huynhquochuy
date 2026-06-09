.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_input_char: .asciiz "Enter your character: "      	# Chuỗi thông báo yêu cầu nhập ký tự
    msg_result:     .asciiz "Result: "             	  	# Chuỗi thông báo "Ket qua: "
    msg_is_digit:   .asciiz " Your character is number"     	# Chuỗi " la so"
    msg_not_digit:  .asciiz " Your character is not number"     # Chuỗi " khong phai la so"
    line_brk:       .asciiz "\n"                    		# Kí tự xuống dòng

.text
.globl main

main:
    # -----------------------------------------------------
    # 1. Nhập một kí tự từ bàn phím
    # -----------------------------------------------------
    la $a0, msg_input_char  # load address: Nạp địa chỉ của chuỗi 'msg_input_char' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in chuỗi yêu cầu nhập

    li $v0, 12              # load immediate: Mã dịch vụ 12 là 'read_char' (đọc một ký tự)
    syscall                 # Thực hiện syscall để đọc ký tự
    move $t0, $v0           # move: Di chuyển ký tự đọc được (từ $v0) vào thanh ghi $t0 để lưu trữ

    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng (sau khi người dùng nhập)

    # -----------------------------------------------------
    # 2. Hiển thị chuỗi "Ket qua: " và ký tự đã nhập
    # -----------------------------------------------------
    la $a0, msg_result      # load address: Nạp địa chỉ của chuỗi 'msg_result' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in "Ket qua: "

    move $a0, $t0           # move: Di chuyển ký tự đã nhập từ $t0 vào $a0 (đối số cho print_char)
    li $v0, 11              # load immediate: Mã dịch vụ 11 là 'print_char' (in một ký tự)
    syscall                 # Thực hiện syscall để in ký tự mà người dùng vừa nhập

    # -----------------------------------------------------
    # 3. Kiểm tra ký tự có phải là số hay không
    # -----------------------------------------------------
    li $s0, '0'             # load immediate: Nạp mã ASCII của ký tự '0' vào $s0 (ASCII 48)
    li $s1, '9'             # load immediate: Nạp mã ASCII của ký tự '9' vào $s1 (ASCII 57)

    # Kiểm tra: nếu ký tự ($t0) nhỏ hơn '0' (48), thì không phải là số
    blt $t0, $s0, NotADigit # branch less than: Nếu $t0 < $s0, nhảy đến nhãn 'NotADigit'

    # Kiểm tra: nếu ký tự ($t0) lớn hơn '9' (57), thì không phải là số
    bgt $t0, $s1, NotADigit # branch greater than: Nếu $t0 > $s1, nhảy đến nhãn 'NotADigit'

    # Nếu đến được đây, nghĩa là ký tự nằm trong khoảng ['0' - '9']
    # -----------------------------------------------------
    # 4. Nếu là số: Hiển thị " your character is number"
    # -----------------------------------------------------
    la $a0, msg_is_digit    # load address: Nạp địa chỉ của chuỗi 'msg_is_digit' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in " la so"
    j EndProgram            # jump: Nhảy đến nhãn 'EndProgram' để kết thúc chương trình

NotADigit:
    # -----------------------------------------------------
    # 5. Nếu không phải là số: Hiển thị " your character is not number"
    # -----------------------------------------------------
    la $a0, msg_not_digit   # load address: Nạp địa chỉ của chuỗi 'msg_not_digit' vào $a0
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in " khong phai la so"

EndProgram:
    # -----------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------
    la $a0, line_brk        # load address: Nạp địa chỉ của ký tự xuống dòng
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                 # Thực hiện syscall để in ký tự xuống dòng (để kết quả không bị dính vào prompt của hệ thống)

    li $v0, 10              # load immediate: Mã dịch vụ 10 là 'exit'
    syscall                 # Thực hiện syscall để thoát chương trình