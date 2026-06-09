.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và buffer
    # -----------------------------------------------------
    msg_input_string:       .asciiz "Nhap vao mot chuoi: "          # Chuỗi thông báo yêu cầu người dùng nhập chuỗi
    
    msg_count_digit:        .asciiz "So ki tu la so: "              # Chuỗi thông báo cho số lượng ký tự số
    msg_count_alpha:        .asciiz "So ki tu la chu: "             # Chuỗi thông báo cho số lượng ký tự chữ
    msg_count_other:        .asciiz "So ki tu khac: "               # Chuỗi thông báo cho số lượng ký tự khác
    
    line_brk:               .asciiz "\n"                            # Ký tự xuống dòng (newline)
    
    # input_buffer: Vùng nhớ 256 bytes để lưu chuỗi gốc nhập từ người dùng.
    # Đủ cho 255 ký tự + 1 byte cho ký tự null ('\0') kết thúc chuỗi.
    input_buffer:           .space 256

.text
.globl main

main:
    # -----------------------------------------------------------------------------
    # 1. Khởi tạo các biến đếm
    # -----------------------------------------------------------------------------
    li $s0, 0                       # load immediate: $s0 sẽ đếm số ký tự là số (digit_count = 0)
    li $s1, 0                       # load immediate: $s1 sẽ đếm số ký tự là chữ (alpha_count = 0)
    li $s2, 0                       # load immediate: $s2 sẽ đếm số ký tự khác (other_count = 0)

    # -----------------------------------------------------------------------------
    # 2. Nhập chuỗi từ bàn phím
    # -----------------------------------------------------------------------------
    # Hiển thị thông báo "Nhap vao mot chuoi: "
    la $a0, msg_input_string        # load address: Nạp địa chỉ của chuỗi 'msg_input_string' vào $a0.
    li $v0, 4                       # load immediate: Mã dịch vụ 4 là 'print_string' (in chuỗi).
    syscall                         # Thực hiện syscall để in thông báo ra màn hình.

    # Đọc chuỗi từ bàn phím và lưu vào input_buffer
    la $a0, input_buffer            # load address: Nạp địa chỉ của 'input_buffer' vào $a0.
                                    # ($a0 là đối số chỉ ra nơi Syscall 8 sẽ lưu chuỗi).
    li $a1, 256                     # load immediate: Nạp kích thước tối đa của buffer (256 bytes) vào $a1.
                                    # ($a1 là đối số chỉ ra kích thước tối đa mà Syscall 8 có thể ghi).
    li $v0, 8                       # load immediate: Mã dịch vụ 8 là 'read_string' (đọc chuỗi).
    syscall                         # Thực hiện syscall để đọc chuỗi từ bàn phím.
                                    # Chuỗi người dùng nhập sẽ được lưu vào 'input_buffer'.

    # -----------------------------------------------------------------------------
    # 3. Duyệt chuỗi và phân loại ký tự
    # -----------------------------------------------------------------------------
    la $t0, input_buffer            # load address: $t0 = con trỏ duyệt chuỗi (current_char_ptr), khởi tạo bằng địa chỉ đầu chuỗi.

    Loop_Count_Chars:
        lb $t1, ($t0)               # load byte: Đọc ký tự tại vị trí $t0 đang trỏ tới vào $t1 (current_char).
        
        # Kiểm tra điều kiện dừng: Nếu gặp ký tự null ('\0'), chuỗi đã kết thúc.
        beqz $t1, End_Loop_Count_Chars # branch if equal zero: Nếu $t1 là 0 ('\0'), nhảy đến nhãn 'End_Loop_Count_Chars'.

        # Loại bỏ ký tự xuống dòng ('\n') nếu có, không đếm nó vào bất kỳ loại nào
        li $t2, '\n'                # load immediate: Nạp mã ASCII của ký tự '\n' vào $t2.
        beq $t1, $t2, Next_Char     # branch if equal: Nếu $t1 là '\n', nhảy thẳng đến 'Next_Char' để bỏ qua.

        # -------------------------------------------------------------------------
        # Phân loại ký tự: Chữ số (0-9)?
        # -------------------------------------------------------------------------
        li $t3, '0'                 # load immediate: Nạp mã ASCII của '0' vào $t3.
        li $t4, '9'                 # load immediate: Nạp mã ASCII của '9' vào $t4.
        
        blt $t1, $t3, Check_Alpha   # branch less than: Nếu $t1 < '0', không phải số, nhảy đến kiểm tra chữ cái.
        bgt $t1, $t4, Check_Alpha   # branch greater than: Nếu $t1 > '9', không phải số, nhảy đến kiểm tra chữ cái.
        
        # Nếu đến đây, ký tự là số (0-9)
        addi $s0, $s0, 1            # add immediate: Tăng biến đếm số ($s0) lên 1.
        j Next_Char                 # jump: Nhảy đến 'Next_Char' để xử lý ký tự tiếp theo.

        # -------------------------------------------------------------------------
        # Phân loại ký tự: Chữ cái (a-z, A-Z)?
        # -------------------------------------------------------------------------
    Check_Alpha:
        # Kiểm tra chữ cái hoa (A-Z)
        li $t3, 'A'                 # load immediate: Nạp mã ASCII của 'A' vào $t3.
        li $t4, 'Z'                 # load immediate: Nạp mã ASCII của 'Z' vào $t4.
        
        blt $t1, $t3, Check_Other   # branch less than: Nếu $t1 < 'A', không phải chữ hoa, nhảy đến kiểm tra loại khác.
        bgt $t1, $t4, Add_Alpha_Count # branch greater than: Nếu $t1 > 'Z', có thể là chữ thường hoặc ký tự khác.
                                    # NHƯNG nếu đã vượt qua 'Z', ta cần kiểm tra lại vùng chữ thường riêng.
                                    # Vì vậy, nếu nó lớn hơn 'Z', nó chưa chắc là ký tự khác, có thể là 'a'.
                                    # Ta sẽ nhảy tới một nhãn tạm để xử lý.

        # Nếu đến đây, ký tự là chữ hoa (A-Z)
        j Add_Alpha_Count           # jump: Nhảy đến nhãn để tăng biến đếm chữ cái.

    # Kiểm tra chữ cái thường (a-z) (nếu không phải A-Z)
    Check_Lowercase:
        li $t3, 'a'                 # load immediate: Nạp mã ASCII của 'a' vào $t3.
        li $t4, 'z'                 # load immediate: Nạp mã ASCII của 'z' vào $t4.
        
        blt $t1, $t3, Check_Other   # branch less than: Nếu $t1 < 'a', không phải chữ thường, nhảy đến kiểm tra loại khác.
        bgt $t1, $t4, Check_Other   # branch greater than: Nếu $t1 > 'z', không phải chữ thường, nhảy đến kiểm tra loại khác.
        
        # Nếu đến đây, ký tự là chữ thường (a-z)
        j Add_Alpha_Count           # jump: Nhảy đến nhãn để tăng biến đếm chữ cái.

    Add_Alpha_Count:
        addi $s1, $s1, 1            # add immediate: Tăng biến đếm chữ cái ($s1) lên 1.
        j Next_Char                 # jump: Nhảy đến 'Next_Char' để xử lý ký tự tiếp theo.

        # -------------------------------------------------------------------------
        # Phân loại ký tự: Ký tự khác
        # -------------------------------------------------------------------------
    Check_Other:
        addi $s2, $s2, 1            # add immediate: Tăng biến đếm ký tự khác ($s2) lên 1.
        j Next_Char                 # jump: Nhảy đến 'Next_Char'.

    Next_Char:
        addi $t0, $t0, 1            # add immediate: Tăng con trỏ $t0 lên 1 (di chuyển tới ký tự tiếp theo).
        j Loop_Count_Chars          # jump: Quay lại đầu vòng lặp để xử lý ký tự tiếp theo.

    End_Loop_Count_Chars:
    # Vòng lặp kết thúc. Các biến đếm $s0, $s1, $s2 chứa kết quả cuối cùng.

    # -----------------------------------------------------------------------------
    # 4. Xuất kết quả ra màn hình
    # -----------------------------------------------------------------------------
    # Xuống dòng trước khi in kết quả
    la $a0, line_brk                # load address: Nạp địa chỉ của 'line_brk' vào $a0.
    li $v0, 4                       # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                         # Thực hiện syscall để in một dòng mới.

    # In số lượng ký tự số
    la $a0, msg_count_digit         # load address: Nạp địa chỉ của 'msg_count_digit' vào $a0.
    li $v0, 4                       # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                         # Thực hiện syscall để in "So ki tu la so: ".
    
    move $a0, $s0                   # move: Di chuyển giá trị đếm số từ $s0 vào $a0 (đối số cho print_int).
    li $v0, 1                       # load immediate: Mã dịch vụ 1 là 'print_int' (in số nguyên).
    syscall                         # Thực hiện syscall để in số lượng ký tự số.
    la $a0, line_brk                # Xuống dòng sau số.
    li $v0, 4
    syscall

    # In số lượng ký tự chữ
    la $a0, msg_count_alpha         # load address: Nạp địa chỉ của 'msg_count_alpha' vào $a0.
    li $v0, 4                       # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                         # Thực hiện syscall để in "So ki tu la chu: ".
    
    move $a0, $s1                   # move: Di chuyển giá trị đếm chữ từ $s1 vào $a0.
    li $v0, 1                       # load immediate: Mã dịch vụ 1 là 'print_int'.
    syscall                         # Thực hiện syscall để in số lượng ký tự chữ.
    la $a0, line_brk                # Xuống dòng sau số.
    li $v0, 4
    syscall

    # In số lượng ký tự khác
    la $a0, msg_count_other         # load address: Nạp địa chỉ của 'msg_count_other' vào $a0.
    li $v0, 4                       # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                         # Thực hiện syscall để in "So ki tu khac: ".
    
    move $a0, $s2                   # move: Di chuyển giá trị đếm ký tự khác từ $s2 vào $a0.
    li $v0, 1                       # load immediate: Mã dịch vụ 1 là 'print_int'.
    syscall                         # Thực hiện syscall để in số lượng ký tự khác.
    la $a0, line_brk                # Xuống dòng sau số.
    li $v0, 4
    syscall

    # -----------------------------------------------------------------------------
    # 5. Thoát chương trình
    # -----------------------------------------------------------------------------
    li $v0, 10                      # load immediate: Nạp giá trị 10 vào $v0 (Mã dịch vụ 10 là 'exit').
    syscall                         # Thực hiện syscall để thoát chương trình.