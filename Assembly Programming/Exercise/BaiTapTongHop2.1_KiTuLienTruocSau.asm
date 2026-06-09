.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và kí tự xuống dòng
    # -----------------------------------------------------
    msg_input: 	    .asciiz "Enter your character: "    # Chuỗi thông báo yêu cầu người dùng nhập ký tự
    msg_previous: 	.asciiz "The previous character: "  # Chuỗi thông báo hiển thị trước ký tự đứng trước
    msg_next: 		.asciiz "The next character: "      # Chuỗi thông báo hiển thị trước ký tự đứng sau
    line_brk: 		.asciiz "\n"                        # Kí tự xuống dòng (newline) để xuống dòng trong output

.text
.globl main                                         # Khai báo nhãn 'main' là toàn cục, điểm bắt đầu của chương trình

main:
    # -----------------------------------------------------
    # 1. Nhập một kí tự từ bàn phím
    # -----------------------------------------------------
    la $a0, msg_input   # load address: Nạp địa chỉ của chuỗi 'msg_input' vào thanh ghi $a0.
                        # ($a0 dùng để truyền đối số cho syscall print_string)
    li $v0, 4           # load immediate: Nạp giá trị 4 vào thanh ghi $v0 (Mã dịch vụ 4 là 'print_string').
    syscall             # Thực hiện syscall để in chuỗi thông báo ra màn hình.

    li $v0, 12          # load immediate: Nạp giá trị 12 vào thanh ghi $v0.
                        # (Mã dịch vụ 12 là 'read_char' - đọc một ký tự từ bàn phím)
    syscall             # Thực hiện syscall để đọc ký tự.
                        # Ký tự đọc được sẽ được lưu tự động vào thanh ghi $v0 (dưới dạng mã ASCII).

    move $t0, $v0       # move: Di chuyển giá trị từ thanh ghi $v0 (chứa ký tự vừa đọc)
                        #       vào thanh ghi tạm thời $t0. ($t0 sẽ lưu trữ ký tự gốc)

    # -----------------------------------------------------
    # 2. In một kí tự xuống dòng sau khi nhập (để output không bị dính vào dòng nhập)
    # -----------------------------------------------------
    la $a0, line_brk    # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0, 4           # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall             # Thực hiện syscall để in kí tự xuống dòng.

    # -----------------------------------------------------
    # 3. Tính toán và hiển thị kí tự đứng trước
    # -----------------------------------------------------
    la $a0, msg_previous # load address: Nạp địa chỉ của chuỗi 'msg_previous' vào thanh ghi $a0.
    li $v0, 4            # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall              # Thực hiện syscall để in chuỗi thông báo "The previous character: ".

    sub $a0, $t0, 1      # subtract: Lấy giá trị của ký tự gốc trong $t0 và trừ đi 1 (mã ASCII của ký tự trước).
                         #           Lưu kết quả (mã ASCII của ký tự trước) vào thanh ghi $a0 (đối số cho print_char).
    li $v0, 11           # load immediate: Nạp giá trị 11 vào thanh ghi $v0.
                         # (Mã dịch vụ 11 là 'print_char' - in một ký tự)
    syscall              # Thực hiện syscall để in ký tự đứng trước ra màn hình.

    la $a0, line_brk     # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0, 4            # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall              # Thực hiện syscall để in kí tự xuống dòng.

    # -----------------------------------------------------
    # 4. Tính toán và hiển thị kí tự đứng sau
    # -----------------------------------------------------
    la $a0, msg_next     # load address: Nạp địa chỉ của chuỗi 'msg_next' vào thanh ghi $a0.
    li $v0, 4            # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall              # Thực hiện syscall để in chuỗi thông báo "The next character: ".

    add $a0, $t0, 1      # add: Lấy giá trị của ký tự gốc trong $t0 và cộng thêm 1 (mã ASCII của ký tự sau).
                         #      Lưu kết quả (mã ASCII của ký tự sau) vào thanh ghi $a0 (đối số cho print_char).
    li $v0, 11           # load immediate: Mã dịch vụ 11 là 'print_char'.
    syscall              # Thực hiện syscall để in ký tự đứng sau ra màn hình.

    la $a0, line_brk     # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0, 4            # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall              # Thực hiện syscall để in kí tự xuống dòng.
    
    # -----------------------------------------------------
    # 5. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10           # load immediate: Nạp giá trị 10 vào thanh ghi $v0.
                         # (Mã dịch vụ 10 là 'exit' - thoát chương trình)
    syscall              # Thực hiện syscall để kết thúc chương trình.