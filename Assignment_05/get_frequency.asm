; // ****************************************************************************************************************************
; // Program name: "Harmonic Sum". This program asks the user for a value n and finds its harmonic sum.
; // Copyright (C) 2022 David Harboyan.
; //
; // Harmonic Sum is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
; // version 3 as published by the Free Software Foundation.
; // Property Tax Assessor is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; // warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
; // A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.
; // ****************************************************************************************************************************
; //
; // Author information
; //  Author name: David Harboyan
; //  Author email: harboyandavid@csu.fullerton.edu
; //
; // Program information
; //  Program name: Harmonic Sum
; //  Programming languages: Three modules in X86, one modules in C++, one module in c, and one in bash
; //  Date program began: 2022 Apr 10
; //  Date of last update: 2022 Apr 25
; //  Date of reorganization of comments: 2022 Apr 25
; //  Files in this program: manager.asm, compute_sum.asm, get_frequency.asm, harmonic.cpp, output_one_line.c, r.sh
; //  Status: Finished.  The program was tested extensively with no errors in Tuffix 2020 Edition.
; //
; // Purpose: Finds the processor's frequency.
; //
; // This file
; //   File name: get_frequency.asm
; //   Language: x86.
; //   Max page width: 132 columns
; //   Assemble: nasm -f elf64 -l get_frequency.lis -o get_frequency.o get_frequency.asm
; //   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o output.out manager.o harmonic.o compute_sum.o get_frequency.o output_one_line.o
; //
; // ===== Begin code area ================================================================================================

extern printf
extern atof

global get_frequency

section .text
get_frequency:
	; 15 pushes
	push rbp
	mov rbp, rsp
	push rbx
	push rcx
	push rdx
	push rdi
	push rsi
	push r8
	push r9
	push r10
	push r11
	push r12
	push r13
	push r14
	push r15
	pushf

	mov r14, 0x80000003 ; this value is passed to cpuid to get information about the processor
	xor r15, r15  ; set loop control variable for section_loop equal to 0
	xor r11, r11  ; set the counter/flag for character collection equal to 0

section_loop:
	xor r13, r13  ; zero the loop control variable for register loop

	mov rax, r14  ; get processor brand and information
	cpuid         ; cpu identification
	inc r14       ; increment the value passed to get the next section of the string

	push rdx      ; 4th set of chars
	push rcx      ; 3rd set of chars
	push rbx      ; 2nd set of chars
	push rax      ; 1st set of chars


register_loop:
	xor r12, r12  ; zero the loop control variable for char loop
	pop rbx       ; get new string of 4 chars

char_loop:
	mov rdx, rbx  ; move string of 4 chars to rdx
	and rdx, 0xFF ; gets the first char in string
	shr rbx, 0x8  ; shifts string to get next char in next iteration

	cmp rdx, 64   ; 64 is the char value for the @ sign
	jne counter   ; leaves r11, does not set flag
	mov r11, 1    ; flag and counter to start storing chars in r10

counter:
	cmp r11, 1    ; checks if flag is true
	jl body       ; skips incrementing if flag is false
	inc r11       ; increments counter if flag is true

body:
	cmp r11, 4    ; counter is greater than 4
	jl loop_conditions
	cmp r11, 7    ; counter is less than 7
	jg loop_conditions

	shr r10, 0x8  ; r10 acts as a queue for characters
	shl rdx, 0x18 ; moves new character from rdx into free space for r10
	or r10, rdx   ; combine the registers

loop_conditions:
	inc r12
	cmp r12, 4 ; char loop
	jne char_loop

	inc r13
	cmp r13, 4 ; register loop
	jne register_loop

	inc r15
	cmp r15, 2 ; string loop
	jne section_loop

exit:
	push r10
	xor rax, rax
	mov rdi, rsp
	call atof  ; converts the string representing the clock speed to a float
	pop r10    ; the value to be returned is already in xmm0, and will be returned

	; 15 pops
	popf
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	pop rsi
	pop rdi
	pop rdx
	pop rcx
	pop rbx
	pop rbp
	ret  ; return xmm0