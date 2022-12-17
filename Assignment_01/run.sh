#!/bin/bash

# Compile Driver (driver.cpp) Using GCC Standard 2017
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp 

# Assemble ASM Files (controller.asm, isfloat.asm)
nasm -f elf64 -l isfloat.lis -o isfloat.o isfloat.asm
nasm -f elf64 -l controller.lis -o controller.o controller.asm

# Link Object Files Using GCC Standard 2017
g++ -m64 -no-pie -o code.out driver.o controller.o isfloat.o -std=c++17

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out