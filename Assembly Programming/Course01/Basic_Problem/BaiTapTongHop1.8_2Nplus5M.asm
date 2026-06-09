.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_input_n:    .asciiz "Nhap so nguyen N: "    # Thông báo yêu cầu nhập số N
    msg_input_m:    .asciiz "Nhap so nguyen M: "    # Thông báo yêu cầu nhập số M
    msg_result:     .asciiz "Ket qua cua 2*N + 5*M la: " # Chuỗi hiển thị trước kết quả
    line_brk:       .asciiz "\n"                    # Kí tự xuống dòng (newline)

.text
.globl main                                     # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên N
    # -----------------------------------------------------
    la $a0, msg_input_n     # load address: Nạp địa chỉ của chuỗi 'msg_input_n' vào $a0.
    li $v0, 4               # load immediate: Mã dịch vụ 4 (print_string).
    syscall                 # In thông báo yêu cầu nhập N.

    li $v0, 5               # load immediate: Mã dịch vụ 5 (read_int).
    syscall                 # Đọc số nguyên N.
    move $t0, $v0           # move: Lưu số N vào $t0. ($t0 = N)

    # -----------------------------------------------------
    # 2. Nhập số nguyên M
    # -----------------------------------------------------
    la $a0, msg_input_m     # Nạp địa chỉ của chuỗi 'msg_input_m' vào $a0.
    li $v0, 4               # Mã dịch vụ 4.
    syscall                 # In thông báo yêu cầu nhập M.

    li $v0, 5               # Mã dịch vụ 5.
    syscall                 # Đọc số nguyên M.
    move $t1, $v0           # Lưu số M vào $t1. ($t1 = M)

    # -----------------------------------------------------
    # 3. Tính biểu thức 2*N + 5*M
    # Cần 2 phép nhân và 1 phép cộng.
    # -----------------------------------------------------

    # Tính 2*N
    li $t2, 2               # Nạp hằng số 2 vào $t2.
    mult $t0, $t2           # mult: Nhân N ($t0) với 2 ($t2).
                            # Kết quả lưu vào hi và lo.
    mflo $s0                # mflo: Lấy 32 bit thấp của kết quả (2*N) từ lo vào $s0. ($s0 = 2*N)
                            # Giả định 2*N không tràn 32 bit.

    # Tính 5*M
    li $t3, 5               # Nạp hằng số 5 vào $t3.
    mult $t1, $t3           # mult: Nhân M ($t1) với 5 ($t3).
                            # Kết quả lưu vào hi và lo.
    mflo $s1                # mflo: Lấy 32 bit thấp của kết quả (5*M) từ lo vào $s1. ($s1 = 5*M)
                            # Giả định 5*M không tràn 32 bit.

    # Tính tổng (2*N) + (5*M)
    add $s2, $s0, $s1       # add: Cộng (2*N) từ $s0 với (5*M) từ $s1.
                            # Kết quả lưu vào $s2. ($s2 = 2*N + 5*M)

    # -----------------------------------------------------
    # 4. Xuất kết quả
    # -----------------------------------------------------
    la $a0, msg_result      # Nạp địa chỉ của chuỗi 'msg_result' vào $a0.
    li $v0, 4               # Mã dịch vụ 4 (print_string).
    syscall                 # In chuỗi thông báo kết quả.

    move $a0, $s2           # Di chuyển kết quả cuối cùng từ $s2 vào $a0.
                            # ($a0 bây giờ chứa giá trị của biểu thức cần in)
    li $v0, 1               # Mã dịch vụ 1 (print_int).
    syscall                 # Thực hiện syscall để in giá trị của biểu thức ra màn hình.

    la $a0, line_brk        # In kí tự xuống dòng