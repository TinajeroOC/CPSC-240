global hsum

section .data
    CONST_0 dq 0.0
    CONST_1 dq 1.0
    
section .bss
    ; Empty section

section .text
hsum:
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
    mov r15, rdi                   ; Store array pointer in r15
    mov r14, rsi                   ; Store array capacity in r14
    mov r13, 0                     ; Store array index in r13

    ; Prepare for iteration
    movsd xmm11, [CONST_0]         ; Store starting sum of 0.

arrayLoop:
    ; Ensure index within array capacity
    cmp r13, r14                   ; Compare r13 (index) to r14 (capacity)
    je exitLoop                    ; Jump if index is equal to capacity

    ; Add Current Number to Sum
    movsd xmm14, [CONST_1]         ; Store 1.0 in xmm14 register
    movsd xmm15, [r15 + r13 * 8]   ; Store current array value in xmm15
    divsd xmm14, xmm15             ; Divide 1.0 by array value
    addsd xmm11, xmm14             ; Add result to sum (xmm11)

    ; Return to start of loop
    inc r13
    jmp arrayLoop

exitLoop:
    movsd xmm0, xmm11              ; Store harmonic sum (xmm11) in xmm0 for return

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