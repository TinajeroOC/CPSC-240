extern printf
extern scanf
extern atof
extern isfloat

global controller

section .data
    CONST dq -1.0
    string_format db "%s", 0
    float_format db "%1.15lf", 10, 0
    message_1 db "Please enter two float numbers. Press ENTER after each input.", 10, 10, 0
    message_2 db 10, "These numbers were entered:", 10, 0
    message_3 db 10, "An invalid input was detected. You may run this program again.", 10, 10, 0
    message_4 db 10, "The larger number is %1.15lf", 10, 0
    message_5 db 10, "The assembly module will now return execution to the driver module.", 10, 0
    message_6 db "The smaller number will be returned to the driver.", 10, 10, 0

section .bss
    ; Empty section

section .text
controller:
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

    ; Print prompt
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, string_format  ; rdi register holds first argument (%s)
    mov rsi, message_1      ; rsi register holds second argument (message_1)
    call printf             ; Call C Library printf function (printf("%s", message_1))

    ; Scan first user input
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, string_format  ; rdi register holds first argument (%s)
    sub rsp, 1024           ; Allocate 1024 bytes on the stack for user input
    mov rsi, rsp            ; rsi register holds second argument
    call scanf              ; Call C Library scanf function

    ; Validate first user input
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, rsp            ; rdi register holds first argument (user input)
    call isfloat            ; Call external isfloat function
    cmp rax, 0              ; Compare isfloat result to 0
    je inputInvalid         ; Jump to inputInvalid if result is equal to 0

    ; Convert first user input into float
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, rsp            ; rdi register holds first argument (user input)
    call atof               ; Call C Library atof function
    movsd xmm13, xmm0       ; Store atof result in xmm13
    add rsp, 1024           ; De-allocate 1024 bytes from stack

    ; Scan second user input
    mov rax, 0
    mov rdi, string_format
    sub rsp, 1024
    mov rsi, rsp
    call scanf

    ; Validate second user input
    mov rax, 0
    mov rdi, rsp
    call isfloat
    cmp rax, 0
    je inputInvalid

    ; Convert second user input into float
    mov rax, 0
    mov rdi, rsp
    call atof              ; Call C Library atof function
    movsd xmm14, xmm0      ; Store atof result in xmm14
    add rsp, 1024

    ; Print user inputs
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_2
    call printf

    mov rax, 1             ; 1 xmm register is used
    mov rdi, float_format  ; rdi register holds first argument (%1.15lf)
    movsd xmm0, xmm13      ; xmm0 register holds second argument (first input)
    call printf            ; Call C Library printf function

    mov rax, 1             ; 1 xmm register is used
    mov rdi, float_format  ; rdi register holds first argument (%1.15lf)
    movsd xmm0, xmm14      ; xmm0 register holds second argument (second input)
    call printf            ; Call C Library printf function

    ; Determine larger number
    ; The smaller number should be stored in xmm13 and the larger number should be stored in xmm14.
    ucomisd xmm13, xmm14   ; ucomisd instruction to compare xmm13 (first input) to xmm14 (second input)
    ja xmm13Larger         ; Jump if value stored in xmm13 is larger than the value stored in xmm14

continue:
    ; Print largest number
    mov rax, 1
    mov rdi, message_4
    movsd xmm0, xmm14      ; Larger number was previously stored in xmm10
    call printf

    mov rax, 0
    mov rdi, string_format
    mov rsi, message_5
    call printf

    mov rax, 0
    mov rdi, string_format
    mov rsi, message_6
    call printf

return:
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

    movsd xmm0, xmm13      ; Store smaller number in xmm0 for return
    ret

inputInvalid:
    add rsp, 1024          ; De-allocate 1024 bytes from stack

    ; Print invalid input message
    mov rax, 0
    mov rdi, string_format
    mov rsi, message_3
    call printf

    ; Return -1 to calling function
    movsd xmm13, [CONST]   ; Store value pointed to by CONST (-1.0) in xmm13
    jmp return

xmm13Larger:
    movsd xmm15, xmm13     ; Use xmm15 to temporarily store xmm13 (larger number)
    movsd xmm13, xmm14     ; Store smaller number in xmm13
    movsd xmm14, xmm15     ; Store larger number in xmm14
    jmp continue           ; Jump to continue