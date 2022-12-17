extern itoa     ; Defined in itoa.asm
extern atof     ; Defined in atof.asm
extern ftoa     ; Defined in ftoa.asm
extern cosine   ; Defined in cosine.asm
extern strlen   ; Defined in strlen.asm

global _start

section .data
    CONST_RAD dq 0.01745329251 

    message_1 db "Welcome to Accurate Cosines by John Doe.", 0
    len_message_1 equ $-message_1   ; Calculates # of bytes in memory between message_1 and len_message_1.

    message_2a db 10, 10, "The time is now ", 0
    len_message_2a equ $-message_2a

    message_2b db " tics.", 10, 10, 0
    len_message_2b equ $-message_2b

    message_3 db "Please enter an angle in degrees and press enter: ", 0
    len_message_3 equ $-message_3

    message_4 db 10, "You entered ", 0
    len_message_4 equ $-message_4

    message_5 db 10, "The equivalent radians is ", 0
    len_message_5 equ $-message_5

    message_6 db 10, 10, "The cosine of those degrees is ", 0
    len_message_6 equ $-message_6

    message_7 db "Have a nice day. Bye.", 10, 0
    len_message_7 equ $-message_7

section .bss
    current_time resb 100
    user_input resb 100
    radians_str resb 100
    cosine_str resb 100
    temp resb 100

section .text
; Define macro that prints a string
%macro printString 2
    mov rax, 1    ; rax register holds 1 for sys_write
    mov rdi, 1    ; rdi register holds 1 for standard output
    mov rsi, %1   ; rsi register holds address of string (arg. 1)
    mov rdx, %2   ; rdx register holds length of string (arg. 2)
    syscall       ; Call sys_write
%endmacro

; Define macro that scans a string
%macro inputString 2
    mov rax, 0    ; rax register holds 0 for sys_read
    mov rdi, 0    ; rdi register holds 0 for standard input
    mov rsi, %1   ; rsi register holds address of string (arg. 1)
    mov rdx, %2   ; rdx register holds maximum length of string (arg. 2)
    syscall       ; Call sys_read
%endmacro

_start:
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

    ; Print introduction message
    printString message_1, len_message_1

    ; Store current system time
    rdtsc                   ; Store processor timestamp in edx:eax
    shl rdx, 32             ; Shift bottom 32 bits of rdx to left
    add rdx, rax            ; Add bottom 32 bits of rax (containing system time) to bottom 32 bits of rdx

    ; Call itoa function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, rdx            ; rdi register holds integer value to convert
    mov rsi, current_time   ; rsi register holds variable to store itoa result
    call itoa               ; Call external itoa function

    ; Print time message
    printString message_2a, len_message_2a
    printString current_time, 100
    printString message_2b, len_message_2b

    ; Print prompt and scan user input
    printString message_3, len_message_3
    inputString user_input, 100

    ; Print confirmation message
    printString message_4, len_message_4
    printString user_input, 100

    ; Call strlen function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, user_input     ; rdi register holds string
    call strlen             ; Call external strlen function
    mov r15, rax            ; Store strlen result in r15
    sub r15, 1              ; Subtract 1 since strlen also counts \0

    ; Call atof function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, user_input     ; rdi register holds string
    mov rsi, r15            ; rsi register holds string length
    call atof               ; Call external atof function
    movsd xmm13, xmm0       ; Store atof result in xmm13

    ; Calculate radians (degrees * 0.01745329251)
    mulsd xmm13, [CONST_RAD]

    ; Call ftoa function
    mov rax, 1              ; 1 xmm register is used
    movsd xmm0, xmm13       ; xmm0 register holds radians 
    mov rdi, radians_str    ; rdi register holds variable to store ftoa result
    mov rsi, 100            ; rsi register holds variable capacity
    call ftoa               ; Call external ftoa function

    ; Call strlen function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, radians_str    ; rdi register holds string
    call strlen             ; Call external strlen function
    mov r14, rax            ; Store strlen result in r14

    ; Print radians message
    printString message_5, len_message_5
    printString radians_str, r14

    ; Call cosine function
    mov rax, 1              ; 1 xmm register is used
    movsd xmm0, xmm13       ; xmm0 register holds radians
    call cosine             ; Call external cosine function
    movsd xmm14, xmm0       ; Store cosine result in xmm14

    ; Call ftoa function
    mov rax, 1
    movsd xmm0, xmm14
    mov rdi, cosine_str
    mov rsi, 100
    call ftoa

    ; Call strlen function
    mov rax, 0
    mov rdi, cosine_str
    call strlen
    mov r14, rax

    ; Print cosine message
    printString message_6, len_message_6
    printString cosine_str, r14

    ; Store current system time
    rdtsc
    shl rdx, 32
    add rdx, rax

    ; Convert time to string using itoa.
    mov rax, 0
    mov rdi, rdx
    mov rsi, current_time
    call itoa

    ; Print time message
    printString message_2a, len_message_2a
    printString current_time, 100
    printString message_2b, len_message_2b

    ; Print outro message
    printString message_7, len_message_7

_exit:
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
    
    ; Exit program
    mov rax, 60             ; rax register holds 60 for sys_exit
    mov rdi, 0              ; rdi register holds 0 for error code
    syscall                 ; Call sys_exit