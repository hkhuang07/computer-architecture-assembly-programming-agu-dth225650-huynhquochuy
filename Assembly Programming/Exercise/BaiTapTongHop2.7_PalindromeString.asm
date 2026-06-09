.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và buffer
    # -----------------------------------------------------
    msg_input_string:   .asciiz "Enter your string: "      # Chuỗi thông báo yêu cầu người dùng nhập chuỗi
    msg_is_palindrome:  .asciiz " is palindrome string "        # Chuỗi thông báo khi chuỗi là đối xứng
    msg_not_palindrome: .asciiz " is not palindrome string" # Chuỗi thông báo khi chuỗi không đối xứng
    line_brk:           .asciiz "\n"                        # Ký tự xuống dòng (newline) để định dạng output

    # input_buffer: Vùng nhớ 256 bytes để lưu chuỗi gốc nhập từ người dùng.
    # Đủ cho 255 ký tự + 1 byte cho ký tự null ('\0') kết thúc chuỗi.
    input_buffer:       .space 256

.text
.globl main

main:
    # -----------------------------------------------------------------------------
    # 1. Nhập chuỗi từ bàn phím
    # -----------------------------------------------------------------------------
    # Hiển thị thông báo "Nhap vao mot chuoi: "
    la $a0, msg_input_string    # load address: Nạp địa chỉ của chuỗi 'msg_input_string' vào thanh ghi $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string' (in chuỗi).
    syscall                     # Thực hiện syscall để in thông báo ra màn hình.

    # Đọc chuỗi từ bàn phím và lưu vào input_buffer
    la $a0, input_buffer        # load address: Nạp địa chỉ của 'input_buffer' vào $a0.
                                # ($a0 là đối số chỉ ra nơi Syscall 8 sẽ lưu chuỗi).
    li $a1, 256                 # load immediate: Nạp kích thước tối đa của buffer (256 bytes) vào $a1.
                                # ($a1 là đối số chỉ ra kích thước tối đa mà Syscall 8 có thể ghi).
    li $v0, 8                   # load immediate: Mã dịch vụ 8 là 'read_string' (đọc chuỗi).
    syscall                     # Thực hiện syscall để đọc chuỗi từ bàn phím.
                                # Chuỗi người dùng nhập sẽ được lưu vào 'input_buffer'.

    # -----------------------------------------------------------------------------
    # 2. Tìm vị trí bắt đầu và kết thúc hiệu quả của chuỗi
    #    (Loại bỏ ký tự '\n' hoặc các ký tự không mong muốn ở cuối do syscall 8)
    # -----------------------------------------------------------------------------
    la $t0, input_buffer        # load address: $t0 = 'ptr_left', con trỏ bắt đầu từ đầu chuỗi.
    la $t1, input_buffer        # load address: $t1 = 'ptr_right', con trỏ sẽ duyệt đến cuối chuỗi.

    # VÒNG_LẶP_Tìm_Cuối_Chuỗi: Di chuyển $t1 (ptr_right) đến cuối chuỗi (trước '\0' hoặc '\n')
    Loop_Find_End:
        lb $t2, ($t1)           # load byte: Đọc ký tự tại vị trí $t1 đang trỏ tới vào $t2 ('char_hien_tai').
        
        # NẾU char_hien_tai == '\0' HOẶC char_hien_tai == '\n' THÌ
        li $t3, '\n'            # load immediate: Nạp mã ASCII của ký tự '\n' vào $t3 để so sánh.
        beqz $t2, End_Loop_Find_End # branch if equal zero: Nếu $t2 là 0 ('\0'), nhảy đến nhãn 'End_Loop_Find_End'.
        beq $t2, $t3, End_Loop_Find_End # branch if equal: Nếu $t2 bằng $t3 ('\n'), cũng nhảy đến 'End_Loop_Find_End'.
        # KẾT_THÚC_NẾU

        addi $t1, $t1, 1        # add immediate: Tăng $t1 lên 1 (di chuyển 'ptr_right' tới ký tự tiếp theo).
        j Loop_Find_End         # jump: Quay lại đầu vòng lặp.

    End_Loop_Find_End:
    # Tại đây, $t1 đang trỏ tới ký tự '\0' hoặc '\n' đầu tiên.
    # Vị trí của ký tự cuối cùng "thực sự" của chuỗi (mà chúng ta muốn so sánh) là $t1 - 1.
    addi $t1, $t1, -1           # add immediate: Giảm $t1 đi 1, bây giờ $t1 ('ptr_right') trỏ tới ký tự cuối cùng hợp lệ.
                                # (Ví dụ: "daiad\n\0" -> $t1 ban đầu trỏ vào '\n', sau đó giảm thành 'd')

    # -----------------------------------------------------------------------------
    # 3. So sánh các ký tự từ hai phía
    # -----------------------------------------------------------------------------
    li $s0, 1                   # load immediate: $s0 = 'is_palindrome_flag'. Khởi tạo = 1 (mặc định là đối xứng).

    VONG_LAP_Kiem_Tra_Doi_Xung:
        # Điều kiện dừng: Khi 'ptr_left' ($t0) vượt qua hoặc bằng 'ptr_right' ($t1).
        # Tức là đã duyệt hết hoặc đi qua điểm giữa của chuỗi.
        bge $t0, $t1, End_Loop_Kiem_Tra_Doi_Xung # branch greater than or equal: Nếu $t0 >= $t1, nhảy thoát vòng lặp.

        lb $t2, ($t0)           # load byte: Đọc ký tự từ vị trí 'ptr_left' ($t0) vào $t2 ('char_left').
        lb $t3, ($t1)           # load byte: Đọc ký tự từ vị trí 'ptr_right' ($t1) vào $t3 ('char_right').

        bne $t2, $t3, Not_Palindrome # branch not equal: NẾU 'char_left' KHÁC 'char_right' THÌ
                                    #   GÁN 'is_palindrome_flag' = 0
                                    #   THOÁT_KHỎI VÒNG_LẶP_Kiem_Tra_Doi_Xung (nhảy đến Not_Palindrome)

        addi $t0, $t0, 1        # add immediate: Tăng 'ptr_left' ($t0) lên 1 (tiến vào giữa từ bên trái).
        addi $t1, $t1, -1       # add immediate: Giảm 'ptr_right' ($t1) đi 1 (tiến vào giữa từ bên phải).
        j VONG_LAP_Kiem_Tra_Doi_Xung # jump: Quay lại đầu vòng lặp.

    Not_Palindrome:
        li $s0, 0               # load immediate: GÁN 'is_palindrome_flag' = 0 (chuỗi không đối xứng).

    End_Loop_Kiem_Tra_Doi_Xung:
    # Vòng lặp kết thúc. Kết quả kiểm tra nằm trong $s0.

    # -----------------------------------------------------------------------------
    # 4. Xuất kết quả ra màn hình
    # -----------------------------------------------------------------------------
    la $a0, line_brk            # load address: Nạp địa chỉ của 'line_brk' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in một dòng mới.

    la $a0, input_buffer        # load address: Nạp địa chỉ của 'input_buffer' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in lại chuỗi ban đầu.

    beq $s0, $zero, Print_Not_Palindrome # branch if equal: NẾU 'is_palindrome_flag' ($s0) == 0 (FALSE) THÌ
                                        #   Nhảy đến 'Print_Not_Palindrome'.

    # NẾU is_palindrome_flag == 1 (chuỗi đối xứng)
    la $a0, msg_is_palindrome   # load address: Nạp địa chỉ của 'msg_is_palindrome' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in " la chuoi doi xung".
    j Exit_Program              # jump: Nhảy đến 'Exit_Program' để kết thúc.

Print_Not_Palindrome:
    # KHÔNG THÌ (chuỗi không đối xứng)
    la $a0, msg_not_palindrome  # load address: Nạp địa chỉ của 'msg_not_palindrome' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in " khong phai la chuoi doi xung".

Exit_Program:
    # -----------------------------------------------------------------------------
    # 5. Thoát chương trình
    # -----------------------------------------------------------------------------
    li $v0, 10                  # load immediate: Nạp giá trị 10 vào $v0 (Mã dịch vụ 10 là 'exit').
    syscall                     # Thực hiện syscall để thoát chương trình.