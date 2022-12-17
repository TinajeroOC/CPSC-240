#!/bin/bash

# Compile Driver (main.c) Using GCC Standard 2017
gcc -g -c -Wall -no-pie -m64 -std=c17 -o main.o main.c

# Compile C++ Files (display_array.cpp) Using GCC Standard 2017
g++ -g -c -Wall -no-pie -m64 -std=c++17 -o display_array.o display_array.cpp

# Assemble ASM Files (manager.asm, input_array.asm, sum.asm)
nasm -f elf64 -l manager.lis -o manager.o manager.asm -g -gdwarf
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm -g -gdwarf
nasm -f elf64 -l sum.lis -o sum.o sum.asm -g -gdwarf

# Link Object Files Using GCC Standard 2017
gcc -g -m64 -no-pie -o code.out main.o manager.o input_array.o sum.o display_array.o -std=c17

# Run Executable in GDB Mode (code.out)
gdb ./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out