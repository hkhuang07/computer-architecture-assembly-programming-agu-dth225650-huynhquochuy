.data
    # -----------------------------------------------------
    # Phần khai báo dữ liệu: Các chuỗi thông báo
    # -----------------------------------------------------
    msg_character:      .asciiz "Enter your character: "    # Chuỗi thông báo yêu cầu người dùng nhập ký tự
    msg_result:         .asciiz "Your character after upcase: " # Chuỗi thông báo hiển thị kết quả ký tự sau khi xử lý
    line_brk:           .asciiz "\n"                        # Kí tự xuống dòng (newline) để xuống dòng trong output

.text
.globl main

main:
	
    # 1. Nhập một kí tự từ bàn phím
    # -----------------------------------------------------
    la $a0, msg_character   # load address: Nạp địa chỉ của chuỗi 'msg_character' vào thanh ghi $a0.
                            # ($a0 dùng để truyền đối số cho syscall print_string)
    li $v0, 4               # load immediate: Nạp giá trị 4 vào thanh ghi $v0 (Mã dịch vụ 4 là 'print_string').
    syscall                 # Thực hiện syscall để in chuỗi thông báo ra màn hình.
    
    li $v0, 12              # load immediate: Nạp giá trị 12 vào thanh ghi $v0.
                            # (Mã dịch vụ 12 là 'read_char' - đọc một ký tự từ bàn phím)
    syscall                 # Thực hiện syscall để đọc ký tự.
                            # Ký tự đọc được sẽ được lưu tự động vào thanh ghi $v0 (dưới dạng mã ASCII).
    
    move $t0, $v0           # move: Di chuyển giá trị từ thanh ghi $v0 (chứa ký tự vừa đọc)
                            #       vào thanh ghi tạm thời $t0. ($t0 sẽ lưu trữ ký tự gốc để xử lý)
    
    # -----------------------------------------------------
    # 2. Kiểm tra ký tự có phải là chữ thường ('a' đến 'z') không
    #    Nếu không phải, nhảy đến phần in trực tiếp ký tự gốc
    # -----------------------------------------------------
    li $s0, 'a'             # load immediate: Nạp mã ASCII của ký tự 'a' vào thanh ghi $s0.
    li $s1, 'z'             # load immediate: Nạp mã ASCII của ký tự 'z' vào thanh ghi $s1.
    li $s2, 'A'             # load immediate: Nạp mã ASCII của ký tự 'A' vào thanh ghi $s2 (dùng để tính offset).
    
    # Kiểm tra: Nếu ký tự trong $t0 nhỏ hơn 'a', không phải chữ thường, nhảy đến in trực tiếp
    blt $t0, $s0, PrintCharDirectly 
                            # branch less than: Nếu $t0 < $s0 ('a'), nhảy đến nhãn 'PrintCharDirectly'.
    
    # Kiểm tra: Nếu ký tự trong $t0 lớn hơn 'z', không phải chữ thường, nhảy đến in trực tiếp
    bgt $t0, $s1, PrintCharDirectly 
                            # branch greater than: Nếu $t0 > $s1 ('z'), nhảy đến nhãn 'PrintCharDirectly'.
    
    # -----------------------------------------------------
    # 3. Nếu là chữ thường, chuyển đổi sang chữ hoa
    # -----------------------------------------------------
    # Tính offset: ('a' - 'A') = 97 - 65 = 32. Offset này là khoảng cách giữa chữ thường và chữ hoa tương ứng.
    sub $t1, $s0, $s2       # subtract: Tính $s0 ('a') - $s2 ('A') và lưu kết quả vào $t1 (offset = 32).
    
    # Chuyển đổi ký tự thường sang hoa: Trừ offset từ ký tự gốc
    sub $t0, $t0, $t1       # subtract: Lấy ký tự gốc trong $t0 trừ đi offset trong $t1.
                            #           Kết quả (ký tự hoa) được lưu lại vào $t0.
    
PrintCharDirectly:
    # -----------------------------------------------------
    # 4. In ký tự xuống dòng và hiển thị kết quả
    # -----------------------------------------------------
    la $a0, line_brk        # load address: Nạp địa chỉ của kí tự xuống dòng '\n' vào thanh ghi $a0.
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                 # Thực hiện syscall để in kí tự xuống dòng (tạo dòng mới trước khi hiển thị kết quả).
    
    la $a0, msg_result      # load address: Nạp địa chỉ của chuỗi 'msg_result' vào thanh ghi $a0.
    li $v0, 4               # load immediate: Mã dịch vụ 4 là 'print_string'.
    syscall                 # Thực hiện syscall để in chuỗi thông báo "Your character after upcase: ".
    
    move $a0, $t0           # move: Di chuyển ký tự đã xử lý (chữ hoa hoặc ký tự gốc) từ $t0 vào $a0.
                            # ($a0 bây giờ chứa ký tự cần in ra màn hình)
    li $v0, 11              # load immediate: Nạp giá trị 11 vào thanh ghi $v0 (Mã dịch vụ 11 là 'print_char').
    syscall                 # Thực hiện syscall để in ký tự ra màn hình.
    
    # -----------------------------------------------------
    # 5. Kết thúc chương trình
    # -----------------------------------------------------
    li $v0, 10              # load immediate: Nạp giá trị 10 vào thanh ghi $v0.
                            # (Mã dịch vụ 10 là 'exit' - thoát chương trình)
    syscall                 # Thực hiện syscall để kết thúc chương trình.