extern scanf
extern printf
extern fillArray
extern displayArray
extern hsum

global supervisor

section .data
    long_format db "%ld", 0
    message_1 db "Please input the count of number of data items to be placed into the array with (maximum 1 million): ", 0
    message_2 db 10, "The array has been filled with non-deterministic random 64-bit float numbers.", 10, 10, 0
    message_3 db "Here are the values in the array", 10, 0
    message_4 db "The harmonic sum is %0.10e", 10, 10, 0
    message_5 db "The harmonic mean is %0.10e", 10, 10, 0
    message_6 db "The supervisor will return the mean to the caller.", 10, 10, 0

section .bss
    array resq 1000000
    array_size resq 1
    sum resq 1
    mean resq 1

section .text
supervisor:
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

    ; Print array prompt
    mov rax, 0
    mov rdi, message_1
    call printf

    ; Scan user input
    mov rax, 0
    mov rdi, long_format
    mov rsi, array_size
    call scanf

    ; Call fillArray function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, array          ; rdi register holds array pointer
    mov rsi, [array_size]   ; rsi register holds array size
    call fillArray          ; Call external fillArray function

    ; Print confirmation message
    mov rax, 0
    mov rdi, message_2
    call printf

printArray:
    ; Print array message
    mov rax, 0
    mov rdi, message_3
    call printf

    ; Call displayArray function
    mov rax, 0             ; 0 xmm registers are used 
    mov rdi, array         ; rdi register holds array pointer
    mov rsi, [array_size]  ; rsi register holds array size
    call displayArray      ; Call external displayArray function

printHarmonic:
    ; Call hsum function
    mov rax, 0             ; 0 xmm registers are used
    mov rdi, array         ; rdi register holds array pointer
    mov rsi, [array_size]  ; rsi register holds array size
    call hsum              ; Calls external hsum function
    movsd [sum], xmm0      ; Store hsum result in sum

    ; Print harmonic sum
    mov rax, 1
    mov rdi, message_4
    call printf

    ; Calculate hmean (count / hsum)
    cvtsi2sd xmm11, [array_size]    ; Move array size to xmm11
    divsd xmm11, [sum]              ; Divide xmm11 by hsum
    movsd [mean], xmm11             ; Move hmean (xmm11) to xmm0

    ; Print harmonic mean
    mov rax, 1
    movsd xmm0, [mean]
    mov rdi, message_5
    call printf

return:
    ; Print return message
    mov rax, 0
    mov rdi, message_6
    call printf

    movsd xmm0, [mean]      ; Store harmonic mean in xmm0 for return

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