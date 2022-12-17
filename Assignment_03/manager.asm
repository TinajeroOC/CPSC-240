extern printf
extern scanf
extern fgets
extern stdin
extern strlen
extern sumArray       ; Defined in sum.asm
extern inputArray     ; Defined in input_array.asm
extern displayArray   ; Defined in display_array.cpp

global manager

section .data
    string_format db "%s", 0
    three_string_format db "%s%s%s", 0
    message_1 db "Please enter your name: ", 0
    message_2 db 10, "This program will sum your array of integers.", 10, 0
    message_3 db "Enter a sequence of long integers separated by white space.", 10, 0
    message_4 db "After the last input press enter followed by Control+D: ", 10, 0
    message_5 db 10, "These number were received and placed into the array:", 10, 0
    message_6 db 10, 10, "The sum of the %ld numbers in this array is %ld.", 10, 10, 0
    message_7 db "This program will return execution to the main function.", 10, 10, 0

section .bss
    user_name resb 64
    array resq 100
    array_size resq 1
    array_sum resq 1

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
    mov rdi, string_format
    mov rsi, message_1
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
    mov rdi, three_string_format
    mov rsi, message_2
    mov rdx, message_3
    mov rcx, message_4
    call printf

    ; Call inputArray function
    mov rax, 0                      ; 0 xmm registers are used
    mov rdi, array                  ; rdi register holds array pointer
    mov rsi, 100                    ; rsi register holds array capacity
    call inputArray                 ; Call external inputArray function
    mov [array_size], rax           ; Store array size in array_size

    ; Print confirmation message
    mov rax, 0
    mov rdi, message_5
    call printf
    
    ; Call displayArray function
    mov rax, 0                      ; 0 xmm registers are used
    mov rdi, array                  ; rdi register holds array pointer
    mov rsi, [array_size]           ; rsi register holds array size
    call displayArray               ; Call external displayArray function

    ; Call sumArray function
    mov rax, 0                      ; 0 xmm registers are used
    mov rdi, array                  ; rdi register holds array pointer
    mov rsi, [array_size]           ; rsi register holds array size
    call sumArray                   ; Call external sumArray function
    mov [array_sum], rax            ; Store sumArray result in array_sum

    ; Print sum message
    mov rax, 0
    mov rdi, message_6
    mov rsi, [array_size]
    mov rdx, [array_sum]
    call printf

    ; Print outro message
    mov rax, 0
    mov rdi, message_7
    call printf

    ; Move user_name to rax for return
    mov rax, user_name

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

    ret