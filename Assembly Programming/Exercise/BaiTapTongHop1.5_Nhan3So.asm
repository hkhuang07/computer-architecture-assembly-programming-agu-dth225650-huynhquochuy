.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_input1: .asciiz "Nhap so nguyen thu nhat: " # Thông báo yêu cầu nhập số thứ nhất
    msg_input2: .asciiz "Nhap so nguyen thu hai: "  # Thông báo yêu cầu nhập số thứ hai
    msg_input3: .asciiz "Nhap so nguyen thu ba: "   # Thông báo yêu cầu nhập số thứ ba
    msg_product: .asciiz "Tich cua ba so: "        # Chuỗi hiển thị trước kết quả tích
    line_brk:   .asciiz "\n"                      # Kí tự xuống dòng (newline)

.text
.globl main                                   # Khai báo nhãn 'main' là toàn cục

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên thứ nhất
    # -----------------------------------------------------
    la $a0, msg_input1    # load address: Nạp địa chỉ của chuỗi 'msg_input1' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In thông báo.

    li $v0, 5             # load immediate: Mã dịch vụ 5 (read_int).
    syscall               # Đọc số nguyên.
    move $t0, $v0         # move: Lưu số thứ nhất vào $t0.

    # -----------------------------------------------------
    # 2. Nhập số nguyên thứ hai
    # -----------------------------------------------------
    la $a0, msg_input2    # Nạp địa chỉ của chuỗi 'msg_input2' vào $a0.
    li $v0, 4             # Mã dịch vụ 4.
    syscall               # In thông báo.

    li $v0, 5             # Mã dịch vụ 5.
    syscall               # Đọc số nguyên.
    move $t1, $v0         # Lưu số thứ hai vào $t1.

    # -----------------------------------------------------
    # 3. Nhập số nguyên thứ ba
    # -----------------------------------------------------
    la $a0, msg_input3    # Nạp địa chỉ của chuỗi 'msg_input3' vào $a0.
    li $v0, 4             # Mã dịch vụ 4.
    syscall               # In thông báo.

    li $v0, 5             # Mã dịch vụ 5.
    syscall               # Đọc số nguyên.
    move $t2, $v0         # Lưu số thứ ba vào $t2.

    # -----------------------------------------------------
    # 4. Tính tích của ba số
    # -----------------------------------------------------
    # Bước 1: Nhân số thứ nhất ($t0) với số thứ hai ($t1)
    mult $t0, $t1         # mult: Thực hiện phép nhân có dấu giữa $t0 và $t1.
                          # Kết quả 64-bit sẽ được lưu vào cặp thanh ghi hi (32 bit cao)
                          # và lo (32 bit thấp).

    mflo $s0              # mflo: Move From Lo. Di chuyển 32 bit thấp của kết quả (tích của $t0 * $t1)
                          #       vào thanh ghi $s0. Thanh ghi $s0 sẽ tạm giữ kết quả trung gian.
                          # (Với các số nhỏ, thường chỉ cần lo)

    # Nếu bạn muốn kiểm tra tràn số, bạn sẽ phải kiểm tra thanh ghi hi ở đây.
    # Tuy nhiên, ví dụ này giả định kết quả không tràn khỏi 32 bit.

    # Bước 2: Nhân kết quả trung gian ($s0) với số thứ ba ($t2)
    mult $s0, $t2         # mult: Thực hiện phép nhân có dấu giữa $s0 (tích của 2 số đầu) và $t2 (số thứ ba).
                          # Kết quả 64-bit mới sẽ lại được lưu vào hi và lo.

    mflo $s1              # mflo: Di chuyển 32 bit thấp của kết quả cuối cùng (tích của 3 số)
                          #       vào thanh ghi $s1. ($s1 sẽ chứa kết quả cuối cùng)

    # -----------------------------------------------------
    # 5. Xuất kết quả tích
    # -----------------------------------------------------
    la $a0, msg_product   # load address: Nạp địa chỉ của chuỗi 'msg_product' vào $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi thông báo "Tich cua ba so: ".

    move $a0, $s1         # move: Di chuyển kết quả tích cuối cùng từ $s1 vào $a0.
                          # ($a0 bây giờ chứa số cần in)
    li $v0, 1             # load immediate: Mã dịch vụ 1 (print_int).
    syscall               # Thực hiện syscall để in giá trị của tích ra màn hình.

    la $a0, line_brk      # In kí tự xuống dòng để kết thúc dòng output.
    li $v0, 4
    syscall

    # -----------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # load immediate: Mã dịch vụ 10 (exit).
    syscall               # Thực hiện syscall để thoát chương trình.