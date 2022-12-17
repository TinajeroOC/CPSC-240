extern printf
extern scanf
extern atof
extern fgets
extern stdin
extern strlen

global hypotenuse

section .data
    CONST dq 0.0
    string_format db "%s", 0
    float_format db "%lf", 0
    output_float_format db "%1.15lf", 10, 0
    message_1 db 10, "Please enter your last name: ", 0
    message_2 db 10, "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
    message_3 db 10, "Please enter the sides of your triangle separated by whitespace: ", 10, 0
    message_4 db 10, "Invalid Input! Enter a positive, non-zero number for both sides: ", 10, 0
    message_5 db 10, "The length of the hypotenuse is %1.15f units.", 10, 0
    message_6 db 10, "Please enjoy your triangles %s %s.", 10, 0

section .bss
    user_name resb 64
    user_title resb 64

section .text
hypotenuse:
    ; Backup General-Purpose Registers (GPR)
    push rbp
    mov rbp, rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    push rbx
    pushf

    ; Print name prompt
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_1
    call printf

    ; Scan user input
    mov rax, 0                      ; 0 xmm registers are used
    mov rdi, user_name              ; rdi register holds first argument (user_name)
    mov rsi, 64                     ; rsi register holds second argument (64 bytes)
    mov rdx, [stdin]                ; rdx register holds third argument (stdin)
    call fgets                      ; Call C Library fgets function (fgets(user_name, 64, stdin))

    ; Remove newline from user input
    mov rax, 0                      ; 0 xmm registers are used
    mov rdi, user_name              ; rdi register holds first argument (user_name)
    call strlen                     ; Call C Library strlen function (strlen(user_name))
    sub rax, 1                      ; Subtract 1 from strlen result to retrieve null character location
    mov byte [user_name + rax], 0   ; Replace newline character (\n) with null character (\0)

    ; Print title prompt
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_2
    call printf

    ; Scan user input
    mov rax, 0
    mov rdi, user_title
    mov rsi, 64
    mov rdx, [stdin]
    call fgets

    ; Remove newline from user input
    mov rax, 0
    mov rdi, user_title
    call strlen
    sub rax, 1
    mov byte [user_title + rax], 0

    ; Print triangle prompt
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_3
    call printf

    ; Scan first user input
    mov rax, 0
    mov rdi, float_format
    sub rsp, 1024
    mov rsi, rsp
    call scanf
    movsd xmm10, [rsp]              ; Store first float in xmm10
    add rsp, 1024

    ; Validate first user input
    ; Per assignment instructions, assume user has inputted a valid float
    ucomisd xmm10, [CONST]          ; Compare first user input against 0
    jbe invalidInput                ; Jump if less than or equal to 0

    ; Scan second user input
    mov rax, 0
    mov rdi, float_format
    sub rsp, 1024
    mov rsi, rsp
    call scanf
    movsd xmm11, [rsp]              ; Store second float in xmm11
    add rsp, 1024

    ; Validate second user input
    ; Per assignment instructions, assume user has inputted a valid float
    ucomisd xmm11, [CONST]          ; Compare second user input against 0
    jbe invalidInput                ; Jump if less than or equal to 0

calculate:
    ; Calculate hypotenuse
    mulsd xmm10, xmm10              ; Square first float (a^2)
    mulsd xmm11, xmm11              ; Square second float (b^2)
    addsd xmm11, xmm10              ; Add xmm10 (a^2) to xmm11 (b^2)
    sqrtsd xmm10, xmm11             ; Store square root of xmm11 (a^2 + b^2) in xmm10

    ; Print hypotenuse
    mov rax, 1
    mov rdi, message_5
    movsd xmm0, xmm10
    call printf

return:
    ; Print outro message
    mov rax, 0
    mov rdi, message_6
    mov rsi, user_title
    mov rdx, user_name
    call printf

    ; Restore General-Purpose Registers (GPR)
    popf
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop rsi
    pop rdi
    pop rbp

    movsd xmm0, xmm10               ; Store hypotenuse in xmm0 for return
    ret

invalidInput:
    ; Print invalid message
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_4
    call printf

    ; Scan first user input
    mov rax, 0
    mov rdi, float_format
    sub rsp, 1024
    mov rsi, rsp
    call scanf
    movsd xmm10, [rsp]
    add rsp, 1024

    ; Validate first user input
    ucomisd xmm10, [CONST]
    jbe invalidInput

    ; Scan second user input
    mov rax, 0
    mov rdi, float_format
    sub rsp, 1024
    mov rsi, rsp
    call scanf
    movsd xmm11, [rsp]
    add rsp, 1024

    ; Validate second user input
    ucomisd xmm11, [CONST]
    jbe invalidInput

    jmp calculate