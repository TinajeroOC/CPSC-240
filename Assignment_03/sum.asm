global sumArray

section .data
    ; Empty Section

section .bss
    ; Empty Section

section .text
sumArray:
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

    ; Store array properties
    mov r15, rdi   ; Store array pointer in r15
    mov r14, rsi   ; Store array capacity in r14
    mov r13, 0     ; Store array index in r13
    
    mov r12, 0     ; Store array sum in r12

sumLoop:
    ; Ensure index within array capacity
    cmp r13, r14   ; Compare r13 (index) to r14 (capacity)
    je exitLoop    ; Jump if index is equal to capacity

    ; Add element to sum
    add r12, [r15 + r13 * 8]
    inc r13

    jmp sumLoop

exitLoop:
    mov rax, r12   ; Store array sum in rax for return

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