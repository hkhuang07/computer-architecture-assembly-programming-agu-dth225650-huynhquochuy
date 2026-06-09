.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_input_lenght:  .asciiz "Nhap chieu dai: "    # Thông báo yêu cầu nhập chiều dài
    msg_input_width: .asciiz "Nhap chieu rong: "   # Thông báo yêu cầu nhập chiều rộng
    msg_perimeter:   .asciiz "Chu vi hinh chu nhat la: " # Chuỗi hiển thị trước kết quả chu vi
    line_brk:       .asciiz "\n"                  # Kí tự xuống dòng (newline)

.text
.globl main                                   # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập chiều dài
    # -----------------------------------------------------
    la $a0, msg_input_lenght # load address: Nạp địa chỉ của chuỗi 'msg_input_dai' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In thông báo yêu cầu nhập chiều dài.

    li $v0, 5             # load immediate: Mã dịch vụ 5 (read_int).
    syscall               # Đọc số nguyên chiều dài.
    move $t0, $v0         # move: Lưu chiều dài vào $t0. ($t0 = chieu_dai)

    # -----------------------------------------------------
    # 2. Nhập chiều rộng
    # -----------------------------------------------------
    la $a0, msg_input_width # Nạp địa chỉ của chuỗi 'msg_input_rong' vào $a0.
    li $v0, 4              # Mã dịch vụ 4.
    syscall                # In thông báo yêu cầu nhập chiều rộng.

    li $v0, 5              # Mã dịch vụ 5.
    syscall                # Đọc số nguyên chiều rộng.
    move $t1, $v0          # Lưu chiều rộng vào $t1. ($t1 = chieu_rong)

    # -----------------------------------------------------
    # 3. Tính Chu vi: Chu vi = (Chiều dài + Chiều rộng) * 2
    # -----------------------------------------------------
    add $t2, $t0, $t1     # add: Cộng chiều dài ($t0) và chiều rộng ($t1).
                          # Kết quả lưu vào $t2. ($t2 = chieu_dai + chieu_rong)

    li $t3, 2             # load immediate: Nạp hằng số 2 vào $t3.

    mult $t2, $t3         # mult: Nhân tổng ($t2) với 2 ($t3).
                          # Kết quả 64-bit lưu vào hi (32 bit cao) và lo (32 bit thấp).

    mflo $s0              # mflo: Move From Lo. Di chuyển 32 bit thấp của kết quả nhân (chu vi)
                          #       vào thanh ghi $s0. ($s0 = chu_vi)
                          # (Giả định chu vi không quá lớn gây tràn 32 bit)

    # -----------------------------------------------------
    # 4. Xuất kết quả Chu vi
    # -----------------------------------------------------
    la $a0, msg_perimeter # Nạp địa chỉ của chuỗi 'msg_chu_vi' vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi thông báo "Chu vi hinh chu nhat la: ".

    move $a0, $s0         # Di chuyển kết quả chu vi từ $s0 vào $a0.
                          # ($a0 bây giờ chứa chu vi cần in)
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # Thực hiện syscall để in giá trị chu vi ra màn hình.

    la $a0, line_brk      # In kí tự xuống dòng để kết thúc dòng output.
    li $v0, 4
    syscall

    # -----------------------------------------------------
    # 5. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # Mã dịch vụ 10 (exit).
    syscall               # Thoát chương trình.