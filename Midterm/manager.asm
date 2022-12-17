extern printf
extern fgets
extern stdin
extern strlen
extern getData     ; Defined in get_data.asm
extern showArray   ; Defined in show_data.cpp
extern max         ; Defined in max.asm

global manager

section .data
    array_capacity equ 6
    string_format db "%s", 0
    two_string_format db "%s%s", 0
    message_1 db "Please enter your name: ", 0
    message_2 db 10, "Please enter floating point numbers separated by ws to be stored in a array of size 6 cells.", 10, 0
    message_3 db "After the last input press <enter> followed by <control+d>.", 10, 0
    message_4 db 10, "These number are stored in the array", 10, 0
    message_5 db 10, "The largest value in the array is %.10lf.", 10, 10, 0

section .bss
    user_name resb 64
    array resq array_capacity
    array_size resq 1
    number resq 1

section .text
manager:
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
    mov rdi, message_1
    call printf

    ; Scan user input
    mov rax, 0
    mov rdi, user_name
    mov rsi, 64
    mov rdx, [stdin]
    call fgets

    ; Remove newline from user input
    mov rax, 0
    mov rdi, user_name
    call strlen
    sub rax, 1
    mov byte [user_name + rax], 0

    ; Print array prompt
    mov rax, 0
    mov rdi, two_string_format
    mov rsi, message_2
    mov rdx, message_3
    call printf

    ; Call getData function
    mov rax, 0                ; 0 xmm registers are used
    mov rdi, array            ; rdi holds first argument (array pointer)
    mov rsi, array_capacity   ; rsi holds second argument (array capacity)
    call getData              ; Call external getData function
    mov [array_size], rax     ; Store getData result in array_size

    ; Print confirmation message
    mov rax, 0
    mov rdi, message_4
    call printf

    ; Call showArray function
    mov rax, 0                ; 0 xmm registers are used
    mov rdi, array            ; rdi holds first argument (array pointer)
    mov rsi, [array_size]     ; rsi holds second argument (array size)
    call showArray            ; Call external showArray function

    ; Call max function
    mov rax, 0                ; 0 xmm registers are used
    mov rdi, array            ; rdi holds first argument (array pointer)
    mov rsi, [array_size]     ; rsi holds second argument (array size)
    call max                  ; Call external max function
    movsd [number], xmm0      ; Store max result in xmm15

    ; Print largest value in array
    mov rax, 1                ; 1 xmm register is used
    mov rdi, message_5        ; rdi holds first argument (message)
    movsd xmm0, [number]      ; rsi holds second argument (largest value)
    call printf               ; Call C Library printf function (printf(message_5, number))

    ; Prepare user_name for return
    mov rax, user_name

    ; Restore  General-Purpose Registers (GPR)
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

    ret