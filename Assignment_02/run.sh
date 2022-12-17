#!/bin/bash

# Compile Driver (driver.cpp) Using GCC Standard 2017
gcc -c -Wall -no-pie -m64 -std=c17 -o pythagoras.o pythagoras.c

# Assemble ASM Files (controller.asm, isfloat.asm)
nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm

# Link Object Files Using GCC Standard 2017
gcc -m64 -no-pie -o code.out pythagoras.o triangle.o -std=c17

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out