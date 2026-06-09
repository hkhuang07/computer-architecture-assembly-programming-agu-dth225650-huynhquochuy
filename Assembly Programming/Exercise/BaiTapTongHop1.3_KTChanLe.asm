.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_prompt:     .asciiz "Nhap vao so nguyen duong N: " # Thông báo yêu cầu nhập số N
    msg_is_even:    .asciiz " la so chan\n"              # Chuỗi hiển thị khi số là chẵn
    msg_is_odd:     .asciiz " la so le\n"               # Chuỗi hiển thị khi số là lẻ
    msg_error_neg:  .asciiz "Loi: Vui long nhap so nguyen DUONG.\n" # Thông báo lỗi nếu nhập số âm

.text
.globl main                                   # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên dương N
    # -----------------------------------------------------
    la $a0, msg_prompt    # load address: Nạp địa chỉ của chuỗi 'msg_prompt' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In thông báo yêu cầu nhập N.

    li $v0, 5             # load immediate: Mã dịch vụ 5 (read_int).
    syscall               # Đọc số nguyên từ bàn phím.
                          # Số đọc được sẽ tự động lưu vào $v0.

    move $t0, $v0         # move: Di chuyển giá trị từ $v0 (số N vừa đọc) vào $t0.

    # -----------------------------------------------------
    # 2. Kiểm tra N có phải là số dương không
    # -----------------------------------------------------
    bltz $t0, HandleNegativeInput # bltz: Branch if Less Than Zero.
                                  # Nếu $t0 (N) nhỏ hơn 0, nhảy đến 'HandleNegativeInput'.

    # -----------------------------------------------------
    # 3. Xác định chẵn/lẻ bằng phép AND bitwise
    # -----------------------------------------------------
    andi $t1, $t0, 1      # andi: Thực hiện phép AND bitwise giữa $t0 (số N) và hằng số 1.
                          # Kết quả lưu vào $t1.
                          # - Nếu N là chẵn (ví dụ 10 = ...01010_2), bit cuối cùng là 0.
                          #   01010_2 AND 00001_2 = 00000_2. => $t1 = 0.
                          # - Nếu N là lẻ (ví dụ 15 = ...01111_2), bit cuối cùng là 1.
                          #   01111_2 AND 00001_2 = 00001_2. => $t1 = 1.

    # -----------------------------------------------------
    # 4. Rẽ nhánh dựa trên kết quả
    # -----------------------------------------------------
    beqz $t1, IsEven      # beqz: Branch if Equal to Zero.
                          # Nếu $t1 bằng 0 (nghĩa là số chẵn), nhảy đến nhãn 'IsEven'.
                          # Ngược lại (nếu $t1 bằng 1, số lẻ), tiếp tục thực thi lệnh tiếp theo.

    # -----------------------------------------------------
    # Nếu là số lẻ
    # -----------------------------------------------------
    # In số N
    move $a0, $t0         # Di chuyển số N vào $a0 để in.
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # In số N.

    # In chuỗi " la so le\n"
    la $a0, msg_is_odd    # Nạp địa chỉ chuỗi 'msg_is_odd' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi.

    j ExitProgram         # jump: Nhảy đến nhãn 'ExitProgram' để kết thúc.

IsEven:
    # -----------------------------------------------------
    # Nếu là số chẵn
    # -----------------------------------------------------
    # In số N
    move2a0, $t0         # Di chuyển số N vào $a0 để in.
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # In số N.

    # In chuỗi " la so chan\n"
    la $a0, msg_is_even   # Nạp địa chỉ chuỗi 'msg_is_even' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi.

    j ExitProgram         # jump: Nhảy đến nhãn 'ExitProgram' để kết thúc.

HandleNegativeInput:
    # -----------------------------------------------------
    # Xử lý lỗi: Nhập số âm
    # -----------------------------------------------------
    la $a0, msg_error_neg # load address: Nạp địa chỉ thông báo lỗi vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In thông báo lỗi.

    # Có thể yêu cầu nhập lại hoặc thoát. Ở đây chọn thoát.

ExitProgram:
    # -----------------------------------------------------
    # 5. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # load immediate: Mã dịch vụ 10 (exit).
    syscall               # Thực hiện syscall để thoát chương trình.