.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và buffer
    # -----------------------------------------------------
    msg_input_string:   .asciiz "Enter your string: "       # Chuỗi thông báo yêu cầu nhập chuỗi
    msg_lowcase_string: .asciiz "Lowercase string: "        # Chuỗi thông báo hiển thị chuỗi đã chuyển đổi
    line_brk:           .asciiz "\n"                        # Kí tự xuống dòng (newline)

    # Buffer cho chuỗi nhập vào: Đủ lớn để chứa chuỗi + ký tự null kết thúc
    # Kích thước 256 bytes sẽ chứa được tối đa 255 ký tự người dùng nhập + 1 byte cho null terminator
    string_buffer:      .space 256

.text
.globl main

main:
    # -----------------------------------------------------------------------------
    # 1. Nhập chuỗi từ bàn phím
    # -----------------------------------------------------------------------------
    la $a0, msg_input_string    # load address: Nạp địa chỉ của chuỗi thông báo vào $a0
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'
    syscall                     # Thực hiện syscall để in thông báo

    la $a0, string_buffer       # load address: Nạp địa chỉ của buffer (vùng nhớ) vào $a0.
                                # ($a0 sẽ là nơi chuỗi nhập vào được lưu trữ)
    li $a1, 256                 # load immediate: Nạp kích thước tối đa của buffer vào $a1.
                                # (Điều này cho syscall 8 biết có bao nhiêu byte nó có thể ghi vào $a0)
    li $v0, 8                   # load immediate: Mã dịch vụ 8 là 'read_string'
    syscall                     # Thực hiện syscall để đọc chuỗi từ bàn phím.
                                # Chuỗi nhập vào sẽ được lưu vào 'string_buffer'.

    # -----------------------------------------------------------------------------
    # 2. Khởi tạo con trỏ và bắt đầu vòng lặp chuyển đổi
    # -----------------------------------------------------------------------------
    la $t0, string_buffer       # load address: Nạp địa chỉ bắt đầu của 'string_buffer' vào $t0.
                                # ($t0 sẽ là con trỏ duyệt qua từng ký tự của chuỗi)

Loop_Start:
    # Lấy ký tự hiện tại từ bộ nhớ mà $t0 đang trỏ tới
    lb $t1, ($t0)               # load byte: Nạp giá trị byte tại địa chỉ ($t0) vào $t1.
                                # ($t1 bây giờ chứa mã ASCII của ký tự hiện tại)

    # Kiểm tra null terminator: Nếu ký tự hiện tại là 0x00 (null), chuỗi đã kết thúc
    beqz $t1, Loop_End          # branch if equal zero: Nếu $t1 bằng 0, nhảy đến nhãn 'Loop_End'.

    # -----------------------------------------------------------------------------
    # 3. Kiểm tra xem ký tự có phải là chữ hoa ('A' đến 'Z') không
    #    Nếu không phải, bỏ qua việc chuyển đổi và chuyển sang ký tự tiếp theo
    # -----------------------------------------------------------------------------
    li $s0, 'A'                 # load immediate: Nạp mã ASCII của ký tự 'A' vào $s0.
    li $s1, 'Z'                 # load immediate: Nạp mã ASCII của ký tự 'Z' vào $s1.
    
    # So sánh: Nếu ký tự ($t1) nhỏ hơn 'A', nó không phải chữ hoa
    blt $t1, $s0, Next_Char     # branch less than: Nếu $t1 < $s0 ('A'), nhảy đến nhãn 'Next_Char'.
    
    # So sánh: Nếu ký tự ($t1) lớn hơn 'Z', nó không phải chữ hoa
    bgt $t1, $s1, Next_Char     # branch greater than: Nếu $t1 > $s1 ('Z'), nhảy đến nhãn 'Next_Char'.

    # -----------------------------------------------------------------------------
    # 4. Nếu đến đây, ký tự là chữ hoa, thực hiện chuyển đổi sang chữ thường
    # -----------------------------------------------------------------------------
    li $s2, 32                  # load immediate: Nạp giá trị offset 32 vào $s2.
                                # (Offset này là 'a' - 'A' = 97 - 65 = 32)
    add $t1, $t1, $s2           # add: Cộng offset 32 vào mã ASCII của ký tự trong $t1.
                                # ($t1 bây giờ chứa mã ASCII của ký tự thường tương ứng)
    sb $t1, ($t0)               # store byte: Ghi (lưu) ký tự đã chuyển đổi từ $t1 trở lại vào bộ nhớ
                                # tại địa chỉ mà $t0 đang trỏ tới (ghi đè lên ký tự hoa cũ).

Next_Char:
    # Tăng con trỏ để di chuyển sang ký tự kế tiếp trong chuỗi
    addi $t0, $t0, 1            # add immediate: Tăng giá trị của $t0 lên 1.

    # Quay lại đầu vòng lặp để xử lý ký tự tiếp theo
    j Loop_Start                # jump: Nhảy không điều kiện về nhãn 'Loop_Start'.

Loop_End:
    # -----------------------------------------------------------------------------
    # 5. Xuất chuỗi đã chuyển đổi ra màn hình
    # -----------------------------------------------------------------------------
    la $a0, line_brk            # load address: Nạp địa chỉ của ký tự xuống dòng vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in một dòng mới, giúp output rõ ràng.
    
    la $a0, msg_lowcase_string  # load address: Nạp địa chỉ của chuỗi "Lowercase string: " vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in thông báo.
    
    la $a0, string_buffer       # load address: Nạp địa chỉ *ban đầu* của 'string_buffer' vào $a0.
                                # (Đây là địa chỉ của chuỗi đã được sửa đổi tại chỗ)
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in chuỗi đã chuyển đổi ra màn hình.
    
    # -----------------------------------------------------------------------------
    # 6. Kết thúc chương trình
    # -----------------------------------------------------------------------------
    li $v0, 10                  # load immediate: Nạp giá trị 10 vào $v0 (Mã dịch vụ 10 là 'exit').
    syscall                     # Thực hiện syscall để thoát chương trình.