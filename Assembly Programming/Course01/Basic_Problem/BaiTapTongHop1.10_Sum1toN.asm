.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_prompt:     .asciiz "Nhap vao mot so nguyen N: " # Thông báo yêu cầu nhập N
    msg_result:     .asciiz "Ket qua: "               # Chuỗi hiển thị trước kết quả tổng
    msg_error_neg:  .asciiz "Loi: Vui long nhap so nguyen DUONG N.\n" # Thông báo lỗi nếu N âm
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
    # 2. Kiểm tra N (N phải là số dương)
    # -----------------------------------------------------
    blez $s0, HandleInvalidN # blez: Branch if Less than or Equal to Zero.
                             # Nếu N <= 0, nhảy đến phần xử lý lỗi. (Yêu cầu là số nguyên N, nhưng tổng 1..N thì N phải >=1)
                             # Tôi sẽ coi "số nguyên N" ở đây ngụ ý N >= 1 để tổng có nghĩa.

    # -----------------------------------------------------
    # 3. Khởi tạo các thanh ghi cho vòng lặp
    # -----------------------------------------------------
    li $t0, 1             # $t0 = current_number = 1 (biến chạy từ 1 đến N)
    li $s1, 0             # $s1 = sum = 0 (khởi tạo tổng bằng 0)

    # -----------------------------------------------------
    # 4. Vòng lặp tính tổng: for (current_number = 1; current_number <= N; current_number++)
    # -----------------------------------------------------
LoopStart:
    bgt $t0, $s0, LoopEnd # bgt: Branch if Greater Than.
                          # Nếu current_number ($t0) > N ($s0), thoát vòng lặp.

    # Kiểm tra tràn số trước khi cộng
    # (Để đơn giản, ta có thể dùng add/addu rồi kiểm tra exception hoặc kiểm tra thủ công)
    # Cách kiểm tra tràn số cho add: If (sum > MAX_INT - current_number) then overflow
    # MIPS không có cờ tràn số tự động cho `add`. `addu` là không tràn số.
    # Ta có thể kiểm tra một cách thủ công: nếu $s1 (tổng hiện tại) lớn và $t0 (số cộng vào) lớn
    # và $s1 + $t0 nhỏ hơn $s1, thì đã tràn số.

    add $s1, $s1, $t0     # add: Cộng current_number ($t0) vào tổng ($s1).
                          # $s1 = $s1 + $t0
                          # (Lưu ý: lệnh 'add' trong MIPS sẽ gây exception nếu tràn số.
                          # Nếu muốn tránh exception, có thể dùng 'addu' và tự kiểm tra tràn.)
                          # Đối với bài này, tôi sử dụng 'add' và giả định kết quả không tràn với N nhỏ.
                          # Để kiểm tra tràn an toàn, phức tạp hơn một chút:
                          # `slt $t9, $s1, $zero`  # Kiểm tra dấu của $s1 (sum)
                          # `slt $t8, $t0, $zero`  # Kiểm tra dấu của $t0 (current_number)
                          # `bne $t9, $t8, NoOverflowCheck` # Nếu dấu khác nhau, không thể tràn
                          # `add $s1, $s1, $t0`    # Thực hiện phép cộng
                          # `slt $t9, $s1, $zero`  # Kiểm tra dấu của kết quả
                          # `beq $t9, $t8, NoOverflowOccurred` # Nếu dấu kết quả vẫn giữ nguyên, không tràn
                          # `j HandleOverflow`     # Nếu dấu thay đổi, đã tràn
                          # NoOverflowCheck:
                          # NoOverflowOccurred:

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

    move $a0, $s1         # Di chuyển tổng cuối cùng từ $s1 vào $a0.
                          # ($a0 bây giờ chứa tổng cần in)
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # Thực hiện syscall để in giá trị tổng ra màn hình.

    la $a0, line_brk      # In kí tự xuống dòng.
    li $v0, 4
    syscall

    #j ExitProgram         # Nhảy đến phần kết thúc chương trình.

# -----------------------------------------------------
# Phần xử lý lỗi
# -----------------------------------------------------
HandleInvalidN:
    la $a0, msg_error_neg # Nạp