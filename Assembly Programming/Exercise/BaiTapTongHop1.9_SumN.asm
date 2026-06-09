.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_prompt:     .asciiz "Nhap so nguyen N: "      # Thông báo yêu cầu nhập số N
    msg_result:     .asciiz "Tong N + ... + N^2 la: " # Chuỗi hiển thị trước kết quả tổng
    msg_error_neg:  .asciiz "Loi: N phai la so khong am.\n" # Thông báo lỗi nếu N âm
    msg_error_large: .asciiz "Loi: Ket qua co the bi tran so. Vui long nhap N nho hon.\n" # Thông báo lỗi nếu N quá lớn
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
    move $s0, $v0         # move: Lưu số N vào $s0. ($s0 = N)

    # -----------------------------------------------------
    # 2. Kiểm tra N (N phải không âm và N^2 không quá lớn)
    # -----------------------------------------------------
    bltz $s0, HandleNegativeInput # bltz: Nếu N < 0, nhảy đến lỗi.

    # Tính N^2 trước để kiểm tra giá trị cuối cùng của tổng
    # và để dùng làm giới hạn trên cho vòng lặp.
    mult $s0, $s0         # mult: Tính N * N. Kết quả lưu vào hi:lo.
    mflo $s1              # mflo: Lấy N^2 từ lo vào $s1. ($s1 = N^2)
    mfhi $t0              # Lấy hi vào $t0 để kiểm tra tràn số.
    bne $t0, $zero, HandleOverflow # Nếu hi != 0, nghĩa là N^2 đã tràn 32 bit,
                                  # thì tổng chắc chắn sẽ tràn. Xử lý lỗi.

    # -----------------------------------------------------
    # 3. Khởi tạo các thanh ghi cho vòng lặp
    # -----------------------------------------------------
    move $t0, $s0         # $t0 = current_number = N (biến chạy từ N đến N^2)
    li $s2, 0             # $s2 = sum = 0 (khởi tạo tổng bằng 0)

    # -----------------------------------------------------
    # 4. Vòng lặp tính tổng: for (current_number = N; current_number <= N^2; current_number++)
    # -----------------------------------------------------
LoopStart:
    bgt $t0, $s1, LoopEnd # bgt: Branch if Greater Than.
                          # Nếu current_number ($t0) > N^2 ($s1), thoát vòng lặp.

    add $s2, $s2, $t0     # add: Cộng current_number ($t0) vào tổng ($s2).
                          # $s2 = $s2 + $t0

    addi $t0, $t0, 1      # addi: Tăng current_number ($t0) lên 1.
                          # $t0 = $t0 + 1

    j LoopStart           # jump: Nhảy về đầu vòng lặp.

LoopEnd:
    # -----------------------------------------------------
    # 5. Xuất kết quả tổng
    # -----------------------------------------------------
    la $a0, msg_result    # Nạp địa chỉ của chuỗi 'msg_result' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi thông báo kết quả.

    move $a0, $s2         # Di chuyển tổng cuối cùng từ $s2 vào $a0.
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
HandleNegativeInput:
    la $a0, msg_error_neg # Nạp địa chỉ thông báo lỗi số âm vào $a0.
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