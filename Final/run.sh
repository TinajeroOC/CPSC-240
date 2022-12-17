#!/bin/bash

# Compile C Files (driver.cpp, display_array.cpp) Using GCC Standard 2017
gcc -c -Wall -no-pie -m64 -std=c17 -o driver.o driver.c
gcc -c -Wall -no-pie -m64 -std=c17 -o display_array.o display_array.c

# Assemble ASM Files (supervisor.asm, random_fill_array.asm, hsum.asm)
nasm -f elf64 -l supervisor.lis -o supervisor.o supervisor.asm
nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm
nasm -f elf64 -l hsum.lis -o hsum.o hsum.asm

# Link Object Files Using the GCC Standard 2017
gcc -m64 -no-pie -o code.out driver.o supervisor.o display_array.o random_fill_array.o hsum.o -std=c17

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out