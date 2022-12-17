global max

section .data
    ; Empty section

section .bss
    ; Empty section

section .text
max:
    ; Backup General-Purpose Registers (GPR)
    push rbp
    mov rbp,rsp
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

    ; Set array properties
    mov r15, rdi   ; Store array pointer in r15
    mov r14, rsi   ; Store array capacity in r14
    mov r13, 0     ; Store array index in r13

    ; Prepare for array iteration
    movsd xmm15, [r15 + r13 * 8]   ; Store value at index 0 in xmm15 for initial comparison

compareLoop:
    ; Ensure index within array capacity
    cmp r13, r14   ; Compare r13 (index) to r14 (capacity)
    je exitLoop    ; Jump if index is equal to capacity

    ; Compare stored number and current array value
    movsd xmm14, [r15 + r13 * 8]   ; Temporarily store current array value in xmm14
    ucomisd xmm14, xmm15           ; Compare xmm14 (array value) to xmm15 (largest value)
    ja xmm14Larger                 ; Jump if xmm14 is above xmm15

    ; Continue array iteration
    inc r13                        ; Increment aray index
    jmp compareLoop                ; Return to start of the loop

xmm14Larger:
    movsd xmm15, xmm14             ; Store the new largest value (xmm14) in xmm15
    inc r13                        ; Increment array index
    jmp compareLoop                ; Return to start of the loop

exitLoop:
    movsd xmm0, xmm15              ; Move largest value (xmm15) to xmm0 for return 

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