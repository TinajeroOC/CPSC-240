#!/bin/bash

# Assemble ASM Files (main.asm, itoa.asm, atof.asm, ftoa.asm, strlen.asm, cosine.asm)
nasm -f elf64 -l main.lis -o main.o main.asm
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm
nasm -f elf64 -l atof.lis -o atof.o atof.asm
nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm
nasm -f elf64 -l strlen.lis -o strlen.o strlen.asm
nasm -f elf64 -l cosine.lis -o cosine.o cosine.asm

# Link Object Files Using GNU Linker (elf_X86_64)
ld -m elf_x86_64 -no-pie -o code.out main.o itoa.o atof.o ftoa.o strlen.o cosine.o

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out