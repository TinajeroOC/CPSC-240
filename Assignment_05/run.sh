#!/bin/bash

# Compile Driver (driver.c, display.c, show_wall_time.c, quicksort.c) Using GCC Standard 2017
gcc -c -Wall -no-pie -m64 -std=c17 -o driver.o driver.c
gcc -c -Wall -no-pie -m64 -std=c17 -o display.o display.c
gcc -c -Wall -no-pie -m64 -std=c17 -o show_wall_time.o show_wall_time.c
gcc -c -Wall -no-pie -m64 -std=c17 -o quicksort.o quicksort.c

# Assemble ASM Files (manager.asm, random_fill_array.asm, get_frequency.asm)
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -l random_fill_array.lis -o random_fill_array.o random_fill_array.asm
nasm -f elf64 -l get_frequency.lis -o get_frequency.o get_frequency.asm

# Link Object Files Using GCC Standard 2017
gcc -m64 -no-pie -o code.out driver.o display.o show_wall_time.o quicksort.o manager.o random_fill_array.o get_frequency.o -std=c17

# Run Executable (code.out)
./code.out

# Remove Unneeded Files
rm *.o
rm *.lis
rm *.out