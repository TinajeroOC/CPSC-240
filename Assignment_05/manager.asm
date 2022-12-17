extern scanf
extern printf
extern atoi
extern fillArray           ; Defined in random_fill_array.asm
extern display             ; Defined in display.c
extern quicksort           ; Defined in quicksort.c
extern get_frequency       ; Defined in get_frequency.asm

global manager

section .data
    CONST dq 1000000000.0
    long_format db "%ld", 0
    message_1 db "Please input the count of number of data items to be placed into the array (maximum 10 million): ", 0
    message_2 db 10, "The array has been filled with non-deterministic random 64-bit float numbers.", 10, 10, 0
    message_3 db "Here are 10 numbers of the array at the beginning.", 10, 0
    message_4 db "Here are 10 numbers starting at the middle of the array.", 10, 0
    message_5 db "Here are the last 10 numbers of the array.", 10, 0
    message_6 db "The time is now %ld tics. Sorting will begin.", 10, 10, 0
    message_7 db "The time is now %ld tics. Sorting has finished.", 10, 10, 0
    message_8 db "Total sort time is %ld tics which equals %lf seconds.", 10, 10, 0
    message_9 db "The benchmark time will be returned to the driver.", 10, 10, 0

section .bss
    array resq 10000000
    array_size resq 1
    index_2 resq 1
    index_3 resq 1

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
    call fillArray          ; Call external fillArray

    ; Print confirmation message
    mov rax, 0
    mov rdi, message_2
    call printf

    ; Calculate index for middle of array [(array_size / 2) - 5]
    mov rax, [array_size]
    mov rbx, 2
    div rbx
    sub rax, 5
    mov [index_2], rax

    ; Calculate index for end of array [(array_size) - 10]
    mov rax, [array_size]
    sub rax, 10
    mov [index_3], rax

    ; Determine output length
    mov r13, 10             ; Store 10 in r13 for comparison
    cmp [array_size], r13   ; Compare array size to 10
    jl overrideIndices      ; Jump if array size is less than 10

benchmark:
    ; Call printArray subroutine
    push qword 0
    call printArray
    pop rax

    ; Benchmark sorting time
    ; Store starting sort time in r14
    rdtsc                   ; Store processor timestamp in edx:eax
    shl rdx, 32             ; Shift bottom 32 bits of rdx to left
    add rdx, rax            ; Add bottom 32 bits of rax (containing system time) to bottom 32 bits of rdx
    mov r14, rdx            ; Store result in r14

    ; Print time message
    mov rax, 0
    mov rdi, message_6
    mov rsi, r14
    call printf

    ; Call quicksort function
    mov rax, 0
    mov rdi, array
    mov rsi, 0
    mov rdx, [array_size]
    call quicksort

    ; Store ending sort time in r15
    rdtsc                   ; Store processor timestamp in edx:eax
    shl rdx, 32             ; Shift bottom 32 bits of rdx to left
    add rdx, rax            ; Add bottom 32 bits of rax (containing system time) to bottom 32 bits of rdx
    mov r15, rdx            ; Store result in r15

    ; Print time message
    mov rax, 0
    mov rdi, message_7
    mov rsi, r15
    call printf

    ; Calculate total sort time
    sub r15, r14            ; Subtract ending time (r15) by starting time (r14)
    cvtsi2sd xmm11, r15     ; Convert integer to double and store in xmm11
    call get_frequency      ; Call external get_frequency function
    divsd xmm11, xmm0       ; Divide tic difference (xmm11) by get_frequency result (xmm0)
    divsd xmm11, [CONST]    ; Divide nanoseocnds (xmm11) by 1,000,000,000 to get seconds

    ; Print sorting time
    mov rax, 1
    mov rdi, message_8
    mov rsi, r15
    movsd xmm0, xmm11
    call printf

    ; Call printArray subroutine
    push qword 0
    call printArray
    pop rax

return:
    ; Print outro message
    mov rax, 0
    mov rdi, message_9
    call printf

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

    movsd xmm0, xmm11       ; Store sorting time (seconds) in xmm0 for return
    ret

printArray:
    ; Print 1st array message
    mov rax, 0
    mov rdi, message_3
    call printf

    ; Call display function
    mov rax, 0              ; 0 xmm registers are used
    mov rdi, array          ; rdi register holds array pointer
    mov rsi, 0              ; rsi register holds array index
    mov rdx, r13            ; rdx register holds output length
    call display            ; Call external display function

    ; Print 2nd array message
    mov rax, 0
    mov rdi, message_4
    call printf

    ; Call display function
    mov rax, 0
    mov rdi, array
    mov rsi, [index_2]
    mov rdx, r13
    call display

    ; Print 3rd array message
    mov rax, 0
    mov rdi, message_5
    call printf

    ; Call display function
    mov rax, 0
    mov rdi, array
    mov rsi, [index_3]
    mov rdx, r13
    call display

    ret

overrideIndices:
    mov r13, [array_size]
    mov qword [index_2], 0
    mov qword [index_3], 0
    jmp benchmark