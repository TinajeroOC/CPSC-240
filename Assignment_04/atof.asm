; Source Link: https://stackoverflow.com/a/4392789/5041327
; Creative Commons Public License (CC BY-SA 3.0)
; More Information https://creativecommons.org/licenses/by-sa/3.0/

global atof

section .text
atof:
        xorps xmm0, xmm0
        divsd xmm0, xmm0
        test  rsi, rsi
        jz    .007
        add   rsi, rdi
        cmp   byte [rdi], 45
        movsd xmm2, [rel .LC1]
        jnz   .001
        movsd xmm2, [rel .LC0]
        inc   rdi
.001:
        movsd xmm3, [rel .LC3]
        xor   edx, edx
        xorps xmm1, xmm1
.002:
        cmp   rdi, rsi
        jnc   .006
        movsx eax, byte [rdi]
        cmp   al, 46
        jnz   .003
        test  edx, edx
        jnz   .007
        mov   edx, 1
        jmp   .005
.003:
        sub   eax, 48
        cmp   eax, 9
        ja    .007
        test  edx, edx
        jz    .004
        divsd xmm2, xmm3
.004:
        mulsd    xmm1, xmm3
        cvtsi2sd xmm4, eax
        addsd    xmm1, xmm4
.005:
        inc rdi
        jmp .002
.006:
        mulsd  xmm1, xmm2
        movaps xmm0, xmm1
.007:
        ret 

section .data

section .bss

section .rodata

.LC0:
 dq 0BFF0000000000000H

.LC1:
 dq 3FF0000000000000H

.LC3:
 dq 4024000000000000H

section .note
 db 04H, 00H, 00H, 00H, 20H, 00H, 00H, 00H
 db 05H, 00H, 00H, 00H, 47H, 4EH, 55H, 00H
 db 02H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H
 db 01H, 00H, 00H, 00H, 00H, 00H, 00H, 00H
 db 01H, 00H, 01H, 0C0H, 04H, 00H, 00H, 00H
 db 09H, 00H, 00H, 00H, 00H, 00H, 00H, 00H