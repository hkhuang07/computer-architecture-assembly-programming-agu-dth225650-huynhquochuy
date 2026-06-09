.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo và buffer
    # -----------------------------------------------------
    msg_input_string:   .asciiz "Enter your string: "       # Chuỗi thông báo yêu cầu người dùng nhập chuỗi
    msg_reverse_string: .asciiz "Result: "                  # Chuỗi thông báo hiển thị chuỗi đã đảo ngược
    line_brk:           .asciiz "\n"                        # Ký tự xuống dòng (newline) để xuống dòng trong output
    
    # input_buffer: Vùng nhớ 256 bytes để lưu chuỗi gốc nhập từ người dùng.
    # Đủ cho 255 ký tự + 1 byte cho ký tự null ('\0') kết thúc chuỗi.
    input_buffer:       .space 256                          
    
    # output_buffer: Vùng nhớ 256 bytes để lưu chuỗi đã được đảo ngược.
    # Kích thước phải bằng hoặc lớn hơn input_buffer.
    output_buffer:      .space 256                          

.text
.globl main

main:
    # -----------------------------------------------------------------------------
    # 1. Nhập chuỗi từ bàn phím
    # -----------------------------------------------------------------------------
    # Hiển thị thông báo "Enter your string: "
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
    # 2. Tìm vị trí kết thúc thực sự của chuỗi gốc
    #    (Loại bỏ ký tự '\n' hoặc các ký tự không mong muốn ở cuối do syscall 8)
    # -----------------------------------------------------------------------------
    # Gán input_ptr_read (con trỏ duyệt để tìm cuối chuỗi) = địa chỉ của input_buffer
    la $t0, input_buffer        # load address: $t0 sẽ đóng vai trò là 'input_ptr_read'.

    # input_ptr_effective_end (sẽ lưu địa chỉ của ký tự cuối cùng hợp lệ)
    # Khởi tạo giả định là chuỗi rỗng hoặc chỉ chứa ký tự không hợp lệ.
    addi $s0, $t0, -1           # add immediate: $s0 = 'input_ptr_effective_end', khởi tạo là (địa chỉ input_buffer - 1).
                                # Nếu chuỗi rỗng, sau vòng lặp $s0 vẫn giữ giá trị này.

    VONG_LAP_Tim_Cuoi_Chuoi:
        lb $t1, ($t0)           # load byte: Đọc ký tự từ địa chỉ mà $t0 đang trỏ tới vào $t1 ('current_char').
        
        # NẾU current_char == 0 (null terminator) HOẶC current_char == '\n' THÌ
        li $t2, '\n'            # load immediate: Nạp mã ASCII của ký tự '\n' vào $t2 để so sánh.
        beqz $t1, Ket_Thuc_Tim_Cuoi_Chuoi # branch if equal zero: Nếu $t1 là 0 ('\0'), nhảy đến nhãn 'Ket_Thuc_Tim_Cuoi_Chuoi'.
        beq $t1, $t2, Ket_Thuc_Tim_Cuoi_Chuoi # branch if equal: Nếu $t1 bằng $t2 ('\n'), cũng nhảy đến 'Ket_Thuc_Tim_Cuoi_Chuoi'.
        # KẾT_THÚC_NẾU

        # Nếu không phải null hay newline, tiếp tục duyệt và cập nhật input_ptr_effective_end
        move $s0, $t0           # move: $s0 = 'input_ptr_effective_end' = địa chỉ của ký tự hiện tại.
        addi $t0, $t0, 1        # add immediate: Tăng $t0 lên 1 để trỏ tới ký tự tiếp theo.
        j VONG_LAP_Tim_Cuoi_Chuoi # jump: Quay lại đầu vòng lặp.

    Ket_Thuc_Tim_Cuoi_Chuoi:
    # Tại đây, $s0 ('input_ptr_effective_end') đang trỏ tới ký tự cuối cùng "thực sự" của chuỗi.
    # (Nếu chuỗi rỗng, $s0 vẫn sẽ là địa chỉ_input_buffer - 1).

    # -----------------------------------------------------------------------------
    # 3. Đảo ngược chuỗi: Sao chép từ cuối chuỗi gốc sang đầu chuỗi mới
    # -----------------------------------------------------------------------------
    la $t3, output_buffer       # load address: $t3 = 'output_ptr_write', khởi tạo bằng địa chỉ đầu 'output_buffer'.

    VONG_LAP_Dao_Nguoc:
        # NẾU input_ptr_effective_end < địa chỉ của input_buffer THÌ
        # (Sử dụng $t0 để lấy địa chỉ bắt đầu của input_buffer để so sánh)
        la $t5, input_buffer    # load address: Nạp địa chỉ bắt đầu của input_buffer vào $t5.
        blt $s0, $t5, Ket_Thuc_Dao_Nguoc # branch less than: Nếu $s0 ('input_ptr_effective_end') nhỏ hơn $t5,
                                        # nghĩa là đã sao chép tất cả các ký tự hợp lệ. Nhảy đến 'Ket_Thuc_Dao_Nguoc'.
        # KẾT_THÚC_NẾU

        lb $t1, ($s0)           # load byte: Đọc ký tự từ địa chỉ ($s0) vào $t1 ('char_to_copy').
        sb $t1, ($t3)           # store byte: Ghi (lưu) ký tự từ $t1 vào địa chỉ ($t3).

        addi $s0, $s0, -1       # add immediate: Giảm $s0 đi 1 (di chuyển con trỏ đọc lùi về đầu chuỗi gốc).
        addi $t3, $t3, 1        # add immediate: Tăng $t3 lên 1 (di chuyển con trỏ ghi tiến về cuối chuỗi mới).
        j VONG_LAP_Dao_Nguoc    # jump: Quay lại đầu vòng lặp để tiếp tục đảo ngược.

    Ket_Thuc_Dao_Nguoc:
    # -----------------------------------------------------------------------------
    # 4. Kết thúc chuỗi đảo ngược bằng ký tự null ('\0')
    # -----------------------------------------------------------------------------
    sb $zero, ($t3)             # store byte: Ghi giá trị 0 (ký tự null) vào vị trí hiện tại của $t3.
                                # Điều này đảm bảo chuỗi trong 'output_buffer' là một chuỗi hợp lệ kết thúc bằng null.

    # -----------------------------------------------------------------------------
    # 5. Xuất chuỗi đã đảo ngược ra màn hình
    # -----------------------------------------------------------------------------
    # In ký tự xuống dòng
    la $a0, line_brk            # load address: Nạp địa chỉ của 'line_brk' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in một dòng mới, giúp output rõ ràng.
    
    # In thông báo "Result: "
    la $a0, msg_reverse_string  # load address: Nạp địa chỉ của 'msg_reverse_string' vào $a0.
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in thông báo.
    
    # In chuỗi đảo ngược từ output_buffer
    la $a0, output_buffer       # load address: Nạp địa chỉ *bắt đầu* của 'output_buffer' vào $a0.
                                # ($a0 là đối số cho Syscall 4 để in chuỗi đã đảo ngược).
    li $v0, 4                   # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                     # Thực hiện syscall để in chuỗi đã đảo ngược ra màn hình.
    
    # -----------------------------------------------------------------------------
    # 6. Thoát chương trình
    # -----------------------------------------------------------------------------
    li $v0, 10                  # load immediate: Nạp giá trị 10 vào $v0 (Mã dịch vụ 10 là 'exit').
    syscall                     # Thực hiện syscall để thoát chương trình.