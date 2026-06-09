.data
    # -----------------------------------------------------
    # Data Section: Strings for messages
    # -----------------------------------------------------
    msg_prompt:         .asciiz "Nhap vao mot so nguyen N: "    # Prompt to enter N
    msg_is_prime:       .asciiz " la so nguyen to\n"          # Message if prime
    msg_not_prime:      .asciiz " khong phai la so nguyen to\n" # Message if not prime
    msg_error_invalid:  .asciiz "Loi: Vui long nhap so nguyen duong.\n" # Error for non-positive N
    line_brk:           .asciiz "\n"                            # Newline character

.text
.globl main                                   # Declare 'main' as global entry point

main:
    # -----------------------------------------------------
    # 1. Input Integer N
    # -----------------------------------------------------
    la $a0, msg_prompt    # Load address of prompt message
    li $v0, 4             # Syscall code for print_string
    syscall               # Print the prompt

    li $v0, 5             # Syscall code for read_int
    syscall               # Read integer N
    move $s0, $v0         # Store N in $s0 (N is the number to check)

    # -----------------------------------------------------
    # 2. Handle Special Cases for Primality
    # -----------------------------------------------------

    # If N <= 1, not prime
    ble $s0, 1, NotPrime  # If N <= 1, branch to NotPrime

    # If N == 2, prime
    li $t0, 2             # Load 2 into $t0
    beq $s0, $t0, IsPrime # If N == 2, branch to IsPrime

    # If N == 3, prime
    li $t0, 3             # Load 3 into $t0
    beq $s0, $t0, IsPrime # If N == 3, branch to IsPrime

    # If N is divisible by 2 (N % 2 == 0), not prime (already handled N=2)
    li $t0, 2             # Load 2 into $t0 (divisor)
    div $s0, $t0          # Divide N by 2
    mfhi $t1              # Get remainder (N % 2) into $t1
    beqz $t1, NotPrime    # If remainder is 0, N is even (and > 2), so NotPrime

    # If N is divisible by 3 (N % 3 == 0), not prime (already handled N=3)
    li $t0, 3             # Load 3 into $t0 (divisor)
    div $s0, $t0          # Divide N by 3
    mfhi $t1              # Get remainder (N % 3) into $t1
    beqz $t1, NotPrime    # If remainder is 0, N is a multiple of 3 (and > 3), so NotPrime

    # -----------------------------------------------------
    # 3. Loop for Divisors (Optimized: Check 6k +/- 1)
    # Loop variables:
    #   $t3 = i (current divisor, starts at 5)
    #   $s2 = N (original number to check, kept in $s0)
    # -----------------------------------------------------
    li $t3, 5             # Initialize i = 5

LoopCheck:
    # Check if i*i > N (or i*i overflows). We only need to check up to sqrt(N).
    # Instead of sqrt(N), we check if i*i <= N.
    # So, if i*i > N, then it's prime.
    mult $t3, $t3         # Calculate i*i (result in hi:lo)
    mflo $t4              # Get lo (i*i) into $t4
    mfhi $t5              # Get hi (potential overflow for i*i) into $t5

    # If i*i overflows (hi != 0), it means i is too large, so N must be prime.
    bne $t5, $zero, IsPrime

    # Now compare i*i ($t4) with N ($s0)
    bgt $t4, $s0, IsPrime # If i*i > N, then N is prime (no divisors found yet)

    # Check N % i == 0
    div $s0, $t3          # Divide N by i
    mfhi $t1              # Get remainder (N % i) into $t1
    beqz $t1, NotPrime    # If remainder is 0, N is divisible by i, so NotPrime

    # Check N % (i+2) == 0
    addi $t3, $t3, 2      # i = i + 2 (This is the i+2 term)
    div $s0, $t3          # Divide N by (i+2)
    mfhi $t1              # Get remainder (N % (i+2)) into $t1
    beqz $t1, NotPrime    # If remainder is 0, N is divisible by (i+2), so NotPrime

    # Increment i by another 4 to make it i+6 for the next iteration (i.e. 5 -> 11, 7 -> 13)
    # Since we already added 2, we need to add 4 more to get to i + 6
    addi $t3, $t3, 4      # i = i + 4 (now i is ready for the next iteration of 6k+5)

    j LoopCheck           # Continue loop

IsPrime:
    # -----------------------------------------------------
    # 4. Output: N is Prime
    # -----------------------------------------------------
    move $a0, $s0         # Move N to $a0 for printing
    li $v0, 1             # Syscall code for print_int
    syscall               # Print N

    la $a0, msg_is_prime  # Load address of " is prime" message
    li $v0, 4             # Syscall code for print_string
    syscall               # Print message

    j ExitProgram         # Jump to exit

NotPrime:
    # -----------------------------------------------------
    # 5. Output: N is Not Prime
    # -----------------------------------------------------
    move $a0, $s0         # Move N to $a0 for printing
    li $v0, 1             # Syscall code for print_int
    syscall               # Print N

    la $a0, msg_not_prime # Load address of " is not prime" message
    li $v0, 4             # Syscall code for print_string
    syscall               # Print message

    j ExitProgram         # Jump to exit

ExitProgram:
    # -----------------------------------------------------
    # 6. Exit Program
    # -----------------------------------------------------
    li $v0, 10            # Syscall code for exit
    syscall               # Terminate the program