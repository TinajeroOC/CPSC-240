#!/bin/bash

# Compile Driver (driver.cpp) Using GCC Standard 2017
g++ -c -Wall -no-pie -m64 -std=c++17 -o driver.o driver.cpp 

# Compile CPP Files (show_data.cpp) Using GCC Standard 2017
g++ -c -Wall -no-pie -m64 -std=c++17 -o show_data.o show_data.cpp 

# Assemble ASM Files (manager.asm, get_data.asm, max.asm)
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -l get_data.lis -o get_data.o get_data.asm
nasm -f elf64 -l max.lis -o max.o max.asm

# Link Object Files Using the GCC Standard 2017
g++ -m64 -no-pie -o code.out driver.o manager.o get_data.o show_data.o max.o -std=c++17

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out