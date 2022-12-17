#include <stdio.h>
#include <stdlib.h>

// This function is defined in manager.asm
extern char* manager();

int main(int argc, char* argv[]) {
    printf("Welcome to Arrays of Integers.\n"
    "Brought to you by John Doe.\n\n");

    char* user_name = manager();

    printf("I hope you liked your arrays %s.\n"
    "Main will return 0 to the operating system. Bye.\n", user_name);

    return 0;
}