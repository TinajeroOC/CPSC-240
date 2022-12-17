#include <stdio.h>
#include <stdlib.h>

// This function is defined in controller.asm.
extern "C" double controller();

int main(int argc, char* argv[]) {
    printf("Welcome to the Float Validator programmed by John Doe.\n");
    printf("Mr. Doe has been working for the Longstreet Software Company for the last two years.\n\n");

    double smallest_number = controller();

    printf("The driver module received this float number %1.15f and will keep it.\n", smallest_number);
    printf("The driver module will return integer 0 to the operating system.\n");
    printf("Have a nice day. Good-bye.\n\n");

    return 0;
}