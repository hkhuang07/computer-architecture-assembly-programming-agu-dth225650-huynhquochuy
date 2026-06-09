.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_prompt:     .asciiz "Nhap vao mot so nguyen: " # Thông báo yêu cầu nhập số nguyên
    msg_divisible:  .asciiz " chia het cho 3\n"      # Chuỗi hiển thị khi số chia hết cho 3
    msg_not_div:    .asciiz " khong chia het cho 3\n" # Chuỗi hiển thị khi số không chia hết cho 3
    line_brk:       .asciiz "\n"                      # Kí tự xuống dòng (newline)

.text
.globl main                                   # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên từ bàn phím
    # -----------------------------------------------------
    la $a0, msg_prompt    # load address: Nạp địa chỉ của chuỗi 'msg_prompt' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In thông báo yêu cầu nhập số nguyên.

    li $v0, 5             # load immediate: Mã dịch vụ 5 (read_int).
    syscall               # Đọc số nguyên từ bàn phím.
                          # Số đọc được sẽ tự động lưu vào $v0.

    move $t0, $v0         # move: Di chuyển giá trị từ $v0 (số nguyên vừa đọc) vào $t0. ($t0 là số bị chia)

    # -----------------------------------------------------
    # 2. Thực hiện phép chia lấy dư cho 3
    # -----------------------------------------------------
    li $t1, 3             # load immediate: Nạp hằng số 3 vào thanh ghi $t1. ($t1 là số chia)

    div $t0, $t1          # div: Thực hiện phép chia có dấu giữa $t0 và $t1.
                          # - Thương số sẽ lưu vào thanh ghi 'lo'.
                          # - Số dư sẽ lưu vào thanh ghi 'hi'.

    mfhi $t2              # mfhi: Move From Hi. Di chuyển giá trị từ thanh ghi 'hi' (số dư)
                          #       vào thanh ghi $t2. ($t2 bây giờ chứa số dư của phép chia cho 3)

    # -----------------------------------------------------
    # 3. Kiểm tra số dư và rẽ nhánh
    # -----------------------------------------------------
    beqz $t2, IsDivisibleBy3 # beqz: Branch if Equal to Zero.
                             # Nếu $t2 (số dư) bằng 0, nhảy đến nhãn 'IsDivisibleBy3'.
                             # Ngược lại (số dư khác 0), tiếp tục thực thi lệnh tiếp theo.

    # -----------------------------------------------------
    # Nếu số không chia hết cho 3
    # -----------------------------------------------------
    # In số nguyên ban đầu
    move $a0, $t0         # Di chuyển số nguyên N vào $a0 để in.
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # In số N.

    # In chuỗi " khong chia het cho 3\n"
    la $a0, msg_not_div   # Nạp địa chỉ chuỗi 'msg_not_div' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi.

    j ExitProgram         # jump: Nhảy đến nhãn 'ExitProgram' để kết thúc.

IsDivisibleBy3:
    # -----------------------------------------------------
    # Nếu số chia hết cho 3
    # -----------------------------------------------------
    # In số nguyên ban đầu
    move $a0, $t0         # Di chuyển số nguyên N vào $a0 để in.
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # In số N.

    # In chuỗi " chia het cho 3\n"
    la $a0, msg_divisible # Nạp địa chỉ chuỗi 'msg_divisible' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi.

    j ExitProgram         # jump: Nhảy đến nhãn 'ExitProgram' để kết thúc.

ExitProgram:
    # -----------------------------------------------------
    # 4. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # load immediate: Mã dịch vụ 10 (exit).
    syscall               # Thực hiện syscall để thoát chương trình.