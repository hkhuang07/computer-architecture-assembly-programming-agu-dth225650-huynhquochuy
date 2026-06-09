.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và kí tự xuống dòng
    # -----------------------------------------------------
    msg_input1: .asciiz "Nhap so nguyen thu nhat: " # Chuỗi thông báo yêu cầu nhập số thứ nhất
    msg_input2: .asciiz "Nhap so nguyen thu hai: "  # Chuỗi thông báo yêu cầu nhập số thứ hai
    msg_sub: 	.asciiz   "Hieu hai so nguyen la: "   # Chuỗi thông báo kết quả tổng
    line_brk: 	.asciiz"\n"                      # Kí tự xuống dòng (newline) để xuống dòng trong output

.text
.globl main                            # Khai báo nhãn 'main' là toàn cục, điểm bắt đầu của chương trình

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên thứ nhất
    # -----------------------------------------------------
    la  $a0,msg_input1    # load address: Nạp địa chỉ của chuỗi 'msg_input1' vào thanh ghi $a0.
                          # ($a0 dùng để truyền đối số cho syscall print_string)
    li 	$v0,4             # load immediate: Nạp giá trị 4 vào thanh ghi $v0.
                          # (Mã dịch vụ 4 là 'print_string')
    syscall               # Thực hiện syscall để in chuỗi thông báo ra màn hình.

    li 	$v0,5             # load immediate: Nạp giá trị 5 vào thanh ghi $v0.
                          # (Mã dịch vụ 5 là 'read_int' - đọc một số nguyên từ bàn phím)
    syscall               # Thực hiện syscall để đọc số nguyên.
                          # Số nguyên đọc được sẽ được lưu tự động vào thanh ghi $v0.

    move $t0,$v0          # move: Di chuyển giá trị từ thanh ghi $v0 (chứa số thứ nhất vừa đọc)
                          #       vào thanh ghi tạm thời $t0. ($t0 sẽ lưu số thứ nhất)

    # -----------------------------------------------------
    # 2. Nhập số nguyên thứ hai
    # -----------------------------------------------------
    la $a0,msg_input2     # load address: Nạp địa chỉ của chuỗi 'msg_input2' vào thanh ghi $a0.
    li $v0,4              # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall               # Thực hiện syscall để in chuỗi thông báo ra màn hình.

    li $v0,5              # load immediate: Nạp giá trị 5 vào thanh ghi $v0.
                          # (Mã dịch vụ 5 là 'read_int')
    syscall               # Thực hiện syscall để đọc số nguyên.
                          # Số nguyên đọc được sẽ được lưu tự động vào thanh ghi $v0.

    move $t1,$v0          # move: Di chuyển giá trị từ thanh ghi $v0 (chứa số thứ hai vừa đọc)
                          #       vào thanh ghi tạm thời $t1. ($t1 sẽ lưu số thứ hai)

    # -----------------------------------------------------
    # 3. In một kí tự xuống dòng (để output không bị dính vào dòng nhập cuối cùng)
    # -----------------------------------------------------
    la $a0,line_brk  	  # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0,4              # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                      # Thực hiện syscall để in kí tự xuống dòng.

    # -----------------------------------------------------
    # 4. Tính hiệu hai số nguyên
    # -----------------------------------------------------
    sub $s0,$t0,$t1     # sub: Trừ giá trị của thanh ghi $t0 (số thứ nhất)
                          #  với giá trị của thanh ghi $t1 (số thứ hai).
                          #  Lưu kết quả tổng vào thanh ghi $s0.
                          # ($s0 là thanh ghi lưu trữ - saved register, thường dùng để lưu kết quả trung gian quan trọng)

    # -----------------------------------------------------
    # 5. Xuất kết quả tổng ra màn hình
    # -----------------------------------------------------
    la $a0,msg_sub         # load address: Nạp địa chỉ của chuỗi 'msg_sum' vào thanh ghi $a0.
    li $v0,4       	  # load immediate: Mã dịch vụ 4 là 'print_string'.
                 	  # Thực hiện syscall để in chuỗi thông báo "Tong hai so nguyen la: ".

    move $a0,$s0                # move: Di chuyển giá trị từ thanh ghi $s0 (chứa kết quả tổng)
                          #       vào thanh ghi $a0.
                          # ($a0 bây giờ chứa số nguyên cần in ra màn hình)
    li $v0,1              # load immediate: Nạp giá trị 1 vào thanh ghi $v0.
                          # (Mã dịch vụ 1 là 'print_int' - in một số nguyên)
    syscall               # Thực hiện syscall để in giá trị của tổng ra màn hình.

    # -----------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0,10           # load immediate: Nạp giá trị 10 vào thanh ghi $v0.
                          # (Mã dịch vụ 10 là 'exit' - thoát chương trình)
    syscall               # Thực hiện syscall để kết thúc chương trình.
