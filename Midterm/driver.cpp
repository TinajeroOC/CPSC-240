#include <stdio.h>
#include <stdlib.h>

// This function is defined in manager.asm.
extern "C" char* manager();

int main(int argc, char *argv[]) {
    printf("Welcome to Maximum authored by John Doe.\n\n");

    char* user_name = manager();

    printf("Thank you for using this software, %s.\nBye.\n"
    "A zero was returned to the operating system.\n", user_name);

    return 0;
}