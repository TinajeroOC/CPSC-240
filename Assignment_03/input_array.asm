extern scanf

global inputArray

section .data
    long_format db "%ld", 0

section .bss
    ; Empty section

section .text
inputArray:
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

    push qword 0

    ; Store array properties
    mov r15, rdi   ; Store array pointer in r15
    mov r14, rsi   ; Store array capacity in r14
    mov r13, 0     ; Store array index in r13

inputLoop:
    ; Ensure index within array capacity
    cmp r13, r14   ; Compare r13 (index) to r14 (capacity)
    je exitLoop    ; Jump if index is equal to capacity

    ; Scan user input
    mov rax, 0
    mov rdi, long_format
    push qword 0
    mov rsi, rsp
    call scanf

    ; Check user input for program exit (ctrl+d)
    ; scanf returns an integer (32 bits): -1 = EOF | 0 = No fields assigned | # = Number of fields assigned
    cmp eax, -1    ; Compare scanf result (lower 32 bits of rax) to EOF
    pop r12        ; Retrieve user input from stack and store in r12
    je exitLoop    ; Jump if scanf result equal to EOF

    ; Store user input into array
    mov [r15 + r13 * 8], r12   ; Calculate memory address and store user input
    inc r13                    ; Increment array index
    jmp inputLoop              ; Return to start of the loop

exitLoop:
    pop rax
    mov rax, r13   ; Store array size in rax for return

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