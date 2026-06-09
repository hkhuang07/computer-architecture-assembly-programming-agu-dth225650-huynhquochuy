.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_input1: .asciiz "Nhap so nguyen thu nhat: "
    msg_input2: .asciiz "Nhap so nguyen thu hai: "
    msg_input3: .asciiz "Nhap so nguyen thu ba: "
    msg_max:    .asciiz "Gia tri lon nhat la: "
    line_brk:   .asciiz "\n"

.text
.globl main

main:
    # -----------------------------------------------------
    # 1. Nhập ba số nguyên
    # -----------------------------------------------------
    # Nhập số thứ nhất vào $t0
    la $a0, msg_input1
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t0, $v0         # $t0 = So_1

    # Nhập số thứ hai vào $t1
    la $a0, msg_input2
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t1, $v0         # $t1 = So_2

    # Nhập số thứ ba vào $t2
    la $a0, msg_input3
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $t2, $v0         # $t2 = So_3

    # -----------------------------------------------------
    # 2. Tìm giá trị lớn nhất (MAX)
    # Phương pháp: So sánh từng cặp và giữ lại giá trị lớn hơn.
    # Ban đầu giả sử số thứ nhất là lớn nhất, sau đó so sánh với các số còn lại.
    # -----------------------------------------------------
    move $s0, $t0         # Giả sử $s0 (MAX) ban đầu là So_1 ($t0)

    # So sánh $s0 (MAX hiện tại) với So_2 ($t1)
    bge $s0, $t1, Check_So3  # bge: Branch if Greater Than or Equal.
                             # Nếu $s0 >= $t1, nghĩa là $s0 vẫn là MAX hoặc bằng,
                             # thì không cần cập nhật, nhảy đến Check_So3.
    move $s0, $t1            # Nếu $s0 < $t1, thì $t1 lớn hơn, cập nhật $s0 = $t1.

Check_So3:
    # So sánh $s0 (MAX hiện tại) với So_3 ($t2)
    bge $s0, $t2, FoundMax   # Nếu $s0 >= $t2, nghĩa là $s0 vẫn là MAX hoặc bằng,
                             # thì đã tìm thấy MAX, nhảy đến FoundMax.
    move $s0, $t2            # Nếu $s0 < $t2, thì $t2 lớn hơn, cập nhật $s0 = $t2.

FoundMax:
    # -----------------------------------------------------
    # 3. Xuất kết quả
    # -----------------------------------------------------
    la $a0, msg_max       # Nạp địa chỉ chuỗi thông báo kết quả vào $a0.
    li $v0, 4             # Mã dịch vụ 4 (print_string).
    syscall               # In chuỗi.

    move $a0, $s0         # Di chuyển giá trị MAX cuối cùng từ $s0 vào $a0.
                          # ($a0 bây giờ chứa số lớn nhất cần in)
    li $v0, 1             # Mã dịch vụ 1 (print_int).
    syscall               # In giá trị MAX.

    la $a0, line_brk      # In kí tự xuống dòng.
    li $v0, 4
    syscall

    # -----------------------------------------------------
    # 4. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10            # Mã dịch vụ 10 (exit).
    syscall               # Thoát chương trình.