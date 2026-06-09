.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và kí tự xuống dòng
    # -----------------------------------------------------
    msg_input1: .asciiz "Nhap so nguyen thu nhat: " # Chuỗi thông báo yêu cầu nhập số thứ nhất
    msg_input2: .asciiz "Nhap so nguyen thu hai: "  # Chuỗi thông báo yêu cầu nhập số thứ hai
    msg_quotient: .asciiz "Thuong so la: "          # Chuỗi thông báo hiển thị trước thương số
    msg_remainder:     .asciiz "So du la: "         # Chuỗi thông báo hiển thị trước số dư
    line_brk:   .asciiz "\n"                        # Kí tự xuống dòng (newline) để xuống dòng trong output
    errordividebyzero: .asciiz "Loi chia cho 0"     # Thông báo lỗi chia cho 0
.text
.globl main                                         # Khai báo nhãn 'main' là toàn cục, điểm bắt đầu của chương trình

main:
    # -----------------------------------------------------
    # 1. Nhập số nguyên thứ nhất
    # -----------------------------------------------------
    la $a0, msg_input1    # load address: Nạp địa chỉ của chuỗi 'msg_input1' vào thanh ghi $a0.
                          # ($a0 dùng để truyền đối số cho syscall print_string)
    li $v0, 4             # load immediate: Nạp giá trị 4 vào thanh ghi $v0.
                          # (Mã dịch vụ 4 là 'print_string')
    syscall               # Thực hiện syscall để in chuỗi thông báo ra màn hình.

    li $v0, 5             # load immediate: Nạp giá trị 5 vào thanh ghi $v0.
                          # (Mã dịch vụ 5 là 'read_int' - đọc một số nguyên từ bàn phím)
    syscall               # Thực hiện syscall để đọc số nguyên.
                          # Số nguyên đọc được sẽ được lưu tự động vào thanh ghi $v0.

    move $t0, $v0         # move: Di chuyển giá trị từ thanh ghi $v0 (chứa số thứ nhất vừa đọc)
                          #       vào thanh ghi tạm thời $t0. ($t0 sẽ lưu số bị chia)

    # -----------------------------------------------------
    # 2. Nhập số nguyên thứ hai
    # -----------------------------------------------------
    la $a0, msg_input2    # load address: Nạp địa chỉ của chuỗi 'msg_input2' vào thanh ghi $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall               # Thực hiện syscall để in chuỗi thông báo ra màn hình.

    li $v0, 5             # load immediate: Nạp giá trị 5 vào thanh ghi $v0.
                          # (Mã dịch vụ 5 là 'read_int')
    syscall               # Thực hiện syscall để đọc số nguyên.
                          # Số nguyên đọc được sẽ được lưu tự động vào thanh ghi $v0.

    move $t1, $v0         # move: Di chuyển giá trị từ thanh ghi $v0 (chứa số thứ hai vừa đọc)
                          #       vào thanh ghi tạm thời $t1. ($t1 sẽ lưu số chia)

    # -----------------------------------------------------
    # Kiểm tra số chia có bằng 0 không (tránh lỗi chia cho 0)
    # -----------------------------------------------------
    beqz $t1, ErrorDivideByZero # beqz: Branch if Equal to Zero.
                                 # Nếu $t1 (số chia) bằng 0, nhảy đến nhãn 'ErrorDivideByZero'.
                                 # Đây là một bước kiểm tra an toàn để tránh lỗi runtime.

    # -----------------------------------------------------
    # 3. Thực hiện phép chia
    # -----------------------------------------------------
    div $t0, $t1          # div: Thực hiện phép chia có dấu giữa $t0 (số bị chia) và $t1 (số chia).
                          # - Thương số (quotient) sẽ được lưu tự động vào thanh ghi đặc biệt 'lo'.
                          # - Số dư (remainder) sẽ được lưu tự động vào thanh ghi đặc biệt 'hi'.

    # -----------------------------------------------------
    # 4. Xuất Thương số
    # -----------------------------------------------------
    la $a0, msg_quotient  # load address: Nạp địa chỉ của chuỗi 'msg_thuong' vào thanh ghi $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall               # Thực hiện syscall để in chuỗi thông báo "Thuong so la: ".

    mflo $a0              # mflo: Move From Lo. Di chuyển giá trị từ thanh ghi 'lo' (thương số)
                          #       vào thanh ghi $a0. ($a0 bây giờ chứa thương số cần in)
    li $v0, 1             # load immediate: Mã dịch vụ 1 là 'print_int'.
    syscall               # Thực hiện syscall để in giá trị của thương số ra màn hình.

    la $a0, line_brk      # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall               # Thực hiện syscall để in kí tự xuống dòng, chuyển sang dòng mới cho số dư.

    # -----------------------------------------------------
    # 5. Xuất Số dư
    # -----------------------------------------------------
    la $a0, msg_remainder # load address: Nạp địa chỉ của chuỗi 'msg_du' vào thanh ghi $a0.
    li $v0, 4             # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall               # Thực hiện syscall để in chuỗi thông báo "So du la: ".

    mfhi $a0              # mfhi: Move From Hi. Di chuyển giá trị từ thanh ghi 'hi' (số dư)
                          #       vào thanh ghi $a0. ($a0 bây giờ chứa số dư cần in)
    li $v0, 1             # load immediate: Mã dịch vụ 1 là 'print_int'.
    syscall
    
    # -----------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10                  # load immediate: Nạp giá trị 10 vào thanh ghi $v0.
                                # (Mã dịch vụ 10 là 'exit' - thoát chương trình)
    syscall                     # Thực hiện syscall để kết thúc chương trình.
   
ErrorDivideByZero:
    la $a0,errordividebyzero
    li $v0,4
    syscall
    
    li $v0,10
    syscall 
     