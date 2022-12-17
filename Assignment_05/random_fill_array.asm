extern isnan

global fillArray

section .data
    ; Empty section

section .bss
    ; Empty section

section .text
fillArray:
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
    mov r15, rdi         ; Store array pointer in r15
    mov r14, rsi         ; Store array capacity in r14
    mov r13, 0           ; Store array index in r13

arrayLoop:
    ; Ensure index within array capacity
    cmp r13, r14         ; Compare r13 (index) to r14 (capacity)
    je exitLoop          ; Jump if index is equal to capacity

    ; Generate random number
    mov rax, 0           ; Clear rax register
    rdrand rax           ; rdrand instruction to generate random 64-bit number
    cvtsi2sd xmm0, rax   ; Convert 64-bit number into a double in xmm0

    ; Validate random number
    mov rax, 1           ; 1 xmm register is used
    call isnan           ; Call C Library isnan function
    cmp rax, 0           ; Compare isnan result to 0 (valid number)
    jne arrayLoop        ; Jump if isnan result is not equal to 0 (NaN)

    ; Store random number in array
    movsd [r15 + r13 * 8], xmm0

    ; Return to start of loop
    inc r13
    jmp arrayLoop

exitLoop:
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