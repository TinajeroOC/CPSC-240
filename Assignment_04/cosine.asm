global cosine

section .data
    CONST_2 dq 2.0
    CONST_1 dq 1.0
    CONST_0 dq 0.0
    CONST_1_NEG dq -1.0

section .bss
    ; Empty section

section .text
cosine:
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

    ; Store parameter
    movsd xmm10, xmm0

    ; Cosine Formula (McLaurin Series)
    ;            x^2
    ; -1 * ----------------
    ;      (2n+2) * (2n+1)

    ; Prepare for iteration
    movsd xmm15, [CONST_0]   ; Store default sum of 0.0 in xmm15
    movsd xmm11, [CONST_1]   ; Store starting value of mclaurin series in xmm11
    mov r14, 10000000        ; Store iteration limit in r14
    mov r13, 0               ; Store iteration counter in r13

    mulsd xmm10, xmm10       ; Calculate x^2 ahead of time

cosineLoop:
    ; Ensure iteration (n) is within limit (10,000,000 iterations)
    cmp r13, r14             ; Compare r13 (iteration) to r14 (iteration limit)
    je exitLoop              ; Jump if iteration is equal to limit

    ; Add current term to sum
    addsd xmm15, xmm11

    ; Calculate (2n+2)
    cvtsi2sd xmm12, r13      ; Convert iteration counter to floating point in xmm12
    mulsd xmm12, [CONST_2]   ; Multiply counter (n) by 2
    addsd xmm12, [CONST_2]   ; Add 1.0 to product (2n)

    ; Calculate (2n+1)
    cvtsi2sd xmm13, r13
    mulsd xmm13, [CONST_2]
    addsd xmm13, [CONST_1]

    ; Multiply (2n+2) and (2n+1)
    mulsd xmm12, xmm13       ; Re-use xmm12 register to hold product of (2n+2)*(2n+1)

    ; Divide x^2 by [(2n+2)*(2n+1)]
    movsd xmm14, xmm10       ; Store a copy of x^2 in xmm14
    divsd xmm14, xmm12       ; Store the quotient of x^2 and [(2n+2)*(2n+1)] in xmm14

    ; Multiply [x^2 / (2n+2)(2n+1)] by -1
    mulsd xmm14, [CONST_1_NEG]

    ; Multiply recurrence relation (xmm11) by current term (xmm14)
    mulsd xmm11, xmm14

    ; Iterate to start of loop
    inc r13
    jmp cosineLoop

exitLoop:
    movsd xmm0, xmm15        ; Store cosine to xmm0 for return

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