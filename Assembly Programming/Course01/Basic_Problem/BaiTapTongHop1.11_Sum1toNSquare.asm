.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_prompt:     .asciiz "Nhap vao mot so nguyen N: " # Thông báo yêu cầu nhập N
    msg_result:     .asciiz "Ket qua: "               # Chuỗi hiển thị trước kết quả tổng
    msg_error_neg:  .asciiz "Loi: Vui long nhap so nguyen DUONG N (>= 1).\n" # Thông báo lỗi nếu N không hợp lệ
    msg_error_large: .asciiz "Loi: Ket qua co the bi tran so. Vui long nhap N nho hon.\n" # Thông báo lỗi nếu tổng tràn
    line_brk:       .asciiz "\n"                      # Kí tự xuống dòng (newline)

.text
.globl main                                   # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên N
    # -----------------------------------------------------
    la $a0, msg_prompt    # load address: Nạp địa chỉ của chuỗi 'msg_prompt' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In thông báo yêu cầu nhập N.

    li $v0, 5             # load immediate: Mã dịch vụ 5 (read_int).
    syscall               # Đọc số nguyên N.
    move $s0, $v0         # move: Lưu số N vào $s0. ($s0 sẽ là giới hạn trên của vòng lặp)

    # -----------------------------------------------------
    # 2. Kiểm tra N (N phải là số nguyên dương, tức N >= 1)
    # -----------------------------------------------------
    blez $s0, HandleInvalidN # blez: Branch if Less than or Equal to Zero.
                             # Nếu N <= 0, nhảy đến phần xử lý lỗi.
                             # Tổng các bình phương bắt đầu từ 1.

    # -----------------------------------------------------
    # 3. Khởi tạo các thanh ghi cho vòng lặp
    # -----------------------------------------------------
    li $t0, 1             # $t0 = current_number = 1 (biến chạy từ 1 đến N)
    li $s1, 0             # $s1 = sum_of_squares = 0 (khởi tạo tổng bằng 0)

    # -----------------------------------------------------
    # 4. Vòng lặp tính tổng: for (current_number = 1; current_number <= N; current_number++)
    # -----------------------------------------------------
LoopStart:
    bgt $t0, $s0, LoopEnd # bgt: Branch if Greater Than.
                          # Nếu current_number ($t0) > N ($s0), thoát vòng lặp.

    # -----------------------------------------------------
    # Tính bình phương của current_number: current_number * current_number
    # -----------------------------------------------------
    mult $t0, $t0         # mult: Nhân current_number ($t0) với chính nó.
                          # Kết quả 64-bit lưu vào hi:lo.
    mflo $t1              # mflo: Lấy 32 bit thấp của bình phương vào $t1. ($t1 = current_number^2)
    mfhi $t2              # mfhi: Lấy 32 bit cao của bình phương vào $t2.
    bne $t2, $zero, HandleOverflow # Nếu $t2 (hi) khác 0, nghĩa là current_number^2 đã tràn 32 bit.
                                   # Tổng chắc chắn sẽ tràn. Nhảy đến xử lý lỗi.

    # -----------------------------------------------------
    # Cộng vào tổng và kiểm tra tràn số cho tổng
    # -----------------------------------------------------
    add $s1, $s1, $t1     # add: Cộng current_number^2 ($t1) vào tổng hiện tại ($s1).
                          # Kết quả lưu vào $s1.
                          # (Lệnh 'add' sẽ gây exception nếu tổng tràn.
                          # Nếu muốn xử lý mềm hơn, dùng 'addu' và tự kiểm tra tràn như đã đề cập.)
                          # Ví dụ N=3, tổng=14 -> không tràn. N=50000, tổng sẽ tràn 32-bit.

    # -----------------------------------------------------
    # Tăng biến đếm
    # -----------------------------------------------------
    addi $t0, $t0, 1      # addi: Tăng current_number ($t0) lên 1.

    j LoopStart           # jump: Nhảy về đầu vòng lặp.

LoopEnd:
    # -----------------------------------------------------
    # 5. Xuất kết quả tổng
    # -----------------------------------------------------
    la $a0, msg_result    # Nạp địa chỉ của chuỗi 'msg_result' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi thông báo kết quả.

    move $a0, $s1         # Di chuyển tổng cuối cùng từ $s1 vào $a0.
                          # ($a0 bây giờ chứa tổng cần in)
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # Thực hiện syscall để in giá trị tổng ra màn hình.

    la $a0, line_brk      # In kí tự xuống dòng.
    li $v0, 4
    syscall

    j ExitProgram         # Nhảy đến phần kết thúc chương trình.

# -----------------------------------------------------
# Phần xử lý lỗi
# -----------------------------------------------------
HandleInvalidN:
    la $a0, msg_error_neg # Nạp địa chỉ thông báo lỗi N không hợp lệ vào $a0.
    li $v0, 4             # Mã dịch vụ 4.
    syscall               # In lỗi.
    j ExitProgram         # Thoát.

HandleOverflow:
    la $a0, msg_error_large # Nạp địa chỉ thông báo lỗi tràn số vào $a0.
    li $v0, 4               # Mã dịch vụ 4.
    syscall                 # In lỗi.
    j ExitProgram           # Thoát.

ExitProgram:
    # -----------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # Mã dịch vụ 10 (exit).
    syscall               # Thoát chương trình.